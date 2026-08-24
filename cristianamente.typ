// ============================================================================
// cristianamente.typ
// Paquete de maquetación para Typst — refleja el sistema de diseño del sitio
// cristianamente.xyz (tema "Paper"): paleta de color, tipografía y los
// componentes editoriales que ya existen en Astro (EditorialQuote, LongQuote,
// ScriptureBlock, Definition, CrossRef), traducidos a funciones de Typst.
//
// Uso mínimo:
//   #import "cristianamente.typ": *
//   #show: articulo.with(titulo: "...", categoria: "Teología", autor: "...", fecha: "...")
//   Cuerpo del ensayo...
//   #cita-editorial("...", autor: "...", fuente: "...", año: "...")
// ============================================================================

// ---------------------------------------------------------------------------
// Paleta — tema "Paper", modo claro (calcada de src/styles/colors/paper.css)
// ---------------------------------------------------------------------------
#let color = (
  bg: rgb("#fdfbf7"),
  bg-offset: rgb("#f5f2eb"),
  surface: rgb("#ffffff"),
  text: rgb("#2c2c2c"),
  text-muted: rgb("#5e5a55"),
  primary: rgb("#1a1a1a"),
  primary-dark: rgb("#000000"),
  secondary: rgb("#8b2e3a"),
  secondary-light: rgb("#a83a48"),
  accent: rgb("#b0753b"),
  border: rgb("#e8e6e1"),
  border-subtle: rgb("#f0eeea"),
)

// Variante "modo oscuro" del mismo tema, por si se necesita una edición
// nocturna del documento (calcada de [data-theme="paper"][data-mode="dark"]).
#let color-dark = (
  bg: rgb("#1c1b1a"),
  bg-offset: rgb("#242220"),
  surface: rgb("#2b2926"),
  text: rgb("#e6e1dc"),
  text-muted: rgb("#a6a09a"),
  primary: rgb("#fdfbf7"),
  primary-dark: rgb("#e8e6e1"),
  secondary: rgb("#d45d6a"),
  secondary-light: rgb("#e87a85"),
  accent: rgb("#d4a373"),
  border: rgb("#3d3a36"),
  border-subtle: rgb("#2b2926"),
)

// ---------------------------------------------------------------------------
// Tipografía — misma asignación de roles que uno.config.ts (presetWebFonts)
// ---------------------------------------------------------------------------
// * "mono" en el sitio es Iosevka. Iosevka no se distribuye vía Google Fonts
//   y no fue posible descargarlo en este entorno; se usa DejaVu Sans Mono
//   como sustituto de ancho fijo. Si tienes los .ttf de Iosevka, cópialos a
//   fonts/ y cambia el valor de font.mono a "Iosevka" — el resto del paquete
//   no necesita cambios.
#let font = (
  display: "Fraunces",      // títulos — equivalente a font-display
  serif: "EB Garamond",     // cuerpo de texto — equivalente a font-serif
  sans: "Urbanist",         // metadatos / UI — equivalente a font-sans
  mono: "DejaVu Sans Mono", // etiquetas con tracking ancho — sustituto de Iosevka*
  hand1: "Kalam",           // notas manuscritas (HandwrittenQuote, PostIt)
  hand2: "Architects Daughter", // sidenotes manuscritas (SidenoteHandwritten)
)

// ---------------------------------------------------------------------------
// Radios y anchos de borde (equivalentes a --radius-* / --border-width, en pt
// en vez de rem — 1rem ≈ 16px ≈ 12pt a la resolución tipográfica habitual)
// ---------------------------------------------------------------------------
#let radius = (
  sm: 3pt,
  md: 4.5pt,
  lg: 7pt,
  xl: 9pt,
)
#let border-width = 0.6pt

