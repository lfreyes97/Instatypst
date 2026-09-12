// Campaña Warfield — cita 03
// Fuente: El calvinismo hoy
// Plantilla: cita-canvas + blockquote-editorial — paleta "oceano" + tipografía "sans-versatil"
// Compilar: typst compile --root . --font-path Fonts campana/03-esperanza-del-mundo.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "oceano", tipografia: "sans-versatil")

#let contenido = blockquote-editorial(
  [El calvinismo emerge así a nuestra vista como nada más ni nada menos que la esperanza del mundo.],
  autor: "B.B. Warfield",
  fuente: "El calvinismo hoy",
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
