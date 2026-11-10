#!/usr/bin/env python3
"""Fotografía una lámina sobre la mesa: renderiza una página de un .typ a PNG y
la pone, como lámina impresa, sobre una hoja de `mesa`.

    python3 scripts/foto-de-lamina.py examples/presets/bauhaus.typ 2 salida.png
    python3 scripts/foto-de-lamina.py demo.typ 1 foto.png --distancia 400 --angulo 1.2

Argumentos: demo.typ, número de página (desde 1), PNG de salida. La orientación
de la hoja (vertical, apaisada o cuadrada) sale de la proporción de la lámina.
Una lámina de preset es un `page()` y no se puede incrustar en otra página, por
eso pasa por PNG. Compila con --root en la raíz del repositorio y Fonts/.
"""
import argparse
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent


def dimensiones_png(ruta: Path) -> tuple[int, int]:
    with open(ruta, "rb") as f:
        cab = f.read(24)
    return struct.unpack(">II", cab[16:24])


def typst(*args: str) -> None:
    r = subprocess.run(["typst", "compile", "--root", str(RAIZ), "--font-path", str(RAIZ / "Fonts"), *args],
                       capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit(r.stderr)


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("demo", type=Path)
    p.add_argument("pagina", type=int)
    p.add_argument("salida", type=Path)
    p.add_argument("--ppi", type=int, default=110, help="resolución de la lámina (por defecto 110)")
    p.add_argument("--salida-ppi", type=int, default=150, help="resolución de la foto (por defecto 150)")
    p.add_argument("--distancia", type=float, default=250, help="mm entre la cámara y la mesa")
    p.add_argument("--focal", type=float, default=50, help="mm")
    p.add_argument("--angulo", type=float, default=0.55, help="grados")
    p.add_argument("--papel", default="a5", help="a3, a4, a5, a6 o letter")
    p.add_argument("--aire", type=float, default=7, help="mm entre la lámina y el borde de la hoja")
    a = p.parse_args()

    demo = a.demo.resolve()
    with tempfile.TemporaryDirectory(dir=RAIZ, prefix=".mesa-") as tmp:
        tmp = Path(tmp)
        png = tmp / "lamina.png"
        typst(str(demo), str(png), "--pages", str(a.pagina), "--ppi", str(a.ppi))
        w, h = dimensiones_png(png)
        forma = "cuadrada" if abs(w - h) / max(w, h) < 0.04 else ("apaisada" if w > h else "vertical")
        fuente = tmp / "foto.typ"
        fuente.write_text(f'''#import "/src/lib.typ": mesa
#mesa.hoja-{forma}(
  paper-size: "{a.papel}", distance: {a.distancia}mm, focal-length: {a.focal}mm,
  angle: {a.angulo}deg, inset: (x: {a.aire}mm, y: {a.aire}mm),
)[#align(center + horizon, mesa.lamina(image("lamina.png"), ancho: 100%))]
''', encoding="utf-8")
        typst(str(fuente), str(a.salida.resolve()), "--ppi", str(a.salida_ppi))
    print(f"listo: {a.salida} ({forma}, lámina {w}×{h})")


if __name__ == "__main__":
    main()
