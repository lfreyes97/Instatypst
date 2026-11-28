// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/pergamino.typ — variant: "pergamino"
//
//    pergamino  hoja manuscrita: pergamino tostado, filetes rojos del
//               copista, capitular iluminada y la cita en cursiva
//
//  Lo común de la tanda A (temas, validación, ajuste) está en
//  _comun-a.typ. Procedencia: v1, carteles/_epigrafes-a.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-a.typ": *

// ═════════════════════════════════════════════════════════════
//  pergamino — hoja manuscrita con capitular iluminada
// ═════════════════════════════════════════════════════════════
#let pergamino(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «pergamino»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-pergamino")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let pauta = c.acento.transparentize(50%)
  let firma = autor != none or obra != none
  let alto-marca = if marca != none { 56pt * k } else { 0pt }

  // la columna del copista
  let x0 = 136pt * k
  let x1 = W - 136pt * k
  let ancho = x1 - x0
  let y-cab = 92pt * k
  let y0 = y-cab + 110pt * k
  let y-pie = H - 104pt * k - alto-marca // borde de abajo de la firma
  let y1 = y-pie - (if firma { 150pt * k } else { 0pt })
  let alto = y1 - y0

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "IM FELL English", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── Pergamino: centro claro, bordes tostados, manchas y grano ──
    place(rect(width: 100%, height: 100%, fill: gradient.radial(
      (c.fondo.lighten(42%), 0%), (c.fondo, 60%), (c.hondo, 100%),
      center: (48%, 42%), radius: 85%,
    )))
    let (fw, fh) = (formato.at(0), formato.at(1))
    superbg.bg-malla(
      (c.hondo, c.fondo.lighten(30%), c.hondo),
      puntos: ((fw * 0.07, fh * 0.92), (fw * 0.9, fh * 0.08), (fw * 0.98, fh * 0.7)),
      radios: (200, 240, 160), semilla: 11, size: formato,
    )
    place(rect(width: 100%, height: 100%, fill: c.fondo.transparentize(52%)))
    superbg.bg-patron(patron: "ruido", color: c.tinta, opacidad: 15%, size: formato)

    // ── Filetes del copista: dos rojos a cada lado de la columna ──
    for x in (x0 - 24pt * k, x0 - 13pt * k, x1 + 13pt * k, x1 + 24pt * k) {
      place(dx: x, line(start: (0pt, 54pt * k), end: (0pt, H - 54pt * k), stroke: 1.1pt * k + pauta))
    }

    // ── Cabecera: una rama de acantos en rojo ──
    place(top + center, dy: y-cab, fl.guarda("acantos", calc.min(460pt * k, ancho), c.acento, alto: 44pt * k))

    // ── La cita, en cursiva justificada, con capitular a dos tintas ──
    // la capitular baja tantas líneas como tiene la cita (2 o 3)
    let componer(s, alto-cap) = block(width: ancho, {
      set text(size: s, style: "italic", hyphenate: true)
      set par(justify: true, leading: 0.62em)
      capitular-ornamentada(cita, alto: alto-cap, hueco: 0.3em, estilo: "rubricada",
        desgaste: 0.3, tinta: c.tinta, fill: c.acento)
    })
    place(top + left, dx: x0, dy: y0, box(width: ancho, height: alto, align(horizon, context {
      let s = _cuerpo(quien, s => componer(s, 3), 84pt * k, alto, 36pt * k)
      let llano = measure(block(width: ancho, text(size: s, style: "italic", par(leading: 0.62em, cita)))).height
      componer(s, calc.clamp(int(calc.round(llano / (s * 1.25))), 2, 3))
    })))
    _guia(guias, x0, y0, ancho, alto)

    // ── Rúbrica final: calderón y autor en rojo, la obra debajo ──
    if firma {
      place(bottom + left, dx: x0, dy: -(H - y-pie), block(width: ancho, align(right, {
        if autor != none {
          block(text(font: "IM FELL English SC", size: 44pt * k, fill: c.acento, tracking: 0.04em, [¶ #autor]))
        }
        if obra != none {
          block(above: 16pt * k, text(size: 38pt * k, fill: c.suave, _obra(obra)))
        }
      })))
      _guia(guias, x0, y1, ancho, y-pie - y1)
    }
    if marca != none { place(bottom + center, dy: -60pt * k, marca) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = pergamino