// ---------------------------------------------------------------------------
// Plantilla de página / artículo
// ---------------------------------------------------------------------------
#let articulo(
  titulo: none,
  subtitulo: none,
  categoria: none,
  autor: none,
  fecha: none,
  paper: "a4",
  modo-oscuro: false,
  doc,
) = {
  let c = if modo-oscuro { color-dark } else { color }

  set page(
    paper: paper,
    margin: (x: 22mm, top: 26mm, bottom: 24mm),
    fill: c.bg,
    numbering: "1",
    number-align: center,
  )
  set text(font: font.serif, size: 11pt, fill: c.text, lang: "es")
  set par(justify: true, leading: 0.78em, first-line-indent: 1.1em, spacing: 1.1em)

  // Encabezados — usan la tipografía display (Fraunces), como .text-display
  // en el sitio (font-serif font-bold tracking-tight allí; aquí, display).
  show heading.where(level: 1): it => block(above: 2em, below: 1em)[
    #set text(font: font.display, weight: 800, size: 17pt, fill: c.primary)
    #set par(first-line-indent: 0pt)
    #it.body
  ]
  show heading.where(level: 2): it => block(above: 1.6em, below: 0.8em)[
    #set text(font: font.display, weight: 700, size: 13.5pt, fill: c.primary)
    #set par(first-line-indent: 0pt)
    #it.body
  ]

  // Enlaces — color secundario, como .text-secondary en hover del sitio
  show link: it => text(fill: c.secondary, it)

  // Cabecera / portada del artículo
  if titulo != none {
    align(center)[
      #if categoria != none [
        #text(font: font.mono, size: 8pt, tracking: 0.22em, fill: c.secondary, upper(categoria))
        #v(0.7em)
      ]
      #text(font: font.display, weight: 900, size: 21pt, fill: c.primary, titulo)
      #if subtitulo != none [
        #v(0.5em)
        #text(font: font.serif, style: "italic", size: 12pt, fill: c.text-muted, subtitulo)
      ]
      #v(0.9em)
      #line(length: 24%, stroke: border-width + c.border)
      #if autor != none or fecha != none [
        #v(0.9em)
        #text(font: font.sans, size: 8.5pt, fill: c.text-muted, tracking: 0.03em)[
          #if autor != none [#autor]
          #if autor != none and fecha != none [ · ]
          #if fecha != none [#fecha]
        ]
      ]
    ]
    v(2.2em)
  }

  doc
}

// ---------------------------------------------------------------------------
// cita-editorial — equivalente a EditorialQuote.astro
// Bloque de doble borde, comillas grandes, tipografía serif itálica.
// ---------------------------------------------------------------------------
#let cita-editorial(cita, autor: none, fuente: none, año: none, modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  block(above: 1.6em, below: 1.6em, width: 100%)[
    #block(
      stroke: 0.5pt + c.border,
      inset: 3pt,
      radius: radius.sm,
      width: 100%,
    )[
      #block(
        fill: c.surface,
        stroke: border-width + c.border,
        inset: (x: 20pt, y: 24pt),
        radius: radius.sm,
        width: 100%,
      )[
        #set text(font: font.serif, style: "italic", size: 13pt, fill: c.primary)
        #set par(first-line-indent: 1.4em, leading: 0.85em)
        #text(size: 26pt, fill: c.secondary.transparentize(75%), font: font.serif)[\u{201C}]
        #h(-4pt)
        #cita
        #if autor != none or fuente != none or año != none [
          #v(10pt)
          #line(length: 100%, stroke: 0.4pt + c.border.transparentize(30%))
          #v(6pt)
          #set text(font: font.mono, size: 7.3pt, tracking: 0.16em, fill: c.text-muted, style: "normal")
          #{
            let partes = ()
            if autor != none { partes.push(strong(upper(autor))) }
            if fuente != none { partes.push(upper(fuente)) }
            if año != none { partes.push(año) }
            partes.join("  ·  ")
          }
        ]
      ]
    ]
  ]
}

