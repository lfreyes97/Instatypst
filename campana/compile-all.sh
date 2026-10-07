#!/usr/bin/env bash
# Compila todas las tarjetas de la campaña a PNG.
# Uso: ./campana/compile-all.sh  (o bash campana/compile-all.sh)
set -euo pipefail

cd "$(dirname "$0")/.."

for f in campana/*.typ; do
  base=$(basename "$f" .typ)
  [ "$base" = "_comun" ] && continue # no es una tarjeta, es el sistema compartido
  typst compile --root . --font-path Fonts "$f" "campana/$base.png"
  echo "OK campana/$base.png"
done
