// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/lapida.typ — variant: "lapida"
//
//    lapida     inscripción en piedra: mayúsculas romanas espaciadas,
//               letra incisa (sombra y luz), el autor como «fecit»
//
//  Lo común de la tanda A (temas, validación, ajuste) está en
//  _comun-a.typ. Procedencia: v1, carteles/_epigrafes-a.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-a.typ": *

// ═════════════════════════════════════════════════════════════
//  lapida — inscripción grabada en piedra
// ═════════════════════════════════════════════════════════════
// Letra incisa, en un bloque de ancho `ancho`: la luz del bisel debajo,
// corrida abajo a la derecha, y la sombra del surco encima.
#let _incisa(cuerpo, c, k, ancho) = block(width: ancho, {
  place(top + left, dx: 1.3pt * k, dy: 1.7pt * k, block(width: ancho, align(center, text(fill: c.acento.transparentize(30%), cuerpo))))
  align(center, text(fill: c.tinta, cuerpo))
})

#let lapida(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «lápida»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-lapida")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let alto-marca = if marca != none { 50pt * k } else { 0pt }
  let m = 64pt * k // la moldura
  let x0 = m + 72pt * k
  let ancho = W - 2 * x0
  let firma = autor != none or obra != none
  let alto-pie = if firma { 30pt * k + (if autor != none { 76pt * k } else { 0pt }) + (if obra != none { 58pt * k } else { 0pt }) } else { 0pt }
  let y-pie = H - m - 84pt * k - alto-marca
  let y0 = m + 92pt * k
  let y1 = y-pie - alto-pie - 56pt * k

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "Marcellus", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── Piedra: vetas, grano y canto oscurecido ──
    superbg.bg-malla(
      (c.fondo.darken(14%), c.fondo.lighten(14%), c.fondo.darken(9%), c.fondo.lighten(10%), c.fondo.darken(12%)),
      semilla: 23, size: formato,
    )
    place(rect(width: 100%, height: 100%, fill: c.fondo.transparentize(45%)))
    superbg.bg-patron(patron: "ruido", color: c.tinta, opacidad: 34%, size: formato)
    superbg.bg-vignette(color: c.tinta, intensidad: 26%, size: formato)

    // ── Moldura tallada: surcos con sombra y luz ──
    let marco(d, grosor, sombra, luz) = {
      let (w, h) = (W - 2 * (m + d), H - 2 * (m + d))
      place(top + left, dx: m + d + grosor * 0.8, dy: m + d + grosor * 0.8, rect(width: w, height: h, stroke: grosor + luz))
      place(top + left, dx: m + d, dy: m + d, rect(width: w, height: h, stroke: grosor + sombra))
    }
    marco(0pt, 3.2pt * k, c.hondo.darken(30%), c.acento.transparentize(30%))
    marco(18pt * k, 1.4pt * k, c.hondo.darken(20%), c.acento.transparentize(45%))

    // ── La inscripción: mayúsculas romanas espaciadas, centradas ──
    let componer(s) = {
      set text(size: s, tracking: 0.14em)
      set par(leading: 0.8em)
      _incisa(upper(cita), c, k, ancho)
    }
    place(top + left, dx: x0, dy: y0, box(width: ancho, height: y1 - y0, align(horizon, context {
      componer(_cuerpo(quien, componer, 68pt * k, y1 - y0, 36pt * k))
    })))
    _guia(guias, x0, y0, ancho, y1 - y0)

    // ── Firma: filete inciso, AUTOR · FECIT, obra ──
    if firma {
      place(bottom + left, dx: x0, dy: -(H - y-pie), block(width: ancho, {
        set par(leading: 0.6em)
        align(center, box(width: 120pt * k, height: 6pt * k, {
          place(dy: 3.2pt * k, line(length: 120pt * k, stroke: 2pt * k + c.acento.transparentize(30%)))
          place(dy: 1.6pt * k, line(length: 120pt * k, stroke: 2pt * k + c.hondo.darken(30%)))
        }))
        if autor != none {
          block(above: 30pt * k, text(size: 40pt * k, tracking: 0.24em, _incisa([#upper(autor) · FECIT], c, k, ancho)))
        }
        if obra != none {
          block(above: 22pt * k, text(size: 34pt * k, tracking: 0.3em, _incisa(upper(obra), c, k, ancho)))
        }
      }))
      _guia(guias, x0, y-pie - alto-pie, ancho, alto-pie)
    }
    if marca != none { place(bottom + center, dy: -m - 34pt * k, marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = lapida
