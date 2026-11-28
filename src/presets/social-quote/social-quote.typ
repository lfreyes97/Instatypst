// ─────────────────────────────────────────────────────────────
//  social-quote.typ — el preset `social-quote` (en v1, `carteles.cita-social`)
//
//  social-quote = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): main, author, handle, date, tag, brand;
//  cada uno también como argumento (`author: […]`). La cita es el `quote` de
//  Typst (o el contenido suelto; también vale `main`, que además lleva su
//  tamaño). El autor (v1 `nombre`) es `author`; `handle` es el nombre de cuenta
//  («@alguien», v1 `usuario`); `date`, la fecha; `tag`, la línea de contexto
//  sobre la cita («En respuesta a @x», «De _La obra_»; v1 `contexto`).
//
//  Propiedades de los elementos:
//    main.size, main.min-size   el cuerpo máximo y el mínimo de la cita (v1 `cuerpo`
//                               y `minimo`). El cuerpo se ajusta solo: el mayor
//                               tamaño, hasta `size`, con el que todo cabe en el
//                               área; si no cabe ni a `min-size`, error.
//    author.position            "bottom" (por defecto) | "top" | "side": dónde va la
//                               atribución (v1 `atribucion`); con "side" la foto
//                               queda a la izquierda y la cita a la derecha.
//
//  Opciones del preset:
//    variant      el aspecto (v1 `estilo`; cada uno con su tema propio):
//                 "classic"    tarjeta blanca sobre fondo oscuro (por defecto)
//                 "post"       publicación genérica de red social   (v1 "publicacion")
//                 "chat"       burbuja de chat con cola              (v1 "mensaje")
//                 "editorial"  serif grande entre filetes            (v1 "editorial")
//                 "paper"      hoja crema con grano, tinta sepia     (v1 "papel")
//                 "chalkboard" encerado con marco y tiza             (v1 "pizarra")
//                 "clipping"   recorte de periódico rasgado          (v1 "recorte")
//                 "aura"       halos vivos y tarjeta de cristal      (v1 "aura")
//                 "minimal"    mucho aire, una línea                 (v1 "minimal")
//                 "underline"  el rotulador como protagonista        (v1 "subrayado")
//    style        la superficie de la cita (v1 `variante`, que aquí no es la variante
//                 del preset): "card" (la tarjeta flota centrada, por defecto) |
//                 "bleed" (la tarjeta llena el área) | "open" (sin tarjeta)
//    verified     una insignia tras el nombre (v1 `verificado`)
//    metrics      (comments:, shares:, likes:, views:): números o textos (v1 `metricas`)
//    reply        la publicación citada: contenido o (text:, name:, handle:) (v1 `respuesta`)
//    note-left, note-right   (icon:, text:) bajo la tarjeta; solo "classic" + "card"
//    area, anchor  el rectángulo de la página que usa el preset (v1 `area`, `ancla`)
//    initials, photo, quote-mark   PENDIENTES como recursos (`initials`, `photo`,
//                 `quote-mark`: no existen). Mientras tanto son opciones: las iniciales
//                 del avatar (v1 `iniciales`, "??"), la foto (v1 `foto`: una ruta o
//                 bytes con `read(…, encoding: none)`) y la comilla decorativa
//                 (v1 `comilla`).
//
//  Escala: la de v1, k = mín(ancho/1080, alto/1350); se conserva para la paridad.
//  Un número en `main.size` es u (`DEUDA.md` §1.6) y se pasa a unidades de lámina.
//
//  Fuentes: cada variante trae las suyas; `fonts:` (rol body) las sobreescribe
//  todas, como `fuente` en v1.
//  Tema: los cinco roles más `card` (v1 `tarjeta`, la tarjeta o la burbuja) y, según
//  la variante, `dots` (trama), `grain` (grano), `tape` (cinta), `border` (marco),
//  `deep`, `haze` y `light` (v1 `trama`, `grano`, `cinta`, `marco`, `hondo`,
//  `bruma`, `claro`). El tema de cada variante es su `theme`. DIFERENCIA con v1: un
//  tema parcial conserva el filete (`guide`), la trama y el grano de la variante;
//  v1 los volvía a derivar si el tema cambiaba `card` o `ink` (salvo en "classic").
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "_common.typ": validate
#import "variants/classic.typ" as _classic
#import "variants/post.typ" as _post
#import "variants/chat.typ" as _chat
#import "variants/editorial.typ" as _editorial
#import "variants/paper.typ" as _paper
#import "variants/chalkboard.typ" as _chalkboard
#import "variants/clipping.typ" as _clipping
#import "variants/aura.typ" as _aura
#import "variants/minimal.typ" as _minimal
#import "variants/underline.typ" as _underline

