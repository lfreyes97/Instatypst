// Demo de consejo(): un color sólido y un numeral gigante en tono sobre tono.
// Cuatro formatos, con y sin etiqueta y explicación; el título se achica solo.
// Ver src/consejo.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/consejo.typ
#import "../../src/consejo.typ": consejo

#let marca = text(font: "Jost", size: 26pt, weight: 700, tracking: 0.1em)[\@IGLESIARAAH]

// retrato (4:5), con todo
#consejo(
  3, [Ora antes de decidir],
  etiqueta: [Consejo 3],
  texto: [Antes de pedir consejo a los demás, preséntale tu necesidad a Dios y espera en su Palabra.],
  marca: marca,
)

// story (9:16)
#consejo(
  7, [Lee la Escritura en voz alta],
  formato: (1080, 1920), etiqueta: [Hábito 7],
  texto: [Oír la Palabra afirma lo que la vista deja pasar.], marca: marca,
)

// cuadrado, dos dígitos y título largo
#consejo(
  12, [Perdona pronto, aunque no te lo hayan pedido],
  formato: (1080, 1080), etiqueta: [Paso 12], marca: marca,
)

// apaisado, solo número y título, con un tema propio (azul)
#consejo(
  1, [Todo comienza con la gracia],
  formato: (1600, 900), marca: marca,
  tema: (fondo: rgb("#1d4ed8"), tinta: rgb("#ffffff"), suave: rgb("#dbe7ff")),
)
