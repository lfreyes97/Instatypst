// ─────────────────────────────────────────────────────────────
//  PALETTES — registro de tokens de color + biblioteca de paletas
// ─────────────────────────────────────────────────────────────
//
//  #import "palettes.typ": palettes
//
//  #let neon = palettes.as-theme("neon")     // → tema para theme.typ
//  #palette.primary                           // usar con social.typ
//  #palettes.catalog()                        // carta visual completa
//
//  Ampliar colores:
//    #palettes.token("sky-400")                          // reusar un color individual
//    #palettes.mix("sky-400", "red-500", rgb("#123456"))  // paleta ad-hoc (tokens y/o colores sueltos)
//  ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "tokens.typ": tokens, token

// Los tokens (colores individuales nombrados) viven en tokens.typ —
// compartidos con theme.typ, para que la marca base y las paletas
// decorativas beban del mismo registro. Se re-exportan aquí por
// compatibilidad con quien ya usaba `palettes.tokens` / `palettes.token`.

// ===== BIBLIOTECA — cada paleta es una lista de claves de `tokens` =====
#let library = (
  "noche-azul": ("stone-850", "blue-650", "sky-400", "yellow-300", "lime-50"),
  "neon": ("violet-700", "pink-700", "pink-500", "orange-500", "orange-525"),
  "retro": ("stone-700", "red-350", "amber-300", "cyan-600", "teal-400"),
  "oceano": ("blue-900", "cyan-500", "amber-500", "green-25", "red-200"),
  "granates": ("red-750", "red-775", "red-700", "red-650", "red-600", "red-625", "red-550", "red-575", "red-500", "red-525"),
  "terracota": ("amber-100", "red-375", "blue-700", "emerald-400", "orange-250"),
  "web-suave": ("sky-600", "stone-25", "lime-75", "violet-100", "pink-100", "cyan-150"),
  "vintage": ("red-325", "orange-350", "slate-100", "amber-150", "slate-800"),
  "arcoiris-pastel": ("yellow-100", "orange-100", "red-100", "fuchsia-150", "violet-150", "sky-200", "cyan-250", "cyan-275", "teal-200", "green-150"),
  "marino": ("blue-800", "sky-425", "cyan-50", "red-450", "red-475"),
  "mediterraneo": ("sky-850", "red-425", "orange-475", "orange-375", "amber-200"),
  "otono": ("red-400", "lime-450", "orange-200", "orange-400", "red-675"),
  "bosque": ("green-400", "green-250", "green-50", "red-800", "red-850"),
  "grises": ("stone-975", "slate-600", "slate-400", "slate-125", "slate-50"),
  "algodon": ("orange-125", "orange-50", "red-50", "pink-125", "teal-225", "teal-100", "amber-50", "sky-100", "sky-225", "sky-250"),
)

#let names() = library.keys()

// Resuelve un elemento de paleta: si es texto, lo busca en `tokens`; si ya es color, lo deja tal cual.
#let _resolve(c) = if type(c) == str { token(c) } else { c }

#let get(name) = {
  if not (name in library) {
    panic("paleta desconocida: " + name + " — disponibles: " + names().join(", "))
  }
  library.at(name).map(_resolve)
}

// Paleta ad-hoc: combina tokens existentes (por clave) y/o colores sueltos, en el orden dado.
// #palettes.mix("sky-400", "red-500", rgb("#123456"))
#let mix(..items) = items.pos().map(_resolve)

// ================= ANÁLISIS DE COLOR =================

#let _chan(v) = v / 100

#let luminance(c) = {
  let x = c.components()
  let f(v) = {
    let u = v / 100
    if u <= 4.045% { u / 12.92 } else { calc.pow((u + 5.5%) / 105.5%, 2.4) }
  }
  let r = x.at(0)
  let g = x.at(1, default: r)
  let b = x.at(2, default: r)
  21.26% * f(r) + 71.52% * f(g) + 7.22% * f(b)
}

// Saturación aproximada (rango normalizado de canales RGB)
#let saturation(c) = {
  let x = c.components()
  let r = x.at(0) / 100
  let g = x.at(1, default: x.at(0)) / 100
  let b = x.at(2, default: x.at(0)) / 100
  calc.max(r, g, b) - calc.min(r, g, b)
}

// ================= ASIGNACIÓN AUTOMÁTICA DE ROLES =================
// dark   = más oscuro · light = más claro
// primary/secondary/accent = intermedios más saturados (en ese orden)

#let auto-roles(cols) = {
  let sorted-l = cols.sorted(key: c => luminance(c))
  let dark = sorted-l.first()
  let light = sorted-l.last()

  let mids = cols.filter(c => c != dark and c != light)
  if mids.len() == 0 { mids = (dark,) }
  let ranked = mids.sorted(key: c => -saturation(c))

  let pick(i) = if i < ranked.len() { ranked.at(i) } else { ranked.at(calc.rem(i, ranked.len())) }

  (
    dark: dark,
    light: light,
    primary: pick(0),
    secondary: pick(1),
    accent: pick(2),
    white: white,
  )
}

// Convierte una paleta de la biblioteca en tema (compatible con theme.typ / social.typ)
#let as-theme(name) = (theme.define)(name, colors: auto-roles(get(name)))

// Igual, pero respetando un orden manual: roles = (primary, secondary, accent, dark, light)
#let as-theme-manual(name, roles) = (theme.define)(name, colors: (
  primary: roles.at(0),
  secondary: roles.at(1),
  accent: roles.at(2),
  dark: roles.at(3),
  light: roles.at(4),
  white: white,
))

// ================= COMPONENTES VISUALES =================

// Fila de muestras con hex debajo
#let swatch(name-or-colors, size: 26pt, show-hex: true) = {
  let cols = if type(name-or-colors) == array { name-or-colors } else { get(name-or-colors) }
  let n = cols.len()
  grid(
    columns: (size,) * n,
    gutter: calc.min(8pt, 20pt / n),
    ..cols.map(c => stack(spacing: 3pt,
      box(circle(radius: size / 2 - 1pt, fill: c, stroke: 0.5pt + luma(60%))),
      if show-hex { align(center, text(size: calc.min(6pt, size * 0.24), fill: luma(35%), c.to-hex())) },
    ))
  )
}

// Tarjeta de paleta (para el catálogo)
#let card(name, width: 250pt) = {
  let cols = get(name)
  let n = cols.len()
  let inner = width - 28pt
  let s = calc.min(34pt, (inner - calc.min(8pt, 20pt / n) * (n - 1)) / n)
  block(
    width: width,
    fill: white,
    stroke: 0.75pt + luma(85%),
    radius: 10pt,
    inset: 14pt,
  )[
    #text(size: 11pt, weight: "bold")[#name]
    #v(7pt)
    #swatch(cols, size: s)
  ]
}

// Catálogo completo de la biblioteca
#let catalog(columns: 3, gutter: 16pt) = grid(
  columns: columns,
  column-gutter: gutter,
  row-gutter: gutter,
  ..names().map(n => card(n)),
)

// Namespace
#let palettes = (
  tokens: tokens,
  token: token,
  library: library,
  names: names,
  get: get,
  mix: mix,
  "auto-roles": auto-roles,
  "as-theme": as-theme,
  "as-theme-manual": as-theme-manual,
  swatch: swatch,
  card: card,
  catalog: catalog,
  luminance: luminance,
  saturation: saturation,
)
