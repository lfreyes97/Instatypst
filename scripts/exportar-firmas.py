#!/usr/bin/env python3
"""Exporta carteles.firmas (+ el catálogo de bloques) a schema/firmas.json.

La fuente única es src/carteles/firmas.typ. Este JSON es su copia legible por
máquina para quien no puede importar el paquete (la CLI typst-rrss lo vendora).

  scripts/exportar-firmas.py            escribe schema/firmas.json
  scripts/exportar-firmas.py --check    falla si el JSON no está al día
"""
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
DESTINO = RAIZ / "schema" / "firmas.json"


def _nombrados(src: str, nombre: str) -> list[str]:
    """Parámetros con nombre (con valor por defecto) de `#let nombre(...)`."""
    m = re.search(r"#let " + re.escape(nombre) + r"\(", src)
    if not m:
        raise SystemExit(f"no encuentro `#let {nombre}(` en el código")
    i, prof, cuerpo = m.end(), 1, ""
    while prof and i < len(src):
        c = src[i]
        prof += c in "([{"
        prof -= c in ")]}"
        if prof:
            cuerpo += c
        i += 1
    trozos, prof, cur = [], 0, ""
    for c in cuerpo:
        prof += c in "([{"
        prof -= c in ")]}"
        if c == "," and prof == 0:
            trozos.append(cur)
            cur = ""
        else:
            cur += c
    trozos.append(cur)
    out = []
    for t in trozos:
        t = re.sub(r"//[^\n]*", "", t).strip()
        mm = re.match(r"([a-zñ0-9_\-]+)\s*:", t)
        if mm:
            out.append(mm.group(1))
    return out


def leer() -> dict:
    cuerpo = (
        f'#import "{RAIZ}/src/lib.typ": carteles\n'
        "#metadata((firmas: carteles.firmas, bloques: carteles.bloques-catalogo, padres: carteles.bloques-padre)) <f>\n"
    )
    with tempfile.TemporaryDirectory() as t:
        f = Path(t) / "export.typ"
        f.write_text(cuerpo, encoding="utf-8")
        r = subprocess.run(
            ["typst", "eval", "--root", "/", "query(<f>).first().value",
             "--in", str(f), "--format", "json"],
            capture_output=True, text=True,
        )
    if r.returncode != 0:
        sys.exit(r.stderr)
    datos = json.loads(r.stdout)
    for nombre, e in datos["firmas"].items():
        src = (RAIZ / "src" / e["archivo"]).read_text(encoding="utf-8")
        e["options"] = _nombrados(src, nombre)
    return {
        "schema": "instatypst-firmas/v1",
        "contract": "instatypst-piece/v1",
        "blocks": datos["bloques"],
        "block_parents": datos["padres"],
        "styles": datos["firmas"],
    }


def main() -> None:
    texto = json.dumps(leer(), ensure_ascii=False, indent=2, sort_keys=False) + "\n"
    if "--check" in sys.argv:
        if not DESTINO.exists() or DESTINO.read_text(encoding="utf-8") != texto:
            sys.exit("schema/firmas.json no está al día: ejecuta scripts/exportar-firmas.py")
        print("schema/firmas.json al día")
        return
    DESTINO.write_text(texto, encoding="utf-8")
    print(f"escrito {DESTINO.relative_to(RAIZ)} ({len(texto)} bytes)")


if __name__ == "__main__":
    main()
