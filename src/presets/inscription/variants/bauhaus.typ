// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/bauhaus.typ — variant: "bauhaus"
//
//    bauhaus  cuadrado, círculo, cuña y barra apoyados en una línea de tierra
//             (la construcción de carteles.bauhaus); bajo la tierra, la cita
//             en columna (Jost) y el autor en la columna estrecha de al lado.
//
//  Lo común de la tanda B (temas, validación, ajuste) está en
//  _comun-b.typ. Procedencia: v1, carteles/_epigrafes-b.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-b.typ": *

// ════════════════════════════════════════════════════════════
//  2 · bauhaus
// ════════════════════════════════════════════════════════════
// La construcción de carteles.bauhaus, en pequeño: un cuadrado rojo apoyado
// en la tierra, el círculo amarillo con centro en su esquina de arriba a la
// derecha (tangente a la misma tierra), una barra negra que nace en el
// margen y pasa por ese centro, y la cuña azul entre la tierra y la barra.
// La tierra es un filete a todo el ancho útil. Debajo, dos columnas: la
// cita (Jost 500) en la ancha y el autor en la estrecha, tras un cuadradito
// rojo. La tierra baja lo que la cita deje (entre el 50 y el 28 % del alto).
#let _formas-bauhaus(c, ancho, gt, m, u, k) = {
  let min-incl = 22deg
  let L = calc.min(0.34 * u, (gt - 0.7 * m) / 2)
  let sx-incl = m + L / calc.tan(min-incl) - L
  let sx-sangra = ancho - 1.8 * L
  let sx = if sx-incl >= sx-sangra { sx-sangra } else { calc.min(sx-incl, ancho - m - 2 * L) }
  let sx = calc.max(ancho * 0.30, sx)
  let (cx, cy) = (sx + L, gt - L)
  let g = 0.042 * u
  let gv = g / calc.cos(calc.atan2((cx - m) / 1pt, L / 1pt))
  let tg = (L - gv / 2) / (cx - m)
  let y-en(x) = gt - (x - m) * tg
  let xf = ancho + 2 * g
  place(top + left, dx: cx - L, dy: cy - L, circle(radius: L, fill: c.amarillo))
  place(top + left, dx: sx, dy: cy, rect(width: L, height: L, fill: c.acento))
  let x1 = sx - 0.14 * L
  place(top + left, polygon(fill: c.azul, (m, gt), (x1, gt), (x1, y-en(x1))))
  place(top + left, polygon(fill: c.tinta, (m, gt), (xf, y-en(xf)), (xf, y-en(xf) - gv), (m, gt - gv)))
  // la tierra
  place(top + left, dx: m, dy: gt, rect(width: ancho - 2 * m, height: 5pt * k, fill: c.tinta))
}

#let _bauhaus(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «bauhaus»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "bauhaus")
  let m = 72pt * k
  let u = calc.min(ancho, alto)
  let gut = 44pt * k
  let lateral = autor != none or obra != none
  let colw = if lateral { (ancho - 2 * m - gut) * 0.68 } else { ancho - 2 * m }
  let latw = ancho - 2 * m - gut - colw
  let gap = 64pt * k // de la tierra al texto
  let estilo = (font: "Jost", weight: 500, tracking: -0.01em, fill: c.tinta)
  let comodo = 52pt * km

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    let pie = if marca != none { measure(marca).height + 32pt * k } else { 0pt }
    let fracs = (0.50, 0.46, 0.42, 0.38, 0.34, 0.31, 0.28)
    let opcion(f) = {
      let gt = alto * f
      let (y, h) = (gt + gap, alto - m - pie - gt - gap)
      (gt: gt, y: y, h: h, s: _cuerpo(cita, estilo, 0.30, colw, h, 76pt * km, minimo))
    }
    let ops = fracs.map(opcion)
    let o = ops.find(o => o.s != none and o.s >= comodo)
    if o == none { o = ops.find(o => o.s != none) }
    if o == none { _no-cabe(quien, minimo) }

    _formas-bauhaus(c, ancho, o.gt, m, u, k)
    place(top + left, dx: m, dy: o.y, _bloque(cita, estilo, 0.30, colw, o.s))

    if lateral {
      let x = m + colw + gut
      let lat = block(width: latw, {
        set text(font: "Jost", fill: c.tinta, lang: "es", hyphenate: false)
        set par(leading: 0.4em, justify: false)
        rect(width: 22pt * k, height: 22pt * k, fill: c.acento)
        v(18pt * k)
        if autor != none { text(size: 30pt * km, weight: 700, tracking: 0.06em, upper(autor)) }
        if autor != none and obra != none { v(10pt * k) }
        if obra != none { text(size: 30pt * km, weight: 400, fill: c.suave, obra) }
      })
      // el rótulo arranca a la altura de la primera línea de la cita
      place(top + left, dx: x, dy: o.y + 0.12 * o.s, lat)
      if measure(lat).height > o.h { panic(quien + ": el autor y la obra no caben en su columna") }
      if guias { _guia(x, o.y, latw, o.h, color: blue) }
    }
    if marca != none { place(bottom + left, dx: m, dy: -m, marca) }
    if guias { _guia(m, o.y, colw, o.h) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = _bauhaus
