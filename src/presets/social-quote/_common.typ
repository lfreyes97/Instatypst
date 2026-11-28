// ─────────────────────────────────────────────────────────────
//  presets/social-quote/_common.typ — piezas que comparten las variantes de
//  `social-quote` (en v1, `_cita-social-comun.typ`): validar el contenido extra,
//  la geometría de la lámina, el avatar, la insignia de verificado, los iconos
//  de las métricas (dibujados con primitivas, sin logos), el formato corto de
//  las cifras y el armazón de lámina con tarjeta que usan casi todas.
//
//  Son solo de este preset: lo usan social-quote.typ y variants/*.
//  Las medidas siguen la escala de v1, k = mín(ancho/1080, alto/1350).
// ─────────────────────────────────────────────────────────────
#import "/src/plain/scaffold.typ": fit-down
#import "/src/resources/motifs/_lamina.typ": area-trabajo
#import "/src/modules/color/palettes/contrast.typ": readable-on
#import "/src/modules/superbg/azar.typ": _secuencia

// Las métricas que se entienden, en el orden en que se muestran.
#let metric-keys = ("comments", "shares", "likes", "views")

// ── validación de los campos de contenido (comunes a todos los estilos) ──
#let validate(d) = {
  let q = "social-quote"
  let es-texto(v) = type(v) in (str, content)
  if d.handle != none and not es-texto(d.handle) {
    panic(q + ": `handle` es un texto (\"@alguien\"), no " + repr(type(d.handle)))
  }
  if d.date != none and not es-texto(d.date) {
    panic(q + ": `date` es un texto o contenido (\"5 nov 2026\"), no " + repr(type(d.date)))
  }
  if type(d.verified) != bool {
    panic(q + ": `verified` es true o false, no " + repr(d.verified))
  }
  if d.tag != none and not es-texto(d.tag) {
    panic(q + ": `tag` es un texto o contenido («En respuesta a…», «de _La obra_»), no " + repr(type(d.tag)))
  }
  if d.metrics != none {
    if type(d.metrics) != dictionary {
      panic(q + ": `metrics` es un diccionario (" + metric-keys.join(", ") + "), no " + repr(type(d.metrics)))
    }
    for (k, v) in d.metrics {
      if k not in metric-keys {
        panic(q + ": métrica desconocida " + repr(k) + " — disponibles: " + metric-keys.join(", "))
      }
      if type(v) not in (int, float, str, content) or (type(v) in (int, float) and v < 0) {
        panic(q + ": la métrica " + repr(k) + " es un número ≥ 0 o un texto, no " + repr(v))
      }
    }
  }
  if d.reply != none {
    let r = d.reply
    if type(r) == dictionary {
      if "text" not in r { panic(q + ": `reply` como diccionario necesita `text` (y admite `name`, `handle`)") }
      for k in r.keys() {
        if k not in ("text", "name", "handle") {
          panic(q + ": `reply` admite `text`, `name` y `handle`, no " + repr(k))
        }
      }
    } else if not es-texto(r) {
      panic(q + ": `reply` es un contenido o un diccionario (text:, name:, handle:), no " + repr(type(r)))
    }
  }
}

// La respuesta normalizada a (text, name, handle).
#let reply-of(r) = if r == none { none } else if type(r) == dictionary {
  (text: r.text, name: r.at("name", default: none), handle: r.at("handle", default: none))
} else { (text: r, name: none, handle: none) }

// «@handle · date» (lo que haya), o none.
#let meta-of(d, sep: " · ") = {
  let partes = (d.handle, d.date).filter(x => x != none)
  if partes.len() == 0 { none } else { partes.join(sep) }
}

// ── cifras cortas: 999 · 1,2 mil · 12 mil · 1,2 M · 12 M ──
#let _decimal(x) = {
  let r = calc.floor(x * 10) / 10
  let s = if r == calc.floor(r) { str(int(r)) } else { str(r).replace(".", ",") }
  s
}
#let short(n) = {
  if type(n) in (str, content) { return n }
  if n < 1000 { str(int(n)) }
  else if n < 10000 { _decimal(n / 1000) + " mil" }
  else if n < 1000000 { str(int(calc.floor(n / 1000))) + " mil" }
  else if n < 10000000 { _decimal(n / 1000000) + " M" }
  else { str(int(calc.floor(n / 1000000))) + " M" }
}

