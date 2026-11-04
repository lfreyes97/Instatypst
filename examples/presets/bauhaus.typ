// Demo de carteles.bauhaus() — formas primarias y barra diagonal; el mismo
// contrato que carteles.suizo (frase, remate, autor, fechas, etiqueta,
// planteo, marca), en cuatro formatos y con una paleta alternativa.
// Compilar: typst compile --root . --font-path Fonts examples/presets/bauhaus.typ
#import "../../src/lib.typ": *

#let marca = text(font: "Jost", size: 18pt, weight: 700, tracking: 0.12em)[TU MARCA]
#let caso(formato, frase, remate, ..args) = carteles.bauhaus(
  frase, remate, formato: formato,
  autor: [B. B. WARFIELD], fechas: [1851 – 1921], marca: marca, ..args,
)

// cuadrado, frase larga
#caso(sizes.instagram,
  [El que tiene entendimiento, calcule el número de la bestia. No pide cómputo, pide],
  [SABIDURÍA.],
  etiqueta: [APOCALIPSIS 13:18], planteo: [¿Capacidad o entendimiento?])

// retrato, el formato de origen
#caso((1080, 1350), [El calvinismo es simplemente la religión en su], [PUREZA.],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?])

// story, paleta alternativa por tema (fondo oscuro)
#caso(sizes.story, [Todo es], [GRACIA.], etiqueta: [UNA PALABRA],
  tema: (fondo: rgb("#14213d"), tinta: rgb("#f4efe3"), suave: rgb("#b8c0d4"),
         acento: rgb("#e63946"), amarillo: rgb("#fca311"), azul: rgb("#4a6fa5")))

// apaisado
#caso(sizes.twitter, [El calvinismo es simplemente la religión en su], [PUREZA.],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?])
