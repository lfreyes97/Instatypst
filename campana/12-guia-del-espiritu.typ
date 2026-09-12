// Campaña Warfield — cita 12
// Fuente: La persona y la obra del Espíritu Santo (La guía del Espíritu)
// Plantilla: cita-canvas + blockquote-bar (default) — paleta "noche-azul" + tipografía "editorial-clasico"
// Compilar: typst compile --root . --font-path Fonts campana/12-guia-del-espiritu.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "noche-azul", tipografia: "editorial-clasico")

#let contenido = blockquote-bar(
  [La guía espiritual misma no es una guía de nosotros mismos por nosotros mismos, sino una guía de nosotros por el Espíritu Santo.],
  autor: "B.B. Warfield",
  fuente: "La guía del Espíritu",
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
