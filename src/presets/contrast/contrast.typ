// ─────────────────────────────────────────────────────────────
//  contrast.typ — el preset `contrast` (en v1, `carteles.contraste`)
//
//  contrast = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): headline, main, author, work, brand;
//  cada uno también como argumento (`author: […]`). Además lee de su cuerpo los
//  dos `versus` (ver abajo).
//  Opciones del preset: layout, margin; el resto viaja en el tema (paper, ink,
//  quiet, accent y los roles propios `affirm` y `deny`), en `fonts` y en las
//  propiedades de los elementos (main.size, headline.size, tag.font).
//
//  Dos lados enfrentados: dos paneles tintados —uno con el color de lo que se
//  niega (`deny`, a la izquierda), otro con el de lo que se afirma (`affirm`, a
//  la derecha)— y, en la juntura, un medallón. Cada lado lleva un rótulo corto,
//  un título y una lista de ítems con su marcador: anillo vacío (niega) o círculo
//  lleno (afirma).
//
//  El contenido (v1: `izquierda` y `derecha`, diccionarios):
//    · cada LADO es un `versus[…]`; el primero va a la izquierda, el segundo a la
//      derecha (`read-parts` guarda uno solo por nombre, por eso el preset
//      recorre el cuerpo y toma los dos en orden).
//    · dentro de un `versus`: `tag[…]` es el rótulo (v1 `rotulo`, en versalitas),
//      `subhead[…]` el título del lado (v1 `titulo`) y un `list` de la librería
//      estándar los ítems (v1 `items`), entregado entero.
//    · `headline` es el titular sobre los dos lados (v1 `titulo`); `headline(size:)`
//      su cuerpo (v1 `cuerpo-titular`) y `main(size:)` el de los ítems (v1
//      `cuerpo`). `tag(font:)` es la fuente de los rótulos (v1 `fuente-rotulos`).
//      Número = u, longitud = absoluta.
//    · `layout`: auto | "columns" | "rows" (v1 `disposicion`: auto, "columnas",
//      "filas"). auto = columnas salvo en formatos más altos que 4:5, donde los
//      lados se apilan.
//
//  Los ítems se achican en la misma proporción (de a 5 %) hasta que ambos lados
//  caben en su panel; si sobra sitio crecen hasta 1,6 (como en v1).
//
//  Escala: pt absolutos, como en v1 (no usa `k`).
//
//  Fuentes: Literata (cuerpo) y Jost (rótulos y medallón), las de v1. Ninguna
//  pareja de typography trae Literata con Jost; se toman los tokens por
//  `ctx.font` y `fonts:` sobreescribe el rol body.
//
//  Pendientes (ver el informe):
//    · el medallón (v1 `medallon`, recurso `medallion` que aún no existe) se dibuja
//      siempre, con «vs»; no se puede cambiar ni quitar.
//    · el rol por ítem y por lado (v1 `(texto:, rol:)` y `rol:` del lado) no tiene
//      destino decidido: el rol de los ítems es siempre el del lado.
//    · el tamaño del título de cada lado (v1 `cuerpo-titulo`, 58 pt) tampoco: la
//      tabla lo manda a headline.size, que ya es el del titular.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame

// el mismo tema que contraste en v1: papel cálido; `affirm` (verde) y `deny`
// (ladrillo) tiñen los dos lados
#let _default-theme = (
  paper: rgb("#f4efe6"),
  ink: rgb("#1f2328"),
  quiet: rgb("#5f656c"),
  accent: rgb("#1f2328"),
  // sin `guide`: v1 no lo tenía y contrast no lo usa; modules/color lo deriva
  affirm: rgb("#2c6a4a"),
  deny: rgb("#a23a2c"),
)

// (`list` tiene `children` pero es un grupo, no una secuencia: no se aplana)
#let _flatten(c) = if c.func() != list and c.has("children") { c.children.map(_flatten).flatten() } else { (c,) }

#let _is(c, kind) = c.func() == metadata and type(c.value) == dictionary and c.value.at("kind", default: none) == kind

// Un lado: (tag:, title:, items:); tag y title con su cuerpo y propiedades.
#let _side(versus) = {
  let tag = none
  let title = none
  let items = ()
  for c in _flatten(versus.body) {
    if _is(c, "tag") { tag = c.value } else if _is(c, "subhead") { title = c.value } else if c.func() == list {
      items += c.children.map(i => i.body)
    } else if c.func() == list.item { items.push(c.body) }
  }
  (tag: tag, title: title, items: items)
}