// ---------------------------------------------------------------------------
// cita-larga — equivalente a LongQuote.astro
// Tarjeta con barra superior de acento y pie de atribución.
// ---------------------------------------------------------------------------
#let cita-larga(body, autor: none, fuente: none, año: none, modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  block(above: 1.6em, below: 1.6em, width: 100%)[
    #block(
      fill: c.surface,
      stroke: border-width + c.border-subtle,
      radius: radius.lg,
      width: 100%,
      clip: true,
    )[
      #block(fill: c.secondary.transparentize(35%), height: 2.4pt, width: 100%)[]
      #block(inset: (x: 20pt, y: 20pt))[
        #set text(font: font.serif, style: "italic", size: 11.5pt, fill: c.primary)
        #set par(leading: 0.85em, first-line-indent: 0pt, spacing: 0.9em)
        #body
      ]
      #block(
        fill: c.bg-offset.transparentize(50%),
        stroke: (top: 0.4pt + c.border-subtle),
        inset: (x: 20pt, y: 12pt),
        width: 100%,
      )[
        #set text(font: font.sans, size: 9.5pt, fill: c.primary, style: "normal")
        — #strong(autor)
        #if fuente != none [ #text(font: font.serif, style: "italic", fill: c.text-muted)[#fuente]]
        #if año != none [ #text(font: font.mono, size: 8pt, fill: c.text-muted.transparentize(20%))[(#año)]]
      ]
    ]
  ]
}

// ---------------------------------------------------------------------------
// escritura — equivalente a ScriptureBlock.astro
// Barra de acento a la izquierda + referencia en mayúsculas con tracking.
// ---------------------------------------------------------------------------
#let escritura(body, referencia: none, version: none, modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  block(above: 1.4em, below: 1.4em, width: 100%)[
    #block(
      stroke: (left: 2.2pt + c.accent.transparentize(55%)),
      inset: (left: 13pt),
      width: 100%,
    )[
      #text(font: font.mono, size: 8pt, weight: "bold", tracking: 0.18em, fill: c.accent, upper(referencia))
      #if version != none [
        #h(4pt)
        #text(font: font.mono, size: 7pt, fill: c.text-muted.transparentize(30%))[(#version)]
      ]
      #v(4pt)
      #set text(font: font.serif, style: "italic", size: 12.5pt, fill: c.primary)
      #set par(leading: 0.8em, first-line-indent: 0pt)
      #body
    ]
  ]
}

// ---------------------------------------------------------------------------
// definicion — equivalente a Definition.astro
// Término + pronunciación + origen, con lista opcional de relacionados.
// ---------------------------------------------------------------------------
#let definicion(
  termino,
  origen: none,
  pronunciacion: none,
  relacionados: none,
  modo-oscuro: false,
  body,
) = {
  let c = if modo-oscuro { color-dark } else { color }
  block(above: 1.4em, below: 1.4em, width: 100%)[
    #text(font: font.display, weight: 900, size: 14pt, fill: c.primary, termino)
    #if pronunciacion != none [
      #h(6pt)
      #text(font: font.mono, size: 9pt, fill: c.text-muted)[/#pronunciacion/]
    ]
    #if origen != none [
      #h(6pt)
      #box(
        fill: c.accent.transparentize(85%),
        inset: (x: 5pt, y: 2pt),
        radius: radius.xl,
      )[#text(font: font.mono, size: 7pt, fill: c.accent, origen)]
    ]
    #v(6pt)
    #set text(font: font.serif, size: 10.5pt, fill: c.text)
    #set par(first-line-indent: 0pt, leading: 0.8em)
    #body
    #if relacionados != none and relacionados.len() > 0 [
      #v(8pt)
      #line(length: 100%, stroke: 0.4pt + c.border-subtle)
      #v(6pt)
      #text(font: font.mono, size: 7.5pt, fill: c.text-muted)[Ver también: ]
      #for (i, r) in relacionados.enumerate() [
        #box(
          fill: c.bg-offset,
          inset: (x: 5pt, y: 2pt),
          radius: radius.xl,
        )[#text(font: font.mono, size: 7.5pt, fill: c.text-muted, r)]
        #if i < relacionados.len() - 1 { h(4pt) }
      ]
    ]
  ]
}

