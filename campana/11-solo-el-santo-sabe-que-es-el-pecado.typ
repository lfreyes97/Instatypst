// Campaña Warfield — cita 11
// Fuente: La persona y la obra del Espíritu Santo (Salmo 51)
// Plantilla: cita-canvas + blockquote-hand — paleta "terracota" + tipografía "manuscrito-calido"
// Compilar: typst compile --root . --font-path Fonts campana/11-solo-el-santo-sabe-que-es-el-pecado.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "terracota", tipografia: "manuscrito-calido")
#let cita = blockquote-hand.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita(
    [Solo el santo sabe qué es el pecado; solo el gozo que se pierde y luego se vuelve a encontrar se comprende plenamente.],
    autor: [B.B. Warfield — Salmo 51],
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
