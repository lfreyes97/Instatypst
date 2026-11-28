// timepiece, variante "lords-day": `dia-del-senor` de WallTypst. Compilar desde la raíz del repo.
#import "/src/lib.typ": clock, verse, work
#import "/.labs/Walltypst-Framed/src/timepiece.typ": timepiece

#timepiece(variant: "lords-day", artboard: (1920, 1080))[
  #clock(time: "09:48", date: "2026-11-19")
  #verse[Es por la misericordia de Jehová que no somos consumidos, porque nunca decayeron sus misericordias. Nuevas son cada mañana; grande es tu fidelidad.]
  #work[#"Lamentaciones 3:22–23  ·  RV1909"]
]
