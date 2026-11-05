// ─────────────────────────────────────────────────────────────
//  mesa/_estilo.typ — la tipografía de libro y el tema de la hoja
//
//  Un tema de hoja usa los roles de los temas de lámina (carteles):
//    fondo   el papel               tinta  el texto
//    suave   pies, leyendas, listas acento  enlaces
//    linea   filetes y borde del papel
//  y, opcionalmente, `titulo` (tinta de los títulos), `codigo` (fondo del
//  bloque de código), `codigo-linea` y `enlace`. Lo que falte se deriva.
//
//  Los tamaños de los títulos van en em del cuerpo: cuando la cámara
//  achica la hoja, el texto se achica con ella.
// ─────────────────────────────────────────────────────────────

#import "../carteles/_temas.typ": resolver-tema, tema-desde-theme

#let temas-mesa = (
  // el papel crema y la tinta parda de siempre
  mesa: (
    fondo: rgb("#fff9ec"),
    tinta: rgb("#2b2417"),
    suave: rgb("#6b5a44"),
    acento: rgb("#7a4a1a"),
    linea: rgb("#d8c9a6"),
    borde: rgb("#e6dcc0"),
    titulo: rgb("#1e160b"),
    codigo: rgb("#fdf6e3"),
    codigo-linea: rgb("#e6d8b8"),
  ),
)

#let fuentes-mesa = (
  cuerpo: ("IM Fell English", "IM FELL DW Pica", "Libertinus Serif", "Noto Serif"),
  titulo: ("IM Fell English", "IM FELL DW Pica", "Libertinus Serif"),
  versalitas: ("IM Fell English SC", "IM FELL DW Pica SC", "Libertinus Serif"),
  mono: ("Libertinus Serif",),
)

// Un tema de hoja completo (con los roles derivados) a partir de lo que pase el usuario.
#let resolver-tema-mesa(tema) = {
  let c = resolver-tema(tema, defecto: "mesa", registro: temas-mesa)
  // los roles que el tema no trae se derivan de los que sí
  let derivados = (
    borde: c.linea,
    titulo: c.tinta.darken(25%),
    codigo: c.fondo.darken(2%),
    codigo-linea: c.linea,
    enlace: c.acento,
  )
  derivados + c
}

// Las fuentes: acepta `cuerpo/titulo/versalitas/mono` o las de un theme
// (`body/display`); lo que falte sale de IM Fell.
#let resolver-fuentes(fuentes) = {
  if fuentes == auto { return fuentes-mesa }
  if type(fuentes) != dictionary { panic("fuentes: se esperaba un diccionario, no " + repr(fuentes)) }
  let f = fuentes-mesa
  let lista(x) = if type(x) == array { x } else { (x,) }
  if "body" in fuentes { f.cuerpo = lista(fuentes.body) }
  if "display" in fuentes { f.titulo = lista(fuentes.display) }
  for k in ("cuerpo", "titulo", "versalitas", "mono") {
    if k in fuentes { f.insert(k, lista(fuentes.at(k))) }
  }
  f
}

// Reglas de composición para el cuerpo de la hoja. `tam` es el cuerpo ya
// escalado por la cámara.
#let estilo-libro(c, f, tam, interlineado, body) = {
  set text(font: f.cuerpo, size: tam, fill: c.tinta, lang: "es", hyphenate: true)
  set par(leading: interlineado, justify: true, spacing: 0.9em, first-line-indent: 1.2em)
  set heading(numbering: none)
  show heading.where(level: 1): it => {
    set par(first-line-indent: 0em)
    set text(font: f.titulo, weight: "bold", size: 1.45em, fill: c.titulo)
    block(width: 100%, inset: (bottom: 0.25em), stroke: (bottom: (paint: c.linea, thickness: 0.7pt)), spacing: 1.4em, it.body)
    v(0.35em)
  }
  show heading.where(level: 2): it => {
    set par(first-line-indent: 0em)
    set text(font: f.titulo, weight: "semibold", size: 1.14em, fill: c.titulo.lighten(15%))
    block(spacing: 1.1em, above: 1.2em, below: 0.6em, it.body)
  }
  show heading.where(level: 3): it => {
    set par(first-line-indent: 0em)
    set text(font: f.titulo, weight: "semibold", size: 1em, fill: c.suave, style: "italic")
    block(spacing: 1em, it.body)
  }
  show link: set text(fill: c.enlace)
  show raw: set text(font: f.mono, size: 0.86em, fill: c.suave)
  set raw(block: false, align: left)
  show raw.where(block: true): it => block(
    width: 100%, fill: c.codigo, inset: 0.7em, radius: 0pt,
    stroke: (paint: c.codigo-linea, thickness: 0.5pt),
    text(font: f.mono, size: 0.84em, it.text),
  )
  show figure: set block(spacing: 1em)
  show figure.caption: it => {
    set par(first-line-indent: 0em, justify: false, leading: 0.55em)
    set text(size: 0.78em, fill: c.suave, style: "italic")
    align(center, it)
  }
  set list(marker: text(fill: c.suave.lighten(30%), [--]), indent: 1.2em, body-indent: 0.6em)
  set enum(numbering: "1.", indent: 1.2em, body-indent: 0.6em)
  show footnote.entry: set text(size: 0.75em, fill: c.suave)
  set footnote.entry(separator: line(length: 22%, stroke: (paint: c.linea, thickness: 0.5pt)), gap: 0.9em, clearance: 1.2em)
  show quote: it => {
    set par(first-line-indent: 0em)
    set text(fill: c.suave, style: "italic")
    block(inset: (left: 0.9em, top: 0.35em, bottom: 0.35em), stroke: (left: (paint: c.linea, thickness: 2.2pt)), it.body)
  }
  body
}
