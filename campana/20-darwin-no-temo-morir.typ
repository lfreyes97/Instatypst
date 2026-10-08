// Lámina 20 · La vida religiosa de Charles Darwin (contraste con Charles Hodge)
// retrato 1080×1350 · par Darwin (2 de 2)
// Concepto: el silencio. La 19 termina en una franja de tierra oscura; aquí todo
// el lienzo es esa tierra, y la frase de Darwin queda pequeña en medio del vacío,
// con el gris hueso de las ramas secas de la 19. GFS Didot + DM Mono.
// Compilar: typst compile --root . --font-path Fonts campana/20-darwin-no-temo-morir.typ campana/20-darwin-no-temo-morir.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.retrato
#let tierra = rgb("#1c1a15")
#let claro = rgb("#d8d3c8")
#let hueso = rgb("#a19c93")
#let tenue = rgb("#8f897e")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: tierra)
#set text(lang: "es", hyphenate: false)

// Viñeta muy leve: el centro apenas más claro que los bordes
#place(superbg.bg-vignette(color: black, intensidad: 30%, size: formatos.retrato))

// ── La frase, sola
#place(center + top, dy: 560pt, block(width: 900pt, align(center)[
  #text(font: "GFS Didot", size: 46pt, fill: claro)[No tengo el menor miedo a morir.]
  #v(30pt)
  #line(length: 44pt, stroke: 1.5pt + hueso)
  #v(18pt)
  #text(font: "DM Mono", size: 24pt, fill: hueso)[Charles Darwin]
]))

// ── Al pie: quién la cita, la nota obligatoria y la marca
#place(center + bottom, dy: -84pt, block(width: 820pt, align(center)[
  #set text(font: "DM Mono", size: 22pt, fill: tenue)
  #set par(leading: 0.6em)
  citado por B. B. Warfield \
  #emph[La vida religiosa de Charles Darwin]
  #v(22pt)
  Palabras de Darwin, no de Warfield: él las cita para contrastarlas con la muerte de Charles Hodge. 2 de 2.
  #v(36pt)
  #logo(hueso, (ancho, alto))
]))
