// Lámina 17 · Apologética · cuadrado 1080×1080
// Concepto: la cita como una demostración numerada, en pizarra oscura. «racional»
// es la línea que se sostiene (⊢, sólida, enorme); «irracional» es la que no se
// sigue (⊬): su prefijo «ir» queda en contorno y tachado.
// Compilar: typst compile --root . --font-path Fonts campana/17-racional-creer-en-cristo.typ campana/17-racional-creer-en-cristo.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.instagram
#let pizarra = rgb("#0d1014")
#let tiza = rgb("#f4f1ea")
#let gris = rgb("#c3c9d1")
#let apagado = rgb("#8b95a1")
#let ambar = rgb("#f2b33d")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: pizarra)
#set text(font: "Instrument Sans", fill: gris, lang: "es", hyphenate: false)

// ── Fondo: retícula de cuaderno de cálculo, muy tenue
#place(superbg.bg-patron(patron: "grid", color: tiza, paso: 54, grosor: 1, opacidad: 5%, size: formatos.instagram))

#let mono(cuerpo, color: apagado, size: 24pt) = text(font: "DM Mono", size: size, fill: color, cuerpo)

// ── La demostración
#let n(i) = mono("0" + str(i))
#let marca(s, color) = text(font: "DM Mono", size: 52pt, fill: color, s)

#let filas(..celdas) = block(width: ancho * 1pt - 168pt, grid(
  columns: (64pt, 1fr, 48pt),
  align: (left + horizon, left + horizon, right + horizon),
  row-gutter: 18pt,
  ..celdas,
))

// Lo que se afirma (líneas 1–3)
#place(dx: 84pt, dy: 176pt, filas(
  n(1), text(size: 58pt)[Creemos en Cristo porque es], [],
  n(2), text(size: 212pt, weight: 700, fill: tiza, tracking: -0.02em)[racional], marca("⊢", ambar),
  n(3), text(size: 58pt)[creer en él,], [],
))

// Raya de deducción entre lo que se sigue y lo que no
#place(dx: 84pt + 64pt, dy: 524pt, line(length: ancho * 1pt - 168pt - 64pt, stroke: (paint: apagado, thickness: 2pt, dash: (6pt, 8pt))))

// Lo que se niega (líneas 4–5): «ir» en contorno y tachado
#let prefijo = strike(
  stroke: 9pt + ambar, offset: -0.26em, extent: 0.08em,
  text(fill: pizarra, stroke: 3.5pt + apagado)[ir],
)
#place(dx: 84pt, dy: 568pt, filas(
  n(4), text(size: 58pt)[no aunque sea], [],
  n(5),
  box(text(size: 170pt, weight: 700, tracking: -0.02em)[#prefijo#h(0.03em)#text(fill: apagado)[racional.]]),
  marca("⊬", apagado),
))

// ── Pie
#place(bottom + left, dx: 84pt, dy: -76pt, block(width: ancho * 1pt - 168pt, grid(
  columns: (1fr, auto),
  align: (left + bottom, right + bottom),
  mono(color: gris)[— B. B. Warfield \ #h(1.2em)#text(fill: apagado)[Apologética]],
  logo(tiza, (ancho, alto)),
)))
