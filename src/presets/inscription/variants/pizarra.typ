// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/pizarra.typ — variant: "pizarra"
//
//    pizarra   pizarra verde con tiza: Caveat, marco de filetes trazado
//              a mano, polvo de tiza encima de todo
//
//  Lo común de la tanda C (temas, validación, ajuste) está en
//  _comun-c.typ. Procedencia: v1, carteles/_epigrafes-c.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-c.typ": *

// Trazo de tiza de p0 a p1 (en pt): varias pasadas finas que tiemblan
// (una onda suave de amplitud y fase al azar) y se pasan un poco de largo.
#let _tiza(p0, p1, grosor, color, semilla, pasadas: 3, temblor: 2.2pt) = {
  let r = _secuencia(pasadas * 5, semilla)
  let (x0, y0) = p0
  let (x1, y1) = p1
  let dx = x1 - x0
  let dy = y1 - y0
  let largo = calc.sqrt((dx / 1pt) * (dx / 1pt) + (dy / 1pt) * (dy / 1pt)) * 1pt
  let (ux, uy) = (dx / largo, dy / largo) // dirección
  let (nx, ny) = (-uy, ux) // normal
  for i in range(pasadas) {
    let (a, f, ph, sobra, op) = r.slice(i * 5, i * 5 + 5)
    let amp = temblor * (0.4 + a)
    let ciclos = 0.6 + 1.4 * f
    let ext0 = (sobra - 0.5) * 10pt
    let ext1 = (r.at(calc.rem(i * 5 + 7, r.len())) - 0.5) * 10pt
    let n = 24
    let pts = range(n + 1).map(j => {
      let t = j / n
      let d = -ext0 + t * (largo + ext0 + ext1)
      let o = amp * calc.sin(2 * calc.pi * (ciclos * t + ph)) + (i - (pasadas - 1) / 2) * grosor * 0.45
      (x0 + ux * d + nx * o, y0 + uy * d + ny * o)
    })
    place(top + left, curve(
      stroke: (paint: color.transparentize(30% + 40% * op), thickness: grosor * (0.55 + 0.5 * a), cap: "round", join: "round"),
      curve.move(pts.at(0)),
      ..pts.slice(1).map(p => curve.line(p)),
    ))
  }
}

// Rectángulo de tiza: cuatro trazos que se cruzan en las esquinas.
#let _marco-tiza(x, y, w, h, grosor, color, semilla) = {
  _tiza((x, y), (x + w, y), grosor, color, semilla)
  _tiza((x + w, y), (x + w, y + h), grosor, color, semilla + 11)
  _tiza((x + w, y + h), (x, y + h), grosor, color, semilla + 23)
  _tiza((x, y + h), (x, y), grosor, color, semilla + 37)
}

#let pizarra(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "pizarra")
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "Caveat"
  let tiza = c.tinta.transparentize(8%)

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: fuente, fill: tiza, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── la pizarra: borrones de tiza mal borrada y bordes en sombra ──
    let L = calc.max(W, H)
    _halo(W * 0.30, H * 0.30, L * 0.42, L * 0.16, c.tinta, 7%)
    _halo(W * 0.74, H * 0.62, L * 0.46, L * 0.14, c.tinta, 6%)
    _halo(W * 0.40, H * 0.86, L * 0.36, L * 0.10, c.tinta, 5%)
    superbg.bg-vignette(color: c.hondo, intensidad: 80%, size: formato)

    // ── marco de filetes, a tiza ──
    let m = 54pt * k
    _marco-tiza(m, m, W - 2 * m, H - 2 * m, 4pt * k, c.tinta, 3)
    let m2 = m + 16pt * k
    _marco-tiza(m2, m2, W - 2 * m2, H - 2 * m2, 2.4pt * k, c.tinta, 41)

    // ── la cita, a la izquierda; el autor, subrayado, a la derecha ──
    let ancho = W - 2 * 128pt * k
    let alto-max = H - 2 * 200pt * k - 230pt * k
    let mn = _minimo(W, px: 44)
    place(center + horizon, dy: -20pt * k, context {
      let t(s) = text(size: s, weight: 500, par(leading: 0.42em, cita))
      let r = _encajar(t, ancho, 100pt * k, alin: left, alto-max, mn, "epigrafe(estilo: \"pizarra\")")
      let (s, hacer) = (r.s, _ => r.q)
      let pie-s = calc.max(52pt * k, _minimo(W, px: 44))
      block(width: ancho, align(left, {
        let q = hacer(s)
        if guias { place(_guia(ancho, measure(q).height)) }
        q
        if autor != none {
          v(56pt * k)
          let a(t) = text(size: t, weight: 600, [— ] + autor)
          let t = _al-ancho(a, pie-s, ancho)
          let w = measure(a(t)).width
          align(right, box({
            a(t)
            place(bottom + left, dy: 10pt * k, _tiza((0pt, 0pt), (w, -3pt * k), 3pt * k, c.tinta, 59, pasadas: 2))
          }))
        }
        if obra != none {
          v(if autor != none { 30pt * k } else { 50pt * k })
          let o(t) = text(size: t, fill: c.acento, obra)
          align(right, o(_al-ancho(o, pie-s * 0.92, ancho)))
        }
      }))
    })
    if marca != none { place(bottom + center, dy: -96pt * k, marca) }

    // ── polvo de tiza encima de todo: rompe el trazo de las letras ──
    superbg.bg-patron(patron: "ruido", color: c.hondo, opacidad: 45%, size: formato)
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = pizarra
