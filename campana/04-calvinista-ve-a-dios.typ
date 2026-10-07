// Campaña Warfield — cita 04 · ACTO I «¿Qué es el calvinismo?»
// Fuente: La teología de Calvino
// Tono: papel-vino · Tipografía: lectura-editorial · Formato: story (1080×1920)
// Plantilla: blockquote-bar "grande" — la cita más larga del acto, en vertical de historia.
// Compilar: typst compile --root . --font-path Fonts campana/04-calvinista-ve-a-dios.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("papel-vino", "lectura-editorial")

#lienzo(
  [
    #blockquote-bar(
      [El calvinista es el hombre que ve a Dios detrás de todos los fenómenos, y en todo lo que ocurre reconoce la mano de Dios, obrando su voluntad.],
      variante: "grande",
      size: 84pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #pad(left: 32pt)[#firma(tema, fuente: "La teología de Calvino", size: 28pt)]
  ],
  tema,
  size: sizes.story,
)
