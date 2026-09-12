// Campaña Warfield — cita 10
// Fuente: "Redentor" y "redención"
// Plantilla: cita-canvas + blockquote-poetry — paleta "vintage" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/10-lecho-de-muerte-de-una-palabra.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "vintage", tipografia: "revival-vintage")

#let contenido = blockquote-poetry(
  [Estamos asistiendo al lecho de muerte de una palabra. Y es triste presenciar la muerte de cualquier cosa valiosa.],
  autor: [B.B. Warfield — "Redentor" y "redención"],
  color: tema.colors.secondary,
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
