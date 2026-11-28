// ─────────────────────────────────────────────────────────────
//  bands.typ — el preset `bands` (en v1, `carteles.franjas`)
//
//  bands = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): quote, headline, footer, brand; cada
//  uno también como argumento (`headline: […]`). La cita (`quote`) es el `quote`
//  de Typst: el preset lo reconoce en el cuerpo y lo estiliza con `show` (se
//  dibuja su cuerpo, sin comillas añadidas); el contenido suelto del cuerpo
//  cuenta como cita. Propiedades de los elementos: main.weight y
//  main.max-size (la cita), headline.size y headline.font, footer.size,
//  footer.height y footer.gap. Opciones del preset: image, veil, text-to,
//  stretch, header, rule, margin, text-margin.
//
//  Cartel de cita con dos franjas y una ilustración al fondo: una cabecera de
//  color con la marca centrada, un título en mayúsculas condensadas, una regla
//  del color de la cabecera y la cita centrada. Debajo, la ilustración a
//  sangre, tapada por un velo del color del papel que se disuelve de arriba
//  abajo. Cierra una tira oscura con el pie. Las franjas y el texto no se
//  mueven con el alto: lo que crece es la ilustración.
//
//  Escala: las medidas son las de v1, pensadas sobre 1080 px de ancho y
//  escaladas con k = mín(ancho/1080, alto/1080). Aquí k coincide con `u`
//  (lado corto / 1080). Los números de la API son `u`; una longitud es absoluta.
//
//  Fuentes: Bricolage Grotesque (la cita) y Bebas Neue (el titular), las de v1.
//  Ninguna pareja de typography las trae: se toman familias sueltas.
//
//  Roles del tema: los cinco más uno propio, `strip` (la tira del pie), que pasa
//  por modules/color como los demás. `quiet` es el color del pie.
//  El velo (v1 `velo`) es un recurso que aún no existe: se dibuja siempre, como
//  en v1, y solo si hay imagen. `image` (v1 `imagen`) es contenido del usuario
//  bajo el velo; el recurso `image` no existe, así que es opción del preset.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame

#let _default-theme = (
  paper: rgb("#00090e"),
  ink: rgb("#ffffff"),
  quiet: rgb("#ffffff"),
  accent: rgb("#9e413a"),
  // sin `guide`: v1 no lo tenía y bands no lo usa; modules/color lo deriva
  strip: rgb("#1a1a1a"),
)

#let _rules(ctx, image, veil, text-to, stretch, header, rule, margin, text-margin) = {
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, quiet, accent, strip, paper) = (tm.ink, tm.quiet, tm.accent, tm.strip, tm.paper)
  let k = calc.min(width / 1pt / 1080, height / 1pt / 1080)
  // una medida de la API (número = u, longitud = absoluta) o la de v1 escalada
  let dim(v, default) = if v == auto { default * k } else { (ctx.len)(v) }

  let p = ctx.parts
  let prop(kind, name, default) = {
    let e = p.at(kind, default: none)
    if e == none or name not in e.props { default } else { e.props.at(name) }
  }
  let qp = p.at("quote", default: none)
  let quote-body = if qp != none { qp.body } else { ctx.loose }
  let hp = p.at("headline", default: none)
  let fp = p.at("footer", default: none)
  let brand = ctx.brand

  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("Bricolage Grotesque") }
  let weight = prop("main", "weight", "extralight")
  let max-size = dim(prop("main", "max-size", auto), 43pt)
  let headline-font = (ctx.font)(prop("headline", "font", "Bebas Neue"))
  let headline-size = dim(prop("headline", "size", auto), 52pt)
  let footer-size = dim(prop("footer", "size", auto), 31pt)
  let footer-height = dim(prop("footer", "height", auto), 57pt)
  let footer-gap = dim(prop("footer", "gap", auto), 20pt)

  let cab = dim(header, 134pt)
  let m = dim(margin, 69pt)
  let box-width = width - 2 * m
  let text-box = width - 2 * dim(text-margin, 78pt)
  let rule-height = dim(rule, 2.2pt)

  {
    set text(fill: ink, lang: "es", hyphenate: false)

    // la imagen a sangre y, encima, el velo del color del papel
    if image != none {
      place(top + left, box(width: width, height: height, clip: true, image))
      place(top + left, rect(
        width: width, height: height, stroke: none,
        fill: gradient.linear(
          angle: 90deg,
          (paper, 0%), (paper, veil.at(0)),
          (paper.transparentize(100%), veil.at(1)), (paper.transparentize(100%), 100%),
        ),
      ))
    }

    // cabecera con la marca
    place(top + left, rect(width: width, height: cab, fill: accent, stroke: none))
    if brand != none {
      place(top + left, box(width: width, height: cab, align(center + horizon, brand)))
    }

    // titular y regla; `y` es el borde de arriba del siguiente bloque
    let y = cab
    if hp != none {
      let the-headline(c) = text(
        font: headline-font, size: c, top-edge: "cap-height", bottom-edge: "baseline", upper(hp.body),
      )
      // la base del titular queda fija (cap-height natural a 48 pt de la
      // cabecera); si se achica para caber, baja la parte de arriba
      let cap-natural = 0.7 * headline-size
      let y-base = y + 48pt * k + cap-natural
      context {
        let natural = headline-size
        let natural-width = measure(the-headline(natural)).width
        let c = if natural-width > box-width { natural * (box-width / natural-width) } else { natural }
        place(top + center, dy: y-base - 0.7 * c, the-headline(c))
      }
      let y-rule = y-base + 16pt * k
      place(top + left, dx: m, dy: y-rule, rect(width: box-width, height: rule-height, fill: accent, stroke: none))
      y = y-rule + rule-height
    }

    // la cita: de la regla (a 24 pt) hasta `text-to`
    let y-quote = y + 24pt * k
    let room = height * text-to - y-quote
    let block-of(c) = block(width: text-box, align(center, text(
      font: family, weight: weight, stretch: stretch, size: c,
      top-edge: "cap-height", bottom-edge: "baseline", {
        show quote: it => it.body
        quote-body
      },
    )))
    context {
      set par(leading: 0.43em)
      let c = (ctx.fit-down)(block-of, max-size, room, min: 18pt * k)
      place(top + center, dy: y-quote, block-of(c))
    }

    // tira del pie
    if fp != none {
      place(bottom + left, dy: -footer-gap, box(
        width: width, height: footer-height, fill: strip,
        align(center + horizon, text(font: family, weight: weight, stretch: stretch, size: footer-size, fill: quiet, fp.body)),
      ))
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
  image: none,
  veil: (34%, 92%),
  text-to: 60%,
  stretch: 75%,
  header: auto,
  rule: auto,
  margin: auto,
  text-margin: auto,
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
  extra-roles: ("strip",),
  known: ("quote", "headline", "footer", "brand"),
  fn: "bands",
  elements: elements,
  rules: ctx => _rules(ctx, image, veil, text-to, stretch, header, rule, margin, text-margin),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "bands", make: make, variants: (), artboard: "cuadrado") // franjas era cuadrado en v1
#let bands = frame.with(preset: preset)
