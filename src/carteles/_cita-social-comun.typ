// ─────────────────────────────────────────────────────────────
//  carteles/_cita-social-comun.typ — piezas que comparten los estilos de
//  `carteles.cita-social`: validar el contenido extra, resolver el tema de
//  un estilo, la geometría de la lámina, el avatar, la insignia de
//  verificado, los iconos de las métricas (dibujados con primitivas, sin
//  logos), el formato corto de las cifras y el armazón de lámina con
//  tarjeta que usan la mayoría de los estilos.
//
//  Privado de `carteles/`: lo usan cita-social.typ y _cita-social-estilos-*.
// ─────────────────────────────────────────────────────────────
#import "../pliego.typ": pliego
#import "_base.typ": medida, escala, area-trabajo, ajustar-alto
#import "_temas.typ": resolver-tema, temas-lamina
#import "../contrast.typ": readable-on
#import "../superbg/azar.typ": _secuencia

// Las métricas que se entienden, en el orden en que se muestran.
#let claves-metricas = ("comentarios", "compartidos", "me-gusta", "vistas")

// ── validación de los campos de contenido (comunes a todos los estilos) ──
#let validar-contenido(d) = {
  let q = "cita-social"
  let es-texto(v) = type(v) in (str, content)
  if d.usuario != none and not es-texto(d.usuario) {
    panic(q + ": `usuario` es un texto (\"@alguien\"), no " + repr(type(d.usuario)))
  }
  if d.fecha != none and not es-texto(d.fecha) {
    panic(q + ": `fecha` es un texto o contenido (\"5 nov 2026\"), no " + repr(type(d.fecha)))
  }
  if type(d.verificado) != bool {
    panic(q + ": `verificado` es true o false, no " + repr(d.verificado))
  }
  if d.contexto != none and not es-texto(d.contexto) {
    panic(q + ": `contexto` es un texto o contenido («En respuesta a…», «de _La obra_»), no " + repr(type(d.contexto)))
  }
  if d.metricas != none {
    if type(d.metricas) != dictionary {
      panic(q + ": `metricas` es un diccionario (" + claves-metricas.join(", ") + "), no " + repr(type(d.metricas)))
    }
    for (k, v) in d.metricas {
      if k not in claves-metricas {
        panic(q + ": métrica desconocida " + repr(k) + " — disponibles: " + claves-metricas.join(", "))
      }
      if type(v) not in (int, float, str, content) or (type(v) in (int, float) and v < 0) {
        panic(q + ": la métrica " + repr(k) + " es un número ≥ 0 o un texto, no " + repr(v))
      }
    }
  }
  if d.respuesta != none {
    let r = d.respuesta
    if type(r) == dictionary {
      if "texto" not in r { panic(q + ": `respuesta` como diccionario necesita `texto` (y admite `nombre`, `usuario`)") }
      for k in r.keys() {
        if k not in ("texto", "nombre", "usuario") {
          panic(q + ": `respuesta` admite `texto`, `nombre` y `usuario`, no " + repr(k))
        }
      }
    } else if not es-texto(r) {
      panic(q + ": `respuesta` es un contenido o un diccionario (texto:, nombre:, usuario:), no " + repr(type(r)))
    }
  }
}

// La respuesta normalizada a (texto, nombre, usuario).
#let respuesta-de(r) = if r == none { none } else if type(r) == dictionary {
  (texto: r.texto, nombre: r.at("nombre", default: none), usuario: r.at("usuario", default: none))
} else { (texto: r, nombre: none, usuario: none) }

// «@usuario · fecha» (lo que haya), o none.
#let meta-de(d, sep: " · ") = {
  let partes = (d.usuario, d.fecha).filter(x => x != none)
  if partes.len() == 0 { none } else { partes.join(sep) }
}

