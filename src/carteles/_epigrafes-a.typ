// ─────────────────────────────────────────────────────────────
//  carteles/_epigrafes-a.typ — estilos de epígrafe, tanda A
//
//  Cinco estilos clásicos, de imprenta y de archivo, para el futuro
//  `carteles.epigrafe(cita, autor:, obra:, estilo:)`. Cada uno es una
//  composición distinta, no un cambio de color:
//
//    pergamino  hoja manuscrita: pergamino tostado, filetes rojos del
//               copista, capitular iluminada y la cita en cursiva
//    portada    portada de libro del XVII: orla de filete doble, cabecera
//               de florones, primera palabra en versalitas rojas, pie de
//               imprenta con autor y obra
//    lapida     inscripción en piedra: mayúsculas romanas espaciadas,
//               letra incisa (sombra y luz), el autor como «fecit»
//    epistola   carta en papel verjurado: margen ancho con la obra como
//               nota de archivo, cuerpo con sangría y firma con rúbrica
//    cartela    cartela de museo: pared blanca, bloque pequeño de sans
//               fina abajo a la izquierda, mucho aire
//
//  Todos con la misma firma:
//    (cita, autor: none, obra: none, formato: (1080, 1350), tema: auto,
//     marca: none, guias: false) => página
//  `tema`: auto (el del estilo), un nombre de `temas-lamina` o un
//  diccionario de roles (fondo, tinta, suave, acento, hondo); lo que falte
//  sale del tema del estilo. `guias: true` dibuja las cajas del texto.
//  La cita se achica hasta caber en su caja; si a 34 px de cuerpo (en
//  1080 de ancho) no cabe, error.
//
//  Privado de `carteles/`: lo usa el despachador de epígrafes.
// ─────────────────────────────────────────────────────────────

#import "../pliego.typ": pliego
#import "_base.typ": medida, escala, ajustar-alto
#import "_temas.typ": temas-lamina, resolver-tema
#import "../superbg/lib.typ" as superbg
#import "../fleurones.typ" as fl
#import "../dropcaps.typ": capitular-ornamentada, _dividir

// ── Temas propios de cada estilo (roles de lámina) ──
#let temas-epigrafe-a = (
  epigrafe-pergamino: (
    fondo: rgb("#ead9b0"),
    tinta: rgb("#2a1c12"),
    suave: rgb("#5e4630"),
    acento: rgb("#9a2118"),
    hondo: rgb("#b8955c"),
  ),
  epigrafe-portada: (
    fondo: rgb("#f2ede2"),
    tinta: rgb("#15120e"),
    suave: rgb("#4a433a"),
    acento: rgb("#b0231a"),
    hondo: rgb("#15120e"),
  ),
  epigrafe-lapida: (
    fondo: rgb("#b7b2a8"),
    tinta: rgb("#2e2b27"),
    suave: rgb("#45413b"),
    acento: rgb("#e6e2da"),
    hondo: rgb("#8a857b"),
  ),
  epigrafe-epistola: (
    fondo: rgb("#f4f0e6"),
    tinta: rgb("#1c2538"),
    suave: rgb("#5f5c55"),
    acento: rgb("#8b3a26"),
    hondo: rgb("#cfc8b8"),
  ),
  epigrafe-cartela: (
    fondo: rgb("#efede8"),
    tinta: rgb("#1d1d1b"),
    suave: rgb("#55534e"),
    acento: rgb("#8f8b83"),
    hondo: rgb("#1d1d1b"),
  ),
)

#let _tema(tema, propio) = resolver-tema(
  if tema == auto { propio } else { tema },
  defecto: propio,
  registro: temas-lamina + temas-epigrafe-a,
)

#let _validar(quien, cita, formato) = {
  if cita == none { panic(quien + ": falta la cita") }
  if type(formato) != array or formato.len() != 2 or formato.any(x => type(x) not in (int, float) or x <= 0) {
    panic(quien + ": `formato` es (ancho, alto) en px, p. ej. (1080, 1350) — recibido: " + repr(formato))
  }
}

// Cuerpo con el que `hacer(s)` cabe en `alto`, de `desde` a `minimo`; si ni
// a `minimo` cabe, error. Usar dentro de `context`.
#let _cuerpo(quien, hacer, desde, alto, minimo) = {
  let s = ajustar-alto(hacer, desde, alto, minimo: minimo, paso: 1pt)
  if measure(hacer(s)).height > alto {
    panic(quien + ": la cita no cabe con el cuerpo a " + str(calc.round(minimo / 1pt, digits: 1))
      + " px (el mínimo legible). Acórtala o usa un formato más alto.")
  }
  s
}

// Guía de depuración: el contorno de una caja.
#let _guia(guias, dx, dy, w, h) = if guias {
  place(top + left, dx: dx, dy: dy, rect(width: w, height: h, stroke: (paint: rgb("#e0218a"), thickness: 1.5pt, dash: "dashed")))
}

