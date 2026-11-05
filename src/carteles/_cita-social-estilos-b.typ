// ─────────────────────────────────────────────────────────────
//  carteles/_cita-social-estilos-b.typ — estilos de `cita-social`, tanda B:
//  los de materia (papel, tiza, periódico) y el de luz
//
//    papel     hoja crema con grano suave sobre cartón kraft, sujeta con
//              cinta; tinta sepia (Literata) y la firma manuscrita (Caveat)
//    pizarra   encerado verde con marco de madera, repisa y tiza; la cita
//              en Caveat, el resaltado en tiza amarilla subrayada
//    recorte   recorte de periódico de bordes rasgados: fecha entre
//              filetes, antetítulo, cita justificada y firma «Por …»
//    aura      noche con halos vivos (violeta, rosa, cian) y una tarjeta
//              de cristal; letra redonda blanca, resaltado ámbar
//
//  Qué muestra cada uno (✓) de los campos de contenido:
//              foto/inic. usuario fecha verif. contexto métricas respuesta
//    papel         ✓        ✓      ✓     —       ✓        —         —
//    pizarra       —        ✓      ✓     ✓ (✓ de tiza) ✓   —         —
//    recorte       foto     ✓      ✓     —       ✓        —         —
//    aura          ✓        ✓      ✓     ✓       ✓        ✓         —
//  (recorte muestra la foto como retrato cuadrado; sin foto no pone las
//  iniciales: un periódico no las usa). Lo demás se ignora sin error.
//
//  `atribucion`: papel, recorte y aura, las tres; pizarra, arriba/abajo
//  («lado» = «abajo»). `variante`: las tres en todos (en pizarra,
//  «tarjeta» es el encerado con marco; «sangre», el encerado a todo el
//  área sin marco; «abierta», la tiza sobre la pared). `comilla`: papel y
//  aura.
//
//  Cada estilo es una función (d) => página. Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────
#import "_cita-social-comun.typ": *
#import "../superbg/azar.typ": _secuencia

// ═════════════════════════════════════════════════════════════
//  papel
// ═════════════════════════════════════════════════════════════
#let papel(d) = {
  let c0 = tema-de(d, "cita-papel")
  let c = if d.variante == "abierta" { colores-abierta(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Literata", "Libertinus Serif"))
  let M = ("DM Mono", "DejaVu Sans Mono")
  let (desde, hasta) = cuerpos(d, g, 84, 22)
  let meta = meta-de(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta)
    set par(leading: 0.55em, spacing: 0.8em)
    // un lavado de acuarela sepia
    set highlight(fill: c0.acento.transparentize(80%), extent: 0.08em, top-edge: "cap-height", bottom-edge: -0.12em)
    let av = calc.max(L(60), calc.min(1.1 * s, L(108)))
    let tn = calc.max(L(30), 0.82 * s)
    let tm = calc.max(L(18), 0.3 * s)
    let cita-b = {
      if d.comilla {
        comilla-grande(s, c.acento)
      }
      text(size: s, d.cita)
    }
    let nombre-b = pila(0.34 * tn, text(font: "Caveat", size: tn, weight: 600, d.nombre),
      if meta != none { text(font: M, size: tm, fill: c.suave, meta) })
    let cara = avatar(d.foto, d.iniciales, av, c0.acento, anillo: L(2.5) + c.tinta)
    if d.contexto != none {
      block(below: L(30), text(font: M, size: tm, tracking: 0.08em, fill: c.suave, upper(d.contexto)))
    }
    disponer(d.atribucion, cita-b,
      grid(columns: (av, 1fr), column-gutter: L(22), align: left + horizon, cara, nombre-b),
      cara, av + L(28), L(40),
      filete: { v(L(34)); line(length: 100%, stroke: (paint: c.linea, thickness: L(2), dash: (L(6), L(8)))); v(L(26)) },
      firma-lado: nombre-b)
  }
  let hoja(w, h, sangre) = box(width: w, height: h, {
    if not sangre {
      place(dx: L(4), dy: L(10), rect(width: w, height: h, fill: black.transparentize(84%), stroke: none))
      place(dx: L(10), dy: L(22), rect(width: w, height: h, fill: black.transparentize(92%), stroke: none))
    }
    place(rect(width: w, height: h, fill: c.tarjeta, stroke: none))
    place(rect(width: w, height: h, fill: grano(L(96), c.grano, n: 70, radio: L(1.3)), stroke: none))
    if not sangre {
      // la cinta: un trozo translúcido, apenas torcido, sobre el borde de arriba
      place(top + center, dy: -L(30), rotate(-3.5deg,
        rect(width: L(230), height: L(60), fill: c.cinta.transparentize(30%), stroke: L(1) + c.cinta.darken(10%))))
    }
  })
  lamina(d, c, "papel", contenido, desde, hasta, insets: (72, 110), fuente: F, tarjeta: hoja)
}