// ── cifras cortas: 999 · 1,2 mil · 12 mil · 1,2 M · 12 M ──
#let _decimal(x) = {
  let r = calc.floor(x * 10) / 10
  let s = if r == calc.floor(r) { str(int(r)) } else { str(r).replace(".", ",") }
  s
}
#let corto(n) = {
  if type(n) in (str, content) { return n }
  if n < 1000 { str(int(n)) }
  else if n < 10000 { _decimal(n / 1000) + " mil" }
  else if n < 1000000 { str(int(calc.floor(n / 1000))) + " mil" }
  else if n < 10000000 { _decimal(n / 1000000) + " M" }
  else { str(int(calc.floor(n / 1000000))) + " M" }
}

// ── el tema de un estilo ──
// `tema` en su valor por defecto ("cita-social") significa «el del estilo»;
// cualquier otro nombre o diccionario se resuelve sobre el tema del estilo.
// Los colores sueltos (`fondo:`, `tinta:`…) pisan al final.
// A diferencia del estilo clásico, los colores sueltos entran en la
// derivación: `tarjeta: black` vuelve a derivar `linea` (y `trama`, `grano`).
#let tema-de(d, propio) = {
  let sueltos = (:)
  for (rol, v) in d.colores { if v != auto { sueltos.insert(rol, v) } }
  let t = if d.tema == "cita-social" or d.tema == propio { sueltos }
    else if type(d.tema) == str { temas-lamina.at(d.tema, default: none) }
    else { d.tema }
  if t == none { resolver-tema(d.tema) } // el error de tema desconocido
  if type(t) == dictionary { t = t + sueltos }
  resolver-tema(t, defecto: propio)
}

// En la variante «abierta» el texto va sobre el fondo: el color que más
// contraste (como el estilo clásico), y lo secundario, rebajado.
#let colores-abierta(c) = {
  let t = readable-on(c.fondo, c.tarjeta, c.tinta)
  c + (tinta: t, suave: t.transparentize(30%), linea: t.transparentize(75%))
}

// ── geometría: medidas pensadas sobre 1080 × 1350, el lado menor manda ──
#let geo(d) = {
  let k = escala(d.formato, base: (1080, 1350))
  let L(u) = u * k * 1pt
  let (ancho, alto) = medida(d.formato)
  let (ax, ay, aw, ah) = area-trabajo(d.formato, area: d.area, ancla: d.ancla, quien: "cita-social")
  (k: k, L: L, ancho: ancho, alto: alto, ax: ax, ay: ay, aw: aw, ah: ah,
   margen: L(72), pie: if d.marca != none { L(120) } else { 0pt })
}

// La fuente y los cuerpos del estilo cuando el llamador dejó los de por
// defecto (el dispatcher los pasa como none).
#let fuente-de(d, propia) = if d.fuente == none { propia } else { d.fuente }
#let cuerpos(d, g, cuerpo, minimo) = (
  (if d.cuerpo == none { cuerpo } else { d.cuerpo }) * g.k * 1pt,
  (if d.minimo == none { minimo } else { d.minimo }) * g.k * 1pt,
)

// El mayor cuerpo (de `desde` a `hasta`, en pasos de 1 pt) con el que el
// bloque cabe en `alto`; si no cabe ni al mínimo, error con mensaje.
#let encajar-cuerpo(bloque, desde, alto, hasta, estilo) = {
  let s = ajustar-alto(bloque, desde, alto, minimo: hasta, paso: 1pt)
  if measure(bloque(s)).height > alto + 0.5pt {
    panic("cita-social(estilo: \"" + estilo + "\"): la cita no cabe en el área ni al tamaño mínimo: acórtala, usa un formato más alto, quita campos (respuesta, métricas…) o baja `minimo`")
  }
  s
}

// ── piezas ──
// Filas apiladas con una separación fija (none se salta): para el nombre y
// su línea de metadatos, que con `linebreak` y cuerpos distintos se pisan.
#let pila(gap, ..filas) = grid(columns: 1, row-gutter: gap, ..filas.pos().filter(x => x != none))

