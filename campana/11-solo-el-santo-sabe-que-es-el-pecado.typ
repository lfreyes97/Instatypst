// Campaña Warfield — cita 11 · ACTO III «El Espíritu»
// Fuente: La persona y la obra del Espíritu Santo (Salmo 51)
// Tono: papel-salvia · Tipografía: revival-vintage · Formato: instagram (1080×1080)
// Plantilla: blockquote-bar — la barra de acento marca el paralelismo de las dos cláusulas.
// Compilar: typst compile --root . --font-path Fonts campana/11-solo-el-santo-sabe-que-es-el-pecado.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-salvia", "revival-vintage")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-bar(
      [#highlight(fill: marca)[Solo el santo sabe qué es el pecado]#[;] solo el gozo que se pierde y luego se vuelve a encontrar se comprende plenamente.],
      size: 78pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #pad(left: 32pt)[#firma(tema, fuente: "Salmo 51", size: 24pt)]
  ],
  tema,
  size: sizes.instagram,
)
