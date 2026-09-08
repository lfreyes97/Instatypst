// Campaña Warfield — cita 02
// Fuente: El calvinismo: significado y usos del término
// Plantilla: cita-canvas + blockquote-pull — paleta "granates" + tipografía "editorial-clasico"
// Compilar: typst compile --root . --font-path Fonts campana/02-calvinista-ha-visto-a-dios.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "granates", tipografia: "editorial-clasico")
#let cita = blockquote-pull.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita(
    [El calvinista es el hombre que ha visto a Dios.],
    autor: "B.B. Warfield",
    fuente: "El calvinismo: significado y usos del término",
  ),
  tema,
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
