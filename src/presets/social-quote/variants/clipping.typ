// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/clipping.typ — variant: "clipping" (en v1, estilo "recorte")
//
//  Recorte de periódico de bordes rasgados.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ
//  (la cita, el nombre, el tema `d.c` ya resuelto…). `theme` es su tema por defecto.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

#let theme = (
    paper: rgb("#2b2826"),
    card: rgb("#ece5d4"),
    ink: rgb("#1b1a18"),
    quiet: rgb("#5a554c"),
    accent: rgb("#a3191f"),
    guide: rgb("#3a3733"),
  )

// El papel rasgado: lados rectos (tijera) y bordes de arriba y abajo en
// dientes irregulares de amplitud `a`.
#let _rasgado(w, h, a, paso, relleno, semilla) = {
  let n = calc.max(2, int(calc.ceil(w / paso)))
  let r = _secuencia(2 * n + 2, semilla)
  let arriba = range(n + 1).map(i => (w * i / n, a * r.at(i)))
  let abajo = range(n + 1).map(i => (w * (n - i) / n, h - a * r.at(n + 1 + i)))
  curve(fill: relleno, stroke: none,
    curve.move(arriba.at(0)), ..arriba.slice(1).map(p => curve.line(p)),
    ..abajo.map(p => curve.line(p)), curve.close())
}

#let variant(d) = {
  let c0 = d.c
  let c = if d.layout == "open" { open-colors(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = font-of(d, ("Libre Baskerville", "Libertinus Serif"))
  let S = ("Inter", "Liberation Sans")
  let (desde, hasta) = sizes-of(d, g, 76, 22)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.ink, hyphenate: true)
    set par(leading: 0.5em, spacing: 0.75em, justify: true)
    show highlight: it => text(weight: 700, it.body)
    let tn = calc.max(L(18), 0.36 * s)
    let fecha = if d.date != none {
      block(below: L(30), {
        line(length: 100%, stroke: L(1.5) + c.guide)
        v(L(10), weak: false)
        align(center, text(font: S, size: tn, weight: 600, tracking: 0.14em, upper(d.date)))
        v(L(10), weak: false)
        line(length: 100%, stroke: L(1.5) + c.guide)
      })
    }
    let ante = if d.tag != none {
      block(below: L(18), text(font: "Bebas Neue", size: calc.max(L(30), 0.62 * s), tracking: 0.03em, fill: if d.layout == "open" { readable-on(c.paper, c0.accent, c0.accent.lighten(45%)) } else { c0.accent }, d.tag))
    }
    let foto = if d.photo != none {
      let lado = calc.max(L(80), calc.min(1.6 * s, L(150)))
      box(width: lado, height: lado, stroke: L(3) + c.ink, clip: true,
        image(d.photo, width: lado, height: lado, fit: "cover"))
    }
    let firma-t = rows(0.35 * tn, {
      set par(justify: false, leading: 0.5em)
      text(font: S, size: tn, fill: c.quiet, [Por ])
      text(font: S, size: tn, weight: 800, tracking: 0.06em, upper(d.name))
    }, if d.handle != none { text(font: S, size: 0.92 * tn, fill: c.quiet, d.handle) })
    let firma = if foto == none { firma-t } else {
      grid(columns: (auto, 1fr), column-gutter: L(22), align: left + horizon, foto, firma-t)
    }
    fecha
    ante
    // justificada solo si la cita da para muchas líneas (unas seis): corta,
    // los blancos se abren y parte palabras
    let cuerpo-t = layout(t => {
      let largo = measure(text(size: s, d.quote)).width > 6 * t.width
      set par(justify: largo)
      set text(hyphenate: largo)
      text(size: s, d.quote)
    })
    arrange(d.position, cuerpo-t, firma, foto,
      if foto != none { measure(foto).width + L(30) } else { 0pt }, L(30),
      filete: { v(L(28)); line(length: L(120), stroke: L(2) + c.guide); v(L(22)) },
      firma-lado: firma-t)
  }
  let papel-r(w, h, bleed) = if bleed { block(width: w, height: h, fill: c.card) } else {
    box(width: w, height: h, {
      place(dx: L(8), dy: L(14), _rasgado(w, h, L(14), L(18), black.transparentize(70%), 5))
      place(_rasgado(w, h, L(14), L(18), c.card, 5))
      place(rect(width: w, height: h, stroke: none, fill: grain-tile(L(80), c.ink, n: 40, radio: L(0.9), semilla: 13)))
    })
  }
  sheet(d, c, "clipping", contenido, desde, hasta, insets: (64, 96), font: S, card: papel-r)
}
