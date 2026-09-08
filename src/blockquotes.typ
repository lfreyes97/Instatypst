// ─── Blockquotes — citas reutilizables (Typst) ────────────────────
// Extraído de social.typ (sección 7) porque es un subsistema propio: a
// diferencia de las plantillas de social.typ, esto NO son canvas completos
// sino bloques de contenido para insertar en cualquier plantilla o página.
//
// Importa: #import "blockquotes.typ": *
// Solo depende de social.typ para 3 nombres (radius, avatar-row, palette) —
// dependencia en una sola dirección, igual que palettes.typ depende de
// theme.typ/tokens.typ. Nada en social.typ llama de vuelta a este archivo.

#import "theme.typ": theme
#import "idiomas.typ": gr, he
#import "social.typ": radius, avatar-row, palette

// ============ 7. BLOCKQUOTES — variedad de citas (bloque reutilizable) ============
// A diferencia de las plantillas anteriores, estas NO son un canvas: son
// bloques de contenido para insertar dentro de cualquier plantilla o página
// (una announce-post, un carousel-slide, o una página normal). Puerto de
// las ideas de cristianamente.typ, reescalado a las proporciones de este
// sistema (pensado para canvas de ~1080pt) y a la paleta de theme.typ.
//
// Convención compartida por las 7 — sin excepciones, para no repetir la
// inconsistencia que encontramos en el original: `autor`/`fuente` siempre
// nombrados y opcionales, `body` siempre primero y posicional, `theme:`
// siempre presente y reenviada a cualquier componente interno.
//
// Convención de tamaño (agregada tras el rediseño de la campaña): cada
// función que compone texto trae también `size: auto`. `auto` conserva
// el tamaño de cuerpo original de esa plantilla (el que tenía antes de
// esta convención); pasar un largo explícito (`size: 40pt`) fija el
// tamaño del elemento principal (el cuerpo de la cita, o el término en
// blockquote-definition) y el resto de los tamaños internos de esa
// misma llamada — comilla, atribución, ícono, etc. — se re-escalan en
// la MISMA proporción (`k = size / tamaño-base-de-esa-plantilla`), para
// que el conjunto se sienta diseñado a cualquier tamaño y no solo el
// cuerpo crezca mientras el resto queda desproporcionado. Es un control
// por-llamada (vive en el `size:` de esa invocación), no un tema global:
// dos citas con el mismo `theme:` pueden pedir tamaños distintos.
// bq-mark() ya seguía este patrón desde antes (su parámetro `size:` no
// es `auto` porque no tiene nada más que escalar).

// Cita editorial — doble borde, comilla grande, itálica
// `size:` (auto por defecto) controla el tamaño del cuerpo de la cita;
// la comilla y la línea de atribución escalan con él en la misma
// proporción (ver nota de escalado al final del archivo).
#let blockquote-editorial(body, autor: none, fuente: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 32pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 24pt, below: 24pt)[
    #block(stroke: 1pt + color.transparentize(70%), inset: 5pt, radius: radius)[
      #block(fill: theme.colors.white, stroke: 1.5pt + color.transparentize(70%), inset: (x: 40pt, y: 40pt), radius: radius, width: 100%)[
        #text(size: 60pt * k, fill: color.transparentize(75%), font: theme.fonts.display, weight: 900)[\u{201C}]
        #v(6pt)
        #text(font: theme.fonts.body, style: "italic", size: s, fill: theme.colors.dark, body)
        #if autor != none or fuente != none [
          #v(20pt)
          #line(length: 100%, stroke: 0.75pt + color.transparentize(70%))
          #v(14pt)
          #text(font: theme.fonts.body, size: 18pt * k, weight: 700, tracking: 0.12em, fill: gray.darken(20%))[
            #if autor != none { upper(autor) }
            #if autor != none and fuente != none { "  ·  " }
            #if fuente != none { upper(fuente) }
          ]
        ]
      ]
    ]
  ]
}

