// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/luto.typ — variant: "luto"
//
//    luto      negro total, una cruz fina dorada y la cita en blanco
//              (Bodoni Moda): la máxima solemnidad
//
//  Lo común de la tanda C (temas, validación, ajuste) está en
//  _comun-c.typ. Procedencia: v1, carteles/_epigrafes-c.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-c.typ": *

// ═════════════════════════════════════════════════════════════
//  luto
// ═════════════════════════════════════════════════════════════
#let luto(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "luto")
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "Bodoni Moda 28pt"

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: fuente, fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // La cruz: latina, de trazo fino, en oro.
    let (cw, ch, g) = (58pt * k, 132pt * k, 2.6pt * k)
    let cruz = box(width: cw, height: ch, {
      place(top + center, rect(width: g, height: ch, fill: c.acento))
      place(top + center, dy: ch * 0.27, rect(width: cw, height: g, fill: c.acento))
    })

    let ancho = W - 2 * 170pt * k
    let alto-max = H - 2 * 120pt * k - ch - 110pt * k - 190pt * k
    let mn = _minimo(W)
    place(center + horizon, dy: -30pt * k, context {
      let t(s) = text(size: s, tracking: 0.005em, par(leading: 0.72em, cita))
      let r = _encajar(t, ancho, 64pt * k, alin: center, alto-max, mn, "epigrafe(estilo: \"luto\")")
      let (s, hacer) = (r.s, _ => r.q)
      let pie-s = calc.max(30pt * k, _minimo(W, px: 30))
      block(width: ancho, align(center, {
        cruz
        v(96pt * k)
        let q = hacer(s)
        if guias { place(_guia(ancho, measure(q).height)) }
        q
        if autor != none {
          v(84pt * k)
          let a(t) = text(size: t, tracking: 0.32em, fill: c.acento, upper(autor))
          a(_al-ancho(a, pie-s, ancho))
        }
        if obra != none {
          v(18pt * k)
          let o(t) = text(size: t, fill: c.suave, obra)
          o(_al-ancho(o, pie-s * 1.05, ancho))
        }
      }))
    })
    if marca != none { place(bottom + center, dy: -70pt * k, marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = luto
