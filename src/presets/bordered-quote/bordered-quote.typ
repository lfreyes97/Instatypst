// ─────────────────────────────────────────────────────────────
//  bordered-quote.typ — el preset `bordered-quote` (en v1, `carteles.cita-orlada`)
//
//  bordered-quote = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): quote, headline, author, work, brand;
//  cada uno también como argumento (`author: […]`). La cita es el `quote` de
//  Typst (o el contenido suelto). La obra (v1 `obra`, y su alias `fuente`) es
//  `work`: v1 daba los dos nombres y mandaba `obra`; ahora es uno solo.
//  Opciones del preset: size, border, chain.
//
//  Cita sobre una orla de fleurones (IM FELL): comilla de fleurón, texto en
//  cursiva, autor en versalitas y fuente. La orla y los temas «vino» y «papel»
//  son del recurso resources/borders, que comparten los tres presets orlados.
//
//    size    el cuerpo de la cita (v1 `tamano`): auto lo ajusta al largo del texto
//    border  qué lados llevan orla (v1 `orla`): "completa" · "arriba" · "abajo" ·
//            "arriba-abajo" · "izquierda" · "derecha" · "lateral" · "columna" ·
//            "ninguna". PENDIENTE: el recurso `border` no existe; es una opción
//            del preset con los valores de v1.
//    chain   el marco de la orla (v1 `cadena`): una clave de `fleurones.cadenas`.
//            Opción del preset mientras el recurso no exista (decisiones).
//
//  Escala: las medidas son las de v1, en px del lienzo (no k ni u).
//  Fuentes: IM FELL English (cita, texto) e IM FELL English SC (rótulos), por
//  token; `fonts: (body: …, annotation: …)` las sobreescribe.
//  Tema: «vino» por defecto; los cinco roles más `deep` (v1 `hondo`). Los otros
//  colores de la orla son internos del recurso (ver borders.typ).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/fleurones/fleurones.typ" as fl
#import "/src/resources/borders/borders.typ" as borders

#let _quote-size(text-body, kind) = {
  let n = borders.text-length(text-body)
  let base = if n > 260 { 42pt } else if n > 170 { 50pt } else if n > 100 { 60pt } else { 76pt }
  if kind == "historia" { base * 1.12 } else if kind == "vertical" { base * 1.05 } else { base }
}

#let _rules(ctx, theme-name, size, border, chain) = {
  let p = ctx.parts
  let qp = p.at("quote", default: none)
  let quote-body = if qp != none { qp.body } else { ctx.loose }
  let part(kind) = { let e = p.at(kind, default: none); if e == none { none } else { e.body } }
  let (headline, author, work) = (part("headline"), part("author"), part("work"))
  let brand = ctx.brand
  let fell = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("im-fell-english") }
  let fellsc = if "annotation" in ctx.fonts { ctx.fonts.annotation } else { (ctx.font)("im-fell-english-sc") }
  let inner = borders.inner-colors(ctx.tm, theme-name)

  borders.bordered-canvas(fl, ctx, inner, fell, border, chain, (c, w, field-height, kind) => {
    let s = if size == auto { _quote-size(quote-body, kind) } else { (ctx.len)(size) }
    let safe = if kind == "historia" { 200pt } else { 46pt }
    box(width: w, height: field-height, inset: (x: 64pt, top: safe, bottom: safe), {
      show quote: it => it.body
      stack(
        dir: ttb,
        // cabecera: encabezado y divisor
        if headline != none {
          align(center)[
            #text(font: fellsc, size: 30pt, tracking: 0.3em, fill: c.accent)[#headline]
            #v(18pt)
            #fl.divisor(w * 0.42, 22pt, c.orn, c.fil)
          ]
        } else { [] },
        v(1fr),
        align(center, text(font: fell, size: s * 2.4, fill: c.orn)[“]),
        v(s * 0.1),
        align(center, block(width: 100%, text(font: fell, style: "italic", size: s)[
          #set par(leading: 0.42em)
          #quote-body
        ])),
        v(s * 0.9),
        if author != none { align(center, text(font: fellsc, size: 30pt, tracking: 0.14em, fill: c.accent, author)) } else { [] },
        v(8pt),
        if work != none { align(center, text(font: fell, style: "italic", size: 26pt, fill: c.quiet, work)) } else { [] },
        v(1fr),
        borders.footer-block(fl, c, fellsc, brand),
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
  size: auto,
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
  known: ("quote", "headline", "author", "work", "brand"),
  fn: "bordered-quote",
  elements: elements,
  rules: ctx => _rules(ctx, borders.base-of(theme, "vino"), size, border, chain),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia. El formato
// por defecto de v1 era el cuadrado.
#let preset = (name: "bordered-quote", make: make, variants: (), artboard: "cuadrado")
#let bordered-quote = frame.with(preset: preset)
