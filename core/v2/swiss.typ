// ─────────────────────────────────────────────────────────────
//  core/v2/swiss.typ — el motor de `type: "swiss"`
//
//  Recibe las piezas ya separadas (sin metadata) y dibuja UNA página.
//  Reglas de colocación de este preset:
//    · retícula de 6 columnas, visible (filetes de 0,8 pt en cada borde)
//    · cabecera: filete de 2,5 pt, autor a la izquierda, fechas en la columna 4
//    · eyebrow y question son UN bloque apilado que arranca en y = 196 pt
//    · techo = 40 pt bajo ese bloque (o margen + 48 pt si no hay bloque)
//    · headline: ancho útil, pero su altura de mayúscula no pasa del 55 % del
//      hueco entre el techo y la base (base = alto − 150 pt)
//    · statement: 4 columnas; se achica de 2 en 2 pt hasta caber en el hueco
//      menos 48 pt de aire; el aire (150 pt) se encoge antes que la letra
//    · flecha: de 14 pt bajo la frase hasta la mitad del aire sobre el titular
//    · pie: filete a 112 pt del borde inferior; brand abajo a la izquierda
//  Las fuentes y medidas son del preset, no parámetros.
// ─────────────────────────────────────────────────────────────

#import "parts.typ": part, read-parts
#import "primitives.typ": dimensions, columns, fit-to-width, fit-to-height, resolve-theme, resolve-brand

// Hijos del tipo "swiss"
#let eyebrow(body) = part("eyebrow", body)
#let question(body) = part("question", body)
#let statement(body) = part("statement", body)
#let headline(body) = part("headline", body)
#let display(body) = part("headline", body)  // alias de headline

#let swiss(
  statement,
  headline,
  eyebrow: none,
  question: none,
  format: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  author: none,
  dates: none,
) = {
  let (width, height) = dimensions(format)
  let tm = resolve-theme(theme, "suizo")
  let ink = tm.ink
  let accent = if accent == auto { tm.accent } else { accent }
  let brand = resolve-brand(brand, ink, format)
  let margin = 64pt
  let g = columns(width, count: 6, margin: margin, gutter: 24pt)
  // la frase y el planteo ocupan las primeras 2/3 de las columnas
  let text-width = g.span.at(4)
  let tag(body, ..args) = text(font: "Inter", size: 22pt, ..args, body)

  page(width: width, height: height, margin: 0pt, fill: tm.background, {
    set text(font: "Hanken Grotesk", fill: ink, lang: "es")
    set par(leading: 0.42em)

    // retícula visible: bordes de columna
    for i in range(g.count) {
      place(top + left, dx: g.x.at(i), line(start: (0pt, 0pt), end: (0pt, height), stroke: 0.8pt + tm.rule))
      place(top + left, dx: g.x.at(i) + g.col, line(start: (0pt, 0pt), end: (0pt, height), stroke: 0.8pt + tm.rule))
    }

    // cabecera
    place(top + left, dx: margin, dy: margin, line(length: g.usable, stroke: 2.5pt + ink))
    if author != none {
      place(top + left, dx: g.x.at(0), dy: margin + 18pt, tag(weight: 700, tracking: 0.12em, author))
    }
    if dates != none {
      place(top + left, dx: g.x.at(calc.floor(g.count / 2)), dy: margin + 18pt, tag(weight: 400, fill: tm.muted, dates))
    }

    // eyebrow + question: un solo bloque apilado
    let heading = if eyebrow != none or question != none {
      block(width: text-width, {
        if eyebrow != none { tag(weight: 700, tracking: 0.12em, fill: accent, eyebrow) }
        v(4pt)
        if question != none { text(font: "Inter", size: 44pt, weight: 400, fill: tm.muted, tracking: -0.01em, question) }
      })
    }
    if heading != none { place(top + left, dx: g.x.at(0), dy: 196pt, heading) }

    context {
      let ceiling = 40pt + if heading != none { 196pt + measure(heading).height } else { margin + 48pt }
      let base = height - 150pt

      // headline: ancho útil, con tope del 55 % del hueco
      let word(s) = text(font: "Bebas Neue", size: s, fill: accent, top-edge: "cap-height", bottom-edge: "baseline", headline)
      let s = calc.min(
        fit-to-width(word, g.usable),
        100pt * (0.55 * (base - ceiling) / measure(word(100pt)).height),
      )
      let box = word(s)
      let headline-y = base - measure(box).height
      place(top + left, dx: margin - 0.035 * s, dy: headline-y, box)

      // statement: 4 columnas, se achica antes que el aire
      let sentence(c) = block(width: text-width, text(size: c, weight: 500, tracking: -0.015em, statement))
      let gap = headline-y - ceiling
      let c = fit-to-height(sentence, 66pt, gap - 48pt)
      let b = sentence(c)
      let bh = measure(b).height
      let air = calc.min(150pt, gap - bh)
      let sentence-y = headline-y - air - bh
      place(top + left, dx: g.x.at(0), dy: sentence-y, b)

      // flecha: de la frase al titular, en la última columna
      let from = sentence-y + 14pt
      let to = headline-y - air / 2
      let length = to - from - 8pt
      place(top + left, dx: g.x.at(g.count - 1) + g.col / 2, dy: from, {
        line(start: (0pt, 0pt), end: (0pt, length), stroke: 3pt + accent)
        place(top + left, dx: -14pt, dy: length - 18pt, polygon(fill: accent, (0pt, 0pt), (28pt, 0pt), (14pt, 26pt)))
      })
    }

    // pie
    place(bottom + left, dx: margin, dy: -112pt, line(length: g.usable, stroke: 2.5pt + ink))
    if brand != none { place(bottom + left, dx: g.x.at(0), dy: -margin + 3pt, brand) }
  })
}

// Adaptador del contrato: lee los hijos del cuerpo y llama al motor.
// Si falta `statement`, el contenido suelto ocupa su lugar.
#let make(
  body,
  format: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  author: none,
  dates: none,
) = {
  let p = read-parts(body)
  swiss(
    p.at("statement", default: p.at("content", default: [])),
    p.at("headline", default: []),
    eyebrow: p.at("eyebrow", default: none),
    question: p.at("question", default: none),
    format: format, theme: theme, accent: accent,
    brand: brand, author: author, dates: dates,
  )
}