// Cita con barra de acento a la izquierda — variante: "default" | "grande" | "acento"
// `size:` sobreescribe el tamaño del cuerpo (por encima del que ya da
// `variante`) y escala la línea de atribución en la misma proporción.
#let blockquote-bar(body, autor: none, fuente: none, color: none, variante: "default", size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = if variante == "grande" { 44pt } else { 32pt }
  let s = if size == auto { base } else { size }
  let k = s / 32pt
  let acentuada = variante == "acento"
  block(width: 100%, above: 24pt, below: 24pt)[
    #block(
      fill: if acentuada { color.transparentize(93%) } else { none },
      stroke: (left: 5pt + color),
      inset: (left: 32pt, y: if acentuada { 24pt } else { 0pt }),
      width: 100%,
    )[
      #text(font: theme.fonts.body, style: "italic", size: s, fill: theme.colors.dark, body)
      #if autor != none or fuente != none [
        #v(16pt)
        #if autor != none [#text(font: theme.fonts.body, size: 22pt * k, weight: 700, fill: theme.colors.dark)[— #autor]]
        #if fuente != none [#text(font: theme.fonts.body, size: 20pt * k, style: "italic", fill: gray.darken(10%))[ · #fuente]]
      ]
    ]
  ]
}

// Tarjeta con barra superior de acento y pie de atribución
// `size:` controla el tamaño del cuerpo; el pie de autor/fuente escala
// en la misma proporción.
#let blockquote-card(body, autor: none, fuente: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 32pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 24pt, below: 24pt)[
    #block(fill: theme.colors.white, radius: radius, width: 100%, clip: true, stroke: 1pt + gray.lighten(70%))[
      #block(fill: color, height: 6pt, width: 100%)[]
      #block(inset: 36pt)[
        #text(font: theme.fonts.body, style: "italic", size: s, fill: theme.colors.dark, body)
      ]
      #if autor != none or fuente != none [
        #block(fill: theme.colors.light, stroke: (top: 0.75pt + gray.lighten(70%)), inset: (x: 36pt, y: 20pt), width: 100%)[
          // Un espacio de markup normal entre dos #text() de TAMAÑO
          // distinto (22pt vs 20pt) colapsa a ~0 en fuentes variables
          // como Urbanist/Hanken Grotesk: el shaper reutiliza el ancho
          // del glifo espacio de una sola instancia y lo aplasta al
          // pasar de tamaño. Por eso "— Autor" y "Fuente" quedaban
          // pegados aunque el espacio literal estuviera en el código.
          // Un #h() con longitud explícita no depende del shaping de
          // fuente y siempre separa de forma confiable.
          #if autor != none [#text(font: theme.fonts.body, size: 22pt * k, weight: 700, fill: theme.colors.dark)[— #autor]]#if autor != none and fuente != none [#h(0.4em)]#if fuente != none [#text(font: theme.fonts.body, size: 20pt * k, style: "italic", fill: gray.darken(10%))[#fuente]]
        ]
      ]
    ]
  ]
}

// Cita dramática, centrada, a todo el ancho — para abrir un slide o sección
// `size:` controla el tamaño del titular; la comilla y la atribución
// escalan con él.
#let blockquote-hero(body, autor: none, fuente: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  let base = 48pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 36pt, below: 36pt)[
    #align(center)[
      #text(size: 86pt * k, fill: color.transparentize(70%), font: theme.fonts.display, weight: 900)[\u{201C}]
      #v(-16pt)
      #text(font: theme.fonts.display, weight: 700, size: s, fill: theme.colors.dark, body)
      #if autor != none or fuente != none [
        #v(24pt)
        #if autor != none [#text(font: theme.fonts.body, size: 24pt * k, weight: 700, tracking: 0.1em, fill: gray.darken(20%))[— #upper(autor)]]
        #if fuente != none [#linebreak() #text(font: theme.fonts.body, style: "italic", size: 22pt * k, fill: gray.darken(10%), fuente)]
      ]
    ]
  ]
}

