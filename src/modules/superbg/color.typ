// ─────────────────────────────────────────────────────────────
//  superbg / color.typ — contraste WCAG 2.x, con los nombres de superbg
//
//  Antes era una copia propia de la luminancia (con el umbral 0,03928 de la
//  errata de WCAG 2.0). Ahora es un adaptador sobre el módulo `color`, que es la
//  única implementación del contraste: superbg declara esa dependencia.
// ─────────────────────────────────────────────────────────────

#import "/src/modules/color/palettes/contrast.typ": contrast

#let contraste(a, b) = contrast(a, b)

#let es-aa(a, b, nivel: "normal") = {
  contraste(a, b) >= if nivel == "grande" { 3 } else { 4.5 }
}

#let texto-sobre(fondo, claro: white, oscuro: rgb("#1c1917")) = {
  if contraste(fondo, claro) >= contraste(fondo, oscuro) { claro } else { oscuro }
}
