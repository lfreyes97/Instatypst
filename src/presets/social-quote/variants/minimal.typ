// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/minimal.typ — variant: "minimal" (en v1, estilo "minimal")
//
//  Mucho aire, una línea.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#fafaf7"),
    card: rgb("#fafaf7"),
    ink: rgb("#111111"),
    quiet: rgb("#7d7d78"),
    accent: rgb("#e4572e"),
    guide: rgb("#d9d9d3"),
  )

#let variant(d) = {
  let c = d.c
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Inter", "Liberation Sans"))
  let (desde, hasta) = sizes-of(d, g, 76, 22)
  let meta = meta-of(d, sep: ", ")
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink, weight: 300)
    set par(leading: 0.6em, spacing: 0.9em)
    show highlight: it => text(weight: 500, it.body)
    let tn = calc.max(L(20), 0.4 * s)
    let firma = {
      box(line(length: L(48), stroke: L(2.5) + c.accent), baseline: -0.32 * tn)
      h(L(20))
      text(size: tn, weight: 500, d.name)
      if d.verified { h(0.25 * tn); badge(0.85 * tn, c.ink, mark: c.paper) }
      if meta != none { text(size: tn, fill: c.quiet, [, #meta]) }
    }
    if d.tag != none {
      block(below: L(44), text(size: 0.8 * tn, weight: 500, tracking: 0.16em, fill: c.quiet, upper(d.tag)))
    }
    if d.position == "top" { firma; v(L(56)); text(size: s, d.quote) } else {
      text(size: s, d.quote); v(L(64)); firma
    }
  }
  sheet(d + (layout: "card"), c, "minimal", contenido, desde, hasta, insets: (0, 0),
    margin: (g.L)(128), font: F)
}