#let _variants = (
  classic: _classic.variant, post: _post.variant, chat: _chat.variant, editorial: _editorial.variant,
  paper: _paper.variant, chalkboard: _chalkboard.variant, clipping: _clipping.variant,
  aura: _aura.variant, minimal: _minimal.variant, underline: _underline.variant,
)
#let _themes = (
  classic: _classic.theme, post: _post.theme, chat: _chat.theme, editorial: _editorial.theme,
  paper: _paper.theme, chalkboard: _chalkboard.theme, clipping: _clipping.theme,
  aura: _aura.theme, minimal: _minimal.theme, underline: _underline.theme,
)

#let _check-variant(variant) = assert(variant in _variants, message: "social-quote: variante desconocida "
  + repr(variant) + " (hay: " + _variants.keys().join(", ") + ")")

#let _rules(ctx, variant, o) = {
  let (width, height) = (ctx.width, ctx.height)
  let k = calc.min(width / 1pt / 1080, height / 1pt / 1350)
  let p = ctx.parts
  let part(name) = { let x = p.at(name, default: none); if x == none { none } else { x.body } }
  let author = p.at("author", default: none)
  let position = if author == none { "bottom" } else { author.props.at("position", default: "bottom") }
  if position not in ("bottom", "top", "side") {
    panic("social-quote: author.position es \"bottom\", \"top\" o \"side\", no " + repr(position))
  }
  if o.style not in ("card", "bleed", "open") {
    panic("social-quote: style es \"card\", \"bleed\" u \"open\", no " + repr(o.style))
  }
  // la cita: `main` si se da; si no, el contenido suelto (un `quote` de Typst o texto)
  let quote-body = if part("main") != none { part("main") } else { ctx.loose }
  let main-props = if "main" in p { p.main.props } else { (:) }
  let to-units(v) = if type(v) == length { v / (k * 1pt) } else { (ctx.len)(v) / (k * 1pt) }
  let size = if "size" in main-props { to-units(main-props.size) } else { none }
  let min-size = if "min-size" in main-props { to-units(main-props.min-size) } else { none }
  let d = (
    quote: quote-body,
    name: if author == none { [] } else { author.body },
    initials: o.initials, photo: o.photo,
    position: position, layout: o.style, quote-mark: o.quote-mark,
    artboard: (width / 1pt, height / 1pt),
    brand: ctx.brand,
    c: ctx.tm,
    font: if "body" in ctx.fonts { ctx.fonts.body } else { none },
    size: size, min-size: min-size,
    area: o.area, anchor: o.anchor,
    note-left: o.note-left, note-right: o.note-right,
    handle: part("handle"), date: part("date"), tag: part("tag"),
    verified: o.verified, metrics: o.metrics, reply: o.reply,
  )
  validate(d)
  // una cita de Typst se dibuja como su cuerpo (sin comillas ni sangría)
  show quote: it => it.body
  (_variants.at(variant))(d)
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  variant: "classic",
  style: "card",
  initials: "??",
  photo: none,
  quote-mark: false,
  note-left: none,
  note-right: none,
  area: 1,
  anchor: center + horizon,
  verified: false,
  metrics: none,
  reply: none,
  ..elements,
) = {
  _check-variant(variant)
  let default-theme = _themes.at(variant)
  let roles = ("paper", "ink", "quiet", "accent", "guide")
  scaffold(
    body,
    artboard: artboard,
    theme: theme,
    accent: accent,
    brand: brand,
    fonts: fonts,
    default-theme: default-theme,
    default-fonts: none,
    extra-roles: default-theme.keys().filter(r => r not in roles),
    known: ("main", "author", "handle", "date", "tag", "brand"),
    fn: "social-quote",
    elements: elements,
    rules: ctx => _rules(ctx, variant, (
      style: style, initials: initials, photo: photo, quote-mark: quote-mark,
      note-left: note-left, note-right: note-right, area: area, anchor: anchor,
      verified: verified, metrics: metrics, reply: reply,
    )),
  )
}

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "social-quote", make: make, variants: _variants.keys())
#let social-quote = frame.with(preset: preset)