// Tarjeta independiente con avatar — reutiliza avatar-row() de la sección 5.
// `iniciales` es explícito (no se deriva de `autor`): así evitamos el bug
// que encontramos en cristianamente.typ (crash si autor no era texto plano).
#let blockquote-avatar(body, autor: none, fuente: none, iniciales: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 28pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(
    fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: radius, inset: 32pt, width: 100%,
  )[
    #text(font: theme.fonts.body, style: "italic", size: s, fill: theme.colors.dark, body)
    #if autor != none or iniciales != none [
      #v(20pt)
      #line(length: 100%, stroke: 0.75pt + gray.lighten(70%))
      #v(16pt)
      #if iniciales != none {
        avatar-row(
          if autor != none { autor } else { "" },
          if fuente != none { fuente } else { "" },
          iniciales,
          bg-color: color,
          theme: theme,
        )
      } else if autor != none {
        text(font: theme.fonts.body, size: 24pt * k, weight: 700, fill: theme.colors.dark, autor)
      }
    ]
  ]
}

// Cita manuscrita, centrada — usa Caveat (bundled en Fonts/, a diferencia de
// Kalam en cristianamente.typ). Compilar con `--font-path Fonts`.
#let blockquote-hand(body, autor: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  let base = 40pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 28pt, below: 28pt)[
    #align(center)[
      #text(font: "Caveat", size: s, fill: theme.colors.dark, body)
      #if autor != none [
        #v(10pt)
        #text(font: "Caveat", size: 28pt * k, fill: color)[— #autor]
      ]
    ]
  ]
}

// Acomoda varias blockquote-avatar en 2 o 3 columnas
// Uso: blockquote-grid(columnas: 3, (blockquote-avatar(...), blockquote-avatar(...)))
#let blockquote-grid(tarjetas, columnas: 2) = block(width: 100%, above: 24pt, below: 24pt)[
  #grid(columns: (1fr,) * columnas, gutter: 24pt, ..tarjetas)
]

// Texto bíblico en paralelo — versículo completo en el idioma original
// junto a su traducción, en dos columnas. Para hebreo pone la columna
// original en RTL (grid() voltea el orden visual solo con dir: rtl, ver
// idiomas.typ); para griego usa GFS Didot (o Libertinus Serif si
// autentico: false) vía gr()/he() de idiomas.typ.
#let blockquote-paralelo(
  original,
  traduccion,
  idioma: "griego", // "griego" | "hebreo"
  autentico: true,
  referencia: none,
  color: none,
  size: auto,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  let es-rtl = idioma == "hebreo"
  let base = 24pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 24pt, below: 24pt, fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: radius, inset: 28pt)[
    #if referencia != none [
      #text(font: theme.fonts.body, size: 18pt * k, weight: 700, fill: color, referencia)
      #v(14pt)
    ]
    #let celda-original = [
      #set text(dir: if es-rtl { rtl } else { ltr })
      #set align(if es-rtl { right } else { left })
      #if idioma == "hebreo" { he(text(size: s, original)) } else { gr(text(size: s, original), autentico: autentico) }
    ]
    #let celda-traduccion = [
      #set text(font: theme.fonts.body, size: 20pt * k, style: "italic", fill: theme.colors.dark)
      #traduccion
    ]
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 28pt,
      align: (horizon, horizon),
      ..if es-rtl { (celda-traduccion, celda-original) } else { (celda-original, celda-traduccion) }
    )
  ]
}

