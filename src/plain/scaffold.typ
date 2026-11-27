// ─────────────────────────────────────────────────────────────
//  plain/scaffold.typ — plain + la configuración resuelta: la base de todo preset
//
//  Un preset (o una variante) es plain + un conjunto de reglas. El scaffold hace
//  lo que todos repetían: medir el artboard, resolver el tema (modules/color) y
//  las fuentes (modules/typography), leer los elementos que el preset reconoce y
//  la marca. Las reglas reciben ese contexto y devuelven el contenido, que el
//  scaffold pone sobre el lienzo de plain.
//
//    scaffold(body, artboard:, theme:, accent:, brand:, fonts:,
//             default-theme:, default-fonts:, extra-roles:, known:,
//             elements:, page-margin:, fn:, rules: ctx => contenido)
//
//  Elementos como argumentos: `#frame(preset: "swiss", author: [X])[…]` es azúcar
//  de `#author[X]` en el cuerpo. El preset recibe sus argumentos sueltos con
//  `..elements` y los pasa en `elements:`; el scaffold rechaza un nombre que el
//  preset no reconoce (así un `autor:` mal escrito da error) y, si un elemento
//  está en los dos lados, gana el del cuerpo (como `brand`).
//
//  ctx:
//    body            el cuerpo tal cual (para quien no lo desarma)
//    parts, loose, has-loose   lo que reconoce (`known`) y el resto (core/parts)
//    width, height, u          el artboard medido; u = lado corto / 1080
//    len(v)          número = u, longitud = absoluta (Spec §3)
//    tm              el tema: los cinco roles (paper, ink, quiet, accent, guide)
//                    y los roles extra que declare el preset (`extra-roles`)
//    fonts           rol → familia (display, body, mono, annotation, main…);
//                    vacío si el preset no tiene fuentes y nadie las pide
//    font(f)         un rol o una familia suelta → familia (`tag(font: …)`)
//    brand           la marca: `#brand[…]` gana a `brand:`; ya resuelta
//    fit-down(hacer, desde, alto, min:, paso:)   el tamaño mayor, de `paso` en
//                    `paso` desde `desde`, con el que hacer(tamaño) cabe en `alto`
//                    (sin bajar de `min`); va dentro de `context`
//    fit-width(hacer, ancho)   el tamaño con el que hacer(tamaño) mide `ancho`
//
//  El scaffold pone sobre el lienzo `set text(fill: tm.ink)` y la familia `body`
//  si la hay; el resto de los estilos es de las reglas.
// ─────────────────────────────────────────────────────────────

#import "/src/core/parts.typ": read-parts
#import "/src/core/artboard.typ": dimensions, unit, len as _len
#import "/src/modules/color/color.typ": resolve-theme
#import "/src/modules/typography/fonts.typ": resolve-fonts, resolve-font, pairings
#import "canvas.typ": canvas, resolve-brand

// El autoajuste común (antes estaba en plain "post", en swiss y en _legado/_base).
#let fit-down(hacer, desde, alto, min: 24pt, paso: 2pt) = {
  let s = desde
  while s > min and measure(hacer(s)).height > alto { s -= paso }
  s
}

#let fit-width(hacer, ancho) = 100pt * (ancho / measure(hacer(100pt)).width)

// `fonts` del usuario contra las del preset. `default-fonts`: una pareja de
// typography o none (el preset no fija fuente: la de Typst).
//   auto            la pareja del preset (o nada)
//   "suizo"         una pareja
//   "Inter"         una familia suelta (o una clave del registro): el rol body
//   (body: …, …)    roles sueltos sobre la pareja del preset
#let _fonts(fonts, default-fonts, fn) = {
  if fonts == auto {
    if default-fonts == none { (:) } else { resolve-fonts(auto, default-fonts, fn: fn) }
  } else if type(fonts) == str and fonts in pairings {
    resolve-fonts(fonts, fonts, fn: fn)
  } else if type(fonts) == str {
    let base = if default-fonts == none { (:) } else { resolve-fonts(auto, default-fonts, fn: fn) }
    let f = resolve-font(fonts, base, fn: fn)
    base + (body: f, main: f)
  } else if type(fonts) == dictionary {
    if default-fonts == none {
      let out = fonts.pairs().map(((r, v)) => (r, resolve-font(v, (:), fn: fn))).to-dict()
      if "body" in out { out.insert("main", out.body) }
      out
    } else { resolve-fonts(fonts, default-fonts, fn: fn) }
  } else {
    panic(fn + ": `fonts` es auto, una pareja, una familia o un diccionario de roles, no " + repr(type(fonts)))
  }
}

#let scaffold(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  default-theme: (paper: white, ink: black, accent: none),
  default-fonts: none,
  extra-roles: (),
  known: (),
  elements: (:),
  page-margin: 0pt,
  fn: "preset",
  rules: ctx => ctx.body,
) = {
  let (width, height) = dimensions(artboard)
  let u = unit(artboard)
  let tm = resolve-theme(theme, default-theme, accent: accent, extra: extra-roles, fn: fn)
  let fs = _fonts(fonts, default-fonts, fn)
  let r = read-parts(body, known: known)
  let parts = r.parts
  // `elements` es el `..elements` del preset (o un diccionario)
  if type(elements) == arguments {
    assert(elements.pos().len() == 0, message: fn + ": sobran argumentos posicionales "
      + repr(elements.pos()) + " (el contenido va en el cuerpo)")
    elements = elements.named()
  }
  for (k, v) in elements {
    assert(k in known, message: fn + ": `" + k + "` no es un elemento ni una opción de este preset"
      + (if known.len() > 0 { " (elementos: " + known.join(", ") + ")" } else { " (no reconoce elementos)" }))
    if k not in parts { parts.insert(k, (body: v, props: (:))) }
  }
  let marca = if "brand" in parts { parts.brand.body } else { brand }
  let ctx = (
    body: body,
    parts: parts,
    loose: r.loose,
    has-loose: r.has-loose,
    width: width,
    height: height,
    u: u,
    len: v => _len(v, u),
    tm: tm,
    fonts: fs,
    font: f => resolve-font(f, fs, fn: fn),
    brand: resolve-brand(marca, tm, artboard),
    fit-down: fit-down,
    fit-width: fit-width,
  )
  canvas(artboard, tm, margin: page-margin, {
    set text(fill: tm.ink)
    set text(font: fs.body) if "body" in fs
    rules(ctx)
  })
}