// ---------------------------------------------------------------------------
// ver-tambien — equivalente a CrossRef.astro
// En papel no hay hover ni navegación, así que se resuelve como una tarjeta
// de referencia con enlace activo (útil si el PDF se lee en pantalla).
// ---------------------------------------------------------------------------
#let ver-tambien(
  titulo,
  href: none,
  autor: none,
  tipo: "cita",
  modo-oscuro: false,
  body,
) = {
  let c = if modo-oscuro { color-dark } else { color }
  let etiquetas = (cita: "Cita", ensayo: "Ensayo", debate: "Debate")
  let etiqueta = etiquetas.at(tipo, default: tipo)

  let contenido = block(
    fill: c.surface,
    stroke: border-width + c.border-subtle,
    inset: (x: 14pt, y: 11pt),
    radius: radius.md,
    width: 100%,
  )[
    #text(font: font.mono, size: 7pt, weight: "bold", tracking: 0.15em, fill: c.secondary, upper(etiqueta))
    #if autor != none [
      #text(font: font.mono, size: 7pt, fill: c.text-muted)[ · #autor]
    ]
    #v(2pt)
    #text(font: font.serif, weight: "bold", size: 10.5pt, fill: c.primary, titulo)
    #if body != none [
      #v(2pt)
      #text(font: font.serif, style: "italic", size: 8.5pt, fill: c.text-muted, body)
    ]
  ]

  block(above: 1.2em, below: 1.2em, width: 100%)[
    #if href != none { link(href, contenido) } else { contenido }
  ]
}

// ---------------------------------------------------------------------------
// nota-manuscrita — inspirado en SidenoteHandwritten.astro / PostIt.astro
// Texto en Kalam o Architects Daughter, para acotaciones informales.
// ---------------------------------------------------------------------------
#let nota-manuscrita(body, fuente: "kalam", modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  let tipografia = if fuente == "architects" { font.hand2 } else { font.hand1 }
  block(above: 1em, below: 1em)[
    #set text(font: tipografia, size: 12pt, fill: c.secondary)
    #set par(leading: 0.7em, first-line-indent: 0pt)
    #body
  ]
}

// ---------------------------------------------------------------------------
// cita-bloque — equivalente a QuoteBlock.astro
// El blockquote "por defecto" del sitio: barra izquierda + serif itálica.
// variante: "default" | "grande" | "acento"
// ---------------------------------------------------------------------------
#let cita-bloque(body, autor: none, fuente: none, variante: "default", modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  let tamaño = if variante == "grande" { 16pt } else { 12.5pt }
  let acentuada = variante == "acento"
  block(above: 1.6em, below: 1.6em, width: 100%)[
    #block(
      fill: if acentuada { c.secondary.transparentize(93%) } else { none },
      stroke: (left: 2.6pt + (if acentuada { c.secondary } else { c.primary })),
      inset: (left: 16pt, y: if acentuada { 10pt } else { 0pt }),
      width: 100%,
    )[
      #set text(font: font.serif, style: "italic", size: tamaño, fill: c.primary)
      #set par(leading: 0.82em, first-line-indent: 0pt)
      #body
      #if autor != none or fuente != none [
        #v(8pt)
        #set text(style: "normal")
        #if autor != none [
          #text(font: font.sans, size: 9pt, weight: "bold", fill: c.primary)[— #autor]
        ]
        #if fuente != none [
          #h(4pt)
          #text(font: font.mono, size: 8pt, style: "italic", fill: c.text-muted)[#fuente]
        ]
      ]
    ]
  ]
}

// ---------------------------------------------------------------------------
// cita-heroica — equivalente a QuoteHero.astro
// Cita dramática a todo el ancho, para abrir un artículo o una sección.
// ---------------------------------------------------------------------------
#let cita-heroica(body, autor: none, fuente: none, modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  block(above: 2.4em, below: 2.4em, width: 100%)[
    #align(center)[
      #text(size: 32pt, fill: c.secondary.transparentize(70%), font: font.serif)[\u{201C}]
      #v(-6pt)
      #text(font: font.display, weight: 700, size: 18pt, fill: c.primary, body)
      #if autor != none or fuente != none [
        #v(10pt)
        #if autor != none [
          #text(font: font.mono, size: 8.5pt, weight: "bold", tracking: 0.18em, fill: c.text-muted)[— #upper(autor)]
        ]
        #if fuente != none [
          #linebreak()
          #text(font: font.serif, style: "italic", size: 8.5pt, fill: c.text-muted.transparentize(20%))[#fuente]
        ]
      ]
    ]
  ]
}

