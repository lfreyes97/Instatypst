#!/bin/sh
# Prueba del contrato generado: un caso válido compila; cada inválido falla con su mensaje.
D=$(dirname "$(readlink -f "$0")")
T="$D/.tmp"; mkdir -p "$T"
caso() {
  printf '#import "../swiss-contrato.typ": *\n#let a = %s\n#a\n' "$1" > "$T/c.typ"
  msg=$(typst compile --root "$D" "$T/c.typ" "$T/c.pdf" 2>&1 | grep -m1 "error:" | sed 's/.*error: //')
  if [ -z "$msg" ]; then echo "VÁLIDO   $1"; else echo "rechaza  $msg"; fi
}
caso 'swiss-args(artboard: "story", theme: (accent: red), brand: (c, l) => [x], repeat: 3)'
caso 'swiss-args(artboard: "instagram")'
caso 'swiss-args(artboard: (size: (1080, 0), medium: "screen"))'
caso 'swiss-args(theme: (acento: red))'
caso 'swiss-args(variant: "fullgrid")'
caso 'swiss-args(repeat: 0)'
caso 'swiss-args(formato: (1080, 1350))'
caso 'swiss-check-parts((statement: [a]))'
rm -rf "$T"
