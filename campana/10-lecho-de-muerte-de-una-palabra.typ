// Lámina 10 · «Redentor» y «redención» · retrato 1080×1350
// Esquela: papel de luto con orla negra, cruz y viñetas de imprenta. El
// difunto es la palabra misma —Redención—, compuesta como el nombre en un
// aviso fúnebre, entre las dos frases de Warfield. IM FELL de punta a punta.
// Compilar: typst compile --root . --font-path Fonts campana/10-lecho-de-muerte-de-una-palabra.typ campana/10-lecho-de-muerte-de-una-palabra.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos, ajustar

#let (ancho, alto) = formatos.retrato
#let papel = rgb("#f3eee3")
#let luto = rgb("#141210")
#let sepia = rgb("#4a443c") // texto secundario, ≈ 8:1 sobre el papel

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: "IM FELL English", fill: luto, lang: "es", hyphenate: false)
#set par(spacing: 0pt)

#superbg.superbg((capas: (
  (tipo: "plano", color: papel),
  (tipo: "ruido", color: luto, opacidad: 6%),
  (tipo: "vignette", color: rgb("#5a4a32"), intensidad: 18%),
)), size: formatos.retrato)

// ── Orla de luto: banda negra gruesa + filete interior ──
#place(top + left, dx: 40pt, dy: 40pt, rect(
  width: ancho * 1pt - 80pt, height: alto * 1pt - 80pt, stroke: 30pt + luto,
))
#place(top + left, dx: 80pt, dy: 80pt, rect(
  width: ancho * 1pt - 160pt, height: alto * 1pt - 160pt, stroke: 1.5pt + luto,
))

// Viñeta de imprenta (IM FELL FLOWERS): fleurón centrado.
#let flor(c, tam: 40pt, color: luto) = text(font: "IM FELL FLOWERS 2", size: tam, fill: color, c)

#let interior = ancho * 1pt - 240pt
// El bloque central se centra en vertical entre la orla y la firma.
#place(top + center, dy: 110pt, block(width: interior, height: 780pt, align(center + horizon, {

  // cruz latina
  box(width: 64pt, height: 120pt, {
    place(top + center, rect(width: 11pt, height: 120pt, fill: luto))
    place(top + center, dy: 30pt, rect(width: 64pt, height: 11pt, fill: luto))
  })
  v(46pt)

  // primera frase: el anuncio
  text(size: 52pt, style: "italic", par(leading: 0.5em)[
    Estamos asistiendo al lecho \ de muerte de una palabra.
  ])
  v(54pt)
  flor("g", tam: 60pt)
  v(40pt)

  // el nombre del difunto
  text(font: "IM FELL French Canon SC", size: 132pt, tracking: 0.03em)[Redención]
  v(36pt)
  line(length: 260pt, stroke: 1.2pt + luto)
  v(52pt)

  // segunda frase: el duelo
  text(size: 52pt, style: "italic", par(leading: 0.5em)[
    Y es triste presenciar la muerte \ de cualquier cosa valiosa.
  ])
})))

// ── Firma: como el pie de la esquela ──
#place(bottom + center, dy: -210pt, block(width: interior, align(center, {
  // cierre del aviso: filete — florón — filete
  box(grid(columns: 3, column-gutter: 18pt, align: horizon,
    line(length: 120pt, stroke: 1pt + luto),
    text(top-edge: "bounds", bottom-edge: "bounds", flor("x", tam: 44pt)),
    line(length: 120pt, stroke: 1pt + luto),
  ))
  v(40pt)
  text(font: "IM FELL English SC", size: 34pt, tracking: 0.08em)[B. B. Warfield]
  v(12pt)
  text(size: 30pt, style: "italic", fill: sepia)[«Redentor» y «redención»]
})))
#place(bottom + center, dy: -118pt, logo(luto, (ancho, alto)))
