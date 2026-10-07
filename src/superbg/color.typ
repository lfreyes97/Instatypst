// ─────────────────────────────────────────────────────────────
//  superbg / color.typ — color inteligente mínimo (sin dependencias)
//  Luminancia/contraste WCAG 2.x con el mismo fix que superpelettes:
//  `.rgb()` antes de `.components()`, o white/black (espacio luma,
//  2 componentes) se leen mal.
// ─────────────────────────────────────────────────────────────

#let _lin(v) = {
  let x = v / 100%
  if x <= 0.03928 { x / 12.92 } else { calc.pow((x + 0.055) / 1.055, 2.4) }
}

#let _luminancia(c) = {
  let k = c.rgb().components()
  0.2126 * _lin(k.at(0)) + 0.7152 * _lin(k.at(1)) + 0.0722 * _lin(k.at(2))
}

// Ratio de contraste WCAG (1–21).
#let contraste(a, b) = {
  let l1 = _luminancia(a)
  let l2 = _luminancia(b)
  let hi = calc.max(l1, l2)
  let lo = calc.min(l1, l2)
  (hi + 0.05) / (lo + 0.05)
}

// ¿Pasa AA? (4.5 normal, 3 grande)
#let es-aa(a, b, nivel: "normal") = {
  contraste(a, b) >= if nivel == "grande" { 3 } else { 4.5 }
}

// El que más contrasta sobre `fondo` — para titulares/botones directos
// sobre el fondo sin adivinar.
#let texto-sobre(fondo, claro: white, oscuro: rgb("#1c1917")) = {
  if contraste(fondo, claro) >= contraste(fondo, oscuro) { claro } else { oscuro }
}
