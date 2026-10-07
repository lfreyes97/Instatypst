// ─────────────────────────────────────────────────────────────
//  superbg / waves.typ — NIVEL 2: olas en capas (bandas sinusoidales)
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size

#let _onda(w, base-y, amp, vueltas, fase, pasos: 72) = {
  let pts = range(pasos + 1).map(i => {
    let x = w * i / pasos
    let y = base-y + amp * calc.sin(2 * calc.pi * vueltas * i / pasos + fase)
    str(x) + " " + str(y)
  })
  "M 0 " + str(base-y + 4000) + " L 0 " + pts.at(0).split(" ").at(1) + " L " + pts.join(" L ") + " L " + str(w) + " " + str(base-y + 4000) + " Z"
}

#let bg-olas(
  colores,
  fondo: white,
  size: sizes.instagram,
  amplitud: 90,
  vueltas: 2,
  fase: 0,
  base: 0.62,
  separacion: 0.13,
  desfase: 0.9,
  ancla: "abajo",
  capas: auto,
  theme: none,
) = {
  let size = _check-size(size)
  if ancla not in ("abajo", "arriba") { panic("bg-olas: ancla \"" + ancla + "\" — usa \"abajo\" | \"arriba\"") }
  let colores = if colores == auto {
    (_tcolor(theme, "primary", rgb("#4f46e5")), _tcolor(theme, "secondary", rgb("#8b5cf6")))
  } else { colores }
  let w = size.at(0)
  let h = size.at(1)
  let n = colores.len()
  if n == 0 { panic("bg-olas: `colores` vacío") }
  // (color, base-y, amp, fase) por capa, de atrás hacia adelante.
  let defs = if capas == auto {
    range(n).map(i => (
      color: colores.at(i),
      b: base - (n - 1 - i) * separacion,
      amp: amplitud * (1 + 0.3 * i / n),
      f: fase + i * desfase,
    ))
  } else { capas }
  let bandas = defs.map(d => {
    let by = d.at("b", default: base) * h
    let path = _onda(w, by, d.at("amp", default: amplitud), vueltas, d.at("f", default: fase))
    "<path d='" + path + "' fill='" + d.at("color", default: colores.at(0)).to-hex() + "'/>"
  }).join("")
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>" + bandas + "</svg>"
  let svg = if ancla == "arriba" {
    // Reflexión vertical real del conjunto (el path ya se dibujó hacia
    // abajo; con ancla arriba queremos lo espejado).
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'><g transform='translate(0 " + str(h) + ") scale(1 -1)'>" + bandas + "</g></svg>"
  } else { svg }
  let fondo-svg = if fondo == none { "" } else {
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'><rect x='0' y='0' width='" + str(w) + "' height='" + str(h) + "' fill='" + fondo.to-hex() + "'/></svg>"
  }
  if fondo == none {
    place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  } else {
    place(image(bytes(fondo-svg), format: "svg", width: 100%, height: 100%)) + place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  }
}
