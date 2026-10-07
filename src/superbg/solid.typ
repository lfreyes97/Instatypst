// ─────────────────────────────────────────────────────────────
//  superbg / solid.typ — NIVEL 2: fondo plano
// ─────────────────────────────────────────────────────────────

// Fondo sólido a 100% del contenedor. Es la capa base de casi todo.
#let bg-plano(color, opacidad: 100%) = {
  place(rect(width: 100%, height: 100%, fill: color.transparentize(100% - opacidad)))
}
