// ─── Sistema de Diseño para Redes Sociales (Typst) ───────────────
// Importa: #import "social.typ": *
// Uso: ver examples.typ y examples-extra.typ
//
// Los tokens provienen de theme.typ (API de colores/fuentes).
//
// PERSONALIZAR EL TEMA — pásalo explícito con `theme:`, no lo sombrees:
//   #import "theme.typ": theme
//   #let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
//   #announce-post("NUEVO", [Título], [Subtítulo], "@mi_marca", theme: marca)
//
// Por qué NO alcanza con `#let palette = marca.colors` / `#let fonts =
// marca.fonts` después de importar: en Typst, las funciones de este archivo
// (badge, headline, canvas, announce-post, …) resuelven `palette`/`fonts`
// por closure — quedan ligadas al valor que tenían AQUÍ, en este archivo,
// en el momento en que se definieron. Reasignarlas en tu documento crea una
// variable nueva en TU scope; no toca lo que estas funciones ven por dentro.
// (Verificado: un `badge()` "sombreado" así sigue saliendo con el color del
// tema base, sin excepción.) Por eso cada función que depende de color o
// tipografía acepta `theme:` (por defecto `theme.base`) y lo reenvía
// explícitamente a cualquier función que llame internamente — es el único
// mecanismo que de verdad propaga un tema personalizado.
//
// `palette`/`fonts` siguen exportándose como alias de conveniencia del tema
// base, útiles si escribes markup propio directo (`#palette.primary` en tu
// documento) — pero NO uses ese patrón para personalizar plantillas.

#import "theme.typ": theme
#import "idiomas.typ": gr, he

// ============ 1. TOKENS DE DISEÑO ============

// Alias de conveniencia del tema base — ver nota arriba: sombrear esto NO
// cambia el comportamiento de ninguna función de este archivo.
#let palette = theme.base.colors
#let fonts = theme.base.fonts

// Tamaños de canvas por plataforma
#let sizes = (
  instagram: (1080, 1080),
  story: (1080, 1920),
  twitter: (1600, 900),
  linkedin: (1200, 1200),
)

// Radio de esquinas y espaciado
#let radius = 24pt
#let page-pad = 80pt

// ============ 2. FUNDACIONES ============

#let canvas(size, body, theme: theme.base) = page(
  width: size.at(0) * 1pt,
  height: size.at(1) * 1pt,
  margin: 0pt,
  fill: theme.colors.light,
  body,
)

#let bg(color) = {
  place(rect(width: 100%, height: 100%, fill: color))
}

// Fondo con gradiente
#let gradient-bg(from: none, to: none, theme: theme.base) = {
  let from = if from == none { theme.colors.primary } else { from }
  let to = if to == none { theme.colors.secondary } else { to }
  place(
    rect(width: 100%, height: 100%,
      fill: gradient.linear(angle: 135deg, from, to)),
  )
}

// Formas decorativas
#let blob(x, y, size, color, opacity: 20%) = place(
  dx: x, dy: y,
  circle(radius: size * 1pt, fill: color.transparentize(100% - opacity)),
)

// ============ 3. COMPONENTES ============

// Etiqueta / badge
// `variations:` pasa directo a text() — solo tiene efecto si la fuente en
// uso es variable (p. ej. Bricolage Grotesque 96pt, ver examples-variable-fonts.typ);
// en cualquier otra fuente se ignora sin error.
#let badge(body, color: none, variations: (:), theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  box(
    fill: color.transparentize(70%),
    stroke: 1.5pt + color,
    radius: 100pt,
    inset: (x: 18pt, y: 8pt),
    text(fill: color, weight: 600, size: 22pt, variations: variations, body),
  )
}

// Título grande
// `variations:` permite marcar ejes de una fuente variable (theme.fonts.display) —
// p. ej. Fraunces: (wght: 900, opsz: 144, WONK: 1). Si se pasa `wght`, gana
// sobre el `weight: 800` fijo de abajo (Typst prioriza el eje explícito).
#let headline(body, color: none, size: 72pt, variations: (:), theme: theme.base) = {
  let color = if color == none { theme.colors.dark } else { color }
  text(
    font: theme.fonts.display,
    fill: color,
    size: size,
    weight: 800,
    variations: variations,
    body,
  )
}

