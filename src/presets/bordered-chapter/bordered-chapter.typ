// ─────────────────────────────────────────────────────────────
//  bordered-chapter.typ — el preset `bordered-chapter` (en v1, `carteles.capitulo-orlado`)
//
//  bordered-chapter = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): numeral, headline, subhead, call, tag,
//  work, author, brand; cada uno también como argumento (`work: […]`).
//    numeral   el número del capítulo (v1 `numero`): un entero, como [1]; sale
//              en romanos
//    headline  el título (v1 `titulo`)         subhead  el subtítulo
//    call      la llamada de arriba (v1 `llamada`; [Lectura de la semana] si
//              nadie la da, como en v1)
//    tag       el rótulo sobre el número (v1 `rotulo`; [Capítulo] por defecto)
//    work, author   la cartela de pie: obra ✿ autor
//  Opciones del preset: border, chain.
//
//  Anuncio de lectura o de serie sobre malla de fleurones (IM FELL): una
//  cartela principal con la llamada, el rótulo, el número en romanos, el título
//  y el subtítulo, y otra de pie con obra y autor. Orla y temas («vino» por
//  defecto, «papel») son del recurso resources/borders.
//
//    border  qué lados llevan orla (v1 `orla`), con los valores de v1.
//            PENDIENTE: el recurso `border` no existe; opción del preset.
//    chain   el marco de la orla (v1 `cadena`; por defecto "ojivas"): una clave
//            de `fleurones.cadenas`. Opción del preset mientras el recurso no
//            exista (decisiones).
//
//  Escala: las medidas son las de v1, en px del lienzo, con su factor `k` por
//  tipo de formato (1,25 historia, 1,1 vertical, 1 cuadrado). Fuentes: IM FELL
//  English e IM FELL English SC, por token (`fonts:` las sobreescribe).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/fleurones/fleurones.typ" as fl
#import "/src/resources/borders/borders.typ" as borders

// El número del capítulo: un entero, o un contenido de texto que lo sea.
#let _number(body) = {
  if body == none { none }
  else if type(body) == int { body }
  else { int(body.text.trim()) }
}

#let _rules(ctx, theme-name, border, chain) = {
  let p = ctx.parts
  let part(kind, default: none) = { let e = p.at(kind, default: none); if e == none { default } else { e.body } }
  let number = _number(part("numeral"))
  let title = part("headline", default: ctx.loose)
  let (subhead, work, author) = (part("subhead"), part("work"), part("author"))
  let call = part("call", default: [Lectura de la semana])
  let tag = part("tag", default: [Capítulo])
  let brand = ctx.brand
  let fell = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("im-fell-english") }
  let fellsc = if "annotation" in ctx.fonts { ctx.fonts.annotation } else { (ctx.font)("im-fell-english-sc") }
  let inner = borders.inner-colors(ctx.tm, theme-name)

  borders.bordered-canvas(fl, ctx, inner, fell, border, chain, (c, w, field-height, kind) => {
    let safe = 36pt
    // malla de fondo en todo el campo
    place(fl.diaper(fl.f1, "AD", w, field-height, 72pt, c.malla))
    let k = if kind == "historia" { 1.25 } else if kind == "vertical" { 1.1 } else { 1.0 }
    box(width: w, height: field-height, inset: (x: 44pt, top: safe, bottom: safe), {
      grid(
        columns: 1fr, rows: (1fr, auto), row-gutter: 26pt,
        // cartela principal: ocupa todo el alto disponible, contenido centrado
        block(width: 100%, height: 100%, fill: c.paper, stroke: 1.6pt + c.deep, inset: (x: 24pt, y: 36pt))[
          #place(top + left, dx: -18pt, dy: -30pt, rect(width: 100% + 36pt, height: 100% + 60pt, stroke: 0.9pt + c.fil))
          #align(center + horizon)[
            #text(font: fellsc, size: 30pt * k, tracking: 0.3em, fill: c.accent)[#call]
            #v(20pt * k)
            #fl.divisor(w * 0.42, 22pt, c.orn, c.fil)
            #v(46pt * k)
            #text(font: fellsc, size: 32pt * k, tracking: 0.32em, fill: c.quiet)[#tag]
            #v(34pt * k)
            #if number != none { text(font: fell, size: 150pt * k, fill: c.ink)[#numbering("I", number)] }
            #v(44pt * k)
            #text(font: fell, size: calc.min(if borders.text-length(title) > 28 { 66pt } else { 82pt } * k, (w - 60pt) / (0.36 * calc.max(8, borders.text-length(title)))), fill: c.ink)[
              #set par(leading: 0.35em)
              #title]
            #if subhead != none {
              v(32pt * k)
              text(font: fell, style: "italic", size: 38pt * k, fill: c.quiet)[#subhead]
            }
          ]
        ],
        // cartela de pie: obra ✿ autor
        block(width: 100%, fill: c.paper, stroke: 1.6pt + c.deep, inset: (x: 20pt, y: 24pt))[
          #align(center)[
            #if work != none { text(font: fellsc, size: 34pt, tracking: 0.14em, work) }
            #if work != none and author != none [#h(16pt) #box(baseline: -4pt, fl.caja(fl.f2, "C", 18pt, 18pt, c.orn)) #h(16pt)]
            #if author != none { text(font: fellsc, size: 28pt, tracking: 0.14em, fill: c.accent, author) }
            #if brand != none {
              v(12pt)
              text(font: fellsc, size: 22pt, tracking: 0.18em, fill: c.quiet)[#brand]
            }
          ]
        ],
      )
    })
  })
}

#let make(
  body,
  artboard: (1080, 1080),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  border: "completa",
  chain: "ojivas",
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  theme: borders.theme-arg(theme),
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: borders.themes.vino,
  default-fonts: none,
  extra-roles: ("deep",),
  known: ("numeral", "headline", "subhead", "call", "tag", "work", "author", "brand"),
  fn: "bordered-chapter",
  elements: elements,
  rules: ctx => _rules(ctx, borders.base-of(theme, "vino"), border, chain),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia. El formato
// por defecto de v1 era el cuadrado.
#let preset = (name: "bordered-chapter", make: make, variants: (), artboard: "cuadrado")
#let bordered-chapter = frame.with(preset: preset)
