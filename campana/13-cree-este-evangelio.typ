// Lámina 13 · «El Espíritu de fe» · story 1080×1920
// Concepto: pasquín de tipos de madera. Bebas Neue a dos tintas (negro y
// rojo) sobre papel de periódico; cada línea compuesta a todo el ancho,
// como en la imprenta de cartel. «CREE ESTE EVANGELIO» arriba y abajo
// enmarca el pliego; las cuatro amenazas, apiladas en rojo, en el centro.
// Compilar: typst compile --root . --font-path Fonts campana/13-cree-este-evangelio.typ campana/13-cree-este-evangelio.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.story
#let papel = rgb("#ebe4d1")
#let negro = rgb("#171513")
#let rojo = rgb("#a11d14")
#let bebas = "Bebas Neue"

#let margen = 64pt
#let medida = ancho * 1pt - 2 * margen

// ── Papel de periódico: tono desparejo + grano ──
#set page(
  width: ancho * 1pt, height: alto * 1pt,
  margin: (x: margen, top: 70pt, bottom: 60pt),
  fill: papel,
  background: {
    superbg.bg-gradiente(parar: ((rgb("#f1ebdb"), 0%), (papel, 55%), (rgb("#d9cfb4"), 100%)), tipo: "radial")
    superbg.bg-patron(patron: "ruido", opacidad: 22%, size: formatos.story)
  },
)
#set text(font: bebas, fill: negro, lang: "es", top-edge: "cap-height", bottom-edge: "baseline")
#set par(spacing: 0pt, leading: 0pt)

// Una línea de tipos compuesta a todo el ancho de `w`: mide a 100pt y
// escala el cuerpo para que el renglón llene la medida exacta.
#let linea(t, w: medida, fill: negro, track: 0pt) = context {
  let m = measure(text(size: 100pt, tracking: track, t)).width
  block(width: w, text(size: 100pt * (w / m), fill: fill, tracking: track * (w / m), t))
}
#let filete(grueso: 6pt) = block(above: 0pt, below: 0pt, line(length: 100%, stroke: grueso + negro))
#let doble = block({
  line(length: 100%, stroke: 7pt + negro)
  v(5pt)
  line(length: 100%, stroke: 2pt + negro)
})

#let vacio(alto) = v(alto)

// ── Cabeza ──
#doble
#vacio(28pt)
#linea("CREE ESTE")
#vacio(22pt)
#linea("EVANGELIO,")
#vacio(44pt)
#linea("Y PODRÁS Y LO PREDICARÁS.", fill: rojo)
#vacio(38pt)
#filete(grueso: 3pt)
#vacio(40pt)

// ── Medio: los hombres y sus amenazas ──
#linea("DIGAN LOS HOMBRES LO QUE QUIERAN")
#vacio(36pt)
#grid(
  columns: (auto, 1fr),
  column-gutter: 26pt,
  // «—déjalos» de canto, como un tipo puesto en vertical.
  context {
    let alto-pila = 4 * 112pt + 3 * 46pt
    let t = text(size: 100pt, "—DÉJALOS")
    let m = measure(t).width
    let s = 100pt * (alto-pila / m)
    let caja = text(size: s, "—DÉJALOS")
    let dim = measure(caja)
    box(width: dim.height, height: dim.width, align(center + horizon,
      rotate(-90deg, reflow: true, caja)))
  },
  {
    for (i, verbo) in ("HERIR,", "RIDICULIZAR,", "PERSEGUIR,", "MATAR—").enumerate() {
      if i > 0 { v(46pt) }
      block(height: 112pt, text(size: 160pt, fill: rojo, verbo))
    }
  },
)
#vacio(42pt)
#filete(grueso: 3pt)
#vacio(40pt)

// ── Pie del cartel: la orden repetida ──
#linea("CREE ESTE EVANGELIO")
#vacio(46pt)
#linea("Y LO PREDICARÁS.", fill: rojo)
#vacio(28pt)
#doble
#place(bottom + left, grid(
  columns: (1fr, auto),
  align: (left + horizon, right + horizon),
  text(size: 36pt, tracking: 2pt)[B. B. WARFIELD #text(fill: rojo)[·] EL ESPÍRITU DE FE],
  logo(negro, (ancho, alto)),
))
