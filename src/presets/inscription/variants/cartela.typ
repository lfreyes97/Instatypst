// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/cartela.typ — variant: "cartela"
//
//    cartela    cartela de museo: pared blanca, bloque pequeño de sans
//               fina abajo a la izquierda, mucho aire
//
//  Lo común de la tanda A (temas, validación, ajuste) está en
//  _comun-a.typ. Procedencia: v1, carteles/_epigrafes-a.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-a.typ": *

// ═════════════════════════════════════════════════════════════
//  cartela — cartela de museo
// ═════════════════════════════════════════════════════════════
#let cartela(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «cartela»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-cartela")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let fx = formato.at(0) / 1080

  let x0 = 100pt * fx
  let ancho = calc.min(600pt * fx, W - 2 * x0)
  let y-bajo = H - 112pt * k
  let alto-max = H * 0.58

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "Hanken Grotesk", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    let bloque(s) = block(width: ancho, {
      if autor != none { block(text(size: 36pt * k, weight: 600, autor)) }
      if obra != none { block(above: 14pt * k, text(size: 34pt * k, weight: 300, fill: c.suave, _obra(obra))) }
      if autor != none or obra != none {
        block(above: 36pt * k, below: 36pt * k, line(length: 64pt * k, stroke: 1.5pt * k + c.acento))
      }
      block(text(size: s, weight: 300, par(leading: 0.6em, [«#cita»])))
    })
    place(bottom + left, dx: x0, dy: -(H - y-bajo), context {
      bloque(_cuerpo(quien, bloque, 40pt * k, alto-max, 34pt * k))
    })
    _guia(guias, x0, y-bajo - alto-max, ancho, alto-max)
    if marca != none { place(bottom + right, dx: -x0, dy: -(H - y-bajo), marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = cartela