// Texto de apoyo
#let subhead(body, color: gray.darken(30%), size: 34pt, variations: (:), theme: theme.base) = text(
  font: theme.fonts.body,
  fill: color,
  size: size,
  variations: variations,
  body,
)

// Pie con marca
#let footer(handle, logo: none, color: white, theme: theme.base) = align(
  bottom + start,
  grid(
    columns: (auto, 1fr),
    align: (left, right),
    if logo != none { image(logo, height: 40pt) } else { h(0pt) },
    text(font: theme.fonts.body, fill: color, size: 26pt, weight: 600, handle),
  ),
)

// ============ 4. PLANTILLAS LISTAS PARA USAR ============

// Post de cita
#let quote-post(
  quote,
  author,
  handle,
  size: sizes.instagram,
  c1: none,
  c2: none,
  theme: theme.base,
) = {
  let c1 = if c1 == none { theme.colors.primary } else { c1 }
  let c2 = if c2 == none { theme.colors.secondary } else { c2 }
  canvas(size, theme: theme, [
    #gradient-bg(from: c1, to: c2, theme: theme)
    #blob(-200pt, -150pt, 400, white)
    #blob(size.at(0) * 1pt - 250pt, size.at(1) * 1pt - 300pt, 450, black, opacity: 15%)
    #place(center)[
      #block(width: 85%)[
        #align(center)[
          #text(size: 90pt, fill: white.transparentize(50%), "\u{201C}")
          #text(font: theme.fonts.display, size: 58pt, weight: 700, fill: white, quote)
          #v(30pt)
          #text(font: theme.fonts.body, size: 30pt, fill: white.transparentize(25%), "— " + author)
          #footer(handle, theme: theme)
        ]
      ]
    ]
  ])
}

// Post de anuncio
#let announce-post(
  tagline,
  title,
  subtitle,
  handle,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  canvas(size, theme: theme, [
    #bg(theme.colors.white)
    #blob(-180pt, -180pt, 380, color, opacity: 12%)
    #blob(700pt, 800pt, 500, color, opacity: 8%)
    #set align(left)
    #pad(page-pad)[
      #badge(tagline, color: color, theme: theme)
      #v(40pt)
      #headline(title, color: theme.colors.dark, size: 84pt, theme: theme)
      #v(20pt)
      #subhead(subtitle, size: 38pt, theme: theme)
      #v(60pt)
      #rect(fill: color, radius: radius, inset: (x: 32pt, y: 16pt))[
        #text(fill: white, size: 28pt, weight: 700, "Saber más →")
      ]
      #footer(handle, color: gray.darken(40%), theme: theme)
    ]
  ])
}

// Tarjeta de tip / consejo numerado
#let tip-card(
  n,
  title,
  description,
  handle,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.accent } else { color }
  canvas(size, theme: theme, [
    #bg(theme.colors.dark)
    #place(right, dx: 60pt, dy: -60pt)[
      #text(size: 320pt, fill: color.transparentize(85%), weight: 900, str(n))
    ]
    #pad(page-pad)[
      #badge("TIP " + str(n), color: color, theme: theme)
      #v(36pt)
      #headline(title, color: white, size: 76pt, theme: theme)
      #v(24pt)
      #subhead(description, color: rgb("#D1D5DB"), size: 36pt, theme: theme)
      #footer(handle, theme: theme)
    ]
  ])
}

// ============ 5. COMPONENTES EXTRA (finetuning) ============

// Avatar circular con iniciales
#let avatar(initials, bg-color: none, fg: white, size: 90pt, theme: theme.base) = {
  let bg-color = if bg-color == none { theme.colors.primary } else { bg-color }
  box(
    box(
      width: size, height: size, radius: 100%,
      fill: bg-color,
      align(center + horizon)[
        #text(font: theme.fonts.display, size: size * 0.38, weight: 800, fill: fg, initials)
      ],
    ),
    outset: (right: 24pt),
  )
}

#let avatar-row(name, role, initials, bg-color: none, theme: theme.base) = {
  let bg-color = if bg-color == none { theme.colors.primary } else { bg-color }
  grid(
    columns: (auto, 1fr),
    gutter: 0pt,
    align: (left + horizon, left + horizon),
    avatar(initials, bg-color: bg-color, theme: theme),
    [
      #text(font: theme.fonts.body, size: 30pt, weight: 700, name) #linebreak()
      #text(font: theme.fonts.body, size: 24pt, fill: gray, role)
    ],
  )
}

