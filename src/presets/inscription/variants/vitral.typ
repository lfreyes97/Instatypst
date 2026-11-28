// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/vitral.typ — variant: "vitral"
//
//    vitral    fondo de celosía de fleurones, orla de damasco en oro y
//              filete rojo; la cita en el óvalo central (IM FELL)
//
//  Lo común de la tanda C (temas, validación, ajuste) está en
//  _comun-c.typ. Procedencia: v1, carteles/_epigrafes-c.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-c.typ": *

// ═════════════════════════════════════════════════════════════
//  vitral
// ═════════════════════════════════════════════════════════════
#let vitral(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "vitral")
  let rojo = c.at("rojo", default: c.acento)
  let hondo = c.at("hondo", default: c.fondo.darken(40%))
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "IM FELL Double Pica"

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: fuente, fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── marco: orla de damasco en oro, filete rojo, filete de oro ──
    let m = 30pt * k
    let G = 34pt * k
    place(top + left, dx: m, dy: m, fl.orla("damasco", W - 2 * m, H - 2 * m, c.acento, grosor: G))
    let r1 = m + G + 7pt * k
    place(top + left, dx: r1, dy: r1, rect(width: W - 2 * r1, height: H - 2 * r1, stroke: 9pt * k + rojo))
    let r2 = r1 + 9pt * k
    place(top + left, dx: r2, dy: r2, rect(width: W - 2 * r2, height: H - 2 * r2, stroke: 1.6pt * k + c.acento))

    // ── el campo: celosía de fleurones, como plomo de vidriera ──
    let F = r2 + 6pt * k
    let (fw, fh) = (W - 2 * F, H - 2 * F)
    let malla = color.mix((c.fondo, 62%), (c.acento, 38%), space: oklab)
    place(top + left, dx: F, dy: F, fl.diaper(fl.f1, "C", fw, fh, 56pt * k, malla))

    // ── rosetas en las esquinas del campo ──
    let lado = 92pt * k
    let e = 26pt * k
    for (al, dx, dy) in ((top + left, F + e, F + e), (top + right, -(F + e), F + e),
      (bottom + left, F + e, -(F + e)), (bottom + right, -(F + e), -(F + e))) {
      place(al, dx: dx, dy: dy, box(fill: hondo, inset: 8pt * k, fl.roseta(lado, c.acento, tipo: "medallon")))
    }

    // ── el óvalo ──
    let rx = fw / 2 - 58pt * k
    let ry = fh / 2 - 58pt * k
    let oval(d, ..args) = place(center + horizon, ellipse(width: 2 * (rx + d), height: 2 * (ry + d), ..args))
    oval(16pt * k, fill: hondo, stroke: none)
    oval(11pt * k, stroke: 9pt * k + rojo)
    oval(4pt * k, stroke: 2.4pt * k + c.acento)
    oval(-8pt * k, stroke: 0.9pt * k + c.acento)

    // ── la cita, en el rectángulo inscrito en el óvalo ──
    let ancho = rx * 1.36
    let alto-max = ry * 1.36
    let mn = _minimo(W)
    place(center + horizon, context {
      let pie-s = calc.max(32pt * k, _minimo(W, px: 28))
      let cabeza = fl.vineta("cruz", 40pt * k, c.acento)
      let pie = {
        if autor != none or obra != none {
          v(40pt * k)
          fl.separador(200pt * k, c.acento, vineta: "rosa", alto: 22pt * k, grosor: 1pt * k)
        }
        if autor != none {
          v(28pt * k)
          let a(t) = text(font: "IM FELL Double Pica SC", size: t, tracking: 0.08em, fill: c.acento, autor)
          a(_al-ancho(a, pie-s * 1.1, ancho))
        }
        if obra != none {
          v(12pt * k)
          let o(t) = text(size: t, fill: c.suave, obra)
          o(_al-ancho(o, pie-s, ancho))
        }
      }
      let fijo = measure(block(width: ancho, align(center, cabeza + v(34pt * k) + pie))).height
      let t(s) = text(size: s, par(leading: 0.5em, cita))
      let r = _encajar(t, ancho, 68pt * k, alin: center, alto-max - fijo, mn, "epigrafe(estilo: \"vitral\")")
      let (s, hacer) = (r.s, _ => r.q)
      block(width: ancho, align(center, {
        if guias { place(center + horizon, _guia(ancho, alto-max)) }
        cabeza
        v(34pt * k)
        hacer(s)
        pie
      }))
    })
    if marca != none { place(bottom + center, dy: -(F + 20pt * k), marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = vitral
