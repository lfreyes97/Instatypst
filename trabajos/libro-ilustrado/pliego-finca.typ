// Prueba de concepto — versión «ilustrada» de Why I Believe in God (Cornelius Van Til).
// Un pliego A5 (148 × 210 mm): a la izquierda la lámina a página completa («La finca»), a la
// derecha el texto compuesto como en un libro (capitular, justificado, cabecera, folio, remate).
// Cambiar el texto: editar texto.typ. Cambiar la lámina: escena-finca.typ.
// Compilar: typst compile --root . --font-path Fonts trabajos/libro-ilustrado/pliego-finca.typ "salida/pliego-finca-{p}.png" --ppi 200
//   (o a PDF: typst compile --root . --font-path Fonts trabajos/libro-ilustrado/pliego-finca.typ salida/pliego-finca.pdf)
#import "../../src/lib.typ": capitular, fleurones
#import "escena-finca.typ": escena
#import "texto.typ": titulo-obra, autor, epigrafe, parrafo
#import "vinetas.typ": memorial, bandera

#let ancho = 148mm
#let alto = 210mm
#let papel = rgb("#f4eddc")
#let tinta = rgb("#1d1a16")
#let apagado = rgb("#7a7060")
#let crema = rgb("#f6f0de")

// ── Izquierda: la lámina, a sangre ─────────────────────────────────
#page(width: ancho, height: alto, margin: 0pt, fill: rgb("#27407f"), {
  let k = ancho / 1080pt // escala de la escena (1080 pt de ancho) al ancho de la página
  scale(x: k * 100%, y: k * 100%, origin: top + left, reflow: true, escena(alto / k))
  // pie de lámina, en el cielo
  place(top + left, dx: 14mm, dy: 15mm, {
    text(font: "DM Mono", size: 7pt, weight: 500, tracking: 0.14em, fill: crema.darken(15%))[LÁMINA I]
    v(3mm)
    box(width: 80mm, text(font: "EB Garamond 12", size: 14pt, style: "italic", fill: crema, epigrafe))
  })
})

// ── Derecha: el texto ──────────────────────────────────────────────
#set page(width: ancho, height: alto, fill: papel,
  margin: (left: 22mm, right: 16mm, top: 22mm, bottom: 26mm),
  header: align(center, text(font: "EB Garamond 12", size: 8pt, fill: apagado, tracking: 0.18em)[#upper(titulo-obra)]),
  footer: align(right, text(font: "EB Garamond 12", size: 9pt, fill: apagado)[13]))
#set text(font: "EB Garamond 12", size: 10.8pt, lang: "es", fill: tinta, hyphenate: true)
#set par(justify: true, leading: 0.64em, spacing: 0.64em)

#pagebreak(weak: true)
#v(2mm)
#capitular(parrafo, alto: 3)
#v(9mm)
// dos viñetas en línea, con pie
#grid(columns: (1fr, 1fr), column-gutter: 8mm, align: center,
  {
    memorial(color: tinta, papel: papel)
    v(2mm)
    text(font: "EB Garamond 12", size: 8.5pt, style: "italic", fill: apagado)[El Memorial de Lincoln]
  },
  {
    bandera(color: tinta, papel: papel)
    v(2mm)
    text(font: "EB Garamond 12", size: 8.5pt, style: "italic", fill: apagado)[«Old Glory»]
  })
#v(8mm)
#align(center, fleurones.remate(16pt, apagado))