// Número estadístico gigante
#let stat(value, label, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  align(center)[
    #text(font: theme.fonts.display, size: 140pt, weight: 900, fill: color, value)
    #linebreak()
    #text(font: theme.fonts.body, size: 34pt, fill: gray.darken(20%), label)
  ]
}

// Barra de progreso decorativa
#let progress(pct, color: none, height: 14pt, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  box(width: 100%, height: height, radius: height,
    fill: color.transparentize(80%), clip: true)[
      #box(width: pct * 100%, height: 100%, radius: height, fill: color)
    ]
}

// Línea divisoria con punto central
#let divider(color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  grid(
    columns: (1fr, auto, 1fr),
    align: (horizon, horizon, horizon),
    line(length: 100%, stroke: 2pt + color.transparentize(50%)),
    box(inset: (x: 14pt), circle(radius: 5pt, fill: color)),
    line(length: 100%, stroke: 2pt + color.transparentize(50%)),
  )
}

// ============ 6. PLANTILLAS EXTRA ============

// Portada de carrusel ("desliza →")
#let carousel-cover(
  kicker,
  title,
  handle,
  n-pages: 6,
  size: sizes.instagram,
  c1: none,
  c2: none,
  theme: theme.base,
) = {
  let c1 = if c1 == none { theme.colors.dark } else { c1 }
  let c2 = if c2 == none { theme.colors.primary } else { c2 }
  canvas(size, theme: theme, [
    #gradient-bg(from: c1, to: c2, theme: theme)
    #blob(600pt, -200pt, 420, white, opacity: 10%)
    #pad(page-pad)[
      #align(right)[
        #badge("CARRUSEL · " + str(n-pages) + " PÁGS", color: theme.colors.accent, theme: theme)
      ]
      #v(50pt)
      #subhead(kicker, color: rgb("#A5B4FC"), size: 36pt, theme: theme)
      #v(16pt)
      #headline(title, color: white, size: 92pt, theme: theme)
      #footer(handle, theme: theme)
      #place(bottom + right, dy: -60pt)[
        #text(size: 44pt, fill: white, weight: 700, "Desliza →")
      ]
    ]
  ])
}

// Slide interior de carrusel (numerado, sobrio)
#let carousel-slide(
  n,
  total,
  title,
  body-text,
  handle,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  canvas(size, theme: theme, [
    #bg(theme.colors.white)
    #place(top, dy: 40pt)[#progress(n / total, color: color, theme: theme)]
    #pad(page-pad)[
      #text(font: theme.fonts.display, size: 30pt, weight: 700, fill: color, str(n) + " / " + str(total))
      #v(28pt)
      #headline(title, size: 72pt, theme: theme)
      #v(24pt)
      #subhead(body-text, size: 38pt, color: rgb("#374151"), theme: theme)
      #footer(handle, color: gray.darken(40%), theme: theme)
    ]
  ])
}

// Tarjeta de estadística / dato
#let stat-card(
  value,
  label,
  caption,
  handle,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  canvas(size, theme: theme, [
    #bg(theme.colors.light)
    #blob(-160pt, (size.at(1) - 330) * 1pt, 400, color, opacity: 10%)
    #align(center + horizon)[
      #block(width: 88%)[
        #stat(value, label, color: color, theme: theme)
        #v(30pt)
        #divider(color: color, theme: theme)
        #v(30pt)
        #subhead(caption, size: 36pt, theme: theme)
        #v(40pt)
        #footer(handle, color: gray.darken(40%), theme: theme)
      ]
    ]
  ])
}

// Comparación antes / después
// helper: círculo central VS
#let vs-badge(size, theme: theme.base) = place(
  dx: (size.at(0) * 1pt) / 2 - 46pt,
  dy: (size.at(1) * 1pt) / 2 - 46pt,
)[
  #box(
    width: 92pt, height: 92pt, radius: 100%,
    fill: white, stroke: 4pt + theme.colors.dark,
    align(center + horizon)[
      #text(font: theme.fonts.display, size: 36pt, weight: 900, fill: theme.colors.dark, "VS")
    ],
  )
]

