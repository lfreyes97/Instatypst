// Campaña Warfield — cita 08
// Fuente: La predestinación
// Plantilla: cita-canvas + blockquote-hero — paleta "terracota" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/08-alfarero-y-barro.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "terracota", tipografia: "revival-vintage")

#let contenido = blockquote-hero(
  [Él era como el alfarero, e Israel como el barro que el alfarero moldea a su voluntad.],
  autor: "B.B. Warfield",
  fuente: "La predestinación",
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