// Cita con atribución lateral rotada — barra vertical con autor/fuente
// (rotate(270deg), se lee girando la cabeza a la derecha) junto al cuerpo
// de la cita, numerado opcionalmente. Puerto de un patrón editorial
// (cita de Pascal con atribución de lado), con los tokens de este tema
// en vez de fuentes sueltas.
#let blockquote-lateral(
  body,
  autor: none,
  fuente: none,
  n: none,
  color: none,
  size: auto,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 32pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 24pt, below: 24pt)[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 18pt,
      align: (bottom, top),
      if autor != none or fuente != none {
        align(bottom)[
          #rotate(270deg, reflow: true)[
            // 16pt/15pt (el tamaño original de este bloque) es escala de
            // párrafo impreso, no de lienzo de ~1080pt — al lado de
            // cualquier otro blockquote-* de este archivo (26-34pt) se ve
            // como texto perdido. Subido a la escala del resto del sistema.
            #text(font: theme.fonts.body, weight: 700, size: 20pt * k, fill: color)[
              #if autor != none [#autor]
              #if autor != none and fuente != none [ — ]
              #if fuente != none [#text(style: "italic", fill: theme.colors.dark)[#fuente]]
            ]
          ]
        ]
      } else { [] },
      [
        #set par(justify: true)
        #set text(font: theme.fonts.body, size: s, fill: theme.colors.dark)
        #if n != none [#text(weight: 700)[#n.] ]
        #body
      ],
    )
  ]
}

// ── NUEVOS · con finetuning (no-GFM) ──

// Pull-quote — comilla gigante detrás del texto, filete corto, display 800.
// Pensado para portadas/carrusel donde `blockquote-hero` centrado se queda corto.
// `marca: none` lo deja minimal; `color:` controla comilla y filete.
#let blockquote-pull(body, autor: none, fuente: none, marca: "“", color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 46pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 28pt, below: 28pt)[
    #if marca != none {
      place(dx: -10pt, dy: -30pt)[
        #text(font: theme.fonts.display, size: 180pt * k, fill: color.transparentize(88%), weight: 900, marca)
      ]
    }
    #pad(x: 28pt, y: 12pt)[
      #text(font: theme.fonts.display, weight: 800, size: s, fill: theme.colors.dark, body)
      #if autor != none or fuente != none [
        #v(18pt)
        #box(fill: color, height: 3pt, width: 48pt)
        #v(10pt)
        #text(font: theme.fonts.body, size: 20pt * k, weight: 700, fill: theme.colors.dark)[
          #if autor != none [#autor]
          #if fuente != none [#text(style: "italic", fill: gray.darken(10%))[ — #fuente]]
        ]
      ]
    ]
  ]
}

// Definición / glosario — porte de `definicion` de cristianamente.typ
// `termino` + `/pronunciación/` + badge `origen` + cuerpo + pills `relacionados`.
// `size:` controla el tamaño del término (encabezado); pronunciación,
// badge de origen, cuerpo y pills escalan con él.
#let blockquote-definition(termino, body, pronunciacion: none, origen: none, relacionados: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 40pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 24pt, below: 24pt, fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: radius, inset: 32pt)[
    #text(font: theme.fonts.display, weight: 900, size: s, fill: theme.colors.dark, termino)
    #if pronunciacion != none [#h(10pt) #text(font: theme.fonts.body, size: 18pt * k, fill: gray, style: "italic")[/#pronunciacion/]]
    #if origen != none [#h(8pt) #box(fill: color.transparentize(88%), inset: (x: 8pt, y: 4pt), radius: 100pt)[#text(size: 14pt * k, fill: color, weight: 700, origen)]]
    #v(14pt)
    #set text(font: theme.fonts.body, size: 26pt * k, fill: theme.colors.dark)
    #set par(leading: 0.85em)
    #body
    #if relacionados != none and relacionados.len() > 0 [
      #v(14pt) #line(length: 100%, stroke: 0.75pt + gray.lighten(70%)) #v(10pt)
      #text(size: 16pt * k, fill: gray, weight: 600)[Ver también: ]
      #for (i, r) in relacionados.enumerate() [
        #box(fill: theme.colors.light, inset: (x: 8pt, y: 4pt), radius: 100pt)[#text(size: 16pt * k, fill: gray.darken(20%), r)] #h(6pt)
      ]
    ]
  ]
}

