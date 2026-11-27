// ─────────────────────────────────────────────────────────────
//  plain/variants/post.typ — plain, variant: "post"
//
//  El post rápido para redes (en v1, la composición de `liso`): el texto
//  principal, un epígrafe arriba, el autor bajo el texto y la marca abajo a la
//  izquierda. Las reglas están en el encabezado de plain/plain.typ.
//
//  Es un conjunto de reglas: recibe el contexto del scaffold (plain/scaffold.typ)
//  y, además, `margin` (la opción de plain, ya en longitud).
// ─────────────────────────────────────────────────────────────

#let known = ("main", "epigraph", "author", "brand")

#let post(ctx) = {
  let (width, height, u, tm, len) = (ctx.width, ctx.height, ctx.u, ctx.tm, ctx.len)
  let r = ctx
  let p = ctx.parts
  let m = ctx.margin

  // el texto principal: `main`, o el contenido suelto
  let mp = p.at("main", default: none)
  let props = if mp == none { (:) } else { mp.props }
  let texto = if mp == none { r.loose } else if r.has-loose { mp.body + parbreak() + r.loose } else { mp.body }
  let size = props.at("size", default: 44)
  let weight = props.at("weight", default: "regular")
  let tracking = props.at("tracking", default: 0em)
  let max-size = props.at("max-size", default: 150)
  let alineado = props.at("align", default: left)
  let fit = size == auto

  let au = p.at("author", default: none)
  let ep = p.at("epigraph", default: none)
  let marca = ctx.brand

  let caja = width - 2 * m
  let pie = if marca != none { 96 * u } else { 0pt }

  let bloque(c) = block(width: caja, align(alineado, {
    text(size: c, weight: weight, tracking: tracking, texto)
    if au != none {
      let s = au.props.at("size", default: auto)
      let s = if s == auto { calc.max(24 * u, c * 0.26) } else { len(s) }
      v(c * 0.45)
      text(size: s, weight: 400, tracking: 0.01em)[— #au.body]
    }
  }))

  let ep-size = if ep == none { 0pt } else { len(ep.props.at("size", default: 34)) }
  let ep-block = if ep != none {
    let src = ep.props.at("source", default: none)
    block(width: caja, align(alineado, block(width: caja * 0.82, align(alineado, {
      text(size: ep-size, style: "italic", weight: 400, fill: tm.ink.transparentize(22%), ep.body)
      if src != none {
        v(ep-size * 0.4)
        text(size: ep-size * 0.72, weight: 600, tracking: 0.04em, fill: tm.ink.transparentize(38%))[— #src]
      }
    }))))
  }

  {
    set text(hyphenate: false)
    set par(leading: 0.28em, justify: false)

    context {
      let h-ep = if ep-block != none { measure(ep-block).height + ep-size * 1.4 } else { 0pt }
      let hueco = height - 2 * m - pie - h-ep
      let c = if fit { len(max-size) } else { len(size) }
      if fit { c = (ctx.fit-down)(bloque, c, hueco, min: 28 * u, paso: 2 * u) }
      let b = bloque(c)
      let y = m + h-ep + (hueco - measure(b).height) * 0.4
      if ep-block != none { place(top + left, dx: m, dy: m, ep-block) }
      place(top + left, dx: m, dy: y, b)
    }

    if marca != none { place(bottom + left, dx: m, dy: -m + 24 * u, marca) }
  }
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = post
