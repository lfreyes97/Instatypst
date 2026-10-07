// ─────────────────────────────────────────────────────────────
//  superbg / tramas.typ — NIVEL 2: halftone + rayos sunburst
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size

// Halftone real: el RADIO varía (no la opacidad) siguiendo un degradado.
// direccion: "horizontal" | "diagonal" | "radial".
#let bg-halftone(
  color: none,
  fondo: white,
  size: sizes.instagram,
  paso: 36,
  r-max: 11,
  r-min: 1.2,
  direccion: "diagonal",
  opacidad: 100%,
  centro: auto,
  theme: none,
) = {
  let size = _check-size(size)
  if direccion not in ("horizontal", "diagonal", "radial") {
    panic("bg-halftone: direccion \"" + direccion + "\" — usa horizontal | diagonal | radial")
  }
  let color = if color == none { _tcolor(theme, "primary", rgb("#4f46e5")) } else { color }
  let w = size.at(0)
  let h = size.at(1)
  let cx = if centro == auto { w / 2 } else { centro.at(0) }
  let cy = if centro == auto { h * 0.42 } else { centro.at(1) }
  let maxd = calc.sqrt(w * w + h * h) / 2
  let op = str(opacidad / 1% / 100)
  let xs = range(0, w + paso, step: paso)
  let ys = range(0, h + paso, step: paso)
  let pts = ()
  for y in ys { for x in xs {
    let t = if direccion == "horizontal" { x / w } else if direccion == "diagonal" { (x + y) / (w + h) } else {
      calc.sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy)) / maxd
    }
    let r = r-min + (r-max - r-min) * t
    pts.push("<circle cx='" + str(x) + "' cy='" + str(y) + "' r='" + str(r) + "' fill='" + color.to-hex() + "' fill-opacity='" + op + "'/>")
  } }
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>" + pts.join("") + "</svg>"
  if fondo == none {
    place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  } else {
    place(rect(width: 100%, height: 100%, fill: fondo)) + place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  }
}

// Rayos sunburst: cuñas alternas desde `centro`, look afiche/feria.
#let bg-rayos(
  color: none,
  fondo: white,
  size: sizes.instagram,
  n: 24,
  centro: auto,
  opacidad: 12%,
  theme: none,
) = {
  let size = _check-size(size)
  let color = if color == none { _tcolor(theme, "primary", rgb("#4f46e5")) } else { color }
  let w = size.at(0)
  let h = size.at(1)
  let cx = if centro == auto { w / 2 } else { centro.at(0) }
  let cy = if centro == auto { h * 0.38 } else { centro.at(1) }
  let op = str(opacidad / 1% / 100)
  let radio = calc.max(w, h) * 1.6
  let paso-a = 2 * calc.pi / n
  let cunas = range(n).map(i => {
    if calc.rem(i, 2) == 1 { "" } else {
      let a0 = i * paso-a
      let a1 = (i + 1) * paso-a
      let x0 = cx + radio * calc.cos(a0)
      let y0 = cy + radio * calc.sin(a0)
      let x1 = cx + radio * calc.cos(a1)
      let y1 = cy + radio * calc.sin(a1)
      "<path d='M " + str(cx) + " " + str(cy) + " L " + str(x0) + " " + str(y0) + " A " + str(radio) + " " + str(radio) + " 0 0 1 " + str(x1) + " " + str(y1) + " Z' fill='" + color.to-hex() + "' fill-opacity='" + op + "'/>"
    }
  }).join("")
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>" + cunas + "</svg>"
  if fondo == none {
    place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  } else {
    place(rect(width: 100%, height: 100%, fill: fondo)) + place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
  }
}
