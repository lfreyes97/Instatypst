// ─────────────────────────────────────────────────────────────
//  blueprint.typ — el preset `blueprint` (en v1, `carteles.plano`)
//
//  blueprint = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): prose, main, author, work, brand; cada
//  uno también como argumento (`author: […]`). El texto de la pieza es `prose`
//  (o `main`, o el contenido suelto); `author` y `work` van en el cajetín.
//  Opciones del preset: highlight, step, major-every, scale, sheet, margin. El
//  resto viaja en las propiedades del texto (main.size, main.max-size,
//  main.weight), en el tema (paper, guide, accent) y en `fonts` (body, mono).
//
//  La frase como cota de un plano técnico: azul de heliografía, retícula de dos
//  pesos (rejilla fina y línea maestra cada `major-every` celdas), marco de
//  lámina con marcas de borde, el texto en el mayor cuerpo que cabe, una línea
//  de cota debajo y un cajetín abajo a la derecha con obra, autor, escala y
//  hoja. Todo es vector de Typst.
//
//  Escala: las medidas son las de v1, pensadas sobre 1080×1350 y escaladas con
//  k = mín(ancho/1080, alto/1350) (no con `u`). Se mantiene k para la paridad.
//
//  Roles del tema: los cinco. `guide` es la línea (retícula, marco, cota) y
//  `ink` el texto; en v1 eran el mismo color (`linea`), por eso valen igual por
//  defecto. `accent` (destacado y cajetín) valía `linea` si no se daba.
//
//  Pendiente (recursos que aún no existen; se dibujan siempre, por dentro):
//    · `dimension` (v1 `cota`): la línea de cota. v1 admitía un rótulo en medio
//      o apagarla (`cota: none`); aquí siempre va la línea sola.
//    · `title-block` (v1 `cajetin`): el cajetín. v1 admitía apagarlo.
//    · `marks` (v1 `marcas`): letras y números del borde. v1 admitía apagarlas.
//  Fuentes: Hanken Grotesk y DM Mono (v1); ninguna pareja de typography las
//  trae, se toman sueltas por `ctx.font` y `fonts:` las sobreescribe
//  (`fonts: (body: …, mono: …)`).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame

#let _default-theme = (
  paper: rgb("#14357a"),
  ink: rgb("#e8f0ff"),
  // sin `quiet`: v1 no lo tenía y blueprint no lo usa; modules/color lo deriva
  accent: rgb("#e8f0ff"),
  guide: rgb("#e8f0ff"),
)

// Cota: línea con topes y flechas en los extremos (v1 `_cota`, sin rótulo).
#let _dimension(width, color, k) = {
  let g = 2.5pt * k
  let tip(dir) = polygon(fill: color, ..if dir == 1 {
    ((0pt, 0pt), (16pt * k, -7pt * k), (16pt * k, 7pt * k))
  } else {
    ((0pt, 0pt), (-16pt * k, -7pt * k), (-16pt * k, 7pt * k))
  })
  block(width: width, height: 34pt * k, {
    place(left + horizon, line(angle: 90deg, length: 34pt * k, stroke: g + color), dy: -17pt * k)
    place(right + horizon, line(angle: 90deg, length: 34pt * k, stroke: g + color), dy: -17pt * k)
    place(left + horizon, dx: g, line(length: width - 2 * g, stroke: g + color))
    place(left + horizon, dx: g, tip(1))
    place(right + horizon, dx: -g, tip(-1))
  })
}

