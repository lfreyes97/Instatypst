// Lámina — "La finca" v2, paisaje con un solo letrero (Cornelius Van Til)
// Variante de vantil-finca-paisaje.typ: un letrero grande en vez de cuatro, para que
// «grandes letreros… no puede sino leerlos» se cumpla a la vista.
// Concepto: la finca vista desde el camino, a color: cielo de mañana, colinas en capas y,
// sobre la colina de delante, la cerca con un letrero por hecho («UN ÁRBOL», «UNA CIFRA»,
// «UN ROSTRO», «TÚ»), todos con el sello del dueño. La cita va sobre el verde del primer
// plano. Versión paisajística de vantil-finca.typ (misma cita, misma cerca).
// Cita: C. Van Til, Why I Believe in God, sección «Early Schooling» (traducción propia).
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-finca-paisaje-letrero.typ salida/vantil-finca-paisaje-letrero.png --ppi 144
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

// Línea de colina: y(x) = base + amp·sin(x/long + fase). Devuelve la altura en pt.
#let cresta(x, base, amp, long, fase) = base * 1pt + amp * 1pt * calc.sin(x / (long * 1pt) + fase)

// Una colina rellena hasta el pie de la lámina.
#let colina(base, amp, long, fase, color) = {
  let pts = range(0, 109).map(i => {
    let x = i * 10pt
    (x, cresta(x, base, amp, long, fase))
  })
  place(top + left, curve(fill: color, stroke: none,
    curve.move((0pt, alto)),
    curve.line(pts.first()),
    ..pts.slice(1).map(p => curve.line(p)),
    curve.line((ancho, alto)),
    curve.close()))
}

// Un árbol: tronco y copa de tres círculos, apoyado en (x, y).
#let arbol(x, y, t, copa) = {
  place(top + left, dx: x - 4pt * t, dy: y - 34pt * t, rect(width: 8pt * t, height: 36pt * t, fill: madera))
  place(top + left, dx: x - 26pt * t, dy: y - 76pt * t, circle(radius: 26pt * t, fill: copa))
  place(top + left, dx: x - 8pt * t, dy: y - 92pt * t, circle(radius: 24pt * t, fill: copa.lighten(8%)))
  place(top + left, dx: x - 38pt * t, dy: y - 58pt * t, circle(radius: 22pt * t, fill: copa.darken(6%)))
}

#let nube(x, y, t) = {
  let b = white.transparentize(12%)
  place(top + left, dx: x, dy: y, ellipse(width: 190pt * t, height: 46pt * t, fill: b))
  place(top + left, dx: x + 30pt * t, dy: y - 24pt * t, circle(radius: 28pt * t, fill: b))
  place(top + left, dx: x + 80pt * t, dy: y - 36pt * t, circle(radius: 34pt * t, fill: b))
}

// El letrero: una placa grande sobre dos postes, plantada en la cresta de la colina.
#let letrero-grande(cx, w, h, rot, base) = {
  let suelo = cresta(cx, base.at(0), base.at(1), base.at(2), base.at(3)) + 10pt
  let y = 235pt
  for dx in (-w * 0.33, w * 0.33) {
    place(top + left, dx: cx + dx - 14pt, dy: y + h - 20pt, rect(width: 28pt, height: suelo - (y + h) + 20pt, fill: madera))
  }
  place(top + left, dx: cx - w / 2, dy: y,
    rotate(rot, origin: center + horizon,
      block(width: w, height: h, fill: esmalte, stroke: 10pt + tinta, radius: 16pt, inset: 0pt, {
        place(top + left, dx: 14pt, dy: 14pt, rect(width: w - 48pt, height: h - 48pt, stroke: 3pt + tinta, radius: 8pt, fill: none))
        place(center + horizon, dy: 0pt, align(center, {
          set par(leading: 0.22em)
          text(font: "Bebas Neue", size: 124pt, fill: tinta, tracking: 0.02em, top-edge: "cap-height", bottom-edge: "baseline")[PROPIEDAD #linebreak() #text(fill: rojo)[DE DIOS]]
        }))
        for (px, py) in ((30pt, 30pt), (w - 40pt, 30pt), (30pt, h - 40pt), (w - 40pt, h - 40pt)) {
          place(top + left, dx: px, dy: py, circle(radius: 6pt, fill: tinta))
        }
      })))
}

