// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/aura.typ — variant: "aura" (en v1, estilo "aura")
//
//  Halos vivos y tarjeta de cristal.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#120c2a"),
    card: rgb("#ffffff"),
    ink: rgb("#ffffff"),
    quiet: rgb("#ddd5f3"),
    accent: rgb("#ff4f8b"),
    guide: rgb("#ffffff"),
    deep: rgb("#7c3aed"),
    haze: rgb("#06b6d4"),
    light: rgb("#ffc069"),
  )

#let variant(d) = {
  let c0 = d.c
  let c = if d.layout == "open" { open-colors(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Outfit", "Inter"))
  let (desde, hasta) = sizes-of(d, g, 92, 24)
  let meta = meta-of(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink, weight: 500)
    set par(leading: 0.5em, spacing: 0.8em)
    show highlight: it => text(fill: c0.light, weight: 700, it.body)
    let av = calc.max(L(64), calc.min(1.15 * s, L(112)))
    let tn = calc.max(L(24), 0.44 * s)
    let cita-b = {
      if d.quote-mark {
        big-quote(s, c0.light)
      }
      text(size: s, d.quote)
    }
    let cara = avatar(d.photo, d.initials, av, c0.deep,
      anillo: (paint: gradient.linear(c0.accent, c0.light), thickness: L(5)))
    let ps = metric-pairs(d.metrics, 0.9 * tn, c.quiet)
    let nombre-b = rows(0.3 * tn, {
      text(size: tn, weight: 700, d.name)
      if d.verified { h(0.25 * tn); badge(0.86 * tn, c0.accent) }
    }, if meta != none { text(size: 0.86 * tn, fill: c.quiet, meta) },
      if ps.len() > 0 { text(size: 0.8 * tn, fill: c.quiet, ps.join(h(0.9 * tn))) })
    if d.tag != none {
      block(below: L(34), box(fill: c0.card.transparentize(84%), radius: 100%, inset: (x: L(22), y: L(10)),
        text(size: 0.74 * tn, weight: 600, fill: c.quiet, d.tag)))
    }
    arrange(d.position, cita-b,
      grid(columns: (av, 1fr), column-gutter: L(22), align: left + horizon, cara, nombre-b),
      cara, av + L(30), L(48), firma-lado: nombre-b)
  }
  // los halos: elipses con degradado radial a transparente, recortadas al área
  let halos(g) = place(top + left, dx: g.ax, dy: g.ay, box(width: g.aw, height: g.ah, clip: true, {
    let (w, h) = (g.aw, g.ah)
    let m = calc.max(w, h)
    for (fx, fy, fr, col, op) in (
      (0.15, 0.12, 0.75, c0.deep, 0%), (0.95, 0.9, 0.7, c0.accent, 10%),
      (0.92, 0.08, 0.5, c0.haze, 15%), (0.05, 0.95, 0.42, c0.light, 35%),
    ) {
      let r = fr * m
      place(dx: fx * w - r, dy: fy * h - r, circle(radius: r, stroke: none,
        fill: gradient.radial((col.transparentize(op), 0%), (col.transparentize(100%), 100%), space: oklab)))
    }
  }))
  sheet(d, c, "aura", contenido, desde, hasta, insets: (60, 100), font: F, below: halos,
    card: (w, h, bleed) => block(width: w, height: h,
      fill: c0.card.transparentize(if bleed { 90% } else { 87% }),
      radius: if bleed { 0pt } else { L(40) },
      stroke: if bleed { none } else { L(2) + c0.guide.transparentize(70%) }))
}
