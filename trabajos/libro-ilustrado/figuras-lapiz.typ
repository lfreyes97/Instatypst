// Tres figuras a lápiz para el pasaje de la finca (Why I Believe in God):
//   finca-lapiz()     la finca desde el camino, con el letrero de propiedad (500 × 235 pt)
//   memorial-lapiz()  el Memorial de Lincoln (190 × 140 pt)
//   bandera-lapiz()   «Old Glory» en su asta (130 × 150 pt)
// Monocromas (grafito sobre papel), sin fondo: sirven sobre cualquier página. Los trazos salen de
// lapiz.typ. Para usarlas en LaTeX, ver figuras-export.typ.
#import "lapiz.typ": *

// ── La finca ────────────────────────────────────────────────────────
#let finca-lapiz() = box(width: 500pt, height: 235pt, {
  let hy = 120 // horizonte
  let vp = 190 // punto de fuga

  // nubes: línea de base y tres arcos
  let nube(x, y, s, semilla) = {
    linea(x, y, x + 74 * s, y, semilla: semilla, grosor: 0.6)
    arco(x + 16 * s, y, 14 * s, 180, 360, semilla: semilla + 1, grosor: 0.6)
    arco(x + 38 * s, y, 21 * s, 180, 360, semilla: semilla + 2, grosor: 0.6)
    arco(x + 60 * s, y, 13 * s, 180, 360, semilla: semilla + 3, grosor: 0.6)
  }
  nube(165, 26, 1.0, 11)
  nube(30, 52, 0.7, 21)
  nube(215, 72, 0.55, 31)

  // sol: círculo y rayos (la mitad de abajo la tapan las colinas)
  circulo-lapiz(95, 109, 30, semilla: 3)
  for a in range(196, 345, step: 18) {
    let c = calc.cos(a * 1deg)
    let s = calc.sin(a * 1deg)
    linea(95 + 36 * c, 109 + 36 * s, 95 + 46 * c, 109 + 46 * s, semilla: a, pasadas: 1, grosor: 0.6)
  }

  // colinas lejanas (la más lejana tapa el sol) y horizonte
  let lejana = range(0, 51).map(i => (i * 10, 104 + 5 * calc.sin(i * 10 / 45 + 0.4)))
  let cercana = range(0, 51).map(i => (i * 10, 115 + 3 * calc.sin(i * 10 / 28 + 2.0)))
  tapar(lejana + ((500, hy + 2), (0, hy + 2)))
  ruta(lejana, semilla: 41, tremor: 0.5, grosor: 0.7)
  tapar(cercana + ((500, hy + 2), (0, hy + 2)))
  ruta(cercana, semilla: 61, tremor: 0.5, grosor: 0.8)
  linea(0, hy + 2, 500, hy + 2, semilla: 71, grosor: 0.8)

  // sembrados: surcos que convergen en el punto de fuga
  for (i, xb) in (-260, -190, -125, -65, -20, 330, 385, 440, 505, 580, 670, 790).enumerate() {
    linea(vp, hy + 2, xb, 235, semilla: 81 + i, pasadas: 1, grosor: 0.45, alfa: 55%, tremor: 0.4)
  }

  // camino: rayado, bordes y raya central
  let xl(t) = lerp(187, 20, t)
  let xr(t) = lerp(193, 300, t)
  let yy(t) = lerp(hy, 235, t)
  for y in range(125, 235, step: 4) {
    let t = (y - hy) / (235 - hy)
    linea(xl(t) + 1, y, xr(t) - 1, y, semilla: 200 + y, pasadas: 1, grosor: 0.45, alfa: 42%, tremor: 0.3)
  }
  linea(187, hy + 2, 20, 235, semilla: 91, grosor: 0.95)
  linea(193, hy + 2, 300, 235, semilla: 92, grosor: 0.95)
  for k in range(0, 7) {
    let t0 = 0.08 + k * 0.14
    let t1 = t0 + 0.07
    let cx(t) = lerp(190, 150, t)
    let q = ((cx(t0) - 1 - 4 * t0, yy(t0)), (cx(t0) + 1 + 4 * t0, yy(t0)), (cx(t1) + 1 + 4 * t1, yy(t1)), (cx(t1) - 1 - 4 * t1, yy(t1)))
    tapar(q)
    ruta(q, cerrada: true, semilla: 300 + k, pasadas: 1, grosor: 0.6)
  }

  // cerca junto al camino
  let ts = (0.12, 0.24, 0.38, 0.55)
  let tope(t) = (xr(t) + 10 + 22 * t, yy(t) - 34 * t - 3)
  for (i, t) in ts.enumerate() {
    let (px, py) = tope(t)
    linea(px, yy(t) + 2, px, py, semilla: 400 + i, grosor: 1.1)
  }
  ruta(ts.map(tope), semilla: 410, pasadas: 1, grosor: 0.6)
  ruta(ts.map(t => (tope(t).at(0), lerp(tope(t).at(1), yy(t), 0.55))), semilla: 420, pasadas: 1, grosor: 0.6)

  // árboles del lado izquierdo, de lejos a cerca
  for (i, t) in (0.17, 0.32, 0.5, 0.72).enumerate() {
    let x = xl(t) - 18 - 40 * t
    let y = yy(t) + 2
    let s = 0.35 + t * 0.9
    linea(x, y, x, y - 30 * s, semilla: 500 + i, grosor: 0.9)
    circulo-lapiz(x, y - 48 * s, 18 * s, semilla: 510 + i, grosor: 0.7)
    circulo-lapiz(x - 14 * s, y - 40 * s, 13 * s, semilla: 520 + i, grosor: 0.7)
    circulo-lapiz(x + 13 * s, y - 42 * s, 14 * s, semilla: 530 + i, grosor: 0.7)
  }

  // el letrero grande: postes, placa con doble marco y rotulado
  let (sx, sy, sw, sh) = (285, 30, 195, 108)
  for (i, px) in (315, 450).enumerate() {
    rayado(px, sy + sh, 7, 70, sep: 2.6, semilla: 600 + i, grosor: 0.5, alfa: 65%)
    linea(px, sy + sh, px, 205, semilla: 610 + i, grosor: 0.9)
    linea(px + 7, sy + sh, px + 7, 205, semilla: 620 + i, grosor: 0.9)
    linea(px - 12, 206, px + 20, 206, semilla: 630 + i, pasadas: 1, grosor: 0.6)
  }
  tapar(((sx, sy), (sx + sw, sy), (sx + sw, sy + sh), (sx, sy + sh)))
  rect-lapiz(sx, sy, sw, sh, semilla: 700, grosor: 1.2)
  rect-lapiz(sx + 7, sy + 7, sw - 14, sh - 14, semilla: 710, grosor: 0.6)
  for (i, (bx, by)) in ((sx + 14, sy + 14), (sx + sw - 14, sy + 14), (sx + 14, sy + sh - 14), (sx + sw - 14, sy + sh - 14)).enumerate() {
    circulo-lapiz(bx, by, 1.8, semilla: 720 + i, pasadas: 1, grosor: 0.6)
  }
  place(top + left, dx: sx * 1pt, dy: (sy + 3) * 1pt, box(width: sw * 1pt, height: (sh - 6) * 1pt,
    align(center + horizon, {
      set par(leading: 0.1em)
      set text(font: "Caveat", weight: 700, size: 33pt, fill: grafito)
      [PROPIEDAD #linebreak() DE DIOS]
    })))
})