// Callout — tip/info/warning/marginal con icono + barra lateral.
// Reemplazo con *intención* para `blockquote-bar` acentuado genérico.
// `size:` controla el tamaño del cuerpo (26pt normal / 28pt en "hand");
// ícono y título escalan con él.
#let blockquote-callout(body, titulo: none, icono: "✦", variante: "tip", color: none, size: auto, theme: theme.base) = {
  // Bug encontrado en auditoría (docs/oportunidades-mejora.md #13): estos
  // defaults usaban `palette` (= theme.base.colors, importado de social.typ),
  // fijo al tema por defecto sin importar qué `theme:` recibiera esta misma
  // función — cualquier tema custom sin `color:` explícito salía con los
  // colores del tema por defecto. `warn` se deja como semántico fijo a
  // propósito (amarillo de advertencia, igual en cualquier tema — no
  // "accent"/"primary" de este theme:).
  let defaults = (tip: theme.colors.accent, info: theme.colors.primary, warn: rgb("#EAB308"), hand: theme.colors.secondary)
  let color = if color == none { defaults.at(variante, default: theme.colors.accent) } else { color }
  let base = if variante == "hand" { 28pt } else { 26pt }
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 20pt, below: 20pt, fill: color.transparentize(92%), stroke: (left: 5pt + color), inset: (x: 28pt, y: 22pt), radius: 12pt)[
    #grid(columns: (auto, 1fr), gutter: 14pt, align: (top, top),
      text(size: 28pt * k, icono),
      [
        #if titulo != none [#text(font: theme.fonts.body, size: 20pt * k, weight: 800, fill: color, upper(titulo)) #v(6pt)]
        #if variante == "hand" {
          text(font: "Caveat", size: s, fill: theme.colors.dark, body)
        } else {
          text(font: theme.fonts.body, size: s, fill: theme.colors.dark, body)
        }
      ]
    )
  ]
}

// Poesía / verso — respeta saltos, sin justificar, sangría colgante.
#let blockquote-poetry(body, autor: none, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  let base = 26pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 24pt, below: 24pt, fill: theme.colors.white, stroke: (left: 3pt + color.transparentize(50%)), inset: (x: 28pt, y: 20pt), radius: 8pt)[
    #set text(font: theme.fonts.body, size: s, fill: theme.colors.dark)
    #set par(leading: 0.95em, justify: false, first-line-indent: 0pt, hanging-indent: 1em)
    #body
    #if autor != none [#v(10pt) #align(right)[#text(font: theme.fonts.body, size: 18pt * k, fill: gray, style: "italic")[— #autor]]]
  ]
}

// Timeline — fecha a la izquierda + regla vertical + cuerpo.
// `size:` controla el cuerpo; la fecha escala con él (la regla vertical
// es un elemento gráfico, no tipografía, y se deja fija).
#let blockquote-timeline(fecha, body, color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let base = 22pt
  let s = if size == auto { base } else { size }
  let k = s / base
  block(width: 100%, above: 18pt, below: 18pt)[
    #grid(columns: (auto, auto, 1fr), gutter: 14pt, align: (top, top, top),
      text(font: theme.fonts.body, size: 18pt * k, weight: 800, fill: color, fecha),
      box(width: 3pt, height: 44pt, fill: color.transparentize(65%), radius: 2pt),
      [#set text(font: theme.fonts.body, size: s, fill: theme.colors.dark); #set par(leading: 0.85em); #body],
    )
  ]
}

// ── LEGOS — primitives componibles (edificio de legos) ──
// Cada blockquote-* de arriba pasa a ser una *receta* con estos legos.
// Exponerlos permite armar brutalista/glass/editorial sin pedir `estilo:` monolítico.

#let bq-mark(texto, size: 60pt, fill: none, theme: theme.base, detras: false) = {
  let fill = if fill == none { theme.colors.primary.transparentize(75%) } else { fill }
  if detras {
    place(dx: -10pt, dy: -30pt)[#text(font: theme.fonts.display, size: 180pt, fill: fill.transparentize(30%), weight: 900, texto)]
  } else {
    text(font: theme.fonts.display, size: size, fill: fill, weight: 900, texto)
  }
}

