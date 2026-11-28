// ─────────────────────────────────────────────────────────────
//  obituary.typ — el preset `obituary` (en v1, `carteles.esquela`)
//
//  obituary = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): headline, subhead, prose, author,
//  work, brand; cada uno también como argumento (`author: […]`).
//    headline   el «difunto»: una palabra o dos, en versalitas grandes (v1 `nombre`)
//    subhead    el anuncio de arriba, en cursiva (v1 `anuncio`)
//    prose      el duelo de abajo, en cursiva (v1 `duelo`)
//
//  Aviso fúnebre de imprenta: papel de luto con orla, cruz, el anuncio en
//  cursiva, el nombre en versalitas grandes, el duelo en cursiva y el pie con
//  filete — florón — filete, autor y obra. IM FELL de punta a punta; las
//  viñetas son de IM FELL FLOWERS (modules/fleurones).
//
//  Opciones del preset (los nombres son los de los recursos de la tabla):
//    border           "mourning" (banda negra gruesa, por defecto) · un marco de
//                     `fleurones.cadenas` ("celosia", "ojivas"…) · none
//                     [PENDIENTE: recurso `border`; hoy se dibuja por dentro]
//    inner            lo que corre por dentro de la orla: "rule" (filete, por
//                     defecto) · un marco de `fleurones.cadenas` ("crucetas"…) · none
//    symbol           "cross" (latina, de dos barras) · contenido · none
//                     [PENDIENTE: recurso `symbol`]
//    vignette, footer-vignette   auto (el glifo de FLOWERS 2 de la lámina) · un
//                     nombre de `fleurones.vinetas` · contenido · none
//                     [PENDIENTE: recursos `vignette` y `footer-vignette`]
//    texture          ruido y viñeteado sobre el papel (true por defecto)
//                     [PENDIENTE: recurso `texture`; hoy se dibuja con superbg]
//  Propiedades de elementos: subhead.size y prose.size (v1 `cuerpo`, 52pt; la
//  tabla lo manda a `main.size`, pero este preset no tiene `main`: el cuerpo se
//  reparte entre los dos textos en cursiva), headline.size (v1 `cuerpo-nombre`,
//  132pt; el nombre se achica si no cabe), headline.font (v1 `fuente-nombre`).
//  Fuentes (`fonts`): body (IM FELL English), display (el nombre: IM FELL French
//  Canon SC) y smallcaps (el autor: IM FELL English SC; v1 `fuente-sc`).
//
//  Escala: las medidas son las de v1, sobre 1080×1350, escaladas con
//  k = mín(ancho/1080, alto/1350) (cuadrado ≈ 0,8). Se mantiene k por la paridad.
//
//  Roles del tema: paper, ink (el «luto» de v1) y quiet (el «sepia»: la obra).
//  v1 no tenía acento ni guía; el acento no se usa.
//  El viñeteado de la textura (v1): con el papel por defecto, el sepia de la
//  lámina; con otro papel, ese papel muy oscurecido.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ" as superbg
#import "/src/modules/fleurones/fleurones.typ" as fl

#let _paper = rgb("#f3eee3")

#let _default-theme = (
  paper: _paper,
  ink: rgb("#141210"),
  quiet: rgb("#4a443c"),
  accent: none, // v1 no tenía acento
)

// Viñeta: auto = el glifo de FLOWERS 2 de la lámina, como texto (`g` de cuerpo,
// con `bordes` ajustados o no); un nombre de `fleurones.vinetas`; o contenido.
#let _vignette(v, c, size, color, bordes: false) = {
  if v == none { return none }
  if v == auto {
    let t = text(font: fl.f2, size: size, fill: color, c)
    return if bordes { text(top-edge: "bounds", bottom-edge: "bounds", t) } else { t }
  }
  if type(v) == str { fl.vineta(v, size * 0.7, color) } else { v }
}

#let _vignetting(paper) = if paper == _paper { rgb("#5a4a32") } else {
  color.mix((paper, 35%), (black, 65%))
}

