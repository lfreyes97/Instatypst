// anaglyph, variante "quote": `cartel-cita` de WallTypst. Compilar desde la raíz del repo.
#import "/src/lib.typ": main, author, work
#import "/.labs/Walltypst-Framed/src/anaglyph.typ": anaglyph

#anaglyph(variant: "quote", artboard: (1920, 1080))[
  #main[Nos hiciste, Señor, para ti, y nuestro corazón está inquieto hasta que descanse en ti.]
  #author[Agustín de Hipona]
  #work[Confesiones, I, 1]
]
