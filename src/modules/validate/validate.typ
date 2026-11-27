// ─────────────────────────────────────────────────────────────
//  lib/validate.typ — comprobaciones con mensajes útiles
//
//  Origen: sistema-opus/validate.typ (expect, expect-one-of, expect-positive),
//  más `suggest` y `check-keys` (nuevos): toda clave desconocida se rechaza con
//  la lista de claves válidas y, si hay una parecida, «¿Quisiste decir …?».
//
//  Typst es de tipado dinámico: se comparan TIPOS reales (`type(x) == str`),
//  nunca sus nombres (`str(type("a"))` es "string", no "str").
//  Módulo hoja: sin imports.
// ─────────────────────────────────────────────────────────────

// nombres como se escriben en Typst (`str(str)` daría "string")
#let _names = ((str, "str"), (int, "int"), (float, "float"), (bool, "bool"), (length, "length"),
  (color, "color"), (content, "content"), (array, "array"), (dictionary, "dictionary"),
  (function, "function"), (ratio, "ratio"), (gradient, "gradient"), (alignment, "alignment"))
#let type-name(t) = {
  if t == none { return "none" }
  if t == auto { return "auto" }
  let f = _names.find(p => p.first() == t)
  if f == none { str(t) } else { f.last() }
}
#let _type-names(types) = types.map(type-name).join(" o ")

/// Falla si `value` no es de uno de los `types` (admite `none` y `auto` como valores).
#let expect(value, types, name, fn: "swiss") = {
  let types = if type(types) == array { types } else { (types,) }
  assert(
    types.any(t => if t == none or t == auto { value == t } else { type(value) == t }),
    message: fn + ": `" + name + "` debe ser " + _type-names(types)
      + ", pero llegó " + type-name(type(value)) + " (" + repr(value) + ")",
  )
}

/// Distancia de edición (Levenshtein) entre dos textos.
#let _lev(a, b) = {
  let a = a.clusters()
  let b = b.clusters()
  let prev = range(b.len() + 1)
  for i in range(a.len()) {
    let cur = (i + 1,)
    for j in range(b.len()) {
      let cost = if a.at(i) == b.at(j) { 0 } else { 1 }
      cur.push(calc.min(prev.at(j + 1) + 1, cur.at(j) + 1, prev.at(j) + cost))
    }
    prev = cur
  }
  prev.last()
}

/// « ¿Quisiste decir "x"?» si alguna opción está cerca; si no, "".
#let suggest(x, options) = {
  if type(x) != str { return "" }
  let best = none
  let d = 99
  for o in options {
    if type(o) == str {
      let k = _lev(lower(x), lower(o))
      if k < d { d = k; best = o }
    }
  }
  if best != none and d > 0 and d < x.clusters().len() and d <= calc.max(2, calc.floor(x.len() / 3)) { " ¿Quisiste decir " + repr(best) + "?" } else { "" }
}

/// Falla si `value` no está en `options`.
#let expect-one-of(value, options, name, fn: "swiss") = {
  assert(
    value in options,
    message: fn + ": `" + name + "` debe ser uno de " + options.map(repr).join(", ")
      + ", pero llegó " + repr(value) + suggest(value, options),
  )
}

/// Falla si un número no es positivo (o >= 0 si `zero: true`).
#let expect-positive(value, name, fn: "swiss", zero: false) = {
  expect(value, (int, float), name, fn: fn)
  if zero {
    assert(value >= 0, message: fn + ": `" + name + "` no puede ser negativo (" + repr(value) + ")")
  } else {
    assert(value > 0, message: fn + ": `" + name + "` debe ser mayor que cero (" + repr(value) + ")")
  }
}

/// Falla si el diccionario `d` tiene claves fuera de `allowed`.
#let check-keys(d, allowed, name, fn: "swiss") = {
  for k in d.keys() {
    assert(k in allowed, message: fn + ": `" + name + "` no tiene la clave " + repr(k)
      + " (claves: " + allowed.join(", ") + ")." + suggest(k, allowed))
  }
}
