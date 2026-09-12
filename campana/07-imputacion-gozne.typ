// Campaña Warfield — cita 07
// Fuente: La imputación
// Plantilla: cita-canvas + blockquote-card — paleta "grises" + tipografía "sans-versatil"
// Compilar: typst compile --root . --font-path Fonts campana/07-imputacion-gozne.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "grises", tipografia: "sans-versatil")

#let contenido = blockquote-card(
  [\[La imputación\] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza, la satisfacción de Cristo, la justificación por la fe— y la guardiana de su pureza.],
  autor: "B.B. Warfield",
  fuente: "La imputación",
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
