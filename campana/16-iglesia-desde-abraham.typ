// Lámina 16 · La polémica del pedobautismo · retrato 1080×1350
// Concepto: una línea de tiempo vertical sin cortes, de «Abraham · Génesis 17»
// arriba hasta «hoy» abajo. Las tres frases son estaciones sobre la línea; las
// muescas son generaciones. La última frase es el remate: nadie cortó la línea.
// Compilar: typst compile --root . --font-path Fonts campana/16-iglesia-desde-abraham.typ campana/16-iglesia-desde-abraham.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.retrato
#let arena = rgb("#f1e9dc")
#let tinta = rgb("#2a2420")
#let oxido = rgb("#9a3a1c")
#let suave = rgb("#6b5e52")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: arena)
#set text(font: "Literata", fill: tinta, lang: "es", hyphenate: false)
#set par(leading: 0.42em)

// Geometría de la línea
#let eje = 132pt          // x de la línea
#let arriba = 128pt       // y del nodo «Abraham»
#let abajo = 1150pt       // y del nodo «hoy»
#let texto-x = 196pt
#let texto-w = ancho * 1pt - texto-x - 92pt

#let rotulo(cuerpo, color: oxido) = text(
  font: "Jost", size: 25pt, weight: 600, tracking: 0.16em, fill: color, upper(cuerpo),
)

// ── Fondo: grano muy leve de papel
#place(superbg.bg-patron(patron: "dots", color: tinta, paso: 22, opacidad: 5%, size: formatos.retrato))

// ── La línea: un solo trazo continuo + muescas de generaciones
#place(dx: eje - 2pt, dy: arriba, rect(width: 4pt, height: abajo - arriba, fill: tinta))
#for y in range(int(arriba / 1pt) + 30, int(abajo / 1pt) - 14, step: 22) {
  place(dx: eje - 13pt, dy: y * 1pt, line(length: 9pt, stroke: 1.6pt + tinta.transparentize(55%)))
}

// Nodo de origen (rombo) y nodo de llegada (anillo)
#place(dx: eje - 17pt, dy: arriba - 17pt, rotate(45deg, rect(width: 24pt, height: 24pt, fill: oxido)))
#place(dx: texto-x, dy: arriba - 16pt, rotulo[Abraham · Génesis 17])

#place(dx: eje - 15pt, dy: abajo - 15pt, circle(radius: 15pt, fill: arena, stroke: 4pt + tinta))
#place(dx: texto-x, dy: abajo - 16pt, rotulo(color: tinta)[Hoy])

// ── Estaciones
#let nodo(r: 11pt, relleno: arena, borde: tinta) = circle(radius: r, fill: relleno, stroke: 3.5pt + borde)

// Repartidas a lo largo de la línea (el tiempo pasa entre una y otra); el
// remate queda junto a «hoy»: es un perfecto, vale hasta el presente.
#let estacion(y, cuerpo, r: 11pt, relleno: arena, borde: tinta, dy-nodo: 14pt) = {
  place(dx: eje - r, dy: y + dy-nodo, nodo(r: r, relleno: relleno, borde: borde))
  place(dx: texto-x, dy: y, block(width: texto-w, cuerpo))
}

#estacion(236pt, text(size: 54pt)[Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos.])
#estacion(580pt, text(size: 54pt)[Deben permanecer allí hasta que Él los saque.])
#estacion(
  880pt, r: 20pt, relleno: oxido, borde: oxido, dy-nodo: 26pt,
  text(size: 84pt, weight: 600, style: "italic", fill: oxido)[#set par(leading: 0.3em); Él en ninguna parte los ha sacado.],
)

// ── Pie: atribución + marca
#place(dx: texto-x, dy: 1222pt, block(width: texto-w)[
  #set text(font: "Jost", size: 24pt, fill: suave)
  #grid(
    columns: (1fr, auto),
    align: (left + bottom, right + bottom),
    [#text(weight: 600, fill: tinta)[B. B. Warfield] \ La polémica del pedobautismo],
    logo(tinta, (ancho, alto)),
  )
])
