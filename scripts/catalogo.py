#!/usr/bin/env python3
"""
catalogo.py — renderiza cada preset de examples/presets/*.typ a miniaturas
PNG y compila docs/catalogo.typ, la página de catálogo que las muestra en
cuadrícula con el nombre del preset y la llamada que lo genera.

Uso (desde cualquier carpeta; sin dependencias fuera de la biblioteca
estándar, solo `typst` en el PATH):
    python3 scripts/catalogo.py                 # todo: miniaturas + PDF
    python3 scripts/catalogo.py --png           # además, el catálogo en PNG
    python3 scripts/catalogo.py bauhaus folio   # rehace solo esas miniaturas
    python3 scripts/catalogo.py --sin-miniaturas  # solo recompila el catálogo

Salidas (todas generadas, ignoradas por git: se rehacen con este comando):
    docs/catalogo/miniaturas/<preset>/NN.png   una por página del preset
    docs/catalogo/catalogo.json                el índice que lee catalogo.typ
    docs/catalogo/catalogo.pdf                 el catálogo
    docs/catalogo/catalogo-NN.png              (con --png) sus páginas

Las miniaturas se renderizan a --ppi (20 por omisión: una cuadrada de
1080 pt sale de 300 px, unos 40 kB). El formato que se rotula bajo cada
miniatura se deduce del tamaño del PNG, redondeado a la decena de pt más
cercana (todos los formatos del paquete son múltiplos de 10).
"""

import argparse
import json
import os
import shutil
import struct
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
PRESETS = RAIZ / "examples" / "presets"
CATALOGO_TYP = RAIZ / "docs" / "catalogo.typ"
SALIDA = RAIZ / "docs" / "catalogo"
MINIATURAS = SALIDA / "miniaturas"
FUENTES = RAIZ / "Fonts"


def typst(*args):
    cmd = ["typst", "compile", "--root", str(RAIZ), "--font-path", str(FUENTES), *map(str, args)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, r.stderr.strip()


def tamano_png(ruta):
    """(ancho, alto) en px, leídos de la cabecera IHDR."""
    with open(ruta, "rb") as f:
        cabecera = f.read(24)
    return struct.unpack(">II", cabecera[16:24])


def a_pt(px, ppi):
    pt = px * 72 / ppi
    decena = round(pt / 10) * 10
    return decena if abs(pt - decena) <= 72 / ppi else round(pt)


def descripcion(fuente):
    """Las líneas de comentario de cabecera, hasta `// Compilar:`."""
    lineas = []
    for linea in fuente.read_text(encoding="utf-8").splitlines():
        if not linea.startswith("//"):
            break
        texto = linea[2:].strip()
        if texto.startswith("Compilar:"):
            break
        lineas.append(texto)
    # párrafos separados por líneas de comentario vacías
    parrafos, actual = [], []
    for t in lineas:
        if t:
            actual.append(t)
        elif actual:
            parrafos.append(" ".join(actual))
            actual = []
    if actual:
        parrafos.append(" ".join(actual))
    return parrafos


def renderizar(fuente, ppi):
    nombre = fuente.stem
    destino = MINIATURAS / nombre
    shutil.rmtree(destino, ignore_errors=True)
    destino.mkdir(parents=True)
    codigo, err = typst("--ppi", ppi, fuente, destino / "{0p}.png")
    return nombre, codigo, err


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("presets", nargs="*", help="nombres de preset a rehacer (por omisión, todos)")
    ap.add_argument("--ppi", type=int, default=20, help="resolución de las miniaturas (20)")
    ap.add_argument("--png", action="store_true", help="exporta también el catálogo en PNG")
    ap.add_argument("--png-ppi", type=int, default=96, help="resolución del catálogo en PNG (96)")
    ap.add_argument("--sin-miniaturas", action="store_true", help="no renderiza, solo recompila el catálogo")
    args = ap.parse_args()

    if shutil.which("typst") is None:
        sys.exit("catalogo.py: no encuentro `typst` en el PATH (prueba `nix develop`).")

    todos = sorted(PRESETS.glob("*.typ"))
    pedidos = set(args.presets)
    desconocidos = pedidos - {f.stem for f in todos}
    if desconocidos:
        sys.exit("catalogo.py: presets desconocidos: " + ", ".join(sorted(desconocidos)))

    SALIDA.mkdir(parents=True, exist_ok=True)
    indice_previo = SALIDA / "catalogo.json"
    ppi_previo = None
    if indice_previo.exists():
        ppi_previo = json.loads(indice_previo.read_text(encoding="utf-8")).get("ppi")

    fallos = []
    if not args.sin_miniaturas:
        a_rehacer = [f for f in todos if not pedidos or f.stem in pedidos]
        if pedidos and ppi_previo not in (None, args.ppi):
            sys.exit(f"catalogo.py: las miniaturas que hay están a {ppi_previo} ppi; "
                     f"rehazlas todas (sin nombres) para cambiar a {args.ppi}.")
        with ThreadPoolExecutor(max_workers=max(1, (os.cpu_count() or 2) // 2)) as pool:
            for nombre, codigo, err in pool.map(lambda f: renderizar(f, args.ppi), a_rehacer):
                estado = "ok" if codigo == 0 else "FALLÓ"
                print(f"  {estado:5} {nombre}", flush=True)
                if codigo != 0:
                    fallos.append(nombre)
                    print("        " + err.replace("\n", "\n        "), file=sys.stderr)
    ppi = args.ppi if not args.sin_miniaturas else (ppi_previo or args.ppi)

    # Índice: un registro por preset, con sus páginas en orden.
    llamadas = CATALOGO_TYP.read_text(encoding="utf-8")
    indice = []
    for f in todos:
        pngs = sorted((MINIATURAS / f.stem).glob("*.png"))
        paginas = []
        for png in pngs:
            w, h = tamano_png(png)
            paginas.append({
                "png": png.relative_to(CATALOGO_TYP.parent).as_posix(),
                "ancho": a_pt(w, ppi), "alto": a_pt(h, ppi),
            })
        if not paginas:
            print(f"  aviso: {f.stem} no tiene miniaturas", file=sys.stderr)
        if f'"{f.stem}":' not in llamadas:
            print(f"  aviso: {f.stem} no tiene llamada en docs/catalogo.typ (diccionario `llamadas`)",
                  file=sys.stderr)
        indice.append({
            "nombre": f.stem,
            "archivo": f.relative_to(RAIZ).as_posix(),
            "descripcion": descripcion(f),
            "paginas": paginas,
        })
    indice_previo.write_text(json.dumps({"ppi": ppi, "presets": indice}, ensure_ascii=False, indent=1),
                             encoding="utf-8")

    codigo, err = typst(CATALOGO_TYP, SALIDA / "catalogo.pdf")
    if codigo != 0:
        sys.exit("catalogo.py: no compila docs/catalogo.typ:\n" + err)
    print(f"  → {(SALIDA / 'catalogo.pdf').relative_to(RAIZ)}")
    if args.png:
        for viejo in SALIDA.glob("catalogo-*.png"):
            viejo.unlink()
        codigo, err = typst("--ppi", args.png_ppi, CATALOGO_TYP, SALIDA / "catalogo-{0p}.png")
        if codigo != 0:
            sys.exit("catalogo.py: no exporta el catálogo a PNG:\n" + err)
        print(f"  → {(SALIDA / 'catalogo-NN.png').relative_to(RAIZ)}")
    if fallos:
        sys.exit("catalogo.py: fallaron " + ", ".join(fallos))


if __name__ == "__main__":
    main()
