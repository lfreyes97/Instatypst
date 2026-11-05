// ─────────────────────────────────────────────────────────────
//  carteles.typ — presets de color sólido + tipografía
//
//  Cada preset es UNA idea visual con nombre, cosechada de una lámina
//  de campana/ que funcionó, no una plantilla única: se elige el que
//  pide el texto. Namespace (`carteles.suizo`, a futuro
//  `carteles.escalera`, `carteles.demostracion`…), mismo patrón que
//  `formas`/`superbg`.
//
//  Un preset arma la página entera: recibe el formato en px (como
//  `sizes`) y devuelve un page(). Sin marca propia: el logo entra por
//  `marca:` como contenido ya hecho, así el paquete no conoce a nadie.
//
//  Piezas sueltas, reusables fuera de los presets:
//    reticula(ancho, …)       -> columnas: .x.at(i), .span.at(n), .util, .col
//    cuerpo-al-ancho(hacer, ancho) -> tamaño con el que hacer(tamaño)
//                                  mide exactamente `ancho` (en context)
//    rayar(cuerpo, …)         -> tachado en línea: recto o a lápiz,
//                                con letras vaciadas opcionales
//    area-trabajo(formato, area:, ancla:) -> (x, y, ancho, alto): la parte
//                                de la página que usa un preset (el resto
//                                queda libre); encajar(rect, base, ancla:,
//                                escala:) -> (ox, oy, s): una lámina de
//                                referencia escalada y apoyada en ella
//
//  Presets en archivo propio (cada uno con su lámina de origen):
//    escalera      (04) la frase baja en peldaños hasta un clímax, sobre
//                  curvas de nivel (curvas-de-nivel) — escalera.typ
//    gozne, llamada (07) cita con llamadas + diagrama radial — gozne.typ
//    linea-tiempo  (16) estaciones sobre una línea vertical — linea-tiempo.typ
//    esquela       (10) aviso fúnebre de imprenta: orla de luto, cruz, el
//                  «difunto» en versalitas — esquela.typ
//    bauhaus       formas primarias y barra diagonal sobre papel crudo,
//                  remate en minúsculas de sans geométrica — carteles/bauhaus.typ
//                  (mismo contrato que suizo: se cambia de estilo cambiando el nombre)
//    mosaico       diez arcos paralelos («C» o «U» a 45°) con círculos y
//                  un rombo; tres variantes con los colores rotando —
//                  carteles/mosaico.typ (portada gráfica: autor y obra; con
//                  frase, título y pila que buscan su sitio; `area`, `ancla`
//                  y `arte` acotan y achican la composición)
//    teselas       bloque cuadrado de teselas (discos y «dianas») en tres colores
//                  que rotan, con título, párrafo y una palabra apilada —
//                  carteles/teselas.typ
//    epigrafe      cita breve con autor y obra, en quince estilos (clásicos, geométricos,
//                  atmosféricos) — carteles/epigrafe.typ
//    hojas         la «hoja» (cuadrado con tres esquinas redondeadas y un anillo)
//                  en flor, en par diagonal o en cinta a 45°, en amarillo y azul,
//                  con título pesado, párrafo y rótulo vertical — carteles/hojas.typ
//                  (la pieza suelta: carteles.hoja, de carteles/_hojas-piezas.typ)
//    folio         (11) folio de salterio: pergamino pautado, capitular
//                  iluminada, glosa al margen — folio.typ
//
//  Presets con orla de fleurones e IM FELL (viven en orlas.typ):
//    cita-orlada, capitulo-orlado, pregunta-orlada, lienzo-orlado,
//    temas-orla
// ─────────────────────────────────────────────────────────────

