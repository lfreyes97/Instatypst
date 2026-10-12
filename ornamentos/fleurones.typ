// ─────────────────────────────────────────────────────────────
// fleurones.typ — Catálogo de IM FELL FLOWERS 1 y 2
//
// Los 80 glifos con tinta de las dos fuentes de flores de Igino Marini,
// cada uno en su caja de tinta exacta (src/fleurones.typ), con lo que
// el clasificador midió de su forma: simetrías, el glifo que es su giro
// de 180° o de 90°, y si encadena (su tinta toca los dos costados).
// Después, la hoja de pruebas: cada glifo como banda, como banda
// alternada con su giro, como roseta en espejo y por giro, y como marco.
// Sirve para ELEGIR: qué funciona como orla, qué como viñeta suelta.
//
// Datos: ornamentos/fleurones.json, generado por
//   python3 ornamentos/clasificar-fleurones.py
// Compilar (desde la raíz del repo):
//   typst compile --root . --font-path Fonts ornamentos/fleurones.typ ornamentos/fleurones.pdf
//
// The Fell Types are digitally reproduced by Igino Marini.
// www.iginomarini.com
// ─────────────────────────────────────────────────────────────

#import "../src/fleurones.typ" as fl

#let datos = json("fleurones.json")
#let tinta = rgb("#2b1916")
#let rojo = rgb("#8e3b3b")
#let gris = rgb("#8a817c")
#let papel = rgb("#fbf8f2")

#set page(paper: "a4", margin: (x: 1.4cm, y: 1.5cm), fill: papel,
  footer: context align(center, text(size: 7pt, fill: gris)[
    The Fell Types are digitally reproduced by Igino Marini · www.iginomarini.com · #counter(page).display()]))
#set text(font: "IM FELL English", size: 9.5pt, fill: tinta, lang: "es")
#set par(leading: 0.55em)

#let corto(f) = if f == fl.f1 { "F1" } else { "F2" }
#let nombre(c) = if c.to-unicode() >= 0xE000 { "U+" + upper(str(c.to-unicode(), base: 16)) } else { c }
#let etiqueta(f, c) = text(font: "IM FELL English SC", size: 10pt, tracking: 0.06em)[#corto(f) · #nombre(c)]
#let dato(cuerpo) = text(size: 7.5pt, fill: gris, cuerpo)

// Glifo a su proporción natural, con la caja de tinta en filete fino.
#let muestra(f, c, alto, color: tinta) = {
  let w = fl.ancho-natural(f, c, alto)
  box(width: w, height: alto, stroke: 0.3pt + rojo.transparentize(50%), fl.caja(f, c, w, alto, color))
}

// ── Portada ──
#align(center)[
  #v(2.2cm)
  #fl.banda(fl.f1, "RS", 12cm, 0.9cm, rojo)
  #v(0.8cm)
  #text(font: "IM FELL English SC", size: 26pt, tracking: 0.12em)[Fleurones]
  #v(0.2cm)
  #text(size: 13pt, style: "italic")[IM FELL FLOWERS 1 y 2 — catálogo y hoja de pruebas]
  #v(0.8cm)
  #fl.banda(fl.f1, "RS", 12cm, 0.9cm, rojo)
]
#v(1cm)
#block(width: 100%, inset: (x: 1.2cm))[
  #set par(justify: true)
  Cada glifo aparece en su *caja de tinta* (el filete rojo): así lo
  coloca `fleurones.caja`, sin el aire de la línea de texto. Debajo, lo
  que el clasificador midió de su forma (son grabados digitalizados, las
  simetrías nunca son exactas: se aceptan desde 0,80 de coincidencia):

  - *simetría* — vertical (izquierda/derecha), horizontal (arriba/abajo)
    o de giro (igual girado 180°).
  - *giro ↔ X* — el glifo X es este mismo girado 180°: la pieza
    complementaria. En FLOWERS 2 cada minúscula es su mayúscula girada.
  - *90° → X* — el glifo X es este girado 90° (los molinetes).
  - *encadena* — la tinta toca los dos costados del avance: pieza
    dibujada para unirse con la siguiente. En FLOWERS 1 lo hacen todas:
    la fuente entera es material de orla.

  La *hoja de pruebas* que sigue a las fichas pone cada glifo en cinco
  usos: banda, banda alternada con su giro, roseta en espejo, roseta por
  giro y marco. Las cadenas que usa Magnalia (`fleurones.cadenas`) son
  ojivas RS, cartuchos IJ (F1), follaje N, flores D y eslabones U (F2).
]

// ── Fichas ──
#for f in (fl.f1, fl.f2) {
  pagebreak()
  heading(level: 1, text(font: "IM FELL English SC", size: 16pt, tracking: 0.08em, f))
  v(4pt)
  let glifos = datos.at(f)
  grid(
    columns: (1fr,) * 5,
    column-gutter: 8pt,
    row-gutter: 12pt,
    ..glifos.keys().map(c => {
      let g = glifos.at(c)
      block(width: 100%, breakable: false, stroke: 0.4pt + gris.transparentize(60%), inset: 6pt, radius: 2pt, {
        set align(center)
        box(height: 1.5cm, align(horizon, muestra(f, c, calc.min(1.3cm, 2.6cm / calc.max(1, g.proporcion)))))
        v(4pt)
        etiqueta(f, c)
        v(2pt)
        set par(leading: 0.35em)
        dato[
          #if g.simetria.len() > 0 [sim. #g.simetria.join(", ") \ ]
          #if "giro" in g [giro ↔ #nombre(g.giro) \ ]
          #if "cuarto" in g [90° → #nombre(g.cuarto) \ ]
          #if g.encadena [encadena \ ]
          prop. #g.proporcion
        ]
      })
    }),
  )
}

// ── Hoja de pruebas ──
#let fila(f, c) = {
  let g = datos.at(f).at(c)
  let h = 0.75cm
  grid(
    columns: (1.5cm, 4.2cm, 4.2cm, 1.7cm, 1.7cm, 2.2cm),
    column-gutter: 8pt,
    align: (left + horizon,) + (center + horizon,) * 5,
    etiqueta(f, c),
    fl.banda(f, c, 4.2cm, h * 0.8, tinta),
    fl.alternar(f, c, 4.2cm, h * 0.8, rojo),
    fl.espejo4(f, c, 1.5cm, tinta),
    fl.giro4(f, c, 1.5cm, rojo),
    fl.marco(2cm, 1.5cm, 0.42cm, f, c, f, c, tinta),
  )
}

#for f in (fl.f1, fl.f2) {
  pagebreak()
  heading(level: 1, text(font: "IM FELL English SC", size: 16pt, tracking: 0.08em)[Pruebas · #f])
  v(2pt)
  grid(
    columns: (1.5cm, 4.2cm, 4.2cm, 1.7cm, 1.7cm, 2.2cm),
    column-gutter: 8pt,
    align: (left,) + (center,) * 5,
    ..([], [banda], [alternada con su giro], [espejo ×4], [giro ×4], [marco]).map(t => text(size: 8pt, style: "italic", fill: gris, t)),
  )
  v(4pt)
  for c in datos.at(f).keys() {
    block(breakable: false, below: 9pt, fila(f, c))
    line(length: 100%, stroke: 0.3pt + gris.transparentize(70%))
  }
}