#let bq-rule(color: none, width: 48pt, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  box(fill: color, height: 3pt, width: width, radius: 1.5pt)
}

#let bq-rule-full(color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  line(length: 100%, stroke: 0.75pt + color.transparentize(70%))
}

// Tamaños subidos a escala de lienzo (~1080pt): 9-11pt es escala de
// párrafo impreso — junto a cualquier otro bq-*/blockquote-* de este
// archivo (18-34pt) quedaba ilegible en un canvas social.
// `size:` escala el modo activo como conjunto (en "pro", autor/fuente
// mantienen su proporción 20pt/18pt entre sí).
#let bq-attribution(autor: none, fuente: none, modo: "pro", color: none, size: auto, theme: theme.base) = {
  let color = if color == none { theme.colors.dark } else { color }
  if modo == "mono" {
    // Brutalista: DM Mono + upper + caja de color
    let s = if size == auto { 16pt } else { size }
    if autor != none or fuente != none {
      let label = if autor != none and fuente != none { upper(autor) + " · " + upper(fuente) } else if autor != none { upper(autor) } else { upper(fuente) }
      box(fill: theme.colors.primary, inset: (x: 10pt, y: 5pt))[#text(font: "DM Mono", size: s, weight: 700, fill: white, label)]
    }
  } else if modo == "caps" {
    let s = if size == auto { 16pt } else { size }
    text(font: theme.fonts.body, size: s, weight: 700, tracking: 0.12em, fill: gray.darken(20%))[
      #if autor != none { upper(autor) }
      #if autor != none and fuente != none { "  ·  " }
      #if fuente != none { upper(fuente) }
    ]
  } else {
    // pro — el " · " ya viene incrustado al inicio del texto de la
    // fuente (mismo tamaño de esa corrida), así que no depende del
    // espacio de markup entre los dos #if (ver nota sobre #h() más
    // arriba en blockquote-card para el caso donde sí hace falta).
    let base = 20pt
    let s = if size == auto { base } else { size }
    let k = s / base
    [#if autor != none [#text(font: theme.fonts.body, size: s, weight: 700, fill: color)[— #autor]]#if fuente != none [#text(font: theme.fonts.body, size: 18pt * k, style: "italic", fill: gray.darken(10%))[ · #fuente]]]
  }
}

#let bq-frame(body, tipo: "soft", color: none, theme: theme.base, radius: none, inset: none) = {
  let color = if color == none { theme.colors.primary } else { color }
  if tipo == "hard" {
    // Brutalista: radius 0, borde 3.5pt negro, sombra offset contenida (pad extra para no desbordar grillas)
    let r = if radius == none { 0pt } else { radius }
    let padv = if inset == none { 22pt } else { inset }
    pad(right: 6pt, bottom: 6pt)[
      #block(width: 100%, above: 12pt, below: 12pt, fill: black, radius: r, inset: 0pt)[
        #block(fill: white, stroke: 3.5pt + black, radius: r, inset: padv, width: 100%, height: 100%)[#body]
      ]
    ]
  } else if tipo == "glass" {
    // Glass: filling translúcido + borde fino + gradient subyacente
    let r = if radius == none { 16pt } else { radius }
    let padv = if inset == none { 16pt } else { inset }
    block(width: 100%, above: 12pt, below: 12pt, fill: gradient.linear(angle: 135deg, color.transparentize(82%), white.transparentize(30%)), stroke: 0.7pt + white.transparentize(20%), radius: r + 2pt, inset: 1pt)[
      #block(fill: white.transparentize(35%), stroke: 0.6pt + color.transparentize(70%), radius: r, inset: padv, width: 100%)[#body]
    ]
  } else {
    // soft = modern (default, compatible)
    let r = if radius == none { 24pt } else { radius }
    let padv = if inset == none { 32pt } else { inset }
    block(width: 100%, above: 12pt, below: 12pt, fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: r, inset: padv)[#body]
  }
}
