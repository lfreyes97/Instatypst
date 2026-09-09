// ─────────────────────────────────────────────────────────────
//  carrusel.typ — carrusel de Instagram con carrocería compartida.
//
//  Puerto de un patrón visto en ig-carrusel.typ (cristianamente-typst,
//  proyecto externo, NO integrado — solo la idea de diseño): topbar
//  (etiqueta + contador "01/08") + pie (marca + "desliza →" o puntos de
//  posición) + numeral gigante de fondo, compartidos por distintos
//  "sabores" de diapositiva.
//
//  NO es automático — nada acá reparte contenido en N slides por su
//  cuenta. Vos seguís llamando cada #carrusel-slide(...)/
//  #carrusel-slide-definicion(...) a mano, en el orden que quieras, y
//  decidís cuántas hay. Lo que el motor evita es repetir la misma
//  carrocería (topbar/pie/centrado) en cada plantilla nueva — mismo
//  espíritu que bq-frame/bq-mark/bq-rule/bq-attribution -> blockquote-*
//  en blockquotes.typ.
//
//  Cada #carrusel-slide(...) ya arma su propio canvas() (= su propia
//  página) — llamalas seguidas, SIN #pagebreak() entre medio: canvas()
//  ya arranca página nueva cada vez (verificado: dos canvas() seguidos
//  sin pagebreak producen 2 páginas, no una).
// ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "social.typ": canvas, sizes, page-pad

#let _pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }

// Puntos de posición — el activo resaltado, el resto en gris tenue.
#let dots(activo, total: 8, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  stack(dir: ltr, spacing: 10pt,
    ..range(1, total + 1).map(i => circle(
      radius: 4.5pt,
      fill: if i == activo { color } else { gray.lighten(60%) },
    ))
  )
}

// Barra superior — etiqueta (kicker) + contador "01/08".
#let topbar(label, n, total: 8, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  grid(
    columns: (1fr, auto),
    text(font: theme.fonts.body, weight: 700, size: 15pt, tracking: 0.28em, fill: color, upper(label)),
    align(right)[
      #text(font: theme.fonts.body, weight: 600, size: 14pt, tracking: 0.08em, fill: theme.colors.dark.transparentize(45%))[#_pad2(n) / #_pad2(total)]
    ],
  )
}

// Pie — marca + "desliza →" (si swipe) o los puntos de posición.
#let pie-carrusel(marca, n, total: 8, swipe: true, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  grid(
    columns: (auto, 1fr),
    text(font: theme.fonts.display, weight: 800, size: 15pt, fill: color, marca),
    align(right)[
      #if swipe [
        #text(font: theme.fonts.body, weight: 600, size: 12pt, tracking: 0.08em, fill: theme.colors.dark.transparentize(45%))[DESLIZA #sym.arrow.r]
      ] else [
        #dots(n, total: total, theme: theme)
      ]
    ],
  )
}

// Numeral decorativo gigante de fondo, esquina superior derecha.
#let numeral-fondo(txt, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  place(top + right, dx: 8pt, dy: -56pt)[
    #text(font: theme.fonts.display, weight: 900, size: 226pt, fill: color.transparentize(93%))[#txt]
  ]
}

// Referencia breve (cita bíblica, fuente, nota) — barra de acento +
// mayúsculas con tracking. Mismo tratamiento visual que la línea de
// fuente en blockquote-editorial, a escala de carrusel.
#let referencia-carrusel(texto, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.accent } else { color }
  box(stroke: (left: 3.5pt + color.transparentize(55%)), inset: (left: 18pt))[
    #text(font: theme.fonts.body, weight: 800, size: 13pt, tracking: 0.16em, fill: color, upper(texto))
  ]
}

// ── Motor: carrusel-slide — título + cuerpo, con referencia opcional. ──
// `numeral:` (opcional) pone un número gigante de fondo, para diapositivas
// tipo "razón 1 de 5". `body-italic:` atenúa el cuerpo (para el kicker de
// portada o el resumen de cierre, ver ejemplo).
#let carrusel-slide(
  marca,
  label: none,
  n: 1,
  total: 8,
  numeral: none,
  title: none,
  title-size: 52pt,
  body: none,
  body-size: 29pt,
  body-italic: false,
  referencia: none,
  swipe: true,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  canvas(size, theme: theme, [
    #if numeral != none { numeral-fondo(numeral, theme: theme) }
    #pad(page-pad)[
      #topbar(label, n, total: total, theme: theme)
      #v(1fr)
      #block(width: 100%)[
        #text(font: theme.fonts.display, weight: 800, size: title-size, fill: color)[#title]
        #v(22pt)
        #text(
          font: theme.fonts.body,
          style: if body-italic { "italic" } else { "normal" },
          size: body-size,
          fill: if body-italic { theme.colors.dark.transparentize(30%) } else { theme.colors.dark },
        )[#body]
        #if referencia != none [
          #v(18pt)
          #referencia-carrusel(referencia, theme: theme)
        ]
      ]
      #v(1fr)
      #pie-carrusel(marca, n, total: total, swipe: swipe, theme: theme)
    ]
  ])
}

// ── Motor: carrusel-slide-definicion — término + pronunciación + origen. ──
// Mismo topbar/pie que carrusel-slide (misma carrocería); cuerpo distinto,
// pensado para una diapositiva tipo "¿qué es X?" antes de entrar al tema.
#let carrusel-slide-definicion(
  marca,
  label: none,
  n: 1,
  total: 8,
  termino: none,
  pronunciacion: none,
  origen: none,
  body: none,
  swipe: true,
  size: sizes.instagram,
  color: none,
  theme: theme.base,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  canvas(size, theme: theme, [
    #pad(page-pad)[
      #topbar(label, n, total: total, theme: theme)
      #v(1fr)
      #block(width: 100%)[
        #grid(
          columns: (auto, auto), column-gutter: 16pt, align: bottom,
          text(font: theme.fonts.display, weight: 900, size: 58pt, fill: color)[#termino],
          text(font: theme.fonts.body, size: 19pt, fill: theme.colors.dark.transparentize(30%))[/#pronunciacion/],
        )
        #if origen != none [
          #v(12pt)
          #box(fill: theme.colors.accent.transparentize(85%), inset: (x: 10pt, y: 5pt), radius: 14pt)[
            #text(font: theme.fonts.body, weight: 700, size: 13pt, fill: theme.colors.accent)[#origen]
          ]
        ]
        #v(26pt)
        #text(font: theme.fonts.body, size: 29pt, fill: theme.colors.dark)[#body]
      ]
      #v(1fr)
      #pie-carrusel(marca, n, total: total, swipe: swipe, theme: theme)
    ]
  ])
}
