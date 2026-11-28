// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/chalkboard.typ — variant: "chalkboard" (en v1, estilo "pizarra")
//
//  Encerado verde con marco de madera.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#1c2420"),
    card: rgb("#2b4237"),
    ink: rgb("#f1efe6"),
    quiet: rgb("#c4d0c5"),
    accent: rgb("#f0d878"),
    guide: rgb("#8fa79a"),
    border: rgb("#7a5634"),
  )

#let variant(d) = {
  let c0 = d.c
  let is-open = d.layout == "open"
  // abierta: la tiza va sobre la pared; si la pared es clara, tinta oscura
  let c = if is-open { open-colors(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Caveat",))
  let (desde, hasta) = sizes-of(d, g, 116, 30)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink, weight: 500)
    set par(leading: 0.42em, spacing: 0.7em)
    show highlight: it => underline(stroke: (paint: c0.accent.transparentize(15%), thickness: 0.07em, cap: "round"),
      offset: 0.14em, evade: false, text(fill: c0.accent, it.body))
    let tn = calc.max(L(30), 0.6 * s)
    let cabeza = if d.tag != none or d.date != none {
      block(below: L(40), grid(columns: (1fr, auto), column-gutter: L(24), align: (left + bottom, right + bottom),
        if d.tag != none {
          underline(stroke: L(2.5) + c.quiet, offset: 0.16em, text(size: 0.9 * tn, fill: c.quiet, d.tag))
        },
        if d.date != none { text(size: 0.8 * tn, fill: c.quiet, d.date) }))
    }
    let linea-firma = {
      text(size: tn, fill: c.quiet, [— #d.name])
      if d.verified {
        h(0.3 * tn)
        box(width: 0.8 * tn, height: 0.7 * tn, curve(stroke: (paint: c0.accent, thickness: 0.09 * tn, cap: "round", join: "round"),
          curve.move((0pt, 0.4 * tn)), curve.line((0.28 * tn, 0.68 * tn)), curve.line((0.8 * tn, 0pt))))
      }
    }
    let firma(al) = rows(0.3 * tn, align(al, linea-firma),
      if d.handle != none { align(al, text(size: 0.8 * tn, fill: c.quiet, d.handle)) })
    cabeza
    if d.position == "top" { firma(left); v(L(36)); text(size: s, d.quote) } else {
      text(size: s, d.quote); v(L(40)); align(right, firma(right))
    }
  }
  let marco = L(26)
  let encerado(w, h, bleed) = box(width: w, height: h, clip: true, {
    place(rect(width: w, height: h, fill: c0.card, stroke: none))
    // borrones de tiza mal borrada (degradados vectoriales, sin rasterizar)
    for (fx, fy, fr, op) in ((0.22, 0.3, 0.42, 7%), (0.78, 0.68, 0.5, 6%), (0.55, 0.12, 0.3, 5%)) {
      let r = fr * calc.max(w, h)
      place(dx: fx * w - r, dy: fy * h - r * 0.6, ellipse(width: 2 * r, height: 1.2 * r, stroke: none,
        fill: gradient.radial((c0.ink.transparentize(100% - op), 0%), (c0.ink.transparentize(100%), 100%))))
    }
    if not bleed {
      place(rect(width: w, height: h, fill: none, radius: L(8), stroke: marco + c0.border))
      place(rect(width: w, height: h, fill: none, radius: L(8), stroke: L(2) + c0.border.darken(30%)))
      place(dx: marco, dy: marco, rect(width: w - 2 * marco, height: h - 2 * marco, fill: none,
        stroke: L(3) + black.transparentize(70%)))
      // la repisa con dos tizas
      place(bottom + left, dy: 0pt, rect(width: w, height: L(20), fill: c0.border.darken(18%), stroke: none))
      place(bottom + left, dx: w * 0.62, dy: -L(20), rect(width: L(64), height: L(14), radius: L(5), fill: c0.ink, stroke: none))
      place(bottom + left, dx: w * 0.62 + L(84), dy: -L(20), rect(width: L(46), height: L(14), radius: L(5), fill: c0.accent, stroke: none))
    }
  })
  sheet(d, c, "chalkboard", contenido, desde, hasta, insets: (96, 96), font: F, card: encerado)
}
