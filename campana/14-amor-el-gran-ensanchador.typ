// Campaña Warfield — cita 14
// Fuente: La persona y la obra del Espíritu Santo (Fortalecimiento espiritual)
// Plantilla: cita-canvas + blockquote-poetry — paleta "bosque" + tipografía "manuscrito-calido"
// Compilar: typst compile --root . --font-path Fonts campana/14-amor-el-gran-ensanchador.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "bosque", tipografia: "manuscrito-calido")

#let contenido = blockquote-poetry(
  [El amor es el gran ensanchador. Es el amor lo que estira el intelecto.],
  autor: [B.B. Warfield — Fortalecimiento espiritual],
  color: tema.colors.primary,
  theme: tema,
)

#cita-canvas(
  contenido,
  "presuposicionalismo.com",
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
  theme: tema,
)
