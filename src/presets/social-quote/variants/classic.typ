// ─────────────────────────────────────────────────────────────
//  presets/social-quote/variants/classic.typ — variant: "classic" (en v1, estilo "clasico")
//
//  Tarjeta blanca sobre fondo oscuro: la cita y su autor (foto o iniciales)
//  como en las tarjetas de LinkedIn. Es la variante por defecto. Muestra todos
//  los campos de contenido y es la única con `note-left` y `note-right`.
//
//  Una variante es una función `d => contenido`: `d` lo arma social-quote.typ.
//  `theme` es su tema por defecto; el filete (`guide`) es un valor fijo, como en
//  v1, y no se deriva de nada.
// ─────────────────────────────────────────────────────────────
#import "../_common.typ": *

#let theme = (
  paper: rgb("#262b36"),
  card: rgb("#ffffff"),
  ink: rgb("#1f2430"),
  quiet: rgb("#586174"),
  accent: rgb("#4f46e5"),
  guide: rgb("#e2e5ec"),
)

#let variant(d) = {
  let c = d.c
  let F = font-of(d, ("Inter", "DM Sans", "Public Sans", "Liberation Sans"))
  let (ancho, alto) = (d.artboard.at(0) * 1pt, d.artboard.at(1) * 1pt)
  let is-open = d.layout == "open"
  let texto-c = if is-open { readable-on(c.paper, c.card, c.ink) } else { c.ink }
  let suave-c = if is-open { texto-c.transparentize(30%) } else { c.quiet }
  let linea-c = if is-open { texto-c.transparentize(75%) } else { c.guide }

  // medidas pensadas sobre 1080 × 1350; el lado menor del formato manda
  let k = calc.min(d.artboard.at(0) / 1080, d.artboard.at(1) / 1350)
  let L(u) = u * k * 1pt
  let (ax, ay, aw, ah) = area-trabajo(d.artboard, area: d.area, ancla: d.anchor, quien: "social-quote")
  let margen = L(72)
  let pie = if d.brand != none { L(120) } else { 0pt }
  let bleed = d.layout == "bleed"
  let inset = if is-open { 0pt } else if bleed { L(80) } else { L(48) }
  // la tarjeta (o el texto) ocupa el área menos el margen; la de sangre, toda
  let caja-w = if bleed { aw } else { aw - 2 * margen }
  let caja-h = if bleed { ah } else { ah - 2 * margen - pie }
  let ancho-int = caja-w - 2 * inset
  let alto-int = caja-h - 2 * inset

  // la atribución crece con la cita (una cita grande pide una cara grande)
  let av-de(s) = calc.max(L(64), calc.min(1.25 * s, L(120)))
  let nombre-de(s) = calc.max(L(26), 0.5 * s)
  // el contenido opcional (handle, date, verified, tag, metrics,
  // reply): sin él, cada rama sale exactamente como antes
  let meta = meta-of(d)
  let con-meta = meta != none or d.verified
  let resp = reply-of(d.reply)
  let nombre-meta(s) = {
    let tn = nombre-de(s)
    rows(0.25 * tn, {
      text(size: tn, weight: 700, fill: texto-c, d.name)
      if d.verified { h(0.25 * tn); badge(0.86 * tn, c.accent, mark: readable-on(c.accent, white, black)) }
    }, if meta != none { text(size: 0.8 * tn, fill: suave-c, meta) })
  }
  let atribucion-bloque(s) = {
    let av = av-de(s)
    let nombre-t = if con-meta { nombre-meta(s) } else { text(size: nombre-de(s), weight: 700, fill: texto-c, d.name) }
    let cara = if d.photo != none {
      box(clip: true, radius: 100%, width: av, height: av, image(d.photo, width: av, height: av, fit: "cover"))
    } else {
      box(width: av, height: av, radius: 100%, fill: c.accent, align(center + horizon,
        text(size: av * 0.38, weight: 800, fill: readable-on(c.accent, white, black), d.initials)))
    }
    grid(columns: (av, 1fr), gutter: L(20), align: (left, left + horizon), cara, nombre-t)
  }
  let divisor = {
    v(L(32))
    line(length: 100%, stroke: 0.75pt + linea-c)
    v(L(24))
  }
  let cita-bloque(s) = {
    set par(leading: 0.5em, spacing: 0.9em)
    if d.quote-mark {
      text(size: s * 1.8, fill: c.accent, font: F, "\u{201C}")
      v(-s * 1.1)
    }
    if d.tag != none {
      block(below: L(18), text(size: calc.max(L(20), 0.42 * s), fill: suave-c, d.tag))
    }
    text(size: s, fill: texto-c, d.quote)
    if resp != none {
      let tn = nombre-de(s)
      block(above: L(28), width: 100%, stroke: 0.75pt + linea-c, radius: L(16), inset: L(24), {
        if resp.name != none or resp.handle != none {
          block(below: L(10), {
            if resp.name != none { text(size: 0.8 * tn, weight: 700, fill: texto-c, resp.name) }
            if resp.handle != none { h(0.35 * tn); text(size: 0.75 * tn, fill: suave-c, resp.handle) }
          })
        }
        text(size: calc.max(L(20), 0.66 * s), fill: texto-c, resp.text)
      })
    }
  }
  let metricas-bloque(s) = if d.metrics != none {
    let tn = nombre-de(s)
    v(L(28))
    metrics-row(d.metrics, 0.95 * tn, suave-c, size: 0.8 * tn)
  }
  // el contenido entero, a tamaño de cita `s`
  let contenido(s) = {
    set text(font: F, lang: "es")
    if d.position == "top" {
      atribucion-bloque(s); divisor; cita-bloque(s)
    } else if d.position == "bottom" {
      cita-bloque(s); divisor; atribucion-bloque(s)
    } else {
      // «side»: la cara arriba a la izquierda y la cita al lado, con el nombre debajo
      let av = av-de(s)
      grid(columns: (av + L(28), 1fr), gutter: 0pt,
        if d.photo != none {
          box(clip: true, radius: 100%, width: av, height: av, image(d.photo, width: av, height: av, fit: "cover"))
        } else {
          box(width: av, height: av, radius: 100%, fill: c.accent, align(center + horizon,
            text(size: av * 0.38, weight: 800, fill: readable-on(c.accent, white, black), d.initials)))
        },
        {
          cita-bloque(s)
          v(L(26))
          if con-meta { nombre-meta(s) } else { text(size: nombre-de(s), weight: 700, fill: texto-c, d.name) }
        },
      )
    }
    metricas-bloque(s)
  }
  let bloque(s) = block(width: ancho-int, contenido(s))

  context {
    let (desde, hasta) = sizes-of(d, (k: k), 92, 22)
    let s = fit-down(bloque, desde, alto-int, min: hasta, paso: 1pt)
    let b = bloque(s)
    let h = measure(b).height
    if h > alto-int + 0.5pt {
      panic("social-quote: la cita no cabe en el área ni al tamaño mínimo (" + repr(if d.min-size == none { 22 } else { d.min-size }) + " por cada 1080 de ancho): acórtala, usa un formato más alto, `style: \"open\"` o baja `main.min-size`")
    }
    // dónde va el recuadro: de bleed, el área entera; si no, centrado en lo que queda sobre el pie
    let (bx, by, bw, bh) = if bleed {
      (ax, ay, aw, ah)
    } else {
      (ax + margen, ay + margen + (ah - 2 * margen - pie - (h + 2 * inset)) / 2, caja-w, h + 2 * inset)
    }
    if d.layout == "card" or bleed {
      place(top + left, dx: bx, dy: by,
        block(width: bw, height: bh, fill: c.card, radius: if bleed { 0pt } else { L(24) }, inset: inset,
          align(horizon, b)))
    } else {
      place(top + left, dx: bx, dy: by, block(width: bw, b))
    }
    // notas decorativas, bajo las esquinas de la tarjeta (sobre el fondo)
    if d.layout == "card" {
      let sobre-fondo = readable-on(c.paper, c.card, c.ink)
      let nota(n, dx) = place(top + left, dx: dx, dy: by + bh + L(14),
        box(width: L(120), align(center, {
          text(size: L(40), n.icon); linebreak()
          text(font: F, size: L(22), fill: sobre-fondo, weight: 600, n.text)
        })))
      if d.note-left != none { nota(d.note-left, bx) }
      if d.note-right != none { nota(d.note-right, bx + bw - L(120)) }
    }
    if d.brand != none {
      place(top + left, dx: ax, dy: ay + ah - margen - L(40), box(width: aw, align(center,
        text(font: F, fill: readable-on(c.paper, c.card, c.ink), d.brand))))
    }
  }
}
