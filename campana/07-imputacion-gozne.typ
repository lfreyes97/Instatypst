// Campaña Warfield — cita 07
// Fuente: La imputación
// Plantilla: cita-canvas + blockquote-card — paleta "grises" + tipografía "sans-versatil"
// Compilar: typst compile --root . --font-path Fonts campana/07-imputacion-gozne.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "grises", tipografia: "sans-versatil")
#let cita = blockquote-card.with(theme: tema, color: tema.colors.primary)

// blockquote-card pone TODO el cuerpo en itálica — la interpolación
// editorial "[La imputación]" (no es de Warfield, la agregamos para que la
// cita tenga sujeto fuera de contexto) se lee mejor en redonda, como se
// hace en tipografía impresa con corchetes editoriales dentro de una cita
// en cursiva. #text(style: "normal") aquí es un override on-the-fly local
// — solo cambia esas dos palabras, el resto del body sigue itálica.
#warfield-canvas(
  cita(
    [#text(style: "normal")[\[La imputación\]] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza, la satisfacción de Cristo, la justificación por la fe— y la guardiana de su pureza.],
    autor: "B.B. Warfield",
    fuente: "La imputación",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.dark,
  blob-color: white,
  footer-color: white,
)
