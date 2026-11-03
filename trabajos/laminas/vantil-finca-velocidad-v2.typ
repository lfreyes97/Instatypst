// Lámina — "La finca a setenta millas por hora" v2 (Cornelius Van Til)
// v2: las rayas pasan a ser estelas con degradado (cola que se apaga, cabeza que brilla),
// de distinta longitud y algunas se salen por la derecha; línea de suelo bajo los postes.
// Concepto: un solo letrero de autopista, verde y de noche, visto a toda velocidad: las
// rayas pasan, el letrero no. La frase que importa es «no puede sino leerlos»: la
// evidencia obliga (cannot but read them), no deja a nadie neutral.
// Hermana de vantil-finca.typ (la cerca de letreros); misma cita, otra idea visual.
// Cita: C. Van Til, Why I Believe in God, sección «Early Schooling» (traducción propia).
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-finca-velocidad-v2.typ salida/vantil-finca-velocidad-v2.png --ppi 144
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

// Estelas de velocidad: (y, x de la cabeza, largo, grosor, ámbar?). La cola se apaga hacia la
// izquierda y la cabeza brilla; las que pasan de 1080 se salen de la lámina.
#let estelas = (
  (586, 640, 520, 3, false), (600, 980, 760, 2, false), (614, 420, 300, 2, false),
  (628, 1120, 900, 5, true), (644, 760, 560, 3, false), (658, 300, 260, 2, false),
  (672, 1040, 820, 3, false), (688, 560, 420, 4, true), (702, 880, 640, 2, false),
  (716, 1150, 780, 3, false), (732, 480, 360, 2, false), (748, 940, 700, 4, false),
)

#page(width: ancho, height: alto, margin: 0pt, fill: noche)[
  // postes y letrero
  #place(top + left, dx: 250pt, dy: 330pt, rect(width: 22pt, height: 233pt, fill: acero))
  #place(top + left, dx: ancho - 272pt, dy: 330pt, rect(width: 22pt, height: 233pt, fill: acero))
  #place(top + left, dx: 88pt, dy: 80pt,
    block(width: ancho - 176pt, height: 300pt, fill: verde, stroke: 8pt + blanco, radius: 22pt, inset: 0pt, {
      place(center + horizon, dy: 2pt, text(font: "Hanken Grotesk", weight: 800, size: 100pt, fill: blanco, tracking: -0.02em)[PROPIEDAD #linebreak() DE DIOS])
    }))

  // suelo
  #place(top + left, dy: 560pt, rect(width: ancho, height: 3pt, fill: acero.transparentize(40%)))

  // velocidad
  #for (y, cabeza, largo, grueso, ambar) in estelas {
    let color = if ambar { senal } else { blanco }
    place(top + left, dx: (cabeza - largo) * 1pt, dy: y * 1pt,
      rect(width: largo * 1pt, height: grueso * 1pt, radius: grueso * 0.5pt,
        fill: gradient.linear(color.transparentize(100%), color.transparentize(25%), angle: 0deg)))
  }

  // cita
  #place(top + left, dx: 88pt, dy: 795pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: blanco)
    set par(leading: 0.44em)
    text(size: 46pt, weight: 400, style: "italic")[«…de modo que quien pasa incluso a setenta millas por hora #text(weight: 800, style: "normal", fill: senal)[no puede sino leerlos.]»]
  }))

  #place(bottom + left, dx: 88pt, dy: -64pt,
    text(font: "DM Mono", size: 18pt, weight: 500, tracking: 0.08em, fill: blanco.darken(35%))[CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976)])
  #place(bottom + right, dx: -88pt, dy: -56pt, logo(blanco, f))
]
