// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/aura.typ — variant: "aura"
//
//    aura      niebla de luz oscura (halos violeta, azul y ámbar), la
//              cita en Cormorant cursiva clara, el autor discreto
//
//  Lo común de la tanda C (temas, validación, ajuste) está en
//  _comun-c.typ. Procedencia: v1, carteles/_epigrafes-c.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-c.typ": *

// ═════════════════════════════════════════════════════════════
//  aura
// ═════════════════════════════════════════════════════════════
#let aura(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "aura")
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "Cormorant Garamond"

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: fuente, fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── la niebla: tres halos y un viñeteado ──
    let L = calc.max(W, H)
    _halo(W * 0.18, H * 0.16, L * 0.62, L * 0.52, c.hondo, 85%)
    _halo(W * 0.88, H * 0.86, L * 0.66, L * 0.56, c.bruma, 80%)
    _halo(W * 0.62, H * 0.56, L * 0.34, L * 0.26, c.acento, 16%)
    superbg.bg-vignette(color: c.fondo, intensidad: 70%, size: formato)

    // ── la cita, el filete y el pie ──
    let ancho = W - 2 * 150pt * k
    let alto-max = H - 2 * 230pt * k - 200pt * k
    let mn = _minimo(W)
    place(center + horizon, dy: -24pt * k, context {
      let t(s) = text(size: s, style: "italic", weight: 500, par(leading: 0.48em, cita))
      let r = _encajar(t, ancho, 82pt * k, alin: center, alto-max, mn, "epigrafe(estilo: \"aura\")")
      let (s, hacer) = (r.s, _ => r.q)
      let pie-s = calc.max(30pt * k, _minimo(W, px: 28))
      block(width: ancho, align(center, {
        let q = hacer(s)
        if guias { place(_guia(ancho, measure(q).height)) }
        q
        if autor != none or obra != none {
          v(52pt * k)
          line(length: 64pt * k, stroke: 1.2pt * k + c.acento)
          v(34pt * k)
        }
        if autor != none {
          let a(t) = text(size: t, weight: 600, tracking: 0.24em, fill: c.acento, upper(autor))
          a(_al-ancho(a, pie-s, ancho))
        }
        if obra != none {
          v(14pt * k)
          let o(t) = text(size: t, fill: c.suave, obra)
          o(_al-ancho(o, pie-s * 1.15, ancho))
        }
      }))
    })
    if marca != none { place(bottom + center, dy: -70pt * k, marca) }
  })
}

// ═════════════════════════════════════════════════════════════
//  pizarra
// ═════════════════════════════════════════════════════════════

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = aura
