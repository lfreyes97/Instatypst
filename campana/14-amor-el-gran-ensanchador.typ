// Campaña Warfield — cita 14
// Fuente: La persona y la obra del Espíritu Santo (Fortalecimiento espiritual)
// Plantilla: cita-canvas + blockquote-poetry — paleta "bosque" + tipografía "manuscrito-calido"
// Compilar: typst compile --root . --font-path Fonts campana/14-amor-el-gran-ensanchador.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "bosque", tipografia: "manuscrito-calido")
#let cita = blockquote-poetry.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita(
    [El amor es el gran ensanchador. Es el amor lo que estira el intelecto.],
    autor: [B.B. Warfield — Fortalecimiento espiritual],
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.dark,
  blob-color: white,
  footer-color: white,
)
