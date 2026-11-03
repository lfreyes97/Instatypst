#!/usr/bin/env bash
# Genera las figuras a lápiz como PDF vectorial (y PNG con transparencia) listas para LaTeX.
# Uso, desde la raíz del repo:  bash trabajos/libro-ilustrado/export-figuras.sh
set -euo pipefail
out=salida/figuras-lapiz
mkdir -p "$out"
typst compile --root . --font-path Fonts trabajos/libro-ilustrado/figuras-export.typ "$out/fig-{p}.svg"
typst compile --root . --font-path Fonts trabajos/libro-ilustrado/figuras-export.typ "$out/fig-{p}.png" --ppi 400
names=(finca memorial bandera)
for i in 1 2 3; do
  n=${names[$((i-1))]}
  rsvg-convert -f pdf -o "$out/$n.pdf" "$out/fig-$i.svg"
  mv "$out/fig-$i.svg" "$out/$n.svg"
  mv "$out/fig-$i.png" "$out/$n.png"
done
ls -la "$out"
