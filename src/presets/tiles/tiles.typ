// ─────────────────────────────────────────────────────────────
//  tiles.typ — el preset `tiles` (en v1, `carteles.teselas`)
//
//  tiles = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): tag, main, conclusion, author, brand;
//  cada uno también como argumento (`author: […]`).
//  Propiedades: main.size (el tamaño máximo del párrafo).
//  Opción del preset: tile (el bloque de teselas).
//
//  Cartel con un bloque cuadrado de teselas —una cuadrícula de 4×4 celdas con
//  algún bloque de 2×2— en tres colores que rotan de fondo y de figura: discos
//  y «dianas» (un aro con un punto). Encima, un título en negrita (tag), un
//  párrafo (main) y una palabra pesada (conclusion) que se parte en una columna
//  estrecha a la derecha («DE / SI / G / N»); el autor, en una línea chica bajo
//  el párrafo.
//
//  Las medidas salen de una lámina de referencia de 300 × 425 y se escalan con
//  el lado menor; en otro formato la lámina queda centrada y el papel llena el
//  resto. La capa de texto es la de resources/motifs/_texto.typ (la misma que
//  mosaic).
//
//  `tile`: una lista de teselas `(col, fila, span, fondo, motivo, color)`, con
//  `span` 1 o 2 (celdas por lado), `fondo` y `color` ROLES del tema (paper,
//  ink, quiet, accent, deep, light) y `motivo` "disco", "diana" o none. En v1 los
//  roles eran en español (acento, hondo, claro); ahora son los del tema V2.
//
//  Escala: la de la lámina (k = lado menor), no `u`; main.size es u vía
//  `ctx.len` (v1: `cuerpo`, en unidades de la lámina de 300 de ancho).
//
//  Fuente: Outfit (v1; token `outfit`, o `fonts:` si se da). Ninguna pareja de
//  typography la trae. Roles del tema: los cinco más dos propios, `deep` (azul
//  hondo) y `light` (crema). `guide` no se usa (lo deriva modules/color).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/resources/motifs/_texto.typ": capa-texto

// el mismo tema que teselas en v1: papel blanco, tinta casi negra, y carmesí,
// azul marino y crema que rotan de fondo y de figura en el bloque
#let _default-theme = (
  paper: rgb("#ffffff"),
  ink: rgb("#100f0d"),
  quiet: rgb("#656263"),
  accent: rgb("#d8225a"),
  deep: rgb("#19253c"),
  light: rgb("#f8f1cd"),
)

// Lámina de referencia (unidades) y su bloque de teselas.
#let _ref = (300, 425)
#let _margin = 25.1 // a los lados y bajo el bloque
#let _block = 250 // lado del bloque (4 celdas)
#let _cell = 62.5

// El bloque de la referencia: (col, fila, span, fondo, motivo, color).
#let reference-tile = (
  (0, 0, 2, "accent", "disco", "deep"),
  (2, 0, 1, "accent", "diana", "light"),
  (3, 0, 1, "light", "diana", "deep"),
  (2, 1, 1, "deep", "disco", "accent"),
  (3, 1, 1, "accent", "disco", "light"),
  (2, 2, 2, "light", "disco", "accent"),
  (0, 2, 1, "accent", "diana", "light"),
  (1, 2, 1, "deep", "diana", "light"),
  (0, 3, 1, "deep", "diana", "accent"),
  (1, 3, 1, "light", "disco", "deep"),
)

#let _rules(ctx, tile) = {
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let p = ctx.parts
  let part(k) = p.at(k, default: none)
  let body-of(k) = { let x = part(k); if x == none { none } else { x.body } }
  let (tag, conclusion, author) = ("tag", "conclusion", "author").map(body-of)
  let mp = part("main")
  let main = if mp == none { if ctx.has-loose { ctx.loose } else { none } } else if ctx.has-loose { mp.body + parbreak() + ctx.loose } else { mp.body }
  let props = if mp == none { (:) } else { mp.props }
  let brand = ctx.brand
  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("outfit") }

  let s = calc.min(width / 1pt / _ref.at(0), height / 1pt / _ref.at(1))
  // la lámina de referencia, centrada en la página
  let ox = (width - _ref.at(0) * s * 1pt) / 2
  let oy = (height - _ref.at(1) * s * 1pt) / 2
  let X(u) = ox + u * s * 1pt
  let Y(u) = oy + u * s * 1pt
  let L(u) = u * s * 1pt
  // main.size, en u absolutas, a unidades de la lámina
  let size = if "size" in props { (ctx.len)(props.size) / L(1) } else { 7.4 }

  // ── el bloque de teselas ──
  let bx = _margin
  let by = _ref.at(1) - _margin - _block
  for t in tile {
    let (col, row, span, bg, motif, fg) = t
    let side = _cell * span
    let x = bx + col * _cell
    let y = by + row * _cell
    place(top + left, dx: X(x), dy: Y(y), box(width: L(side), height: L(side), fill: tm.at(bg), {
      let d = L(side * 0.84)
      let c = (L(side) - d) / 2
      if motif == "disco" {
        place(top + left, dx: c, dy: c, circle(radius: d / 2, fill: tm.at(fg)))
      } else if motif == "diana" {
        place(top + left, dx: c, dy: c, circle(radius: d / 2, fill: tm.at(fg)))
        let h = L(side * 0.496) // el hueco del aro
        place(top + left, dx: (L(side) - h) / 2, dy: (L(side) - h) / 2, circle(radius: h / 2, fill: tm.at(bg)))
        let dot = L(side * 0.198) // el punto central
        place(top + left, dx: (L(side) - dot) / 2, dy: (L(side) - dot) / 2, circle(radius: dot / 2, fill: tm.at(fg)))
      }
    }))
  }

  set text(font: family, lang: "es", hyphenate: false)
  capa-texto(L, X, Y, tm.ink, tm.quiet,
    (
      titulo: (x: bx, y: 35.5, ancho: 190),
      parrafo: (x: bx, y: 62.0, ancho: 190.1, alto: 82, alto-autor: 66),
      pila: (derecha: bx + _block, y: 29.1, alto: 112),
      autor: (x: bx, y: 131),
    ),
    etiqueta: tag, frase: main, remate: conclusion, autor: author, cuerpo: size,
    fit-down: ctx.fit-down)
  if brand != none {
    // v1 no le daba la tinta del tema a la marca: heredaba el negro de Typst
    // (la tinta de teselas es #100f0d). Se conserva para la paridad.
    place(bottom + center, dy: -(oy + L(5)), text(fill: black, brand))
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  tile: reference-tile,
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
  extra-roles: ("deep", "light"),
  known: ("tag", "main", "conclusion", "author", "brand"),
  fn: "tiles",
  elements: elements,
  rules: ctx => _rules(ctx, tile),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "tiles", make: make, variants: ())
#let tiles = frame.with(preset: preset)
