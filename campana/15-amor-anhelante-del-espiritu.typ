// Campaña Warfield — cita 15
// Fuente: La persona y la obra del Espíritu Santo (El amor del Espíritu Santo)
// Plantilla: cita-canvas + blockquote-hero — paleta "bosque" + tipografía "manuscrito-calido"
// Compilar: typst compile --root . --font-path Fonts campana/15-amor-anhelante-del-espiritu.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "bosque", tipografia: "manuscrito-calido")

#let contenido = blockquote-hero(
  [¡El amor del Espíritu! ¡El amor anhelante, celoso, del Espíritu Santo por nuestras almas!],
  autor: "B.B. Warfield",
  fuente: "El amor del Espíritu Santo",
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
