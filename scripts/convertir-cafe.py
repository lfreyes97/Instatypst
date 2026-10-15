#!/usr/bin/env python3
"""Convierte las manchas de café de `coffeestains` (CTAN) de TikZ a SVG.

El paquete LaTeX coffeestains (Hanno Rein, mantenido por Patrick
Bideault; dominio público) dibuja cuatro manchas reales, A–D, como
\\fill[coffeeN] con curvas de Bézier en pt. Este script lee el .sty y
escribe src/superbg/assets/cafe/{A,B,C,D}.svg: un <path> por \\fill, con su color,
y el eje y invertido (TikZ crece hacia arriba, SVG hacia abajo).

Uso: python3 scripts/convertir-cafe.py ruta/a/coffeestains.sty
(el .sty sale de https://ctan.org/pkg/coffeestains)
"""
import re
import sys
from pathlib import Path

NUM = r"(-?[\d.]+)pt"
PUNTO = re.compile(r"\(\s*" + NUM + r"\s*,\s*" + NUM + r"\s*\)")


def main(sty: Path, destino: Path) -> None:
    texto = sty.read_text(encoding="utf-8")
    colores = {
        n: tuple(float(v) for v in rgb.split(","))
        for n, rgb in re.findall(r"\\definecolor\{(coffee\d+)\}\{rgb\}\{([^}]*)\}", texto)
    }
    destino.mkdir(parents=True, exist_ok=True)
    for letra in "ABCD":
        cuerpo = re.search(r"\\newcommand\{\\stain" + letra + r"\}\[2\]\{(.*?)\\end\{tikzpicture\}", texto, re.S).group(1)
        caminos, xs, ys = [], [], []
        for color, camino in re.findall(r"\\fill\[(coffee\d+)\]\s*(.*?);", cuerpo, re.S):
            d = []
            # tokens: punto inicial, "--" punto, ".. controls p and p .. p"
            for tok in re.finditer(r"(--|\.\.\s*controls)?\s*(\([^)]*\)(?:\s*and\s*\([^)]*\))?\s*(?:\.\.\s*\([^)]*\))?)", camino):
                op, resto = tok.group(1), tok.group(2)
                pts = [(float(x), -float(y)) for x, y in PUNTO.findall(resto)]
                if not pts:
                    continue
                for x, y in pts:
                    xs.append(x)
                    ys.append(y)
                coords = " ".join(f"{x:.2f} {y:.2f}" for x, y in pts)
                if op is None and not d:
                    d.append("M" + coords)
                elif op and op.startswith(".."):
                    d.append("C" + coords)
                else:
                    d.append("L" + coords)
            r, g, b = colores[color]
            hexa = "#{:02x}{:02x}{:02x}".format(round(r * 255), round(g * 255), round(b * 255))
            caminos.append(f"<path fill='{hexa}' d='{''.join(d)}Z'/>")
        x0, y0 = min(xs), min(ys)
        w, h = max(xs) - x0, max(ys) - y0
        svg = (
            f"<svg xmlns='http://www.w3.org/2000/svg' viewBox='{x0:.2f} {y0:.2f} {w:.2f} {h:.2f}'>"
            "<!-- coffeestains (CTAN), Hanno Rein / Patrick Bideault, dominio público -->"
            + "".join(caminos)
            + "</svg>\n"
        )
        (destino / f"{letra}.svg").write_text(svg, encoding="utf-8")
        print(f"{letra}: {len(caminos)} caminos, {w:.0f}×{h:.0f} pt")


if __name__ == "__main__":
    main(Path(sys.argv[1]), Path(__file__).resolve().parent.parent / "src/superbg/assets/cafe")
