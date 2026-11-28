// inscription, variante "ruler": `escala-versiculos` de WallTypst (muestra verso.json). Compilar desde la raíz del repo.
#import "/src/lib.typ": verse, work, ruler
#import "/.labs/Walltypst-Framed/src/inscription.typ": inscription

#inscription(variant: "ruler", artboard: (1920, 1080))[
  #ruler(total: 66, current: 22)
  #verse[Es por la misericordia de Jehová que no somos consumidos, porque nunca decayeron sus misericordias. Nuevas son cada mañana; grande es tu fidelidad.]
  #work[#"Lamentaciones 3:22–23  ·  RV1909"]
]
