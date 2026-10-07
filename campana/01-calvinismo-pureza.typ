// Campaña Warfield — cita 01 · ACTO I «¿Qué es el calvinismo?»
// Fuente: ¿Qué es el calvinismo?
// Tono: papel-vino · Tipografía: lectura-editorial · Formato: twitter (1600×900)
// Plantilla: blockquote-hero — la tesis de apertura, centrada y sola en el papel.
// Compilar: typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("papel-vino", "lectura-editorial")

#lienzo(
  [
    #blockquote-hero(
      [El calvinismo es simplemente la religión en su pureza.],
      size: 102pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "¿Qué es el calvinismo?", alineacion: center, size: 26pt)
  ],
  tema,
  size: sizes.twitter,
)