// ═════════════════════════════════════════════════════════════
//  pizarra
// ═════════════════════════════════════════════════════════════
#let pizarra(d) = {
  let c0 = tema-de(d, "cita-pizarra")
  let abierta = d.variante == "abierta"
  // abierta: la tiza va sobre la pared; si la pared es clara, tinta oscura
  let c = if abierta { colores-abierta(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Caveat",))
  let (desde, hasta) = cuerpos(d, g, 116, 30)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta, weight: 500)
    set par(leading: 0.42em, spacing: 0.7em)
    show highlight: it => underline(stroke: (paint: c0.acento.transparentize(15%), thickness: 0.07em, cap: "round"),
      offset: 0.14em, evade: false, text(fill: c0.acento, it.body))
    let tn = calc.max(L(30), 0.6 * s)
    let cabeza = if d.contexto != none or d.fecha != none {
      block(below: L(40), grid(columns: (1fr, auto), column-gutter: L(24), align: (left + bottom, right + bottom),
        if d.contexto != none {
          underline(stroke: L(2.5) + c.suave, offset: 0.16em, text(size: 0.9 * tn, fill: c.suave, d.contexto))
        },
        if d.fecha != none { text(size: 0.8 * tn, fill: c.suave, d.fecha) }))
    }
    let linea-firma = {
      text(size: tn, fill: c.suave, [— #d.nombre])
      if d.verificado {
        h(0.3 * tn)
        box(width: 0.8 * tn, height: 0.7 * tn, curve(stroke: (paint: c0.acento, thickness: 0.09 * tn, cap: "round", join: "round"),
          curve.move((0pt, 0.4 * tn)), curve.line((0.28 * tn, 0.68 * tn)), curve.line((0.8 * tn, 0pt))))
      }
    }
    let firma(al) = pila(0.3 * tn, align(al, linea-firma),
      if d.usuario != none { align(al, text(size: 0.8 * tn, fill: c.suave, d.usuario)) })
    cabeza
    if d.atribucion == "arriba" { firma(left); v(L(36)); text(size: s, d.cita) } else {
      text(size: s, d.cita); v(L(40)); align(right, firma(right))
    }
  }
  let marco = L(26)
  let encerado(w, h, sangre) = box(width: w, height: h, clip: true, {
    place(rect(width: w, height: h, fill: c0.tarjeta, stroke: none))
    // borrones de tiza mal borrada (degradados vectoriales, sin rasterizar)
    for (fx, fy, fr, op) in ((0.22, 0.3, 0.42, 7%), (0.78, 0.68, 0.5, 6%), (0.55, 0.12, 0.3, 5%)) {
      let r = fr * calc.max(w, h)
      place(dx: fx * w - r, dy: fy * h - r * 0.6, ellipse(width: 2 * r, height: 1.2 * r, stroke: none,
        fill: gradient.radial((c0.tinta.transparentize(100% - op), 0%), (c0.tinta.transparentize(100%), 100%))))
    }
    if not sangre {
      place(rect(width: w, height: h, fill: none, radius: L(8), stroke: marco + c0.marco))
      place(rect(width: w, height: h, fill: none, radius: L(8), stroke: L(2) + c0.marco.darken(30%)))
      place(dx: marco, dy: marco, rect(width: w - 2 * marco, height: h - 2 * marco, fill: none,
        stroke: L(3) + black.transparentize(70%)))
      // la repisa con dos tizas
      place(bottom + left, dy: 0pt, rect(width: w, height: L(20), fill: c0.marco.darken(18%), stroke: none))
      place(bottom + left, dx: w * 0.62, dy: -L(20), rect(width: L(64), height: L(14), radius: L(5), fill: c0.tinta, stroke: none))
      place(bottom + left, dx: w * 0.62 + L(84), dy: -L(20), rect(width: L(46), height: L(14), radius: L(5), fill: c0.acento, stroke: none))
    }
  })
  lamina(d, c, "pizarra", contenido, desde, hasta, insets: (96, 96), fuente: F, tarjeta: encerado)
}

// ═════════════════════════════════════════════════════════════
//  recorte
// ═════════════════════════════════════════════════════════════
// El papel rasgado: lados rectos (tijera) y bordes de arriba y abajo en
// dientes irregulares de amplitud `a`.
#let _rasgado(w, h, a, paso, relleno, semilla) = {
  let n = calc.max(2, int(calc.ceil(w / paso)))
  let r = _secuencia(2 * n + 2, semilla)
  let arriba = range(n + 1).map(i => (w * i / n, a * r.at(i)))
  let abajo = range(n + 1).map(i => (w * (n - i) / n, h - a * r.at(n + 1 + i)))
  curve(fill: relleno, stroke: none,
    curve.move(arriba.at(0)), ..arriba.slice(1).map(p => curve.line(p)),
    ..abajo.map(p => curve.line(p)), curve.close())
}

