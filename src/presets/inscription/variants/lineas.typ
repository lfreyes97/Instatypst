// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/lineas.typ — variant: "lineas"
//
//    lineas   fondo liso, un solo filete grueso que sangra por la izquierda y
//             la cita en un cuerpo enorme de Bodoni, apoyada abajo.
//
//  Lo común de la tanda B (temas, validación, ajuste) está en
//  _comun-b.typ. Procedencia: v1, carteles/_epigrafes-b.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-b.typ": *

// ════════════════════════════════════════════════════════════
//  5 · lineas
// ════════════════════════════════════════════════════════════
// Nada más que un filete grueso arriba, sangrando por la izquierda, y la
// cita en Bodoni de cuerpo enorme apoyada sobre el autor, abajo. Un color y
// el fondo.
#let _lineas(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «lineas»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "epi-lineas")
  // el estilo es el cuerpo enorme: no baja tanto como los otros
  let minimo = calc.max(minimo, 52pt * km)
  let m = 84pt * k
  let estilo = (font: "Bodoni Moda 72pt", weight: 400, tracking: -0.015em, fill: c.tinta)

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    let grueso = 20pt * k
    place(top + left, dy: m, rect(width: m + 0.26 * ancho, height: grueso, fill: c.acento))

    let firma = if autor == none and obra == none { none } else {
      let partes = ()
      if autor != none { partes.push(autor) }
      if obra != none { partes.push(obra) }
      block(width: ancho - 2 * m - (if marca != none { 220pt * k } else { 0pt }),
        text(font: "Bodoni Moda 28pt", size: 40pt * km, fill: c.suave, lang: "es", hyphenate: false,
          par(leading: 0.45em, justify: false, partes.join([, ]))))
    }
    let fh = if firma == none { 0pt } else { measure(firma).height }
    let sep = if firma == none { 0pt } else { 64pt * k }
    let (y0, y1) = (m + grueso + 96pt * k, alto - m - fh - sep)
    let w = ancho - 2 * m
    let s = _cuerpo(cita, estilo, 0.16, w, y1 - y0, 200pt * km, minimo)
    if s == none { _no-cabe(quien, minimo) }
    let b = _bloque(cita, estilo, 0.16, w, s)
    place(top + left, dx: m, dy: y1 - measure(b).height, b)
    if firma != none { place(top + left, dx: m, dy: alto - m - fh, firma) }
    if marca != none { place(bottom + right, dx: -m, dy: -m, marca) }
    if guias { _guia(m, y0, w, y1 - y0) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = _lineas
