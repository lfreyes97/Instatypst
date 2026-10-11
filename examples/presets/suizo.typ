// Demo de carteles.suizo() — el mismo preset en cuatro formatos y con
// textos de distinto largo: se acomoda solo (la frase no sube más allá
// del planteo y se achica si no cabe; en apaisado el remate se limita
// por el alto). Ver src/carteles.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/suizo.typ
#import "../../src/lib.typ": *

#let marca = text(font: "Inter", size: 18pt, weight: 700, tracking: 0.12em)[TU MARCA]
#let caso(formato, frase, remate, ..args) = carteles.suizo(
  frase, remate, formato: formato,
  autor: [B. B. WARFIELD], fechas: [1851 – 1921], marca: marca, ..args,
)

// cuadrado, frase larga
#caso(sizes.instagram,
  [El que tiene entendimiento, calcule el número de la bestia. No pide cómputo, pide],
  [SABIDURÍA.],
  etiqueta: [APOCALIPSIS 13:18], planteo: [¿Capacidad o entendimiento?])

// story, otro acento
#caso(sizes.story, [El calvinismo es simplemente la religión en su], [PUREZA.],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?], acento: rgb("#1d4ed8"))

// retrato, sin planteo, frase mínima
#caso((1080, 1350), [Todo es], [GRACIA.], etiqueta: [UNA PALABRA])

// apaisado
#caso(sizes.twitter, [El calvinismo es simplemente la religión en su], [PUREZA.],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?])
