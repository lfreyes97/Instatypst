// Demo de mesa: hoja suelta fotografiada sobre madera (de DeskBook).
// Compilar: typst compile --root . --font-path Fonts examples/mesa.typ
// Una lámina de preset sobre la mesa: python3 scripts/foto-de-lamina.py (ver su ayuda)
#import "../src/lib.typ": *

// una portada: el texto gira con la hoja
#mesa.portada-vertical(title: [Mi Libro], subtitle: [una hoja sobre la mesa], author: [Luis Reyes])[Portada de prueba.]

// una hoja aparte, de cerca y torcida: el texto gira con ella
#mesa.hoja-apaisada(distance: 150mm, angle: -1.2deg)[
  = Apaisada
  #lorem(40)
  #mesa.lamina(rect(width: 100%, height: 16mm, fill: rgb("#c8102e"), align(center + horizon, text(fill: white, [una lámina]))))
]

// el texto fluye por varias hojas
#show: mesa.vertical.with(distance: 250mm)

= Capítulo 1
#lorem(120)

#mesa.nota[Nota suelta sin sombra.]

#pagebreak()
#lorem(90)