// En la variante «open» el texto va sobre el fondo: el color que más
// contraste (como el estilo clásico), y lo secundario, rebajado.
#let open-colors(c) = {
  let t = readable-on(c.paper, c.card, c.ink)
  c + (ink: t, quiet: t.transparentize(30%), guide: t.transparentize(75%))
}

// ── geometría: medidas pensadas sobre 1080 × 1350, el lado menor manda ──
#let geo(d) = {
  let k = calc.min(d.artboard.at(0) / 1080, d.artboard.at(1) / 1350)
  let L(u) = u * k * 1pt
  let (width, height) = (d.artboard.at(0) * 1pt, d.artboard.at(1) * 1pt)
  let (ax, ay, aw, ah) = area-trabajo(d.artboard, area: d.area, ancla: d.anchor, quien: "social-quote")
  (k: k, L: L, width: width, height: height, ax: ax, ay: ay, aw: aw, ah: ah,
   margin: L(72), foot: if d.brand != none { L(120) } else { 0pt })
}

// La fuente y los cuerpos del estilo cuando el llamador dejó los de por
// defecto (el dispatcher los pasa como none).
#let font-of(d, propia) = if d.font == none { propia } else { d.font }
#let sizes-of(d, g, cuerpo, minimo) = (
  (if d.size == none { cuerpo } else { d.size }) * g.k * 1pt,
  (if d.min-size == none { minimo } else { d.min-size }) * g.k * 1pt,
)

// El mayor cuerpo (de `desde` a `hasta`, en pasos de 1 pt) con el que el
// bloque cabe en `alto`; si no cabe ni al mínimo, error con mensaje.
#let fit-size(bloque, desde, alto, hasta, estilo) = {
  let s = fit-down(bloque, desde, alto, min: hasta, paso: 1pt)
  if measure(bloque(s)).height > alto + 0.5pt {
    panic("social-quote(variant: \"" + estilo + "\"): la cita no cabe en el área ni al tamaño mínimo: acórtala, usa un formato más alto, quita campos (reply, metrics…) o baja `main.min-size`")
  }
  s
}

// ── piezas ──
// Filas apiladas con una separación fija (none se salta): para el nombre y
// su línea de metadatos, que con `linebreak` y sizes-of distintos se pisan.
#let rows(gap, ..filas) = grid(columns: 1, row-gutter: gap, ..filas.pos().filter(x => x != none))

// La comilla grande sobre la cita: se recorta a su parte de arriba (la que
// tiene el trazo) para que no empuje ni pise la primera línea.
#let big-quote(s, color, escala: 2.3, alto: 0.8) = block(below: 0.12 * s, height: alto * s, clip: true,
  text(size: escala * s, fill: color, top-edge: "cap-height", bottom-edge: "baseline", "\u{201C}"))

// Avatar redondo: la foto o las iniciales sobre el acento.
#let avatar(foto, iniciales, av, acento, anillo: none, fuente: auto) = {
  let cara = if foto != none {
    box(clip: true, radius: 100%, width: av, height: av, image(foto, width: av, height: av, fit: "cover"))
  } else {
    box(width: av, height: av, radius: 100%, fill: acento, align(center + horizon,
      text(size: av * 0.38, weight: 800, fill: readable-on(acento, white, black),
        ..(if fuente != auto { (font: fuente) } else { (:) }), iniciales)))
  }
  if anillo == none { cara } else {
    box(width: av, height: av, cara + place(top + left, circle(radius: av / 2, stroke: anillo)))
  }
}

