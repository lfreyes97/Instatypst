// ─────────────────────────────────────────────────────────────
//  tip.typ — el preset `tip` (en v1, `carteles.consejo`)
//
//  tip = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): numeral, headline, prose, tag, brand;
//  cada uno también como argumento (`numeral: [3]`). Opciones del preset:
//  margin; el resto viaja en las propiedades de los elementos (headline.size,
//  prose.size), en el tema y en `fonts`.
//
//  Un color sólido y tipografía: el número es una letra gigante, en tono sobre
//  tono, que sangra por el borde inferior derecho; encima, la etiqueta en una
//  píldora, el título en sans pesada y la explicación. Sirve para consejos,
//  pasos, razones, puntos de una serie: cualquier cosa que lleve numeral.
//
//  Contenido (v1 → V2): `numero` → `#numeral[…]`, `titulo` → `#headline[…]`,
//  `texto` → `#prose[…]`, `etiqueta` → `#tag[…]`, `marca` → `brand`. Un título
//  suelto (sin `#headline`) también vale: es el contenido suelto.
//  `headline.size` (v1 `cuerpo-titulo`, 112 pt) es el tope: el título se achica
//  solo hasta caber en la mitad superior. `prose.size` (v1 `cuerpo-texto`, 44 pt).
//  Número = u, longitud = absoluta.
//
//  Escala: pt absolutos, como en v1 (no usa `k`); en formatos más altos que 4:5
//  el numeral y el título crecen con la proporción.
//
//  Fuente: Jost (v1), por el token `jost`; `fonts:` la sobreescribe.
//
//  Tema: los cinco roles, con los valores de v1 (mostaza y tinta casi negra); sin
//  `guide` (v1 no lo tenía; modules/color lo deriva).
//
//  Pendiente: el tono del numeral (v1 `sombra`) es el recurso `shadow`, que aún
//  no existe. Se dibuja siempre, como v1: #d29d21 con el tema por defecto, y la
//  tinta al 14 % sobre el papel si el tema cambia papel o tinta.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame

#let _default-theme = (
  paper: rgb("#f0b323"),
  ink: rgb("#181818"),
  quiet: rgb("#3a3210"),
  accent: none, // v1 no tenía acento y tip no lo usa (no se inventa un valor)
)

#let _default-shadow = rgb("#d29d21")

#let _rules(ctx, margin) = {
  let part(k) = ctx.parts.at(k, default: none)
  let body-of(k) = { let p = part(k); if p == none { none } else { p.body } }
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (paper, ink) = (tm.paper, tm.ink)
  // pendiente: recurso `shadow`. Como en v1: el tema por defecto trae el tono fijo;
  // si el tema cambia papel o tinta, se deriva (tinta al 14 % sobre el papel).
  let shadow = if paper == _default-theme.paper and ink == _default-theme.ink { _default-shadow } else {
    color.mix((paper, 86%), (ink, 14%))
  }
  let brand = ctx.brand
  let margin = (ctx.len)(margin)
  let useful = width - 2 * margin
  let side = calc.min(width, height)
  // en formatos más altos que 4:5 (story) el numeral y el título crecen con la proporción
  let tall = if height / width > 1.5 { height / width / 1.25 } else { 1 }

  let numeral = body-of("numeral")
  let tag = body-of("tag")
  let hp = part("headline")
  let headline = if hp == none { ctx.loose } else if ctx.has-loose { hp.body + parbreak() + ctx.loose } else { hp.body }
  let prose = body-of("prose")
  let pp = part("prose")
  let max-headline = if hp != none and "size" in hp.props { (ctx.len)(hp.props.size) } else { 112pt }
  let size-prose = if pp != none and "size" in pp.props { (ctx.len)(pp.props.size) } else { 44pt }

  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("jost") }

  {
    set text(font: family, fill: ink, lang: "es", hyphenate: false)
    set par(leading: 0.28em)

    context {
      // el numeral: abajo a la derecha, sangrando por el borde
      if numeral != none {
        let make-num(s) = text(size: s, weight: 900, fill: shadow, top-edge: "cap-height", bottom-edge: "baseline", numeral)
        let s-num = calc.min(side * 1.0 * tall, (ctx.fit-width)(make-num, width * 0.98))
        let num = make-num(s-num)
        let (nw, nh) = (measure(num).width, measure(num).height)
        place(dx: width - nw + 0.04 * width, dy: height - nh + 0.07 * height, num)
      }

      // la etiqueta, arriba
      let y = margin
      if tag != none {
        let pill = box(
          fill: ink, radius: 100pt, inset: (x: 30pt, y: 14pt),
          text(size: 26pt, weight: 700, tracking: 0.16em, fill: paper, upper(tag)),
        )
        place(dx: margin, dy: y, pill)
        y += measure(pill).height + 0.045 * height
      }

      // la marca, abajo a la izquierda
      let h-brand = if brand != none { measure(brand).height } else { 0pt }
      if brand != none { place(dx: margin, dy: height - margin - h-brand, brand) }

      // título y texto: el título se achica hasta caber en el alto que le toca
      let prose-block = if prose != none {
        block(width: useful, text(size: size-prose, weight: 500, fill: ink, prose))
      }
      let air = 0.5 * size-prose
      let h-prose = if prose-block != none { measure(prose-block).height + air } else { 0pt }
      let top = calc.min(height * 0.5, height - y - margin - h-brand - 0.04 * height - h-prose)
      let make(s) = block(width: useful, text(size: s, weight: 800, tracking: -0.02em, headline))
      let s = (ctx.fit-down)(make, max-headline * tall, top, min: 48pt, paso: 2pt)
      let stack = {
        make(s)
        if prose-block != none {
          v(air + 0.05 * s)
          prose-block
        }
      }
      place(dx: margin, dy: y, block(width: useful, stack))
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
  margin: 88pt,
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
  known: ("numeral", "headline", "prose", "tag", "brand"),
  fn: "tip",
  elements: elements,
  rules: ctx => _rules(ctx, margin),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "tip", make: make, variants: ())
#let tip = frame.with(preset: preset)
