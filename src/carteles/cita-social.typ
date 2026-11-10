// ─────────────────────────────────────────────────────────────
//  carteles/cita-social.typ — cita con su autor (foto o iniciales), como
//  las tarjetas de LinkedIn: la cita y la atribución juntas
//
//    #carteles.cita-social(
//      [Una obra pseudónima… una #highlight[obra diabólica]: …],
//      [Luis Felipe Reyes de los Reyes], iniciales: "LR",
//      foto: "/examples/avatar.jpg", formato: (1080, 1920))
//
//    #carteles.cita-social([…], [Ana Ruiz], estilo: "publicacion",
//      usuario: "@anaruiz", fecha: "5 nov 2026", verificado: true,
//      metricas: (comentarios: 48, compartidos: 310, me-gusta: 1234))
//
//  El cuerpo de la cita se ajusta solo: el mayor tamaño (hasta `cuerpo`) con
//  el que todo cabe en el área de trabajo; si no cabe ni a `minimo` (22 por
//  cada 1080 de ancho), error con mensaje. Para resaltar palabras usa el
//  `#highlight[…]` de Typst (cada estilo lo pinta a su manera).
//
//  estilo     el aspecto (cada uno con su tema propio en `temas-lamina`):
//             "clasico"     tarjeta blanca sobre fondo oscuro (por defecto)
//             "publicacion" publicación genérica de red social
//             "mensaje"     burbuja de chat con cola
//             "editorial"   serif grande entre filetes
//             "papel"       hoja crema con grano, tinta sepia
//             "pizarra"     encerado con marco y tiza
//             "recorte"     recorte de periódico rasgado
//             "aura"        halos vivos y tarjeta de cristal
//             "minimal"     mucho aire, una línea
//             "subrayado"   el rotulador como protagonista
//             (qué campos y qué variantes usa cada estilo: cabeceras de
//             _cita-social-estilos-a.typ y -b.typ)
//  variante   "tarjeta"  la tarjeta flota centrada sobre el fondo (por defecto)
//             "sangre"   la tarjeta llena el área entera, de borde a borde
//             "abierta"  sin tarjeta: la cita directa sobre el fondo
//  atribucion "abajo" (por defecto) | "arriba" | "lado": la foto a la
//             izquierda, la cita a la derecha
//  comilla    la comilla grande y decorativa sobre la cita
//
//  Contenido opcional (none/false: no aparece; el clásico los muestra todos):
//  usuario    "@alguien", junto o bajo el nombre
//  fecha      texto o contenido ("5 nov 2026", "10:24 · 5 nov 2026")
//  verificado true: una insignia (círculo con visto, dibujada) tras el nombre
//  metricas   (comentarios:, compartidos:, me-gusta:, vistas:): números
//             (1234 → «1,2 mil», 2500000 → «2,5 M») o textos
//  contexto   de dónde sale la cita: «En respuesta a @x», «De _La obra_»
//  respuesta  la publicación citada: contenido o (texto:, nombre:, usuario:)
//
//  foto: ruta a una imagen (con `/` inicial: relativa a la raíz del proyecto).
//  nota-izq, nota-der: (icono:, texto:) o none; solo en el estilo clásico,
//  variante «tarjeta».
//  marca: contenido para el pie, centrado abajo del área.
//
//  tema: nombre de `temas-lamina`, diccionario (fondo, tarjeta, tinta, suave,
//  acento, linea) o `tema-desde-theme(theme.base)`; por defecto "cita-social",
//  que en los demás estilos significa «el tema del estilo» ("cita-papel"…).
//  `fondo`, `tarjeta`, `tinta`, `suave`, `acento` y `linea` pisan al tema.
//  `fuente`, `cuerpo` y `minimo` en su valor por defecto dejan los del
//  estilo; cualquier otro valor manda.
//
//  Reemplaza a `quote-social` (social.typ). Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────
#import "../pliego.typ": pliego
#import "_base.typ": medida, escala, area-trabajo, ajustar-alto
#import "_temas.typ": resolver-tema
#import "../contrast.typ": readable-on
#import "_cita-social-comun.typ": validar-contenido, meta-de, respuesta-de, insignia, fila-metricas, pila
#import "_cita-social-estilos-a.typ": estilos-a
#import "_cita-social-estilos-b.typ": estilos-b

#let _fuente-clasica = ("Inter", "DM Sans", "Public Sans", "Liberation Sans")
#let estilos-cita-social = ("clasico", ..estilos-a.keys(), ..estilos-b.keys())

