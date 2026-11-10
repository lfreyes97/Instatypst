// ─────────────────────────────────────────────────────────────
//  carteles/_cita-social-estilos-a.typ — estilos de `cita-social`, tanda A:
//  los de pantalla y los tipográficos
//
//    publicacion  una publicación genérica de red social: avatar, nombre,
//                 insignia, @usuario, la cita, la cita anidada, la fecha y
//                 la fila de métricas con iconos de línea
//    mensaje      burbuja de chat con cola junto al avatar, sobre una trama
//                 de puntos; la respuesta va citada dentro de la burbuja
//    editorial    serif grande (Fraunces) entre filetes de portadilla, el
//                 contexto como antetítulo rojo y la firma en versalitas
//    minimal      mucho aire, un peso ligero, una línea y la firma
//    subrayado    grotesca gruesa con el resaltado de rotulador como
//                 protagonista, en tarjeta con sombra dura
//
//  Qué muestra cada uno (✓) de los campos de contenido:
//                 foto/inic. usuario fecha verif. contexto métricas respuesta
//    publicacion      ✓        ✓      ✓     ✓       ✓        ✓         ✓
//    mensaje          ✓        ✓      ✓     ✓       ✓ (chip) ✓ (píldora) ✓
//    editorial        —        ✓      ✓     ✓       ✓        —         —
//    minimal          —        ✓      ✓     ✓       ✓        —         —
//    subrayado        ✓        ✓      ✓     ✓       ✓        —         —
//  Lo que no cabe en el carácter del estilo se ignora sin error.
//
//  `atribucion`: publicacion la ignora (la cabecera va siempre arriba, como
//  en una publicación); mensaje usa arriba/abajo para el lado del avatar y
//  la cola («lado» = «abajo»); editorial, las tres («lado»: la firma en
//  columna a la izquierda); minimal, arriba/abajo («lado» = «abajo»);
//  subrayado, las tres.
//  `variante`: publicacion y subrayado, las tres (tarjeta, sangre,
//  abierta); mensaje, editorial y minimal no tienen tarjeta y la ignoran.
//  `comilla`: editorial y subrayado; los demás la ignoran.
//
//  Cada estilo es una función (d) => página, con `d` el diccionario de
//  argumentos que arma `cita-social`. Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────
#import "_cita-social-comun.typ": *

// ═════════════════════════════════════════════════════════════
//  publicacion
// ═════════════════════════════════════════════════════════════
#let publicacion(d) = {
  let c0 = tema-de(d, "cita-publicacion")
  let c = if d.variante == "abierta" { colores-abierta(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Inter", "Liberation Sans"))
  let (desde, hasta) = cuerpos(d, g, 72, 22)
  let resp = respuesta-de(d.respuesta)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta)
    set par(leading: 0.5em, spacing: 0.8em)
    show highlight: it => text(fill: c.acento, weight: 600, it.body)
    let av = calc.max(L(64), calc.min(1.25 * s, L(116)))
    let tn = calc.max(L(24), 0.5 * s)
    let tm = 0.92 * tn
    let puntos = box(width: 1.3 * tn, height: 0.5 * tn,
      for i in range(3) { place(dx: i * 0.5 * tn, dy: 0.16 * tn, circle(radius: 0.1 * tn, fill: c.suave, stroke: none)) })
    grid(columns: (av, 1fr, auto), column-gutter: L(20), align: (left + horizon, left + horizon, right + top),
      avatar(d.foto, d.iniciales, av, c0.acento),
      pila(0.22 * tn, {
        text(size: tn, weight: 700, d.nombre)
        if d.verificado { h(0.25 * tn); insignia(0.86 * tn, c0.acento) }
      }, if d.usuario != none { text(size: tm, fill: c.suave, d.usuario) }),
      puntos)
    v(L(30))
    if d.contexto != none {
      block(below: L(16), text(size: tm, fill: c.suave, d.contexto))
    }
    text(size: s, d.cita)
    if resp != none {
      let tr = calc.max(L(22), 0.7 * s)
      block(above: L(30), width: 100%, stroke: L(2) + c.linea, radius: L(22), inset: L(28), {
        if resp.nombre != none or resp.usuario != none {
          block(below: L(12), {
            if resp.nombre != none { text(size: 0.85 * tn, weight: 700, resp.nombre) }
            if resp.usuario != none { h(0.4 * tn); text(size: 0.8 * tn, fill: c.suave, resp.usuario) }
          })
        }
        text(size: tr, resp.texto)
      })
    }
    if d.fecha != none { block(above: L(30), text(size: tm, fill: c.suave, d.fecha)) }
    if d.metricas != none {
      v(L(22))
      line(length: 100%, stroke: L(2) + c.linea)
      v(L(20))
      fila-metricas(d.metricas, 1.05 * tn, c.suave, size: tm)
    }
  }
  lamina(d, c, "publicacion", contenido, desde, hasta, insets: (56, 96), fuente: F,
    tarjeta: (w, h, sangre) => block(width: w, height: h, fill: c.tarjeta,
      radius: if sangre { 0pt } else { L(28) }, stroke: if sangre { none } else { L(2) + c.linea }))
}

