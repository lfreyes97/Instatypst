// ─────────────────────────────────────────────────────────────
//  esquela.typ — preset «esquela» (lámina 10)
//
//  Aviso fúnebre de imprenta: papel de luto con orla, cruz, el anuncio
//  en cursiva, el «difunto» compuesto como nombre de esquela en
//  versalitas grandes, el duelo en cursiva y el pie con filete — florón
//  — filete, autor y obra. IM FELL de punta a punta; las viñetas son de
//  IM FELL FLOWERS (fleurones.typ).
//
//  Se usa desde el namespace `carteles` (carteles.esquela). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "pliego.typ": pliego
#import "superbg/lib.typ" as superbg
#import "fleurones.typ" as fl

// Viñeta: auto = el glifo de FLOWERS 2 de la lámina, como texto (`g`
// de cuerpo, con `bordes` ajustados o no); un nombre de
// `fleurones.vinetas`; o cualquier contenido.
#let _vineta(v, c, cuerpo, color, bordes: false) = {
  if v == none { return none }
  if v == auto {
    let t = text(font: fl.f2, size: cuerpo, fill: color, c)
    return if bordes { text(top-edge: "bounds", bottom-edge: "bounds", t) } else { t }
  }
  if type(v) == str { fl.vineta(v, cuerpo * 0.7, color) } else { v }
}

// ── carteles.esquela ────────────────────────────────────────
//   nombre      el «difunto»: una palabra o dos, en versalitas grandes
//   anuncio     frase de arriba (cursiva); los cortes de línea, a mano
//   duelo       frase de abajo (cursiva)
//   autor, obra pie: autor en versalitas, obra en cursiva sepia
//   marca       contenido al pie, centrado (p. ej. el logo)
//   orla        "luto" (banda negra gruesa) · un marco de
//               `fleurones.cadenas` ("celosia", "ojivas"…) · none
//   interior    lo que corre por dentro de la orla: "filete" · un marco
//               de `fleurones.cadenas` ("crucetas"…) · none
//   simbolo     "cruz" (latina, de dos barras) · contenido · none
//   vineta, vineta-pie   auto (las de la lámina) · un nombre de
//               `fleurones.vinetas` · contenido · none
//   cuerpo, cuerpo-nombre   tamaños; el nombre se achica si no cabe
//   textura     ruido y viñeteado sobre el papel
//
// Pensado para el retrato 1080×1350; en otros formatos las medidas se
// escalan con el lado menor relativo (cuadrado ≈ 0,8).
#let esquela(
  nombre,
  anuncio: none,
  duelo: none,
  formato: (1080, 1350),
  autor: none,
  obra: none,
  marca: none,
  papel: rgb("#f3eee3"),
  luto: rgb("#141210"),
  sepia: rgb("#4a443c"),
  orla: "luto",
  interior: "filete",
  simbolo: "cruz",
  vineta: auto,
  vineta-pie: auto,
  fuente: "IM FELL English",
  fuente-nombre: "IM FELL French Canon SC",
  fuente-sc: "IM FELL English SC",
  cuerpo: 52pt,
  cuerpo-nombre: 132pt,
  textura: true,
) = {
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let k = calc.min(formato.at(0) / 1080, formato.at(1) / 1350)

  pliego(width: ancho, height: alto, margin: 0pt, fill: papel, {
    set text(font: fuente, fill: luto, lang: "es", hyphenate: false)
    set par(spacing: 0pt)

    if textura {
      superbg.superbg((capas: (
        (tipo: "plano", color: papel),
        (tipo: "ruido", color: luto, opacidad: 6%),
        (tipo: "vignette", color: rgb("#5a4a32"), intensidad: 18%),
      )), size: formato)
    }

    // ── Orla ──
    if orla == "luto" {
      place(top + left, dx: 40pt * k, dy: 40pt * k, rect(
        width: ancho - 80pt * k, height: alto - 80pt * k, stroke: 30pt * k + luto,
      ))
    } else if orla != none {
      let g = fl.cadenas.at(orla).grosor * k * 0.88
      let m = 26pt * k
      place(top + left, dx: m, dy: m, fl.orla(orla, ancho - 2 * m, alto - 2 * m, luto, grosor: g))
    }
    if interior == "filete" {
      place(top + left, dx: 80pt * k, dy: 80pt * k, rect(
        width: ancho - 160pt * k, height: alto - 160pt * k, stroke: 1.5pt * k + luto,
      ))
    } else if interior != none {
      let m = 68pt * k
      place(top + left, dx: m, dy: m, fl.orla(interior, ancho - 2 * m, alto - 2 * m, luto, grosor: 18pt * k))
    }

    let caja = ancho - 240pt * k
    // El nombre se compone a `cuerpo-nombre`, o al ancho de la caja si no cabe.
    let nom = context {
      let hacer(s) = text(font: fuente-nombre, size: s, tracking: 0.03em, nombre)
      let s = cuerpo-nombre * k
      let w = measure(hacer(s)).width
      hacer(if w > caja { s * caja / w } else { s })
    }

    // ── Bloque central, entre la orla y el pie ──
    place(top + center, dy: 110pt * k, block(width: caja, height: alto - 570pt * k, align(center + horizon, {
      if simbolo == "cruz" {
        box(width: 64pt * k, height: 120pt * k, {
          place(top + center, rect(width: 11pt * k, height: 120pt * k, fill: luto))
          place(top + center, dy: 30pt * k, rect(width: 64pt * k, height: 11pt * k, fill: luto))
        })
        v(46pt * k)
      } else if simbolo != none {
        simbolo
        v(46pt * k)
      }
      if anuncio != none {
        text(size: cuerpo * k, style: "italic", par(leading: 0.5em, anuncio))
        v(54pt * k)
      }
      let vc = _vineta(vineta, "g", 60pt * k, luto)
      if vc != none {
        vc
        v(40pt * k)
      }
      nom
      v(36pt * k)
      line(length: 260pt * k, stroke: 1.2pt * k + luto)
      if duelo != none {
        v(52pt * k)
        text(size: cuerpo * k, style: "italic", par(leading: 0.5em, duelo))
      }
    })))

    // ── Pie de la esquela: filete — florón — filete, autor, obra ──
    place(bottom + center, dy: -210pt * k, block(width: caja, align(center, {
      let vp = _vineta(vineta-pie, "x", 44pt * k, luto, bordes: true)
      box(grid(columns: 3, column-gutter: 18pt * k, align: horizon,
        line(length: 120pt * k, stroke: 1pt * k + luto),
        vp,
        line(length: 120pt * k, stroke: 1pt * k + luto),
      ))
      if autor != none {
        v(40pt * k)
        text(font: fuente-sc, size: 34pt * k, tracking: 0.08em, autor)
      }
      if obra != none {
        v(12pt * k)
        text(size: 30pt * k, style: "italic", fill: sepia, obra)
      }
    })))
    if marca != none { place(bottom + center, dy: -118pt * k, marca) }
  })
}
