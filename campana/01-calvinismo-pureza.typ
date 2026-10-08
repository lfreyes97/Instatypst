// Lámina 01 · «¿Qué es el calvinismo?» · retrato 1080×1350
// Concepto: cartel suizo. «PUREZA» ocupa todo el ancho en un solo rojo
// sobre papel casi blanco; el resto de la frase, pequeño y en sans, cuelga
// de una retícula de seis columnas visible. Nada más: la pureza es quitar.
// Compilar: typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ campana/01-calvinismo-pureza.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.retrato
#let papel = rgb("#f3f0e9")
#let tinta = rgb("#141414")
#let rojo = rgb("#c8102e")
#let reticula = rgb("#d9d3c7")
#let gris = rgb("#5c5850")

#let margen = 64pt
#let cols = 6
#let medianil = 24pt
#let util = ancho * 1pt - 2 * margen
#let col = (util - (cols - 1) * medianil) / cols
// x de inicio de la columna i (0-based)
#let cx(i) = margen + i * (col + medianil)

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: "Hanken Grotesk", fill: tinta, lang: "es")
#set par(leading: 0.42em)

// ── retícula visible: bordes de columna en filete fino ──
#for i in range(cols) {
  place(top + left, dx: cx(i), line(start: (0pt, 0pt), end: (0pt, alto * 1pt), stroke: 0.8pt + reticula))
  place(top + left, dx: cx(i) + col, line(start: (0pt, 0pt), end: (0pt, alto * 1pt), stroke: 0.8pt + reticula))
}

// ── cabecera ──
#place(top + left, dx: margen, dy: margen, line(length: util, stroke: 2.5pt + tinta))
#place(top + left, dx: cx(0), dy: margen + 18pt, text(font: "Inter", size: 22pt, weight: 700, tracking: 0.12em)[B. B. WARFIELD])
#place(top + left, dx: cx(3), dy: margen + 18pt, text(font: "Inter", size: 22pt, weight: 400, fill: gris)[1851 – 1921])

// ── la pregunta del ensayo, arriba, como planteo ──
#place(top + left, dx: cx(0), dy: 196pt, block(width: 4 * col + 3 * medianil)[
  #text(font: "Inter", size: 22pt, weight: 700, tracking: 0.12em, fill: rojo)[DEL ENSAYO]
  #v(4pt)
  #text(font: "Inter", size: 44pt, weight: 400, fill: gris, tracking: -0.01em)[¿Qué es el calvinismo?]
])

// ── la frase, pequeña, sobre las columnas 1–4 ──
#place(top + left, dx: cx(0), dy: 590pt, block(width: 4 * col + 3 * medianil)[
  #text(size: 66pt, weight: 500, tracking: -0.015em)[El calvinismo es simplemente la religión en su]
])

// flecha fina que baja de la frase a la palabra
#place(top + left, dx: cx(5) + col / 2, dy: 604pt, {
  line(start: (0pt, 0pt), end: (0pt, 250pt), stroke: 3pt + rojo)
  place(top + left, dx: -14pt, dy: 232pt, polygon(fill: rojo, (0pt, 0pt), (28pt, 0pt), (14pt, 26pt)))
})

// ── PUREZA: todo el ancho útil ──
#let palabra(s) = text(font: "Bebas Neue", size: s, fill: rojo, top-edge: "cap-height", bottom-edge: "baseline")[PUREZA.]
#context {
  let w1 = measure(palabra(100pt)).width
  let s = 100pt * (util / w1)
  let caja = palabra(s)
  let alto-caja = measure(caja).height
  place(top + left, dx: margen - 0.035 * s, dy: alto * 1pt - 150pt - alto-caja, caja)
}

// ── pie ──
#place(bottom + left, dx: margen, dy: -112pt, line(length: util, stroke: 2.5pt + tinta))
#place(bottom + left, dx: cx(0), dy: -margen + 3pt, logo(tinta, (ancho, alto)))
