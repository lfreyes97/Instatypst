// ─────────────────────────────────────────────────────────────
//  superbg / compose.typ — NIVEL 2/3: frame lateral + vidrio + apilar
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _tcolor, _check-size
#import "spots.typ": _svg-aura

// Franjas de aura en los bordes + tarjeta sólida en medio.
// Es el `frame:` de cita-canvas (Instatypst) como capa independiente:
// ocupa exactamente el margen `margen` a cada lado, el contenido no se
// mueve. `izq`/`der` son los dos colores de borde.
#let bg-frame(izq, der, centro: white, margen: 80pt, size: sizes.instagram, theme: none) = {
  let size = _check-size(size)
  let izq = if izq == auto { _tcolor(theme, "primary", rgb("#4f46e5")) } else { izq }
  let der = if der == auto { _tcolor(theme, "secondary", rgb("#db2777")) } else { der }
  let w = size.at(0)
  let h = size.at(1)
  let r = calc.max(w, h) * 0.37
  let circulos = ((0, 0, r, izq.to-hex()), (0, h, r, izq.to-hex()), (w, 0, r, der.to-hex()), (w, h, r, der.to-hex()))
  let svg = _svg-aura(w, h, r * 0.55, circulos)
  (
    place(image(bytes(svg), format: "svg", width: 100%, height: 100%)),
    place(dx: margen, rect(width: 100% - 2 * margen, height: 100%, fill: centro)),
  ).join()
}

// Vidrio esmerilado APROXIMADO (tinte + borde, sin blur real).
// El blur REAL solo es posible fusionando fondo+panel en un mismo SVG
// (ver bg-aura(..., panel:) o el motor con aura+vidrio juntos) — esta
// capa sola es para componer sobre CUALQUIER fondo ya existente.
#let bg-vidrio(x, y, w, h, r: 24pt, tinte: white, borde: auto, size: sizes.instagram) = {
  let borde = if borde == auto { tinte } else { borde }
  place(dx: x, dy: y, block(width: w, height: h, radius: r, clip: true)[
    #rect(width: 100%, height: 100%, fill: tinte.transparentize(65%))
    #place(rect(width: 100%, height: 100%, radius: r, fill: none, stroke: 1.5pt + borde.transparentize(40%)))
  ])
}

// Apila capas ya construidas (contents con place) en orden.
#let combinar(..capas) = capas.pos().join()
