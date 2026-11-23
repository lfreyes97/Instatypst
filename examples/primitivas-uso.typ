// ─────────────────────────────────────────────────────────────
//  examples/primitivas-uso.typ — el "usuario" del template
//
//  Este archivo es el que manda: trae las primitivas, decide la
//  paleta, el formato y la composición. Las primitivas solo miden,
//  colocan, esquivan y ajustan; no saben de colores ni de estilo.
// ─────────────────────────────────────────────────────────────

#import "../core/primitivas.typ": *

#let formato = (1080, 1350)
#let pal = (
  fondo: rgb("#161616"),
  tinta: rgb("#f4efe6"),
  suave: rgb("#9a9488"),
  acento: rgb("#d9603b"),
)

// La rejilla cambia con el aspecto: 6 columnas en vertical,
// 12 en apaisado, 16 en ultra. Zona segura de escritorio y DEBUG.
#let firma = marca("R", proporcion: 1 / 28)
#let rej = rejilla(formato,
  columns: (vertical: 6, apaisado: 12, ultra: 16),
  rows: 8,
  gutter: (sm: 16, xl: 32),
  margin: 60,
  safe: "escritorio",
  debug: false,
)

#page(width: rej.ancho, height: rej.alto, margin: 0pt, fill: pal.fondo, {
  // 1. Dos formas piden celdas (número entero de celdas).
  let disco = (col: 1, row: 1, span: 4, rows: 4)
  let barra = (col: 5, row: 1, span: 1, rows: 8)

  // 2. Cada forma se publica como obstáculo con su aire.
  let obstaculos = (
    ob-celda(disco, rej, aire: 24pt),
    ob-celda(barra, rej, aire: 16pt),
  )

  let d = (rej.celda)(disco)
  let b = (rej.celda)(barra)
  place(top + left, dx: d.x, dy: d.y,
    circle(radius: calc.min(d.w, d.h) / 2, fill: pal.acento))
  place(top + left, dx: b.x, dy: b.y,
    rect(width: b.w, height: b.h, fill: pal.suave))

  // 3. El texto no va en su celda: toma la mayor región libre
  //    del contenedor, descontando obstáculos y zona segura.
  let k = (rej.contenedor)()
  let limites = (k.x, k.y, k.x + k.w, k.y + k.h)
  let caja = mayor-caja-libre(obstaculos, limites)

  if caja == none {
    text(fill: red, size: 20pt)[No hay caja libre]
  } else {
    context {
      let w = caja.at(2) - caja.at(0)
      let h = caja.at(3) - caja.at(1)
      let titulo = [La rejilla decide dónde cae el texto]
      let hacer(t) = text(size: t, fill: pal.tinta, weight: 800, titulo)
      let s = ajustar-alto(hacer, 72pt, h, minimo: 24pt)
      place(top + left, dx: caja.at(0), dy: caja.at(1),
        box(width: w, height: h, text(size: s, fill: pal.tinta, weight: 800, titulo)))
    }
  }

  // 4. Depuración: contorno de obstáculos + rejilla y zona segura.
  dibujar-obstaculos(obstaculos, x => x, y => y, v => v, color: blue)
  (rej.depuracion)()
  place(top + left, dx: 40pt, dy: 40pt, firma(pal.acento, formato))
})
