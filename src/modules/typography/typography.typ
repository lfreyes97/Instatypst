// ─────────────────────────────────────────────────────────────
//  lib/typography.typ — escala, pasos, roles de texto y `typeset`
//
//  Origen: sistema-opus/typography.typ (escala 5:4 desde 16, roles, pitch),
//  reescrito sin `state`: `typeset(estilo, cuerpo, ctx)` recibe el contexto
//  (unidad, colores, fuentes) en vez de leer el cartel en curso, para que un
//  preset lo llame dentro de su propia página.
//
//  Tres capas, como en COMENTARIOS.md § a.3:
//    roles   index, kicker, headline, display (= headline dominante), lede,
//            prose, note, subhead, numeral, colophon
//    pasos   step: n  →  16 × 1,25ⁿ unidades de referencia (admite fracciones)
//    alias   step: "service" …  (nombres de grupos del corpus, no ordinales)
//  Un estilo es un diccionario con: font, step | size, weight, tracking, fill
//  (y, internos del preset, leading y case). `size` va en unidades de referencia:
//  lo usa el preset para cifras exactas (22, 44, 66); un `step` de una capa
//  posterior lo anula, y viceversa. `step: "fit"` = el preset ajusta el cuerpo.
// ─────────────────────────────────────────────────────────────

#import "/src/modules/validate/validate.typ": expect, expect-one-of, check-keys, suggest
#import "/src/modules/color/color.typ": resolve-fill
#import "fonts.typ": resolve-font

#let scale-base = 16
#let scale-ratio = 1.25

/// Alias de pasos: los siete grupos que piden los datos (COMENTARIOS.md § a.3).
#let step-aliases = (
  fine: 0,        // anotación: 13–16
  service: 1,     // dato de servicio: 20
  reading: 3,     // lectura: 25–31
  emphasis: 5,    // énfasis: 39–61
  banner: 8,      // titular con figura: 76–120
  poster: 10,     // titular que es la figura: 149–186
  monumental: 12, // 233+
)

/// Apriete con nombre (para writers: nunca valores libres).
#let tracking-names = (
  tight: -0.03em,
  snug: -0.015em,
  normal: 0em,
  open: 0.03em,
  wide: 0.12em,
)

#let weights = ("thin", "extralight", "light", "regular", "medium", "semibold", "bold", "extrabold", "black")

#let text-roles = ("index", "kicker", "headline", "display", "lede", "prose", "note", "subhead", "numeral", "colophon")

/// Valores por defecto de cada rol (los del corpus de 20 carteles).
/// Un preset los sobrescribe con los suyos.
#let role-defaults = (
  index: (font: "annotation", step: -1, weight: "regular", tracking: 0.03em, fill: "quiet"),
  kicker: (font: "annotation", step: 0, weight: "regular", tracking: 0.03em, fill: "ink", case: "upper"),
  colophon: (font: "annotation", step: 0, weight: "regular", tracking: 0.03em, fill: "quiet"),
  note: (font: "body", step: 1, weight: "regular", tracking: 0em, fill: "ink"),
  prose: (font: "body", step: 2, weight: "regular", tracking: 0em, fill: "ink"),
  lede: (font: "body", step: 3, weight: "regular", tracking: 0em, fill: "ink"),
  subhead: (font: "display", step: 5, weight: "bold", tracking: -0.02em, fill: "ink"),
  headline: (font: "display", step: 8, weight: "bold", tracking: -0.03em, fill: "ink"),
  display: (font: "display", step: 10, weight: "bold", tracking: -0.04em, fill: "ink"),
  numeral: (font: "display", step: 11, weight: "bold", tracking: -0.04em, fill: "ink"),
)

/// Claves de un estilo. Las cinco primeras son las que puede emitir un writer.
#let style-keys = ("step", "weight", "tracking", "font", "fill", "size", "leading", "case")

/// Tamaño (unidades de referencia) del paso `n` o de un alias.
#let step-size(n, fn: "swiss") = {
  let n = if type(n) == str {
    assert(n in step-aliases, message: fn + ": paso desconocido " + repr(n) + " (alias: "
      + step-aliases.keys().join(", ") + "; o un número)." + suggest(n, step-aliases.keys()))
    step-aliases.at(n)
  } else { n }
  expect(n, (int, float), "step", fn: fn)
  scale-base * calc.pow(scale-ratio, n)
}

/// Comprueba un diccionario de estilo del camino Typst: nombres estrictos,
/// valores permisivos (cualquier paso, color, longitud o familia).
#let check-style(s, where, fn: "swiss") = {
  expect(s, dictionary, where, fn: fn)
  check-keys(s, style-keys, where, fn: fn)
  if "step" in s and s.step != "fit" and type(s.step) == str { let _ = step-size(s.step, fn: fn) }
  if "step" in s and s.step != "fit" and type(s.step) != str { expect(s.step, (int, float), where + ".step", fn: fn) }
  if "size" in s { expect(s.size, (int, float), where + ".size", fn: fn) }
  if "weight" in s {
    assert(type(s.weight) == int or s.weight in weights, message: fn + ": `" + where
      + ".weight` debe ser un entero o uno de " + weights.join(", ") + ", no " + repr(s.weight)
      + suggest(s.weight, weights))
  }
  if "tracking" in s {
    assert(type(s.tracking) == length or s.tracking in tracking-names, message: fn + ": `" + where
      + ".tracking` debe ser una longitud (em) o uno de " + tracking-names.keys().join(", ")
      + ", no " + repr(s.tracking) + suggest(s.tracking, tracking-names.keys()))
  }
  if "font" in s { expect(s.font, str, where + ".font", fn: fn) }
  if "case" in s { expect-one-of(s.case, (none, "upper", "lower"), where + ".case", fn: fn) }
  s
}

/// Mezcla dos estilos: `b` gana. Un `step` en `b` anula el `size` de `a` y viceversa.
#let merge-style(a, b) = {
  let out = a
  if "step" in b and "size" in out { let _ = out.remove("size") }
  if "size" in b and "step" in out { let _ = out.remove("step") }
  out + b
}

/// Cuerpo en unidades de referencia de un estilo (none si es "fit").
#let style-size(s, fn: "swiss") = {
  if "size" in s { s.size } else if s.at("step", default: 2) == "fit" { none } else { step-size(s.at("step", default: 2), fn: fn) }
}

/// Compone `body` con un estilo resuelto. `ctx` = (unit, colors, fonts).
/// `size` (unidades de referencia) fuerza el cuerpo (lo usan los ajustes).
#let typeset(s, body, ctx, size: auto, fn: "swiss") = {
  let sz = if size != auto { size } else { style-size(s, fn: fn) }
  assert(sz != none, message: fn + ": el estilo tiene `step: \"fit\"`; este texto no se ajusta solo, da un paso")
  let tr = s.at("tracking", default: 0em)
  let tr = if type(tr) == str { tracking-names.at(tr) } else { tr }
  let b = if s.at("case", default: none) == "upper" { upper(body) } else if s.at("case", default: none) == "lower" { lower(body) } else { body }
  let args = (
    font: resolve-font(s.at("font", default: "body"), ctx.fonts, fn: fn),
    size: sz * ctx.unit,
    weight: s.at("weight", default: "regular"),
    tracking: tr,
    fill: resolve-fill(s.at("fill", default: "ink"), ctx.colors, fn: fn),
  )
  if "leading" in s {
    set par(leading: s.leading)
    std.text(..args, b)
  } else { std.text(..args, b) }
}
