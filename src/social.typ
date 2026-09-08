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
    // `center` a secas es una alineación de un solo eje (horizontal) — sin
    // sumarle `horizon`, place() ancla verticalmente arriba por defecto y
    // deja todo el tercio inferior del lienzo vacío. Con textos cortos como
    // los de esta plantilla, el efecto es muy notorio.
    #place(center + horizon)[
      #block(width: 85%)[
        #align(center)[
          #text(size: 90pt, fill: white.transparentize(50%), "\u{201C}")
          #text(font: theme.fonts.display, size: 58pt, weight: 700, fill: white, quote)
          #v(30pt)
          #text(font: theme.fonts.body, size: 30pt, fill: white.transparentize(25%), "— " + author)
        ]
      ]
    ]
    // El pie va en su propio place() anclado a la esquina inferior — igual
    // que nota-izq/nota-der en quote-social — en vez de vivir dentro del
    // bloque centrado: allí, align(bottom+start) de footer() solo alineaba
    // contra la altura del propio bloque (que se ajusta a su contenido), no
    // contra el lienzo, así que terminaba pegado justo debajo de la cita en
    // vez de en el borde inferior real.
    #place(bottom + center, dy: -page-pad)[
      #block(width: 85%)[
        #footer(handle, theme: theme)
      ]
    ]
  ])
}

