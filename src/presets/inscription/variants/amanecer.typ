// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/amanecer.typ — variant: "amanecer"
//
//    amanecer  banda horizontal de luz cálida sobre azul noche; la cita
//              en el horizonte (Fraunces), contrapunto de `luto`
//
//  Lo común de la tanda C (temas, validación, ajuste) está en
//  _comun-c.typ. Procedencia: v1, carteles/_epigrafes-c.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-c.typ": *

// ═════════════════════════════════════════════════════════════
//  amanecer
// ═════════════════════════════════════════════════════════════
#let amanecer(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "amanecer")
  let hondo = c.at("hondo", default: c.fondo)
  let claro = c.at("claro", default: c.acento.lighten(50%))
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "Fraunces 72pt"
  // La cita va sobre la luz: con un tema de tinta clara (los oscuros del
  // registro), se compone con el color de la noche, el que más contrasta
  // con el borde de la banda.
  let tinta = (c.tinta, c.fondo, hondo).sorted(key: x => -superbg.contraste(x, c.acento)).first()

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, context {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    let ancho = W - 2 * 130pt * k
    let pad = 64pt * k // de la cita al borde de la luz plena
    let fade-min = 150pt * k // degradado mínimo de la luz a la noche
    let pie-h = 190pt * k // sitio del autor, bajo la banda
    let alto-max = H - 2 * (pad + fade-min) - 2 * pie-h
    let mn = _minimo(W)
    let t(s) = text(size: s, weight: 300, par(leading: 0.55em, cita))
    let r = _encajar(t, ancho, 76pt * k, alin: center, alto-max, mn, "epigrafe(estilo: \"amanecer\")")
    let (s, hacer) = (r.s, _ => r.q)
    let q = hacer(s)
    let ht = measure(q).height

    // ── el cielo: noche, luz en el horizonte, noche ──
    let yc = H * 0.47 // el horizonte
    let b0 = yc - ht / 2 - pad
    let b1 = yc + ht / 2 + pad
    let fade-arr = calc.min(360pt * k, b0 - pie-h * 0.2)
    let fade-ab = calc.min(190pt * k, H - b1 - pie-h)
    let pos(y) = calc.clamp(y / H, 0, 1) * 100%
    let malva = color.mix((c.fondo, 55%), (c.acento, 45%), space: oklab)
    let ciruela = color.mix((hondo, 60%), (c.acento, 40%), space: oklab)
    place(rect(width: W, height: H, stroke: none, fill: gradient.linear(angle: 90deg, space: oklab,
      (c.fondo, 0%),
      (c.fondo, pos(b0 - fade-arr)),
      (malva, pos(b0 - fade-arr * 0.42)),
      (c.acento, pos(b0)),
      (claro, pos(yc)),
      (c.acento.darken(4%), pos(b1)),
      (ciruela, pos(b1 + fade-ab * 0.4)),
      (hondo, pos(b1 + fade-ab)),
      (hondo, 100%),
    )))
    // La línea del horizonte: un hilo de luz a todo el ancho, bajo la cita.
    place(top + left, dy: b1 + 1pt, rect(width: W, height: 1.4pt * k, fill: claro.transparentize(35%)))

    place(top + center, dy: yc - ht / 2, {
      if guias { place(_guia(ancho, ht)) }
      q
    })

    // ── autor y obra, en la noche de abajo ──
    let pie-s = calc.max(28pt * k, _minimo(W, px: 28))
    place(top + center, dy: b1 + fade-ab + 34pt * k, block(width: ancho, align(center, {
      if autor != none {
        let a(t) = text(font: "Jost", size: t, weight: 400, tracking: 0.3em, fill: c.suave, upper(autor))
        a(_al-ancho(a, pie-s, ancho))
      }
      if obra != none {
        v(16pt * k)
        let o(t) = text(size: t, weight: 300, fill: c.suave, obra)
        o(_al-ancho(o, pie-s * 1.2, ancho))
      }
    })))
    if marca != none { place(bottom + center, dy: -70pt * k, marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = amanecer
