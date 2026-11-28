#!/usr/bin/env bash
# Compila todas las tarjetas de la campaña a PNG.
# Uso: ./examples-v1/trabajos/campana/compile-all.sh  (o bash examples-v1/trabajos/campana/compile-all.sh)
set -euo pipefail

cd "$(dirname "$0")/../.."

# Solo las láminas numeradas: _comun.typ y logo.typ son módulos, no tarjetas.
for f in examples-v1/trabajos/campana/[0-9]*.typ; do
  base=$(basename "$f" .typ)
  typst compile --root . --font-path Fonts "$f" "examples-v1/trabajos/campana/$base.png"
  echo "OK examples-v1/trabajos/campana/$base.png"
done