#import "superbg/lib.typ" as superbg
#import "orlas.typ": lienzo-orlado, cita-orlada, capitulo-orlado, pregunta-orlada, temas as temas-orla
#import "escalera.typ": escalera, curvas-de-nivel
#import "gozne.typ": gozne, llamada
#import "linea-tiempo.typ": linea-tiempo
#import "esquela.typ": esquela
#import "folio.typ": folio
#import "carteles/_base.typ": medida, escala, area-trabajo, encajar, cuerpo-al-ancho, ajustar-alto
#import "carteles/_temas.typ": temas-lamina, resolver-tema, tema-desde-theme
#import "carteles/bauhaus.typ": bauhaus
#import "carteles/mosaico.typ": mosaico
#import "carteles/teselas.typ": teselas
#import "carteles/hojas.typ": hojas
#import "carteles/epigrafe.typ": epigrafe, estilos-epigrafe
#import "carteles/cita-social.typ": cita-social
#import "carteles/_hojas-piezas.typ": hoja

// Retícula de columnas sobre `ancho` (largo). `x.at(i)`: borde
// izquierdo de la columna i (desde 0); `span.at(n)`: ancho de n columnas
// con sus medianiles (`span.at(0)` = 0pt). Mismo orden de operaciones que la lámina 01 a mano, para
// que los resultados coincidan al punto flotante.
#let reticula(ancho, columnas: 6, margen: 64pt, medianil: 24pt) = {
  let util = ancho - 2 * margen
  let col = (util - (columnas - 1) * medianil) / columnas
  (
    columnas: columnas,
    margen: margen,
    medianil: medianil,
    util: util,
    col: col,
    x: range(columnas).map(i => margen + i * (col + medianil)),
    span: (0pt,) + range(1, columnas + 1).map(n => n * col + (n - 1) * medianil),
  )
}

// `cuerpo-al-ancho`, `ajustar-alto`, `medida` y `escala` viven en
// carteles/_base.typ (por debajo de los presets, para que `esquela` y
// `folio` puedan usarlos sin ciclo de import) y se re-exportan aquí.

// Tachado en línea, para negar una palabra o un prefijo dentro de la
// frase (se usa como cualquier texto: #rayar[ir]racional).
//   trazo: "recto" -> strike de Typst a media altura de las mayúsculas
//                     (lámina 17)
//          "lapiz" -> línea de corrector a mano alzada, apenas
//                     inclinada y más larga que la palabra (lámina 09)
//   vaciar: (fondo: color, contorno: stroke) -> las letras quedan en
//           contorno, rellenas con el color del fondo
#let rayar(cuerpo, color: rgb("#d0342c"), trazo: "recto", grosor: auto, vaciar: none) = {
  let cuerpo = if vaciar == none { cuerpo } else { text(fill: vaciar.fondo, stroke: vaciar.contorno, cuerpo) }
  if trazo == "recto" {
    let g = if grosor == auto { 0.053em } else { grosor }
    strike(stroke: g + color, offset: -0.26em, extent: 0.08em, cuerpo)
  } else if trazo == "lapiz" {
    let g = if grosor == auto { 0.086em } else { grosor }
    box(context {
      let w = measure(cuerpo).width
      cuerpo
      place(top + left, line(
        start: (-0.24em, 0.52em), end: (w + 0.28em, 0.34em),
        stroke: (paint: color, thickness: g, cap: "round"),
      ))
    })
  } else {
    panic("rayar: trazo debe ser \"recto\" o \"lapiz\", no " + repr(trazo))
  }
}

