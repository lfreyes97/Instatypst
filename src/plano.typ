// ─────────────────────────────────────────────────────────────
//  plano.typ — preset «plano» (grid blueprint)
//
//  La frase como cota de un plano técnico: azul de heliografía, retícula
//  de dos pesos (rejilla fina y línea maestra cada `maestra` celdas),
//  marco de lámina con marcas de borde, el texto en mayor cuerpo que
//  cabe, una línea de cota debajo y un cajetín abajo a la derecha con
//  autor, obra, escala y hoja. Todo se dibuja con vectores de Typst: no
//  depende de superbg.
//
//  Se usa desde el namespace `carteles` (carteles.plano). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

// Cota: línea con topes y flechas en los extremos, rótulo opcional al
// centro sobre un hueco del color de fondo.
#let _cota(ancho, color, fondo, rotulo, fuente, k) = {
  let g = 2.5pt * k
  let punta(dir) = polygon(fill: color, ..if dir == 1 {
    ((0pt, 0pt), (16pt * k, -7pt * k), (16pt * k, 7pt * k))
  } else {
    ((0pt, 0pt), (-16pt * k, -7pt * k), (-16pt * k, 7pt * k))
  })
  block(width: ancho, height: 34pt * k, {
    place(left + horizon, line(angle: 90deg, length: 34pt * k, stroke: g + color), dy: -17pt * k)
    place(right + horizon, line(angle: 90deg, length: 34pt * k, stroke: g + color), dy: -17pt * k)
    place(left + horizon, dx: g, line(length: ancho - 2 * g, stroke: g + color))
    place(left + horizon, dx: g, punta(1))
    place(right + horizon, dx: -g, punta(-1))
    if rotulo != none {
      place(center + horizon, box(fill: fondo, inset: (x: 18pt * k, y: 4pt * k),
        text(font: fuente, size: 22pt * k, fill: color, tracking: 0.12em, rotulo)))
    }
  })
}

