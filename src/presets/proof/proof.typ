// ─────────────────────────────────────────────────────────────
//  proof.typ — el preset `proof` (en v1, `carteles.demostracion`)
//
//  proof = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): headline, author, work, brand; cada
//  uno también como argumento (`author: […]`). Además lee de su cuerpo el `list`
//  de la librería estándar (y sus `list.item`) y, dentro de cada ítem, `main` y
//  `versus` (ver abajo).
//  Opciones del preset: margin, rule-gap, start; el resto viaja en el tema
//  (paper, ink, quiet, accent y el rol propio `light`), en `fonts` y en las
//  propiedades de los elementos (main.size, main.max-size).
//
//  La cita como demostración numerada, en pizarra: renglones numerados en mono;
//  la palabra que se sostiene, enorme, con ⊢; la que no se sigue, con ⊬. Una raya
//  de deducción punteada separa los grupos.
//
//  El contenido (v1: `grupos`, un array de arrays):
//    · un GRUPO es un `list` (la llamada `#list(…)`, o una tanda de `- …`
//      seguidos); cada ítem es un renglón.
//    · un ítem de texto es un renglón de lectura.
//    · un ítem que contiene `#main[…]` es un renglón que se sostiene (v1
//      `(afirma: …)`: ⊢ en acento y la palabra en `light`).
//    · un ítem que contiene `#versus[…]` es un renglón que se niega (v1
//      `(niega: …)`: ⊬ apagado y la palabra en `ink`).
//    · `main(size:)` / `versus(size:)` fijan el cuerpo de ese renglón (v1
//      `cuerpo:`); `max-size` es el tope del cuerpo que llena la columna (v1
//      `cuerpo-max`, 232 pt). Número = u, longitud = absoluta.
//    · `headline` (v1 `encabezado`) es la entrada sin numerar sobre el primer grupo.
//
//  Escala: las medidas son pt absolutos, como en v1 (no usa `k`).
//
//  Fuentes: Instrument Sans (cuerpo) y DM Mono (mono), las de v1. Ninguna pareja
//  de typography las trae juntas; se toman los tokens por `ctx.font` y `fonts:`
//  los sobreescribe (roles body y mono) como en cualquier preset.
//
//  Roles del tema: los cinco más uno propio, `light` (v1 `claro`), que pasa por
//  modules/color como los demás. v1 lo derivaba de `ink` cuando el tema cambiaba
//  paper o ink; un rol extra no se deriva de nada: viene del tema por defecto.
//
//  Pendientes (ver el informe): la retícula de cuaderno (v1 `cuadricula`, recurso
//  `grid` que aún no existe) se dibuja siempre; el cuerpo de lectura (v1
//  `cuerpo-lectura`, `list.size`) no tiene dónde viajar porque `list` es el de
//  Typst y no lleva propiedades; el signo por renglón (v1 `signo:`) no se traduce;
//  qué elemento marca el renglón que se sostiene y el que se niega.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ" as superbg

#let _default-theme = (
  paper: rgb("#0d1014"),
  ink: rgb("#c3c9d1"),
  quiet: rgb("#8b95a1"),
  accent: rgb("#f2b33d"),
  // sin `guide`: v1 no lo tenía y proof no lo usa; modules/color lo deriva
  light: rgb("#f4f1ea"),
)

// (`list` tiene `children` pero es un grupo, no una secuencia: no se aplana)
#let _flatten(c) = if c.func() != list and c.has("children") { c.children.map(_flatten).flatten() } else { (c,) }

// El cuerpo de un ítem → (kind:, body:, props:); kind es "read", "affirms" o "denies".
#let _line(item) = {
  let found = _flatten(item.body).find(c => c.func() == metadata and type(c.value) == dictionary
    and c.value.at("kind", default: none) in ("main", "versus"))
  if found == none { (kind: "read", body: item.body, props: (:)) } else {
    (kind: if found.value.kind == "main" { "affirms" } else { "denies" }, body: found.value.body, props: found.value.props)
  }
}

// Los grupos del contenido suelto: cada `list` es un grupo; los `list.item`
// sueltos y seguidos forman otro.
#let _groups(loose) = {
  let groups = ()
  let run = ()
  for c in _flatten(loose) {
    if c.func() == list.item {
      run.push(_line(c))
    } else if c.func() == list {
      if run.len() > 0 { groups.push(run); run = () }
      groups.push(c.children.map(_line))
    }
  }
  if run.len() > 0 { groups.push(run) }
  groups
}

