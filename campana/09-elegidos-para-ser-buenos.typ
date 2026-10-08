// Lámina 09 · «La elección» · twitter 1600×900
// Corrección de pruebas: la idea falsa («porque seamos buenos») queda
// tachada en gris con lápiz rojo y su «porque» encerrado; debajo, la
// verdad en negro pesado, con «para que» escrito en la tinta roja del editor.
// Compilar: typst compile --root . --font-path Fonts campana/09-elegidos-para-ser-buenos.typ campana/09-elegidos-para-ser-buenos.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos, ajustar

#let (ancho, alto) = formatos.twitter
#let papel = rgb("#faf8f3")
#let tinta = rgb("#141414")
#let gris = rgb("#6c6c6c")  // ≈ 5:1 sobre el papel: tachado, pero legible
#let rojo = rgb("#d0342c")  // lápiz de corrector

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: "Public Sans", fill: tinta, lang: "es", hyphenate: false)

#superbg.superbg((capas: (
  (tipo: "plano", color: papel),
  (tipo: "ruido", color: tinta, opacidad: 3%),
)), size: formatos.twitter)

#let margen = 120pt

// ── Renglón 1: la idea que el editor tacha ──
// Se mide a mano para que el tachón y el óvalo caigan sobre las palabras.
#let t1 = 58pt
#let y1 = 132pt
#context {
  let gris-t(c) = text(size: t1, weight: 400, fill: gris, c)
  let antes = measure(gris-t[No somos escogidos porque]).width
  let palabra = measure(gris-t[porque]).width
  let total = measure(gris-t[No somos escogidos porque seamos buenos;]).width
  let xp = margen + antes - palabra

  place(top + left, dx: margen, dy: y1, gris-t[No somos escogidos porque seamos buenos;])
  // tachón: un trazo de lápiz apenas inclinado, más largo que la frase
  place(top + left, line(
    start: (margen - 14pt, y1 + 30pt), end: (margen + total + 16pt, y1 + 20pt),
    stroke: (paint: rojo, thickness: 5pt, cap: "round"),
  ))
  // óvalo alrededor de «porque»
  place(top + left, dx: xp - 22pt, dy: y1 - 18pt, rotate(-4deg, ellipse(
    width: palabra + 44pt, height: 92pt, stroke: (paint: rojo, thickness: 3.5pt),
  )))
}

// ── Renglones 2–3: la corrección, firme ──
// «para que» va en la tinta roja del corrector: es lo que reemplaza al
// «porque» encerrado arriba.
#let corregido = [somos escogidos #text(fill: rojo)[para~que] podamos ser buenos.]
#place(top + left, dx: margen, dy: 286pt, block(width: 1360pt, height: 420pt, context ajustar(
  s => text(size: s, weight: 800, tracking: -0.02em, par(leading: 0.34em, corregido)),
  1360pt, 420pt, texto: corregido, max: 140pt, min: 60pt,
)))

// ── Pie ──
#place(top + left, dx: margen, dy: 760pt, line(length: 1360pt, stroke: 1.5pt + tinta))
#place(top + left, dx: margen, dy: 786pt, text(size: 30pt)[
  #text(weight: 700)[B. B. Warfield] #h(10pt) #text(fill: gris)[La elección]
])
#place(top + right, dx: -margen, dy: 784pt, logo(tinta, (ancho, alto)))
