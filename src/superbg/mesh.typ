// ─────────────────────────────────────────────────────────────
//  superbg / mesh.typ — NIVEL 2: malla de color orgánica
//  Distinto de bg-aura(): ahí N círculos iguales en diagonal; acá cada
//  punto tiene posición Y radio propios (jitter con semilla) — manchas
//  de pesos distintos que se funden, no una fila ordenada.
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size
#import "spots.typ": _svg-aura
#import "azar.typ": _secuencia

#let bg-malla(
  colores,
  size: sizes.instagram,
  puntos: auto,
  radios: auto,
  blur: auto,
  fondo: none,
  semilla: 7,
  theme: none,
) = {
  let size = _check-size(size)
  let colores = if colores == auto {
    (_tcolor(theme, "primary", rgb("#4f46e5")), _tcolor(theme, "secondary", rgb("#db2777")), _tcolor(theme, "accent", rgb("#f59e0b")))
  } else { colores }
  let w = size.at(0)
  let h = size.at(1)
  let n = colores.len()
  if n == 0 { panic("bg-malla: `colores` vacío") }
  let centros = if puntos == auto {
    let js = _secuencia(2 * n, semilla)
    range(n).map(i => {
      let t = if n == 1 { 0.5 } else { i / (n - 1) }
      (
        w * (0.22 + 0.56 * t) + (js.at(2 * i) - 0.5) * w * 0.24,
        h * (0.68 - 0.36 * t) + (js.at(2 * i + 1) - 0.5) * h * 0.24,
      )
    })
  } else { puntos }
  let base = calc.min(w, h) * 0.34
  let rs = if radios == auto {
    let js = _secuencia(n, semilla + 1)
    range(n).map(i => base * (0.75 + 0.7 * js.at(i)))
  } else if type(radios) == array {
    if radios.len() != n { panic("bg-malla: `radios` debe tener tantos valores como `colores`") }
    radios
  } else {
    range(n).map(_ => radios)
  }
  let blur = if blur == auto { base * 0.55 } else { blur }
  let circulos = range(n).map(i => (centros.at(i).at(0), centros.at(i).at(1), rs.at(i), colores.at(i).to-hex()))
  let aura = place(image(
    bytes(_svg-aura(w, h, blur, circulos)),
    format: "svg", width: 100%, height: 100%,
  ))
  if fondo == none { aura } else {
    place(rect(width: 100%, height: 100%, fill: fondo)) + aura
  }
}
