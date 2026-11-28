// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/paper.typ — variant: "paper" (en v1, estilo "papel")
//
//  Hoja crema con grano sobre cartón kraft.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#9a7a58"),
    card: rgb("#f4ead5"),
    ink: rgb("#4a3121"),
    quiet: rgb("#7a6049"),
    accent: rgb("#9c4a2a"),
    tape: rgb("#efe6c8"),
    guide: rgb("#d8c7a6"),
    grain: rgb("#8a6d4c"),
  )

#let variant(d) = {
  let c0 = d.c
  let c = if d.layout == "open" { open-colors(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Literata", "Libertinus Serif"))
  let M = ("DM Mono", "DejaVu Sans Mono")
  let (desde, hasta) = sizes-of(d, g, 84, 22)
  let meta = meta-of(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink)
    set par(leading: 0.55em, spacing: 0.8em)
    // un lavado de acuarela sepia
    set highlight(fill: c0.accent.transparentize(80%), extent: 0.08em, top-edge: "cap-height", bottom-edge: -0.12em)
    let av = calc.max(L(60), calc.min(1.1 * s, L(108)))
    let tn = calc.max(L(30), 0.82 * s)
    let tm = calc.max(L(18), 0.3 * s)
    let cita-b = {
      if d.quote-mark {
        big-quote(s, c.accent)
      }
      text(size: s, d.quote)
    }
    let nombre-b = rows(0.34 * tn, text(font: "Caveat", size: tn, weight: 600, d.name),
      if meta != none { text(font: M, size: tm, fill: c.quiet, meta) })
    let cara = avatar(d.photo, d.initials, av, c0.accent, anillo: L(2.5) + c.ink)
    if d.tag != none {
      block(below: L(30), text(font: M, size: tm, tracking: 0.08em, fill: c.quiet, upper(d.tag)))
    }
    arrange(d.position, cita-b,
      grid(columns: (av, 1fr), column-gutter: L(22), align: left + horizon, cara, nombre-b),
      cara, av + L(28), L(40),
      filete: { v(L(34)); line(length: 100%, stroke: (paint: c.guide, thickness: L(2), dash: (L(6), L(8)))); v(L(26)) },
      firma-lado: nombre-b)
  }
  let hoja(w, h, bleed) = box(width: w, height: h, {
    if not bleed {
      place(dx: L(4), dy: L(10), rect(width: w, height: h, fill: black.transparentize(84%), stroke: none))
      place(dx: L(10), dy: L(22), rect(width: w, height: h, fill: black.transparentize(92%), stroke: none))
    }
    place(rect(width: w, height: h, fill: c.card, stroke: none))
    place(rect(width: w, height: h, fill: grain-tile(L(96), c.grain, n: 70, radio: L(1.3)), stroke: none))
    if not bleed {
      // la cinta: un trozo translúcido, apenas torcido, sobre el borde de arriba
      place(top + center, dy: -L(30), rotate(-3.5deg,
        rect(width: L(230), height: L(60), fill: c.tape.transparentize(30%), stroke: L(1) + c.tape.darken(10%))))
    }
  })
  sheet(d, c, "paper", contenido, desde, hasta, insets: (72, 110), font: F, card: hoja)
}
