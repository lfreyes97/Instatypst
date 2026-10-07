// Campaña Warfield — cita 20 · ACTO IV «Polémica y mundo» — PAR DARWIN/HODGE (2 de 2)
// Fuente: La vida religiosa de Charles Darwin (contraste con Charles Hodge)
// Tono: tinta-grafito · Tipografía: geometrico-moderno · Formato: twitter (1600×900)
// Plantilla: blockquote-pull — seis palabras: la cita más corta de la campaña, y la única
// que no es de Warfield. Cierra la serie en negro, como respuesta visual a la 19.
// La `nota:` de la firma es obligatoria aquí: sin ella, suelta en un feed, la tarjeta
// parecería atribuirle a Warfield una frase de Darwin.
// Compilar: typst compile --root . --font-path Fonts campana/20-darwin-no-temo-morir.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("tinta-grafito", "geometrico-moderno")

#lienzo(
  [
    #blockquote-pull(
      [No tengo el menor miedo a morir.],
      size: 132pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #pad(x: 28pt)[
      #firma(
        tema,
        autor: "Charles Darwin",
        fuente: "citado por B.B. Warfield — La vida religiosa de Charles Darwin",
        nota: [Palabras de Darwin, no de Warfield: él las cita para contrastarlas con la muerte de Charles Hodge. 2 de 2.],
        size: 26pt,
      )
    ]
  ],
  tema,
  size: sizes.twitter,
)
