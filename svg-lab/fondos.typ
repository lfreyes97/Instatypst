// Laboratorio de fondos SVG — rama feature/fondos-svg.
// Compilar: typst compile --root . svg-lab/fondos.typ
// Cada sección es una página (canvas = page). Si algo falla, se ve aislado.
#import "../src/lib.typ": *

// 1. bocadillo compuesto con texto (patrón box + place del módulo)
#canvas(sizes.instagram, [
  #bg(white)
  #align(center + horizon)[
    #box(width: 500pt, height: 340pt)[
      #place(top + left)[#formas.bocadillo(w: 500pt, h: 300pt, fill: rgb("#0EA5E9"))]
      #place(top + left, dx: 30pt, dy: 30pt)[
        #block(width: 440pt)[
          #text(fill: white, size: 32pt, weight: 700)[Bocadillo + texto encima. La forma es solo el fondo; el texto va en su propio place dentro del mismo box.]
        ]
      ]
    ]
  ]
])

// 2. cinta compuesta con texto
#canvas(sizes.instagram, [
  #bg(white)
  #align(center + horizon)[
    #box(width: 560pt, height: 120pt)[
      #place(top + left)[#formas.cinta(w: 560pt, h: 120pt, fill: rgb("#DC2626"))]
      #place(center + horizon, dx: 0pt)[
        #align(center)[#text(fill: white, size: 40pt, weight: 800)[CINTA CON TEXTO]]
      ]
    ]
  ]
])

// 3. blobs orgánicos (las 6 siluetas)
#canvas(sizes.instagram, [
  #bg(white)
  #pad(60pt)[
    #grid(columns: 3, gutter: 30pt,
      formas.blob("nube", w: 280pt, fill: rgb("#0EA5E9")),
      formas.blob("nota", w: 280pt, fill: rgb("#16A34A")),
      formas.blob("hoja", w: 280pt, fill: rgb("#D97706")),
      formas.blob("burbuja", w: 280pt, fill: rgb("#7C3AED")),
      formas.blob("mancha", w: 280pt, fill: rgb("#DC2626")),
      formas.blob("tarjeta", w: 280pt, fill: rgb("#0F172A")),
    )
  ]
])

// 4. aura-bg sin panel (blur de manchas, 3 colores en diagonal)
#canvas(sizes.instagram, [
  #aura-bg((rgb("#EF4444"), rgb("#22C55E"), rgb("#3B82F6")))
  #place(center + horizon)[
    #align(center)[#text(fill: white, size: 48pt, weight: 800)[AURA SIN PANEL]]
  ]
])

// 5. aura-bg con panel (vidrio esmerilado real sobre las mismas manchas)
#canvas(sizes.instagram, [
  #aura-bg((rgb("#EF4444"), rgb("#22C55E"), rgb("#3B82F6")),
    panel: (x: 140, y: 340, w: 800, h: 400, r: 40))
  #place(center + horizon)[
    #align(center)[#text(fill: white, size: 40pt, weight: 800)[AURA CON PANEL]]
  ]
])
