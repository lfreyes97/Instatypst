// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/chat.typ — variant: "chat" (en v1, estilo "mensaje")
//
//  Burbuja de chat con cola.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#e6e3f1"),
    card: rgb("#ffffff"),
    ink: rgb("#1b1830"),
    quiet: rgb("#6b6880"),
    accent: rgb("#6a3fd8"),
    guide: rgb("#e7e4ef"),
    dots: rgb("#d6d1e8"),
  )

#let variant(d) = {
  let c = d.c
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("DM Sans", "Inter"))
  let (desde, hasta) = sizes-of(d, g, 80, 22)
  let resp = reply-of(d.reply)
  let arriba = d.position == "top"
  let ancho-total = g.aw - 2 * g.margin
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink)
    set par(leading: 0.5em, spacing: 0.8em)
    set highlight(fill: c.accent.transparentize(80%), extent: 0.06em, radius: 0.12em)
    // un `context` propio: las medidas de aquí dentro ven los `set` de arriba
    context {
    let av = calc.max(L(56), calc.min(1.2 * s, L(96)))
    let gap = L(28)
    let relleno = calc.max(L(26), 0.62 * s)
    let tn = calc.max(L(22), 0.5 * s)
    let max-b = ancho-total - av - gap
    // lo que va dentro de la burbuja
    let cabecera = {
      text(size: tn, weight: 700, fill: c.accent, d.name)
      if d.verified { h(0.25 * tn); badge(0.85 * tn, c.accent) }
      if d.handle != none { h(0.45 * tn); text(size: 0.9 * tn, fill: c.quiet, d.handle) }
    }
    let citada = if resp != none {
      block(width: 100%, fill: c.accent.transparentize(90%), radius: L(14), inset: (left: L(26), rest: L(18)),
        stroke: (left: L(6) + c.accent), {
          if resp.name != none or resp.handle != none {
            block(below: L(8), {
              if resp.name != none { text(size: 0.85 * tn, weight: 700, fill: c.accent, resp.name) }
              if resp.handle != none { h(0.35 * tn); text(size: 0.8 * tn, fill: c.quiet, resp.handle) }
            })
          }
          text(size: calc.max(L(20), 0.62 * s), fill: c.quiet, resp.text)
        })
    }
    let cuerpo-t = text(size: s, d.quote)
    let hora = if d.date != none { text(size: 0.82 * tn, fill: c.quiet, d.date) }
    // ancho natural de la burbuja (ajusta al texto si es corto)
    let nat = calc.max(measure(cabecera).width, measure(cuerpo-t).width,
      if hora != none { measure(hora).width } else { 0pt },
      if citada != none { L(360) } else { 0pt })
    let bw = calc.min(nat + 2 * relleno, max-b)
    let r = L(40)
    let filas = (cabecera,)
    if citada != none { filas.push(citada) }
    filas.push(cuerpo-t)
    if hora != none { filas.push(grid.cell(align: right, hora)) }
    let interior = block(width: bw, inset: relleno,
      grid(columns: 1fr, row-gutter: calc.max(L(22), 0.75 * tn), ..filas))
    let bh = measure(interior).height
    let cola = if arriba {
      curve(fill: c.card, stroke: none,
        curve.move((-L(22), 0pt)), curve.line((L(30), 0pt)), curve.line((L(30), L(40))),
        curve.cubic((L(14), L(28)), (L(2), L(8)), (-L(22), 0pt)), curve.close())
    } else {
      curve(fill: c.card, stroke: none,
        curve.move((-L(22), bh)), curve.line((L(30), bh)), curve.line((L(30), bh - L(40))),
        curve.cubic((L(14), bh - L(28)), (L(2), bh - L(8)), (-L(22), bh)), curve.close())
    }
    let burbuja = box(width: bw, height: bh, {
      place(cola)
      place(block(width: bw, height: bh, fill: c.card,
        radius: if arriba { (top-left: L(6), rest: r) } else { (bottom-left: L(6), rest: r) }))
      place(interior)
    })
    let pildora = if d.metrics != none {
      let ps = metric-pairs(d.metrics, 0.95 * tn, c.quiet)
      if ps.len() > 0 {
        box(fill: c.card, radius: 100%, stroke: L(3) + c.paper, inset: (x: L(22), y: L(12)),
          text(size: 0.86 * tn, fill: c.quiet, ps.join(h(0.8 * tn))))
      }
    }
    if d.tag != none {
      block(below: L(36), width: 100%, align(center,
        box(fill: c.card.transparentize(25%), radius: 100%, inset: (x: L(26), y: L(12)),
          text(size: 0.86 * tn, weight: 500, fill: c.quiet, d.tag))))
    }
    grid(columns: (av, gap, auto), align: if arriba { top } else { bottom },
      avatar(d.photo, d.initials, av, c.accent), [], burbuja)
    if pildora != none {
      v(-L(22))
      pad(left: av + gap + L(24), pildora)
    }
    }
  }
  sheet(d + (layout: "card"), c, "chat", contenido, desde, hasta, insets: (0, 0), font: F,
    below: g => place(top + left, dx: g.ax, dy: g.ay,
      rect(width: g.aw, height: g.ah, stroke: none, fill: dot-tiling(L(40), L(2.6), c.dots))))
}
