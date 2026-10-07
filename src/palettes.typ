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
#import "@local/superpelettes:0.1.0": luminance, auto-roles

// Los tokens (colores individuales nombrados) viven en tokens.typ —
// compartidos con theme.typ, para que la marca base y las paletas
// decorativas beban del mismo registro. Se re-exportan aquí por
// compatibilidad con quien ya usaba `palettes.tokens` / `palettes.token`.

// ===== BIBLIOTECA — cada paleta es una lista de claves de `tokens` =====
// Nombres actualizados tras el rename semántico de tokens.typ --
// "granates" y "marino" se reconstruyeron a mano porque varias de sus
// claves viejas colapsaron en el mismo color real (las 10 de
// "granates" eran, medidas en OKLCH, solo 4 colores distintos).
#let library = (
  "noche-azul": ("stone-850", "aciano", "denim", "heno", "pergamino"),
  "neon": ("violeta", "granate", "rosa-mexicano", "mandarina", "dorado"),
  "retro": ("stone-700", "tomate", "mostaza", "petróleo", "turquesa"),
  "oceano": ("navy", "lago", "dorado", "green-25", "malva"),
  "granates": ("wine", "teja", "escarlata", "coral", "carmesí", "arcilla", "caoba", "amapola", "granate", "rosa-antiguo"),
  "terracota": ("marfil", "salmón", "vino-frío", "jade", "caramelo"),
  "web-suave": ("cielo", "stone-25", "lime-75", "glicina", "rosa-polvo", "aguamarina"),
  "vintage": ("tomate", "miel", "slate-100", "amber-150", "slate-800"),
  "arcoiris-pastel": ("vainilla", "durazno", "rosa-antiguo", "malvavisco", "orquídea", "nomeolvides", "celeste", "cristal", "turquesa", "menta"),
  "marino": ("vino-frío", "grafito", "cyan-50", "coral", "acero"),
  "mediterraneo": ("acero", "amapola", "calabaza", "azafrán", "champán"),
  "otono": ("carmesí", "lima", "avellana", "tostado", "arcilla"),
  "bosque": ("esmeralda", "salvia", "green-50", "caoba", "rosa-antiguo"),
  "grises": ("stone-975", "slate-600", "slate-400", "slate-125", "slate-50"),
  "algodon": ("arena", "crema", "rosa-ceniza", "rosa-viejo", "niebla", "teal-100", "amber-50", "sky-100", "bruma", "acero"),
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
// luminance/auto-roles vivían reimplementados acá con el mismo bug que
// theme.typ tenía por su lado: `.components()` sin forzar `.rgb()`
// antes lee mal cualquier color en espacio `luma` (white/black). Ahora
// se importan de @local/superpelettes:0.1.0 -- una sola implementación
// correcta en vez de dos copias con el mismo bug cada una.
//
// `saturation` se queda acá (superpelettes no la expone suelta, solo la
// usa internamente dentro de su propio `auto-roles`) pero con el mismo
// fix: forzar `.rgb()` antes de leer canales.
#let saturation(c) = {
  let x = c.rgb().components()
  let r = x.at(0) / 100
  let g = x.at(1, default: x.at(0)) / 100
  let b = x.at(2, default: x.at(0)) / 100
  calc.max(r, g, b) - calc.min(r, g, b)
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