#let recorte(d) = {
  let c0 = tema-de(d, "cita-recorte")
  let c = if d.variante == "abierta" { colores-abierta(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Libre Baskerville", "Libertinus Serif"))
  let S = ("Inter", "Liberation Sans")
  let (desde, hasta) = cuerpos(d, g, 76, 22)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta, hyphenate: true)
    set par(leading: 0.5em, spacing: 0.75em, justify: true)
    show highlight: it => text(weight: 700, it.body)
    let tn = calc.max(L(18), 0.36 * s)
    let fecha = if d.fecha != none {
      block(below: L(30), {
        line(length: 100%, stroke: L(1.5) + c.linea)
        v(L(10), weak: false)
        align(center, text(font: S, size: tn, weight: 600, tracking: 0.14em, upper(d.fecha)))
        v(L(10), weak: false)
        line(length: 100%, stroke: L(1.5) + c.linea)
      })
    }
    let ante = if d.contexto != none {
      block(below: L(18), text(font: "Bebas Neue", size: calc.max(L(30), 0.62 * s), tracking: 0.03em, fill: if d.variante == "abierta" { readable-on(c.fondo, c0.acento, c0.acento.lighten(45%)) } else { c0.acento }, d.contexto))
    }
    let foto = if d.foto != none {
      let lado = calc.max(L(80), calc.min(1.6 * s, L(150)))
      box(width: lado, height: lado, stroke: L(3) + c.tinta, clip: true,
        image(d.foto, width: lado, height: lado, fit: "cover"))
    }
    let firma-t = pila(0.35 * tn, {
      set par(justify: false, leading: 0.5em)
      text(font: S, size: tn, fill: c.suave, [Por ])
      text(font: S, size: tn, weight: 800, tracking: 0.06em, upper(d.nombre))
    }, if d.usuario != none { text(font: S, size: 0.92 * tn, fill: c.suave, d.usuario) })
    let firma = if foto == none { firma-t } else {
      grid(columns: (auto, 1fr), column-gutter: L(22), align: left + horizon, foto, firma-t)
    }
    fecha
    ante
    // justificada solo si la cita da para muchas líneas (unas seis): corta,
    // los blancos se abren y parte palabras
    let cuerpo-t = layout(t => {
      let largo = measure(text(size: s, d.cita)).width > 6 * t.width
      set par(justify: largo)
      set text(hyphenate: largo)
      text(size: s, d.cita)
    })
    disponer(d.atribucion, cuerpo-t, firma, foto,
      if foto != none { measure(foto).width + L(30) } else { 0pt }, L(30),
      filete: { v(L(28)); line(length: L(120), stroke: L(2) + c.linea); v(L(22)) },
      firma-lado: firma-t)
  }
  let papel-r(w, h, sangre) = if sangre { block(width: w, height: h, fill: c.tarjeta) } else {
    box(width: w, height: h, {
      place(dx: L(8), dy: L(14), _rasgado(w, h, L(14), L(18), black.transparentize(70%), 5))
      place(_rasgado(w, h, L(14), L(18), c.tarjeta, 5))
      place(rect(width: w, height: h, stroke: none, fill: grano(L(80), c.tinta, n: 40, radio: L(0.9), semilla: 13)))
    })
  }
  lamina(d, c, "recorte", contenido, desde, hasta, insets: (64, 96), fuente: S, tarjeta: papel-r)
}

