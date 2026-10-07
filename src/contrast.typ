// ─────────────────────────────────────────────────────────────
//  CONTRASTE WCAG 2.x — luminancia relativa + ratio de contraste
//
//  Vendorizado desde el paquete hermano `superpelettes` (lib/contrast.typ)
//  para que Instatypst no dependa de un paquete `@local` instalado a
//  mano fuera de este repo. Única implementación en todo el sistema —
//  theme.typ y palettes.typ importan de acá, ninguno reimplementa nada.
//
//  OJO: `.components()` depende del espacio del color — un gris puro
//  como `white`/`black` vive en `luma`, no en `rgb`. Por eso `luminance`
//  fuerza `.rgb()` antes de leer los canales (sin esto, `luminance(black)`
//  da 0.7152 en vez de 0 — hace que `readable-on` elija el candidato
//  equivocado).
// ─────────────────────────────────────────────────────────────

#let _chan(v) = {
  let x = v / 100%
  if x <= 0.04045 { x / 12.92 } else { calc.pow((x + 0.055) / 1.055, 2.4) }
}

#let luminance(c) = {
  let comps = c.rgb().components()
  let r = comps.at(0)
  let g = comps.at(1, default: r)
  let b = comps.at(2, default: r)
  0.2126 * _chan(r) + 0.7152 * _chan(g) + 0.0722 * _chan(b)
}

#let contrast(a, b) = {
  let l1 = luminance(a)
  let l2 = luminance(b)
  (calc.max(l1, l2) + 0.05) / (calc.min(l1, l2) + 0.05)
}

#let is-aa(a, b) = contrast(a, b) >= 4.5
#let is-aaa(a, b) = contrast(a, b) >= 7.0

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

// Para cualquier bg en sRGB, max(contraste(bg, blanco),
// contraste(bg, negro)) >= ~4.58:1 (mínimo en el punto donde ambas
// curvas WCAG se cruzan). Blanco+negro como candidatos garantizan AA
// (4.5:1) sin excepción, para cualquier fondo.
#let auto-pair(bg, candidates: (white, black)) = (
  bg: bg,
  fg: readable-on(bg, ..candidates),
)

// Variante con candidatos extra (p. ej. un tono oscuro/claro del mismo
// matiz) para un look menos plano — la garantía AA se mantiene porque
// blanco y negro siguen en la lista.
#let auto-pair-tinted(bg, extra: ()) = auto-pair(bg, candidates: (white, black) + extra)
