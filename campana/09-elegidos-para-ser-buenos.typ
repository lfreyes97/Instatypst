// Campaña Warfield — cita 09
// Fuente: La elección
// Plantilla: cita-canvas + blockquote-hero — paleta "noche-azul" + tipografía "brutalista"
// Compilar: typst compile --root . --font-path Fonts campana/09-elegidos-para-ser-buenos.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "noche-azul", tipografia: "brutalista")

#let marca-h = tema.colors.primary.transparentize(65%)
#let contenido = blockquote-hero(
  [No somos escogidos porque seamos #highlight(fill: marca-h)[buenos]; somos escogidos para que podamos ser #highlight(fill: marca-h)[buenos].],
  autor: "B.B. Warfield",
  fuente: "La elección",
  color: tema.colors.primary,
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
