// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/malla.typ — variant: "malla"
//
//    malla    retícula suiza de módulos casi cuadrados con una sola celda de
//             color que lleva el autor; la cita grande en bandera izquierda
//             (Hanken Grotesk) sobre las filas de arriba.
//
//  Lo común de la tanda B (temas, validación, ajuste) está en
//  _comun-b.typ. Procedencia: v1, carteles/_epigrafes-b.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-b.typ": *

// ════════════════════════════════════════════════════════════
//  4 · malla
// ════════════════════════════════════════════════════════════
// Retícula de 4 columnas (6 en apaisado) y filas casi cuadradas que llenan
// el alto, en filetes finos. La cita va en bandera izquierda desde la
// esquina de la primera celda y ocupa las filas de arriba (Hanken Grotesk
// 600); la última fila queda libre salvo una celda, la de la derecha, llena
// de rojo, con el autor y la obra.
#let _malla(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «malla»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "epi-malla")
  let m = 56pt * k
  let cols = if ancho > alto { 6 } else { 4 }
  let cw = (ancho - 2 * m) / cols
  let filas = calc.max(2, calc.floor((alto - 2 * m) / cw))
  let rh = (alto - 2 * m) / filas
  let pad = 22pt * k
  let fil = 1.5pt * k
  let estilo = (font: "Hanken Grotesk", weight: 600, tracking: -0.025em, fill: c.tinta)
  // Hanken junta tanto el punto y el cierre de comillas que se montan
  let cita = { show regex("[.,;:!?…][»”’]"): t => t.text.clusters().join(h(0.1em)); cita }

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    // ── la retícula ──
    for i in range(cols + 1) {
      place(top + left, dx: m + i * cw - fil / 2, dy: m, rect(width: fil, height: alto - 2 * m, fill: c.linea))
    }
    for j in range(filas + 1) {
      place(top + left, dx: m, dy: m + j * rh - fil / 2, rect(width: ancho - 2 * m, height: fil, fill: c.linea))
    }

    // ── la celda ──
    let (cx, cy) = (m + (cols - 1) * cw, m + (filas - 1) * rh)
    place(top + left, dx: cx - fil / 2, dy: cy - fil / 2, rect(width: cw + fil, height: rh + fil, fill: c.acento))
    if autor != none or obra != none {
      let iw = cw - 2 * pad
      let et = (font: "Hanken Grotesk", weight: 700, tracking: -0.01em, fill: c.claro)
      // el autor se achica (por palabras) hasta caber en el ancho de la celda
      let sa = if autor == none { 0pt } else {
        let pal = _plano(autor).split(regex("\s+")).filter(x => x != "")
        let ancha = calc.max(1pt, ..pal.map(p => measure(text(size: 100pt, ..et, p)).width))
        calc.min(38pt * km, 100pt * (iw / ancha))
      }
      if autor != none and sa < 20pt * km { panic(quien + ": el nombre del autor no cabe en la celda") }
      let dentro = block(width: iw, {
        set text(lang: "es", hyphenate: false)
        set par(leading: 0.3em, justify: false)
        if autor != none { text(size: sa, ..et, autor) }
        if autor != none and obra != none { v(12pt * k) }
        if obra != none { text(font: "Hanken Grotesk", size: 26pt * km, weight: 400, fill: c.claro, obra) }
      })
      if measure(dentro).height > rh - 2 * pad { panic(quien + ": el autor y la obra no caben en la celda") }
      place(top + left, dx: cx + pad, dy: cy + pad, dentro)
    }
    if marca != none { place(top + left, dx: m + pad, dy: cy + rh - pad - measure(marca).height, marca) }

    // ── la cita ──
    let (x, y, w) = (m + pad, m + pad * 0.6, ancho - 2 * m - 2 * pad)
    let h = (filas - 1) * rh - 2 * pad
    let s = _cuerpo(cita, estilo, 0.26, w, h, 112pt * km, minimo)
    if s == none { _no-cabe(quien, minimo) }
    place(top + left, dx: x, dy: y, _bloque(cita, estilo, 0.26, w, s))
    if guias { _guia(x, y, w, h) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = _malla
