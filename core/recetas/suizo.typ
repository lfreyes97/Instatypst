// ─────────────────────────────────────────────────────────────
//  core/recetas/suizo.typ — una receta construida sobre primitivas
//
//  Misma API y misma composición que carteles.suizo: la página la
//  arma esta receta; las primitivas solo miden, resuelven el tema,
//  tienden la retícula y ajustan el texto.
// ─────────────────────────────────────────────────────────────

#import "../primitivas.typ": medida, resolver-tema, resolver-marca, reticula, pliego, cuerpo-al-ancho, ajustar-alto

// suizo — remate a todo el ancho sobre retícula visible.
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
  let marca = resolver-marca(marca, tinta, formato)
  let acento = if acento == auto { tm.acento } else { acento }
  let linea = if linea == auto { tm.linea } else { linea }
  let gris = if gris == auto { tm.suave } else { gris }
  let r = reticula(ancho, columnas: columnas, margen: margen, medianil: medianil)
  let ancho-frase = r.span.at(calc.ceil(columnas * 2 / 3))
  let rotulo(cuerpo, ..args) = text(font: fuente-rotulos, size: 22pt, ..args, cuerpo)

  pliego(width: ancho, height: alto, margin: 0pt, fill: papel, {
    set text(font: fuente, fill: tinta, lang: "es")
    set par(leading: 0.42em)

    // retícula visible: bordes de columna en filete fino
    for i in range(columnas) {
      place(top + left, dx: r.x.at(i), line(start: (0pt, 0pt), end: (0pt, alto), stroke: 0.8pt + linea))
      place(top + left, dx: r.x.at(i) + r.col, line(start: (0pt, 0pt), end: (0pt, alto), stroke: 0.8pt + linea))
    }

    // cabecera
    place(top + left, dx: margen, dy: margen, line(length: r.util, stroke: 2.5pt + tinta))
    if autor != none {
      place(top + left, dx: r.x.at(0), dy: margen + 18pt, rotulo(weight: 700, tracking: 0.12em, autor))
    }
    if fechas != none {
      place(top + left, dx: r.x.at(calc.floor(columnas / 2)), dy: margen + 18pt, rotulo(weight: 400, fill: gris, fechas))
    }

    // el planteo, arriba
    let bloque-planteo = if etiqueta != none or planteo != none {
      block(width: ancho-frase, {
        if etiqueta != none { rotulo(weight: 700, tracking: 0.12em, fill: acento, etiqueta) }
        v(4pt)
        if planteo != none { text(font: fuente-rotulos, size: 44pt, weight: 400, fill: gris, tracking: -0.01em, planteo) }
      })
    }
    if bloque-planteo != none { place(top + left, dx: r.x.at(0), dy: 196pt, bloque-planteo) }

    context {
      let techo = 40pt + if bloque-planteo != none { 196pt + measure(bloque-planteo).height } else { margen + 48pt }
      let base = alto - 150pt

      // remate: todo el ancho útil
      let palabra(s) = text(font: fuente-remate, size: s, fill: acento,
        top-edge: "cap-height", bottom-edge: "baseline", remate)
      let s = calc.min(
        cuerpo-al-ancho(palabra, r.util),
        100pt * (0.55 * (base - techo) / measure(palabra(100pt)).height),
      )
      let caja = palabra(s)
      let remate-y = base - measure(caja).height
      place(top + left, dx: margen - 0.035 * s, dy: remate-y, caja)

      // la frase, chica, sobre las primeras columnas
      let bloque(c) = block(width: ancho-frase, text(size: c, weight: 500, tracking: -0.015em, frase))
      let hueco = remate-y - techo
      let c = ajustar-alto(bloque, cuerpo-frase, hueco - 48pt)
      let b = bloque(c)
      let fh = measure(b).height
      let aire = calc.min(aire, hueco - fh)
      let fy = if frase-y == auto { remate-y - aire - fh } else { frase-y }
      place(top + left, dx: r.x.at(0), dy: fy, b)

      // flecha fina de la frase a la palabra
      if flecha {
        let desde = fy + 14pt
        let hasta = if flecha-hasta == auto { remate-y - aire / 2 } else { flecha-hasta }
        let largo = hasta - desde - 8pt
        place(top + left, dx: r.x.at(columnas - 1) + r.col / 2, dy: desde, {
          line(start: (0pt, 0pt), end: (0pt, largo), stroke: 3pt + acento)
          place(top + left, dx: -14pt, dy: largo - 18pt, polygon(fill: acento, (0pt, 0pt), (28pt, 0pt), (14pt, 26pt)))
        })
      }
    }

    // pie
    place(bottom + left, dx: margen, dy: -112pt, line(length: r.util, stroke: 2.5pt + tinta))
    if marca != none { place(bottom + left, dx: r.x.at(0), dy: -margen + 3pt, marca) }
  })
}
