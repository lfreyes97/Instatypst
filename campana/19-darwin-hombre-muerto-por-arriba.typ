// Campaña Warfield — cita 19
// Fuente: La vida religiosa de Charles Darwin
// Plantilla: cita-canvas + blockquote-lateral — paleta "grises" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/19-darwin-hombre-muerto-por-arriba.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "grises", tipografia: "revival-vintage")
#let cita = blockquote-lateral.with(theme: tema, color: tema.colors.dark)
#let marca-h = tema.colors.primary.transparentize(60%)

// blockquote-lateral ya deja el cuerpo en redonda (no itálica), así que
// "[Darwin]" no necesita el tratamiento de la 07 — ya contrasta por sí
// solo. La sentencia final sí recibe #text(weight: 700) on-the-fly encima
// del highlight, para que el remate del párrafo pese más que la
// descripción que lo precede.
#warfield-canvas(
  cita(
    [\[Darwin\] quedó como algún gran árbol del bosque de ramas extendidas, bajo el cual los hombres pueden descansar y refrescarse, pero ya marcado por la decadencia como suya propia. #highlight(fill: marca-h)[#text(weight: 700)[Era un hombre muerto por arriba]].],
    autor: "B.B. Warfield",
    fuente: "sobre Charles Darwin — La vida religiosa de Charles Darwin",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