// La obra va en cursiva: si ya viene con `_…_` (emph) se deja; si no, se
// le pone. (Dentro de un texto en cursiva, el emph la vuelve redonda.)
#let _obra(o) = if type(o) == content and o.func() == emph { o } else { emph(o) }

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

// ═════════════════════════════════════════════════════════════
//  portada — portada tipográfica de libro del XVII
// ═════════════════════════════════════════════════════════════
#let portada(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «portada»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-portada")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let alto-marca = if marca != none { 50pt * k } else { 0pt }

  let m = 52pt * k // la orla
  let x0 = m + 78pt * k
  let ancho = W - 2 * x0
  let y-cab = m + 56pt * k
  // el pie de imprenta, contado desde abajo: filetes + autor + obra
  let alto-pie = 8pt * k + (if autor != none { 96pt * k } else { 0pt }) + (if obra != none { 66pt * k } else { 0pt })
  let y-pie = H - m - 62pt * k - alto-marca // borde de abajo del pie
  let y0 = y-cab + 110pt * k
  let y1 = y-pie - alto-pie - 60pt * k

  // primera palabra (en versalitas rojas, más grande) y el resto
  let (primera, resto, _) = _dividir(cita, 1)

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "IM FELL Double Pica", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── Orla: filete doble, grueso fuera y fino dentro ──
    place(top + left, dx: m, dy: m, rect(width: W - 2 * m, height: H - 2 * m, stroke: 6pt * k + c.hondo))
    place(top + left, dx: m + 13pt * k, dy: m + 13pt * k,
      rect(width: W - 2 * m - 26pt * k, height: H - 2 * m - 26pt * k, stroke: 1.6pt * k + c.hondo))

    // ── Cabecera de florones entre filetes ──
    place(top + left, dx: x0, dy: y-cab, fl.cabecera(ancho, c.acento, guarda: "palmetas", linea: c.tinta, alto: 34pt * k))

    // ── La cita: primera palabra en mayúsculas rojas; el resto, centrado;
    // debajo, filete — cruz — filete ──
    let componer(s) = block(width: ancho, align(center, {
      block(text(font: "IM FELL French Canon SC", size: s * 1.9, fill: c.acento, tracking: 0.08em, upper(primera)))
      if resto != none {
        block(above: 0.5 * s, text(size: s, par(leading: 0.5em, resto)))
      }
      block(above: 0.9 * s, fl.separador(5.5 * s, c.tinta, vineta: "cruz", alto: 0.5 * s, grosor: 1pt * k))
    }))
    place(top + left, dx: x0, dy: y0, box(width: ancho, height: y1 - y0, align(horizon, context {
      componer(_cuerpo(quien, componer, 66pt * k, y1 - y0, 36pt * k))
    })))
    _guia(guias, x0, y0, ancho, y1 - y0)

    // ── Pie de imprenta: filetes, AUTOR, obra ──
    place(bottom + left, dx: x0, dy: -(H - y-pie), block(width: ancho, align(center, {
      line(length: ancho, stroke: 2.4pt * k + c.tinta)
      v(5pt * k)
      line(length: ancho, stroke: 0.8pt * k + c.tinta)
      if autor != none {
        block(above: 42pt * k, text(font: "IM FELL English SC", size: 46pt * k, tracking: 0.12em, autor))
      }
      if obra != none {
        block(above: 24pt * k, text(font: "IM FELL English", size: 40pt * k, fill: c.acento, _obra(obra)))
      }
    })))
    _guia(guias, x0, y-pie - alto-pie, ancho, alto-pie)
    if marca != none { place(bottom + center, dy: -m - 34pt * k, marca) }
  })
}

// ═════════════════════════════════════════════════════════════
//  lapida — inscripción grabada en piedra
// ═════════════════════════════════════════════════════════════
// Letra incisa, en un bloque de ancho `ancho`: la luz del bisel debajo,
// corrida abajo a la derecha, y la sombra del surco encima.
#let _incisa(cuerpo, c, k, ancho) = block(width: ancho, {
  place(top + left, dx: 1.3pt * k, dy: 1.7pt * k, block(width: ancho, align(center, text(fill: c.acento.transparentize(30%), cuerpo))))
  align(center, text(fill: c.tinta, cuerpo))
})