// La comilla grande sobre la cita: se recorta a su parte de arriba (la que
// tiene el trazo) para que no empuje ni pise la primera línea.
#let comilla-grande(s, color, escala: 2.3, alto: 0.8) = block(below: 0.12 * s, height: alto * s, clip: true,
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
#let insignia(t, fondo, marca: white) = box(baseline: 0.14 * t, width: t, height: t, {
  place(circle(radius: t / 2, fill: fondo, stroke: none))
  place(curve(stroke: (paint: marca, thickness: 0.13 * t, cap: "round", join: "round"),
    curve.move((0.27 * t, 0.52 * t)), curve.line((0.44 * t, 0.68 * t)), curve.line((0.74 * t, 0.36 * t))))
})

// Iconos de línea de lado `t`: comentarios (bocadillo), compartidos (flecha
// que sale de una caja), me-gusta (corazón), vistas (ojo).
#let icono(nombre, t, color, grosor: auto) = {
  let g = if grosor == auto { 0.085 * t } else { grosor }
  let st = (paint: color, thickness: g, cap: "round", join: "round")
  let P(x, y) = (x * t, y * t)
  box(width: t, height: t, baseline: 0.16 * t, {
    if nombre == "me-gusta" {
      place(curve(stroke: st,
        curve.move(P(0.5, 0.9)),
        curve.line(P(0.13, 0.53)),
        curve.cubic(P(-0.02, 0.38), P(0.06, 0.1), P(0.28, 0.1)),
        curve.cubic(P(0.39, 0.1), P(0.46, 0.17), P(0.5, 0.25)),
        curve.cubic(P(0.54, 0.17), P(0.61, 0.1), P(0.72, 0.1)),
        curve.cubic(P(0.94, 0.1), P(1.02, 0.38), P(0.87, 0.53)),
        curve.close()))
    } else if nombre == "comentarios" {
      place(curve(stroke: st,
        curve.move(P(0.3, 0.76)),
        curve.cubic(P(0.1, 0.7), P(0.04, 0.56), P(0.04, 0.44)),
        curve.cubic(P(0.04, 0.24), P(0.24, 0.1), P(0.5, 0.1)),
        curve.cubic(P(0.76, 0.1), P(0.96, 0.24), P(0.96, 0.44)),
        curve.cubic(P(0.96, 0.64), P(0.76, 0.78), P(0.5, 0.78)),
        curve.line(P(0.2, 0.94)),
        curve.close()))
    } else if nombre == "compartidos" {
      place(curve(stroke: st,
        curve.move(P(0.5, 0.14)), curve.line(P(0.12, 0.14)), curve.line(P(0.12, 0.88)),
        curve.line(P(0.86, 0.88)), curve.line(P(0.86, 0.5))))
      place(curve(stroke: st, curve.move(P(0.44, 0.56)), curve.line(P(0.9, 0.1))))
      place(curve(stroke: st, curve.move(P(0.62, 0.1)), curve.line(P(0.9, 0.1)), curve.line(P(0.9, 0.38))))
    } else if nombre == "vistas" {
      place(curve(stroke: st,
        curve.move(P(0.03, 0.5)),
        curve.cubic(P(0.26, 0.14), P(0.74, 0.14), P(0.97, 0.5)),
        curve.cubic(P(0.74, 0.86), P(0.26, 0.86), P(0.03, 0.5)),
        curve.close()))
      place(dx: 0.36 * t, dy: 0.36 * t, circle(radius: 0.14 * t, fill: color, stroke: none))
    }
  })
}

// Las métricas como pares (icono, cifra), en el orden de `claves-metricas`.
#let pares-metricas(m, t, color, gap: 0.32) = {
  if m == none { return () }
  claves-metricas.filter(k => k in m).map(k => box({
    icono(k, t, color)
    h(gap * t)
    corto(m.at(k))
  }))
}

// Una fila de métricas repartida a lo ancho (como el pie de una publicación).
#let fila-metricas(m, t, color, size: auto) = {
  let ps = pares-metricas(m, t, color)
  if ps.len() == 0 { return none }
  set text(size: if size == auto { 0.86 * t } else { size }, fill: color)
  grid(columns: ps.map(_ => 1fr), align: left + horizon, ..ps)
}

