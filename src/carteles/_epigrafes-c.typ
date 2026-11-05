// ─────────────────────────────────────────────────────────────
//  carteles/_epigrafes-c.typ — estilos de epígrafe, tanda C: los
//  atmosféricos (cada uno trae su fondo o su ambiente)
//
//    aura      niebla de luz oscura (halos violeta, azul y ámbar), la
//              cita en Cormorant cursiva clara, el autor discreto
//    pizarra   pizarra verde con tiza: Caveat, marco de filetes trazado
//              a mano, polvo de tiza encima de todo
//    vitral    fondo de celosía de fleurones, orla de damasco en oro y
//              filete rojo; la cita en el óvalo central (IM FELL)
//    luto      negro total, una cruz fina dorada y la cita en blanco
//              (Bodoni Moda): la máxima solemnidad
//    amanecer  banda horizontal de luz cálida sobre azul noche; la cita
//              en el horizonte (Fraunces), contrapunto de `luto`
//
//  Todos con la misma firma:
//    (cita, autor: none, obra: none, formato: (1080, 1350), tema: auto,
//     marca: none, guias: false) => página
//  `cita` es contenido (admite `\`); `tema` es auto (el del estilo), un
//  nombre de `temas-lamina` o de `temas-c`, o un diccionario de roles
//  (fondo, tinta, suave, acento, hondo y los propios de cada estilo); lo
//  que falte sale del tema del estilo. La cita se achica hasta caber; si
//  no cabe ni al cuerpo mínimo (34 px por cada 1080 de ancho; 44 en la
//  manuscrita de `pizarra`), error.
//
//  Exporta `estilos-c` (nombre → función) y `temas-c`. Privado de
//  `carteles/`: lo usa el despachador de `carteles.epigrafe`.
// ─────────────────────────────────────────────────────────────

#import "_base.typ": medida, escala, ajustar-alto
#import "_temas.typ": temas-lamina, resolver-tema
#import "../fleurones.typ" as fl
#import "../superbg/lib.typ" as superbg
#import "../superbg/azar.typ": _secuencia

// ── Temas propios de cada estilo ──
#let temas-c = (
  aura: (
    fondo: rgb("#0c0d16"),
    tinta: rgb("#f1ebe0"),
    suave: rgb("#aaa3b6"),
    acento: rgb("#c7a46c"),
    hondo: rgb("#3b2b78"), // el halo violeta
    bruma: rgb("#17505f"), // el halo azul verdoso
  ),
  pizarra: (
    fondo: rgb("#24392f"),
    tinta: rgb("#f2f0e6"), // tiza blanca
    suave: rgb("#c9d3c8"),
    acento: rgb("#eedb8e"), // tiza amarilla
    hondo: rgb("#1a2a22"),
  ),
  vitral: (
    fondo: rgb("#13234c"), // azul profundo
    tinta: rgb("#f3ead2"), // crema
    suave: rgb("#d9c99c"),
    acento: rgb("#c99b3e"), // oro
    hondo: rgb("#0b1532"), // el óvalo
    rojo: rgb("#8c1b22"),
  ),
  luto: (
    fondo: rgb("#000000"),
    tinta: rgb("#f6f4ef"),
    suave: rgb("#8f8a81"),
    acento: rgb("#bf9d5c"), // oro de la cruz
  ),
  amanecer: (
    fondo: rgb("#0a1332"), // noche, arriba
    hondo: rgb("#110b23"), // noche, abajo
    tinta: rgb("#151a36"), // la cita, sobre la luz
    suave: rgb("#eadcc1"), // autor y obra, sobre la noche
    acento: rgb("#f0a462"), // borde cálido de la banda
    claro: rgb("#fbe7c4"), // el centro de la luz
  ),
)

#let _tema(tema, estilo) = {
  let base = temas-c.at(estilo)
  if tema == auto { return base }
  base + resolver-tema(tema, registro: temas-lamina + temas-c)
}

// Cuerpo mínimo legible: `px` por cada 1080 de ancho.
#let _minimo(W, px: 34) = px * 1pt * (W / 1080pt)

// La cita compuesta en una caja de `ancho`: `t(s)` es el texto a cuerpo `s`
// (sin caja). Devuelve (s:, q:) con el mayor cuerpo ≤ desde con el que cabe
// en `alto`; error si no cabe ni a `minimo`. Las líneas que el autor cortó a
// mano con `\` se respetan si caben enteras achicando poco (hasta un 25 %);
// si no, los cortes se vuelven espacios y la cita corre seguida, para no
// dejar una palabra sola en la línea de abajo. Usar dentro de `context`.
#let _encajar(t, ancho, desde, alto, minimo, quien, alin: center) = {
  let caja(s, seguida) = block(width: ancho, align(alin, {
    show linebreak: it => if seguida [ ] else { it }
    t(s)
  }))
  let ajustar(seguida) = {
    let hacer(s) = caja(s, seguida)
    let s = calc.max(minimo, ajustar-alto(hacer, desde, alto, minimo: minimo, paso: 1pt))
    if measure(hacer(s)).height > alto + 0.5pt {
      panic(quien + ": la cita no cabe ni con el cuerpo mínimo (" + repr(calc.round(minimo / 1pt)) + " pt) — acórtala o usa un formato más alto")
    }
    s
  }
  let s = ajustar(false)
  let w = measure(t(s)).width
  if w <= ancho { return (s: s, q: caja(s, false)) }
  let s2 = s * (ancho / w) * 0.995
  if s2 >= 0.75 * s and s2 >= minimo { return (s: s2, q: caja(s2, false)) }
  let s3 = ajustar(true)
  (s: s3, q: caja(s3, true))
}

// Tamaño ≤ s con el que `hacer(t)` no pasa de `ancho` (autor, obra).
#let _al-ancho(hacer, s, ancho) = {
  let w = measure(hacer(s)).width
  if w > ancho { s * ancho / w } else { s }
}

// Caja de guía (depurar).
#let _guia(w, h) = rect(width: w, height: h, stroke: (paint: rgb("#ff2bd6"), thickness: 1pt, dash: "dashed"))

// Halo: elipse con degradado radial de `col` (a `op`) a transparente.
#let _halo(x, y, rx, ry, col, op) = place(top + left, dx: x - rx, dy: y - ry, ellipse(
  width: 2 * rx, height: 2 * ry, stroke: none,
  fill: gradient.radial(
    (col.transparentize(100% - op), 0%),
    (col.transparentize(100% - op * 0.55), 35%),
    (col.transparentize(100%), 100%),
  ),
))

// ═════════════════════════════════════════════════════════════
//  aura
// ═════════════════════════════════════════════════════════════
#let aura(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "aura")
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "Cormorant Garamond"

  page(width: W, height: H, margin: 0pt, fill: c.fondo, {
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

  page(width: W, height: H, margin: 0pt, fill: c.fondo, {
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

  page(width: W, height: H, margin: 0pt, fill: c.fondo, {
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

// ═════════════════════════════════════════════════════════════
//  luto
// ═════════════════════════════════════════════════════════════
#let luto(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let c = _tema(tema, "luto")
  let (W, H) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let fuente = "Bodoni Moda 28pt"

  page(width: W, height: H, margin: 0pt, fill: c.fondo, {
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

  page(width: W, height: H, margin: 0pt, fill: c.fondo, context {
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

// ── el registro ──
#let estilos-c = (
  aura: aura,
  pizarra: pizarra,
  vitral: vitral,
  luto: luto,
  amanecer: amanecer,
)
