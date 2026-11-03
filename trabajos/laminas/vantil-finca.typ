// Lámina — "La finca" (Cornelius Van Til)
// Concepto: la finca de Dios con sus letreros de propiedad. Una cerca de postes y, en cada
// poste, el letrero de un hecho distinto: todo hecho lleva puesto el sello del dueño.
// Amarillo de señal de tránsito (se lee a toda velocidad) y letreros blancos de esmalte.
// Cita: C. Van Til, Why I Believe in God, sección «Early Schooling» (traducción propia del
// inglés; «setenta millas por hora» es literal del original, unos 113 km/h).
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-finca.typ salida/vantil-finca.png --ppi 144
#import "../../src/lib.typ": *
#import "../campana/_comun.typ": logo, formatos

#let f = formatos.retrato
#let ancho = f.at(0) * 1pt
#let alto = f.at(1) * 1pt

#let senal = rgb("#f0b323")
#let tinta = rgb("#141414")
#let esmalte = rgb("#fbf8ef")
#let rojo = rgb("#b3261e")

#let suelo = 650pt // línea del suelo

// Un poste con su letrero. `cx` es el centro, `y` la altura del borde superior del
// letrero, `rot` su inclinación.
#let alto-letrero = 190pt
#let poste(cx, y, w, rot, hecho) = {
  // el poste
  place(top + left, dx: cx - 13pt, dy: y - 40pt, rect(width: 26pt, height: suelo - y + 40pt, fill: tinta))
  // el letrero
  place(top + left, dx: cx - w / 2, dy: y,
    rotate(rot, origin: center + horizon,
      block(width: w, height: alto-letrero, fill: esmalte, stroke: 7pt + tinta, radius: 10pt, inset: 0pt, {
        place(top + left, dx: 8pt, dy: 8pt, rect(width: w - 30pt, height: alto-letrero - 30pt, stroke: 2pt + tinta, radius: 5pt, fill: none))
        place(top + center, dy: 20pt, text(font: "DM Mono", size: 14pt, weight: 500, tracking: 0.12em, fill: tinta.lighten(30%), hecho))
        place(center + horizon, dy: 12pt, align(center, text(font: "Bebas Neue", size: 50pt, fill: tinta, tracking: 0.02em, top-edge: "cap-height", bottom-edge: "baseline")[PROPIEDAD #linebreak() #text(fill: rojo)[DE DIOS]]))
        for (px, py) in ((19pt, 19pt), (w - 27pt, 19pt), (19pt, alto-letrero - 27pt), (w - 27pt, alto-letrero - 27pt)) {
          place(top + left, dx: px, dy: py, circle(radius: 3.5pt, fill: tinta))
        }
      })))
}

#page(width: ancho, height: alto, margin: 0pt, fill: senal)[
  // cerca: riel y suelo
  #place(top + left, dy: 410pt, rect(width: ancho, height: 16pt, fill: tinta))
  #place(top + left, dy: suelo, rect(width: ancho, height: 14pt, fill: tinta))

  #poste(135pt, 175pt, 235pt, -2.5deg, [UN ÁRBOL])
  #poste(395pt, 250pt, 235pt, 2deg, [UNA CIFRA])
  #poste(685pt, 165pt, 235pt, -1.5deg, [UN ROSTRO])
  #poste(945pt, 255pt, 235pt, 3deg, [TÚ])

  #place(top + left, dx: 88pt, dy: 770pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: tinta)
    set par(leading: 0.46em)
    text(size: 43pt, weight: 400, style: "italic")[«Dios dice que usted vive, por así decirlo, en su finca. Y su finca tiene grandes letreros de propiedad puestos por todas partes, de modo que quien pasa incluso a setenta millas por hora no puede sino leerlos. #text(weight: 800, style: "normal")[Cada hecho de este mundo] tiene grabado indeleblemente su sello.»]
  }))

  #place(bottom + left, dx: 88pt, dy: -64pt,
    text(font: "DM Mono", size: 18pt, weight: 500, tracking: 0.08em, fill: tinta.lighten(25%))[CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976)])
  #place(bottom + right, dx: -88pt, dy: -56pt, logo(tinta, f))
]
