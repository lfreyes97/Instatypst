// timepiece, "month": el calendario mensual de WallTypst (`calendario`), en sintaxis V2.
// Compilar desde la raíz del repo:
//   typst compile --root . .labs/Walltypst-Framed/ejemplos/timepiece-month.typ out.svg
#import "/src/lib.typ": calendar
#import "/.labs/Walltypst-Framed/src/timepiece.typ": timepiece

#timepiece(artboard: (1920, 1080))[
  #calendar(year: 2026, month: 12, today: 3,
    marks: ((day: 6, label: "Santa Cena"), (day: 13, label: "Reunión de oración"), 24, 25))
]
