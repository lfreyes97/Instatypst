// ─────────────────────────────────────────────────────────────
//  THEME API — control y administración de colores y fuentes
//  (API funcional pura: los temas son valores inmutables)
// ─────────────────────────────────────────────────────────────
//
//  #import "theme.typ": theme
//
//  #let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
//  #let marca2 = theme.with-color(marca, "accent", orange)
//  #theme.color("primary", marca)
//  #theme.font("display", marca)
//
//  Para usar un tema con las plantillas de social.typ, sombrea los tokens:
//    #let palette = marca.colors
//    #let fonts = marca.fonts
//
//  Los colores de `base` viven en tokens.typ (registro compartido con
//  palettes.typ) — ver ese archivo para reutilizar o ampliar colores.
//  ─────────────────────────────────────────────────────────────

#import "tokens.typ": token
#import "contrast.typ": luminance, contrast, is-aa, is-aaa, readable-on, auto-pair, auto-pair-tinted

// ===== Claves requeridas =====
#let required-colors = ("primary", "secondary", "accent", "dark", "light", "white")
#let required-fonts = ("display", "body")

// ===== Tema base (tokens del sistema) =====
#let base = (
  name: "default",
  colors: (
    primary: token("índigo"),
    secondary: token("frambuesa"),
    accent: token("ámbar"),
    dark: token("grafito"),
    light: token("slate-25"),
    white: white,
  ),
  fonts: (
    display: ("Poppins", "Urbanist", "Outfit"),
    body: ("Inter", "DM Sans", "Public Sans", "Liberation Sans"),
  ),
)

// ================= VALIDACIÓN =================

#let validate(t) = {
  for k in required-colors {
    if not k in t.colors { panic("falta el color requerido: " + k) }
  }
  for k in required-fonts {
    if not k in t.fonts { panic("falta la fuente requerida: " + k) }
  }
  t
}

// ================= CREACIÓN / DERIVACIÓN =================

// Crea un tema nuevo a partir del base (los colores/fuentes que pases sobreescriben)
#let define(name, colors: (:), fonts: (:)) = {
  let t = (name: name, colors: base.colors + colors, fonts: base.fonts + fonts)
  validate(t)
  t
}

// Deriva un tema cambiando un color
#let with-color(t, key, value) = {
  let colors = t.colors
  colors.insert(key, value)
  validate((name: t.name, colors: colors, fonts: t.fonts))
}

// Deriva un tema cambiando una familia tipográfica
#let with-font(t, kind, family) = {
  let fonts = t.fonts
  fonts.insert(kind, if type(family) == array { family } else { (family,) })
  validate((name: t.name, colors: t.colors, fonts: fonts))
}

// Fusiona varios cambios de golpe
#let with(t, colors: (:), fonts: (:)) = validate((
  name: t.name,
  colors: t.colors + colors,
  fonts: t.fonts + fonts,
))

// Renombra un tema derivado
#let named(t, name) = (name: name, colors: t.colors, fonts: t.fonts)

// ================= ACCESO A TOKENS =================

#let color(key, t: base) = {
  if not (key in t.colors) { panic("color desconocido: " + key) }
  t.colors.at(key)
}

#let font(kind, t: base) = {
  if not (kind in t.fonts) { panic("fuente desconocida: " + kind) }
  t.fonts.at(kind)
}

#let colors(t: base) = t.colors
#let fonts(t: base) = t.fonts

// Derivados rápidos sobre tokens del tema
#let lighten(key, amount, t: base) = color(key, t: t).lighten(amount)
#let darken(key, amount, t: base) = color(key, t: t).darken(amount)
#let fade(key, opacity, t: base) = color(key, t: t).transparentize(100% - opacity)

// ================= CONTRASTE WCAG 2.x =================
// luminance/contrast/is-aa/is-aaa/readable-on/auto-pair/auto-pair-tinted
// venían reimplementados acá con un bug real: `.components()` sin forzar
// `.rgb()` antes lee mal los canales de cualquier color en espacio `luma`
// (white/black, literales que `base.colors.white` y el propio
// `readable-on(bg, white, black)` usan todo el tiempo) -- confirmado:
// `contrast(x, black)` daba de menos, al punto de hacer que
// `readable-on` eligiera el candidato equivocado en un caso real de
// examples/api.typ (elegía "blanco" cuando "negro" daba casi 3x más
// contraste). Ahora se importan de contrast.typ -- una sola
// implementación correcta en vez de dos (ésta y la de palettes.typ)
// reimplementando el mismo bug cada una por su lado.

// ================= PERSISTENCIA (JSON) =================

// Guarda un tema a JSON
#let export(t, path) = {
  let cs = (:)
  for (k, v) in t.colors { cs.insert(k, v.to-hex()) }
  json(path, (name: t.name, colors: cs, fonts: t.fonts))
}

// Carga un tema desde JSON
#let load(path) = {
  let data = json(path)
  let cs = (:)
  for (k, hexv) in data.colors { cs.insert(k, rgb(hexv)) }
  define(data.name, colors: cs, fonts: data.fonts)
}

// ================= NAMESPACE =================
// Permite: #import "theme.typ": theme  →  #theme.define(...), #theme.color(...)
#let theme = (
  base: base,
  define: define,
  named: named,
  "with": with,
  "with-color": with-color,
  "with-font": with-font,
  color: color,
  font: font,
  colors: colors,
  fonts: fonts,
  lighten: lighten,
  darken: darken,
  fade: fade,
  luminance: luminance,
  contrast: contrast,
  "is-aa": is-aa,
  "is-aaa": is-aaa,
  "readable-on": readable-on,
  "auto-pair": auto-pair,
  "auto-pair-tinted": auto-pair-tinted,
  export: export,
  load: load,
)
