// Lámina 18 · El sobrenaturalismo cristiano · twitter 1600×900
// Concepto: diagrama de preposiciones. Una línea de horizonte parte el lienzo en
// cielo y tierra; a la derecha, un eje vertical ordena DE (bajo tierra, el origen),
// EN (sobre la línea) y SOBRE (por encima), hasta la cumbre: el Hecho Sobrenatural.
// Compilar: typst compile --root . --font-path Fonts campana/18-hecho-sobrenatural.typ campana/18-hecho-sobrenatural.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.twitter
#let cielo-alto = rgb("#e6dfcf")
#let cielo-bajo = rgb("#f6f2ea")
#let suelo = rgb("#ddd4c2")
#let tinta = rgb("#1f2a3a")
#let pizarra = rgb("#4a5260")
#let oro = rgb("#7d500c")

#let horizonte = 628pt
#let eje = 1268pt

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: cielo-bajo)
#set text(font: "Cormorant Garamond", fill: tinta, lang: "es", hyphenate: false)

// ── Cielo (más denso arriba) y tierra
#place(rect(width: 100%, height: horizonte, fill: gradient.linear(cielo-alto, cielo-bajo, angle: 90deg)))
#place(dy: horizonte, rect(width: 100%, height: alto * 1pt - horizonte, fill: suelo))
// estratos del suelo: rayas finas, cada vez más juntas hacia abajo
#for i in range(1, 12) {
  let y = 272 * (1 - calc.pow(0.84, i))
  place(dy: horizonte + y * 1pt, line(length: 100%, stroke: 1pt + tinta.transparentize(90% - i * 1%)))
}
#place(dy: horizonte - 1.5pt, line(length: 100%, stroke: 3pt + tinta))

// ── Preposición en Marcellus (en la cita y en el diagrama)
#let prep(s, size: 1em, color: tinta) = text(font: "Marcellus", size: size, tracking: 0.08em, fill: color, upper(s))

// ── La cita (cielo, a la izquierda)
#place(dx: 104pt, dy: 120pt, block(width: 1110pt)[
  #set par(leading: 0.34em, spacing: 0pt)
  // cortes a mano: cada preposición cae en su propio tramo de la frase
  #text(size: 60pt)[El Dios del cristiano es, sin duda, \ el Dios #prep("de", size: 0.78em) la naturaleza \ y el Dios #prep("en", size: 0.78em) la naturaleza: \ pero antes y sobre todo esto, \ es el Dios #prep("sobre", size: 0.78em) la naturaleza]
  #v(26pt)
  #text(font: "Marcellus", size: 96pt, fill: oro)[—el Hecho Sobrenatural.]
])

// ── Atribución + marca (tierra, a la izquierda)
// El logo va anclado al margen, no a continuación del texto: así no se
// corre cuando cambia su tamaño (que sale del lienzo, ver _comun.typ).
#place(dx: 104pt, dy: horizonte + 52pt, [
  #text(font: "Marcellus", size: 24pt, tracking: 0.18em)[B. B. WARFIELD] \
  #text(size: 34pt, style: "italic", fill: pizarra)[El sobrenaturalismo cristiano]
])
#place(bottom + left, dx: 104pt, dy: -64pt, logo(tinta, (ancho, alto)))

// ── Diagrama (derecha)
// eje
#place(dx: eje - 1pt, dy: 176pt, line(angle: 90deg, length: horizonte - 176pt, stroke: (paint: tinta, thickness: 2pt, dash: (2pt, 7pt), cap: "round")))
#place(dx: eje - 1pt, dy: horizonte, line(angle: 90deg, length: 150pt, stroke: 2pt + tinta))

// cumbre: el sol del Hecho Sobrenatural
#let cumbre-y = 150pt
#for k in range(16) {
  let a = k * 22.5deg
  let r1 = 38pt
  let r2 = if calc.rem(k, 2) == 0 { 78pt } else { 58pt }
  place(dx: eje + r1 * calc.cos(a), dy: cumbre-y + r1 * calc.sin(a),
    line(angle: a, length: r2 - r1, stroke: 2.5pt + oro))
}
#place(dx: eje - 26pt, dy: cumbre-y - 26pt, circle(radius: 26pt, fill: oro))

// estaciones: nodo + preposición + «la naturaleza»
// `alza`: cuánto sube el rótulo respecto del nodo (EN se apoya sobre la línea).
#let estacion(y, palabra, size, relleno: none, alza: auto, aire: 10pt) = {
  let alza = if alza == auto { size * 0.62 } else { alza }
  place(dx: eje - 11pt, dy: y - 11pt, circle(radius: 11pt, fill: if relleno == none { cielo-bajo } else { relleno }, stroke: 3pt + tinta))
  place(dx: eje + 38pt, dy: y - alza, stack(
    spacing: aire,
    prep(palabra, size: size),
    text(size: 28pt, style: "italic", fill: pizarra)[la naturaleza],
  ))
}
#estacion(400pt, "sobre", 64pt, relleno: tinta)
#estacion(horizonte, "en", 50pt, alza: 50pt, aire: 30pt)
#estacion(horizonte + 150pt, "de", 40pt)
