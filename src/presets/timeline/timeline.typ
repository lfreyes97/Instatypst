// ─────────────────────────────────────────────────────────────
//  timeline.typ — el preset `timeline` (en v1, `carteles.linea-tiempo`)
//
//  timeline = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): list (la de Typst), conclusion, main,
//  tag, author, work, brand; cada uno también como argumento (`author: […]`).
//  Opciones del preset: origin, end, y.
//
//  Una línea vertical sin cortes, de un origen (rombo + rótulo en versalitas
//  espaciadas) a un final (anillo + rótulo), con muescas de generaciones. Las
//  estaciones son los ítems de una lista (`- …`): nodo sobre la línea y texto a
//  la derecha. La conclusión es la última estación, destacada: nodo relleno más
//  grande, texto grande en cursiva y en el color de acento, junto al final.
//
//  Destinos de las opciones de v1:
//    estaciones → la `list` del cuerpo      remate → `conclusion`
//    origen, fin → `origin`, `end`          y → `y`
//    cuerpo → `main(size:)`                 cuerpo-remate → `conclusion(size:)`
//    fuente-rotulos → `tag(font:)`          autor, obra → `author`, `work`
//  `main` y `tag` no llevan texto aquí: solo sus propiedades (el cuerpo que se
//  les dé no se dibuja). Es una decisión pendiente (informe de la traducción).
//
//  Si las estaciones no caben en el largo de la línea con 0,8 cuerpos de aire
//  entre una y otra, todo se achica en la misma proporción (de a 5 %); si sobra
//  mucho (formatos altos), crece hasta 1,25 y el aire no pasa de 4 cuerpos: el
//  resto queda como tramo de línea antes de la primera. `y` (un array de largos,
//  uno por estación más uno para la conclusión) las fija a mano.
//
//  Escala: como en v1, la geometría y los tamaños son absolutos (pt), pensados
//  sobre un ancho de 1080 y un alto cualquiera. Los números de la API
//  (`main(size: 54)`) son `u` vía `ctx.len`.
//
//  Fuentes: Literata (texto) y Jost (rótulos), de v1; ninguna pareja de
//  typography las trae juntas, se toman los tokens por `ctx.font` y `fonts:` los
//  sobreescribe como en cualquier preset.
//
//  Textura: el grano de papel (v1 `textura`, puntos muy tenues en la tinta) es un
//  recurso que aún no existe: se dibuja siempre, con superbg. Pendiente: poder
//  apagarlo.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ" as superbg

#let _default-theme = (
  paper: rgb("#f1e9dc"),
  ink: rgb("#2a2420"),
  quiet: rgb("#6b5e52"),
  accent: rgb("#9a3a1c"),
  // sin `guide`: v1 no lo tenía y timeline no lo usa; modules/color lo deriva
)

// Los ítems de las listas del contenido suelto (read-parts entrega cada `list` entera).
#let _stations(loose) = {
  let flat(c) = if c.func() != list and c.has("children") { c.children.map(flat).flatten() } else { (c,) }
  let out = ()
  for c in flat(loose) {
    if c.func() == list { out += c.children.map(i => i.body) } else if c.func() == list.item { out.push(c.body) }
  }
  out
}

