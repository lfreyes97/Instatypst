// Especímenes tipográficos desde las bases del repo.
// Usa font-tokens.typ (familias reales verificadas) + font-pairings.typ
// (las 8 parejas) — nada de nombres de fuente hardcodeados.
// Compilar: typst compile --root . --font-path Fonts examples/tipografias.typ
#import "../src/lib.typ": *
#import "../src/font-tokens.typ": token, family

#set page(paper: "a4", margin: (x: 2cm, y: 2cm), flipped: true)
#set text(lang: "es", size: 10pt)

#let pangrama = "El veloz murciélago hindú comía feliz cardillo"

#let total = (pairings.names)().len() * 2

// Una fila de muestra: etiqueta de peso + "AaBbCc — 123" grande + pangrama.
// En variables se fija el eje con `variations:` (rango verificado en el
// token); en estáticas, peso Typst normal.
#let show-variant(key, wght: none, label: "Regular", sample: pangrama) = {
  let t = token(key)
  let fam = t.family
  let vars = if wght == none { (:) } else { (wght: wght) }
  grid(
    columns: (0.8fr, 2.6fr, 1fr),
    column-gutter: 16pt,
    row-gutter: 2pt,
    align(right + horizon)[#text(size: 9pt, fill: blue)[#label]],
    align(left + horizon)[#text(font: fam, size: 20pt, variations: vars)[AaBbCc — 123]],
    align(left + horizon)[#text(font: fam, size: 8pt, variations: vars)[#sample]],
  )
  v(4pt)
}

// Pesos a mostrar para una clave: en variables, min/medio/max del eje wght
// (si lo tiene); en estáticas, Regular + Bold de Typst.
#let variant-rows(key) = {
  let t = token(key)
  if t.variable and "wght" in t.at("axes", default: (:)) {
    let (lo, hi) = t.axes.wght
    let mid = calc.round((lo + hi) / 2)
    (
      (wght: lo, label: "Min " + str(lo)),
      (wght: mid, label: "Medio " + str(mid)),
      (wght: hi, label: "Max " + str(hi)),
    )
  } else {
    ((weight-label: "Regular"), (weight-label: "Bold"))
  }
}

// Ficha de una pareja: columna izq con info, columna der con muestras por rol.
#let typography-page(nombre) = {
  let roles = (pairings.library).at(nombre)
  align(left)[
    #text(size: 11pt)[Typography]
    #h(1fr)
    #context text(size: 11pt)[#counter(page).display() / #total]
  ]
  v(16pt)
  grid(
    columns: (1fr, 2fr),
    column-gutter: 40pt,
    [
      #text(size: 20pt, weight: "bold")[Typography\ maintype]
      #v(16pt)
      #text(size: 14pt, weight: "bold")[#nombre]
      #text(size: 9pt, fill: gray)[Pareja de font-pairings.typ]
      #v(12pt)
      #for (role, key) in roles [
        #text(size: 9pt)[#role: #family(key)#if token(key).variable [ (variable)]] \
      ]
    ],
    [
      #for (role, key) in roles [
        #text(size: 9pt, fill: blue)[#upper(role)]
        #v(4pt)
        #for fila in variant-rows(key) [
          #if "wght" in fila {
            show-variant(key, wght: fila.wght, label: fila.label)
          } else {
            grid(
              columns: (0.8fr, 2.6fr, 1fr),
              column-gutter: 16pt, row-gutter: 2pt,
              align(right + horizon)[#text(size: 9pt, fill: blue)[#fila.weight-label]],
              align(left + horizon)[#text(font: family(key), size: 20pt, weight: lower(fila.weight-label))[AaBbCc — 123]],
              align(left + horizon)[#text(font: family(key), size: 8pt, weight: lower(fila.weight-label))[#pangrama]],
            )
            v(4pt)
          }
        ]
      ]
    ],
  )
}

// Ficha de combinación: documento de ejemplo con display de títulos y
// body de cuerpo, resueltos desde la pareja (no nombres sueltos).
#let typography-pair(nombre) = {
  let roles = (pairings.library).at(nombre)
  let heading-font = family(roles.display)
  let body-font = family(roles.body)
  align(left)[
    #text(size: 11pt)[Typography Pairing]
    #h(1fr)
    #context text(size: 11pt)[#counter(page).display() / #total]
  ]
  v(16pt)
  align(center)[#text(size: 20pt, weight: "bold")[Combinación de Tipografías]]
  v(16pt)
  grid(
    columns: (1fr, 1fr),
    column-gutter: 30pt,
    align(center)[
      #text(size: 11pt, fill: blue)[TÍTULOS]
      #v(8pt)
      #text(size: 16pt, weight: "bold")[#heading-font]
      #text(size: 9pt, fill: gray)[display · #nombre]
    ],
    align(center)[
      #text(size: 11pt, fill: blue)[CUERPO]
      #v(8pt)
      #text(size: 16pt, weight: "bold")[#body-font]
      #text(size: 9pt, fill: gray)[body · #nombre]
    ],
  )
  v(20pt)
  block(width: 100%, inset: 20pt, stroke: 1pt + gray.lighten(50%), radius: 8pt)[
    #text(font: heading-font, size: 24pt, weight: "bold")[El Arte de la Tipografía]
    #v(12pt)
    #text(font: heading-font, size: 16pt)[Introducción al Diseño Editorial]
    #v(10pt)
    #text(font: body-font, size: 10.5pt)[La tipografía es el arte y la técnica de organizar tipos para hacer que el lenguaje escrito sea legible, atractivo y efectivo cuando se muestra. El arreglo de tipos involuciona la selección de fuentes, tamaños de punto, longitudes de línea, espaciado entre líneas y espaciado entre letras.]
    #v(8pt)
    #text(font: body-font, size: 10.5pt)[La combinación correcta de tipografías puede transformar completamente la apariencia y la efectividad de un documento. Una buena pareja tipográfica crea contraste visual mientras mantiene la armonía y la cohesión en el diseño general.]
    #v(10pt)
    #text(font: heading-font, size: 14pt)[Principios de Combinación]
    #v(8pt)
    #text(font: body-font, size: 10.5pt)[Al combinar tipografías, es importante considerar el contraste, la complementariedad y el contexto. Las fuentes deben trabajar juntas para crear una jerarquía clara y guiar al lector a través del contenido de manera natural.]
  ]
}

#for (i, nombre) in (pairings.names)().enumerate() {
  if i > 0 { pagebreak() }
  typography-page(nombre)
  pagebreak()
  typography-pair(nombre)
}
