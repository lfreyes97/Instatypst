// Lámina — "La finca" v3, desde el camino (Cornelius Van Til)
// Concepto: la finca vista por quien pasa en coche. La carretera se pierde en el horizonte,
// los sembrados convergen, una cerca corre junto al camino y, al borde, un letrero enorme de
// «PROPIEDAD DE DIOS»: el que pasa a setenta millas por hora no puede sino leerlo. Luz de
// atardecer (sol bajo entre colinas, cielo de azul a ámbar).
// Cita: C. Van Til, Why I Believe in God, sección «Early Schooling» (traducción propia).
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-finca-paisaje-v3.typ salida/vantil-finca-paisaje-v3.png --ppi 144
#import "../../src/lib.typ": *
#import "../campana/_comun.typ": logo, formatos

#let f = formatos.retrato
#let ancho = f.at(0) * 1pt
#let alto = f.at(1) * 1pt

#let tinta = rgb("#141414")
#let esmalte = rgb("#fbf8ef")
#let rojo = rgb("#b3261e")
#let crema = rgb("#f6f0de")
#let madera = rgb("#5a3b24")
#let ambar = rgb("#ffd04f")

#let horizonte = 520pt // y de la línea del horizonte
#let piso = 790pt // y donde acaba el paisaje y empieza el verde de la cita
#let fuga = 384pt // x del punto de fuga
#let lerp(a, b, t) = a + (b - a) * t
// t = 0 en el horizonte, 1 al pie del paisaje
#let ycamino(t) = lerp(horizonte, piso, t)
#let izq(t) = lerp(fuga - 5pt, 40pt, t) // borde izquierdo del camino
#let der(t) = lerp(fuga + 5pt, 650pt, t) // borde derecho

#let colina(base, amp, long, fase, color) = {
  let pts = range(0, 109).map(i => {
    let x = i * 10pt
    (x, base * 1pt + amp * 1pt * calc.sin(x / (long * 1pt) + fase))
  })
  place(top + left, curve(fill: color, stroke: none,
    curve.move((0pt, horizonte + 4pt)),
    curve.line(pts.first()),
    ..pts.slice(1).map(p => curve.line(p)),
    curve.line((ancho, horizonte + 4pt)),
    curve.close()))
}

#let arbol(x, y, t, copa) = {
  place(top + left, dx: x - 4pt * t, dy: y - 34pt * t, rect(width: 8pt * t, height: 36pt * t, fill: madera))
  place(top + left, dx: x - 26pt * t, dy: y - 76pt * t, circle(radius: 26pt * t, fill: copa))
  place(top + left, dx: x - 8pt * t, dy: y - 92pt * t, circle(radius: 24pt * t, fill: copa.lighten(8%)))
  place(top + left, dx: x - 38pt * t, dy: y - 58pt * t, circle(radius: 22pt * t, fill: copa.darken(6%)))
}

#let nube(x, y, t, color) = {
  place(top + left, dx: x, dy: y, ellipse(width: 220pt * t, height: 40pt * t, fill: color))
  place(top + left, dx: x + 40pt * t, dy: y - 18pt * t, ellipse(width: 120pt * t, height: 34pt * t, fill: color))
}

// El letrero: una placa enorme sobre dos postes, al borde del camino.
#let letrero-grande(cx, w, h, y, suelo, rot) = {
  for dx in (-w * 0.3, w * 0.3) {
    place(top + left, dx: cx + dx - 14pt, dy: y + h - 20pt, rect(width: 28pt, height: suelo - (y + h) + 20pt, fill: madera))
  }
  place(top + left, dx: cx - w / 2, dy: y,
    rotate(rot, origin: center + horizon,
      block(width: w, height: h, fill: esmalte, stroke: 9pt + tinta, radius: 14pt, inset: 0pt, {
        place(top + left, dx: 12pt, dy: 12pt, rect(width: w - 42pt, height: h - 42pt, stroke: 2.5pt + tinta, radius: 7pt, fill: none))
        place(center + horizon, align(center, {
          set par(leading: 0.22em)
          text(font: "Bebas Neue", size: 104pt, fill: tinta, tracking: 0.02em, top-edge: "cap-height", bottom-edge: "baseline")[PROPIEDAD #linebreak() #text(fill: rojo)[DE DIOS]]
        }))
        for (px, py) in ((26pt, 26pt), (w - 34pt, 26pt), (26pt, h - 34pt), (w - 34pt, h - 34pt)) {
          place(top + left, dx: px, dy: py, circle(radius: 5pt, fill: tinta))
        }
      })))
}