#let _rules(ctx, origin, end, y) = {
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
  let conclusion = part("conclusion")
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, quiet, accent, paper) = (tm.ink, tm.quiet, tm.accent, tm.paper)
  let brand = ctx.brand
  let formato = (width / 1pt, height / 1pt)
  let stations = _stations(ctx.loose)

  let size-body = if "size" in props("main") { (ctx.len)(props("main").size) } else { 54pt }
  let size-conclusion = if "size" in props("conclusion") { (ctx.len)(props("conclusion").size) } else { 84pt }
  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("literata") }
  let font-tag = if "font" in props("tag") { (ctx.font)(props("tag").font) } else if "annotation" in ctx.fonts { ctx.fonts.annotation } else { (ctx.font)("jost") }

  // Geometría de la línea: fija respecto de los bordes
  let axis = 132pt // x de la línea
  let line-start = 128pt // y del nodo de origen
  let line-end = height - 200pt // y del nodo final
  let text-x = 196pt
  let text-w = width - text-x - 92pt

  let label(body, color: accent) = text(
    font: font-tag, size: 25pt, weight: 600, tracking: 0.16em, fill: color, upper(body),
  )
  let node(r, fill, edge) = circle(radius: r, fill: fill, stroke: 3.5pt + edge)

  // Una estación con todo escalado por `e` (1 = tamaños de siempre).
  // El nodo cae sobre la primera línea: su posición es proporcional al
  // cuerpo (14pt y radio 11pt a 54pt; 26pt y 20pt a 84pt en la conclusión).
  let block-of(c, e, is-conclusion) = if is-conclusion {
    let s = size-conclusion * e
    block(width: text-w, text(size: s, weight: 600, style: "italic", fill: accent, {
      set par(leading: 0.3em)
      c
    }))
  } else {
    block(width: text-w, text(size: size-body * e, c))
  }
  let all = stations.map(c => (c, false)) + if conclusion != none { ((conclusion, true),) } else { () }

  {
    set text(font: family, fill: ink, lang: "es", hyphenate: false)
    set par(leading: 0.42em)

    // ── Fondo: grano muy leve de papel
    place(superbg.bg-patron(patron: "dots", color: ink, paso: 22, opacidad: 5%, size: formato))

    // ── La línea: un solo trazo continuo + muescas de generaciones
    place(dx: axis - 2pt, dy: line-start, rect(width: 4pt, height: line-end - line-start, fill: ink))
    for yy in range(int(line-start / 1pt) + 30, int(line-end / 1pt) - 14, step: 22) {
      place(dx: axis - 13pt, dy: yy * 1pt, line(length: 9pt, stroke: 1.6pt + ink.transparentize(55%)))
    }

    // Nodo de origen (rombo) y nodo de llegada (anillo)
    place(dx: axis - 17pt, dy: line-start - 17pt, rotate(45deg, rect(width: 24pt, height: 24pt, fill: accent)))
    if origin != none { place(dx: text-x, dy: line-start - 16pt, label(origin)) }
    place(dx: axis - 15pt, dy: line-end - 15pt, circle(radius: 15pt, fill: paper, stroke: 4pt + ink))
    if end != none { place(dx: text-x, dy: line-end - 16pt, label(color: ink, end)) }

    // ── Estaciones
    context {
      // tramo donde caben: desde 108pt bajo el origen hasta 122pt sobre
      // el final (las medidas de la lámina 16)
      let (y0, y1) = (line-start + 108pt, line-end - 122pt)
      let n = all.len()
      let heights(e) = all.map(((c, r)) => measure(block-of(c, e, r)).height)
      let air-of(hs) = (y1 - y0 - hs.sum()) / calc.max(1, n - 1)
      let e = 1.0
      let hs = heights(e)
      // si no hay al menos 0,8 cuerpos de aire entre estaciones, se achica
      while n > 1 and air-of(hs) < 0.8 * size-body * e and e > 0.4 {
        e -= 0.05
        hs = heights(e)
      }
      // si sobra (más de 4 cuerpos de aire: formatos altos), crece hasta 1,25
      if y == auto {
        while n > 1 and e < 1.25 and air-of(heights(e + 0.05)) > 4 * size-body * (e + 0.05) { e += 0.05 }
        hs = heights(e)
      }
      let ys = if y != auto { y } else if n == 1 {
        (y1 - hs.at(0),)
      } else {
        // mismo aire entre una y otra, como mucho 4 cuerpos; la última
        // termina en y1 y lo que sobra queda arriba, como tramo de línea
        // antes de la primera estación
        let air = calc.min(air-of(hs), 4 * size-body * e)
        let acc = (y1 - hs.sum() - air * (n - 1),)
        for i in range(1, n) { acc.push(acc.last() + hs.at(i - 1) + air) }
        acc
      }
      for (i, (c, is-conclusion)) in all.enumerate() {
        let (r, dn, fill, edge) = if is-conclusion {
          let s = size-conclusion * e
          (s * 20 / 84, s * 26 / 84, accent, accent)
        } else {
          let s = size-body * e
          (s * 11 / 54, s * 14 / 54, paper, ink)
        }
        place(dx: axis - r, dy: ys.at(i) + dn, node(r, fill, edge))
        place(dx: text-x, dy: ys.at(i), block-of(c, e, is-conclusion))
      }
    }

    // ── Pie: atribución + marca
    if author != none or work != none or brand != none {
      place(dx: text-x, dy: height - 128pt, block(width: text-w, {
        set text(font: font-tag, size: 24pt, fill: quiet)
        grid(
          columns: (1fr, auto),
          align: (left + bottom, right + bottom),
          [#if author != none { text(weight: 600, fill: ink, author) } \ #work],
          if brand != none { brand },
        )
      }))
    }
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  origin: none,
  end: none,
  y: auto,
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
  known: ("conclusion", "main", "tag", "author", "work", "brand"),
  fn: "timeline",
  elements: elements,
  rules: ctx => _rules(ctx, origin, end, y),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "timeline", make: make, variants: ())
#let timeline = frame.with(preset: preset)
