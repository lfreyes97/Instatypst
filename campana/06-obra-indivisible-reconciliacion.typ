// Campaña Warfield — cita 06
// Fuente: La expiación
// Plantilla: cita-canvas + blockquote-editorial — paleta "noche-azul" + tipografía "lectura-editorial"
// Compilar: typst compile --root . --font-path Fonts campana/06-obra-indivisible-reconciliacion.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "noche-azul", tipografia: "lectura-editorial")

#let contenido = blockquote-editorial(
  [Por esta única e indivisible obra, tanto Dios es reconciliado con nosotros, como nosotros somos reconciliados con Dios.],
  autor: "B.B. Warfield",
  fuente: "La expiación",
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
