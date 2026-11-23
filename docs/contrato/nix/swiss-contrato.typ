// GENERADO por integracion/gen.nix desde contract.nix. No editar a mano.
// Preset `swiss`: Remate enorme abajo a todo lo ancho, sobre retícula de 6 columnas visible.

#let _chk-accent(v) = {
  assert(v == auto or std.type(v) == color,
    message: "swiss: `accent` debe ser auto | color, no " + repr(v))
}

#let _chk-artboard(v) = {
  assert(std.type(v) == str or std.type(v) == dictionary,
    message: "swiss: `artboard` debe ser str | dictionary, no " + repr(v))
  if std.type(v) == str { assert(v in ("feed-portrait", "feed-square", "story", "slide", "wallpaper-uhd"),
    message: "swiss: `artboard` debe ser uno de feed-portrait, feed-square, story, slide, wallpaper-uhd, no " + repr(v)) }
  if std.type(v) == dictionary {
    let allowed = (medium: (str,), size: (array,))
    for (k, x) in v {
      assert(k in allowed, message: "swiss: `artboard` no tiene la clave " + repr(k) + " (claves: medium, size)")
      assert(std.type(x) in allowed.at(k), message: "swiss: `artboard." + k + "` debe ser " + allowed.at(k).map(repr).join(" | ") + ", no " + repr(x))
    }
    if "medium" in v { assert(v.medium in ("print", "screen", "wallpaper"), message: "swiss: `artboard.medium` debe ser uno de print, screen, wallpaper, no " + repr(v.medium)) }
    if "size" in v { assert(v.size.len() == 2 and v.size.all(s => (std.type(s) in (int, float) and s > 0) or (std.type(s) == length and s > 0pt)),
      message: "swiss: `artboard.size` es (ancho, alto) positivos, no " + repr(v.size)) }
  }
}

#let _chk-author(v) = {
  assert(v == none or std.type(v) == content or std.type(v) == str,
    message: "swiss: `author` debe ser none | content | str, no " + repr(v))
}

#let _chk-brand(v) = {
  assert(v == none or std.type(v) == content or std.type(v) == str or std.type(v) == function,
    message: "swiss: `brand` debe ser none | content | str | function, no " + repr(v))
}

#let _chk-dates(v) = {
  assert(v == none or std.type(v) == content or std.type(v) == str,
    message: "swiss: `dates` debe ser none | content | str, no " + repr(v))
}

#let _chk-repeat(v) = {
  assert(v == none or std.type(v) == int or std.type(v) == array,
    message: "swiss: `repeat` debe ser none | int | array, no " + repr(v))
  if std.type(v) == int { assert(v >= 1, message: "swiss: `repeat` debe ser >= 1, no " + repr(v)) }
}

#let _chk-theme(v) = {
  assert(v == auto or std.type(v) == str or std.type(v) == dictionary,
    message: "swiss: `theme` debe ser auto | str | dictionary, no " + repr(v))
  if std.type(v) == str { assert(v in ("suizo", "lamina"),
    message: "swiss: `theme` debe ser uno de suizo, lamina, no " + repr(v)) }
  if std.type(v) == dictionary {
    let allowed = (accent: (color,), background: (color,), ink: (color,), muted: (color,), rule: (color,))
    for (k, x) in v {
      assert(k in allowed, message: "swiss: `theme` no tiene la clave " + repr(k) + " (claves: accent, background, ink, muted, rule)")
      assert(std.type(x) in allowed.at(k), message: "swiss: `theme." + k + "` debe ser " + allowed.at(k).map(repr).join(" | ") + ", no " + repr(x))
    }

  }
}

#let _chk-variant(v) = {
  assert(std.type(v) == str,
    message: "swiss: `variant` debe ser str, no " + repr(v))
  if std.type(v) == str { assert(v in ("lines", "cells", "shifted", "baseline"),
    message: "swiss: `variant` debe ser uno de lines, cells, shifted, baseline, no " + repr(v)) }
}

/// El contrato como datos: para documentación, un servidor MCP o el índice de recursos.
#let swiss-contract = (
  params: (accent: (types: ("auto", "color"), default: "auto", doc: "Color del remate y la flecha."), artboard: (types: ("str", "dictionary"), default: "\"feed-portrait\"", doc: "Tamaño y destino del lienzo."), author: (types: ("none", "content", "str"), default: "none", doc: "Cabecera, izquierda."), brand: (types: ("none", "content", "str", "function"), default: "none", doc: "Marca del pie: contenido o función (color, lienzo) => contenido."), dates: (types: ("none", "content", "str"), default: "none", doc: "Cabecera, columna 4."), repeat: (types: ("none", "int", "array"), default: "none", doc: "Una lámina por elemento; el cuerpo pasa a ser una función item => contenido."), theme: (types: ("auto", "str", "dictionary"), default: "auto", doc: "Colores: auto = el del preset; nombre del registro; o roles sueltos."), variant: (types: ("str",), default: "\"lines\"", doc: "Modo de la retícula visible (las cuatro variantes vistas en los carteles).")),
  parts: (eyebrow: (types: ("content",), required: false, draws: "kicker en flow.top"), headline: (types: ("content",), required: true, draws: "fitted(role: headline, fit: width) en flow.bottom"), question: (types: ("content",), required: false, draws: "lede en flow.top"), statement: (types: ("content",), required: true, draws: "fitted(role: prose, fit: height) en flow.fill")),
  layers: ("raster", "header", "flow", "footer"),
)

/// Valores por defecto (literales Typst del contrato).
#let swiss-defaults = (accent: auto, artboard: "feed-portrait", author: none, brand: none, dates: none, repeat: none, theme: auto, variant: "lines")

/// Valida los argumentos con nombre, rechaza los desconocidos y completa los que faltan.
#let swiss-args(..args) = {
  assert(args.pos().len() == 0, message: "swiss: solo admite argumentos con nombre")
  let given = args.named()
  for k in given.keys() {
    assert(k in swiss-defaults, message: "swiss: argumento desconocido " + repr(k) + " (hay: accent, artboard, author, brand, dates, repeat, theme, variant)")
  }
  let out = swiss-defaults + given
  _chk-accent(out.accent)
  _chk-artboard(out.artboard)
  _chk-author(out.author)
  _chk-brand(out.brand)
  _chk-dates(out.dates)
  _chk-repeat(out.repeat)
  _chk-theme(out.theme)
  _chk-variant(out.variant)
  out
}

/// Comprueba los hijos leídos del cuerpo (diccionario kind => contenido, más `content`).
#let swiss-check-parts(found) = {

  assert("headline" in found,
    message: "swiss: falta el hijo `headline`")

  assert("statement" in found or found.at("content", default: []) != [],
    message: "swiss: falta el hijo `statement` (o contenido suelto)")
  found
}