#let _rules(ctx, border, inner, symbol, vignette, footer-vignette, texture) = {
  let p = ctx.parts
  let body-of(kind) = { let e = p.at(kind, default: none); if e == none { none } else { e.body } }
  let props-of(kind) = { let e = p.at(kind, default: none); if e == none { (:) } else { e.props } }
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (paper, ink, quiet) = (tm.paper, tm.ink, tm.quiet)
  let formato = (width / 1pt, height / 1pt)
  let k = calc.min(formato.at(0) / 1080, formato.at(1) / 1350)

  let headline = if "headline" in p { p.headline.body } else { ctx.loose }
  let hp = props-of("headline")
  let subhead = body-of("subhead")
  let prose = body-of("prose")
  let author = body-of("author")
  let work = body-of("work")
  let brand = ctx.brand

  let size-of(kind) = { let pr = props-of(kind); if "size" in pr { (ctx.len)(pr.size) } else { 52pt * k } }
  let size-headline = if "size" in hp { (ctx.len)(hp.size) } else { 132pt * k }
  let font-body = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("im-fell-english") }
  let font-headline = if "font" in hp { (ctx.font)(hp.font) } else if "display" in ctx.fonts { ctx.fonts.display } else { (ctx.font)("im-fell-french-canon-sc") }
  let font-sc = if "smallcaps" in ctx.fonts { ctx.fonts.smallcaps } else { (ctx.font)("im-fell-english-sc") }

  {
    set text(font: font-body, fill: ink, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    if texture {
      superbg.superbg((capas: (
        (tipo: "plano", color: paper),
        (tipo: "ruido", color: ink, opacidad: 6%),
        (tipo: "vignette", color: _vignetting(paper), intensidad: 18%),
      )), size: formato)
    }

    // ── Orla ──
    if border == "mourning" {
      place(top + left, dx: 40pt * k, dy: 40pt * k, rect(
        width: width - 80pt * k, height: height - 80pt * k, stroke: 30pt * k + ink,
      ))
    } else if border != none {
      let g = fl.cadenas.at(border).grosor * k * 0.88
      let m = 26pt * k
      place(top + left, dx: m, dy: m, fl.orla(border, width - 2 * m, height - 2 * m, ink, grosor: g))
    }
    if inner == "rule" {
      place(top + left, dx: 80pt * k, dy: 80pt * k, rect(
        width: width - 160pt * k, height: height - 160pt * k, stroke: 1.5pt * k + ink,
      ))
    } else if inner != none {
      let m = 68pt * k
      place(top + left, dx: m, dy: m, fl.orla(inner, width - 2 * m, height - 2 * m, ink, grosor: 18pt * k))
    }

    let box-w = width - 240pt * k
    // El nombre se compone a `headline.size`, o al ancho de la caja si no cabe.
    let name = context {
      let make(s) = text(font: font-headline, size: s, tracking: 0.03em, headline)
      let w = measure(make(size-headline)).width
      make(if w > box-w { size-headline * (box-w / w) } else { size-headline })
    }

    // ── Bloque central, entre la orla y el pie ──
    place(top + center, dy: 110pt * k, block(width: box-w, height: height - 570pt * k, align(center + horizon, {
      if symbol == "cross" {
        box(width: 64pt * k, height: 120pt * k, {
          place(top + center, rect(width: 11pt * k, height: 120pt * k, fill: ink))
          place(top + center, dy: 30pt * k, rect(width: 64pt * k, height: 11pt * k, fill: ink))
        })
        v(46pt * k)
      } else if symbol != none {
        symbol
        v(46pt * k)
      }
      if subhead != none {
        text(size: size-of("subhead"), style: "italic", par(leading: 0.5em, subhead))
        v(54pt * k)
      }
      let vc = _vignette(vignette, "g", 60pt * k, ink)
      if vc != none {
        vc
        v(40pt * k)
      }
      name
      v(36pt * k)
      line(length: 260pt * k, stroke: 1.2pt * k + ink)
      if prose != none {
        v(52pt * k)
        text(size: size-of("prose"), style: "italic", par(leading: 0.5em, prose))
      }
    })))

    // ── Pie: filete — florón — filete, autor, obra ──
    place(bottom + center, dy: -210pt * k, block(width: box-w, align(center, {
      let vp = _vignette(footer-vignette, "x", 44pt * k, ink, bordes: true)
      box(grid(columns: 3, column-gutter: 18pt * k, align: horizon,
        line(length: 120pt * k, stroke: 1pt * k + ink),
        vp,
        line(length: 120pt * k, stroke: 1pt * k + ink),
      ))
      if author != none {
        v(40pt * k)
        text(font: font-sc, size: 34pt * k, tracking: 0.08em, author)
      }
      if work != none {
        v(12pt * k)
        text(size: 30pt * k, style: "italic", fill: quiet, work)
      }
    })))
    if brand != none { place(bottom + center, dy: -118pt * k, brand) }
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  border: "mourning",
  inner: "rule",
  symbol: "cross",
  vignette: auto,
  footer-vignette: auto,
  texture: true,
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
  known: ("headline", "subhead", "prose", "author", "work", "brand"),
  fn: "obituary",
  elements: elements,
  rules: ctx => _rules(ctx, border, inner, symbol, vignette, footer-vignette, texture),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "obituary", make: make, variants: ())
#let obituary = frame.with(preset: preset)