#page(width: ancho, height: alto, margin: 0pt, fill: rgb("#2f6f46"))[
  // cielo de atardecer
  #place(top + left, rect(width: ancho, height: horizonte + 10pt,
    fill: gradient.linear(rgb("#3d6fb8"), rgb("#8f8fcf"), rgb("#f2a65a"), rgb("#ffe0a1"), angle: 90deg)))
  // nubes teñidas
  #nube(560pt, 120pt, 1.0, rgb("#ffd7c0").transparentize(15%))
  #nube(90pt, 230pt, 0.8, rgb("#ffc7b0").transparentize(20%))
  #nube(700pt, 300pt, 0.6, rgb("#ffe3c8").transparentize(25%))
  // sol bajo con halo
  #place(top + left, dx: 130pt, dy: 300pt, circle(radius: 190pt, fill: rgb("#ffe6a8").transparentize(75%)))
  #place(top + left, dx: 180pt, dy: 350pt, circle(radius: 140pt, fill: rgb("#ffe6a8").transparentize(50%)))
  #place(top + left, dx: 235pt, dy: 405pt, circle(radius: 85pt, fill: rgb("#ffcf4a")))

  // colinas lejanas
  #colina(480, 22, 130, 0.6, rgb("#8a86c9"))
  #colina(505, 16, 100, 2.2, rgb("#6b9f86"))

  // sembrados: campo y franjas que convergen en el punto de fuga
  #place(top + left, dy: horizonte, rect(width: ancho, height: piso - horizonte, fill: rgb("#58a34d")))
  #for (i, xb) in (-420, -300, -180, -60, 560, 700, 840, 980, 1120, 1260, 1400).enumerate() {
    let c = if calc.even(i) { rgb("#6bb25a") } else { rgb("#4a9645") }
    place(top + left, curve(fill: c, stroke: none,
      curve.move((fuga, horizonte)),
      curve.line((xb * 1pt, piso)),
      curve.line(((xb + 120) * 1pt, piso)),
      curve.close()))
  }

  // camino y su raya central
  #place(top + left, curve(fill: rgb("#3e434a"), stroke: none,
    curve.move((izq(0), horizonte)), curve.line((der(0), horizonte)),
    curve.line((der(1), piso)), curve.line((izq(1), piso)), curve.close()))
  #for k in range(0, 7) {
    let t0 = 0.08 + k * 0.14
    let t1 = t0 + 0.07
    let cx(t) = lerp(fuga, 345pt, t)
    place(top + left, curve(fill: rgb("#f3e6b0"), stroke: none,
      curve.move((cx(t0) - 1pt - 7pt * t0, ycamino(t0))), curve.line((cx(t0) + 1pt + 7pt * t0, ycamino(t0))),
      curve.line((cx(t1) + 1pt + 7pt * t1, ycamino(t1))), curve.line((cx(t1) - 1pt - 7pt * t1, ycamino(t1))), curve.close()))
  }
  // arcén claro del lado derecho
  #place(top + left, curve(fill: none, stroke: 3pt + rgb("#f3e6b0").transparentize(40%),
    curve.move((der(0.05), ycamino(0.05))), curve.line((der(1), piso))))

  // cerca junto al camino (poste y alambre, de lejos a cerca)
  #{
    let ts = (0.1, 0.2, 0.32, 0.47)
    let punta(t) = (der(t) + 16pt + 30pt * t, ycamino(t) - 44pt * t - 6pt)
    place(top + left, curve(stroke: 3pt + madera, curve.move(punta(ts.first())), ..ts.slice(1).map(t => curve.line(punta(t)))))
    for t in ts {
      let (px, py) = punta(t)
      place(top + left, dx: px - 5pt * (0.4 + t), dy: py, rect(width: 10pt * (0.4 + t), height: 50pt * t + 8pt, fill: madera))
    }
  }

  // árboles del lado izquierdo, de lejos a cerca
  #for (t, copa) in ((0.12, "#3f8f4a"), (0.24, "#4a9a52"), (0.4, "#3f8f4a"), (0.62, "#4a9a52")) {
    arbol(izq(t) - 55pt * (0.3 + t), ycamino(t) + 4pt, 0.25 + t * 1.1, rgb(copa))
  }

  // el letrero grande, al borde derecho
  #letrero-grande(790pt, 500pt, 270pt, 275pt, 720pt, -1.5deg)

  // primer plano: el verde donde va la cita
  #place(top + left, dy: piso, rect(width: ancho, height: alto - piso, fill: rgb("#2f6f46")))

  #place(top + left, dx: 88pt, dy: 850pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: crema)
    set par(leading: 0.46em)
    text(size: 38pt, weight: 400, style: "italic")[«Dios dice que usted vive, por así decirlo, en su finca. Y su finca tiene grandes letreros de propiedad puestos por todas partes, de modo que quien pasa incluso a setenta millas por hora #text(weight: 800, style: "normal", fill: ambar)[no puede sino leerlos.] Cada hecho de este mundo tiene grabado indeleblemente su sello.»]
  }))

  #place(bottom + left, dx: 88pt, dy: -64pt,
    text(font: "DM Mono", size: 18pt, weight: 500, tracking: 0.08em, fill: crema.darken(25%))[CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976)])
  #place(bottom + right, dx: -88pt, dy: -56pt, logo(crema, f))
]