#let cita-social(
  cita,
  nombre,
  iniciales: "??",
  foto: none,
  atribucion: "abajo",
  variante: "tarjeta",
  comilla: false,
  nota-izq: none,
  nota-der: none,
  formato: (1080, 1350),
  tema: "cita-social",
  fondo: auto,
  tarjeta: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  linea: auto,
  marca: none,
  fuente: ("Inter", "DM Sans", "Public Sans", "Liberation Sans"),
  cuerpo: 92,
  minimo: 22,
  area: 1,
  ancla: center + horizon,
  estilo: "clasico",
  usuario: none,
  fecha: none,
  verificado: false,
  metricas: none,
  contexto: none,
  respuesta: none,
) = {
  if atribucion not in ("abajo", "arriba", "lado") {
    panic("cita-social: atribucion es \"abajo\", \"arriba\" o \"lado\", no " + repr(atribucion))
  }
  if variante not in ("tarjeta", "sangre", "abierta") {
    panic("cita-social: variante es \"tarjeta\", \"sangre\" o \"abierta\", no " + repr(variante))
  }
  if estilo not in estilos-cita-social {
    panic("cita-social: estilo desconocido " + repr(estilo) + " — disponibles: " + estilos-cita-social.join(", "))
  }
  let d = (
    cita: cita, nombre: nombre, iniciales: iniciales, foto: foto, atribucion: atribucion,
    variante: variante, comilla: comilla, formato: formato, tema: tema, marca: marca,
    colores: (fondo: fondo, tarjeta: tarjeta, tinta: tinta, suave: suave, acento: acento, linea: linea),
    fuente: if fuente == _fuente-clasica { none } else { fuente },
    cuerpo: if cuerpo == 92 { none } else { cuerpo },
    minimo: if minimo == 22 { none } else { minimo },
    area: area, ancla: ancla,
    usuario: usuario, fecha: fecha, verificado: verificado, metricas: metricas,
    contexto: contexto, respuesta: respuesta,
  )
  validar-contenido(d)
  if estilo != "clasico" {
    return ((estilos-a + estilos-b).at(estilo))(d)
  }
  let (ancho, alto) = medida(formato)
  let tm = resolver-tema(tema, defecto: "cita-social")
  let c = (
    fondo: if fondo == auto { tm.fondo } else { fondo },
    tarjeta: if tarjeta == auto { tm.tarjeta } else { tarjeta },
    tinta: if tinta == auto { tm.tinta } else { tinta },
    suave: if suave == auto { tm.suave } else { suave },
    acento: if acento == auto { tm.acento } else { acento },
    linea: if linea == auto { tm.linea } else { linea },
  )
  // sin tarjeta, el texto va directo sobre el fondo: el color que más contraste
  let abierta = variante == "abierta"
  let texto-c = if abierta { readable-on(c.fondo, c.tarjeta, c.tinta) } else { c.tinta }
  let suave-c = if abierta { texto-c.transparentize(30%) } else { c.suave }
  let linea-c = if abierta { texto-c.transparentize(75%) } else { c.linea }

  // medidas pensadas sobre 1080 × 1350; el lado menor del formato manda
  let k = escala(formato, base: (1080, 1350))
  let L(u) = u * k * 1pt
  let (ax, ay, aw, ah) = area-trabajo(formato, area: area, ancla: ancla, quien: "cita-social")
  let margen = L(72)
  let pie = if marca != none { L(120) } else { 0pt }
  let sangre = variante == "sangre"
  let inset = if abierta { 0pt } else if sangre { L(80) } else { L(48) }
  // la tarjeta (o el texto) ocupa el área menos el margen; la de sangre, toda
  let caja-w = if sangre { aw } else { aw - 2 * margen }
  let caja-h = if sangre { ah } else { ah - 2 * margen - pie }
  let ancho-int = caja-w - 2 * inset
  let alto-int = caja-h - 2 * inset

  // la atribución crece con la cita (una cita grande pide una cara grande)
  let av-de(s) = calc.max(L(64), calc.min(1.25 * s, L(120)))
  let nombre-de(s) = calc.max(L(26), 0.5 * s)
  // el contenido opcional (usuario, fecha, verificado, contexto, métricas,
  // respuesta): sin él, cada rama sale exactamente como antes
  let meta = meta-de(d)
  let con-meta = meta != none or verificado
  let resp = respuesta-de(respuesta)
  let nombre-meta(s) = {
    let tn = nombre-de(s)
    pila(0.25 * tn, {
      text(size: tn, weight: 700, fill: texto-c, nombre)
      if verificado { h(0.25 * tn); insignia(0.86 * tn, c.acento, marca: readable-on(c.acento, white, black)) }
    }, if meta != none { text(size: 0.8 * tn, fill: suave-c, meta) })
  }
  let atribucion-bloque(s) = {
    let av = av-de(s)
    let nombre-t = if con-meta { nombre-meta(s) } else { text(size: nombre-de(s), weight: 700, fill: texto-c, nombre) }
    let cara = if foto != none {
      box(clip: true, radius: 100%, width: av, height: av, image(foto, width: av, height: av, fit: "cover"))
    } else {
      box(width: av, height: av, radius: 100%, fill: c.acento, align(center + horizon,
        text(size: av * 0.38, weight: 800, fill: readable-on(c.acento, white, black), iniciales)))
    }
    grid(columns: (av, 1fr), gutter: L(20), align: (left, left + horizon), cara, nombre-t)
  }
  let divisor = {
    v(L(32))
    line(length: 100%, stroke: 0.75pt + linea-c)
    v(L(24))
  }
  let cita-bloque(s) = {
    set par(leading: 0.5em, spacing: 0.9em)
    if comilla {
      text(size: s * 1.8, fill: c.acento, font: fuente, "\u{201C}")
      v(-s * 1.1)
    }
    if contexto != none {
      block(below: L(18), text(size: calc.max(L(20), 0.42 * s), fill: suave-c, contexto))
    }
    text(size: s, fill: texto-c, cita)
    if resp != none {
      let tn = nombre-de(s)
      block(above: L(28), width: 100%, stroke: 0.75pt + linea-c, radius: L(16), inset: L(24), {
        if resp.nombre != none or resp.usuario != none {
          block(below: L(10), {
            if resp.nombre != none { text(size: 0.8 * tn, weight: 700, fill: texto-c, resp.nombre) }
            if resp.usuario != none { h(0.35 * tn); text(size: 0.75 * tn, fill: suave-c, resp.usuario) }
          })
        }
        text(size: calc.max(L(20), 0.66 * s), fill: texto-c, resp.texto)
      })
    }
  }
  let metricas-bloque(s) = if metricas != none {
    let tn = nombre-de(s)
    v(L(28))
    fila-metricas(metricas, 0.95 * tn, suave-c, size: 0.8 * tn)
  }
  // el contenido entero, a tamaño de cita `s`
  let contenido(s) = {
    set text(font: fuente, lang: "es")
    if atribucion == "arriba" {
      atribucion-bloque(s); divisor; cita-bloque(s)
    } else if atribucion == "abajo" {
      cita-bloque(s); divisor; atribucion-bloque(s)
    } else {
      // «lado»: la cara arriba a la izquierda y la cita al lado, con el nombre debajo
      let av = av-de(s)
      grid(columns: (av + L(28), 1fr), gutter: 0pt,
        if foto != none {
          box(clip: true, radius: 100%, width: av, height: av, image(foto, width: av, height: av, fit: "cover"))
        } else {
          box(width: av, height: av, radius: 100%, fill: c.acento, align(center + horizon,
            text(size: av * 0.38, weight: 800, fill: readable-on(c.acento, white, black), iniciales)))
        },
        {
          cita-bloque(s)
          v(L(26))
          if con-meta { nombre-meta(s) } else { text(size: nombre-de(s), weight: 700, fill: texto-c, nombre) }
        },
      )
    }
    metricas-bloque(s)
  }
  let bloque(s) = block(width: ancho-int, contenido(s))

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    let desde = cuerpo * k * 1pt
    let hasta = minimo * k * 1pt
    let s = ajustar-alto(bloque, desde, alto-int, minimo: hasta, paso: 1pt)
    let b = bloque(s)
    let h = measure(b).height
    if h > alto-int + 0.5pt {
      panic("cita-social: la cita no cabe en el área ni al tamaño mínimo (" + repr(minimo) + " por cada 1080 de ancho): acórtala, usa un formato más alto, `variante: \"abierta\"` o baja `minimo`")
    }
    // dónde va el recuadro: de sangre, el área entera; si no, centrado en lo que queda sobre el pie
    let (bx, by, bw, bh) = if sangre {
      (ax, ay, aw, ah)
    } else {
      (ax + margen, ay + margen + (ah - 2 * margen - pie - (h + 2 * inset)) / 2, caja-w, h + 2 * inset)
    }
    if variante == "tarjeta" or sangre {
      place(top + left, dx: bx, dy: by,
        block(width: bw, height: bh, fill: c.tarjeta, radius: if sangre { 0pt } else { L(24) }, inset: inset,
          align(horizon, b)))
    } else {
      place(top + left, dx: bx, dy: by, block(width: bw, b))
    }
    // notas decorativas, bajo las esquinas de la tarjeta (sobre el fondo)
    if variante == "tarjeta" {
      let sobre-fondo = readable-on(c.fondo, c.tarjeta, c.tinta)
      let nota(n, dx) = place(top + left, dx: dx, dy: by + bh + L(14),
        box(width: L(120), align(center, {
          text(size: L(40), n.icono); linebreak()
          text(font: fuente, size: L(22), fill: sobre-fondo, weight: 600, n.texto)
        })))
      if nota-izq != none { nota(nota-izq, bx) }
      if nota-der != none { nota(nota-der, bx + bw - L(120)) }
    }
    if marca != none {
      place(top + left, dx: ax, dy: ay + ah - margen - L(40), box(width: aw, align(center,
        text(font: fuente, fill: readable-on(c.fondo, c.tarjeta, c.tinta), marca))))
    }
  })
}
