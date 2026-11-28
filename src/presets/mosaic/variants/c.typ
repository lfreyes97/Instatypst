// ─────────────────────────────────────────────────────────────
//  presets/mosaic/variants/c.typ — variant: "c" (en v1, variante "c")
//
//  Una «C»: diez arcos con la boca a la derecha, un rombo en la boca y un
//  círculo hondo abajo a la izquierda, sobre el papel. Es la variante por
//  defecto de mosaic.
//
//  Una variante de mosaic es el dato de su composición (lo que v1 llamaba
//  `_variantes.<nombre>`). Posiciones y diámetros en px de la lámina de
//  referencia (802,5 × 1117,5), desde la esquina de arriba a la izquierda;
//  los colores son ROLES del tema, no valores. Todo está medido sobre el
//  render de la referencia.
//    thickness  grosor de las líneas
//    title      el rótulo vertical (author): x = su eje, y = donde empieza
//    foot-x     borde derecho del rótulo del pie (work)
//    plans      cómo se reparte el texto: "band" (la banda libre sobre el arte)
//               o "diagonal" (la pila arriba y el bloque abajo, a uno y otro
//               lado del brazo largo)
// ─────────────────────────────────────────────────────────────

#let variant = (
  paper: "paper",
  thickness: 10.5,
  arcs: (center: (441.2, 531.3), radius: 58.6, step: 28.48, from: 45deg, to: 315deg, tail: (0, 0), color: "ink"),
  circles: ((center: (215.3, 872.6), d: 261.1, color: "deep"),),
  rhombi: ((center: (577.35, 535.15), diag: 133, color: "accent"),),
  text: "deep",
  title: (x: 49.5, y: 169),
  foot-x: 717,
  plans: "band",
)