// ── El Memorial de Lincoln ──────────────────────────────────────────
#let memorial-lapiz() = box(width: 190pt, height: 140pt, {
  // escalinata
  rect-lapiz(10, 126, 170, 8, semilla: 1, grosor: 0.9)
  rect-lapiz(22, 118, 146, 8, semilla: 5, grosor: 0.9)
  rect-lapiz(34, 110, 122, 8, semilla: 9, grosor: 0.9)
  // columnas con su sombra a la derecha
  for i in range(0, 8) {
    let x = 40 + i * 14.4
    linea(x, 50, x, 110, semilla: 20 + i, grosor: 0.85)
    linea(x + 9, 50, x + 9, 110, semilla: 40 + i, grosor: 0.85)
    rayado(x + 5, 50, 4, 60, sep: 2.4, semilla: 60 + i, grosor: 0.45, alfa: 60%)
    linea(x - 2, 50, x + 11, 50, semilla: 80 + i, pasadas: 1, grosor: 0.7)
  }
  // arquitrabe con rayado
  rect-lapiz(32, 38, 126, 12, semilla: 100, grosor: 0.9)
  rayado(32, 38, 126, 12, sep: 4, semilla: 101, alfa: 38%, grosor: 0.4)
  // frontón con tres marcas en el tímpano
  ruta(((24, 38), (95, 9), (166, 38)), cerrada: true, semilla: 110, grosor: 0.95)
  for dx in (-14, 0, 14) {
    linea(95 + dx, 22, 95 + dx, 29, semilla: 120 + dx, pasadas: 1, grosor: 0.6)
  }
  // sombra del suelo
  for i in range(0, 6) {
    linea(4 + i * 7, 138 + calc.rem(i, 2), 30 + i * 7, 138 + calc.rem(i, 2), semilla: 130 + i, pasadas: 1, grosor: 0.4, alfa: 50%)
  }
})