// Post de evento con fecha
#let event-post(
  day,
  month,
  title,
  details,
  handle,
  size: sizes.story,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.secondary } else { color }
  canvas(size, theme: theme, [
    #bg(theme.colors.dark)
    #blob(-250pt, -250pt, 500, color, opacity: 25%)
    #blob(650pt, 1300pt, 600, theme.colors.primary, opacity: 20%)
    #pad(page-pad)[
      #box(
        fill: color, radius: radius, width: 220pt,
        inset: (y: 24pt),
        align(center)[
          #text(font: theme.fonts.display, size: 84pt, weight: 900, fill: white, day)
          #linebreak()
          #text(font: theme.fonts.body, size: 32pt, weight: 700, fill: white.transparentize(15%), month)
        ],
      )
      #v(48pt)
      #headline(title, color: white, size: 80pt, theme: theme)
      #v(24pt)
      #subhead(details, color: rgb("#9CA3AF"), size: 38pt, theme: theme)
      #v(60pt)
      #rect(fill: white, radius: radius, inset: (x: 36pt, y: 18pt))[
        #text(fill: theme.colors.dark, size: 30pt, weight: 800, "Reserva tu lugar →")
      ]
      #footer(handle, theme: theme)
    ]
  ])
}

// Testimonio con avatar
#let testimonial-post(
  quote,
  name,
  role,
  initials,
  handle,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  canvas(size, theme: theme, [
    #bg(theme.colors.light)
    #place(top + center, dy: -120pt)[
      #circle(radius: 260pt, fill: color.transparentize(90%))
    ]
    #pad(page-pad)[
      #text(size: 100pt, fill: color, "\u{201C}")
      #text(font: theme.fonts.display, size: 52pt, weight: 600, fill: theme.colors.dark, quote)
      #v(40pt)
      #divider(color: color, theme: theme)
      #v(40pt)
      #avatar-row(name, role, initials, bg-color: color, theme: theme)
      #v(50pt)
      #footer(handle, color: gray.darken(40%), theme: theme)
    ]
  ])
}

// Encuesta / pregunta para stories
#let poll-story(
  question,
  option-a,
  option-b,
  handle,
  size: sizes.story,
  c1: none,
  c2: none,
  theme: theme.base,
) = {
  let c1 = if c1 == none { theme.colors.primary } else { c1 }
  let c2 = if c2 == none { theme.colors.secondary } else { c2 }
  canvas(size, theme: theme, [
    #gradient-bg(from: c1, to: c2, theme: theme)
    #pad(page-pad)[
      #badge("ENCUESTA", color: theme.colors.accent, theme: theme)
      #v(40pt)
      #headline(question, color: white, size: 78pt, theme: theme)
      #v(70pt)
      #(for opt in (option-a, option-b) [
        #block(width: 100%)[
          #rect(
            width: 100%, radius: radius,
            fill: white, inset: (y: 34pt, x: 30pt),
            stroke: 3pt + white,
          )[
            #align(center)[#text(font: theme.fonts.body, size: 42pt, weight: 700, fill: theme.colors.dark, opt)]
          ]
        ]
        #v(36pt)
      ])
      #footer(handle, theme: theme)
    ]
  ])
}

#let versus-post(
  left-title,
  left-items,
  right-title,
  right-items,
  handle,
  size: sizes.instagram,
  bad: rgb("#EF4444"),
  good: rgb("#22C55E"),
  theme: theme.base,
) = {
  let item-list(items, marker-color, filled) = pad(page-pad)[
    #for it in items [
      #grid(columns: (auto, 1fr), gutter: 18pt, align: (top + left, top + left))[
        #box(circle(radius: 10pt, fill: if filled { marker-color } else { none }, stroke: 3pt + marker-color), outset: (top: 12pt))
      ][
        #text(font: theme.fonts.body, size: 32pt, fill: theme.colors.dark, it)
      ]
      #v(24pt)
    ]
  ]
  canvas(size, theme: theme, [
    #bg(theme.colors.white)
    #set text(font: theme.fonts.body)
    #vs-badge(size, theme: theme)
    #place[
      #grid(
        columns: (1fr, 1fr),
        rows: (100%),
        column-gutter: 4pt,
        [
          #block(height: 100%, fill: bad.transparentize(92%), inset: page-pad)[
            #badge("ANTES", color: bad, theme: theme)
            #v(24pt)
            #text(font: theme.fonts.display, size: 44pt, weight: 800, fill: theme.colors.dark, left-title)
            #v(32pt)
            #item-list(left-items, bad, false)
          ]
        ],
        [
          #block(height: 100%, fill: good.transparentize(92%), inset: page-pad)[
            #badge("DESPUÉS", color: good, theme: theme)
            #v(24pt)
            #text(font: theme.fonts.display, size: 44pt, weight: 800, fill: theme.colors.dark, right-title)
            #v(32pt)
            #item-list(right-items, good, true)
            #v(50pt)
            #align(center)[#text(size: 26pt, fill: gray, handle)]
          ]
        ],
      )
    ]
  ])
}

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

