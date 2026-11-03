// Lámina — "La finca a setenta millas por hora" (Cornelius Van Til)
// Concepto: un solo letrero de autopista, verde y de noche, visto a toda velocidad: las
// rayas pasan, el letrero no. La frase que importa es «no puede sino leerlos»: la
// evidencia obliga (cannot but read them), no deja a nadie neutral.
// Hermana de vantil-finca.typ (la cerca de letreros); misma cita, otra idea visual.
// Cita: C. Van Til, Why I Believe in God, sección «Early Schooling» (traducción propia).
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-finca-velocidad.typ salida/vantil-finca-velocidad.png --ppi 144
#import "../../src/lib.typ": *
#import "../campana/_comun.typ": logo, formatos

#let f = formatos.instagram
#let ancho = f.at(0) * 1pt
#let alto = f.at(1) * 1pt

#let noche = rgb("#14171a")
#let verde = rgb("#0c6a3b")
#let blanco = rgb("#f4f1ea")
#let senal = rgb("#f0b323")
#let acero = rgb("#5b646b")

// Rayas de velocidad: (y, longitud, grosor, opacidad). Entran por la izquierda y se pierden
// antes del letrero; el letrero queda quieto.
#let rayas = (
  (590, 520, 3, 55), (604, 300, 2, 35), (618, 640, 4, 70), (633, 380, 2, 40),
  (647, 760, 3, 50), (662, 460, 5, 75), (677, 240, 2, 30), (691, 580, 3, 55),
  (705, 340, 2, 35), (720, 700, 4, 60),
)

#page(width: ancho, height: alto, margin: 0pt, fill: noche)[
  // postes y letrero
  #place(top + left, dx: 250pt, dy: 330pt, rect(width: 22pt, height: 190pt, fill: acero))
  #place(top + left, dx: ancho - 272pt, dy: 330pt, rect(width: 22pt, height: 190pt, fill: acero))
  #place(top + left, dx: 88pt, dy: 80pt,
    block(width: ancho - 176pt, height: 300pt, fill: verde, stroke: 8pt + blanco, radius: 22pt, inset: 0pt, {
      place(center + horizon, dy: 2pt, text(font: "Hanken Grotesk", weight: 800, size: 100pt, fill: blanco, tracking: -0.02em)[PROPIEDAD #linebreak() DE DIOS])
    }))

  // velocidad
  #for (y, largo, grueso, opa) in rayas {
    place(top + left, dx: 0pt, dy: y * 1pt,
      rect(width: largo * 1pt, height: grueso * 1pt, radius: grueso * 0.5pt, fill: blanco.transparentize((100 - opa) * 1%)))
  }

  // cita
  #place(top + left, dx: 88pt, dy: 770pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: blanco)
    set par(leading: 0.44em)
    text(size: 46pt, weight: 400, style: "italic")[«…de modo que quien pasa incluso a setenta millas por hora #text(weight: 800, style: "normal", fill: senal)[no puede sino leerlos.]»]
  }))

  #place(bottom + left, dx: 88pt, dy: -64pt,
    text(font: "DM Mono", size: 18pt, weight: 500, tracking: 0.08em, fill: blanco.darken(35%))[CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976)])
  #place(bottom + right, dx: -88pt, dy: -56pt, logo(blanco, f))
]
