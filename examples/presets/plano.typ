// Demo de carteles.plano() — grid blueprint: azul de heliografía, retícula
// de dos pesos, marco con marcas de borde, cota y cajetín. Ver src/plano.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/plano.typ
#import "../../src/lib.typ": carteles, sizes

#let marca = text(font: "Inter", size: 18pt, weight: 700, tracking: 0.12em, fill: rgb("#e8f0ff"))[TU MARCA]

// retrato: la lámina por omisión
#carteles.plano(
  [El amor es el gran ensanchador.],
  autor: [B. B. Warfield], obra: [Fortalecimiento espiritual], marca: marca,
)

// cuadrado, cota con rótulo y palabra en acento
#carteles.plano(
  [La fe no se opone a la razón: la ensancha.],
  formato: sizes.instagram, autor: [B. B. Warfield], obra: [Fe y razón],
  cota: [ANCHO LIBRE], destacar: ("ensancha",), acento: rgb("#ffb877"), marca: marca,
)

// apaisado, sin cajetín ni marcas, plano claro (blueprint invertido)
#carteles.plano(
  [Todo es gracia.],
  formato: sizes.twitter, fondo: rgb("#f3f1e8"), linea: rgb("#1d3b8b"),
  cajetin: false, marcas: false, cota: none,
)
