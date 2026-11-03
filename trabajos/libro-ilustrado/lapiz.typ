// Trazo a lápiz en vectorial: líneas con temblor, dos pasadas por trazo, extremos que se pasan
// un poco y rayado de sombreado. Todo en coordenadas FLOTANTES (puntos tipográficos) dentro del
// recuadro de la figura; cada primitiva se `place`a en el origen del recuadro.
// El «temblor» sale de un ruido determinista (misma figura, mismo dibujo), así que compilar dos
// veces da el mismo resultado.
#let grafito = rgb("#2b2b2b")

// Ruido pseudoaleatorio en [-0.5, 0.5), determinista.
#let ruido(n) = {
  let v = calc.sin(n * 12.9898 + 4.1414) * 43758.5453
  v - calc.floor(v) - 0.5
}
#let pt(x, y) = (x * 1pt, y * 1pt)
#let lerp(a, b, t) = a + (b - a) * t

// Una polilínea suave con el trazo del lápiz.
#let _trazo(pts, grosor, color, alfa) = place(top + left, curve(
  stroke: stroke(paint: color.transparentize(100% - alfa), thickness: grosor * 1pt, cap: "round", join: "round"),
  curve.move(pts.first()), ..pts.slice(1).map(q => curve.line(q))))

// Una línea recta a mano alzada de (x0, y0) a (x1, y1).
#let linea(x0, y0, x1, y1, semilla: 1, pasadas: 2, tremor: 0.7, grosor: 0.7, color: grafito, alfa: 85%) = {
  let dx = x1 - x0
  let dy = y1 - y0
  let largo = calc.sqrt(dx * dx + dy * dy)
  if largo > 0.01 {
    let ux = dx / largo
    let uy = dy / largo
    let n = calc.max(2, calc.ceil(largo / 16))
    for p in range(0, pasadas) {
      let s = semilla * 101 + p * 37
      let e0 = ruido(s) * 3
      let e1 = ruido(s + 1) * 3
      let pts = range(0, n + 1).map(i => {
        let t = i / n
        let o = ruido(s + i * 5.7 + 2) * tremor * 2
        let px = x0 + dx * t + ux * (e0 * (1 - t) + e1 * t) - uy * o
        let py = y0 + dy * t + uy * (e0 * (1 - t) + e1 * t) + ux * o
        pt(px, py)
      })
      _trazo(pts, grosor * (1 - p * 0.15), color, alfa - p * 12%)
    }
  }
}

// Una ruta de puntos [(x, y), …] (abierta o cerrada) como segmentos a mano alzada.
#let ruta(puntos, cerrada: false, semilla: 1, ..args) = {
  let n = puntos.len()
  let hasta = if cerrada { n } else { n - 1 }
  for i in range(0, hasta) {
    let (x0, y0) = puntos.at(i)
    let (x1, y1) = puntos.at(calc.rem(i + 1, n))
    linea(x0, y0, x1, y1, semilla: semilla + i * 3, ..args)
  }
}

#let rect-lapiz(x, y, w, h, semilla: 1, ..args) = ruta(((x, y), (x + w, y), (x + w, y + h), (x, y + h)), cerrada: true, semilla: semilla, ..args)

// Un arco de círculo (ángulos en grados, 0 = derecha, creciente hacia abajo) con radio irregular.
#let arco(cx, cy, r, a0, a1, semilla: 1, pasadas: 2, tremor: 0.7, grosor: 0.7, color: grafito, alfa: 85%) = {
  let n = calc.max(6, calc.ceil(calc.abs(a1 - a0) / 12))
  for p in range(0, pasadas) {
    let s = semilla * 53 + p * 29
    let pts = range(0, n + 1).map(i => {
      let a = (lerp(a0, a1, i / n) + ruido(s + 9) * 6) * 1deg
      let rr = r + ruido(s + i * 3.3) * tremor * 2
      pt(cx + rr * calc.cos(a), cy + rr * calc.sin(a))
    })
    _trazo(pts, grosor * (1 - p * 0.15), color, alfa - p * 12%)
  }
}
#let circulo-lapiz(cx, cy, r, semilla: 1, ..args) = arco(cx, cy, r, -10, 355, semilla: semilla, ..args)

// Rayado diagonal dentro de un rectángulo (sombreado).
#let rayado(x, y, w, h, sep: 3.5, semilla: 1, grosor: 0.45, alfa: 55%, inverso: false) = place(top + left, dx: x * 1pt, dy: y * 1pt,
  block(width: w * 1pt, height: h * 1pt, clip: true, {
    let k = -h
    while k < w {
      let s = semilla * 17 + int(k * 3)
      if inverso {
        linea(k + h, h, k, 0, semilla: s, pasadas: 1, tremor: 0.4, grosor: grosor, alfa: alfa)
      } else {
        linea(k, h, k + h, 0, semilla: s, pasadas: 1, tremor: 0.4, grosor: grosor, alfa: alfa)
      }
      k += sep
    }
  }))

// Relleno liso de un polígono (para tapar lo que queda detrás): papel.
#let tapar(puntos, color: white) = place(top + left, curve(fill: color, stroke: none,
  curve.move(pt(..puntos.first())), ..puntos.slice(1).map(p => curve.line(pt(..p))), curve.close()))
