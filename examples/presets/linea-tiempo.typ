// Demo de linea-tiempo() — la línea de tiempo vertical de la lámina 16 en
// cuatro formatos y con 2, 3 y 5 estaciones: se acomoda sola (mismo aire
// entre estaciones; si no caben se achica, si sobra crece hasta 1,25 y el
// resto queda como tramo de línea antes de la primera). Ver
// src/linea-tiempo.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/linea-tiempo.typ
#import "../../src/linea-tiempo.typ": linea-tiempo

#let marca = text(font: "Jost", size: 20pt, weight: 600, tracking: 0.12em)[TU MARCA]
#let caso(formato, estaciones, ..args) = linea-tiempo(
  estaciones, formato: formato,
  autor: [B. B. Warfield], obra: [La polémica del pedobautismo], marca: marca, ..args,
)

#let abraham = (
  [Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos.],
  [Deben permanecer allí hasta que Él los saque.],
)
#let historia = (
  [En el principio creó Dios los cielos y la tierra.],
  [Llamó a Abraham y le prometió una descendencia.],
  [Dio la Ley en el Sinaí.],
  [Envió a su Hijo, nacido de mujer.],
  [Derramó su Espíritu en Pentecostés.],
)

// retrato, 2 + remate (la lámina 16)
#caso((1080, 1350), abraham, remate: [Él en ninguna parte los ha sacado.],
  origen: [Abraham · Génesis 17], fin: [Hoy])

// story: sobra alto, la letra crece y el aire no pasa de 4 cuerpos
#caso((1080, 1920), abraham, remate: [Él en ninguna parte los ha sacado.],
  origen: [Abraham · Génesis 17], fin: [Hoy])

// cuadrado, 2 sin remate
#caso((1080, 1080), ([La promesa es para vosotros y para vuestros hijos.], [y para todos los que están lejos.]),
  origen: [Pentecostés · Hechos 2], fin: [Hoy])

// cuadrado, 5 + remate: se achica para que quepan
#caso((1080, 1080), historia, remate: [Y volverá.], origen: [Génesis 1], fin: [Hoy])

// apaisado, 2 + remate: la línea sigue vertical, el texto se ensancha
#caso((1600, 900), abraham, remate: [Él en ninguna parte los ha sacado.],
  origen: [Abraham · Génesis 17], fin: [Hoy])
