// ─────────────────────────────────────────────────────────────
//  superbg / memphis.typ — NIVEL 2: confetti estilo Memphis
//  Formas dispersas con PRNG de semilla (misma semilla = mismo layout).
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size
#import "azar.typ": _secuencia

#let _figura(forma, x, y, s, hex, op, ang, grosor) = {
  let g0 = "<g transform='rotate(" + str(ang) + " " + str(x) + " " + str(y) + ")' opacity='" + op + "'>"
  let g1 = "</g>"
  if forma == "circulo" {
    "<circle cx='" + str(x) + "' cy='" + str(y) + "' r='" + str(s / 2) + "' fill='" + hex + "' opacity='" + op + "'/>"
  } else if forma == "aro" {
    "<circle cx='" + str(x) + "' cy='" + str(y) + "' r='" + str(s / 2) + "' fill='none' stroke='" + hex + "' stroke-width='" + str(grosor) + "' opacity='" + op + "'/>"
  } else if forma == "triangulo" {
    g0 + "<polygon points='" + str(x) + "," + str(y - s / 2) + " " + str(x + s / 2) + "," + str(y + s / 2) + " " + str(x - s / 2) + "," + str(y + s / 2) + "' fill='" + hex + "'/>" + g1
  } else if forma == "cuadrado" {
    g0 + "<rect x='" + str(x - s / 2) + "' y='" + str(y - s / 2) + "' width='" + str(s) + "' height='" + str(s) + "' fill='" + hex + "'/>" + g1
  } else if forma == "linea" {
    g0 + "<line x1='" + str(x - s / 2) + "' y1='" + str(y) + "' x2='" + str(x + s / 2) + "' y2='" + str(y) + "' stroke='" + hex + "' stroke-width='" + str(grosor) + "' stroke-linecap='round'/>" + g1
  } else if forma == "cruz" {
    let l = s / 2
    g0 + "<path d='M " + str(x - l) + " " + str(y) + " H " + str(x + l) + " M " + str(x) + " " + str(y - l) + " V " + str(y + l) + "' stroke='" + hex + "' stroke-width='" + str(grosor) + "' stroke-linecap='round'/>" + g1
  } else {
    "<circle cx='" + str(x) + "' cy='" + str(y) + "' r='3' fill='" + hex + "' opacity='" + op + "'/>"
  }
}

#let bg-memphis(
  colores: auto,
  fondo: auto,
  size: sizes.instagram,
  densidad: 26,
  semilla: 3,
  grosor: 5,
  opacidad: 85%,
  theme: none,
) = {
  let size = _check-size(size)
  let colores = if colores == auto {
    (_tcolor(theme, "primary", rgb("#4f46e5")), _tcolor(theme, "secondary", rgb("#db2777")), _tcolor(theme, "accent", rgb("#f59e0b")))
  } else { colores }
  let fondo = if fondo == auto {
    if theme != none and "colors" in theme { theme.colors.light } else { rgb("#fafaf9") }
  } else { fondo }
  let w = size.at(0)
  let h = size.at(1)
  let formas = ("circulo", "aro", "triangulo", "cuadrado", "linea", "cruz", "punto")
  let px = _secuencia(densidad, semilla)
  let py = _secuencia(densidad, semilla + 101)
  let pc = _secuencia(densidad, semilla + 202)
  let pf = _secuencia(densidad, semilla + 303)
  let ps = _secuencia(densidad, semilla + 404)
  let pa = _secuencia(densidad, semilla + 505)
  let op = str(opacidad / 1% / 100)
  let figs = range(densidad).map(i => {
    let x = px.at(i) * w
    let y = py.at(i) * h
    let c = colores.at(calc.floor(pc.at(i) * colores.len()))
    let f = formas.at(calc.floor(pf.at(i) * formas.len()))
    let s = 14 + ps.at(i) * 26
    _figura(f, x, y, s, c.to-hex(), op, pa.at(i) * 360, grosor)
  }).join("")
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>" + figs + "</svg>"
  if fondo == none {
    place(image(bytes(svg.replace("−", "-")), format: "svg", width: 100%, height: 100%))
  } else {
    place(rect(width: 100%, height: 100%, fill: fondo)) + place(image(bytes(svg.replace("−", "-")), format: "svg", width: 100%, height: 100%))
  }
}
