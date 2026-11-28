// ─────────────────────────────────────────────────────────────
//  presets/mosaic/variants/u.typ — variant: "u" (en v1, variante "u")
//
//  Una «U» hacia abajo y a la derecha: el brazo largo sale por el borde. Papel
//  acento, un círculo del papel y otro hondo. Ver `c.typ` para el significado
//  de los campos.
// ─────────────────────────────────────────────────────────────

#let variant = (
  paper: "accent",
  thickness: 7.5,
  arcs: (center: (363.1, 474.7), radius: 60.2, step: 20.87, axis: 45deg, tail: (247.3, 4000), color: "ink"),
  circles: (
    (center: (412.65, 227.0), d: 294.4, color: "paper"),
    (center: (261.05, 915.25), d: 151.6, color: "deep"),
  ),
  rhombi: (),
  text: "deep",
  title: (x: 61.5, y: 676),
  foot-x: 702,
  // la pila arriba a la derecha, título y párrafo abajo a la derecha (bajo el brazo largo)
  plans: "diagonal",
)
