// Campaña Warfield — cita 11
// Fuente: La persona y la obra del Espíritu Santo (Salmo 51)
// Plantilla: cita-canvas + blockquote-hand — paleta "terracota" + tipografía "manuscrito-calido"
// Compilar: typst compile --root . --font-path Fonts campana/11-solo-el-santo-sabe-que-es-el-pecado.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "terracota", tipografia: "manuscrito-calido")

#let contenido = blockquote-hand(
  [Solo el santo sabe qué es el pecado; solo el gozo que se pierde y luego se vuelve a encontrar se comprende plenamente.],
  autor: [B.B. Warfield — Salmo 51],
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
