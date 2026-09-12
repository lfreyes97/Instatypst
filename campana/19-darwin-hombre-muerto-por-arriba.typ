// Campaña Warfield — cita 19
// Fuente: La vida religiosa de Charles Darwin
// Plantilla: cita-canvas + blockquote-lateral — paleta "grises" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/19-darwin-hombre-muerto-por-arriba.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "grises", tipografia: "revival-vintage")

#let marca-h = tema.colors.primary.transparentize(60%)
#let contenido = blockquote-lateral(
  [\[Darwin\] quedó como algún gran árbol del bosque de ramas extendidas, bajo el cual los hombres pueden descansar y refrescarse, pero ya marcado por la decadencia como suya propia. #highlight(fill: marca-h)[Era un hombre muerto por arriba].],
  autor: "B.B. Warfield",
  fuente: "sobre Charles Darwin — La vida religiosa de Charles Darwin",
  color: tema.colors.dark,
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
