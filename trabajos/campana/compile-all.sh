#!/usr/bin/env bash
# Compila todas las tarjetas de la campaña a PNG.
# Uso: ./trabajos/campana/compile-all.sh  (o bash trabajos/campana/compile-all.sh)
set -euo pipefail

cd "$(dirname "$0")/../.."

# Solo las láminas numeradas: _comun.typ y logo.typ son módulos, no tarjetas.
for f in trabajos/campana/[0-9]*.typ; do
  base=$(basename "$f" .typ)
  typst compile --root . --font-path Fonts "$f" "trabajos/campana/$base.png"
  echo "OK trabajos/campana/$base.png"
done
