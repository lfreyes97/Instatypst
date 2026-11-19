// ─────────────────────────────────────────────────────────────
//  evento.typ — preset «evento»: la fecha como protagonista
//
//  Reescribe el `event-post` del primer prototipo (social.typ). En vez de
//  una cajita con el día, la fecha es el elemento tipográfico: el número
//  enorme y, a su lado, el mes en versalitas espaciadas. Debajo de un filete
//  baja el título, con el detalle (lugar, hora) y, al pie, la llamada a la
//  acción en una píldora de contorno.
//
//  Se usa desde el namespace `carteles` (carteles.evento). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "pliego.typ": pliego
#import "carteles/_temas.typ": resolver-tema
#import "carteles/_base.typ": ajustar-alto, resolver-marca

// ── carteles.evento ─────────────────────────────────────────
//   dia, mes    la fecha: el día (número o texto) y el mes como se quiera ver
//               («nov», «noviembre»); el mes va en versalitas
//   titulo      contenido: el nombre del evento
//   detalle     contenido: lugar, hora… bajo el título
//   etiqueta    contenido corto sobre la fecha («Conferencia»)
//   llamada     contenido: la llamada a la acción, en una píldora al pie
//   marca       contenido abajo a la derecha (p. ej. el logo)
//   cuerpo-titulo, cuerpo-detalle  tamaños máximos (el título crece más en
//               formatos altos); el título se achica solo hasta caber entre
//               el filete y el pie
// tema: nombre de `temas-lamina` (por defecto "evento"), diccionario de roles
// (fondo, tinta, suave, acento) o `carteles.tema-desde-theme(theme.base)`.
// Los parámetros de color pisan al tema; auto = el del tema.
#let evento(
  dia,
  mes,
  titulo,
  detalle: none,
  etiqueta: none,
  llamada: none,
  formato: (1080, 1350),
  marca: none,
  tema: "evento",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  fuente: "Literata",
  fuente-rotulos: "Jost",
  cuerpo-titulo: 116pt,
  cuerpo-detalle: 40pt,
  margen: 84pt,
) = {
  let tm = resolver-tema(tema, defecto: "evento")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let marca = resolver-marca(marca, tinta, formato)
  let suave = if suave == auto { tm.suave } else { suave }
  let acento = if acento == auto { tm.acento } else { acento }
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let util = ancho - 2 * margen

  // El número se escala con el lado menor: legible en cualquier formato. En
  // los más altos que 4:5 (story) fecha y título crecen con la proporción,
  // para que el hueco del medio no se coma la pieza.
  let lado = calc.min(ancho, alto)
  let alta = if alto / ancho > 1.5 { alto / ancho / 1.25 } else { 1 }
  let cuerpo-dia = lado * 0.30 * alta
  let cuerpo-mes = lado * 0.062 * alta

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    set par(leading: 0.32em)

    // ── La fecha, arriba
    let y = margen
    if etiqueta != none {
      place(dx: margen, dy: y, text(
        font: fuente-rotulos, size: 0.0245 * lado, weight: 600, tracking: 0.22em, fill: acento, upper(etiqueta),
      ))
      y += 0.06 * lado
    }
    let fecha = grid(
      columns: (auto, 1fr),
      column-gutter: 0.04 * lado,
      align: bottom,
      text(size: cuerpo-dia, weight: 800, tracking: -0.03em, top-edge: "cap-height", bottom-edge: "baseline", [#dia]),
      pad(bottom: 0.012 * cuerpo-dia, text(
        font: fuente-rotulos, size: cuerpo-mes, weight: 700, tracking: 0.12em, fill: acento, upper(mes),
      )),
    )
    place(dx: margen, dy: y, fecha)
    context {
      let y-filete = y + measure(fecha).height + 0.045 * lado
      place(dx: margen, dy: y-filete, line(length: util, stroke: 3pt + acento))

      // ── El pie: llamada y marca, en la misma línea
      let pie = if llamada != none or marca != none {
        let pildora = if llamada != none {
          box(
            stroke: 3pt + acento, radius: 100pt, inset: (x: 38pt, y: 20pt),
            text(font: fuente-rotulos, size: 30pt, weight: 700, fill: acento, llamada),
          )
        }
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          pildora, marca,
        )
      }
      let h-pie = if pie != none { measure(block(width: util, pie)).height } else { 0pt }
      let y-pie = alto - margen - h-pie
      if pie != none { place(dx: margen, dy: y-pie, block(width: util, pie)) }

      // ── Título y detalle, abajo, sobre el pie; el título se achica hasta caber
      let separacion = if pie != none { 0.05 * lado } else { 0pt }
      let y1 = y-pie - separacion
      let y0 = y-filete + 0.05 * lado
      let detalle-bloque = if detalle != none {
        block(width: util, text(font: fuente-rotulos, size: cuerpo-detalle, fill: suave, detalle))
      }
      // el aire entre título y detalle crece con el título (los descendentes no tocan)
      let aire(s) = 0.9 * cuerpo-detalle + 0.1 * s
      let h-detalle = if detalle-bloque != none { measure(detalle-bloque).height + aire(cuerpo-titulo * alta) } else { 0pt }
      let hacer(s) = block(width: util, text(size: s, weight: 700, tracking: -0.015em, titulo))
      let s = ajustar-alto(hacer, cuerpo-titulo * alta, y1 - y0 - h-detalle, minimo: 44pt, paso: 2pt)
      let bloque = {
        hacer(s)
        if detalle-bloque != none {
          v(aire(s))
          detalle-bloque
        }
      }
      place(dx: margen, dy: y1 - measure(block(width: util, bloque)).height, block(width: util, bloque))
    }
  })
}
