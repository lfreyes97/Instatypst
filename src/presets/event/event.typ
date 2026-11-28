// ─────────────────────────────────────────────────────────────
//  event.typ — el preset `event` (en v1, `carteles.evento`)
//
//  event = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): date, headline, prose, tag, call,
//  brand; cada uno también como argumento (`call: […]`).
//  Opción del preset: margin; el resto viaja en las propiedades de los
//  elementos (headline.size, prose.size, tag.font), en el tema y en `fonts`.
//
//  La fecha como protagonista: el día enorme y, a su lado, el mes en versalitas
//  espaciadas. Bajo un filete baja el título (headline), con el detalle (prose:
//  lugar, hora…) y, al pie, la llamada a la acción (call) en una píldora de
//  contorno y la marca. El título se achica solo hasta caber entre el filete y
//  el pie.
//
//  La fecha (v1 `dia`, `mes`): la tabla manda ambos a `date`. Va entera en su
//  cuerpo y se parte por el salto de línea: `#date[14 \ nov]`, arriba el día y
//  abajo el mes (como la glosa de folio; decisiones-traduccion.md).
//
//  Escala: las medidas son pt absolutos y proporciones del lado menor, como en
//  v1 (no usa `k`). En las propiedades, número = u y longitud = absoluta.
//
//  Fuentes: Literata (cuerpo) y Jost (rótulos), las de v1. Ninguna pareja de
//  typography las trae juntas; se toman los tokens por `ctx.font`. `fonts:`
//  sobreescribe el cuerpo; `tag(font: …)`, la de los rótulos (v1
//  `fuente-rotulos`: la etiqueta, el mes, el detalle y la llamada).
//
//  Roles del tema: los cinco (v1 `fondo`, `tinta`, `suave`, `acento`).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame

#let _default-theme = (
  paper: rgb("#101826"),
  ink: rgb("#f2ece0"),
  quiet: rgb("#adb6c2"),
  accent: rgb("#ff8a5c"),
  // sin `guide`: v1 no lo tenía y event no lo usa; modules/color lo deriva
)

// Las líneas de un cuerpo, partidas por el salto de línea o de párrafo, sin los
// espacios de los bordes.
#let _date-lines(body) = {
  let kids = if body.has("children") { body.children } else { (body,) }
  let out = ((),)
  for c in kids {
    if repr(c.func()) in ("parbreak", "linebreak") { out.push(()) } else { out.last().push(c) }
  }
  let blanco(c) = repr(c.func()) == "space"
  out.map(l => {
    while l.len() > 0 and blanco(l.first()) { l = l.slice(1) }
    while l.len() > 0 and blanco(l.last()) { l = l.slice(0, -1) }
    l.join()
  }).filter(l => l != none)
}

#let _rules(ctx, margin) = {
  let part(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { none } else { p.body }
  }
  let props(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { (:) } else { p.props }
  }
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, quiet, accent) = (tm.ink, tm.quiet, tm.accent)
  let brand = ctx.brand
  let (day, month) = {
    let d = part("date")
    if d == none { (none, none) } else {
      let ls = _date-lines(d)
      (ls.at(0, default: none), ls.at(1, default: none))
    }
  }
  let headline = part("headline")
  let detail = part("prose")
  let tag = part("tag")
  let call = part("call")

  let margin = (ctx.len)(margin)
  let util = width - 2 * margin
  let size-headline = if "size" in props("headline") { (ctx.len)(props("headline").size) } else { 116pt }
  let size-detail = if "size" in props("prose") { (ctx.len)(props("prose").size) } else { 40pt }

  let body-font = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("literata") }
  let tag-font = props("tag").at("font", default: none)
  let label-font = (ctx.font)(if tag-font == none { "jost" } else { tag-font })

  // El número se escala con el lado menor: legible en cualquier formato. En los
  // más altos que 4:5 (story) fecha y título crecen con la proporción, para que
  // el hueco del medio no se coma la pieza.
  let side = calc.min(width, height)
  let tall = if height / width > 1.5 { height / width / 1.25 } else { 1 }
  let size-day = side * 0.30 * tall
  let size-month = side * 0.062 * tall

  set text(font: body-font, fill: ink, lang: "es", hyphenate: false)
  set par(leading: 0.32em)

  // ── La fecha, arriba
  let y = margin
  if tag != none {
    place(dx: margin, dy: y, text(
      font: label-font, size: 0.0245 * side, weight: 600, tracking: 0.22em, fill: accent, upper(tag),
    ))
    y += 0.06 * side
  }
  let date-block = if day == none and month == none { none } else {
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.04 * side,
      align: bottom,
      text(size: size-day, weight: 800, tracking: -0.03em, top-edge: "cap-height", bottom-edge: "baseline", [#day]),
      pad(bottom: 0.012 * size-day, text(
        font: label-font, size: size-month, weight: 700, tracking: 0.12em, fill: accent, upper([#month]),
      )),
    )
  }
  if date-block != none { place(dx: margin, dy: y, date-block) }
  context {
    let date-height = if date-block == none { 0pt } else { measure(date-block).height }
    let y-rule = y + date-height + 0.045 * side
    place(dx: margin, dy: y-rule, line(length: util, stroke: 3pt + accent))

    // ── El pie: llamada y marca, en la misma línea
    let footer = if call != none or brand != none {
      let pill = if call != none {
        box(
          stroke: 3pt + accent, radius: 100pt, inset: (x: 38pt, y: 20pt),
          text(font: label-font, size: 30pt, weight: 700, fill: accent, call),
        )
      }
      grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        pill, brand,
      )
    }
    let footer-height = if footer != none { measure(block(width: util, footer)).height } else { 0pt }
    let y-footer = height - margin - footer-height
    if footer != none { place(dx: margin, dy: y-footer, block(width: util, footer)) }

    // ── Título y detalle, abajo, sobre el pie; el título se achica hasta caber
    let gap = if footer != none { 0.05 * side } else { 0pt }
    let y1 = y-footer - gap
    let y0 = y-rule + 0.05 * side
    let detail-block = if detail != none {
      block(width: util, text(font: label-font, size: size-detail, fill: quiet, detail))
    }
    // el aire entre título y detalle crece con el título (los descendentes no tocan)
    let air(s) = 0.9 * size-detail + 0.1 * s
    let detail-height = if detail-block != none { measure(detail-block).height + air(size-headline * tall) } else { 0pt }
    let make-headline(s) = block(width: util, text(size: s, weight: 700, tracking: -0.015em, if headline == none { [] } else { headline }))
    let s = (ctx.fit-down)(make-headline, size-headline * tall, y1 - y0 - detail-height, min: 44pt, paso: 2pt)
    let stack = {
      make-headline(s)
      if detail-block != none {
        v(air(s))
        detail-block
      }
    }
    place(dx: margin, dy: y1 - measure(block(width: util, stack)).height, block(width: util, stack))
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  margin: 84pt,
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  theme: theme,
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: _default-theme,
  default-fonts: none,
  known: ("date", "headline", "prose", "tag", "call", "brand"),
  fn: "event",
  elements: elements,
  rules: ctx => _rules(ctx, margin),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "event", make: make, variants: ())
#let event = frame.with(preset: preset)
