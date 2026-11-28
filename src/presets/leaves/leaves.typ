// ─────────────────────────────────────────────────────────────
//  leaves.typ — el preset `leaves` (en v1, `carteles.hojas`)
//
//  leaves = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): headline, prose, caption, footer, tag,
//  note, brand; cada uno también como argumento (`caption: […]`).
//  Propiedades: headline.weight (el peso de los títulos, 800), prose.size (el
//  tamaño del párrafo) y prose.font (la tipografía del párrafo y la nota).
//  Opciones del preset: variant, side, ring-radius, hole-radius, guides.
//
//  Portada geométrica en dos colores (amarillo y azul sobre blanco, con negro
//  para el texto) hecha con una sola pieza, la «hoja» de
//  resources/motifs/_hojas-piezas.typ: un cuadrado con tres esquinas redondeadas
//  y una aguda, con un anillo del otro color y un hueco del color del papel.
//  Tres composiciones, que son las variantes (variants/):
//
//    "flower"    cuatro hojas en 2 × 2 con la punta al centro (por defecto).
//                Usa también footer, tag y note.      (v1: "flor")
//    "diagonal"  dos hojas que se tocan por la punta, un punto negro y el título
//                apilado abajo.                       (v1: "diagonal")
//    "pattern"   una cinta de pares de hojas a 45° que el borde recorta.
//                                                     (v1: "patron")
//
//  Una variante es una función `c => contenido`; _kit.typ arma el contexto `c`
//  (escala, cajas de texto medidas, rótulo vertical, guías) que comparten.
//
//  Escala: la de v1, k = mín(ancho/380, alto/475) (en apaisado, alto/400): las
//  cotas de las variantes están en unidades de una lámina de 380 de ancho. Se
//  conserva k para la paridad. Un número en `prose.size` es u (Spec §3) y se
//  pasa a unidades de lámina; por defecto 8,3 unidades, como v1.
//
//  Fuentes: Poppins para títulos y rótulo, Inter para párrafo y nota (los tokens
//  `poppins` e `inter`; `fonts:` los sobreescribe por rol display y body).
//  Ninguna pareja de typography trae las dos. Roles del tema: los cinco más uno
//  propio, `deep` (el azul de las hojas); `accent` es el amarillo.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "_kit.typ": kit
#import "variants/flower.typ" as _flower
#import "variants/diagonal.typ" as _diagonal
#import "variants/pattern.typ" as _pattern

#let _variants = (flower: _flower.variant, diagonal: _diagonal.variant, pattern: _pattern.variant)

// el mismo tema que hojas en v1 (papel blanco, tinta negra, amarillo y azul)
#let _default-theme = (
  paper: rgb("#ffffff"),
  ink: rgb("#000000"),
  quiet: rgb("#111111"),
  accent: rgb("#f9c90f"),
  deep: rgb("#2a3ed3"),
)

#let _rules(ctx, variant, side, ring-radius, hole-radius, guides) = {
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (w, h) = (width / 1pt, height / 1pt)
  // En vertical y en cuadrado manda el ancho (hasta 4:5); en apaisado, el alto,
  // contado como 400 unidades (los textos no se quedan chicos).
  let k = if w > h { calc.min(w / 380, h / 400) } else { calc.min(w / 380, h / 475) }
  let p = ctx.parts
  let part(name) = { let x = p.at(name, default: none); if x == none { none } else { x.body } }
  // Nada es obligatorio (Spec §1.4): sin `headline`, el contenido suelto es el
  // título; con `headline`, el suelto sigue a la prosa, en otro párrafo.
  let loose = if ctx.has-loose { ctx.loose } else { none }
  let headline = part("headline")
  let prose = part("prose")
  if headline == none { headline = if loose == none { [] } else { loose } } else if loose != none {
    prose = if prose == none { loose } else { prose + parbreak() + loose }
  }
  let parts = (
    headline: headline,
    prose: prose,
    caption: part("caption"),
    footer: part("footer"),
    tag: part("tag"),
    note: part("note"),
  )
  let prose-props = if "prose" in p { p.prose.props } else { (:) }
  let headline-props = if "headline" in p { p.headline.props } else { (:) }
  let to-units(v) = if type(v) == length { v / (k * 1pt) } else { (ctx.len)(v) / (k * 1pt) }
  let size = if "size" in prose-props { to-units(prose-props.size) } else { 8.3 }
  let weight = headline-props.at("weight", default: 800)
  let display = if "display" in ctx.fonts { ctx.fonts.display } else { (ctx.font)("poppins") }
  let body = if "font" in prose-props { (ctx.font)(prose-props.font) } else if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("inter") }
  let roles = (paper: tm.paper, ink: tm.ink, quiet: tm.quiet, accent: tm.accent, deep: tm.deep)

  {
    set text(lang: "es", hyphenate: false)
    context {
      let c = kit(
        width, height, k, roles, parts,
        display: display, body: body, weight: weight, size: size,
        side: side, ring: ring-radius, hole: hole-radius, guides: guides,
      )
      (_variants.at(variant))(c)
      if ctx.brand != none {
        place(bottom + center, dy: -(c.L)(16), ctx.brand)
      }
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
  variant: "flower",
  side: auto,
  ring-radius: 0.30,
  hole-radius: 0.185,
  guides: false,
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
  extra-roles: ("deep",),
  // `footer`, `tag` y `note` son de "flower": en las otras variantes no se
  // reconocen y llegan como contenido suelto (Spec §1.4), sin error
  known: ("headline", "prose", "caption", "brand") + if variant == "flower" { ("footer", "tag", "note") } else { () },
  fn: "leaves",
  elements: elements,
  rules: ctx => _rules(ctx, variant, side, ring-radius, hole-radius, guides),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "leaves", make: make, variants: _variants.keys())
#let leaves = frame.with(preset: preset)
