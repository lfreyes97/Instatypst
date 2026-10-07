// ─────────────────────────────────────────────────────────────
//  superbg / _util.typ — utilidades internas (no se exporta solo)
//  sizes independientes + resolución theme-agnóstica + validación
// ─────────────────────────────────────────────────────────────

// Medidas propias (duplicadas a propósito: superbg NO importa
// social.typ de Instatypst — independencia total).
#let sizes = (
  instagram: (1080, 1080),
  cuadrado: (1080, 1080),
  story: (1080, 1920),
  twitter: (1600, 900),
  linkedin: (1200, 1200),
)

// Resuelve un color por defecto desde un theme opcional.
// `theme` es duck-typing: cualquier dict con `.colors` (p. ej. el
// theme de Instatypst) — NUNCA se importa Instatypst aquí.
// Uso: #_tcolor(theme, "primary", rgb("#4f46e5"))
#let _tcolor(theme, key, fallback) = {
  if theme == none { fallback } else if "colors" in theme and key in theme.colors {
    theme.colors.at(key)
  } else { fallback }
}

// Valida que size sea (w, h) numérico.
#let _check-size(size) = {
  if type(size) != array or size.len() != 2 {
    panic("superbg: `size` debe ser (ancho, alto), p. ej. sizes.instagram — recibido: " + repr(size))
  }
  size
}

// Normaliza spec: string | dict-capa | array-capas | dict-motor -> dict-motor
// canónico (size:, capas: (...)).
#let _normalizar(spec, size) = {
  if type(spec) == str {
    (size: size, capas: ((tipo: "preset", nombre: spec),))
  } else if type(spec) == array {
    (size: size, capas: spec)
  } else if type(spec) == dictionary {
    if "capas" in spec {
      let s = if "size" in spec { spec.size } else { size }
      (size: s, capas: spec.capas)
    } else if "tipo" in spec {
      (size: size, capas: (spec,))
    } else {
      panic("superbg: dict no reconocido — usa (tipo: ..., ...) o (capas: (...), size: ...) — recibido: " + repr(spec.keys()))
    }
  } else {
    panic("superbg: spec debe ser string | dict | array — recibido: " + repr(type(spec)))
  }
}
