// timepiece, variante "analog": `reloj-analogico` de WallTypst. Compilar desde la raíz del repo.
#import "/src/lib.typ": clock
#import "/.labs/Walltypst-Framed/src/timepiece.typ": timepiece

#timepiece(variant: "analog", artboard: (1920, 1080))[
  #clock(time: "21:07", date: "2026-11-22")
]
