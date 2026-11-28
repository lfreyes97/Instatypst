// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/hojas.typ — variant: "hojas"
//
//    hojas    la flor de cuatro hojas (_hojas-piezas.typ) como firma pequeña
//             junto al autor; la cita, un bloque pesado de sans (Poppins 800)
//             que llena la caja de arriba.
//
//  Lo común de la tanda B (temas, validación, ajuste) está en
//  _comun-b.typ. Procedencia: v1, carteles/_epigrafes-b.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-b.typ": *

// ════════════════════════════════════════════════════════════
//  1 · hojas
// ════════════════════════════════════════════════════════════
// Papel blanco; la cita en Poppins 800, apretada, llena la caja de arriba.
// Abajo a la izquierda, la flor de cuatro hojas (amarillo y azul, el hueco
// del color del papel) y, a su lado, el autor en versalitas y la obra.
#let _hojas(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «hojas»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "hojas")
  let m = 88pt * k
  let lado = 56pt * k // la flor mide 2 lados
  let estilo = (font: "Poppins", weight: 800, tracking: -0.025em, fill: c.tinta)

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    // ── la firma ──
    let firma-texto = {
      set text(font: "Poppins", fill: c.tinta, lang: "es")
      if autor != none { text(size: 36pt * km, weight: 700, tracking: 0.08em, upper(autor)) }
      if autor != none and obra != none { linebreak() }
      if obra != none { text(size: 36pt * km, weight: 400, fill: c.suave, obra) }
    }
    let tw = ancho - 2 * m - 2 * lado - 32pt * k - (if marca != none { 200pt * k } else { 0pt })
    let ft = block(width: tw, par(leading: 0.45em, justify: false, firma-texto))
    let fh = calc.max(2 * lado, measure(ft).height)
    let fy = alto - m - fh
    place(top + left, dx: m, dy: fy + fh - 2 * lado, flor(lado, c.acento, c.hondo, c.fondo))
    if autor != none or obra != none {
      place(top + left, dx: m + 2 * lado + 32pt * k, dy: fy + fh - measure(ft).height, ft)
    }
    if marca != none { place(bottom + right, dx: -m, dy: -m, marca) }

    // ── la cita ──
    let (x, y, w) = (m, m, ancho - 2 * m)
    let h = fy - 72pt * k - y
    let s = _cuerpo(cita, estilo, 0.24, w, h, 170pt * km, minimo)
    if s == none { _no-cabe(quien, minimo) }
    place(top + left, dx: x, dy: y, _bloque(cita, estilo, 0.24, w, s))
    if guias { _guia(x, y, w, h); _guia(m, fy, ancho - 2 * m, fh, color: blue) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = _hojas