// ═════════════════════════════════════════════════════════════
//  mensaje
// ═════════════════════════════════════════════════════════════
#let mensaje(d) = {
  let c = tema-de(d, "cita-mensaje")
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("DM Sans", "Inter"))
  let (desde, hasta) = cuerpos(d, g, 80, 22)
  let resp = respuesta-de(d.respuesta)
  let arriba = d.atribucion == "arriba"
  let ancho-total = g.aw - 2 * g.margen
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta)
    set par(leading: 0.5em, spacing: 0.8em)
    set highlight(fill: c.acento.transparentize(80%), extent: 0.06em, radius: 0.12em)
    // un `context` propio: las medidas de aquí dentro ven los `set` de arriba
    context {
    let av = calc.max(L(56), calc.min(1.2 * s, L(96)))
    let gap = L(28)
    let relleno = calc.max(L(26), 0.62 * s)
    let tn = calc.max(L(22), 0.5 * s)
    let max-b = ancho-total - av - gap
    // lo que va dentro de la burbuja
    let cabecera = {
      text(size: tn, weight: 700, fill: c.acento, d.nombre)
      if d.verificado { h(0.25 * tn); insignia(0.85 * tn, c.acento) }
      if d.usuario != none { h(0.45 * tn); text(size: 0.9 * tn, fill: c.suave, d.usuario) }
    }
    let citada = if resp != none {
      block(width: 100%, fill: c.acento.transparentize(90%), radius: L(14), inset: (left: L(26), rest: L(18)),
        stroke: (left: L(6) + c.acento), {
          if resp.nombre != none or resp.usuario != none {
            block(below: L(8), {
              if resp.nombre != none { text(size: 0.85 * tn, weight: 700, fill: c.acento, resp.nombre) }
              if resp.usuario != none { h(0.35 * tn); text(size: 0.8 * tn, fill: c.suave, resp.usuario) }
            })
          }
          text(size: calc.max(L(20), 0.62 * s), fill: c.suave, resp.texto)
        })
    }
    let cuerpo-t = text(size: s, d.cita)
    let hora = if d.fecha != none { text(size: 0.82 * tn, fill: c.suave, d.fecha) }
    // ancho natural de la burbuja (ajusta al texto si es corto)
    let nat = calc.max(measure(cabecera).width, measure(cuerpo-t).width,
      if hora != none { measure(hora).width } else { 0pt },
      if citada != none { L(360) } else { 0pt })
    let bw = calc.min(nat + 2 * relleno, max-b)
    let r = L(40)
    let filas = (cabecera,)
    if citada != none { filas.push(citada) }
    filas.push(cuerpo-t)
    if hora != none { filas.push(grid.cell(align: right, hora)) }
    let interior = block(width: bw, inset: relleno,
      grid(columns: 1fr, row-gutter: calc.max(L(22), 0.75 * tn), ..filas))
    let bh = measure(interior).height
    let cola = if arriba {
      curve(fill: c.tarjeta, stroke: none,
        curve.move((-L(22), 0pt)), curve.line((L(30), 0pt)), curve.line((L(30), L(40))),
        curve.cubic((L(14), L(28)), (L(2), L(8)), (-L(22), 0pt)), curve.close())
    } else {
      curve(fill: c.tarjeta, stroke: none,
        curve.move((-L(22), bh)), curve.line((L(30), bh)), curve.line((L(30), bh - L(40))),
        curve.cubic((L(14), bh - L(28)), (L(2), bh - L(8)), (-L(22), bh)), curve.close())
    }
    let burbuja = box(width: bw, height: bh, {
      place(cola)
      place(block(width: bw, height: bh, fill: c.tarjeta,
        radius: if arriba { (top-left: L(6), rest: r) } else { (bottom-left: L(6), rest: r) }))
      place(interior)
    })
    let pildora = if d.metricas != none {
      let ps = pares-metricas(d.metricas, 0.95 * tn, c.suave)
      if ps.len() > 0 {
        box(fill: c.tarjeta, radius: 100%, stroke: L(3) + c.fondo, inset: (x: L(22), y: L(12)),
          text(size: 0.86 * tn, fill: c.suave, ps.join(h(0.8 * tn))))
      }
    }
    if d.contexto != none {
      block(below: L(36), width: 100%, align(center,
        box(fill: c.tarjeta.transparentize(25%), radius: 100%, inset: (x: L(26), y: L(12)),
          text(size: 0.86 * tn, weight: 500, fill: c.suave, d.contexto))))
    }
    grid(columns: (av, gap, auto), align: if arriba { top } else { bottom },
      avatar(d.foto, d.iniciales, av, c.acento), [], burbuja)
    if pildora != none {
      v(-L(22))
      pad(left: av + gap + L(24), pildora)
    }
    }
  }
  lamina(d + (variante: "tarjeta"), c, "mensaje", contenido, desde, hasta, insets: (0, 0), fuente: F,
    debajo: g => place(top + left, dx: g.ax, dy: g.ay,
      rect(width: g.aw, height: g.ah, stroke: none, fill: trama-puntos(L(40), L(2.6), c.trama))))
}

