// Campaña Warfield — cita 04
// Fuente: La teología de Calvino
// Plantilla: cita-canvas + blockquote-bar (grande) — paleta "granates" + tipografía "editorial-clasico"
// Compilar: typst compile --root . --font-path Fonts campana/04-calvinista-ve-a-dios.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "granates", tipografia: "editorial-clasico")
#let cita = blockquote-bar.with(theme: tema, color: tema.colors.primary, variante: "grande")

#warfield-canvas(
  cita(
    [El calvinista es el hombre que ve a Dios detrás de todos los fenómenos, y en todo lo que ocurre reconoce la mano de Dios, obrando su voluntad.],
    autor: "B.B. Warfield",
    fuente: "La teología de Calvino",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
