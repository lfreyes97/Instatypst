// Campaña Warfield — cita 17
// Fuente: Apologética
// Plantilla: cita-canvas + blockquote-bar (acento) — paleta "grises" + tipografía "geometrico-moderno"
// Compilar: typst compile --root . --font-path Fonts campana/17-racional-creer-en-cristo.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "grises", tipografia: "geometrico-moderno")

#let marca-h = tema.colors.primary.transparentize(70%)
#let contenido = blockquote-bar(
  [Creemos en Cristo porque es #highlight(fill: marca-h)[racional] creer en él, no aunque sea #highlight(fill: marca-h)[irracional].],
  autor: "B.B. Warfield",
  fuente: "Apologética",
  variante: "acento",
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