// ═════════════════════════════════════════════════════════════
//  aura
// ═════════════════════════════════════════════════════════════
#let aura(d) = {
  let c0 = tema-de(d, "cita-aura")
  let c = if d.variante == "abierta" { colores-abierta(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Outfit", "Inter"))
  let (desde, hasta) = cuerpos(d, g, 92, 24)
  let meta = meta-de(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta, weight: 500)
    set par(leading: 0.5em, spacing: 0.8em)
    show highlight: it => text(fill: c0.claro, weight: 700, it.body)
    let av = calc.max(L(64), calc.min(1.15 * s, L(112)))
    let tn = calc.max(L(24), 0.44 * s)
    let cita-b = {
      if d.comilla {
        comilla-grande(s, c0.claro)
      }
      text(size: s, d.cita)
    }
    let cara = avatar(d.foto, d.iniciales, av, c0.hondo,
      anillo: (paint: gradient.linear(c0.acento, c0.claro), thickness: L(5)))
    let ps = pares-metricas(d.metricas, 0.9 * tn, c.suave)
    let nombre-b = pila(0.3 * tn, {
      text(size: tn, weight: 700, d.nombre)
      if d.verificado { h(0.25 * tn); insignia(0.86 * tn, c0.acento) }
    }, if meta != none { text(size: 0.86 * tn, fill: c.suave, meta) },
      if ps.len() > 0 { text(size: 0.8 * tn, fill: c.suave, ps.join(h(0.9 * tn))) })
    if d.contexto != none {
      block(below: L(34), box(fill: c0.tarjeta.transparentize(84%), radius: 100%, inset: (x: L(22), y: L(10)),
        text(size: 0.74 * tn, weight: 600, fill: c.suave, d.contexto)))
    }
    disponer(d.atribucion, cita-b,
      grid(columns: (av, 1fr), column-gutter: L(22), align: left + horizon, cara, nombre-b),
      cara, av + L(30), L(48), firma-lado: nombre-b)
  }
  // los halos: elipses con degradado radial a transparente, recortadas al área
  let halos(g) = place(top + left, dx: g.ax, dy: g.ay, box(width: g.aw, height: g.ah, clip: true, {
    let (w, h) = (g.aw, g.ah)
    let m = calc.max(w, h)
    for (fx, fy, fr, col, op) in (
      (0.15, 0.12, 0.75, c0.hondo, 0%), (0.95, 0.9, 0.7, c0.acento, 10%),
      (0.92, 0.08, 0.5, c0.bruma, 15%), (0.05, 0.95, 0.42, c0.claro, 35%),
    ) {
      let r = fr * m
      place(dx: fx * w - r, dy: fy * h - r, circle(radius: r, stroke: none,
        fill: gradient.radial((col.transparentize(op), 0%), (col.transparentize(100%), 100%), space: oklab)))
    }
  }))
  lamina(d, c, "aura", contenido, desde, hasta, insets: (60, 100), fuente: F, debajo: halos,
    tarjeta: (w, h, sangre) => block(width: w, height: h,
      fill: c0.tarjeta.transparentize(if sangre { 90% } else { 87% }),
      radius: if sangre { 0pt } else { L(40) },
      stroke: if sangre { none } else { L(2) + c0.linea.transparentize(70%) }))
}

#let estilos-b = (
  papel: papel,
  pizarra: pizarra,
  recorte: recorte,
  aura: aura,
)
