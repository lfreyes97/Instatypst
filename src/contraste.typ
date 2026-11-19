// ─────────────────────────────────────────────────────────────
//  contraste.typ — preset «contraste»: dos lados enfrentados
//
//  Reescribe el `versus-post` del primer prototipo (social.typ) con las
//  convenciones de los presets: tema de lámina, tamaños que se ajustan
//  solos a lo que cabe, y un pie con autor, obra y marca.
//
//  Dos paneles tintados —uno con el color de lo que se niega, otro con el
//  de lo que se afirma— y, en la juntura, un medallón. Cada lado lleva un
//  rótulo corto, un título y una lista de ítems con su marcador: anillo
//  vacío (niega), círculo lleno (afirma) o punto (neutro).
//
//  Se usa desde el namespace `carteles` (carteles.contraste). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "pliego.typ": pliego
#import "carteles/_temas.typ": resolver-tema
#import "carteles/_base.typ": resolver-marca

// Un ítem es un contenido o `(texto: …, rol: "afirma" | "niega" | "neutro")`.
#let _ítem(it, rol) = if type(it) == dictionary {
  (texto: it.texto, rol: it.at("rol", default: rol))
} else {
  (texto: it, rol: rol)
}

// ── carteles.contraste ──────────────────────────────────────
//   izquierda, derecha  los dos lados: diccionarios con
//                         rotulo   contenido corto en versalitas («antes»)
//                         titulo   contenido: lo que encabeza el lado
//                         items    array de ítems (ver arriba)
//                         rol      "niega" | "afirma" | "neutro": el de los
//                                  ítems que no traen el suyo (por defecto,
//                                  niega a la izquierda y afirma a la derecha)
//   titulo      contenido: un titular sobre los dos lados
//   medallon    contenido en la juntura (por defecto «vs»); none = sin medallón
//   autor, obra pie (autor en negrita, obra debajo)
//   marca       contenido abajo a la derecha (p. ej. el logo)
//   cuerpo      tamaño de los ítems; el título del lado es cuerpo-titulo
//   disposicion auto | "columnas" | "filas". auto = columnas salvo en
//               formatos más altos que 4:5 (story), donde los lados se apilan
//
// Los ítems se achican en la misma proporción (de a 5 %) hasta que ambos
// lados caben en su panel; si sobra sitio crecen hasta 1,25.
// tema: nombre de `temas-lamina` (por defecto "contraste"), diccionario de roles
// (fondo, tinta, suave, acento, afirma, niega) o `carteles.tema-desde-theme(theme.base)`.
// Los parámetros de color pisan al tema; auto = el del tema.
#let contraste(
  izquierda,
  derecha,
  titulo: none,
  medallon: [vs],
  formato: (1080, 1350),
  autor: none,
  obra: none,
  marca: none,
  tema: "contraste",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  afirma: auto,
  niega: auto,
  fuente: "Literata",
  fuente-rotulos: "Jost",
  cuerpo: 38pt,
  cuerpo-titulo: 58pt,
  cuerpo-titular: 72pt,
  disposicion: auto,
  margen: 72pt,
) = {
  let tm = resolver-tema(tema, defecto: "contraste")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let marca = resolver-marca(marca, tinta, formato)
  let suave = if suave == auto { tm.suave } else { suave }
  let acento = if acento == auto { tm.acento } else { acento }
  let afirma = if afirma == auto { tm.afirma } else { afirma }
  let niega = if niega == auto { tm.niega } else { niega }
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)

  let en-columnas = if disposicion == auto { ancho / alto >= 0.75 } else { disposicion == "columnas" }
  let color-de(rol) = if rol == "afirma" { afirma } else if rol == "niega" { niega } else { tinta }
  let lados = (
    (izquierda, "niega"),
    (derecha, "afirma"),
  )

  // marcador de un ítem, del tamaño del texto
  let marcador(rol, c) = {
    let r = 0.30 * c
    let col = color-de(rol)
    box(width: 2 * r, height: 2 * r, if rol == "niega" {
      circle(radius: r, stroke: 0.1 * c + 0pt + col, fill: none)
    } else if rol == "afirma" {
      circle(radius: r, fill: col)
    } else {
      move(dx: 0.3 * r, dy: 0.3 * r, circle(radius: 0.7 * r, fill: col))
    })
  }

  // La cabecera de un lado (rótulo y título), con todo escalado por `e`.
  let cabecera(d, rol-lado, e) = {
    let c = cuerpo * e
    let col = color-de(d.at("rol", default: rol-lado))
    set par(leading: 0.34em)
    if d.at("rotulo", default: none) != none {
      text(font: fuente-rotulos, size: 0.6 * c, weight: 600, tracking: 0.2em, fill: col, upper(d.rotulo))
      v(0.5 * c)
    }
    if d.at("titulo", default: none) != none {
      text(size: cuerpo-titulo * e, weight: 700, fill: tinta, d.titulo)
    }
  }

  // Filete y lista de ítems de un lado.
  let lista(d, rol-lado, e) = {
    let c = cuerpo * e
    let col = color-de(d.at("rol", default: rol-lado))
    set par(leading: 0.34em)
    line(length: 100%, stroke: 0.06 * c + col)
    v(0.8 * c)
    for it in d.at("items", default: ()) {
      let (texto, rol) = _ítem(it, d.at("rol", default: rol-lado))
      grid(
        columns: (1.3 * c, 1fr),
        align: top,
        move(dy: 0.18 * c, marcador(rol, c)),
        text(size: c, fill: tinta, texto),
      )
      v(0.62 * c)
    }
  }

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)

    // ── Zonas: titular arriba, panel en medio, pie abajo
    let hay-pie = autor != none or obra != none or marca != none
    let pie-alto = if hay-pie { 76pt } else { 0pt }
    let ancho-util = ancho - 2 * margen

    context {
      let titular = if titulo != none {
        block(width: ancho-util, text(size: cuerpo-titular, weight: 700, tracking: -0.01em, titulo))
      } else { none }
      let h-titular = if titular != none { measure(titular).height + 56pt } else { 0pt }

      let y0 = margen + h-titular
      let y1 = alto - margen - pie-alto
      let area-alto = y1 - y0

      // Geometría de los dos paneles
      let (pw, ph) = if en-columnas { (ancho-util / 2, area-alto) } else { (ancho-util, area-alto / 2) }
      let relleno = 44pt
      let (iw, ih) = (pw - 2 * relleno, ph - 2 * relleno)
      let origen(i) = if en-columnas { (margen + i * pw, y0) } else { (margen, y0 + i * ph) }

      // Un lado entero: la cabecera con el alto de la mayor de las dos, para
      // que los filetes y las listas queden a la misma altura.
      let alto-cab(e) = calc.max(..lados.map(((d, r)) => measure(width: iw, cabecera(d, r, e)).height))
      let entero(d, r, e) = {
        block(width: iw, height: alto-cab(e), cabecera(d, r, e))
        v(0.5 * cuerpo * e)
        lista(d, r, e)
      }

      // El tamaño: el mayor (hasta 1,6) con el que ambos lados caben
      let cabe(e) = lados.all(((d, r)) => measure(width: iw, entero(d, r, e)).height <= ih)
      let e = 1.6
      while e > 0.4 and not cabe(e) { e -= 0.05 }

      if titular != none { place(dx: margen, dy: margen, titular) }

      for (i, (d, r)) in lados.enumerate() {
        let (x, y) = origen(i)
        let col = color-de(d.at("rol", default: r))
        place(dx: x, dy: y, rect(width: pw, height: ph, fill: col.transparentize(90%), stroke: none))
        place(dx: x, dy: y, rect(width: pw, height: 7pt, fill: col, stroke: none))
        place(dx: x + relleno, dy: y + relleno, block(width: iw, entero(d, r, e)))
      }

      // El medallón, en la juntura de los dos paneles
      if medallon != none {
        let rad = 38pt
        let (mx, my) = if en-columnas { (margen + pw, y0) } else { (margen + pw / 2, y0 + ph) }
        place(dx: mx - rad, dy: my - rad, circle(
          radius: rad, fill: tinta, stroke: 6pt + fondo,
          align(center + horizon, text(font: fuente-rotulos, size: 30pt, weight: 700, style: "italic", fill: fondo, medallon)),
        ))
      }
    }

    // ── Pie: atribución + marca
    if hay-pie {
      place(dx: margen, dy: alto - margen - 54pt, block(width: ancho-util, {
        set text(font: fuente-rotulos, size: 24pt, fill: suave)
        grid(
          columns: (1fr, auto),
          align: (left + bottom, right + bottom),
          [#if autor != none { text(weight: 600, fill: tinta, autor) } \ #obra],
          if marca != none { marca },
        )
      }))
    }
  })
}