// ═════════════════════════════════════════════════════════════
//  editorial
// ═════════════════════════════════════════════════════════════
#let editorial(d) = {
  let c = tema-de(d, "cita-editorial")
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Fraunces 72pt", "Fraunces", "Libertinus Serif"))
  let S = ("Inter", "Liberation Sans") // la letra de la firma y el antetítulo
  let (desde, hasta) = cuerpos(d, g, 104, 26)
  let meta = meta-de(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta)
    set par(leading: 0.42em, spacing: 0.7em)
    show highlight: it => text(style: "italic", fill: c.acento, it.body)
    let tn = calc.max(L(20), 0.3 * s)
    let sup = {
      line(length: 100%, stroke: L(6) + c.linea)
      v(L(8), weak: false)
      line(length: 100%, stroke: L(1.5) + c.linea)
    }
    let inf = {
      line(length: 100%, stroke: L(1.5) + c.linea)
      v(L(8), weak: false)
      line(length: 100%, stroke: L(6) + c.linea)
    }
    let antetitulo = if d.contexto != none {
      block(below: L(30), text(font: S, size: tn, weight: 700, tracking: 0.14em, fill: c.acento, upper(d.contexto)))
    }
    let cita-b = {
      if d.comilla {
        comilla-grande(s, c.acento)
      }
      text(size: s, weight: 400, d.cita)
    }
    let firma = pila(0.45 * tn, {
      text(font: S, size: tn, weight: 700, tracking: 0.12em, upper(d.nombre))
      if d.verificado { h(0.3 * tn); insignia(0.95 * tn, c.acento) }
    }, if meta != none { text(font: S, size: 0.95 * tn, fill: c.suave, meta) })
    let raya = box(line(length: L(56), stroke: L(4) + c.acento))
    sup
    v(L(44))
    if d.atribucion == "lado" {
      antetitulo
      grid(columns: (30%, 1fr), column-gutter: L(36), align: top,
        grid.vline(x: 1, stroke: L(1.5) + c.linea, position: start),
        { raya; v(L(18)); firma }, pad(left: L(36), cita-b))
    } else if d.atribucion == "arriba" {
      antetitulo
      firma
      v(L(44))
      cita-b
    } else {
      antetitulo
      cita-b
      v(L(48))
      raya
      v(L(18))
      firma
    }
    v(L(44))
    inf
  }
  lamina(d + (variante: "tarjeta"), c, "editorial", contenido, desde, hasta, insets: (16, 16),
    margen: (g.L)(88), fuente: S)
}

