// ─────────────────────────────────────────────────────────────
//  presets/mosaic/variants/u-inverted.typ — variant: "u-inverted" (en v1, "u-inversa")
//
//  Una «U» hacia abajo y a la izquierda, sobre fondo hondo, con las líneas en
//  gris (quiet). Ver `c.typ` para el significado de los campos.
// ─────────────────────────────────────────────────────────────

#let variant = (
  paper: "deep",
  thickness: 7.5,
  arcs: (center: (465.2, 497.5), radius: 26.6, step: 20.87, axis: 135deg, tail: (302, 302), color: "quiet"),
  circles: (
    (center: (386.15, 289.85), d: 203.5, color: "accent"),
    (center: (442.95, 784.05), d: 327.0, color: "paper"),
  ),
  rhombi: (),
  text: "quiet",
  title: (x: 743.5, y: 121),
  foot-x: 688,
  // el texto: la banda libre de arriba, sobre el círculo naranja
  plans: "band",
)
