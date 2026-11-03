// Lámina — "Los lentes de colores" (Cornelius Van Til)
// Concepto: una sola palabra, HECHOS, atravesada por unos lentes. Fuera del cristal
// es tinta negra sobre crema; dentro, la misma palabra sale teñida. Es el mismo
// hecho visto a través de otras presuposiciones: no cambia el hecho, cambia el color.
// Cita: C. Van Til, Why I Believe in God (Great Commission Publications, 1976), 15
// (traducción al español). Titular: paráfrasis, no cita.
// Compilar: typst compile --root . --font-path Fonts trabajos/laminas/vantil-lentes.typ salida/vantil-lentes.png --ppi 144
#import "../../src/lib.typ": *
#import "../campana/_comun.typ": logo, formatos

#let f = formatos.instagram
#let crema = rgb("#efe9db")
#let tinta = rgb("#141414")
#let verde = rgb("#2f7d4f")
#let cristal = rgb("#cfe3c4")
#let apagado = rgb("#6d675b")

#let ancho = f.at(0) * 1pt
#let alto = f.at(1) * 1pt
#let d = 390pt // diámetro de cada lente
#let sep = 60pt // espacio entre lentes (el puente)
#let x0 = (ancho - (2 * d + sep)) / 2
#let y0 = 90pt
#let palabra-y = 204pt // posición de la palabra
#let tam = 232pt

#let palabra(color) = text(font: "Fraunces 72pt", weight: 900, size: tam, fill: color, tracking: -0.04em)[HECHOS]

// La palabra se centra en la lámina; dentro de cada lente se vuelve a dibujar
// desplazada para que coincida exactamente con la de fuera.
#let lente(x) = {
  place(top + left, dx: x, dy: y0,
    box(width: d, height: d, radius: 50%, clip: true, fill: cristal, {
      place(top + left, dx: -x, dy: palabra-y - y0, box(width: ancho, align(center, palabra(verde))))
    }))
  place(top + left, dx: x, dy: y0, circle(radius: d / 2, fill: none, stroke: 9pt + tinta))
}

#page(width: f.at(0) * 1pt, height: f.at(1) * 1pt, margin: 0pt, fill: crema)[
  // palabra base, en tinta
  #place(top + left, dy: palabra-y, box(width: ancho, align(center, palabra(tinta))))

  // montura
  #lente(x0)
  #lente(x0 + d + sep)
  // puente
  #place(top + left, dx: x0 + d - 4pt, dy: y0 + d / 2 - 70pt,
    curve(stroke: 9pt + tinta, curve.move((0pt, 40pt)), curve.cubic((20pt, -10pt), (sep - 20pt + 8pt, -10pt), (sep + 8pt, 40pt))))
  // texto
  #place(top + left, dx: 88pt, dy: 580pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: tinta)
    set par(leading: 0.42em)
    text(size: 78pt, weight: 700, tracking: -0.025em)[Nadie ve los hechos\ #text(fill: verde)[sin lentes.]]
    v(0pt)
    set par(leading: 0.5em)
    text(size: 31pt, weight: 400, style: "italic")[«Ha cementado usted sus lentes de colores a su rostro con tal firmeza que no puede quitárselos ni siquiera cuando duerme.»]
  }))

  // atribución y marca
  #place(bottom + left, dx: 88pt, dy: -64pt,
    text(font: "DM Mono", size: 18pt, tracking: 0.08em, fill: apagado)[CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976), P. 15])
  #place(bottom + right, dx: -88pt, dy: -56pt, logo(tinta, f))
]
