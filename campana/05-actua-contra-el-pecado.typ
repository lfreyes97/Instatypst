// Campaña Warfield — cita 05
// Fuente: La incapacidad y la exigencia de la fe
// Plantilla: cita-canvas + blockquote-hero — paleta "noche-azul" + tipografía "editorial-expresivo"
// Compilar: typst compile --root . --font-path Fonts campana/05-actua-contra-el-pecado.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "noche-azul", tipografia: "editorial-expresivo")
#let cita = blockquote-hero.with(theme: tema, color: tema.colors.secondary)

#warfield-canvas(
  cita(
    [Actúa contra el pecado, en el nombre de Cristo, como si tuvieras fuerza, y hallarás que la tienes.],
    autor: "B.B. Warfield",
    fuente: "La incapacidad y la exigencia de la fe",
  ),
  tema,
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