// ── carteles.suizo ──────────────────────────────────────────
// Cartel suizo (lámina 01): una palabra-remate ocupa todo el ancho útil
// en un solo color de acento; el resto de la frase, chico y en sans,
// cuelga de una retícula de columnas visible, y una flecha baja de la
// frase a la palabra. Cabecera y pie entre filetes.
//
//   frase    contenido: lo que se lee antes del remate
//   remate   la palabra que llena el ancho (str o contenido)
//   autor, fechas            cabecera (izquierda / columna 3)
//   etiqueta, planteo        bloque superior: rótulo en acento + pregunta
//   marca    contenido para el pie (p. ej. el logo), abajo a la izquierda
//   tema     nombre de `temas-lamina`, diccionario (fondo, tinta, suave,
//            acento, linea) o `tema-desde-theme(theme.base)`; por defecto
//            "suizo". `papel`, `tinta`, `gris`, `acento` y `linea`, si se
//            pasan, pisan al tema (auto = el del tema).
//   frase-y, flecha-hasta    auto = la frase se apoya `aire` por encima
//                            del remate y la flecha llega a mitad de ese
//                            aire; un largo los fija a mano
//
// Se acomoda solo al formato y al largo del texto: la frase nunca sube
// por encima del planteo (se achica si hace falta) y en apaisado el
// remate se limita por el alto.
#let suizo(
  frase,
  remate,
  formato: (1080, 1350),
  autor: none,
  fechas: none,
  etiqueta: none,
  planteo: none,
  marca: none,
  tema: "suizo",
  papel: auto,
  tinta: auto,
  acento: auto,
  linea: auto,
  gris: auto,
  fuente: "Hanken Grotesk",
  fuente-rotulos: "Inter",
  fuente-remate: "Bebas Neue",
  cuerpo-frase: 66pt,
  columnas: 6,
  margen: 64pt,
  medianil: 24pt,
  aire: 150pt,
  flecha: true,
  frase-y: auto,
  flecha-hasta: auto,
) = {
  let (ancho, alto) = medida(formato)
  let tm = resolver-tema(tema, defecto: "suizo")
  let papel = if papel == auto { tm.fondo } else { papel }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let acento = if acento == auto { tm.acento } else { acento }
  let linea = if linea == auto { tm.linea } else { linea }
  let gris = if gris == auto { tm.suave } else { gris }
  let r = reticula(ancho, columnas: columnas, margen: margen, medianil: medianil)
  // ancho de la frase y del planteo: las primeras 2/3 de las columnas
  let ancho-frase = r.span.at(calc.ceil(columnas * 2 / 3))
  let rotulo(cuerpo, ..args) = text(font: fuente-rotulos, size: 22pt, ..args, cuerpo)

  page(width: ancho, height: alto, margin: 0pt, fill: papel, {
    set text(font: fuente, fill: tinta, lang: "es")
    set par(leading: 0.42em)

    // ── retícula visible: bordes de columna en filete fino ──
    for i in range(columnas) {
      place(top + left, dx: r.x.at(i), line(start: (0pt, 0pt), end: (0pt, alto), stroke: 0.8pt + linea))
      place(top + left, dx: r.x.at(i) + r.col, line(start: (0pt, 0pt), end: (0pt, alto), stroke: 0.8pt + linea))
    }

    // ── cabecera ──
    place(top + left, dx: margen, dy: margen, line(length: r.util, stroke: 2.5pt + tinta))
    if autor != none {
      place(top + left, dx: r.x.at(0), dy: margen + 18pt, rotulo(weight: 700, tracking: 0.12em, autor))
    }
    if fechas != none {
      place(top + left, dx: r.x.at(calc.floor(columnas / 2)), dy: margen + 18pt, rotulo(weight: 400, fill: gris, fechas))
    }

    // ── el planteo, arriba ──
    let bloque-planteo = if etiqueta != none or planteo != none {
      block(width: ancho-frase, {
        if etiqueta != none { rotulo(weight: 700, tracking: 0.12em, fill: acento, etiqueta) }
        v(4pt)
        if planteo != none { text(font: fuente-rotulos, size: 44pt, weight: 400, fill: gris, tracking: -0.01em, planteo) }
      })
    }
    if bloque-planteo != none { place(top + left, dx: r.x.at(0), dy: 196pt, bloque-planteo) }

    context {
      // Techo: hasta dónde puede subir la frase sin pisar lo de arriba.
      let techo = 40pt + if bloque-planteo != none { 196pt + measure(bloque-planteo).height } else { margen + 48pt }
      let base = alto - 150pt // el remate se apoya acá

      // ── remate: todo el ancho útil ──
      // En apaisado, medido por el ancho se comería el alto: no pasa del
      // 55 % del hueco entre el techo y la base (y deja de llenar el ancho).
      let palabra(s) = text(font: fuente-remate, size: s, fill: acento, top-edge: "cap-height", bottom-edge: "baseline", remate)
      let s = calc.min(
        cuerpo-al-ancho(palabra, r.util),
        100pt * (0.55 * (base - techo) / measure(palabra(100pt)).height),
      )
      let caja = palabra(s)
      let remate-y = base - measure(caja).height
      place(top + left, dx: margen - 0.035 * s, dy: remate-y, caja)

      // ── la frase, chica, sobre las primeras columnas ──
      // Si no cabe entre el techo y el remate (dejando al menos 48pt de
      // aire), se achica de a 2pt; el aire se encoge antes que la letra.
      let bloque(c) = block(width: ancho-frase, text(size: c, weight: 500, tracking: -0.015em, frase))
      let hueco = remate-y - techo
      let c = ajustar-alto(bloque, cuerpo-frase, hueco - 48pt)
      let b = bloque(c)
      let fh = measure(b).height
      let aire = calc.min(aire, hueco - fh)
      let fy = if frase-y == auto { remate-y - aire - fh } else { frase-y }
      place(top + left, dx: r.x.at(0), dy: fy, b)

      // ── flecha fina de la frase a la palabra, en la última columna ──
      if flecha {
        let desde = fy + 14pt
        let hasta = if flecha-hasta == auto { remate-y - aire / 2 } else { flecha-hasta }
        let largo = hasta - desde - 8pt // la punta (26pt) arranca 18pt antes del final de la línea
        place(top + left, dx: r.x.at(columnas - 1) + r.col / 2, dy: desde, {
          line(start: (0pt, 0pt), end: (0pt, largo), stroke: 3pt + acento)
          place(top + left, dx: -14pt, dy: largo - 18pt, polygon(fill: acento, (0pt, 0pt), (28pt, 0pt), (14pt, 26pt)))
        })
      }
    }

    // ── pie ──
    place(bottom + left, dx: margen, dy: -112pt, line(length: r.util, stroke: 2.5pt + tinta))
    if marca != none { place(bottom + left, dx: r.x.at(0), dy: -margen + 3pt, marca) }
  })
}

