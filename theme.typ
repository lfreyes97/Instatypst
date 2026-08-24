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

// ===== Claves requeridas =====
#let required-colors = ("primary", "secondary", "accent", "dark", "light", "white")
#let required-fonts = ("display", "body")

// ===== Tema base (tokens del sistema) =====
#let base = (
  name: "default",
  colors: (
    primary: token("indigo-400"),
    secondary: token("pink-400"),
    accent: token("amber-550"),
    dark: token("slate-900"),
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

// ================= UTILIDADES DE CONTRASTE (WCAG 2.x) =================

#let _chan(v) = {
  let x = v / 100
  if x <= 4.045% { x / 12.92 } else { calc.pow((x + 5.5%) / 105.5%, 2.4) }
}

#let luminance(c) = {
  let comps = c.components()
  let r = comps.at(0)
  let g = comps.at(1, default: r)
  let b = comps.at(2, default: r)
  0.2126 * _chan(r) + 0.7152 * _chan(g) + 0.0722 * _chan(b)
}

// Ratio de contraste entre dos colores (1.0 – 21.0)
#let contrast(a, b) = {
  let l1 = luminance(a)
  let l2 = luminance(b)
  (calc.max(l1, l2) + 5%) / (calc.min(l1, l2) + 5%)
}

// ¿Cumple AA (4.5) / AAA (7)?
#let is-aa(a, b) = contrast(a, b) >= 4.5
#let is-aaa(a, b) = contrast(a, b) >= 7.0

// Elige el candidato con mejor contraste sobre `bg`
#let readable-on(bg, ..candidates) = {
  let best = none
  let best-r = -1.0
  for c in candidates.pos() {
    let r = contrast(c, bg)
    if r > best-r {
      best-r = r
      best = c
    }
  }
  best
}

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
  export: export,
  load: load,
)
