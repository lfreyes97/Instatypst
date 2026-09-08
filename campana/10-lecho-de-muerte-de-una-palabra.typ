// Campaña Warfield — cita 10
// Fuente: "Redentor" y "redención"
// Plantilla: cita-canvas + blockquote-poetry — paleta "vintage" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/10-lecho-de-muerte-de-una-palabra.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "vintage", tipografia: "revival-vintage")
#let cita = blockquote-poetry.with(theme: tema, color: tema.colors.secondary)

#warfield-canvas(
  cita(
    [Estamos asistiendo al lecho de muerte de una palabra. Y es triste presenciar la muerte de cualquier cosa valiosa.],
    autor: [B.B. Warfield — "Redentor" y "redención"],
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.dark,
  blob-color: white,
  footer-color: white,
)
