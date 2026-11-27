// ─────────────────────────────────────────────────────────────
//  superbg / gradient.typ — NIVEL 2: gradientes
//  tipo: "linear" | "radial" | "conic"
// ─────────────────────────────────────────────────────────────

#import "_util.typ": _tcolor

#let bg-gradiente(from: none, to: none, angulo: 135deg, tipo: "linear", parar: none, theme: none) = {
  if tipo not in ("linear", "radial", "conic") {
    panic("bg-gradiente: tipo desconocido \"" + tipo + "\" — usa \"linear\" | \"radial\" | \"conic\"")
  }
  let from = if from == none { _tcolor(theme, "primary", rgb("#4f46e5")) } else { from }
  let to = if to == none { _tcolor(theme, "secondary", rgb("#db2777")) } else { to }
  let grad = if tipo == "linear" {
    if parar == none { gradient.linear(angle: angulo, from, to) } else { gradient.linear(angle: angulo, ..parar) }
  } else if tipo == "radial" {
    if parar == none { gradient.radial(from, to) } else { gradient.radial(..parar) }
  } else {
    if parar == none { gradient.conic(angle: angulo, from, to) } else { gradient.conic(angle: angulo, ..parar) }
  }
  place(rect(width: 100%, height: 100%, fill: grad))
}