// Cita editorial — doble borde, comilla grande, itálica
#let blockquote-editorial(body, autor: none, fuente: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(width: 100%, above: 24pt, below: 24pt)[
    #block(stroke: 1pt + color.transparentize(70%), inset: 5pt, radius: radius)[
      #block(fill: theme.colors.white, stroke: 1.5pt + color.transparentize(70%), inset: (x: 40pt, y: 40pt), radius: radius, width: 100%)[
        #text(size: 60pt, fill: color.transparentize(75%), font: theme.fonts.display, weight: 900)[\u{201C}]
        #v(6pt)
        #text(font: theme.fonts.body, style: "italic", size: 32pt, fill: theme.colors.dark, body)
        #if autor != none or fuente != none [
          #v(20pt)
          #line(length: 100%, stroke: 0.75pt + color.transparentize(70%))
          #v(14pt)
          #text(font: theme.fonts.body, size: 18pt, weight: 700, tracking: 0.12em, fill: gray.darken(20%))[
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
#let blockquote-bar(body, autor: none, fuente: none, color: none, variante: "default", theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  let tamano = if variante == "grande" { 44pt } else { 32pt }
  let acentuada = variante == "acento"
  block(width: 100%, above: 24pt, below: 24pt)[
    #block(
      fill: if acentuada { color.transparentize(93%) } else { none },
      stroke: (left: 5pt + color),
      inset: (left: 32pt, y: if acentuada { 24pt } else { 0pt }),
      width: 100%,
    )[
      #text(font: theme.fonts.body, style: "italic", size: tamano, fill: theme.colors.dark, body)
      #if autor != none or fuente != none [
        #v(16pt)
        #if autor != none [#text(font: theme.fonts.body, size: 22pt, weight: 700, fill: theme.colors.dark)[— #autor]]
        #if fuente != none [#text(font: theme.fonts.body, size: 20pt, style: "italic", fill: gray.darken(10%))[ · #fuente]]
      ]
    ]
  ]
}

// Tarjeta con barra superior de acento y pie de atribución
#let blockquote-card(body, autor: none, fuente: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(width: 100%, above: 24pt, below: 24pt)[
    #block(fill: theme.colors.white, radius: radius, width: 100%, clip: true, stroke: 1pt + gray.lighten(70%))[
      #block(fill: color, height: 6pt, width: 100%)[]
      #block(inset: 36pt)[
        #text(font: theme.fonts.body, style: "italic", size: 32pt, fill: theme.colors.dark, body)
      ]
      #if autor != none or fuente != none [
        #block(fill: theme.colors.light, stroke: (top: 0.75pt + gray.lighten(70%)), inset: (x: 36pt, y: 20pt), width: 100%)[
          #if autor != none [#text(font: theme.fonts.body, size: 22pt, weight: 700, fill: theme.colors.dark)[— #autor]]
          #if fuente != none [#text(font: theme.fonts.body, size: 20pt, style: "italic", fill: gray.darken(10%))[ #fuente]]
        ]
      ]
    ]
  ]
}

// Cita dramática, centrada, a todo el ancho — para abrir un slide o sección
#let blockquote-hero(body, autor: none, fuente: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  block(width: 100%, above: 36pt, below: 36pt)[
    #align(center)[
      #text(size: 86pt, fill: color.transparentize(70%), font: theme.fonts.display, weight: 900)[\u{201C}]
      #v(-16pt)
      #text(font: theme.fonts.display, weight: 700, size: 48pt, fill: theme.colors.dark, body)
      #if autor != none or fuente != none [
        #v(24pt)
        #if autor != none [#text(font: theme.fonts.body, size: 24pt, weight: 700, tracking: 0.1em, fill: gray.darken(20%))[— #upper(autor)]]
        #if fuente != none [#linebreak() #text(font: theme.fonts.body, style: "italic", size: 22pt, fill: gray.darken(10%), fuente)]
      ]
    ]
  ]
}