// La insignia de verificado: un círculo con una marca de visto (genérica).
#let badge(t, fondo, mark: white) = box(baseline: 0.14 * t, width: t, height: t, {
  place(circle(radius: t / 2, fill: fondo, stroke: none))
  place(curve(stroke: (paint: mark, thickness: 0.13 * t, cap: "round", join: "round"),
    curve.move((0.27 * t, 0.52 * t)), curve.line((0.44 * t, 0.68 * t)), curve.line((0.74 * t, 0.36 * t))))
})

// Iconos de línea de lado `t`: comments (bocadillo), shares (flecha
// que sale de una caja), likes (corazón), views (ojo).
#let icon(nombre, t, color, grosor: auto) = {
  let g = if grosor == auto { 0.085 * t } else { grosor }
  let st = (paint: color, thickness: g, cap: "round", join: "round")
  let P(x, y) = (x * t, y * t)
  box(width: t, height: t, baseline: 0.16 * t, {
    if nombre == "likes" {
      place(curve(stroke: st,
        curve.move(P(0.5, 0.9)),
        curve.line(P(0.13, 0.53)),
        curve.cubic(P(-0.02, 0.38), P(0.06, 0.1), P(0.28, 0.1)),
        curve.cubic(P(0.39, 0.1), P(0.46, 0.17), P(0.5, 0.25)),
        curve.cubic(P(0.54, 0.17), P(0.61, 0.1), P(0.72, 0.1)),
        curve.cubic(P(0.94, 0.1), P(1.02, 0.38), P(0.87, 0.53)),
        curve.close()))
    } else if nombre == "comments" {
      place(curve(stroke: st,
        curve.move(P(0.3, 0.76)),
        curve.cubic(P(0.1, 0.7), P(0.04, 0.56), P(0.04, 0.44)),
        curve.cubic(P(0.04, 0.24), P(0.24, 0.1), P(0.5, 0.1)),
        curve.cubic(P(0.76, 0.1), P(0.96, 0.24), P(0.96, 0.44)),
        curve.cubic(P(0.96, 0.64), P(0.76, 0.78), P(0.5, 0.78)),
        curve.line(P(0.2, 0.94)),
        curve.close()))
    } else if nombre == "shares" {
      place(curve(stroke: st,
        curve.move(P(0.5, 0.14)), curve.line(P(0.12, 0.14)), curve.line(P(0.12, 0.88)),
        curve.line(P(0.86, 0.88)), curve.line(P(0.86, 0.5))))
      place(curve(stroke: st, curve.move(P(0.44, 0.56)), curve.line(P(0.9, 0.1))))
      place(curve(stroke: st, curve.move(P(0.62, 0.1)), curve.line(P(0.9, 0.1)), curve.line(P(0.9, 0.38))))
    } else if nombre == "views" {
      place(curve(stroke: st,
        curve.move(P(0.03, 0.5)),
        curve.cubic(P(0.26, 0.14), P(0.74, 0.14), P(0.97, 0.5)),
        curve.cubic(P(0.74, 0.86), P(0.26, 0.86), P(0.03, 0.5)),
        curve.close()))
      place(dx: 0.36 * t, dy: 0.36 * t, circle(radius: 0.14 * t, fill: color, stroke: none))
    }
  })
}

// Las métricas como pares (icono, cifra), en el orden de `metric-keys`.
#let metric-pairs(m, t, color, gap: 0.32) = {
  if m == none { return () }
  metric-keys.filter(k => k in m).map(k => box({
    icon(k, t, color)
    h(gap * t)
    short(m.at(k))
  }))
}

// Una fila de métricas repartida a lo ancho (como el pie de una publicación).
#let metrics-row(m, t, color, size: auto) = {
  let ps = metric-pairs(m, t, color)
  if ps.len() == 0 { return none }
  set text(size: if size == auto { 0.86 * t } else { size }, fill: color)
  grid(columns: ps.map(_ => 1fr), align: left + horizon, ..ps)
}