// Grano de papel: una tesela de puntos al azar (vectorial, repetida; pesa
// unos pocos kB en el PDF, nada que ver con un ruido rasterizado).
#let grano(lado, color, n: 70, semilla: 7, radio: 0.9pt) = {
  let r = _secuencia(n * 3, semilla)
  tiling(size: (lado, lado), {
    for i in range(n) {
      let (x, y, o) = r.slice(i * 3, i * 3 + 3)
      place(dx: x * lado, dy: y * lado, circle(radius: radio * (0.5 + o), fill: color.transparentize(40% + 50% * o), stroke: none))
    }
  })
}

// Una trama de puntos regulares (fondo de conversación).
#let trama-puntos(paso, radio, color) = tiling(size: (paso, paso), {
  place(dx: paso / 4 - radio, dy: paso / 4 - radio, circle(radius: radio, fill: color, stroke: none))
  place(dx: 3 * paso / 4 - radio, dy: 3 * paso / 4 - radio, circle(radius: radio, fill: color, stroke: none))
})

// La marca, centrada al pie del área.
#let poner-marca(d, g, c, fuente) = if d.marca != none {
  place(top + left, dx: g.ax, dy: g.ay + g.ah - g.margen - (g.L)(40), box(width: g.aw, align(center,
    text(font: fuente, fill: readable-on(c.fondo, c.tarjeta, c.tinta), d.marca))))
}

// Cita, atribución y avatar dispuestos según `atribucion`:
//   abajo  cita · filete · atribución     arriba  atribución · filete · cita
//   lado   el avatar en una columna a la izquierda; cita y atribución al lado
// `filete` es el contenido entre ambas (none: solo un espacio `aire`).
#let disponer(atribucion, cita, firma, cara, ancho-cara, aire, filete: none, firma-lado: auto) = {
  let medio = if filete == none { v(aire) } else { filete }
  if atribucion == "arriba" {
    firma; medio; cita
  } else if atribucion == "abajo" {
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
// envuelve); `tarjeta(w, h, sangre)` dibuja el soporte (o none); `debajo` y
// `encima` (funciones de la geometría g) van antes y después; `insets` es
// (tarjeta, sangre). Devuelve la página.
#let lamina(d, c, estilo, contenido, desde, hasta,
  tarjeta: none, insets: (48, 80), margen: auto, debajo: none, encima: none, fuente: "Inter",
  ancho-max: none) = {
  let g = geo(d)
  let L = g.L
  let abierta = d.variante == "abierta"
  let sangre = d.variante == "sangre"
  let margen = if margen == auto { g.margen } else { margen }
  let inset = if abierta { 0pt } else if sangre { L(insets.at(1)) } else { L(insets.at(0)) }
  let caja-w = if sangre { g.aw } else { g.aw - 2 * margen }
  let caja-h = if sangre { g.ah } else { g.ah - 2 * margen - g.pie }
  let ancho-int = caja-w - 2 * inset
  if ancho-max != none { ancho-int = calc.min(ancho-int, ancho-max) }
  let alto-int = caja-h - 2 * inset
  let bloque(s) = block(width: ancho-int, contenido(s))
  pliego(width: g.ancho, height: g.alto, margin: 0pt, fill: c.fondo, context {
    if debajo != none { debajo(g) }
    let s = encajar-cuerpo(bloque, desde, alto-int, hasta, estilo)
    let b = bloque(s)
    let h = measure(b).height
    let (bx, by, bw, bh) = if sangre { (g.ax, g.ay, g.aw, g.ah) } else {
      (g.ax + margen, g.ay + margen + (g.ah - 2 * margen - g.pie - (h + 2 * inset)) / 2, caja-w, h + 2 * inset)
    }
    if not abierta and tarjeta != none { place(top + left, dx: bx, dy: by, tarjeta(bw, bh, sangre)) }
    place(top + left, dx: bx + (bw - ancho-int) / 2, dy: by + (bh - h) / 2, b)
    if encima != none { encima((x: bx, y: by, w: bw, h: bh, s: s, g: g)) }
    poner-marca(d, g, c, fuente)
  })
}
