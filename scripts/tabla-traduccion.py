#!/usr/bin/env python3
"""Genera la tabla de traducción engine_v1 -> contrato semántico de un preset.

Uso:  python3 -I scripts/tabla-traduccion.py suizo [--out docs/traduccion-suizo.md]

Fuentes:
  schema/firmas.json   nombres de los parámetros, bloques piece/v1 y `entradas`
  src/<archivo>        la firma de la función, de donde salen los valores por defecto
  core/nombres.toml    bloque -> nombre semántico (la única parte hecha a mano)
"""
import argparse, json, pathlib, re, sys, tomllib

RAIZ = pathlib.Path(__file__).resolve().parent.parent


def firma_typ(fuente: str, nombre: str):
    """Devuelve [(parametro, defecto|None)] de `#let nombre(...)`, en orden."""
    m = re.search(r"#let\s+" + re.escape(nombre) + r"\s*\(", fuente)
    if not m:
        return None
    i, prof, en_cadena, trozos, actual = m.end(), 1, False, [], []
    while i < len(fuente) and prof > 0:
        c = fuente[i]
        if en_cadena:
            actual.append(c)
            if c == "\\":
                actual.append(fuente[i + 1]); i += 1
            elif c == '"':
                en_cadena = False
        elif c == '"':
            en_cadena = True; actual.append(c)
        elif fuente.startswith("//", i):          # comentario hasta fin de línea
            while i < len(fuente) and fuente[i] != "\n":
                i += 1
            continue
        elif c in "([{":
            prof += 1; actual.append(c)
        elif c in ")]}":
            prof -= 1
            if prof > 0:
                actual.append(c)
        elif c == "," and prof == 1:
            trozos.append("".join(actual)); actual = []
        else:
            actual.append(c)
        i += 1
    trozos.append("".join(actual))
    salida = []
    for t in (x.strip() for x in trozos):
        if not t or t.startswith(".."):
            continue
        nombre_p, _, defecto = t.partition(":")
        salida.append((nombre_p.strip(), defecto.strip() or None))
    return salida


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("preset")
    ap.add_argument("--out")
    a = ap.parse_args()

    firmas = json.loads((RAIZ / "schema/firmas.json").read_text())["styles"]
    if a.preset not in firmas:
        sys.exit(f"preset desconocido: {a.preset} (hay {len(firmas)}: {', '.join(sorted(firmas))})")
    f = firmas[a.preset]
    nombres = tomllib.loads((RAIZ / "core/nombres.toml").read_text())
    por_bloque, por_param = nombres["bloques"], nombres["parametros"]

    # parámetro v1 -> (bloque piece/v1, nombre semántico)
    via_bloque = {}
    for bloque, destino in f.get("entradas", {}).items():
        if isinstance(destino, dict):
            for campo, param in destino.items():
                via_bloque[param] = (f"{bloque}.{campo}", por_bloque.get(f"{bloque}.{campo}"))
        else:
            via_bloque[destino] = (bloque, por_bloque.get(bloque))

    canonico = {v: k for k, v in f.get("campo", {}).items()}  # parametro -> nombre canónico

    archivo = RAIZ / "src" / f["archivo"]
    sig = firma_typ(archivo.read_text(), a.preset)
    defectos = dict(sig) if sig else {}
    if sig is None:
        print(f"aviso: no encontré `#let {a.preset}(` en {archivo}; sin defectos", file=sys.stderr)

    orden = list(f["pos"]) + list(f["options"])
    filas, n_map = [], 0
    for i, p in enumerate(orden, 1):
        bloque, sem = via_bloque.get(p, ("—", None))
        if sem is None:
            sem = por_param.get(p)
        pos = " (pos.)" if p in f["pos"] else ""
        d = "obligatorio" if p in f["pos"] and defectos.get(p) is None else (defectos.get(p) or "—")
        estado = "mapeado" if sem else "sin mapeo"
        n_map += bool(sem)
        filas.append(f"| {i} | `{p}`{pos} | `{d}` | {('`'+sem+'`') if sem else '—'} | "
                     f"{('`'+bloque+'`') if bloque != '—' else '—'} | "
                     f"{('`'+canonico[p]+'`') if p in canonico else '—'} | {estado} |")

    # coherencia: parámetros de la firma Typst que el JSON no lista
    extra = [p for p, _ in (sig or []) if p not in orden]
    cabecera = [
        f"# Tabla de traducción de `{a.preset}`",
        "",
        f"Generada por `scripts/tabla-traduccion.py` desde `schema/firmas.json`, `src/{f['archivo']}` y "
        f"`core/nombres.toml`. No editar a mano: cambia el origen y regenera.",
        "",
        f"{len(orden)} parámetros, {n_map} con nombre semántico, {len(orden) - n_map} sin mapeo.",
        "",
        "| # | engine_v1 | defecto | semántico | bloque `piece/v1` | campo canónico | estado |",
        "|---|---|---|---|---|---|---|",
    ]
    pie = []
    if extra:
        pie = ["", f"Aviso: la firma Typst tiene parámetros que el JSON no lista: {', '.join(extra)}."]
    texto = "\n".join(cabecera + filas + pie) + "\n"
    if a.out:
        (RAIZ / a.out).write_text(texto)
        print(f"escrito {a.out}")
    else:
        print(texto, end="")


if __name__ == "__main__":
    main()
