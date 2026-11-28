// timepiece, variante "month-verse": `verso-calendario` de WallTypst, en sintaxis V2.
// Compilar desde la raíz del repo:
//   typst compile --root . .labs/Walltypst-Framed/ejemplos/timepiece-month-verse.typ out.svg
#import "/src/lib.typ": calendar, verse, work
#import "/.labs/Walltypst-Framed/src/timepiece.typ": timepiece

#timepiece(variant: "month-verse", artboard: (1920, 1080))[
  #calendar(year: 2026, month: 11, today: 19, marks: ((day: 29, label: "Santa Cena"),))
  #verse[Es por la misericordia de Jehová que no somos consumidos, porque nunca decayeron sus misericordias. Nuevas son cada mañana; grande es tu fidelidad.]
  #work[#"Lamentaciones 3:22–23  ·  RV1909"]
]