#let cerca = (610, 12, 170, 1.0) // base, amplitud, longitud de onda, fase de la colina de la cerca

#page(width: ancho, height: alto, margin: 0pt, fill: rgb("#2f6f46"))[
  // cielo
  #place(top + left, rect(width: ancho, height: 680pt,
    fill: gradient.linear(rgb("#5fb0e6"), rgb("#a9d9ee"), rgb("#fbe7ad"), angle: 90deg)))
  // sol con halo
  #place(top + left, dx: 690pt, dy: 20pt, circle(radius: 150pt, fill: rgb("#ffe39a").transparentize(70%)))
  #place(top + left, dx: 730pt, dy: 60pt, circle(radius: 110pt, fill: rgb("#ffe39a").transparentize(45%)))
  #place(top + left, dx: 765pt, dy: 95pt, circle(radius: 75pt, fill: rgb("#ffd04f")))
  // nubes
  #nube(80pt, 130pt, 1.0)
  #nube(790pt, 250pt, 0.7)
  #nube(720pt, 200pt, 0.5)

  // colinas lejanas, medias y la de la cerca
  #colina(440, 30, 140, 0.4, rgb("#9fcaa6"))
  #colina(515, 30, 120, 2.0, rgb("#7fb77a"))
  #arbol(55pt, cresta(55pt, 515, 30, 120, 2.0) + 4pt, 1.0, rgb("#3f8f4a"))
  #arbol(140pt, cresta(140pt, 515, 30, 120, 2.0) + 4pt, 0.75, rgb("#4a9a52"))
  #arbol(960pt, cresta(960pt, 515, 30, 120, 2.0) + 4pt, 0.9, rgb("#3f8f4a"))
  #arbol(1040pt, cresta(1040pt, 515, 30, 120, 2.0) + 4pt, 1.1, rgb("#4a9a52"))
  #colina(cerca.at(0), cerca.at(1), cerca.at(2), cerca.at(3), rgb("#5fa94e"))

  // riel de la cerca (sigue la colina)
  #{
    let pts = range(0, 109).map(i => {
      let x = i * 10pt
      (x, cresta(x, cerca.at(0), cerca.at(1), cerca.at(2), cerca.at(3)) - 70pt)
    })
    place(top + left, curve(stroke: 9pt + madera, curve.move(pts.first()), ..pts.slice(1).map(p => curve.line(p))))
  }
  #letrero-grande(540pt, 700pt, 330pt, -1.2deg, cerca)

  // flores en la colina de la cerca
  #for (x, y, c) in ((60, 650, "#f2b33d"), (210, 672, "#e8574a"), (275, 645, "#f6f0de"), (360, 678, "#f2b33d"),
    (520, 655, "#e8574a"), (590, 680, "#f6f0de"), (760, 650, "#f2b33d"), (820, 675, "#e8574a"),
    (900, 648, "#f6f0de"), (1010, 672, "#f2b33d")) {
    place(top + left, dx: x * 1pt, dy: y * 1pt, circle(radius: 5pt, fill: rgb(c)))
  }

  // primer plano: verde profundo donde va la cita
  #colina(720, 10, 220, 0.2, rgb("#2f6f46"))

  #place(top + left, dx: 88pt, dy: 800pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: crema)
    set par(leading: 0.46em)
    text(size: 41pt, weight: 400, style: "italic")[«Dios dice que usted vive, por así decirlo, en su finca. Y su finca tiene grandes letreros de propiedad puestos por todas partes, de modo que quien pasa incluso a setenta millas por hora no puede sino leerlos. #text(weight: 800, style: "normal", fill: rgb("#ffd04f"))[Cada hecho de este mundo] tiene grabado indeleblemente su sello.»]
  }))

  #place(bottom + left, dx: 88pt, dy: -64pt,
    text(font: "DM Mono", size: 18pt, weight: 500, tracking: 0.08em, fill: crema.darken(25%))[CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976)])
  #place(bottom + right, dx: -88pt, dy: -56pt, logo(crema, f))
]
