// ─────────────────────────────────────────────────────────────
//  plain/plain.typ — el preset `plain`: el lienzo y su color
//
//  Sirve para dos cosas: es el scaffold de los demás presets (todo preset es
//  plain + un conjunto de reglas) y es lo simple, donde quien escribe compone a
//  mano:
//
//    #frame(theme: wine)[#align(horizon + center)[#text(font: "Fraunces", 4em)[Hola lola]]]
//
//  variant: auto   el cuerpo se dibuja tal cual, dentro del margen. Ningún
//                  elemento tiene reglas: `#main[Hola]` sale igual que
//                  `#text[Hola]`, como un `h1` sin estilar.
//  variant: "post" (variants/post.typ) el post rápido para redes (en v1, la composición de `liso`):
//                  el texto principal, un epígrafe arriba, el autor bajo el texto
//                  y la marca abajo a la izquierda.
//
//  Los elementos están en elements.typ. Los que reconoce "post":
//    main(size:, weight:, tracking:, max-size:, align:)   el texto; si falta, el
//                       contenido suelto ocupa su lugar
//    epigraph(source:, size:)   cita breve arriba, en cursiva y atenuada
//    author(size:)      «— autor» bajo el texto
//    brand              abajo a la izquierda (también acepta `brand:` en frame)
//  Opciones: margin (96), fonts (auto, una familia o (body: …)).
//
//  Composición de "post" (la de liso):
//    · el bloque (texto + autor) se coloca en el centro óptico del hueco que dejan
//      los márgenes, el epígrafe y la marca: el aire de arriba es 2/3 del de abajo
//    · `size: auto` ajusta el texto: parte de `max-size` (150) y baja de 2 en 2
//      hasta caber, sin bajar de 28; con un `size` dado no se ajusta nada
//    · el autor mide 0,26 del texto (mínimo 24) y va a 0,45 del texto por debajo
//    · con marca se reservan 96 abajo, y la marca se apoya a 24 sobre el margen
//  Valores por defecto neutros: texto de 44, peso regular, sin tracking.
//  Los números son u (lado corto / 1080); las longitudes, absolutas.
//  Lo que liso hacía con `desgaste` (tinta gastada) es un recurso y no está.
// ─────────────────────────────────────────────────────────────

#import "/src/frame.typ": frame
#import "scaffold.typ": scaffold
#import "/src/core/artboard.typ": unit, len
#import "variants/post.typ" as _post

// Cada variante es un conjunto de reglas (ctx => contenido), en su archivo de
// variants/, con los elementos que reconoce.
#let _variants = (post: (rules: _post.variant, known: _post.known))
#let variants = _variants.keys()

// variant: auto — las reglas mínimas: el cuerpo tal cual, dentro del margen.
#let _auto(ctx) = {
  ctx.body
  if ctx.brand != none { place(bottom + left, dy: 24 * ctx.u, ctx.brand) }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  brand: none,
  variant: auto,
  margin: 96,
  fonts: auto,
  ..elements,
) = {
  if variant != auto and variant not in _variants {
    panic("plain: variante desconocida " + repr(variant) + " (hay: " + variants.join(", ") + ")")
  }
  let common = (artboard: artboard, theme: theme, brand: brand, fonts: fonts, elements: elements, fn: "plain")
  if variant == auto {
    // el margen es el de la página: el cuerpo fluye dentro
    scaffold(body, ..common, page-margin: len(margin, unit(artboard)), rules: _auto)
  } else {
    let v = _variants.at(variant)
    scaffold(body, ..common, known: v.known,
      rules: ctx => (v.rules)(ctx + (margin: (ctx.len)(margin))))
  }
}

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "plain", make: make, variants: variants)
#let plain = frame.with(preset: preset)
