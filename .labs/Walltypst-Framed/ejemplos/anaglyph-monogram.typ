// anaglyph, variante "monogram": `cartel-monograma` de WallTypst. Compilar desde la raíz del repo.
#import "/src/lib.typ": epigraph, author, work
#import "/.labs/Walltypst-Framed/src/anaglyph.typ": anaglyph

#anaglyph(variant: "monogram", artboard: (1920, 1080))[
  #epigraph[El fin principal del hombre es glorificar a Dios y gozar de él para siempre.]
  #author[Catecismo Menor de Westminster]
  #work[Pregunta 1]
]
