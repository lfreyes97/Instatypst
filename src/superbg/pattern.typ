// ─────────────────────────────────────────────────────────────
//  superbg / pattern.typ — NIVEL 2: patrones SVG + ruido + viñeta
//  patron: "dots" | "grid" | "diagonal" | "anillos" | "cruz"
//          | "ruido" | "vignette"
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size

#let _svg-patron(w, h, patron, hex, paso, grosor, radio, opacidad-pct, hex-fondo) = {
  let op = str(opacidad-pct / 100)
  let base = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>"
  let fondo = if hex-fondo == none { "" } else {
    "<rect x='0' y='0' width='" + str(w) + "' height='" + str(h) + "' fill='" + hex-fondo + "'/>"
  }
  if patron == "dots" {
    let xs = range(0, w + paso, step: paso)
    let ys = range(0, h + paso, step: paso)
    let pts = ()
    for y in ys { for x in xs { pts.push("<circle cx='" + str(x) + "' cy='" + str(y) + "' r='" + str(radio) + "' fill='" + hex + "' fill-opacity='" + op + "'/>") } }
    (base, fondo, pts.join(""), "</svg>").join("")
  } else if patron == "grid" {
    let xs = range(0, w + paso, step: paso)
    let ys = range(0, h + paso, step: paso)
    let lines = ()
    for x in xs { lines.push("<line x1='" + str(x) + "' y1='0' x2='" + str(x) + "' y2='" + str(h) + "' stroke='" + hex + "' stroke-opacity='" + op + "' stroke-width='" + str(grosor) + "'/>") }
    for y in ys { lines.push("<line x1='0' y1='" + str(y) + "' x2='" + str(w) + "' y2='" + str(y) + "' stroke='" + hex + "' stroke-opacity='" + op + "' stroke-width='" + str(grosor) + "'/>") }
    (base, fondo, lines.join(""), "</svg>").join("")
  } else if patron == "diagonal" {
    // Líneas a 45°: barremos c = x - y.
    let diags = ()
    let c = -h
    while c < w + h {
      diags.push("<line x1='" + str(c) + "' y1='0' x2='" + str(c + h) + "' y2='" + str(h) + "' stroke='" + hex + "' stroke-opacity='" + op + "' stroke-width='" + str(grosor) + "'/>")
      c += paso
    }
    (base, fondo, diags.join(""), "</svg>").join("")
  } else if patron == "anillos" {
    let xs = range(0, w + paso, step: paso)
    let ys = range(0, h + paso, step: paso)
    let rings = ()
    for y in ys { for x in xs { rings.push("<circle cx='" + str(x) + "' cy='" + str(y) + "' r='" + str(radio) + "' fill='none' stroke='" + hex + "' stroke-opacity='" + op + "' stroke-width='" + str(grosor) + "'/>") } }
    (base, fondo, rings.join(""), "</svg>").join("")
  } else if patron == "cruz" {
    let xs = range(0, w + paso, step: paso)
    let ys = range(0, h + paso, step: paso)
    let l = radio
    let marks = ()
    for y in ys { for x in xs {
      marks.push("<path d='M " + str(x - l) + " " + str(y) + " H " + str(x + l) + " M " + str(x) + " " + str(y - l) + " V " + str(y + l) + "' stroke='" + hex + "' stroke-opacity='" + op + "' stroke-width='" + str(grosor) + "' stroke-linecap='round'/>")
    } }
    (base, fondo, marks.join(""), "</svg>").join("")
  } else if patron == "ruido" {
    (
      base, fondo,
      "<filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/><feColorMatrix type='saturate' values='0'/></filter>",
      "<rect x='0' y='0' width='" + str(w) + "' height='" + str(h) + "' fill='" + hex + "' filter='url(#n)' opacity='" + op + "'/>",
      "</svg>",
    ).join("")
  } else if patron == "vignette" {
    (
      base, fondo,
      "<defs><radialGradient id='v' cx='50%' cy='50%' r='75%'>",
      "<stop offset='55%' stop-color='" + hex + "' stop-opacity='0'/>",
      "<stop offset='100%' stop-color='" + hex + "' stop-opacity='" + op + "'/>",
      "</radialGradient></defs>",
      "<rect x='0' y='0' width='" + str(w) + "' height='" + str(h) + "' fill='url(#v)'/>",
      "</svg>",
    ).join("")
  } else {
    panic("bg-patron: patron desconocido \"" + patron + "\" — usa dots | grid | diagonal | anillos | cruz | ruido | vignette")
  }
}

#let bg-patron(
  patron: "dots",
  color: none,
  fondo: none,
  paso: 48,
  grosor: 1.5,
  radio: 3,
  opacidad: 18%,
  size: sizes.instagram,
  theme: none,
) = {
  let size = _check-size(size)
  let color = if color == none { _tcolor(theme, "dark", rgb("#111111")) } else { color }
  let hex-fondo = if fondo == none { none } else { fondo.to-hex() }
  let svg = _svg-patron(size.at(0), size.at(1), patron, color.to-hex(), paso, grosor, radio, opacidad / 1%, hex-fondo)
  place(image(bytes(svg), format: "svg", width: 100%, height: 100%))
}

// Atajo legible para viñeta (no pide paso/radio).
#let bg-vignette(color: black, intensidad: 35%, size: sizes.instagram) = {
  bg-patron(patron: "vignette", color: color, opacidad: intensidad, size: size)
}