// ── carteles.demostracion ───────────────────────────────────
// La cita como demostración numerada, en pizarra (lámina 17): renglones
// numerados en mono; la palabra que se sostiene, enorme, con ⊢; la que
// no se sigue, con ⊬. Una raya de deducción punteada separa los grupos.
//
//   grupos   array de grupos; cada grupo, un array de renglones (un solo
//            grupo puede pasarse plano). Un renglón es:
//              contenido        -> renglón de lectura
//              (afirma: c)      -> c enorme en `claro`, signo ⊢ en acento
//              (niega: c)       -> c enorme en `texto`, signo ⊬ apagado
//            y acepta `signo:` y `cuerpo:` para pisar los de siempre.
//            El tamaño enorme, por defecto, llena la columna (hasta
//            `cuerpo-max`, para que una palabra corta no se dispare).
//   autor, obra    pie en mono, abajo a la izquierda
//   marca          contenido abajo a la derecha (p. ej. el logo)
//   inicio         y del primer grupo; auto = el bloque reparte el aire
//                  libre 1:2 (arriba:abajo) entre el margen y el pie
//
// Si el bloque no cabe en el alto (apaisado, demasiados renglones),
// todo se achica en la misma proporción.
// tema: nombre de `temas-lamina` (por defecto "demostracion"), diccionario de roles
// (fondo, tinta, suave, acento…) o `carteles.tema-desde-theme(theme.base)`.
// Los parámetros de color (`fondo`, `claro`, `texto` (tinta), `apagado` (suave), `acento`) pisan al tema; auto = el del tema.
#let demostracion(
  grupos,
  formato: (1080, 1080),
  autor: none,
  obra: none,
  marca: none,
  tema: "demostracion",
  fondo: auto,
  claro: auto,
  texto: auto,
  apagado: auto,
  acento: auto,
  fuente: "Instrument Sans",
  fuente-mono: "DM Mono",
  cuerpo-lectura: 58pt,
  cuerpo-max: 232pt,
  margen: 84pt,
  aire-raya: (arriba: 76pt, abajo: 44pt),
  cuadricula: true,
  inicio: auto,
) = {
  let tm = resolver-tema(tema, defecto: "demostracion")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let claro = if claro == auto { tm.claro } else { claro }
  let texto = if texto == auto { tm.tinta } else { texto }
  let apagado = if apagado == auto { tm.suave } else { apagado }
  let acento = if acento == auto { tm.acento } else { acento }
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let caja = ancho - 2 * margen
  let (col-n, col-signo) = (64pt, 48pt)
  // un solo grupo plano -> lista de un grupo
  let grupos = if grupos.len() > 0 and type(grupos.at(0)) != array { (grupos,) } else { grupos }

  let mono(cuerpo, color: apagado, size: 24pt) = text(font: fuente-mono, size: size, fill: color, cuerpo)
  let numero(i) = mono(if i < 10 { "0" + str(i) } else { str(i) })
  let destacar(c, tono, s) = box(text(size: s, weight: 700, fill: tono, tracking: -0.02em, c))

  // celdas de un grupo, con todo escalado por `e` (1 = tamaños de siempre)
  let filas(grupo, desde, e) = {
    let celdas = ()
    for (k, r) in grupo.enumerate() {
      celdas.push(numero(desde + k))
      if type(r) == dictionary {
        let afirma = "afirma" in r
        let c = if afirma { r.afirma } else { r.niega }
        let tono = if afirma { claro } else { texto }
        let s = r.at("cuerpo", default: auto)
        // llena la columna, pero una palabra corta no pasa de `cuerpo-max`
        let s = if s == auto {
          calc.min(cuerpo-max, cuerpo-al-ancho(t => destacar(c, tono, t), 0.98 * (caja - col-n - col-signo)))
        } else { s }
        celdas.push(destacar(c, tono, s * e))
        let signo = r.at("signo", default: if afirma { "⊢" } else { "⊬" })
        celdas.push(text(font: fuente-mono, size: 52pt * e, fill: if afirma { acento } else { apagado }, signo))
      } else {
        celdas.push(text(size: cuerpo-lectura * e, r))
        celdas.push([])
      }
    }
    block(width: caja, grid(
      columns: (col-n, 1fr, col-signo),
      align: (left + horizon, left + horizon, right + horizon),
      row-gutter: 18pt * e,
      ..celdas,
    ))
  }

  page(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: texto, lang: "es", hyphenate: false)

    // ── retícula de cuaderno de cálculo, muy tenue ──
    if cuadricula {
      place(superbg.bg-patron(patron: "grid", color: claro, paso: 54, grosor: 1, opacidad: 5%, size: formato))
    }

    // ── pie ──
    let pie = block(width: caja, grid(
      columns: (1fr, auto),
      align: (left + bottom, right + bottom),
      if autor != none or obra != none {
        mono(color: texto)[— #autor \ #h(1.2em)#text(fill: apagado, obra)]
      },
      if marca != none { marca },
    ))
    place(bottom + left, dx: margen, dy: -76pt, pie)

    context {
      // numeración corrida entre grupos
      let desde = (1,)
      for g in grupos { desde.push(desde.last() + g.len()) }
      let medir(e) = {
        let bloques = grupos.enumerate().map(((i, g)) => filas(g, desde.at(i), e))
        let alto-total = bloques.map(b => measure(b).height).sum() + (grupos.len() - 1) * (aire-raya.arriba + aire-raya.abajo) * e
        (bloques, alto-total)
      }
      // espacio disponible: entre el margen y el pie
      let techo = margen
      let piso = alto - 76pt - measure(pie).height - 40pt
      let e = 1.0
      let (bloques, total) = medir(e)
      while total > piso - techo and e > 0.3 {
        e -= 0.05
        (bloques, total) = medir(e)
      }
      let y = if inicio == auto { techo + (piso - techo - total) / 3 } else { inicio }
      for (i, b) in bloques.enumerate() {
        if i > 0 {
          y += aire-raya.arriba * e
          // raya de deducción, desde la columna del texto
          place(dx: margen + col-n, dy: y, line(length: caja - col-n, stroke: (paint: apagado, thickness: 2pt, dash: (6pt, 8pt))))
          y += aire-raya.abajo * e
        }
        place(dx: margen, dy: y, b)
        y += measure(b).height
      }
    }
  })
}
