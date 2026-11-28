// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/portada.typ — variant: "portada"
//
//    portada    portada de libro del XVII: orla de filete doble, cabecera
//               de florones, primera palabra en versalitas rojas, pie de
//               imprenta con autor y obra
//
//  Lo común de la tanda A (temas, validación, ajuste) está en
//  _comun-a.typ. Procedencia: v1, carteles/_epigrafes-a.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-a.typ": *

// ═════════════════════════════════════════════════════════════
//  portada — portada tipográfica de libro del XVII
// ═════════════════════════════════════════════════════════════
#let portada(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «portada»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-portada")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let alto-marca = if marca != none { 50pt * k } else { 0pt }

  let m = 52pt * k // la orla
  let x0 = m + 78pt * k
  let ancho = W - 2 * x0
  let y-cab = m + 56pt * k
  // el pie de imprenta, contado desde abajo: filetes + autor + obra
  let alto-pie = 8pt * k + (if autor != none { 96pt * k } else { 0pt }) + (if obra != none { 66pt * k } else { 0pt })
  let y-pie = H - m - 62pt * k - alto-marca // borde de abajo del pie
  let y0 = y-cab + 110pt * k
  let y1 = y-pie - alto-pie - 60pt * k

  // primera palabra (en versalitas rojas, más grande) y el resto
  let (primera, resto, _) = _dividir(cita, 1)

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "IM FELL Double Pica", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── Orla: filete doble, grueso fuera y fino dentro ──
    place(top + left, dx: m, dy: m, rect(width: W - 2 * m, height: H - 2 * m, stroke: 6pt * k + c.hondo))
    place(top + left, dx: m + 13pt * k, dy: m + 13pt * k,
      rect(width: W - 2 * m - 26pt * k, height: H - 2 * m - 26pt * k, stroke: 1.6pt * k + c.hondo))

    // ── Cabecera de florones entre filetes ──
    place(top + left, dx: x0, dy: y-cab, fl.cabecera(ancho, c.acento, guarda: "palmetas", linea: c.tinta, alto: 34pt * k))

    // ── La cita: primera palabra en mayúsculas rojas; el resto, centrado;
    // debajo, filete — cruz — filete ──
    let componer(s) = block(width: ancho, align(center, {
      block(text(font: "IM FELL French Canon SC", size: s * 1.9, fill: c.acento, tracking: 0.08em, upper(primera)))
      if resto != none {
        block(above: 0.5 * s, text(size: s, par(leading: 0.5em, resto)))
      }
      block(above: 0.9 * s, fl.separador(5.5 * s, c.tinta, vineta: "cruz", alto: 0.5 * s, grosor: 1pt * k))
    }))
    place(top + left, dx: x0, dy: y0, box(width: ancho, height: y1 - y0, align(horizon, context {
      componer(_cuerpo(quien, componer, 66pt * k, y1 - y0, 36pt * k))
    })))
    _guia(guias, x0, y0, ancho, y1 - y0)

    // ── Pie de imprenta: filetes, AUTOR, obra ──
    place(bottom + left, dx: x0, dy: -(H - y-pie), block(width: ancho, align(center, {
      line(length: ancho, stroke: 2.4pt * k + c.tinta)
      v(5pt * k)
      line(length: ancho, stroke: 0.8pt * k + c.tinta)
      if autor != none {
        block(above: 42pt * k, text(font: "IM FELL English SC", size: 46pt * k, tracking: 0.12em, autor))
      }
      if obra != none {
        block(above: 24pt * k, text(font: "IM FELL English", size: 40pt * k, fill: c.acento, _obra(obra)))
      }
    })))
    _guia(guias, x0, y-pie - alto-pie, ancho, alto-pie)
    if marca != none { place(bottom + center, dy: -m - 34pt * k, marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = portada
