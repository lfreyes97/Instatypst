// Campaña Warfield — cita 13
// Fuente: La persona y la obra del Espíritu Santo (El Espíritu de fe)
// Plantilla: cita-canvas + blockquote-hero — paleta "mediterraneo" + tipografía "editorial-expresivo"
// Compilar: typst compile --root . --font-path Fonts campana/13-cree-este-evangelio.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "mediterraneo", tipografia: "editorial-expresivo")

#let marca-h = tema.colors.accent.transparentize(60%)
#let contenido = blockquote-hero(
  [Cree este Evangelio, y podrás y lo predicarás. Digan los hombres lo que quieran —déjalos herir, ridiculizar, perseguir, matar— #highlight(fill: marca-h)[cree este Evangelio] y lo predicarás.],
  autor: "B.B. Warfield",
  fuente: "El Espíritu de fe",
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