#let _rules(ctx, layout, margin) = {
  let part(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { none } else { p.body }
  }
  let props(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { (:) } else { p.props }
  }
  let author = part("author")
  let work = part("work")
  let headline = part("headline")
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, quiet, paper) = (tm.ink, tm.quiet, tm.paper)
  let (affirm, deny) = (tm.affirm, tm.deny)
  let brand = ctx.brand
  let margin = (ctx.len)(margin)

  let body-size = if "size" in props("main") { (ctx.len)(props("main").size) } else { 38pt }
  let title-size = 58pt
  let headline-size = if "size" in props("headline") { (ctx.len)(props("headline").size) } else { 72pt }
  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("literata") }
  let label-font(side) = if side.tag != none and "font" in side.tag.props { (ctx.font)(side.tag.props.font) } else { (ctx.font)("jost") }
  let medallion-font = (ctx.font)("jost")

  // los dos lados, en el orden del cuerpo: deny a la izquierda, affirm a la derecha
  let sides = _flatten(ctx.body).filter(c => _is(c, "versus")).map(c => _side(c.value)).slice(0, 2)
  let sides = sides.zip((deny, affirm), (true, false)).map(((s, color, denies)) => (..s, color: color, denies: denies))

  let in-columns = if layout == auto { width / height >= 0.75 } else { layout == "columns" }

  // marcador de un ítem, del tamaño del texto
  let marker(side, c) = {
    let r = 0.30 * c
    box(width: 2 * r, height: 2 * r, if side.denies {
      circle(radius: r, stroke: 0.1 * c + 0pt + side.color, fill: none)
    } else {
      circle(radius: r, fill: side.color)
    })
  }

  // La cabecera de un lado (rótulo y título), con todo escalado por `e`.
  let head(side, e) = {
    let c = body-size * e
    set par(leading: 0.34em)
    if side.tag != none {
      text(font: label-font(side), size: 0.6 * c, weight: 600, tracking: 0.2em, fill: side.color, upper(side.tag.body))
      v(0.5 * c)
    }
    if side.title != none {
      text(size: title-size * e, weight: 700, fill: ink, side.title.body)
    }
  }

  // Filete y lista de ítems de un lado.
  let items(side, e) = {
    let c = body-size * e
    set par(leading: 0.34em)
    line(length: 100%, stroke: 0.06 * c + side.color)
    v(0.8 * c)
    for it in side.items {
      grid(
        columns: (1.3 * c, 1fr),
        align: top,
        move(dy: 0.18 * c, marker(side, c)),
        text(size: c, fill: ink, it),
      )
      v(0.62 * c)
    }
  }

  set text(font: family, fill: ink, lang: "es", hyphenate: false)

  // ── Zonas: titular arriba, panel en medio, pie abajo
  let has-footer = author != none or work != none or brand != none
  let footer-height = if has-footer { 76pt } else { 0pt }
  let inner-width = width - 2 * margin

  context {
    let top = if headline != none {
      block(width: inner-width, text(size: headline-size, weight: 700, tracking: -0.01em, headline))
    } else { none }
    let top-height = if top != none { measure(top).height + 56pt } else { 0pt }

    let y0 = margin + top-height
    let y1 = height - margin - footer-height
    let area-height = y1 - y0

    // Geometría de los dos paneles
    let (pw, ph) = if in-columns { (inner-width / 2, area-height) } else { (inner-width, area-height / 2) }
    let pad = 44pt
    let (iw, ih) = (pw - 2 * pad, ph - 2 * pad)
    let origin(i) = if in-columns { (margin + i * pw, y0) } else { (margin, y0 + i * ph) }

    // Un lado entero: la cabecera con el alto de la mayor de las dos, para que
    // los filetes y las listas queden a la misma altura.
    let head-height(e) = calc.max(..sides.map(s => measure(width: iw, head(s, e)).height))
    let whole(s, e) = {
      block(width: iw, height: head-height(e), head(s, e))
      v(0.5 * body-size * e)
      items(s, e)
    }

    // El tamaño: el mayor (hasta 1,6) con el que ambos lados caben
    let fits(e) = sides.all(s => measure(width: iw, whole(s, e)).height <= ih)
    let e = 1.6
    while e > 0.4 and not fits(e) { e -= 0.05 }

    if top != none { place(dx: margin, dy: margin, top) }

    for (i, s) in sides.enumerate() {
      let (x, y) = origin(i)
      place(dx: x, dy: y, rect(width: pw, height: ph, fill: s.color.transparentize(90%), stroke: none))
      place(dx: x, dy: y, rect(width: pw, height: 7pt, fill: s.color, stroke: none))
      place(dx: x + pad, dy: y + pad, block(width: iw, whole(s, e)))
    }

    // El medallón (v1: recurso pendiente), en la juntura de los dos paneles
    let rad = 38pt
    let (mx, my) = if in-columns { (margin + pw, y0) } else { (margin + pw / 2, y0 + ph) }
    place(dx: mx - rad, dy: my - rad, circle(
      radius: rad, fill: ink, stroke: 6pt + paper,
      align(center + horizon, text(font: medallion-font, size: 30pt, weight: 700, style: "italic", fill: paper)[vs]),
    ))
  }

  // ── Pie: atribución + marca
  if has-footer {
    place(dx: margin, dy: height - margin - 54pt, block(width: inner-width, {
      set text(font: medallion-font, size: 24pt, fill: quiet)
      grid(
        columns: (1fr, auto),
        align: (left + bottom, right + bottom),
        [#if author != none { text(weight: 600, fill: ink, author) } \ #work],
        if brand != none { brand },
      )
    }))
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  layout: auto,
  margin: 72pt,
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
  extra-roles: ("affirm", "deny"),
  known: ("headline", "main", "author", "work", "brand"),
  fn: "contrast",
  elements: elements,
  rules: ctx => _rules(ctx, layout, margin),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "contrast", make: make, variants: ())
#let contrast = frame.with(preset: preset)
