// Campaña Warfield — cita 02 · ACTO I «¿Qué es el calvinismo?»
// Fuente: El calvinismo: significado y usos del término
// Tono: tinta-vino (ancla oscura del acto) · Tipografía: lectura-editorial · Formato: twitter (1600×900)
// Plantilla: blockquote-pull — comilla gigante detrás de una definición de siete palabras.
// Compilar: typst compile --root . --font-path Fonts campana/02-calvinista-ha-visto-a-dios.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("tinta-vino", "lectura-editorial")

#lienzo(
  [
    #blockquote-pull(
      [El calvinista es el hombre que ha visto a Dios.],
      size: 115pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #pad(x: 28pt)[#firma(tema, fuente: "El calvinismo: significado y usos del término", size: 26pt)]
  ],
  tema,
  size: sizes.twitter,
)
