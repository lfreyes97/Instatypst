// Epígrafe de Bilderdijk en tres diseños de cartel (1080×1350).
// Compilar: typst compile --root . --font-path Fonts examples/epigrafe.typ
#let cita = [«Cuando un pueblo ha de perecer en sus pecados, \ en la Iglesia comienza la lepra del alma.»]
#let autor = [Willem Bilderdijk, _Oprakeling_]
#let pag(fondo, cuerpo) = page(width: 1080pt, height: 1350pt, margin: 0pt, fill: fondo, cuerpo)

// 1 · Editorial oscuro: cita en cursiva grande, filete y atribución en versalitas
#pag(rgb("#14201f"))[
  #place(top + left, dx: 96pt, dy: 96pt, text(font: "Inter", size: 22pt, weight: 600, tracking: 6pt, fill: rgb("#c9a24a"), upper[Epígrafe]))
  #place(horizon + left, dx: 96pt, dy: -40pt, block(width: 880pt)[
    #set text(font: "EB Garamond", size: 92pt, style: "italic", fill: rgb("#f1e9d8"), lang: "es")
    #set par(leading: 22pt)
    #cita
    #v(56pt)
    #line(length: 120pt, stroke: 3pt + rgb("#c9a24a"))
    #v(28pt)
    #text(font: "Inter", size: 26pt, style: "normal", tracking: 2pt, fill: rgb("#c9a24a"), upper(autor))
  ])
]

// 2 · Suizo claro: comilla gigante, texto al pie, rojo de acento
#pag(rgb("#f4f1ea"))[
  #place(top + left, dx: 70pt, dy: 60pt, text(font: "Bodoni Moda", size: 700pt, weight: 700, fill: rgb("#c0392b"), "\u{201C}"))
  #place(bottom + left, dx: 96pt, dy: -110pt, block(width: 900pt)[
    #set text(font: "Jost", size: 72pt, weight: 600, fill: rgb("#111"), lang: "es")
    #set par(leading: 18pt)
    #cita
    #v(40pt)
    #text(font: "Jost", size: 32pt, weight: 400, fill: rgb("#555"), autor)
  ])
]

// 3 · Centrado sobrio: el 70 % central, simetría y ornamento mínimo
#pag(rgb("#e9e1cf"))[
  #align(center + horizon, block(width: 70%)[
    #text(font: "Cormorant Garamond", size: 56pt, fill: rgb("#7a2e2e"))[❦]
    #v(44pt)
    #set text(font: "Cormorant Garamond", size: 84pt, style: "italic", fill: rgb("#2b2118"), lang: "es")
    #set par(leading: 20pt, justify: false)
    #cita
    #v(48pt)
    #text(font: "Cormorant Garamond", size: 32pt, style: "normal", tracking: 4pt, fill: rgb("#7a2e2e"), upper(autor))
  ])
]