// Tarjeta independiente con avatar — reutiliza avatar-row() de la sección 5.
// `iniciales` es explícito (no se deriva de `autor`): así evitamos el bug
// que encontramos en cristianamente.typ (crash si autor no era texto plano).
#let blockquote-avatar(body, autor: none, fuente: none, iniciales: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(
    fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: radius, inset: 32pt, width: 100%,
  )[
    #text(font: theme.fonts.body, style: "italic", size: 28pt, fill: theme.colors.dark, body)
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
        text(font: theme.fonts.body, size: 24pt, weight: 700, fill: theme.colors.dark, autor)
      }
    ]
  ]
}

// Cita manuscrita, centrada — usa Caveat (bundled en Fonts/, a diferencia de
// Kalam en cristianamente.typ). Compilar con `--font-path Fonts`.
#let blockquote-hand(body, autor: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  block(width: 100%, above: 28pt, below: 28pt)[
    #align(center)[
      #text(font: "Caveat", size: 40pt, fill: theme.colors.dark, body)
      #if autor != none [
        #v(10pt)
        #text(font: "Caveat", size: 28pt, fill: color)[— #autor]
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
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  let es-rtl = idioma == "hebreo"
  block(width: 100%, above: 24pt, below: 24pt, fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: radius, inset: 28pt)[
    #if referencia != none [
      #text(font: theme.fonts.body, size: 18pt, weight: 700, fill: color, referencia)
      #v(14pt)
    ]
    #let celda-original = [
      #set text(dir: if es-rtl { rtl } else { ltr })
      #set align(if es-rtl { right } else { left })
      #if idioma == "hebreo" { he(text(size: 24pt, original)) } else { gr(text(size: 24pt, original), autentico: autentico) }
    ]
    #let celda-traduccion = [
      #set text(font: theme.fonts.body, size: 20pt, style: "italic", fill: theme.colors.dark)
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
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(width: 100%, above: 24pt, below: 24pt)[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 18pt,
      align: (bottom, top),
      if autor != none or fuente != none {
        align(bottom)[
          #rotate(270deg, reflow: true)[
            #text(font: theme.fonts.body, weight: 700, size: 16pt, fill: color)[
              #if autor != none [#autor]
              #if autor != none and fuente != none [ — ]
              #if fuente != none [#text(style: "italic", fill: theme.colors.dark)[#fuente]]
            ]
          ]
        ]
      } else { [] },
      [
        #set par(justify: true)
        #set text(font: theme.fonts.body, size: 15pt, fill: theme.colors.dark)
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
#let blockquote-pull(body, autor: none, fuente: none, marca: "“", color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(width: 100%, above: 28pt, below: 28pt)[
    #if marca != none {
      place(dx: -10pt, dy: -30pt)[
        #text(font: theme.fonts.display, size: 180pt, fill: color.transparentize(88%), weight: 900, marca)
      ]
    }
    #pad(x: 28pt, y: 12pt)[
      #text(font: theme.fonts.display, weight: 800, size: 46pt, fill: theme.colors.dark, body)
      #if autor != none or fuente != none [
        #v(18pt)
        #box(fill: color, height: 3pt, width: 48pt)
        #v(10pt)
        #text(font: theme.fonts.body, size: 20pt, weight: 700, fill: theme.colors.dark)[
          #if autor != none [#autor]
          #if fuente != none [#text(style: "italic", fill: gray.darken(10%))[ — #fuente]]
        ]
      ]
    ]
  ]
}

// Definición / glosario — porte de `definicion` de cristianamente.typ
// `termino` + `/pronunciación/` + badge `origen` + cuerpo + pills `relacionados`.
#let blockquote-definition(termino, body, pronunciacion: none, origen: none, relacionados: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(width: 100%, above: 24pt, below: 24pt, fill: theme.colors.white, stroke: 1pt + gray.lighten(70%), radius: radius, inset: 32pt)[
    #text(font: theme.fonts.display, weight: 900, size: 40pt, fill: theme.colors.dark, termino)
    #if pronunciacion != none [#h(10pt) #text(font: theme.fonts.body, size: 18pt, fill: gray, style: "italic")[/#pronunciacion/]]
    #if origen != none [#h(8pt) #box(fill: color.transparentize(88%), inset: (x: 8pt, y: 4pt), radius: 100pt)[#text(size: 14pt, fill: color, weight: 700, origen)]]
    #v(14pt)
    #set text(font: theme.fonts.body, size: 26pt, fill: theme.colors.dark)
    #set par(leading: 0.85em)
    #body
    #if relacionados != none and relacionados.len() > 0 [
      #v(14pt) #line(length: 100%, stroke: 0.75pt + gray.lighten(70%)) #v(10pt)
      #text(size: 16pt, fill: gray, weight: 600)[Ver también: ]
      #for (i, r) in relacionados.enumerate() [
        #box(fill: theme.colors.light, inset: (x: 8pt, y: 4pt), radius: 100pt)[#text(size: 16pt, fill: gray.darken(20%), r)] #h(6pt)
      ]
    ]
  ]
}

