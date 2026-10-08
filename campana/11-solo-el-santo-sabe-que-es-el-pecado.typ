// Lámina 11 · «Salmo 51» · cuadrado 1080×1080
// Concepto: un folio de salterio. Pergamino pautado en rojo, capitular
// iluminada a dos tintas (la única de la campaña), texto en IM FELL y la
// fuente anotada al margen con una manecilla, como glosa de copista.
// Compilar: typst compile --root . --font-path Fonts campana/11-solo-el-santo-sabe-que-es-el-pecado.typ campana/11-solo-el-santo-sabe-que-es-el-pecado.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.instagram
#let tinta = rgb("#1f1610")
#let rubrica = rgb("#9e2219")
#let pergamino = rgb("#eee0bf")
#let pauta = rubrica.transparentize(72%)

#let fell = "IM FELL English"
#let fell-sc = "IM FELL English SC"
#let flores = "IM FELL FLOWERS 2"

// Caja de texto del folio (en pt).
#let x0 = 118pt
#let x1 = 838pt
#let y0 = 130pt
// Altura de la manecilla: apunta a la línea del segundo «solo».
#let glosa-y = 458pt

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: pergamino)
#set text(font: fell, fill: tinta, lang: "es", hyphenate: true)

// ── Pergamino: centro más claro, bordes tostados, grano ──
#place(rect(width: 100%, height: 100%, fill: gradient.radial(
  (rgb("#f6ecd4"), 0%), (rgb("#ecdcb6"), 58%), (rgb("#d6bd8a"), 100%),
  center: (46%, 44%), radius: 82%,
)))
#superbg.bg-malla(
  (rgb("#c9a86a"), rgb("#e9d6ac"), rgb("#c4a167")),
  puntos: ((60, 1010), (900, 120), (1040, 900)),
  radios: (180, 260, 150),
  semilla: 3,
  size: formatos.instagram,
)
#place(rect(width: 100%, height: 100%, fill: pergamino.transparentize(45%)))
#superbg.bg-patron(patron: "ruido", opacidad: 16%, size: formatos.instagram)

// ── Pautado del copista: líneas rojas que cruzan el folio ──
#for x in (x0, x1, 868pt, 1012pt) {
  place(dx: x, line(start: (0pt, 0pt), end: (0pt, alto * 1pt), stroke: 1.2pt + pauta))
}
#for y in (130pt, 868pt) {
  place(dy: y, line(start: (0pt, 0pt), end: (ancho * 1pt, 0pt), stroke: 1.2pt + pauta))
}

// ── Cabecera: banda de florones en rojo ──
#place(top + left, dx: x0, dy: 70pt, box(width: x1 - x0, height: 50pt, clip: true,
  text(font: flores, size: 40pt, fill: rubrica, repeat(gap: 6pt)[m])))

// ── Texto del salmo con capitular iluminada ──
#place(top + left, dx: x0, dy: y0, box(width: x1 - x0, height: 868pt - y0, align(horizon, block(width: 100%, {
  // Justificado sin cortar palabras (los guiones a este cuerpo se leen
  // mal en el teléfono); los florones rellenan la última línea.
  set text(size: 66pt, hyphenate: false)
  set par(justify: true, leading: 0.62em, spacing: 0pt)
  capitular-ornamentada(
    [Solo el santo sabe qué es el pecado; #text(fill: rubrica)[solo] el gozo que se pierde y luego se vuelve a encontrar se comprende plenamente.#h(0.3em)#box(width: 1fr, text(font: flores, size: 34pt, fill: rubrica, repeat(gap: 4pt)[k]))],
    alto: 3,
    hueco: 0.28em,
    estilo: "rubricada",
    desgaste: 0.35,
  )
}))))

// ── Glosa al margen: manecilla + fuente ──
#place(top + left, dx: x1 + 44pt, dy: glosa-y, block(width: 140pt, {
  set par(leading: 0.32em)
  text(font: flores, size: 58pt, fill: tinta)[2]
  v(10pt)
  text(size: 34pt, fill: rubrica, style: "italic")[Salmo]
  linebreak()
  text(size: 52pt, fill: rubrica, style: "italic")[51]
}))

// ── Pie: firma y marca ──
#place(top + left, dx: x0, dy: 944pt, block(width: x1 - x0, {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    text(font: fell-sc, size: 32pt, tracking: 1pt)[B. B. Warfield],
    logo(tinta, (ancho, alto)),
  )
}))
