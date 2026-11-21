// ─────────────────────────────────────────────────────────────
//  core/v2/primitives.typ — el toolbox mínimo de engine_v2 (solo lo que usa `swiss`)
//
//  Sin imports. Nombres en inglés; se deciden al traducir, no antes: cada
//  primitiva nueva entra cuando un preset la necesita.
// ─────────────────────────────────────────────────────────────

// Formatos con nombre (px). Las claves son las del demo.
#let formats = (
  retrato: (1080, 1350),
  cuadrado: (1080, 1080),
  instagram: (1080, 1080),
  story: (1080, 1920),
  twitter: (1600, 900),
  linkedin: (1200, 1200),
)

// Tamaño del lienzo en pt, desde px: (ancho, alto).
#let dimensions(format) = (format.at(0) * 1pt, format.at(1) * 1pt)

// Retícula de columnas sobre un ancho: ancho útil, ancho de columna,
// x de cada columna y ancho acumulado de 0..n columnas (span.at(n)).
#let columns(width, count: 6, margin: 64pt, gutter: 24pt) = {
  let usable = width - 2 * margin
  let col = (usable - (count - 1) * gutter) / count
  (
    count: count,
    margin: margin,
    gutter: gutter,
    usable: usable,
    col: col,
    x: range(count).map(i => margin + i * (col + gutter)),
    span: (0pt,) + range(1, count + 1).map(n => n * col + (n - 1) * gutter),
  )
}

// Tamaño con el que `make(tamaño)` mide exactamente `width`. Usar dentro de `context`.
#let fit-to-width(make, width) = 100pt * (width / measure(make(100pt)).width)

// Mayor tamaño <= `from` con el que `make(tamaño)` cabe en `height`;
// baja de `step` en `step` y se detiene en `min`. Usar dentro de `context`.
#let fit-to-height(make, from, height, min: 24pt, step: 2pt) = {
  let s = from
  while s > min and measure(make(s)).height > height { s -= step }
  s
}

// ── tema ──────────────────────────────────────────────────────
// Roles: background, ink, muted, accent, rule.
#let themes = (
  suizo: (
    background: rgb("#f3f0e9"),
    ink: rgb("#141414"),
    muted: rgb("#5c5850"),
    accent: rgb("#c8102e"),
    rule: rgb("#d9d3c7"),
  ),
  lamina: (
    background: rgb("#f7f7f3"),
    ink: rgb("#14213d"),
    muted: rgb("#454f63"),
    accent: rgb("#0f766e"),
  ),
)
#let _mix(a, b, p) = color.mix((a, 100% - p), (b, p), space: oklab)

// `theme` es `auto` (el tema por defecto del tipo), un nombre del registro o un
// diccionario de roles que se superpone al tema por defecto. Si el diccionario cambia `background` o `ink` y no da `rule`,
// el filete se deriva (12 % de tinta sobre el fondo).
#let resolve-theme(theme, default) = {
  let find(name) = {
    if not name in themes { panic("theme desconocido: " + repr(name) + " (hay: " + themes.keys().join(", ") + ")") }
    themes.at(name)
  }
  let base = find(default)
  let given = if theme == auto { (:) } else if type(theme) == str { find(theme) } else if type(theme) == dictionary { theme } else {
    panic("theme: se esperaba un nombre o un diccionario, no " + repr(type(theme)))
  }
  let resolved = base + given
  let changed = ("background", "ink").any(r => r in given and given.at(r) != base.at(r, default: none))
  if not "rule" in given and changed { resolved.insert("rule", _mix(resolved.background, resolved.ink, 12%)) }
  resolved
}

// `brand` es un contenido ya hecho o una función (color, lienzo) -> contenido.
#let resolve-brand(brand, color, format) = if type(brand) == function { brand(color, format) } else { brand }