// ── «Old Glory» ─────────────────────────────────────────────────────
#let bandera-lapiz() = box(width: 130pt, height: 150pt, {
  // asta y remate
  linea(20, 12, 20, 148, semilla: 1, grosor: 1)
  linea(22.6, 12, 22.6, 148, semilla: 2, grosor: 1)
  circulo-lapiz(21.3, 8, 3.4, semilla: 3, pasadas: 1, grosor: 0.8)
  // paño: 13 franjas con ondeo
  let fx0 = 24
  let fw = 96
  let fy0 = 14
  let fh = 68
  let onda(x) = 2.4 * calc.sin((x - fx0) / 14 + 0.3)
  let xs = range(0, 13).map(i => fx0 + i * fw / 12)
  for i in range(0, 14) {
    let y = fy0 + i * fh / 13
    ruta(xs.map(x => (x, y + onda(x))), semilla: 10 + i, pasadas: 1, grosor: 0.55)
  }
  // franjas rojas: línea media
  for i in range(0, 13) {
    if calc.even(i) {
      let y = fy0 + (i + 0.5) * fh / 13
      ruta(xs.map(x => (x, y + onda(x))), semilla: 40 + i, pasadas: 1, grosor: 0.6, alfa: 65%)
    }
  }
  // bordes del paño
  linea(fx0, fy0 + onda(fx0), fx0, fy0 + fh + onda(fx0), semilla: 70, pasadas: 1, grosor: 0.7)
  linea(fx0 + fw, fy0 + onda(fx0 + fw), fx0 + fw, fy0 + fh + onda(fx0 + fw), semilla: 71, pasadas: 1, grosor: 0.7)
  // cantón: rayado denso en las dos direcciones y estrellas
  let cw = 38
  let ch = 7 * fh / 13
  rayado(fx0, fy0 - 2, cw, ch + 6, sep: 1.8, semilla: 80, grosor: 0.5, alfa: 75%)
  rayado(fx0, fy0 - 2, cw, ch + 6, sep: 1.8, semilla: 81, grosor: 0.5, alfa: 75%, inverso: true)
  for r in range(0, 4) {
    for c in range(0, 5) {
      place(top + left, dx: (fx0 + 5 + c * 7) * 1pt, dy: (fy0 + 5 + r * 8.5 + onda(fx0 + 5 + c * 7)) * 1pt,
        circle(radius: 1.2pt, fill: white, stroke: none))
    }
  }
})
