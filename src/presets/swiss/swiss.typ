// ─────────────────────────────────────────────────────────────
//  swiss.typ — el preset `swiss` (en v1, `suizo`)
//
//  swiss = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): tag, subhead, main, conclusion,
//  author, dates, brand; cada uno también como argumento (`author: […]`).
//  El resto viaja en las propiedades
//  de los elementos (main.size, tag.font, conclusion.font), en el tema y en
//  `fonts` (por defecto la pareja `suizo`: body Hanken Grotesk para la frase,
//  annotation Inter para los rótulos, display Bebas Neue para el remate).
//
//  Reglas de colocación, heredadas de v1:
//    · retícula de 6 columnas, visible (0,8 pt en cada borde)
//    · cabecera: filete de 2,5 pt, autor a la izquierda, fechas en la 4.ª columna
//    · tag + subhead: un bloque apilado que arranca en y = 196 pt
//    · techo = 40 pt bajo ese bloque (o margen + 48 pt si no hay bloque)
//    · conclusion: ancho útil, con tope del 55 % del hueco hasta la base
//      (base = alto − 150 pt)
//    · main: 4 columnas; se achica de 2 en 2 pt hasta caber en el hueco
//      menos 48 pt de aire; el aire se encoge antes que la letra
//    · flecha de 14 pt bajo la frase hasta la mitad del aire sobre el remate
//    · sin conclusion no hay remate ni flecha: la frase baja hasta la base
//      (`DEUDA.md` §1.5, caso 4); el cuerpo vacío da la retícula, la cabecera y el pie
//    · pie: filete a 112 pt del borde inferior; brand abajo a la izquierda
//  Las medidas son las de v1; los números de la API siguen siendo pt aquí.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame

#let _default-theme = (
  paper: rgb("#f3f0e9"),
  ink: rgb("#141414"),
  quiet: rgb("#5c5850"),
  accent: rgb("#c8102e"),
  guide: rgb("#d9d3c7"),
)

// Retícula: ancho útil, columna, x de cada columna y span acumulado.
#let _columns(width, count: 6, margin: 64pt, gutter: 24pt) = {
  let usable = width - 2 * margin
  let col = (usable - (count - 1) * gutter) / count
  (
    count: count,
    margin: margin,
    gutter: gutter,
    usable: usable,
    col: col,
    x: range(count).map(i => margin + i * (col + gutter)),
    span: (0pt,) + range(1, count + 1).map(n => n * col + (n - 1) * gutter),
  )
}