// ═════════════════════════════════════════════════════════════
//  minimal
// ═════════════════════════════════════════════════════════════
#let minimal(d) = {
  let c = tema-de(d, "cita-minimal")
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Inter", "Liberation Sans"))
  let (desde, hasta) = cuerpos(d, g, 76, 22)
  let meta = meta-de(d, sep: ", ")
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta, weight: 300)
    set par(leading: 0.6em, spacing: 0.9em)
    show highlight: it => text(weight: 500, it.body)
    let tn = calc.max(L(20), 0.4 * s)
    let firma = {
      box(line(length: L(48), stroke: L(2.5) + c.acento), baseline: -0.32 * tn)
      h(L(20))
      text(size: tn, weight: 500, d.nombre)
      if d.verificado { h(0.25 * tn); insignia(0.85 * tn, c.tinta, marca: c.fondo) }
      if meta != none { text(size: tn, fill: c.suave, [, #meta]) }
    }
    if d.contexto != none {
      block(below: L(44), text(size: 0.8 * tn, weight: 500, tracking: 0.16em, fill: c.suave, upper(d.contexto)))
    }
    if d.atribucion == "arriba" { firma; v(L(56)); text(size: s, d.cita) } else {
      text(size: s, d.cita); v(L(64)); firma
    }
  }
  lamina(d + (variante: "tarjeta"), c, "minimal", contenido, desde, hasta, insets: (0, 0),
    margen: (g.L)(128), fuente: F)
}

// ═════════════════════════════════════════════════════════════
//  subrayado
// ═════════════════════════════════════════════════════════════
#let subrayado(d) = {
  let c0 = tema-de(d, "cita-subrayado")
  let c = if d.variante == "abierta" { colores-abierta(c0) } else { c0 }
  let g = geo(d)
  let L = g.L
  let F = fuente-de(d, ("Bricolage Grotesque", "Inter"))
  let (desde, hasta) = cuerpos(d, g, 104, 24)
  let meta = meta-de(d)
  let contenido(s) = {
    set text(font: F, lang: "es", fill: c.tinta, weight: 800)
    set par(leading: 0.5em, spacing: 0.8em)
    // el rotulador: una banda del acento por la mitad baja de las letras;
    // dentro, la tinta del tema (no la de la variante abierta)
    set highlight(fill: c0.acento, top-edge: 0.6em, bottom-edge: -0.14em, extent: 0.1em)
    show highlight: set text(fill: readable-on(c0.acento, c0.tinta, white, black))
    let av = calc.max(L(60), calc.min(1.05 * s, L(104)))
    let tn = calc.max(L(24), 0.42 * s)
    let cita-b = {
      if d.comilla {
        comilla-grande(s, c.tinta)
      }
      text(size: s, d.cita)
    }
    let nombre-b = pila(0.25 * tn, {
      text(size: tn, weight: 700, d.nombre)
      if d.verificado { h(0.25 * tn); insignia(0.86 * tn, c.tinta, marca: c.tarjeta) }
    }, if meta != none { text(size: 0.86 * tn, weight: 500, fill: c.suave, meta) })
    let cara = avatar(d.foto, d.iniciales, av, c0.acento, anillo: L(3) + c.tinta)
    let firma = grid(columns: (av, 1fr), column-gutter: L(20), align: left + horizon, cara, nombre-b)
    let barra = { box(width: L(96), height: L(12), fill: c0.acento); v(L(26)) }
    if d.contexto != none {
      block(below: L(32), box(stroke: L(2.5) + c.tinta, radius: 100%, inset: (x: L(20), y: L(10)),
        text(size: 0.72 * tn, weight: 700, tracking: 0.1em, upper(d.contexto))))
    }
    disponer(d.atribucion, cita-b, { barra; firma }, cara, av + L(28), L(48),
      firma-lado: { barra; nombre-b })
  }
  lamina(d, c, "subrayado", contenido, desde, hasta, insets: (60, 96), fuente: F,
    tarjeta: (w, h, sangre) => if sangre { block(width: w, height: h, fill: c.tarjeta) } else {
      box(width: w, height: h, {
        place(dx: L(16), dy: L(16), block(width: w, height: h, fill: c.tinta, radius: L(10)))
        place(block(width: w, height: h, fill: c.tarjeta, radius: L(10), stroke: L(3) + c.tinta))
      })
    })
}

#let estilos-a = (
  publicacion: publicacion,
  mensaje: mensaje,
  editorial: editorial,
  minimal: minimal,
  subrayado: subrayado,
)
