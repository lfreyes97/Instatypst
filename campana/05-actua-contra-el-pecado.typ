// Campaña Warfield — cita 05
// Fuente: La incapacidad y la exigencia de la fe
// Plantilla: cita-canvas + blockquote-hero — paleta "noche-azul" + tipografía "editorial-expresivo"
// Compilar: typst compile --root . --font-path Fonts campana/05-actua-contra-el-pecado.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "noche-azul", tipografia: "editorial-expresivo")

#let contenido = blockquote-hero(
  [Actúa contra el pecado, en el nombre de Cristo, como si tuvieras fuerza, y hallarás que la tienes.],
  autor: "B.B. Warfield",
  fuente: "La incapacidad y la exigencia de la fe",
  color: tema.colors.secondary,
  theme: tema,
)

#cita-canvas(
  contenido,
  "presuposicionalismo.com",
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
  theme: tema,
)