#let _rules(ctx) = {
  let author = ctx.parts.at("author", default: none)
  let author = if author == none { none } else { author.body }
  let dates = ctx.parts.at("dates", default: none)
  let dates = if dates == none { none } else { dates.body }
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let ink = tm.ink
  let accent = tm.accent
  let brand = ctx.brand
  let g = _columns(width)
  let text-width = g.span.at(4)

  let r = ctx
  let p = ctx.parts
  let mp = p.at("main", default: none)
  let frase = if mp == none { r.loose } else if r.has-loose { mp.body + parbreak() + r.loose } else { mp.body }
  let props = if mp == none { (:) } else { mp.props }
  let size-frase = if "size" in props { props.size } else { 66pt }

  let tp = p.at("tag", default: none)
  let sp = p.at("subhead", default: none)
  let cp = p.at("conclusion", default: none)
  let remate = if cp == none { [] } else { cp.body }

  let rotulos = if tp != none and "font" in tp.props { (ctx.font)(tp.props.font) } else { ctx.fonts.annotation }
  let fuente-remate = if cp != none and "font" in cp.props { (ctx.font)(cp.props.font) } else { ctx.fonts.display }
  let rotulo(cuerpo, ..args) = text(font: rotulos, size: 22pt, ..args, cuerpo)

  {
    set text(lang: "es")
    set par(leading: 0.42em)

    // retícula visible
    for i in range(g.count) {
      place(top + left, dx: g.x.at(i), line(start: (0pt, 0pt), end: (0pt, height), stroke: 0.8pt + tm.guide))
      place(top + left, dx: g.x.at(i) + g.col, line(start: (0pt, 0pt), end: (0pt, height), stroke: 0.8pt + tm.guide))
    }

    // cabecera
    place(top + left, dx: g.margin, dy: g.margin, line(length: g.usable, stroke: 2.5pt + ink))
    if author != none {
      place(top + left, dx: g.x.at(0), dy: g.margin + 18pt, rotulo(weight: 700, tracking: 0.12em, author))
    }
    if dates != none {
      place(top + left, dx: g.x.at(calc.floor(g.count / 2)), dy: g.margin + 18pt, rotulo(weight: 400, fill: tm.quiet, dates))
    }

    // tag + subhead: un solo bloque apilado
    let heading = if tp != none or sp != none {
      block(width: text-width, {
        if tp != none { rotulo(weight: 700, tracking: 0.12em, fill: accent, tp.body) }
        v(4pt)
        if sp != none { text(font: rotulos, size: 44pt, weight: 400, fill: tm.quiet, tracking: -0.01em, sp.body) }
      })
    }
    if heading != none { place(top + left, dx: g.x.at(0), dy: 196pt, heading) }

    context {
      let ceiling = 40pt + if heading != none { 196pt + measure(heading).height } else { g.margin + 48pt }
      let base = height - 150pt

      // remate: ancho útil, con tope del 55 % del hueco. Sin `conclusion` no hay
      // remate: la frase baja hasta la base (`DEUDA.md` §1.5, caso 4)
      let remate-box = if cp != none {
        let word(s) = text(font: fuente-remate, size: s, fill: accent,
          top-edge: "cap-height", bottom-edge: "baseline", remate)
        let s = calc.min(
          (ctx.fit-width)(word, g.usable),
          100pt * (0.55 * (base - ceiling) / measure(word(100pt)).height),
        )
        (caja: word(s), s: s)
      }
      let conclusion-y = if remate-box == none { base } else { base - measure(remate-box.caja).height }
      if remate-box != none {
        place(top + left, dx: g.margin - 0.035 * remate-box.s, dy: conclusion-y, remate-box.caja)
      }

      // frase: 4 columnas, se achica antes que el aire
      let sentence(c) = block(width: text-width, text(size: c, weight: 500, tracking: -0.015em, frase))
      let gap = conclusion-y - ceiling
      let c = (ctx.fit-down)(sentence, size-frase, gap - 48pt)
      let b = sentence(c)
      let bh = measure(b).height
      let air = if cp == none { 0pt } else { calc.min(150pt, gap - bh) }
      let sentence-y = conclusion-y - air - bh
      place(top + left, dx: g.x.at(0), dy: sentence-y, b)

      // flecha en la última columna, de la frase al remate (sin remate, no hay flecha)
      if cp != none {
        let from = sentence-y + 14pt
        let to = conclusion-y - air / 2
        let length = to - from - 8pt
        place(top + left, dx: g.x.at(g.count - 1) + g.col / 2, dy: from, {
          line(start: (0pt, 0pt), end: (0pt, length), stroke: 3pt + accent)
          place(top + left, dx: -14pt, dy: length - 18pt, polygon(fill: accent, (0pt, 0pt), (28pt, 0pt), (14pt, 26pt)))
        })
      }
    }

    // pie
    place(bottom + left, dx: g.margin, dy: -112pt, line(length: g.usable, stroke: 2.5pt + ink))
    if brand != none { place(bottom + left, dx: g.x.at(0), dy: -g.margin + 3pt, brand) }
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  theme: theme,
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: _default-theme,
  default-fonts: "suizo",
  known: ("tag", "subhead", "main", "conclusion", "author", "dates", "brand"),
  elements: elements,
  fn: "swiss",
  rules: _rules,
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "swiss", make: make, variants: ())
#let swiss = frame.with(preset: preset)
