// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/post.typ — variant: "post" (en v1, estilo "publicacion")
//
//  Una publicación genérica de red social.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#e9edf2"),
    card: rgb("#ffffff"),
    ink: rgb("#0f1419"),
    quiet: rgb("#5b6670"),
    accent: rgb("#3f51d6"),
    guide: rgb("#e1e5ea"),
  )

#let variant(d) = {
  let c0 = d.c
  let c = if d.layout == "open" { open-colors(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Inter", "Liberation Sans"))
  let (desde, hasta) = sizes-of(d, g, 72, 22)
  let resp = reply-of(d.reply)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink)
    set par(leading: 0.5em, spacing: 0.8em)
    show highlight: it => text(fill: c.accent, weight: 600, it.body)
    let av = calc.max(L(64), calc.min(1.25 * s, L(116)))
    let tn = calc.max(L(24), 0.5 * s)
    let tm = 0.92 * tn
    let puntos = box(width: 1.3 * tn, height: 0.5 * tn,
      for i in range(3) { place(dx: i * 0.5 * tn, dy: 0.16 * tn, circle(radius: 0.1 * tn, fill: c.quiet, stroke: none)) })
    grid(columns: (av, 1fr, auto), column-gutter: L(20), align: (left + horizon, left + horizon, right + top),
      avatar(d.photo, d.initials, av, c0.accent),
      rows(0.22 * tn, {
        text(size: tn, weight: 700, d.name)
        if d.verified { h(0.25 * tn); badge(0.86 * tn, c0.accent) }
      }, if d.handle != none { text(size: tm, fill: c.quiet, d.handle) }),
      puntos)
    v(L(30))
    if d.tag != none {
      block(below: L(16), text(size: tm, fill: c.quiet, d.tag))
    }
    text(size: s, d.quote)
    if resp != none {
      let tr = calc.max(L(22), 0.7 * s)
      block(above: L(30), width: 100%, stroke: L(2) + c.guide, radius: L(22), inset: L(28), {
        if resp.name != none or resp.handle != none {
          block(below: L(12), {
            if resp.name != none { text(size: 0.85 * tn, weight: 700, resp.name) }
            if resp.handle != none { h(0.4 * tn); text(size: 0.8 * tn, fill: c.quiet, resp.handle) }
          })
        }
        text(size: tr, resp.text)
      })
    }
    if d.date != none { block(above: L(30), text(size: tm, fill: c.quiet, d.date)) }
    if d.metrics != none {
      v(L(22))
      line(length: 100%, stroke: L(2) + c.guide)
      v(L(20))
      metrics-row(d.metrics, 1.05 * tn, c.quiet, size: tm)
    }
  }
  sheet(d, c, "post", contenido, desde, hasta, insets: (56, 96), font: F,
    card: (w, h, bleed) => block(width: w, height: h, fill: c.card,
      radius: if bleed { 0pt } else { L(28) }, stroke: if bleed { none } else { L(2) + c.guide }))
}
