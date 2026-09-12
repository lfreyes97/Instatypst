// Campaña Warfield — cita 01
// Fuente: ¿Qué es el calvinismo?
// Plantilla: cita-canvas + blockquote-hero — paleta "granates" + tipografía "brutalista"
// Compilar: typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "granates", tipografia: "brutalista")

#let contenido = blockquote-hero(
  [El calvinismo es simplemente la religión en su pureza.],
  autor: "B.B. Warfield",
  fuente: "¿Qué es el calvinismo?",
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
