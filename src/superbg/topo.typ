// ─────────────────────────────────────────────────────────────
//  superbg / topo.typ — NIVEL 2: curvas de nivel topográficas
//  Anillos concéntricos con wobble sinusoidal (semilla fija) —
//  trazo fino sobre fondo claro, típico look editorial/mapa.
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size

#let bg-topo(
  color: none,
  fondo: rgb("#fafaf9"),
  size: sizes.instagram,
  centro: auto,
  anillos: 14,
  separacion: 46,
  wobble: 18,
  grosor: 1.6,
  opacidad: 30%,
  semilla: 5,
  theme: none,
) = {
  let size = _check-size(size)
  let color = if color == none { _tcolor(theme, "primary", rgb("#4f46e5")) } else { color }
  let w = size.at(0)
  let h = size.at(1)
  let cx = if centro == auto { w / 2 } else { centro.at(0) }
  let cy = if centro == auto { h * 0.44 } else { centro.at(1) }
  let op = str(opacidad / 1% / 100)
  let pasos = 96
  let curvas = range(anillos).map(k => {
    let r = (k + 1) * separacion
    let pts = range(pasos + 1).map(i => {
      let a = 2 * calc.pi * i / pasos
      let rr = r + wobble * calc.sin(3 * a + k * 1.7 + semilla)
      str(cx + rr * calc.cos(a)) + " " + str(cy + rr * calc.sin(a))
    })
    "<path d='M " + pts.join(" L ") + " Z' fill='none' stroke='" + color.to-hex() + "' stroke-opacity='" + op + "' stroke-width='" + str(grosor) + "'/>"
  }).join("")
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>" + curvas + "</svg>"
  if fondo == none {
    place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  } else {
    place(rect(width: 100%, height: 100%, fill: fondo)) + place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  }
}
