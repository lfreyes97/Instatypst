// ─────────────────────────────────────────────────────────────
//  motifs/_curvas-de-nivel.typ — el mapa topográfico de la lámina 04
//
//  Anillos de curvas de nivel alrededor de una cumbre. Privado de
//  `resources/motifs/`: lo usa `stairs`. Viene de v1 (escalera.typ), sin
//  cambios de código. Cuando exista el recurso `curves` (campos continuos,
//  v1 curvas.typ) esto pasará a ser una de sus familias.
// ─────────────────────────────────────────────────────────────

// ── curvas de nivel ─────────────────────────────────────────
// Mapa topográfico de la lámina 04: anillos alrededor de `cumbre`
// ((x, y) en largos), cada uno un poco corrido hacia arriba a la
// izquierda (la ladera no es simétrica) y con una ondulación que crece
// hacia afuera; cada quinto anillo, más grueso, como las curvas
// maestras. `sep` es la distancia entre anillos.
// (Propias y no bg-topo de superbg: acá la cumbre cae en un punto
// preciso, debajo del clímax.)
#let curvas-de-nivel(cumbre, color, n: 34, sep: 40pt, pasos: 140) = {
  let (x0, y0) = (cumbre.at(0) / 1pt, cumbre.at(1) / 1pt)
  let sep = sep / 1pt
  let deriva = sep / 40 // el corrimiento por anillo crece con la separación
  for k in range(1, n + 1) {
    let r = k * sep
    let cx = x0 - k * 6.5 * deriva
    let cy = y0 - k * 11 * deriva
    let amp = calc.min(0.24, 0.10 + k * 0.006)
    let pts = range(pasos).map(i => {
      let a = 2 * calc.pi * i / pasos
      let f = 1 + amp * (0.5 * calc.sin(2 * a + 0.9 + k * 0.06) + 0.32 * calc.sin(3 * a + 2.1 - k * 0.05) + 0.18 * calc.sin(5 * a + 0.4 + k * 0.09))
      ((cx + r * f * calc.cos(a)) * 1pt, (cy + r * f * 1.18 * calc.sin(a)) * 1pt)
    })
    let maestra = calc.rem(k, 5) == 0
    place(top + left, polygon(
      stroke: (if maestra { 2.2pt } else { 1.1pt }) + color.transparentize(if maestra { 55% } else { 72% }),
      ..pts,
    ))
  }
}
