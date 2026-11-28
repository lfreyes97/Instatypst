// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/underline.typ — variant: "underline" (en v1, estilo "subrayado")
//
//  El rotulador como protagonista.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#f3efe6"),
    card: rgb("#fffdf8"),
    ink: rgb("#121212"),
    quiet: rgb("#5d5a55"),
    accent: rgb("#ffd43b"),
    guide: rgb("#e6e0d3"),
  )

#let variant(d) = {
  let c0 = d.c
  let c = if d.layout == "open" { open-colors(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Bricolage Grotesque", "Inter"))
  let (desde, hasta) = sizes-of(d, g, 104, 24)
  let meta = meta-of(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink, weight: 800)
    set par(leading: 0.5em, spacing: 0.8em)
    // el rotulador: una banda del acento por la mitad baja de las letras;
    // dentro, la tinta del tema (no la de la variante abierta)
    set highlight(fill: c0.accent, top-edge: 0.6em, bottom-edge: -0.14em, extent: 0.1em)
    show highlight: set text(fill: readable-on(c0.accent, c0.ink, white, black))
    let av = calc.max(L(60), calc.min(1.05 * s, L(104)))
    let tn = calc.max(L(24), 0.42 * s)
    let cita-b = {
      if d.quote-mark {
        big-quote(s, c.ink)
      }
      text(size: s, d.quote)
    }
    let nombre-b = rows(0.25 * tn, {
      text(size: tn, weight: 700, d.name)
      if d.verified { h(0.25 * tn); badge(0.86 * tn, c.ink, mark: c.card) }
    }, if meta != none { text(size: 0.86 * tn, weight: 500, fill: c.quiet, meta) })
    let cara = avatar(d.photo, d.initials, av, c0.accent, anillo: L(3) + c.ink)
    let firma = grid(columns: (av, 1fr), column-gutter: L(20), align: left + horizon, cara, nombre-b)
    let barra = { box(width: L(96), height: L(12), fill: c0.accent); v(L(26)) }
    if d.tag != none {
      block(below: L(32), box(stroke: L(2.5) + c.ink, radius: 100%, inset: (x: L(20), y: L(10)),
        text(size: 0.72 * tn, weight: 700, tracking: 0.1em, upper(d.tag))))
    }
    arrange(d.position, cita-b, { barra; firma }, cara, av + L(28), L(48),
      firma-lado: { barra; nombre-b })
  }
  sheet(d, c, "underline", contenido, desde, hasta, insets: (60, 96), font: F,
    card: (w, h, bleed) => if bleed { block(width: w, height: h, fill: c.card) } else {
      box(width: w, height: h, {
        place(dx: L(16), dy: L(16), block(width: w, height: h, fill: c.ink, radius: L(10)))
        place(block(width: w, height: h, fill: c.card, radius: L(10), stroke: L(3) + c.ink))
      })
    })
}
