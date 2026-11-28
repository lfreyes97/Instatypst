// anaglyph, variante "edge" con epígrafe: `cartel-capas-canto` con la muestra `epigrafe.json`.
#import "/src/lib.typ": epigraph, author, work
#import "/.labs/Walltypst-Framed/src/anaglyph.typ": anaglyph

#anaglyph(variant: "edge", artboard: (1920, 1080))[
  #epigraph[El fin principal del hombre es glorificar a Dios y gozar de él para siempre.]
  #author[Catecismo Menor de Westminster]
  #work[Pregunta 1]
]
