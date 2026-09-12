// Campaña Warfield — cita 20
// Fuente: La vida religiosa de Charles Darwin (contraste con Charles Hodge)
// Plantilla: cita-canvas + blockquote-pull — paleta "grises" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/20-darwin-no-temo-morir.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "grises", tipografia: "revival-vintage")

#let contenido = blockquote-pull(
  [No tengo el menor miedo a morir.],
  autor: "Charles Darwin",
  fuente: "citado por B.B. Warfield, contrastado con la muerte de Charles Hodge — La vida religiosa de Charles Darwin",
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
