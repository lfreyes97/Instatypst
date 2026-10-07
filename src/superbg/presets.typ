// ─────────────────────────────────────────────────────────────
//  superbg / presets.typ — NIVEL 1: fondos preconstruidos
//  Cada preset devuelve ARRAY DE CAPAS (para el motor) — no contenido.
//  `preset-capas()` + `lista-presets()` + `superbg-preset()` (render directo).
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor
#import "core.typ": _motor

#let _nombres = ("plano-claro", "amanecer", "noche", "papel-crema", "neon-aura", "editorial-suave", "rejilla-sutil", "puntos", "foto-oscura", "marco-lateral", "vidrio-aura", "atardecer-malla", "ola-nocturna", "ola-clara", "topo-papel", "halftone-pop", "memphis-fiesta", "rayos-alba", "aurora")

#let lista-presets() = _nombres

// Devuelve array de capas-dict para el motor. `args` permite:
//   ruta: para "foto-oscura" · colores: override · resto se ignora.
#let preset-capas(nombre, theme: none, ruta: none, colores: auto, centro: auto) = {
  let p = if theme != none and "colors" in theme { theme.colors } else { none }
  let light = if p != none { p.light } else { rgb("#f5f5f4") }
  let white = if p != none { p.white } else { white }
  let dark = if p != none { p.dark } else { rgb("#1c1917") }
  let c1 = if colores != auto and type(colores) == array and colores.len() >= 1 { colores.at(0) } else if p != none { p.primary } else { rgb("#4f46e5") }
  let c2 = if colores != auto and type(colores) == array and colores.len() >= 2 { colores.at(1) } else if p != none { p.secondary } else { rgb("#db2777") }
  let centro = if centro == auto { white } else { centro }

  if nombre == "plano-claro" {
    ((tipo: "plano", color: light),)
  } else if nombre == "amanecer" {
    ((tipo: "gradiente", from: c1, to: c2, angulo: 135deg),)
  } else if nombre == "noche" {
    ((tipo: "plano", color: dark), (tipo: "patron", patron: "dots", color: white, opacidad: 10%), (tipo: "vignette", color: black, intensidad: 45%))
  } else if nombre == "papel-crema" {
    ((tipo: "plano", color: rgb("#fdfbf7")), (tipo: "ruido", color: rgb("#78716c"), opacidad: 6%))
  } else if nombre == "neon-aura" {
    ((tipo: "plano", color: dark), (tipo: "aura", colores: (c1, c2, if p != none { p.accent } else { rgb("#f59e0b") })), (tipo: "vignette", color: black, intensidad: 30%))
  } else if nombre == "editorial-suave" {
    ((tipo: "plano", color: centro), (tipo: "patron", patron: "diagonal", color: c1, opacidad: 7%, paso: 56, grosor: 1.2))
  } else if nombre == "rejilla-sutil" {
    ((tipo: "plano", color: centro), (tipo: "patron", patron: "grid", color: c1, opacidad: 10%, paso: 56, grosor: 1))
  } else if nombre == "puntos" {
    ((tipo: "plano", color: centro), (tipo: "patron", patron: "dots", color: c1, opacidad: 14%, paso: 44, radio: 2.6))
  } else if nombre == "foto-oscura" {
    if ruta == none { panic("superbg preset \"foto-oscura\" necesita `ruta:` a la imagen") }
    ((tipo: "imagen", ruta: ruta, overlay: black, opacidad: 45%), (tipo: "vignette", color: black, intensidad: 35%))
  } else if nombre == "marco-lateral" {
    ((tipo: "frame", izq: c1, der: c2, centro: centro),)
  } else if nombre == "vidrio-aura" {
    // Vidrio REAL: aura + panel en el MISMO svg (fusión).
    ((tipo: "plano", color: dark), (tipo: "aura", colores: (c1, c2), panel: (x: 140, y: 340, w: 800, h: 400, r: 48)),)
  } else if nombre == "atardecer-malla" {
    ((tipo: "malla", colores: (rgb("#f97316"), rgb("#ec4899"), rgb("#8b5cf6")), fondo: rgb("#1c1917")), (tipo: "vignette", color: black, intensidad: 30%))
  } else if nombre == "ola-nocturna" {
    ((tipo: "olas", colores: (c1, c2), fondo: dark), (tipo: "vignette", color: black, intensidad: 25%))
  } else if nombre == "ola-clara" {
    ((tipo: "olas", colores: (c1, c2), fondo: centro),)
  } else if nombre == "topo-papel" {
    ((tipo: "topo", color: c1, fondo: rgb("#fafaf9")),)
  } else if nombre == "halftone-pop" {
    ((tipo: "plano", color: centro), (tipo: "halftone", color: c1, direccion: "radial", fondo: none),)
  } else if nombre == "memphis-fiesta" {
    ((tipo: "memphis", colores: if colores == auto and p != none { (p.primary, p.secondary, p.accent) } else { colores }, fondo: centro),)
  } else if nombre == "rayos-alba" {
    ((tipo: "rayos", color: c1, fondo: centro, opacidad: 14%),)
  } else if nombre == "aurora" {
    ((tipo: "malla", colores: (c1, c2, if p != none { p.accent } else { rgb("#f59e0b") }), fondo: dark), (tipo: "patron", patron: "dots", color: white, opacidad: 8%), (tipo: "vignette", color: black, intensidad: 30%))
  } else {
    panic("superbg: preset desconocido \"" + nombre + "\" — disponibles: " + _nombres.join(", "))
  }
}

// NIVEL 1 directo: renderiza el preset como fondo (place apilado).
#let superbg-preset(nombre, size: sizes.instagram, theme: none, ruta: none, colores: auto, centro: auto) = {
  _motor(preset-capas(nombre, theme: theme, ruta: ruta, colores: colores, centro: centro), size, theme)
}
