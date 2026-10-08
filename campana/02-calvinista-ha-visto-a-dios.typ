// Lámina 02 · «El calvinismo: significado y usos del término» · cuadrado 1080×1080
// Concepto: la visión. Noche cerrada y, detrás de las palabras, una fuente
// de luz que abre rayos de oro tenue. La primera mitad de la frase queda en
// la penumbra; «ha visto a Dios» es lo iluminado, grande y en oro.
// Compilar: typst compile --root . --font-path Fonts campana/02-calvinista-ha-visto-a-dios.typ campana/02-calvinista-ha-visto-a-dios.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.instagram
#let noche = rgb("#0e0c0a")
#let oro = rgb("#e4c27a")
#let oro-hondo = rgb("#b8913f")
#let marfil = rgb("#d9d0c1")
#let foco = (540, 500) // de dónde sale la luz (unidades del lienzo)

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: noche)
#set text(font: "DM Serif Display", fill: marfil, lang: "es")

// ── luz: resplandor + rayos + oscurecer bordes ──
#place(rect(width: 100%, height: 100%, fill: gradient.radial(
  rgb("#3b2d16"), rgb("#1d1710"), noche,
  center: (foco.at(0) / ancho * 100%, foco.at(1) / alto * 100%), radius: 70%,
)))
// Rayos dibujados a mano: bg-rayos de superbg pierde las cuñas con
// coordenadas negativas (str() de un negativo da «−» U+2212, que el SVG
// no entiende), y acá la luz tiene que abrirse en todas direcciones.
// Anchos y brillos irregulares, para que parezca luz y no una feria.
#let rayos(n, radio, op-base, semilla) = for i in range(n) {
  let paso = 360deg / n
  let r1 = calc.rem(i * 37 + semilla * 11, 17) / 17 // pseudoazar 0..1
  let r2 = calc.rem(i * 53 + semilla * 7, 13) / 13
  let a0 = i * paso
  let a1 = a0 + paso * (0.25 + 0.45 * r1)
  let (cx, cy) = foco
  place(top + left, polygon(
    fill: oro.transparentize(100% - op-base * (0.5 + r2)),
    (cx * 1pt, cy * 1pt),
    ((cx + radio * calc.cos(a0)) * 1pt, (cy + radio * calc.sin(a0)) * 1pt),
    ((cx + radio * calc.cos(a1)) * 1pt, (cy + radio * calc.sin(a1)) * 1pt),
  ))
}
#rayos(72, 1500, 9%, 1)
#rayos(28, 1500, 5%, 4)
// la luz se apaga con la distancia: velo radial hacia la noche
#let centro-foco = (foco.at(0) / ancho * 100%, foco.at(1) / alto * 100%)
#place(rect(width: 100%, height: 100%, fill: gradient.radial(
  (noche.transparentize(100%), 0%), (noche.transparentize(85%), 22%),
  (noche.transparentize(35%), 48%), (noche, 78%), (noche, 100%),
  center: centro-foco, radius: 80%,
)))
// núcleo de luz detrás de las palabras
#place(rect(width: 100%, height: 100%, fill: gradient.radial(
  (oro.transparentize(84%), 0%), (oro.transparentize(100%), 100%),
  center: centro-foco, radius: 34%,
)))

// ── texto ──
#place(top + center, dy: 185pt, block(width: 820pt)[
  #set align(center)
  #text(size: 54pt, tracking: 0.005em)[El calvinista es el hombre que]
  #v(-26pt)
  #set par(leading: 0.08em)
  #text(size: 178pt, fill: oro, tracking: -0.02em)[ha visto \ a #text(style: "italic")[Dios.]]
])

// filete corto, firma y marca
#place(bottom + center, dy: -150pt, line(length: 90pt, stroke: 1.5pt + oro-hondo))
#place(bottom + center, dy: -92pt, text(size: 26pt, fill: marfil)[
  B. B. Warfield #h(0.4em) #text(fill: oro-hondo)[·] #h(0.4em) #text(style: "italic")[El calvinismo: significado y usos del término]
])
#place(bottom + center, dy: -40pt, logo(oro-hondo, (ancho, alto)))
