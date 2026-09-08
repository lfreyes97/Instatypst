// Campaña Warfield — cita 17
// Fuente: Apologética
// Plantilla: cita-canvas + blockquote-bar (acento) — paleta "grises" + tipografía "geometrico-moderno"
// Compilar: typst compile --root . --font-path Fonts campana/17-racional-creer-en-cristo.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "grises", tipografia: "geometrico-moderno")
#let cita = blockquote-bar.with(theme: tema, color: tema.colors.primary, variante: "acento")
#let marca-h = tema.colors.primary.transparentize(70%)

// blockquote-bar deja el cuerpo en peso regular — "racional"/"irracional"
// son el contraste exacto de la frase, así que además del highlight de
// color reciben #text(weight: 700) on-the-fly para que el contraste se
// sienta también en el trazo, no solo en el fondo.
#warfield-canvas(
  cita(
    [Creemos en Cristo porque es #highlight(fill: marca-h)[#text(weight: 700)[racional]] creer en él, no aunque sea #highlight(fill: marca-h)[#text(weight: 700)[irracional]].],
    autor: "B.B. Warfield",
    fuente: "Apologética",
  ),
  tema,
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
