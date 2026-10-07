// ─────────────────────────────────────────────────────────────
//  superbg / spots.typ — NIVEL 2: manchas (blob sólido + aura blur)
//  Porte de blob()/aura-bg() de Instatypst/social.typ, sin dependencia.
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size

// Mancha sólida simple (transparencia, sin blur).
#let bg-blob(x, y, radio, color, opacidad: 20%) = place(
  dx: x, dy: y,
  circle(radius: radio * 1pt, fill: color.transparentize(100% - opacidad)),
)

// SVG interno del aura (círculos + blur + opcional panel vidrio real).
#let _svg-aura(w, h, blur, circulos, panel: none, panel-blur: auto, tinte: white) = {
  let elipses = circulos.map(c => "<circle cx='" + str(c.at(0)) + "' cy='" + str(c.at(1)) + "' r='" + str(c.at(2)) + "' fill='" + c.at(3) + "'/>").join("")
  let pblur = if panel-blur == auto { blur * 0.4 } else { panel-blur }
  let pr = if panel == none { 0 } else { panel.at("r", default: 0) }
  let panel-defs = if panel == none {
    ""
  } else {
    (
      "<filter id='pb' x='-50%' y='-50%' width='200%' height='200%'><feGaussianBlur stdDeviation='" + str(pblur) + "'/></filter>",
      "<clipPath id='pc'><rect x='" + str(panel.x) + "' y='" + str(panel.y) + "' width='" + str(panel.w) + "' height='" + str(panel.h) + "' rx='" + str(pr) + "'/></clipPath>",
    ).join("")
  }
  let panel-capas = if panel == none {
    ""
  } else {
    (
      "<g filter='url(#pb)' clip-path='url(#pc)'>" + elipses + "</g>",
      "<rect x='" + str(panel.x) + "' y='" + str(panel.y) + "' width='" + str(panel.w) + "' height='" + str(panel.h) + "' rx='" + str(pr) + "' fill='" + tinte.to-hex() + "' fill-opacity='0.35'/>",
      "<rect x='" + str(panel.x) + "' y='" + str(panel.y) + "' width='" + str(panel.w) + "' height='" + str(panel.h) + "' rx='" + str(pr) + "' fill='none' stroke='" + tinte.to-hex() + "' stroke-opacity='0.6' stroke-width='1.5'/>",
    ).join("")
  }
  (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>",
    "<defs><filter id='b' x='-100%' y='-100%' width='400%' height='400%'><feGaussianBlur stdDeviation='" + str(blur) + "'/></filter>" + panel-defs + "</defs>",
    "<g filter='url(#b)'>" + elipses + "</g>",
    panel-capas,
    "</svg>",
  ).join("")
}

// Aura desenfocada real (SVG + feGaussianBlur). `colores:` se reparte en
// diagonal; `posiciones:` ((x,y), ...) para control manual en las mismas
// unidades que `size`. `panel:` dict (x:, y:, w:, h:, r:) dibuja vidrio
// esmerilado REAL sobre las mismas manchas (no aproximación).
#let bg-aura(colores, size: sizes.instagram, r: auto, blur: auto, posiciones: auto, panel: none, panel-blur: auto, tinte: white, theme: none) = {
  let size = _check-size(size)
  let colores = if colores == auto {
    (_tcolor(theme, "primary", rgb("#4f46e5")), _tcolor(theme, "secondary", rgb("#db2777")), _tcolor(theme, "accent", rgb("#f59e0b")))
  } else { colores }
  let w = size.at(0)
  let h = size.at(1)
  let n = colores.len()
  if n == 0 { panic("bg-aura: `colores` vacío") }
  let r = if r == auto { calc.min(w, h) * 0.38 } else { r }
  let blur = if blur == auto { r * 0.55 } else { blur }
  let centros = if posiciones == auto {
    range(n).map(i => {
      let t = if n == 1 { 0.5 } else { i / (n - 1) }
      (w * (0.3 + 0.4 * t), h * (0.3 + 0.4 * (1 - t)))
    })
  } else {
    posiciones
  }
  let circulos = range(n).map(i => (centros.at(i).at(0), centros.at(i).at(1), r, colores.at(i).to-hex()))
  place(image(
    bytes(_svg-aura(w, h, blur, circulos, panel: panel, panel-blur: panel-blur, tinte: tinte)),
    format: "svg", width: 100%, height: 100%,
  ))
}
