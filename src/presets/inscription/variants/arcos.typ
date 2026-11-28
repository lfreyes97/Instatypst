// ─────────────────────────────────────────────────────────────
//  presets/inscription/variants/arcos.typ — variant: "arcos"
//
//    arcos    los arcos paralelos de mosaico (_arcos.typ) como un sol naciente
//             en una banda del 40 % de arriba; la cita, centrada en serif
//             (Fraunces), en el resto.
//
//  Lo común de la tanda B (temas, validación, ajuste) está en
//  _comun-b.typ. Procedencia: v1, carteles/_epigrafes-b.typ.
// ─────────────────────────────────────────────────────────────

#import "_comun-b.typ": *

// ════════════════════════════════════════════════════════════
//  3 · arcos
// ════════════════════════════════════════════════════════════
// Una banda del 40 % de arriba con diez arcos paralelos (los de mosaico) en
// medio círculo, sobre una línea de horizonte, y un disco naranja en su
// centro: un sol que asoma. La banda recorta lo que sale por los lados. En
// el resto, la cita centrada en Fraunces y, debajo, el autor en versalitas
// espaciadas (naranja) y la obra en cursiva.
#let _arcos-estilo(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «arcos»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "epi-arcos")
  let m = 84pt * k
  let H = alto * 0.40
  let n = 10
  let tope = calc.min(H - 0.8 * m, ancho * 0.62) // borde de fuera del arco mayor
  let r0 = tope * 0.30
  let paso = (tope - r0) / (n - 1 + 0.37)
  let grosor = 0.37 * paso
  let estilo = (font: "Fraunces 72pt", weight: 400, tracking: -0.005em, fill: c.tinta)

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    // ── la banda ──
    place(top + left, box(width: ancho, height: H + grosor / 2, clip: true, {
      arcos((ancho / 2, H), r0 + grosor / 2, lineas: n, paso: paso, grosor: grosor,
        desde: 180deg, hasta: 360deg, color: c.suave)
      let rd = r0 - 0.55 * paso
      place(top + left, dx: ancho / 2 - rd, dy: H - rd, circle(radius: rd, fill: c.acento))
    }))
    place(top + left, dy: H - grosor / 2, rect(width: ancho, height: grosor, fill: c.suave))

    // ── la firma ──
    let firma = if autor == none and obra == none { none } else {
      block(width: ancho - 2 * m, align(center, {
        set text(lang: "es", hyphenate: false)
        set par(leading: 0.5em, justify: false)
        if autor != none { text(font: "Jost", size: 30pt * km, weight: 600, tracking: 0.22em, fill: c.acento, upper(autor)) }
        if autor != none and obra != none { linebreak() }
        if obra != none { text(font: "Fraunces 72pt", size: 36pt * km, fill: c.suave, obra) }
      }))
    }
    let fh = if firma == none { 0pt } else { measure(firma).height }
    let sep = if firma == none { 0pt } else { 64pt * k }
    let pie = if marca != none { measure(marca).height + 32pt * k } else { 0pt }

    // ── la cita ──
    let (y0, y1) = (H + 80pt * k, alto - m - pie)
    let w = ancho - 2 * m
    let h = y1 - y0 - fh - sep
    let s = _cuerpo(cita, estilo, 0.36, w, h, 84pt * km, minimo, al: center)
    if s == none { _no-cabe(quien, minimo) }
    let b = _bloque(cita, estilo, 0.36, w, s, al: center)
    let bh = measure(b).height
    let y = y0 + (y1 - y0 - bh - sep - fh) / 2
    place(top + left, dx: m, dy: y, b)
    if firma != none { place(top + left, dx: m, dy: y + bh + sep, firma) }
    if marca != none { place(bottom + center, dy: -m, marca) }
    if guias { _guia(m, y0, w, y1 - y0); _guia(0pt, 0pt, ancho, H, color: blue) }
  })
}

// La variante: cada archivo de variants/ exporta `variant`.
#let variant = _arcos-estilo
