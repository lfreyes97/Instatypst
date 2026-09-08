// Campaña Warfield — cita 03
// Fuente: El calvinismo hoy
// Plantilla: cita-canvas + blockquote-editorial — paleta "oceano" + tipografía "sans-versatil"
// Compilar: typst compile --root . --font-path Fonts campana/03-esperanza-del-mundo.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "oceano", tipografia: "sans-versatil")
#let cita = blockquote-editorial.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita(
    [El calvinismo emerge así a nuestra vista como nada más ni nada menos que la esperanza del mundo.],
    autor: "B.B. Warfield",
    fuente: "El calvinismo hoy",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.dark,
  blob-color: white,
  footer-color: white,
)