// Lienzo genérico para blockquotes.typ — pensado para reemplazar a
// quote-post cuando el contenido de la cita lo pide: en vez de un layout
// fijo (comilla + display + autor, todo centrado), recibe cualquier bloque
// ya armado con blockquote-editorial/-hero/-pull/-card/-bar/-avatar/-hand/
// -poetry/-timeline/-lateral/-paralelo/-definition/-callout y solo resuelve
// tres cosas: fondo, márgenes, y centrado vertical real.
//
// Centrado: ni pad()+align(horizon) (pad() encoge el contenedor a su
// contenido — no hay alto de sobra contra el cual centrar, ver nota en
// quote-social) ni place(center) a secas (alinea un solo eje — el bug que
// tenía quote-post). Acá el contenido vive directo en el flujo del canvas
// (que sí tiene alto FIJO vía page(height:..)) con v(1fr) arriba y abajo:
// eso reparte el sobrante en partes iguales de verdad. El pie va DESPUÉS
// del segundo v(1fr), como parte del mismo flujo — no en un place() aparte
// — así el fr de arriba se calcula ya descontando su alto y nunca hay
// riesgo de que una cita larga lo atropelle.
//
// `bg-color:` — usa SIEMPRE theme.colors.white para blockquotes sin fondo
// propio (hero/pull/lateral/timeline/paralelo: pintan texto oscuro sobre
// nada) en vez de theme.colors.light: en paletas monocromáticas como
// "granates", `light` sigue siendo un rojo saturado (ver nota de
// fondo-editorial en articulo.typ), no un neutro — blanco puro es lo único
// que siempre contrasta, para cualquier paleta.
#let cita-canvas(
  contenido,
  handle,
  size: sizes.instagram,
  bg-color: none,
  gradient: none, // (from, to) — si se da, pisa bg-color con gradient-bg
  blobs: true,
  blob-color: white,
  footer-color: none,
  theme: theme.base,
) = {
  let bg-color = if bg-color == none { theme.colors.white } else { bg-color }
  let footer-color = if footer-color == none { gray.darken(40%) } else { footer-color }
  canvas(size, theme: theme, [
    #if gradient != none {
      gradient-bg(from: gradient.at(0), to: gradient.at(1), theme: theme)
    } else {
      bg(bg-color)
    }
    #if blobs [
      #blob(-200pt, -160pt, 380, blob-color, opacity: 8%)
      #blob(size.at(0) * 1pt - 220pt, size.at(1) * 1pt - 260pt, 420, blob-color, opacity: 10%)
    ]
    #v(1fr)
    #pad(x: page-pad)[#contenido]
    #v(1fr)
    #pad(x: page-pad, bottom: page-pad * 0.65)[#footer(handle, color: footer-color, theme: theme)]
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

// Cita social con atribución (foto/iniciales + nombre) dentro de la misma
// tarjeta blanca, y notas laterales decorativas opcionales — inspirado en
// tarjetas tipo LinkedIn. Para resaltar palabras dentro de `cita` usa el
// #highlight() nativo de Typst, no una API propia:
//   #quote-social([...quedar sometido al #highlight[dominio] y al #highlight[capricho].], "Nombre", iniciales: "LR")
// `iniciales` es explícito (igual que en blockquote-avatar) — no se deriva
// de `nombre`, para evitar el bug ya conocido si `nombre` no es texto plano.
// `atribucion: "abajo" | "arriba"` — dónde va foto+nombre dentro de la
// tarjeta, respecto a la cita.
// `comilla: true` muestra la comilla decorativa sobre la cita; `false` la
// quita (junto con el espaciado que la compensaba, no deja hueco).
// `nota-izq`/`nota-der` son dict (icono:, texto:) o `none` para omitir el
// lado. Las ilustraciones reales (figuras, puertas, cadenas...) no se
// recrean con primitivas de Typst — `icono:` acepta cualquier content,
// incluido `image(...)`, para sustituir el emoji por defecto con tu arte.
#let quote-social(
  cita,
  nombre,
  iniciales: "??",
  foto: none,
  atribucion: "abajo",
  comilla: false,
  nota-izq: none,
  nota-der: none,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  if atribucion not in ("abajo", "arriba") {
    panic("atribucion desconocida: " + atribucion + " — usa \"abajo\" o \"arriba\"")
  }
  let color = if color == none { theme.colors.dark } else { color }
  let avatar-tam = 76pt

  let bloque-cita = [
    #if comilla [
      #text(size: 50pt, fill: color.transparentize(60%), "\u{201C}")
      #v(-30pt)
    ]
    #text(font: theme.fonts.body, size: 34pt, fill: theme.colors.dark, cita)
  ]

  let bloque-atribucion = grid(
    columns: (avatar-tam, 1fr),
    gutter: 20pt,
    align: (left, left + horizon),
    if foto != none {
      box(clip: true, radius: 100%, width: avatar-tam, height: avatar-tam)[
        #image(foto, width: avatar-tam, height: avatar-tam, fit: "cover")
      ]
    } else {
      avatar(iniciales, size: avatar-tam, theme: theme)
    },
    text(font: theme.fonts.body, size: 26pt, weight: 700, fill: theme.colors.dark, nombre),
  )

  let divisor = [
    #v(32pt)
    #line(length: 100%, stroke: 0.75pt + gray.lighten(70%))
    #v(24pt)
  ]

  canvas(size, theme: theme, [
    #bg(color)
    #pad(page-pad)[
      // v(1fr) antes y después reparte el espacio sobrante arriba/abajo por
      // igual — a diferencia de align(horizon), que no centra nada aquí
      // porque pad() ya encoge el contenedor al tamaño de su contenido
      // (sin alto de sobra contra el cual centrar).
      #v(1fr)
      #block(
        fill: theme.colors.white, radius: radius, inset: 40pt, width: 100%,
      )[
        #if atribucion == "arriba" [
          #bloque-atribucion
          #divisor
          #bloque-cita
        ] else [
          #bloque-cita
          #divisor
          #bloque-atribucion
        ]
      ]
      #v(1fr)
      #if nota-izq != none {
        place(bottom + left, dx: -20pt, dy: 30pt)[
          #align(center)[
            #text(size: 40pt, nota-izq.icono) #linebreak()
            #text(font: theme.fonts.body, size: 20pt, fill: white, weight: 600, nota-izq.texto)
          ]
        ]
      }
      #if nota-der != none {
        place(bottom + right, dx: 20pt, dy: 30pt)[
          #align(center)[
            #text(size: 40pt, nota-der.icono) #linebreak()
            #text(font: theme.fonts.body, size: 20pt, fill: white, weight: 600, nota-der.texto)
          ]
        ]
      }
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

