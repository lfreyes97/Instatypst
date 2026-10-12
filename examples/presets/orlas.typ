// Demo de los presets con orla de fleurones (src/orlas.typ, motor en
// src/fleurones.typ): cita, pregunta y capítulo, con varias orlas,
// cadenas, temas y formatos. Son los ejemplos de la plantilla de redes de
// Magnalia Dei, rehechos con el preset: salen iguales píxel a píxel
// (salvo una fracción de píxel en la roseta: su glifo 2L se mide ahora
// con fontTools, 1/1000 em distinto de la tabla a mano).
//
// IM FELL FLOWERS pide, al publicar, la nota de `fleurones.credito`
// donde el medio lo pida (pie de foto, créditos); no va en la imagen.
// Compilar: typst compile --root . --font-path Fonts examples/presets/orlas.typ
#import "../../src/lib.typ": carteles, sizes
#let mag = (encabezado: [Magnalia Dei], autor: [Herman Bavinck])
#let cuadrado = sizes.instagram
#let vertical = (1080, 1350)
#let historia = sizes.story

#carteles.cita-orlada(..mag, fuente: [Magnalia Dei, cap. I · El sumo bien], tema: "vino", tamano: 70pt)[
  El hombre es un enigma que solo halla su solución en Dios.
]
#carteles.cita-orlada(..mag, fuente: [Magnalia Dei, cap. I · El sumo bien], tema: "papel", orla: "arriba", cadena: "cartuchos")[
  El hombre es un enigma que solo halla su solución en Dios.
]
#carteles.cita-orlada(..mag, fuente: [Magnalia Dei, cap. I · El sumo bien], formato: vertical, tema: "vino", orla: "arriba-abajo", cadena: "follaje")[
  Pero la Escritura comprende ambas cosas, arrojando luz sobre el hombre y la humanidad,
  resolviendo contradicciones, disipando nieblas y descubriendo verdades ocultas.
]
#carteles.pregunta-orlada(fuente: [Magnalia Dei, cap. I], tema: "papel", orla: "izquierda", cadena: "ojivas")[
  ¿Qué distingue a los humanos de otras criaturas en su capacidad de reconocer y buscar el sumo bien?
]
#carteles.capitulo-orlado(1, [El sumo bien], subtitulo: [El sumo bien del hombre es solo Dios], obra: [Magnalia Dei], autor: [H. Bavinck], tema: "vino", orla: "columna")
#carteles.cita-orlada(..mag, fuente: [Magnalia Dei, cap. I], tema: "vino", orla: "abajo", cadena: "flores")[
  El hombre es un enigma que solo halla su solución en Dios.
]
#carteles.capitulo-orlado(2, [El conocimiento \ de Dios], obra: [Magnalia Dei], autor: [H. Bavinck], formato: historia, tema: "papel", orla: "lateral", cadena: "cartuchos")
#carteles.pregunta-orlada(fuente: [Magnalia Dei, cap. I], formato: vertical, tema: "vino", orla: "ninguna",
  pista: [Considere los atributos únicos de los humanos, como la razón y el intelecto.])[
  ¿Qué distingue a los humanos de otras criaturas en su capacidad de reconocer y buscar el sumo bien?
]