#let _rules(ctx, margin, rule-gap, start) = {
  let part(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { none } else { p.body }
  }
  let author = part("author")
  let work = part("work")
  let headline = part("headline")
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (light, ink, quiet, accent) = (tm.light, tm.ink, tm.quiet, tm.accent)
  let brand = ctx.brand
  let formato = (int(calc.round(width / 1pt)), int(calc.round(height / 1pt))) // enteros: la retícula usa `range`
  let margin = (ctx.len)(margin)
  let box-width = width - 2 * margin
  let (col-n, col-sign) = (64pt, 48pt)
  let groups = _groups(ctx.body) // el cuerpo entero: read-parts aplana los `list` en ítems

  let body-font = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("instrument-sans") }
  let mono-font = if "mono" in ctx.fonts { ctx.fonts.mono } else { (ctx.font)("dm-mono") }
  let reading-size = 58pt

  let mono(body, color: quiet, size: 24pt) = text(font: mono-font, size: size, fill: color, body)
  let numeral(i) = mono(if i < 10 { "0" + str(i) } else { str(i) })
  let highlight(c, tone, s) = box(text(size: s, weight: 700, fill: tone, tracking: -0.02em, c))

  // celdas de un grupo, con todo escalado por `e` (1 = tamaños de siempre)
  let rows(group, from, e) = {
    let cells = ()
    for (k, r) in group.enumerate() {
      cells.push(numeral(from + k))
      if r.kind != "read" {
        let affirms = r.kind == "affirms"
        let c = r.body
        let tone = if affirms { light } else { ink }
        // llena la columna, pero una palabra corta no pasa de `max-size`
        let s = if "size" in r.props { (ctx.len)(r.props.size) } else {
          let top = if "max-size" in r.props { (ctx.len)(r.props.max-size) } else { 232pt }
          calc.min(top, (ctx.fit-width)(t => highlight(c, tone, t), 0.98 * (box-width - col-n - col-sign)))
        }
        cells.push(highlight(c, tone, s * e))
        cells.push(text(font: mono-font, size: 52pt * e, fill: if affirms { accent } else { quiet }, if affirms { "⊢" } else { "⊬" }))
      } else {
        cells.push(text(size: reading-size * e, r.body))
        cells.push([])
      }
    }
    block(width: box-width, grid(
      columns: (col-n, 1fr, col-sign),
      align: (left + horizon, left + horizon, right + horizon),
      row-gutter: 18pt * e,
      ..cells,
    ))
  }

  {
    set text(font: body-font, fill: ink, lang: "es", hyphenate: false)

    // retícula de cuaderno de cálculo, muy tenue (v1 `cuadricula: true`; recurso `grid` pendiente)
    place(superbg.bg-patron(patron: "grid", color: light, paso: 54, grosor: 1, opacidad: 5%, size: formato))

    // pie
    let foot = block(width: box-width, grid(
      columns: (1fr, auto),
      align: (left + bottom, right + bottom),
      if author != none or work != none {
        mono(color: ink)[— #author \ #h(1.2em)#text(fill: quiet, work)]
      },
      if brand != none { brand },
    ))
    place(bottom + left, dx: margin, dy: -76pt, foot)

    context {
      // numeración corrida entre grupos
      let from = (1,)
      for g in groups { from.push(from.last() + g.len()) }
      let entry(e) = if headline != none {
        block(width: box-width - col-n, text(size: reading-size * e, headline))
      }
      let measured(e) = {
        let blocks = groups.enumerate().map(((i, g)) => rows(g, from.at(i), e))
        let total = blocks.map(b => measure(b).height).sum() + (groups.len() - 1) * (rule-gap.above + rule-gap.below) * e
        if headline != none { total += measure(entry(e)).height + (rule-gap.above + rule-gap.below) * e }
        (blocks, total)
      }
      // espacio disponible: entre el margen y el pie
      let ceiling = margin
      let floor = height - 76pt - measure(foot).height - 40pt
      let e = 1.0
      let (blocks, total) = measured(e)
      while total > floor - ceiling and e > 0.3 {
        e -= 0.05
        (blocks, total) = measured(e)
      }
      let y = if start == auto { ceiling + (floor - ceiling - total) / 3 } else { start }
      if headline != none {
        let en = entry(e)
        place(dx: margin + col-n, dy: y, en)
        y += measure(en).height
      }
      for (i, b) in blocks.enumerate() {
        if i > 0 or headline != none {
          y += rule-gap.above * e
          // raya de deducción, desde la columna del texto
          place(dx: margin + col-n, dy: y, line(length: box-width - col-n, stroke: (paint: quiet, thickness: 2pt, dash: (6pt, 8pt))))
          y += rule-gap.below * e
        }
        place(dx: margin, dy: y, b)
        y += measure(b).height
      }
    }
  }
}

#let make(
  body,
  artboard: (1080, 1080),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  margin: 84pt,
  rule-gap: (above: 76pt, below: 44pt),
  start: auto,
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
  extra-roles: ("light",),
  known: ("headline", "author", "work", "brand"),
  fn: "proof",
  elements: elements,
  rules: ctx => _rules(ctx, margin, rule-gap, start),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "proof", make: make, variants: (), artboard: "cuadrado") // demostracion era cuadrada en v1
#let proof = frame.with(preset: preset)
