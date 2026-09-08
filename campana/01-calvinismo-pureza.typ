// Campaña Warfield — cita 01
// Fuente: ¿Qué es el calvinismo?
// Plantilla: cita-canvas + blockquote-hero — paleta "granates" + tipografía "brutalista"
// Compilar: typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "granates", tipografia: "brutalista")
#let cita = blockquote-hero.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita(
    [El calvinismo es simplemente la religión en su pureza.],
    autor: "B.B. Warfield",
    fuente: "¿Qué es el calvinismo?",
  ),
  tema,
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
