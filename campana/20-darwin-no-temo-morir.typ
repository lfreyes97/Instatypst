// Campaña Warfield — cita 20
// Fuente: La vida religiosa de Charles Darwin (contraste con Charles Hodge)
// Plantilla: cita-canvas + blockquote-pull — paleta "grises" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/20-darwin-no-temo-morir.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "grises", tipografia: "revival-vintage")
#let cita = blockquote-pull.with(theme: tema, color: tema.colors.dark)

#warfield-canvas(
  cita(
    [No tengo el menor miedo a morir.],
    autor: "Charles Darwin",
    fuente: "citado por B.B. Warfield, contrastado con la muerte de Charles Hodge — La vida religiosa de Charles Darwin",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
