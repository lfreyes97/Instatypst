// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/epistola.typ — variant: "epistola"
//
//    epistola   carta en papel verjurado: margen ancho con la obra como
//               nota de archivo, cuerpo con sangría y firma con rúbrica
//
//  Lo común de la tanda A (temas, validación, ajuste) está en
//  _comun-a.typ. Procedencia: v1, carteles/_epigrafes-a.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-a.typ": *

// ═════════════════════════════════════════════════════════════
//  epistola — carta con margen ancho y firma con rúbrica
// ═════════════════════════════════════════════════════════════
// Rúbrica (paraph): sale del final de la firma, baja hacia la izquierda,
// hace un gancho y vuelve en un latigazo largo por debajo. Caja `w` × `h`.
#let _rubrica(w, h, color, grosor) = box(width: w, height: h, curve(
  stroke: (paint: color, thickness: grosor, cap: "round", join: "round"),
  curve.move((w * 0.97, h * 0.04)),
  curve.cubic((w * 0.92, h * 0.55), (w * 0.62, h * 0.74), (w * 0.32, h * 0.66)),
  curve.cubic((w * 0.06, h * 0.58), (w * 0.02, h * 0.28), (w * 0.17, h * 0.26)),
  curve.cubic((w * 0.36, h * 0.24), (w * 0.52, h * 1.0), (w * 1.0, h * 0.80)),
))

#let epistola(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «epístola»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-epistola")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let fx = formato.at(0) / 1080

  let x0 = 300pt * fx // margen ancho
  let x1 = W - 104pt * fx
  let ancho = x1 - x0
  let y0 = 140pt * k
  let y1 = H - 130pt * k - (if marca != none { 60pt * k } else { 0pt })
  let alto = y1 - y0

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "EB Garamond 12", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── Papel verjurado: puntizones finos, corondeles, pliegues en tercios ──
    let fina = c.hondo.transparentize(62%)
    place(rect(width: 100%, height: 100%, fill: tiling(size: (W, 5pt * k),
      place(dy: 2pt * k, line(length: W, stroke: 0.5pt * k + fina)))))
    for i in range(calc.ceil(W / (96pt * fx))) {
      place(dx: 48pt * fx + i * 96pt * fx, line(start: (0pt, 0pt), end: (0pt, H), stroke: 1.2pt * k + c.hondo.transparentize(58%)))
    }
    for t in (1 / 3, 2 / 3) {
      place(dy: H * t - 10pt * k, rect(width: W, height: 20pt * k, fill: gradient.linear(
        (c.fondo.transparentize(100%), 0%), (c.hondo.transparentize(55%), 50%),
        (c.fondo.lighten(40%).transparentize(30%), 56%), (c.fondo.transparentize(100%), 100%),
        angle: 90deg)))
    }

    // ── La carta: cuerpo con sangría y firma con rúbrica ──
    let carta(s) = block(width: ancho, {
      block({
        set text(size: s)
        set par(justify: true, leading: 0.72em)
        // (la sangría, a mano: `first-line-indent` no sangra el párrafo único)
        [#h(2.4em)#cita]
      })
      if autor != none {
        let f = text(style: "italic", size: s * 1.3, autor)
        block(above: 1.3 * s, align(right, context {
          let w = measure(f).width
          box(stack(dir: ttb, spacing: 0.12 * s, align(right, f),
            align(right, _rubrica(calc.max(w * 1.1, 200pt * k), s * 1.4, c.tinta, calc.max(2.4pt * k, s * 0.06)))))
        }))
      }
    })
    place(top + left, dx: x0, dy: y0, box(width: ancho, height: alto, align(horizon, context {
      carta(_cuerpo(quien, carta, 60pt * k, alto, 36pt * k))
    })))
    _guia(guias, x0, y0, ancho, alto)

    // ── En el margen, la obra: nota de archivo a la altura del comienzo ──
    if obra != none {
      let wn = x0 - 50pt * fx - 56pt * fx
      place(top + left, dx: 56pt * fx, dy: y0, box(width: wn, height: alto, align(horizon, context {
        // a la altura de la primera línea de la carta
        let s = _cuerpo(quien, carta, 60pt * k, alto, 36pt * k)
        let hc = measure(carta(s)).height
        let nota = block(width: wn, align(right, {
          text(size: 34pt * k, style: "italic", fill: c.acento, par(leading: 0.4em, obra))
          block(above: 12pt * k, line(length: 46pt * k, stroke: 1.2pt * k + c.acento))
        }))
        let hn = measure(nota).height
        // la caja centra la nota; se sube para alinear su arriba con la carta
        move(dy: -(hc - hn) / 2 + 0.18 * s, nota)
      })))
    }
    if marca != none { place(bottom + right, dx: -104pt * fx, dy: -60pt * k, marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = epistola
