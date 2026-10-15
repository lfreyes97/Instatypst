// Demo de superbg.bg-papel, las manchas de café (generadas: bg-cafe;
// reales, del paquete LaTeX coffeestains: mancha-cafe) y superbg.tinta-gastada (src/superbg/papel.typ):
// papel viejo / escaneado y tinta gastada de imprenta, el mismo aire que
// las capitulares de EB Garamond con `desgaste:`.
// Compilar: typst compile --root . --font-path Fonts examples/papel.typ
#import "../src/lib.typ": *

#let formato = (1080, 1350)
#let hoja(cuerpo) = page(width: 1080pt, height: 1350pt, margin: 0pt, cuerpo)
#let tinta = rgb("#1c1712")
#let rotulo(c) = text(font: "DM Mono", size: 20pt, fill: tinta.lighten(25%), c)
#let fell(..args) = text(font: "IM FELL English", fill: tinta, ..args)

// 1 · los dos presets, a página entera
#hoja[
  #superbg.superbg("papel-viejo", size: formato)
  #place(top + left, dx: 80pt, dy: 80pt, rotulo[superbg("papel-viejo")])
]
#hoja[
  #superbg.superbg("papel-escaneado", size: formato)
  #place(top + left, dx: 110pt, dy: 80pt, rotulo[superbg("papel-escaneado")])
]

// 2 · parámetros de bg-papel, de a uno
#let muestra(titulo, ..args) = block(width: 100%, height: 100%, clip: true, {
  superbg.bg-papel(size: (470, 560), ..args)
  place(bottom + left, dx: 20pt, dy: -20pt, rotulo(titulo))
})
#hoja(pad(48pt, grid(
  columns: (1fr, 1fr), rows: (1fr, 1fr), gutter: 44pt,
  muestra([color: \#f4ecd8 \ manchas: 25%, oxido: 0], color: rgb("#f4ecd8"), manchas: 25%, oxido: 0),
  muestra([color: \#e3cf9c \ manchas: 90%, oxido: 24], color: rgb("#e3cf9c"), manchas: 90%, oxido: 24, semilla: 4),
  muestra([escaneo: true, lomo: "arriba"], escaneo: true, lomo: "arriba"),
  muestra([bordes: 90%, fibras: 60% \ semilla: 7], bordes: 90%, fibras: 60%, semilla: 7),
)))

// 3 · tinta-gastada: la misma palabra, de 0 a 1
#hoja[
  #superbg.bg-papel(size: formato)
  #place(top + left, dx: 80pt, dy: 80pt, rotulo[text(fill: superbg.tinta-gastada(tinta, intensidad: …))])
  #place(top + left, dx: 80pt, dy: 150pt, stack(spacing: 22pt,
    ..(0, 0.25, 0.5, 0.75, 1).map(k => grid(
      columns: (140pt, auto), align: horizon,
      rotulo[#k],
      fell(size: 150pt, fill: if k == 0 { tinta } else { superbg.tinta-gastada(tinta, intensidad: k) })[Gracia],
    )),
  ))
]

// 4 · café real: las cuatro manchas de coffeestains (dominio público),
// en café (tinte: auto) y, las dos de color, con los originales (tinte: none)
#let celda(c, ..args) = box(width: 470pt, height: 380pt, {
  place(center + horizon, superbg.mancha-cafe(cual: c, ancho: 330pt, ..args))
  place(top + left, rotulo(c + if args.named().len() > 0 { " · tinte: none" }))
})
#hoja[
  #superbg.bg-papel(size: formato, oxido: 0)
  #place(top + left, dx: 70pt, dy: 60pt, rotulo[superbg.mancha-cafe(cual: …)])
  #place(top + left, dx: 50pt, dy: 120pt, grid(
    columns: 2, column-gutter: 40pt, row-gutter: 20pt,
    ..superbg.manchas-cafe.map(c => celda(c)),
    celda("C", tinte: none), celda("D", tinte: none),
  ))
]
#hoja[
  #superbg.superbg("papel-cafe", size: formato)
  #place(top + left, dx: 80pt, dy: 80pt, rotulo[superbg("papel-cafe")])
]
// las generadas: bg-papel(cafe: n) apoya tazas en el papel; bg-cafe es
// la misma mancha como capa suelta
#hoja[
  #superbg.bg-papel(size: formato, cafe: 2)
  #place(top + left, dx: 80pt, dy: 80pt, rotulo[bg-papel(cafe: 2) — manchas generadas])
]
#hoja[
  #superbg.bg-papel(size: formato, oxido: 0)
  #place(top + left, dx: 80pt, dy: 80pt, rotulo[bg-cafe(tazas: 1, gotas: 6, intensidad: 1.3) encima del texto])
  #place(top + left, dx: 80pt, dy: 380pt, fell(size: 190pt, fill: superbg.tinta-gastada(tinta, intensidad: 0.4))[Sola \ fide.])
  #superbg.bg-cafe(tazas: 1, gotas: 6, intensidad: 1.3, radio: 190, semilla: 8, size: formato)
]

// 5 · todo junto: papel escaneado, capitular con desgaste y texto gastado
#hoja[
  #superbg.superbg("papel-escaneado", size: formato)
  #place(top + left, dx: 130pt, dy: 150pt, block(width: 820pt, {
    set par(justify: true, leading: 0.55em)
    set text(lang: "es")
    fell(size: 40pt, fill: superbg.tinta-gastada(tinta, intensidad: 0.4),
      capitular-ornamentada(desgaste: 0.5, alto: 4)[Estamos asistiendo al lecho de muerte de una palabra. Y es triste presenciar la muerte de cualquier cosa valiosa, aunque sea la de una palabra. Las palabras que mueren no se van solas: se llevan consigo la verdad que nombraban.])
    v(40pt)
    align(right, fell(size: 30pt, style: "italic", fill: superbg.tinta-gastada(tinta, intensidad: 0.4))[— B. B. Warfield])
  }))
]