// Callout — tip/info/warning/marginal con icono + barra lateral.
// Reemplazo con *intención* para `blockquote-bar` acentuado genérico.
#let blockquote-callout(body, titulo: none, icono: "✦", variante: "tip", color: none, theme: theme.base) = {
  let defaults = (tip: palette.accent, info: palette.primary, warn: rgb("#EAB308"), hand: palette.secondary)
  let color = if color == none { defaults.at(variante, default: palette.accent) } else { color }
  block(width: 100%, above: 20pt, below: 20pt, fill: color.transparentize(92%), stroke: (left: 5pt + color), inset: (x: 28pt, y: 22pt), radius: 12pt)[
    #grid(columns: (auto, 1fr), gutter: 14pt, align: (top, top),
      text(size: 28pt, icono),
      [
        #if titulo != none [#text(font: theme.fonts.body, size: 20pt, weight: 800, fill: color, upper(titulo)) #v(6pt)]
        #if variante == "hand" {
          text(font: "Caveat", size: 28pt, fill: theme.colors.dark, body)
        } else {
          text(font: theme.fonts.body, size: 26pt, fill: theme.colors.dark, body)
        }
      ]
    )
  ]
}

// Poesía / verso — respeta saltos, sin justificar, sangría colgante.
#let blockquote-poetry(body, autor: none, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  block(width: 100%, above: 24pt, below: 24pt, fill: theme.colors.white, stroke: (left: 3pt + color.transparentize(50%)), inset: (x: 28pt, y: 20pt), radius: 8pt)[
    #set text(font: theme.fonts.body, size: 26pt, fill: theme.colors.dark)
    #set par(leading: 0.95em, justify: false, first-line-indent: 0pt, hanging-indent: 1em)
    #body
    #if autor != none [#v(10pt) #align(right)[#text(font: theme.fonts.body, size: 18pt, fill: gray, style: "italic")[— #autor]]]
  ]
}

// Timeline — fecha a la izquierda + regla vertical + cuerpo.
#let blockquote-timeline(fecha, body, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  block(width: 100%, above: 18pt, below: 18pt)[
    #grid(columns: (auto, auto, 1fr), gutter: 14pt, align: (top, top, top),
      text(font: theme.fonts.body, size: 18pt, weight: 800, fill: color, fecha),
      box(width: 3pt, height: 44pt, fill: color.transparentize(65%), radius: 2pt),
      [#set text(font: theme.fonts.body, size: 22pt, fill: theme.colors.dark); #set par(leading: 0.85em); #body],
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

#let bq-attribution(autor: none, fuente: none, modo: "pro", color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.dark } else { color }
  if modo == "mono" {
    // Brutalista: DM Mono + upper + caja de color
    if autor != none or fuente != none {
      let label = if autor != none and fuente != none { upper(autor) + " · " + upper(fuente) } else if autor != none { upper(autor) } else { upper(fuente) }
      box(fill: theme.colors.primary, inset: (x: 6pt, y: 3pt))[#text(font: "DM Mono", size: 9pt, weight: 700, fill: white, label)]
    }
  } else if modo == "caps" {
    text(font: theme.fonts.body, size: 9pt, weight: 700, tracking: 0.12em, fill: gray.darken(20%))[
      #if autor != none { upper(autor) }
      #if autor != none and fuente != none { "  ·  " }
      #if fuente != none { upper(fuente) }
    ]
  } else {
    // pro
    [#if autor != none [#text(font: theme.fonts.body, size: 11pt, weight: 700, fill: color)[— #autor]] #if fuente != none [#text(font: theme.fonts.body, size: 10pt, style: "italic", fill: gray.darken(10%))[ · #fuente]]]
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