#let lapida(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «lápida»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-lapida")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let alto-marca = if marca != none { 50pt * k } else { 0pt }
  let m = 64pt * k // la moldura
  let x0 = m + 72pt * k
  let ancho = W - 2 * x0
  let firma = autor != none or obra != none
  let alto-pie = if firma { 30pt * k + (if autor != none { 76pt * k } else { 0pt }) + (if obra != none { 58pt * k } else { 0pt }) } else { 0pt }
  let y-pie = H - m - 84pt * k - alto-marca
  let y0 = m + 92pt * k
  let y1 = y-pie - alto-pie - 56pt * k

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "Marcellus", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    // ── Piedra: vetas, grano y canto oscurecido ──
    superbg.bg-malla(
      (c.fondo.darken(14%), c.fondo.lighten(14%), c.fondo.darken(9%), c.fondo.lighten(10%), c.fondo.darken(12%)),
      semilla: 23, size: formato,
    )
    place(rect(width: 100%, height: 100%, fill: c.fondo.transparentize(45%)))
    superbg.bg-patron(patron: "ruido", color: c.tinta, opacidad: 34%, size: formato)
    superbg.bg-vignette(color: c.tinta, intensidad: 26%, size: formato)

    // ── Moldura tallada: surcos con sombra y luz ──
    let marco(d, grosor, sombra, luz) = {
      let (w, h) = (W - 2 * (m + d), H - 2 * (m + d))
      place(top + left, dx: m + d + grosor * 0.8, dy: m + d + grosor * 0.8, rect(width: w, height: h, stroke: grosor + luz))
      place(top + left, dx: m + d, dy: m + d, rect(width: w, height: h, stroke: grosor + sombra))
    }
    marco(0pt, 3.2pt * k, c.hondo.darken(30%), c.acento.transparentize(30%))
    marco(18pt * k, 1.4pt * k, c.hondo.darken(20%), c.acento.transparentize(45%))

    // ── La inscripción: mayúsculas romanas espaciadas, centradas ──
    let componer(s) = {
      set text(size: s, tracking: 0.14em)
      set par(leading: 0.8em)
      _incisa(upper(cita), c, k, ancho)
    }
    place(top + left, dx: x0, dy: y0, box(width: ancho, height: y1 - y0, align(horizon, context {
      componer(_cuerpo(quien, componer, 68pt * k, y1 - y0, 36pt * k))
    })))
    _guia(guias, x0, y0, ancho, y1 - y0)

    // ── Firma: filete inciso, AUTOR · FECIT, obra ──
    if firma {
      place(bottom + left, dx: x0, dy: -(H - y-pie), block(width: ancho, {
        set par(leading: 0.6em)
        align(center, box(width: 120pt * k, height: 6pt * k, {
          place(dy: 3.2pt * k, line(length: 120pt * k, stroke: 2pt * k + c.acento.transparentize(30%)))
          place(dy: 1.6pt * k, line(length: 120pt * k, stroke: 2pt * k + c.hondo.darken(30%)))
        }))
        if autor != none {
          block(above: 30pt * k, text(size: 40pt * k, tracking: 0.24em, _incisa([#upper(autor) · FECIT], c, k, ancho)))
        }
        if obra != none {
          block(above: 22pt * k, text(size: 34pt * k, tracking: 0.3em, _incisa(upper(obra), c, k, ancho)))
        }
      }))
      _guia(guias, x0, y-pie - alto-pie, ancho, alto-pie)
    }
    if marca != none { place(bottom + center, dy: -m - 34pt * k, marca) }
  })
}

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

// ═════════════════════════════════════════════════════════════
//  cartela — cartela de museo
// ═════════════════════════════════════════════════════════════
#let cartela(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «cartela»"
  _validar(quien, cita, formato)
  let c = _tema(tema, "epigrafe-cartela")
  let (W, H) = medida(formato)
  let k = escala(formato)
  let fx = formato.at(0) / 1080

  let x0 = 100pt * fx
  let ancho = calc.min(600pt * fx, W - 2 * x0)
  let y-bajo = H - 112pt * k
  let alto-max = H * 0.58

  pliego(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: "Hanken Grotesk", fill: c.tinta, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    let bloque(s) = block(width: ancho, {
      if autor != none { block(text(size: 36pt * k, weight: 600, autor)) }
      if obra != none { block(above: 14pt * k, text(size: 34pt * k, weight: 300, fill: c.suave, _obra(obra))) }
      if autor != none or obra != none {
        block(above: 36pt * k, below: 36pt * k, line(length: 64pt * k, stroke: 1.5pt * k + c.acento))
      }
      block(text(size: s, weight: 300, par(leading: 0.6em, [«#cita»])))
    })
    place(bottom + left, dx: x0, dy: -(H - y-bajo), context {
      bloque(_cuerpo(quien, bloque, 40pt * k, alto-max, 34pt * k))
    })
    _guia(guias, x0, y-bajo - alto-max, ancho, alto-max)
    if marca != none { place(bottom + right, dx: -x0, dy: -(H - y-bajo), marca) }
  })
}

#let estilos-a = (
  pergamino: pergamino,
  portada: portada,
  lapida: lapida,
  epistola: epistola,
  cartela: cartela,
)
