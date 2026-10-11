// Demo de gozne() — la cita entera de un lado y, del otro, un gozne de
// dibujo técnico: la idea central es el perno y cada hoja que gira sobre
// él lleva el número de su #llamada(n) en la cita. De 2 a 5 hojas, en
// apaisado (cita al costado) y en vertical o cuadrado (cita arriba): los
// rótulos se ubican solos al extremo de cada hoja. Ver src/gozne.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/gozne.typ
#import "../../src/gozne.typ": gozne, llamada

#let marca = text(font: "Inter", size: 18pt, weight: 700, tracking: 0.12em)[TU MARCA]
#let caso(formato, cita, centro, hojas, ..args) = gozne(
  cita, centro, hojas, formato: formato,
  autor: [B. B. Warfield], obra: [La imputación], marca: marca, ..args,
)

// apaisado, 3 hojas: la cita de la lámina 07
#caso((1600, 900),
  [#text(fill: rgb("#a8361f"))[\[La imputación\]] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza#llamada(1), la satisfacción de Cristo#llamada(2), la justificación por la fe#llamada(3)— y la guardiana de su pureza.],
  [La \ imputación],
  ([La pecaminosidad \ de la raza], [La satisfacción \ de Cristo], [La justificación \ por la fe]))

// apaisado grande, 4 hojas, otra paleta
#caso((1920, 1080),
  [La Escritura es necesaria#llamada(1), suficiente#llamada(2), clara#llamada(3) y tiene autoridad#llamada(4) porque Dios mismo habla en ella.],
  [La \ Escritura],
  ([Necesidad], [Suficiencia], [Claridad], [Autoridad]),
  papel: rgb("#eef0ec"), tinta: rgb("#1d2b26"), acento: rgb("#2f6b4f"))

// retrato, 2 hojas
#caso((1080, 1350),
  [La ley muestra el pecado#llamada(1); el evangelio muestra al Salvador#llamada(2). Confundirlas es perder las dos.],
  [Ley y \ evangelio],
  ([La ley], [El evangelio]))

// story, 5 hojas
#caso((1080, 1920),
  [La gracia de Dios no es un suceso aislado: elección#llamada(1), llamamiento#llamada(2), justificación#llamada(3), adopción#llamada(4) y glorificación#llamada(5) giran sobre la unión con Cristo.],
  [Unión \ con Cristo],
  ([Elección], [Llamamiento], [Justificación], [Adopción], [Glorificación]))

// cuadrado, 3 hojas
#caso((1080, 1080),
  [[La imputación] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza#llamada(1), la satisfacción de Cristo#llamada(2), la justificación por la fe#llamada(3)— y la guardiana de su pureza.],
  [La \ imputación],
  ([La pecaminosidad \ de la raza], [La satisfacción \ de Cristo], [La justificación \ por la fe]))
