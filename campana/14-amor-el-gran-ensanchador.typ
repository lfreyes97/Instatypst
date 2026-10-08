// Lámina 14 · «Fortalecimiento espiritual» · twitter 1600×900
// Concepto: la tipografía hace lo que dice. «ensanchador.» está ensanchada
// (escala horizontal) hasta tocar los dos márgenes, con una cota de plano
// que mide el estirón; «estira el intelecto» se estira por espaciado hasta
// cubrir el mismo ancho. El resto queda contenido, pequeño. Syne sobre azul;
// la palabra ensanchada va en Jost, que delata la deformación (Syne ya es ancha).
// Compilar: typst compile --root . --font-path Fonts campana/14-amor-el-gran-ensanchador.typ campana/14-amor-el-gran-ensanchador.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.twitter
#let fondo = rgb("#1c2657")
#let crema = rgb("#f6efe2")
#let damasco = rgb("#ffb877")
#let syne = "Syne"

#let mx = 84pt
#let medida = ancho * 1pt - 2 * mx

// ── Fondo: azul con una retícula de plano muy tenue ──
#set page(
  width: ancho * 1pt, height: alto * 1pt,
  margin: (x: mx, top: 74pt, bottom: 64pt),
  fill: fondo,
  background: {
    superbg.bg-gradiente(parar: ((rgb("#24316c"), 0%), (fondo, 60%), (rgb("#151c45"), 100%)), angulo: 120deg)
    superbg.bg-patron(patron: "grid", color: crema, paso: 50, grosor: 1, opacidad: 5%, size: formatos.twitter)
  },
)
#set text(font: syne, fill: crema, lang: "es", top-edge: "cap-height", bottom-edge: "baseline")
#set par(spacing: 0pt, leading: 0pt)

// Ensancha `t` en horizontal hasta llenar `w` (la letra se engorda, no crece en alto).
// `y:` permite subirle un poco el alto sin perder la deformación.
#let ensanchar(t, size, w: medida, y: 100%, ..args) = context {
  let c = text(size: size, ..args, t)
  let m = measure(c).width
  block(width: w, scale(x: (w / m) * 100%, y: y, origin: top + left, reflow: true, c))
}
// Estira `t` por espaciado entre letras hasta llenar `w`.
#let estirar(t, size, w: medida, ..args) = context {
  let letras = t.clusters().len()
  let m = measure(text(size: size, ..args, t)).width
  let extra = (w - m) / (letras - 1)
  block(width: w + extra, text(size: size, tracking: extra, ..args, t))
}

// Cota de plano: línea con flechas y topes en los extremos.
#let cota(color: damasco) = {
  let punta(dir) = polygon(fill: color, ..if dir == 1 {
    ((0pt, 0pt), (18pt, -8pt), (18pt, 8pt))
  } else {
    ((0pt, 0pt), (-18pt, -8pt), (-18pt, 8pt))
  })
  block(width: 100%, height: 30pt, {
    place(left + horizon, line(angle: 90deg, length: 30pt, stroke: 2.5pt + color), dy: -15pt)
    place(right + horizon, line(angle: 90deg, length: 30pt, stroke: 2.5pt + color), dy: -15pt)
    place(left + horizon, dx: 3pt, line(length: medida - 6pt, stroke: 2.5pt + color))
    place(left + horizon, dx: 3pt, punta(1))
    place(right + horizon, dx: -3pt, punta(-1))
  })
}

#v(1fr)
#text(size: 64pt, weight: 500)[El amor es el gran]
#v(40pt)
#ensanchar("ensanchador.", 120pt, y: 150%, weight: 700, font: "Jost")
#v(34pt)
#cota()
#v(1.2fr)
#text(size: 64pt, weight: 500)[Es el amor lo que]
#v(36pt)
#estirar("estira el intelecto.", 84pt, weight: 700, fill: damasco)
#v(1.4fr)
#v(36pt)

#place(bottom + left, block(width: medida, grid(
  columns: (1fr, auto),
  align: (left + horizon, right + horizon),
  text(size: 26pt, tracking: 0.5pt)[#text(weight: 700)[B. B. Warfield] · Fortalecimiento espiritual],
  logo(crema, (ancho, alto)),
)))