#let _rules(ctx, highlight, step, major-every, scale, sheet, margin) = {
  let part(n) = ctx.parts.at(n, default: none)
  let body-of(n) = { let p = part(n); if p == none { none } else { p.body } }
  let author = body-of("author")
  let work = body-of("work")
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (paper, ink, guide, accent) = (tm.paper, tm.ink, tm.guide, tm.accent)
  let brand = ctx.brand
  let k = calc.min(width / 1pt / 1080, height / 1pt / 1350)

  // el texto: prose, o main, o el contenido suelto; las propiedades, las de main
  let tp = if part("prose") != none { part("prose") } else { part("main") }
  let text-body = if tp == none { ctx.loose } else if ctx.has-loose { tp.body + parbreak() + ctx.loose } else { tp.body }
  let props-prose = if part("prose") != none { part("prose").props } else { (:) }
  let props-main = if part("main") != none { part("main").props } else { (:) }
  let props = props-prose + props-main
  let weight = props.at("weight", default: 700)
  let size-fixed = if "size" in props { (ctx.len)(props.size) } else { auto }
  let size-max = if "max-size" in props { (ctx.len)(props.at("max-size")) } else { 140pt * k }

  let margin = if margin == auto { 84pt * k } else { (ctx.len)(margin) }
  let cell = if step == auto { 36pt * k } else { (ctx.len)(step) }
  let box-width = width - 2 * margin

  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("Hanken Grotesk") }
  let mono-family = if "mono" in ctx.fonts { ctx.fonts.mono } else { (ctx.font)("DM Mono") }
  let mono(t, s: 20pt, ..a) = text(font: mono-family, size: s * k, tracking: 0.1em, fill: ink, ..a, t)

  {
    set text(font: family, fill: ink, lang: "es", hyphenate: false)
    set par(leading: 0.28em, spacing: 0pt)

    // ── retícula: fina cada `step`, maestra cada `major-every` celdas,
    //    con origen en el vértice del marco ──
    let nx = calc.floor((width - 2 * margin) / cell)
    let ny = calc.floor((height - 2 * margin) / cell)
    let grid-w = nx * cell
    let grid-h = ny * cell
    let x0 = (width - grid-w) / 2
    let y0 = (height - grid-h) / 2
    for i in range(0, nx + 1) {
      let m = calc.rem(i, major-every) == 0
      place(top + left, dx: x0 + i * cell, dy: y0,
        line(angle: 90deg, length: grid-h, stroke: (if m { 1.6pt } else { 0.8pt }) * k + guide.transparentize(if m { 62% } else { 86% })))
    }
    for j in range(0, ny + 1) {
      let m = calc.rem(j, major-every) == 0
      place(top + left, dx: x0, dy: y0 + j * cell,
        line(length: grid-w, stroke: (if m { 1.6pt } else { 0.8pt }) * k + guide.transparentize(if m { 62% } else { 86% })))
    }

    // ── marco de lámina ──
    place(top + left, dx: x0, dy: y0, rect(width: grid-w, height: grid-h, stroke: 2.5pt * k + guide))
    place(top + left, dx: x0 - 16pt * k, dy: y0 - 16pt * k, rect(width: grid-w + 32pt * k, height: grid-h + 32pt * k, stroke: 0.9pt * k + guide.transparentize(40%)))

    // ── marcas de borde: letras arriba, números a la izquierda (pendiente: `marks`) ──
    {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".clusters()
      let per-x = calc.max(1, calc.ceil(nx / 6))
      let per-y = calc.max(1, calc.ceil(ny / 8))
      for (n, i) in range(0, nx, step: per-x).enumerate() {
        let w = calc.min(per-x, nx - i) * cell
        place(top + left, dx: x0 + i * cell, dy: y0 - 46pt * k, box(width: w, align(center, mono(letters.at(n, default: "·"), s: 18pt))))
        place(top + left, dx: x0 + i * cell, dy: y0 - 16pt * k, line(angle: 90deg, length: 16pt * k, stroke: 1.6pt * k + guide))
      }
      for (n, j) in range(0, ny, step: per-y).enumerate() {
        let h = calc.min(per-y, ny - j) * cell
        place(top + left, dx: x0 - 54pt * k, dy: y0 + j * cell, box(width: 34pt * k, height: h, align(center + horizon, mono(str(n + 1), s: 18pt))))
        place(top + left, dx: x0 - 16pt * k, dy: y0 + j * cell, line(length: 16pt * k, stroke: 1.6pt * k + guide))
      }
    }

    // ── cajetín: abajo a la derecha, dentro del marco (pendiente: `title-block`) ──
    let title-h = 150pt * k
    {
      let slot(label, value) = block(inset: (x: 14pt * k, y: 10pt * k), width: 100%, {
        mono(label, s: 13pt, fill: ink.transparentize(30%))
        v(5pt * k)
        text(font: mono-family, size: 20pt * k, fill: accent, tracking: 0.04em, value)
      })
      let tb-w = calc.min(box-width, 620pt * k)
      place(top + left, dx: x0 + grid-w - tb-w, dy: y0 + grid-h - 124pt * k, block(
        width: tb-w, fill: paper, stroke: 2pt * k + guide,
        grid(
          columns: (1.7fr, 1fr, 1fr),
          rows: (auto, auto),
          stroke: 1pt * k + guide,
          grid.cell(colspan: 3, slot([PLANO], if work != none { work } else { [—] })),
          slot([DIBUJÓ], if author != none { author } else { [—] }),
          slot([ESCALA], scale),
          slot([HOJA], sheet),
        ),
      ))
    }

    // ── texto + cota (pendiente: `dimension`) ──
    let room = grid-h - 2 * 60pt * k - title-h - 80pt * k
    let text-fit(c) = {
      let t = if highlight.len() > 0 {
        show regex(highlight.map(p => "(" + p + ")").join("|")): it => text(fill: accent, it)
        text-body
      } else { text-body }
      text(size: c, weight: weight, tracking: -0.02em, t)
    }
    let text-w = grid-w - 2 * 48pt * k
    let bloc(c) = block(width: text-w, text-fit(c))

    context {
      let c = if size-fixed == auto { size-max } else { size-fixed }
      if size-fixed == auto {
        while c > 28pt and measure(bloc(c)).height > room { c -= 2pt }
      }
      let b = bloc(c)
      let h = measure(b).height
      let y = y0 + 60pt * k + (room - h) * 0.4
      place(top + left, dx: x0 + 48pt * k, dy: y, b)
      place(top + left, dx: x0 + 48pt * k, dy: y + h + 40pt * k, _dimension(text-w, accent, k))
    }

    if brand != none { place(bottom + left, dx: x0 + 48pt * k, dy: -(y0 + 36pt * k), brand) }
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  highlight: (),
  step: auto,
  major-every: 5,
  scale: [1 : 1],
  sheet: [1 / 1],
  margin: auto,
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  // v1 tenía un solo color, `linea`, para las líneas, el texto y (si `acento` era
  // auto) el acento. En V2 son guide, ink y accent; para conservar el sentido de
  // v1, un tema que da `guide` y no da `ink` o `accent` los hace seguir a `guide`.
  theme: if type(theme) == dictionary and "guide" in theme {
    (ink: theme.guide) + (if accent == auto { (accent: theme.guide) } else { (:) }) + theme
  } else { theme },
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: _default-theme,
  default-fonts: none,
  known: ("prose", "main", "author", "work", "brand"),
  fn: "blueprint",
  elements: elements,
  rules: ctx => _rules(ctx, highlight, step, major-every, scale, sheet, margin),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "blueprint", make: make, variants: ())
#let blueprint = frame.with(preset: preset)
