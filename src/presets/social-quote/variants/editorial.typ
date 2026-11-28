// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/editorial.typ — variant: "editorial" (en v1, estilo "editorial")
//
//  Serif grande entre filetes.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = {
  let t = (
    paper: rgb("#f7f4ee"),
    card: rgb("#f7f4ee"),
    ink: rgb("#16130f"),
    quiet: rgb("#6a6257"),
    accent: rgb("#b3261e"),
  )
  t + (guide: t.ink)
}

#let variant(d) = {
  let c = d.c
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Fraunces 72pt", "Fraunces", "Libertinus Serif"))
  let S = ("Inter", "Liberation Sans") // la letra de la firma y el antetítulo
  let (desde, hasta) = sizes-of(d, g, 104, 26)
  let meta = meta-of(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink)
    set par(leading: 0.42em, spacing: 0.7em)
    show highlight: it => text(style: "italic", fill: c.accent, it.body)
    let tn = calc.max(L(20), 0.3 * s)
    let sup = {
      line(length: 100%, stroke: L(6) + c.guide)
      v(L(8), weak: false)
      line(length: 100%, stroke: L(1.5) + c.guide)
    }
    let inf = {
      line(length: 100%, stroke: L(1.5) + c.guide)
      v(L(8), weak: false)
      line(length: 100%, stroke: L(6) + c.guide)
    }
    let antetitulo = if d.tag != none {
      block(below: L(30), text(font: S, size: tn, weight: 700, tracking: 0.14em, fill: c.accent, upper(d.tag)))
    }
    let cita-b = {
      if d.quote-mark {
        big-quote(s, c.accent)
      }
      text(size: s, weight: 400, d.quote)
    }
    let firma = rows(0.45 * tn, {
      text(font: S, size: tn, weight: 700, tracking: 0.12em, upper(d.name))
      if d.verified { h(0.3 * tn); badge(0.95 * tn, c.accent) }
    }, if meta != none { text(font: S, size: 0.95 * tn, fill: c.quiet, meta) })
    let raya = box(line(length: L(56), stroke: L(4) + c.accent))
    sup
    v(L(44))
    if d.position == "side" {
      antetitulo
      grid(columns: (30%, 1fr), column-gutter: L(36), align: top,
        grid.vline(x: 1, stroke: L(1.5) + c.guide, position: start),
        { raya; v(L(18)); firma }, pad(left: L(36), cita-b))
    } else if d.position == "top" {
      antetitulo
      firma
      v(L(44))
      cita-b
    } else {
      antetitulo
      cita-b
      v(L(48))
      raya
      v(L(18))
      firma
    }
    v(L(44))
    inf
  }
  sheet(d + (layout: "card"), c, "editorial", contenido, desde, hasta, insets: (16, 16),
    margin: (g.L)(88), font: S)
}