// ── carteles.plano ──────────────────────────────────────────
//   texto     contenido; los cortes de línea, a mano si se quieren
//   autor, obra    van en el cajetín (autor = «dibujó», obra = «plano»)
//   marca     contenido abajo a la izquierda (p. ej. el logo)
//   fondo     el azul de la lámina
//   linea     color de la retícula, el marco y la cota (auto = papel
//             de calco, un blanco azulado)
//   acento    color del texto destacado `[…]` y del cajetín (auto = el
//             mismo `linea`); se aplica a `destacar` si se pasa
//   destacar  palabras (array de strings) del texto que van en acento
//   paso      lado de la celda fina; `maestra`: cada cuántas celdas va
//             una línea gruesa
//   cota      auto = línea sola · contenido = rótulo en medio de la
//             línea · none = sin cota
//   cajetin   true/false; `escala` y `hoja` son sus dos casillas fijas
//   marcas    letras y números en los bordes, como en una lámina
//
// Pensado para 1080×1350; en otros formatos las medidas se escalan
// con el lado menor relativo.
#let plano(
  texto,
  formato: (1080, 1350),
  autor: none,
  obra: none,
  marca: none,
  fondo: rgb("#14357a"),
  linea: auto,
  acento: auto,
  destacar: (),
  paso: 36pt,
  maestra: 5,
  cota: auto,
  cajetin: true,
  escala: [1 : 1],
  hoja: [1 / 1],
  marcas: true,
  fuente: "Hanken Grotesk",
  fuente-mono: "DM Mono",
  peso: 700,
  cuerpo: auto,
  cuerpo-max: 140pt,
  margen: 84pt,
) = {
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let k = calc.min(formato.at(0) / 1080, formato.at(1) / 1350)
  let tinta = if linea == auto { rgb("#e8f0ff") } else { linea }
  let acento = if acento == auto { tinta } else { acento }
  let margen = margen * k
  let caja = ancho - 2 * margen
  let mono(t, s: 20pt, ..a) = text(font: fuente-mono, size: s * k, tracking: 0.1em, fill: tinta, ..a, t)

  page(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    set par(leading: 0.28em, spacing: 0pt)

    // ── retícula: fina cada `paso`, maestra cada `maestra` celdas,
    //    con origen en el vértice del marco ──
    let celda = paso * k
    let nx = calc.floor((ancho - 2 * margen) / celda)
    let ny = calc.floor((alto - 2 * margen) / celda)
    let ancho-r = nx * celda
    let alto-r = ny * celda
    let x0 = (ancho - ancho-r) / 2
    let y0 = (alto - alto-r) / 2
    for i in range(0, nx + 1) {
      let m = calc.rem(i, maestra) == 0
      place(top + left, dx: x0 + i * celda, dy: y0,
        line(angle: 90deg, length: alto-r, stroke: (if m { 1.6pt } else { 0.8pt }) * k + tinta.transparentize(if m { 62% } else { 86% })))
    }
    for j in range(0, ny + 1) {
      let m = calc.rem(j, maestra) == 0
      place(top + left, dx: x0, dy: y0 + j * celda,
        line(length: ancho-r, stroke: (if m { 1.6pt } else { 0.8pt }) * k + tinta.transparentize(if m { 62% } else { 86% })))
    }

    // ── marco de lámina ──
    place(top + left, dx: x0, dy: y0, rect(width: ancho-r, height: alto-r, stroke: 2.5pt * k + tinta))
    place(top + left, dx: x0 - 16pt * k, dy: y0 - 16pt * k, rect(width: ancho-r + 32pt * k, height: alto-r + 32pt * k, stroke: 0.9pt * k + tinta.transparentize(40%)))

    // ── marcas de borde: letras arriba, números a la izquierda ──
    if marcas {
      let letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".clusters()
      let por-x = calc.max(1, calc.ceil(nx / 6))
      let por-y = calc.max(1, calc.ceil(ny / 8))
      for (n, i) in range(0, nx, step: por-x).enumerate() {
        let w = calc.min(por-x, nx - i) * celda
        place(top + left, dx: x0 + i * celda, dy: y0 - 46pt * k, box(width: w, align(center, mono(letras.at(n, default: "·"), s: 18pt))))
        place(top + left, dx: x0 + i * celda, dy: y0 - 16pt * k, line(angle: 90deg, length: 16pt * k, stroke: 1.6pt * k + tinta))
      }
      for (n, j) in range(0, ny, step: por-y).enumerate() {
        let h = calc.min(por-y, ny - j) * celda
        place(top + left, dx: x0 - 54pt * k, dy: y0 + j * celda, box(width: 34pt * k, height: h, align(center + horizon, mono(str(n + 1), s: 18pt))))
        place(top + left, dx: x0 - 16pt * k, dy: y0 + j * celda, line(length: 16pt * k, stroke: 1.6pt * k + tinta))
      }
    }

    // ── cajetín: abajo a la derecha, dentro del marco ──
    let alto-cajetin = if cajetin { 150pt * k } else { 0pt }
    if cajetin {
      let casilla(rot, valor) = block(inset: (x: 14pt * k, y: 10pt * k), width: 100%, {
        mono(rot, s: 13pt, fill: tinta.transparentize(30%))
        v(5pt * k)
        text(font: fuente-mono, size: 20pt * k, fill: acento, tracking: 0.04em, valor)
      })
      let ancho-c = calc.min(caja, 620pt * k)
      place(top + left, dx: x0 + ancho-r - ancho-c, dy: y0 + alto-r - 124pt * k, block(
        width: ancho-c, fill: fondo, stroke: 2pt * k + tinta,
        grid(
          columns: (1.7fr, 1fr, 1fr),
          rows: (auto, auto),
          stroke: 1pt * k + tinta,
          grid.cell(colspan: 3, casilla([PLANO], if obra != none { obra } else { [—] })),
          casilla([DIBUJÓ], if autor != none { autor } else { [—] }),
          casilla([ESCALA], escala),
          casilla([HOJA], hoja),
        ),
      ))
    }

    // ── texto + cota ──
    let hueco = alto-r - 2 * 60pt * k - alto-cajetin - (if cota != none { 80pt * k } else { 0pt })
    let cuerpo-texto(c) = {
      let t = if destacar.len() > 0 {
        show regex(destacar.map(p => "(" + p + ")").join("|")): it => text(fill: acento, it)
        texto
      } else { texto }
      text(size: c, weight: peso, tracking: -0.02em, t)
    }
    let ancho-texto = ancho-r - 2 * 48pt * k
    let bloque(c) = block(width: ancho-texto, cuerpo-texto(c))

    context {
      let c = if cuerpo == auto { cuerpo-max * k } else { cuerpo }
      if cuerpo == auto {
        while c > 28pt and measure(bloque(c)).height > hueco { c -= 2pt }
      }
      let b = bloque(c)
      let h = measure(b).height
      let y = y0 + 60pt * k + (hueco - h) * 0.4
      place(top + left, dx: x0 + 48pt * k, dy: y, b)
      if cota != none {
        let rotulo = if cota == auto { none } else { cota }
        place(top + left, dx: x0 + 48pt * k, dy: y + h + 40pt * k, _cota(ancho-texto, acento, fondo, rotulo, fuente-mono, k))
      }
    }

    if marca != none { place(bottom + left, dx: x0 + 48pt * k, dy: -(y0 + 36pt * k), marca) }
  })
}
