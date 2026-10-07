// Campaña Warfield — cita 05 · ACTO II «La obra de la gracia»
// Fuente: La incapacidad y la exigencia de la fe
// Tono: papel-noche · Tipografía: editorial-clasico · Formato: twitter (1600×900)
// Plantilla: blockquote-hero — imperativo pastoral, centrado.
// Compilar: typst compile --root . --font-path Fonts campana/05-actua-contra-el-pecado.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-noche", "editorial-clasico")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-hero(
      [Actúa contra el pecado, en el nombre de Cristo, como si tuvieras fuerza, y #highlight(fill: marca)[hallarás que la tienes].],
      size: 102pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "La incapacidad y la exigencia de la fe", alineacion: center, size: 26pt)
  ],
  tema,
  size: sizes.twitter,
)
