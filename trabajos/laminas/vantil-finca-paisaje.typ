// Lámina — "La finca" v2, paisaje (Cornelius Van Til)
// Concepto: la finca vista desde el camino, a color: cielo de mañana, colinas en capas y,
// sobre la colina de delante, la cerca con un letrero por hecho («UN ÁRBOL», «UNA CIFRA»,
// «UN ROSTRO», «TÚ»), todos con el sello del dueño. La cita va sobre el verde del primer
// plano. Versión paisajística de vantil-finca.typ (misma cita, misma cerca).
// Cita: C. Van Til, Why I Believe in God, sección «Early Schooling» (traducción propia).
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-finca-paisaje.typ salida/vantil-finca-paisaje.png --ppi 144
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

// Un poste con su letrero, plantado en la cresta de la colina de la cerca.
#let letrero-alto = 150pt
#let poste(cx, w, rot, hecho, base) = {
  let suelo = cresta(cx, base.at(0), base.at(1), base.at(2), base.at(3)) + 6pt
  let y = suelo - 196pt
  place(top + left, dx: cx - 9pt, dy: y - 20pt, rect(width: 18pt, height: suelo - y + 20pt, fill: madera))
  place(top + left, dx: cx - w / 2, dy: y,
    rotate(rot, origin: center + horizon,
      block(width: w, height: letrero-alto, fill: esmalte, stroke: 5.5pt + tinta, radius: 8pt, inset: 0pt, {
        place(top + left, dx: 6pt, dy: 6pt, rect(width: w - 23pt, height: letrero-alto - 23pt, stroke: 1.6pt + tinta, radius: 4pt, fill: none))
        place(top + center, dy: 15pt, text(font: "DM Mono", size: 10.5pt, weight: 500, tracking: 0.12em, fill: tinta.lighten(30%), hecho))
        place(center + horizon, dy: 9pt, align(center, text(font: "Bebas Neue", size: 40pt, fill: tinta, tracking: 0.02em, top-edge: "cap-height", bottom-edge: "baseline")[PROPIEDAD #linebreak() #text(fill: rojo)[DE DIOS]]))
        for (px, py) in ((12pt, 12pt), (w - 18pt, 12pt), (12pt, letrero-alto - 18pt), (w - 18pt, letrero-alto - 18pt)) {
          place(top + left, dx: px, dy: py, circle(radius: 3pt, fill: tinta))
        }
      })))
}

#let cerca = (610, 12, 170, 1.0) // base, amplitud, longitud de onda, fase de la colina de la cerca

#page(width: ancho, height: alto, margin: 0pt, fill: rgb("#2f6f46"))[
  // cielo
  #place(top + left, rect(width: ancho, height: 680pt,
    fill: gradient.linear(rgb("#5fb0e6"), rgb("#a9d9ee"), rgb("#fbe7ad"), angle: 90deg)))
  // sol con halo
  #place(top + left, dx: 130pt, dy: 80pt, circle(radius: 150pt, fill: rgb("#ffe39a").transparentize(70%)))
  #place(top + left, dx: 170pt, dy: 120pt, circle(radius: 110pt, fill: rgb("#ffe39a").transparentize(45%)))
  #place(top + left, dx: 205pt, dy: 155pt, circle(radius: 75pt, fill: rgb("#ffd04f")))
  // nubes
  #nube(560pt, 150pt, 1.0)
  #nube(790pt, 250pt, 0.7)
  #nube(40pt, 330pt, 0.6)

  // colinas lejanas, medias y la de la cerca
  #colina(440, 30, 140, 0.4, rgb("#9fcaa6"))
  #colina(515, 30, 120, 2.0, rgb("#7fb77a"))
  #arbol(270pt, cresta(270pt, 515, 30, 120, 2.0) + 4pt, 1.0, rgb("#3f8f4a"))
  #arbol(540pt, cresta(540pt, 515, 30, 120, 2.0) + 4pt, 0.8, rgb("#4a9a52"))
  #arbol(810pt, cresta(810pt, 515, 30, 120, 2.0) + 4pt, 1.05, rgb("#3f8f4a"))
  #arbol(1035pt, cresta(1035pt, 515, 30, 120, 2.0) + 4pt, 0.7, rgb("#4a9a52"))
  #colina(cerca.at(0), cerca.at(1), cerca.at(2), cerca.at(3), rgb("#5fa94e"))

  // riel de la cerca (sigue la colina)
  #{
    let pts = range(0, 109).map(i => {
      let x = i * 10pt
      (x, cresta(x, cerca.at(0), cerca.at(1), cerca.at(2), cerca.at(3)) - 70pt)
    })
    place(top + left, curve(stroke: 9pt + madera, curve.move(pts.first()), ..pts.slice(1).map(p => curve.line(p))))
  }
  #poste(140pt, 192pt, -2deg, [UN ÁRBOL], cerca)
  #poste(400pt, 192pt, 1.5deg, [UNA CIFRA], cerca)
  #poste(680pt, 192pt, -1.5deg, [UN ROSTRO], cerca)
  #poste(940pt, 192pt, 2.5deg, [TÚ], cerca)

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