// Grano de papel: una tesela de puntos al azar (vectorial, repetida; pesa
// unos pocos kB en el PDF, nada que ver con un ruido rasterizado).
#let grain-tile(lado, color, n: 70, semilla: 7, radio: 0.9pt) = {
  let r = _secuencia(n * 3, semilla)
  tiling(size: (lado, lado), {
    for i in range(n) {
      let (x, y, o) = r.slice(i * 3, i * 3 + 3)
      place(dx: x * lado, dy: y * lado, circle(radius: radio * (0.5 + o), fill: color.transparentize(40% + 50% * o), stroke: none))
    }
  })
}

// Una trama de puntos regulares (fondo de conversación).
#let dot-tiling(paso, radio, color) = tiling(size: (paso, paso), {
  place(dx: paso / 4 - radio, dy: paso / 4 - radio, circle(radius: radio, fill: color, stroke: none))
  place(dx: 3 * paso / 4 - radio, dy: 3 * paso / 4 - radio, circle(radius: radio, fill: color, stroke: none))
})

// La marca, centrada al pie del área.
#let place-brand(d, g, c, font) = if d.brand != none {
  place(top + left, dx: g.ax, dy: g.ay + g.ah - g.margin - (g.L)(40), box(width: g.aw, align(center,
    text(font: font, fill: readable-on(c.paper, c.card, c.ink), d.brand))))
}

// Cita, atribución y avatar dispuestos según `position`:
//   bottom  cita · filete · atribución    top  atribución · filete · cita
//   side    el avatar en una columna a la izquierda; cita y atribución al lado
// `filete` es el contenido entre ambas (none: solo un espacio `aire`).
#let arrange(atribucion, cita, firma, cara, ancho-cara, aire, filete: none, firma-lado: auto) = {
  let medio = if filete == none { v(aire) } else { filete }
  if atribucion == "top" {
    firma; medio; cita
  } else if atribucion == "bottom" {
    cita; medio; firma
  } else {
    let fl = if firma-lado == auto { firma } else { firma-lado }
    if cara == none { cita; medio; fl } else {
      grid(columns: (ancho-cara, 1fr), gutter: 0pt, cara, { cita; v(aire); fl })
    }
  }
}

// ── armazón de lámina con tarjeta (como el estilo clásico) ──
// `contenido(s)` es el contenido a cuerpo `s` (ya con su ancho: el bloque lo
// envuelve); `card(w, h, bleed)` dibuja el soporte (o none); `below` y
// `above` (funciones de la geometría g) van antes y después; `insets` es
// (tarjeta, sangre). Devuelve la página.
#let sheet(d, c, estilo, contenido, desde, hasta,
  card: none, insets: (48, 80), margin: auto, below: none, above: none, font: "Inter",
  max-width: none) = {
  let g = geo(d)
  let L = g.L
  let is-open = d.layout == "open"
  let bleed = d.layout == "bleed"
  let margin = if margin == auto { g.margin } else { margin }
  let inset = if is-open { 0pt } else if bleed { L(insets.at(1)) } else { L(insets.at(0)) }
  let caja-w = if bleed { g.aw } else { g.aw - 2 * margin }
  let caja-h = if bleed { g.ah } else { g.ah - 2 * margin - g.foot }
  let ancho-int = caja-w - 2 * inset
  if max-width != none { ancho-int = calc.min(ancho-int, max-width) }
  let alto-int = caja-h - 2 * inset
  let bloque(s) = block(width: ancho-int, contenido(s))
  context {
    if below != none { below(g) }
    let s = fit-size(bloque, desde, alto-int, hasta, estilo)
    let b = bloque(s)
    let h = measure(b).height
    let (bx, by, bw, bh) = if bleed { (g.ax, g.ay, g.aw, g.ah) } else {
      (g.ax + margin, g.ay + margin + (g.ah - 2 * margin - g.foot - (h + 2 * inset)) / 2, caja-w, h + 2 * inset)
    }
    if not is-open and card != none { place(top + left, dx: bx, dy: by, card(bw, bh, bleed)) }
    place(top + left, dx: bx + (bw - ancho-int) / 2, dy: by + (bh - h) / 2, b)
    if above != none { above((x: bx, y: by, w: bw, h: bh, s: s, g: g)) }
    place-brand(d, g, c, font)
  }
}
