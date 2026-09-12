// Campaña Warfield — cita 18
// Fuente: El sobrenaturalismo cristiano
// Plantilla: cita-canvas + blockquote-editorial — paleta "granates" + tipografía "lectura-editorial"
// Compilar: typst compile --root . --font-path Fonts campana/18-hecho-sobrenatural.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "granates", tipografia: "lectura-editorial")

#let marca-h = tema.colors.accent.transparentize(65%)
#let contenido = blockquote-editorial(
  [El Dios del cristiano es, sin duda, el Dios de la naturaleza y el Dios en la naturaleza: pero antes y sobre todo esto, es el Dios sobre la naturaleza —el #highlight(fill: marca-h)[Hecho Sobrenatural].],
  autor: "B.B. Warfield",
  fuente: "El sobrenaturalismo cristiano",
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