// ---------------------------------------------------------------------------
// cita-manuscrita — equivalente a HandwrittenQuote.astro
// Cita centrada en Kalam, con comillas decorativas grandes de fondo.
// (Distinta de nota-manuscrita: esa es para acotaciones cortas al margen;
// esta es un blockquote completo con atribución.)
// ---------------------------------------------------------------------------
#let cita-manuscrita(body, autor: none, modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  block(above: 2em, below: 2em, width: 100%, inset: (x: 18pt, y: 8pt))[
    #align(center)[
      #text(font: font.hand1, size: 15pt, fill: c.primary)[
        #set par(leading: 0.75em, first-line-indent: 0pt)
        #body
      ]
      #if autor != none [
        #v(10pt)
        #text(font: font.hand1, size: 11pt, fill: c.text-muted)[— #autor]
      ]
    ]
  ]
}

// ---------------------------------------------------------------------------
// cita-tarjeta — equivalente a QuoteCard.astro
// Tarjeta independiente para usar sola o dentro de grid-citas.
// ---------------------------------------------------------------------------
// Extrae texto plano de `autor` sea cual sea su tipo (str o content simple);
// si no se puede (p. ej. contenido con formato mixto), no falla — cede "?".
#let _texto-plano(v) = {
  if v == none { none }
  else if type(v) == str { v }
  else if type(v) == content and v.func() == text { v.text }
  else { none }
}

#let cita-tarjeta(body, autor: none, fuente: none, categoria: none, modo-oscuro: false) = {
  let c = if modo-oscuro { color-dark } else { color }
  let autor-txt = _texto-plano(autor)
  let inicial = if autor-txt != none { upper(autor-txt.slice(0, 1)) } else { "?" }
  block(
    fill: c.surface,
    stroke: border-width + c.border-subtle,
    inset: (x: 14pt, y: 14pt),
    radius: radius.lg,
    width: 100%,
  )[
    #if categoria != none [
      #text(font: font.mono, size: 7pt, weight: "bold", tracking: 0.15em, fill: c.secondary, upper(categoria))
      #v(6pt)
    ]
    #text(font: font.serif, style: "italic", size: 11pt, fill: c.primary, body)
    #v(10pt)
    #line(length: 100%, stroke: 0.4pt + c.border-subtle)
    #v(8pt)
    #grid(
      columns: (auto, auto),
      column-gutter: 8pt,
      align: horizon,
      box(
        width: 16pt,
        height: 16pt,
        fill: c.secondary.transparentize(88%),
        radius: 8pt,
      )[
        #align(center + horizon)[#text(font: font.sans, size: 7.5pt, weight: "bold", fill: c.secondary, inicial)]
      ],
      [
        #if autor != none [
          #text(font: font.sans, size: 8.5pt, weight: "bold", fill: c.primary)[#autor]
        ]
        #if fuente != none [
          #linebreak()
          #text(font: font.serif, style: "italic", size: 7.5pt, fill: c.text-muted)[#fuente]
        ]
      ],
    )
  ]
}

// ---------------------------------------------------------------------------
// grid-citas — equivalente a QuoteGrid.astro
// Acomoda varias cita-tarjeta en 2 o 3 columnas.
// Uso: grid-citas(columnas: 3, (cita-tarjeta(...), cita-tarjeta(...), ...))
// ---------------------------------------------------------------------------
#let grid-citas(tarjetas, columnas: 2) = {
  block(above: 1.6em, below: 1.6em, width: 100%)[
    #grid(
      columns: (1fr,) * columnas,
      gutter: 12pt,
      ..tarjetas
    )
  ]
}
