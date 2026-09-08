// Campaña Warfield — cita 06
// Fuente: La expiación
// Plantilla: cita-canvas + blockquote-editorial — paleta "noche-azul" + tipografía "lectura-editorial"
// Compilar: typst compile --root . --font-path Fonts campana/06-obra-indivisible-reconciliacion.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "noche-azul", tipografia: "lectura-editorial")
#let cita = blockquote-editorial.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita(
    [Por esta única e indivisible obra, tanto Dios es reconciliado con nosotros, como nosotros somos reconciliados con Dios.],
    autor: "B.B. Warfield",
    fuente: "La expiación",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.dark,
  blob-color: white,
  footer-color: white,
)
