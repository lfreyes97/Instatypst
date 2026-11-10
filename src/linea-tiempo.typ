// ─────────────────────────────────────────────────────────────
//  linea-tiempo.typ — preset «línea de tiempo» (lámina 16)
//
//  Una línea vertical sin cortes, de un origen (rombo + rótulo en
//  versalitas espaciadas) a un final (anillo + rótulo), con muescas de
//  generaciones. Las frases son estaciones sobre la línea —nodo + texto a
//  la derecha— y la última puede ser un remate: nodo relleno más grande,
//  texto grande en cursiva y en el color de acento, junto al final.
//
//  Se usa desde el namespace `carteles` (carteles.linea-tiempo). No
//  importa carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "pliego.typ": pliego
#import "superbg/lib.typ" as superbg

// ── carteles.linea-tiempo ───────────────────────────────────
//   estaciones  array de contenidos: las frases, de arriba abajo
//   origen, fin rótulos de los extremos (van en mayúsculas espaciadas)
//   remate      contenido: la última frase, destacada junto al final
//   autor, obra pie (autor en negrita, obra debajo)
//   marca       contenido abajo a la derecha (p. ej. el logo)
//   cuerpo, cuerpo-remate   tamaños de las frases y del remate
//   y           auto = las estaciones se reparten a lo largo de la
//               línea con el mismo aire entre una y otra, y el remate
//               termina cerca del final; un array de largos (uno por
//               estación, más uno para el remate) las fija a mano
//
// Si las frases no caben en el largo de la línea con 0,8 cuerpos de aire
// entre una y otra, todo se achica en la misma proporción (de a 5 %); si
// sobra mucho (formatos altos), crece hasta 1,25 y el aire no pasa de 4
// cuerpos: el resto queda como tramo de línea antes de la primera.
#let linea-tiempo(
  estaciones,
  origen: none,
  fin: none,
  remate: none,
  formato: (1080, 1350),
  autor: none,
  obra: none,
  marca: none,
  fondo: rgb("#f1e9dc"),
  tinta: rgb("#2a2420"),
  acento: rgb("#9a3a1c"),
  suave: rgb("#6b5e52"),
  fuente: "Literata",
  fuente-rotulos: "Jost",
  cuerpo: 54pt,
  cuerpo-remate: 84pt,
  textura: true,
  y: auto,
) = {
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)

  // Geometría de la línea: fija respecto de los bordes
  let eje = 132pt // x de la línea
  let arriba = 128pt // y del nodo de origen
  let abajo = alto - 200pt // y del nodo final
  let texto-x = 196pt
  let texto-w = ancho - texto-x - 92pt

  let rotulo(cuerpo, color: acento) = text(
    font: fuente-rotulos, size: 25pt, weight: 600, tracking: 0.16em, fill: color, upper(cuerpo),
  )
  let nodo(r, relleno, borde) = circle(radius: r, fill: relleno, stroke: 3.5pt + borde)

  // Una estación con todo escalado por `e` (1 = tamaños de siempre).
  // El nodo cae sobre la primera línea: su posición es proporcional al
  // cuerpo (14pt y radio 11pt a 54pt; 26pt y 20pt a 84pt en el remate).
  let bloque(c, e, es-remate) = if es-remate {
    let s = cuerpo-remate * e
    block(width: texto-w, text(size: s, weight: 600, style: "italic", fill: acento, {
      set par(leading: 0.3em)
      c
    }))
  } else {
    block(width: texto-w, text(size: cuerpo * e, c))
  }
  let todas = estaciones.map(c => (c, false)) + if remate != none { ((remate, true),) } else { () }

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    set par(leading: 0.42em)

    // ── Fondo: grano muy leve de papel
    if textura {
      place(superbg.bg-patron(patron: "dots", color: tinta, paso: 22, opacidad: 5%, size: formato))
    }

    // ── La línea: un solo trazo continuo + muescas de generaciones
    place(dx: eje - 2pt, dy: arriba, rect(width: 4pt, height: abajo - arriba, fill: tinta))
    for yy in range(int(arriba / 1pt) + 30, int(abajo / 1pt) - 14, step: 22) {
      place(dx: eje - 13pt, dy: yy * 1pt, line(length: 9pt, stroke: 1.6pt + tinta.transparentize(55%)))
    }

    // Nodo de origen (rombo) y nodo de llegada (anillo)
    place(dx: eje - 17pt, dy: arriba - 17pt, rotate(45deg, rect(width: 24pt, height: 24pt, fill: acento)))
    if origen != none { place(dx: texto-x, dy: arriba - 16pt, rotulo(origen)) }
    place(dx: eje - 15pt, dy: abajo - 15pt, circle(radius: 15pt, fill: fondo, stroke: 4pt + tinta))
    if fin != none { place(dx: texto-x, dy: abajo - 16pt, rotulo(color: tinta, fin)) }

    // ── Estaciones
    context {
      // tramo donde caben: desde 108pt bajo el origen hasta 122pt sobre
      // el final (las medidas de la lámina 16)
      let (y0, y1) = (arriba + 108pt, abajo - 122pt)
      let n = todas.len()
      let altos(e) = todas.map(((c, r)) => measure(bloque(c, e, r)).height)
      let aire-de(hs) = (y1 - y0 - hs.sum()) / calc.max(1, n - 1)
      let e = 1.0
      let hs = altos(e)
      // si no hay al menos 0,8 cuerpos de aire entre estaciones, se achica
      while n > 1 and aire-de(hs) < 0.8 * cuerpo * e and e > 0.4 {
        e -= 0.05
        hs = altos(e)
      }
      // si sobra (más de 4 cuerpos de aire: formatos altos), crece hasta 1,25
      if y == auto {
        while n > 1 and e < 1.25 and aire-de(altos(e + 0.05)) > 4 * cuerpo * (e + 0.05) { e += 0.05 }
        hs = altos(e)
      }
      let ys = if y != auto { y } else if n == 1 {
        (y1 - hs.at(0),)
      } else {
        // mismo aire entre una y otra, como mucho 4 cuerpos; la última
        // termina en y1 y lo que sobra queda arriba, como tramo de línea
        // antes de la primera estación
        let aire = calc.min(aire-de(hs), 4 * cuerpo * e)
        let acc = (y1 - hs.sum() - aire * (n - 1),)
        for i in range(1, n) { acc.push(acc.last() + hs.at(i - 1) + aire) }
        acc
      }
      for (i, (c, es-remate)) in todas.enumerate() {
        let (r, dn, relleno, borde) = if es-remate {
          let s = cuerpo-remate * e
          (s * 20 / 84, s * 26 / 84, acento, acento)
        } else {
          let s = cuerpo * e
          (s * 11 / 54, s * 14 / 54, fondo, tinta)
        }
        place(dx: eje - r, dy: ys.at(i) + dn, nodo(r, relleno, borde))
        place(dx: texto-x, dy: ys.at(i), bloque(c, e, es-remate))
      }
    }

    // ── Pie: atribución + marca
    if autor != none or obra != none or marca != none {
      place(dx: texto-x, dy: alto - 128pt, block(width: texto-w, {
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
