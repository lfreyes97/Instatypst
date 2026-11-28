// timepiece, variante "hour": `cartel-hora` de WallTypst. Compilar desde la raíz del repo.
#import "/src/lib.typ": clock, verse, work
#import "/.labs/Walltypst-Framed/src/timepiece.typ": timepiece

#timepiece(variant: "hour", artboard: (1920, 1080))[
  #clock(time: "06:30", date: "2026-11-22")
  #verse[Jesucristo es el mismo ayer, y hoy, y por los siglos.]
  #work[#"Hebreos 13:8  ·  RV1909"]
]
