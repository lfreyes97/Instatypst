#import "src/lib.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages)

// ─────────────────────────────────────────────────────────────
// demo.typ — Catálogo visual completo de instatypst
// Compilar: typst compile --root . --font-path Fonts demo.typ demo.pdf
// ─────────────────────────────────────────────────────────────

// ── Portada A4 ──
#set page(paper: "a4", margin: 2cm, fill: rgb("#fafafa"))
#set text(font: theme.base.fonts.body, size: 11pt, fill: theme.base.colors.dark, lang: "es")
#set par(justify: true, leading: 0.85em)
#set heading(numbering: none)

#align(center + horizon)[
  #text(font: theme.base.fonts.display, size: 36pt, weight: 900, fill: theme.base.colors.primary)[InstaTypst]
  #v(6pt)
  #text(size: 14pt, fill: theme.base.colors.dark.transparentize(30%))[Sistema de diseño en Typst]
  #v(18pt)
  #box(fill: theme.base.colors.primary, radius: 8pt, inset: (x: 18pt, y: 8pt))[
    #text(fill: white, size: 11pt, weight: 700)[DEMO · Catálogo visual completo]
  ]
  #v(24pt)
  #text(size: 9pt, fill: gray)[Compilado con `typst compile --root . --font-path Fonts demo.typ` · v0.1.0 · 2026]
  #v(6pt)
  #text(size: 8pt, fill: gray)[Cada sección muestra un tipo de elemento visual del paquete]
]

#pagebreak()

// ── Índice ──
#align(left)[
  #text(font: theme.base.fonts.display, size: 22pt, weight: 800, fill: theme.base.colors.primary)[Índice]
  #v(12pt)
  #text(size: 10pt, fill: gray)[Este demo cubre todos los tipos exportados por `src/lib.typ`]
  #v(10pt)
]
#grid(columns: 2, gutter: 14pt,
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 9pt, weight: 700)[1. Fundaciones]
    #v(4pt)
    #set text(size: 8pt, fill: luma(30%))
    - Paletas (15) · Tokens (96)
    - Parejas tipográficas (8) · Tokens (49+)
    - Theme API
  ],
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 9pt, weight: 700)[2. Componentes base]
    #v(4pt)
    #set text(size: 8pt, fill: luma(30%))
    - badge · headline · subhead · footer
    - avatar · avatar-row · stat · progress · divider
    - canvas · bg · gradient-bg · blob
  ],
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 9pt, weight: 700)[3. Plantillas sociales (10 + VS)]
    #v(4pt)
    #set text(size: 8pt, fill: luma(30%))
    - quote-post · announce-post · tip-card
    - carousel-cover/slide · stat-card
    - event-post · testimonial-post · poll-story · versus-post
  ],
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 9pt, weight: 700)[4. Blockquotes (9)]
    #v(4pt)
    #set text(size: 8pt, fill: luma(30%))
    - editorial · bar (×3) · card · hero
    - avatar · hand · paralelo · lateral · grid
  ],
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 9pt, weight: 700)[5. Editorial]
    #v(4pt)
    #set text(size: 8pt, fill: luma(30%))
    - capitular (Ysabeau/EB Garamond/IM Fell)
    - articulo · primer-parrafo · fondo-editorial
  ],
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 9pt, weight: 700)[6. Escritura & Idiomas]
    #v(4pt)
    #set text(size: 8pt, fill: luma(30%))
    - pasaje · vs · ch · scripture
    - lat · gr · he · translit · interlineal
  ],
)

#pagebreak()

// ═══════════════════════════════════════════════════════════
// 1. PALETAS
// ═══════════════════════════════════════════════════════════
#set page(width: 830pt, height: auto, margin: 18pt, fill: rgb("#fafafa"))
#text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[1 · Paletas]
#v(4pt)
#text(size: 9pt, fill: gray)[#(palettes.names)().len() paletas curadas · `palettes.catalog()` · #color-tokens.tokens.len() tokens individuales — página ancha 830pt como en `examples/palettes.typ` para que 3 columnas no desborden]
#v(10pt)
#(palettes.catalog)(columns: 3, gutter: 12pt)

#pagebreak()
#set page(paper: "a4", margin: 1.8cm, fill: rgb("#fafafa"))

// Detalle de 2 paletas con roles
#text(font: theme.base.fonts.display, size: 14pt, weight: 700, fill: theme.base.colors.dark)[1b · Roles automáticos]
#v(6pt)
#text(size: 8.5pt, fill: gray)[`palettes.as-theme("neon")` y `palettes.as-theme("terracota")` → `auto-roles()` mapea a primary/secondary/accent/dark/light/white]
#v(8pt)
#let role-table(t) = table(
  columns: (auto, auto, auto), stroke: none, inset: (y: 3pt, x: 4pt),
  ..("primary","secondary","accent","dark","light","white").map(k => (
    text(size: 7.5pt, weight: 600)[#k],
    box(circle(radius: 7pt, fill: t.colors.at(k), stroke: 0.5pt + luma(70%))),
    text(size: 6pt, fill: luma(40%), t.colors.at(k).to-hex()),
  )).flatten(),
)
#let neon = (palettes.as-theme)("neon")
#let terracota = (palettes.as-theme)("terracota")
#let marino = (palettes.as-theme)("marino")
#grid(columns: 3, gutter: 10pt,
  block(fill: neon.colors.light, radius: 8pt, inset: 10pt, stroke: 0.6pt + luma(85%))[
    #text(size: 8pt, weight: 700)[neon] #v(4pt) #role-table(neon)
  ],
  block(fill: terracota.colors.light, radius: 8pt, inset: 10pt, stroke: 0.6pt + luma(85%))[
    #text(size: 8pt, weight: 700)[terracota] #v(4pt) #role-table(terracota)
  ],
  block(fill: marino.colors.light, radius: 8pt, inset: 10pt, stroke: 0.6pt + luma(85%))[
    #text(size: 8pt, weight: 700)[marino] #v(4pt) #role-table(marino)
  ],
)
#v(8pt)
#text(size: 7.5pt, fill: gray)[Demo de `palettes.swatch`: ] #(palettes.swatch)("oceano", size: 18pt)

#pagebreak()

// ═══════════════════════════════════════════════════════════
// 2. PAREJAS TIPOGRÁFICAS
// ═══════════════════════════════════════════════════════════
#set page(width: 830pt, height: auto, margin: 18pt, fill: rgb("#fafafa"))
#text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[2 · Parejas tipográficas]
#v(4pt)
#text(size: 9pt, fill: gray)[#(pairings.names)().len() parejas curadas · `pairings.catalog()` · #font-tokens.tokens.len() fuentes verificadas — página ancha para 3 columnas]
#v(10pt)
#(pairings.catalog)(columns: 3, gutter: 12pt)

#pagebreak()
#set page(paper: "a4", margin: 1.8cm, fill: rgb("#fafafa"))
#text(font: theme.base.fonts.display, size: 14pt, weight: 700)[2b · Pareja en uso real]
#v(6pt)
#let expresivo = (pairings.as-theme)("editorial-expresivo")
#let vintage = (pairings.as-theme)("revival-vintage")
#grid(columns: 2, gutter: 12pt,
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 8pt, weight: 700)[editorial-expresivo] #v(6pt)
    #text(font: expresivo.fonts.display, size: 18pt, weight: 700)[Fraunces Display]
    #text(font: expresivo.fonts.body, size: 9pt, fill: luma(35%))[Bricolage Grotesque · Inter]
  ],
  block(fill: white, stroke: 0.7pt + luma(85%), radius: 8pt, inset: 12pt)[
    #text(size: 8pt, weight: 700)[revival-vintage] #v(6pt)
    #text(font: vintage.fonts.display, size: 18pt, weight: 700)[Cormorant Garamond]
    #text(font: vintage.fonts.body, size: 9pt, fill: luma(35%))[DM Sans]
  ],
)
#v(10pt)
#text(size: 8pt, fill: gray)[Arriba: roles tipográficos. Abajo, ejemplo de `announce-post` con `theme: expresivo` — ver sección 4 para el canvas a tamaño real (1080×1080).]

#pagebreak()

// ═══════════════════════════════════════════════════════════
// 3. COMPONENTES BASE (A4)
// ═══════════════════════════════════════════════════════════
#text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[3 · Componentes base]
#v(2pt)
#text(size: 8.5pt, fill: gray)[`badge` · `headline` · `subhead` · `footer` · `avatar` · `avatar-row` · `stat` · `progress` · `divider` · `canvas`/`bg`/`gradient-bg`/`blob`]
#v(10pt)

#text(size: 9pt, weight: 700)[badge — nativo 22pt dentro de canvas 1080pt; aquí escalado a ~55% para A4]
#scale(x: 55%, y: 55%, reflow: true)[
  #badge("NUEVO", color: palette.primary) #h(8pt) #badge("TIP 3", color: palette.accent) #h(8pt) #badge("CARRUSEL · 6 PÁGS", color: rgb("#22C55E"))
]

```typ
#badge("NUEVO", color: palette.primary)
#badge("TIP 3", color: palette.accent)
```
#v(8pt)

#text(size: 9pt, weight: 700)[headline / subhead — nativo 72pt/34pt en 1080pt; aquí 38pt/18pt (~53%) para no desbordar A4]
#scale(x: 92%, y: 92%, reflow: true)[
  #headline([Titular 72pt → 38pt en A4], size: 38pt)
]
#v(3pt)
#subhead([Texto de apoyo 34pt → 18pt en demo A4 — Lorem ipsum dolor sit amet.], size: 18pt)

```typ
#headline([Titular grande], size: 72pt) // nativo 1080pt
#headline([Titular demo], size: 38pt)   // A4 escalado
#subhead([Texto de apoyo], size: 34pt)  // nativo
```
#v(8pt)

#text(size: 9pt, weight: 700)[avatar · avatar-row — nativo `avatar(size:90pt)` en 1080pt; aquí 44pt (~49%)]
#grid(columns: 2, gutter: 14pt,
  block(fill: white, radius: 8pt, inset: 10pt, stroke: 0.6pt + luma(85%))[
    #avatar("MJ", bg-color: palette.primary, size: 44pt) #h(8pt) #avatar("AA", bg-color: palette.secondary, size: 44pt) #h(8pt) #avatar("PG", bg-color: palette.accent, size: 44pt)
    #v(6pt) #text(size: 7pt, fill: gray)[`avatar("MJ", size:90pt)` nativo → 44pt en A4]
  ],
  block(fill: white, radius: 8pt, inset: 10pt, stroke: 0.6pt + luma(85%))[
    #scale(x: 62%, y: 62%, reflow: true)[
      #avatar-row("María J.", "Community Manager", "MJ", bg-color: palette.primary)
    ]
    #v(6pt)
    #scale(x: 62%, y: 62%, reflow: true)[
      #avatar-row("Carlos P.", "Editor", "CP", bg-color: palette.secondary)
    ]
    #v(4pt) #text(size: 7pt, fill: gray)[`avatar-row` escalado 62% para A4]
  ],
)

```typ
#avatar("MJ", bg-color: palette.primary, size: 90pt)
#avatar-row("María J.", "Community Manager", "MJ")
```
#v(8pt)

#text(size: 9pt, weight: 700)[stat · progress · divider — todos a escala canvas, aquí 45-60% para A4]
#block(fill: white, radius: 8pt, inset: 10pt, stroke: 0.6pt + luma(85%), width: 100%)[
  #grid(columns: 3, gutter: 14pt, align: (center, center, center),
    scale(x: 42%, y: 42%, reflow: true)[#stat("+240%", "más alcance", color: palette.primary)],
    block(width: 100%)[
      #progress(0.72, color: palette.secondary, height: 8pt) #v(6pt)
      #progress(0.35, color: palette.accent, height: 8pt) #v(6pt)
      #align(center)[#text(size: 7pt, fill: gray)[`progress(72%, height:8pt)` nativo 14pt]]
    ],
    block(width: 100%)[#text(size: 7pt, fill: gray)[arriba] #v(4pt) #divider(color: palette.primary) #v(4pt) #text(size: 7pt, fill: gray)[abajo]],
  )
]

```typ
#stat("+240%", "más alcance", color: palette.primary) // 140pt nativo
#progress(0.72, color: palette.secondary) // height: 14pt nativo
#divider(color: palette.secondary)
```
#v(8pt)

#text(size: 9pt, weight: 700)[footer — nativo 26pt en 1080pt; aquí escalado 60% para A4]
#block(fill: palette.dark, radius: 8pt, inset: 12pt, width: 100%)[
  #scale(x: 60%, y: 60%, reflow: true)[#footer("@mi_marca", color: white)]
  #v(4pt) #text(size: 7pt, fill: white.transparentize(40%))[Sobre fondo oscuro · `footer(handle, color: white)` — nativo fuera de escala]
]
#v(6pt)
#block(fill: white, radius: 8pt, inset: 12pt, stroke: 0.6pt + luma(85%), width: 100%)[
  #scale(x: 60%, y: 60%, reflow: true)[#footer("@mi_marca", color: gray.darken(40%))]
  #v(4pt) #text(size: 7pt, fill: gray)[Sobre fondo claro · `footer(handle, color: gray.darken(40%))`]
]

```typ
#footer("@mi_marca", color: white)
#footer("@mi_marca", color: gray.darken(40%))
```
#v(8pt)

#text(size: 9pt, weight: 700)[Fundaciones canvas]
#grid(columns: 2, gutter: 12pt,
  block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 10pt)[
    #text(size: 7.5pt, weight: 700)[sizes] #v(4pt)
    #text(size: 7.5pt, fill: luma(30%))[instagram: 1080×1080#linebreak()story: 1080×1920#linebreak()twitter: 1600×900#linebreak()linkedin: 1200×1200]
  ],
  block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 10pt)[
    #text(size: 7.5pt, weight: 700)[bg / gradient-bg / blob] #v(4pt)
    #box(height: 28pt, width: 100%, fill: gradient.linear(angle: 135deg, palette.primary, palette.secondary), radius: 6pt)
    #v(4pt) #text(size: 7pt, fill: gray)[`gradient-bg(from: primary, to: secondary)` + `blob()` decorativo]
  ],
)

#pagebreak()

// ═══════════════════════════════════════════════════════════
// 4. PLANTILLAS SOCIALES — cada una es un canvas a página completa
// ═══════════════════════════════════════════════════════════
#set page(paper: "a4", margin: 1.2cm, fill: rgb("#fafafa"))
#align(center)[
  #text(font: theme.base.fonts.display, size: 20pt, weight: 800, fill: theme.base.colors.primary)[4 · Plantillas sociales]
  #v(4pt)
  #text(size: 9pt, fill: gray)[10 plantillas `canvas` + `versus-post`/`vs-badge` · Las siguientes páginas son posts reales a tamaño Instagram/Story]
]

#pagebreak()

// Cada plantilla ocupa su propia página con su tamaño nativo
#quote-post([El diseño no es cómo se ve algo. Es cómo funciona.], [Steve Jobs], "@mi_marca")
#announce-post("NUEVO", [Lanzamos la versión 2.0], [Rediseñamos todo lo que te gustaba, y añadimos lo que pediste.], "@mi_marca")
#tip-card(3, [Publica a la misma hora cada día], [La constancia entrena al algoritmo... y a tu audiencia.], "@mi_marca", color: palette.secondary)
#carousel-cover("GUÍA 2026", [Cómo crecer en Instagram sin pagar anuncios], "@mi_marca", n-pages: 6)
#carousel-slide(2, 6, [Publica con constancia], [El algoritmo premia las cuentas activas. Fija un horario y respétalo: mejor 3 posts semanales fijos que 10 seguidos y silencio.], "@mi_marca")
#stat-card("+240%", [más alcance orgánico], [Las cuentas que usan carruseles duplican su interacción frente a las imágenes simples.], "@mi_marca")
#versus-post("Sin estrategia", ([Publicar al azar], [Sin identidad visual], [Ignorar comentarios]), "Con sistema", ([Calendario fijo], [Plantillas reutilizables], [Comunidad activa]), "@mi_marca")
#event-post("12", "SEPT", [Webinar: Diseño con Typst], ["Gratis · Online · 18:00 CET. Aprende a crear visuales profesionales desde código."], "@mi_marca")
#testimonial-post([En dos semanas pasamos de publicar improvisando a tener un feed coherente. El engagement se disparó.], "María J.", "Community Manager", "MJ", "@mi_marca")
#poll-story([¿Qué quieres ver mañana?], ["Tutorial paso a paso"], ["Plantilla descargable"], "@mi_marca")

// ═══════════════════════════════════════════════════════════
// 5. BLOCKQUOTES — 9 tipos, cada uno dentro de un canvas demo
// ═══════════════════════════════════════════════════════════
#set page(paper: "a4", margin: 1.2cm, fill: rgb("#fafafa"))
#align(center)[
  #text(font: theme.base.fonts.display, size: 20pt, weight: 800, fill: theme.base.colors.primary)[5 · Blockquotes]
  #v(4pt)
  #text(size: 9pt, fill: gray)[9 funciones `blockquote-*` · bloques reutilizables (no canvas) — aquí montados en canvas Instagram para demo]
]
#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[1/9 · blockquote-editorial]
    #v(8pt)
    #blockquote-editorial([El diseño no es cómo se ve algo. Es cómo funciona.], autor: "Steve Jobs", fuente: "Wired, 1996")
    #v(6pt) #text(size: 16pt, fill: gray)[Doble borde · comilla 60pt · itálica · `autor:`/`fuente:` en mayúsculas]
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[2/9 · blockquote-bar — variante default]
    #v(8pt)
    #blockquote-bar([La constancia entrena al algoritmo... y a tu audiencia.], autor: "Equipo de redes", color: palette.secondary)
    #v(18pt)
    #text(size: 20pt, weight: 700, fill: gray)[3/9 · blockquote-bar — variante grande]
    #v(8pt)
    #blockquote-bar([Una cita más grande, con la variante "grande".], autor: "Alguien", variante: "grande", color: palette.accent)
    #v(18pt)
    #text(size: 20pt, weight: 700, fill: gray)[4/9 · blockquote-bar — variante acento]
    #v(8pt)
    #blockquote-bar([Una cita acentuada con fondo tenue.], variante: "acento", color: palette.primary)
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[5/9 · blockquote-card]
    #v(8pt)
    #blockquote-card([Las cuentas que usan carruseles duplican su interacción.], autor: "María J.", fuente: "Community Manager", color: palette.primary)
  ]
])

#canvas(sizes.instagram, [
  #gradient-bg(from: palette.dark, to: palette.primary)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: white.transparentize(40%))[6/9 · blockquote-hero — sobre gradiente oscuro]
    #v(8pt)
    #blockquote-hero([No somos almas que tienen cuerpos; somos cuerpos que, cuando Dios lo ordena, resucitarán.], autor: "C.S. Lewis", color: palette.accent)
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[7/9 · blockquote-avatar + blockquote-grid (2 columnas)]
    #v(8pt)
    #blockquote-grid(columnas: 2, (
      blockquote-avatar([En dos semanas pasamos de improvisar a tener un feed coherente.], autor: "María J.", fuente: "CM", iniciales: "MJ"),
      blockquote-avatar([El contenido es rey, pero la constancia es reina.], autor: "Autor Anónimo", iniciales: "AA", color: palette.secondary),
    ))
    #v(10pt) #text(size: 16pt, fill: gray)[`blockquote-grid(columnas: 2, (blockquote-avatar(...), ...))` · `iniciales:` explícito evita crash si autor no es texto plano]
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[7b/9 · blockquote-avatar — solo con autor (sin avatar-row)]
    #v(8pt)
    #blockquote-avatar([Una idea aislada sin iniciales muestra solo el nombre.], autor: "Séneca", fuente: "Cartas a Lucilio")
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[8/9 · blockquote-hand — Caveat (requiere --font-path Fonts)]
    #v(8pt)
    #blockquote-hand([El corazón tiene razones que la razón no conoce.], autor: "Pascal")
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[9a/9 · blockquote-paralelo — griego + español]
    #v(8pt)
    #blockquote-paralelo(
      [Ἐν ἀρχῇ ἦν ὁ λόγος, καὶ ὁ λόγος ἦν πρὸς τὸν θεόν, καὶ θεὸς ἦν ὁ λόγος.],
      [En el principio era el Verbo, y el Verbo era con Dios, y el Verbo era Dios.],
      idioma: "griego", referencia: "Juan 1:1", color: palette.primary,
    )
    #v(10pt)
    #text(size: 20pt, weight: 700, fill: gray)[9b/9 · blockquote-paralelo — hebreo RTL + español]
    #v(8pt)
    #blockquote-paralelo(
      [בְּרֵאשִׁית בָּרָא אֱלֹהִים אֵת הַשָּׁמַיִם וְאֵת הָאָרֶץ],
      [En el principio creó Dios los cielos y la tierra.],
      idioma: "hebreo", referencia: "Génesis 1:1", color: rgb("#8b2e3a"),
    )
  ]
])

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #text(size: 20pt, weight: 700, fill: gray)[10/9 · blockquote-lateral — atribución rotada 270° + numeración]
    #v(8pt)
    #blockquote-lateral(n: 26, autor: "Blaise Pascal", fuente: "Pensées")[Del mismo modo que se estropea la mente, se estropea también el sentimiento. La mente y el sentimiento se forman por medio del trato con los demás; y es imposible elegir bien si uno no está ya formado y no estropeado.]
    #v(16pt)
    #blockquote-lateral(autor: "Séneca", fuente: "Cartas")[No es que tengamos poco tiempo, sino que perdemos mucho.]
  ]
])

// ═══════════════════════════════════════════════════════════
// 6. EDITORIAL — capitular + articulo + pasaje
// ═══════════════════════════════════════════════════════════
#set page(paper: "a4", margin: 1.8cm, fill: rgb("#fdfbf7"))
#text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[6 · Editorial]
#v(4pt)
#text(size: 9pt, fill: gray)[`capitular` · `articulo` · `primer-parrafo` · `fondo-editorial` / `make-theme`]
#v(10pt)

#text(size: 10pt, weight: 700)[capitular — 3 familias]
#v(6pt)
#set text(size: 10pt, lang: "es")
#set par(justify: true, leading: 0.75em)
#capitular(font: (font-tokens.family)("eb-garamond"), alto: 3, fill: rgb("#2c2c2c"))[En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha mucho tiempo que vivía un hidalgo de los de lanza en astillero, adarga antigua, rocín flaco y galgo corredor.]
#v(6pt) #text(size: 7pt, fill: gray)[↑ EB Garamond · `capitular(alto: 3, font: "EB Garamond")`]
#v(8pt)
#capitular(font: (font-tokens.family)("ysabeau"), alto: 3, fill: rgb("#7a1f1f"))[Una olla de algo más vaca que carnero, salpicón las más noches, duelos y quebrantos los sábados, lantejas los viernes, algún palomino de añadidura los domingos, consumían las tres partes de su hacienda.]
#v(6pt) #text(size: 7pt, fill: gray)[↑ Ysabeau · `capitular(font: "Ysabeau")`]
#v(8pt)
#capitular(font: (font-tokens.family)("im-fell-english"), alto: 3, fill: rgb("#2c4a3a"))[El resto della concluían sayo de velarte, calzas de velludo para las fiestas, con sus pantuflos de lo mesmo, y los días de entresemana se honraba con su vellorí de lo más fino.]
#v(6pt) #text(size: 7pt, fill: gray)[↑ IM FELL English · parámetro `transformar:` disponible para versalitas]

#v(14pt)
#text(size: 10pt, weight: 700)[primer-parrafo + fondo-editorial]
#v(6pt)
#let t-demo = make-theme(paleta: "terracota", tipografia: "editorial-clasico")
#block(fill: fondo-editorial(t-demo), radius: 6pt, inset: 14pt, stroke: (left: 3pt + t-demo.colors.primary), width: 100%)[
  #set text(font: t-demo.fonts.body, size: 9.5pt, fill: t-demo.colors.dark)
  #set par(justify: true, leading: 0.8em, first-line-indent: 1em)
  #primer-parrafo(alto: 3)[Este optimismo, que caracteriza precisamente a la filosofía de las Luces y al cientificismo del siglo XIX, carece ya de actualidad. Después de las catástrofes de que ha sido testigo el siglo XX, la razón ha perdido su dimensión positiva y se ataca en tanto que instrumento de dominio responsable y burocrático.]
  Nuestra relación con los tiempos, y concretamente con el futuro, está ya marcada por esta crítica, aun cuando perduren restos del pasado optimismo.
  #v(4pt) #text(size: 7pt, fill: gray)[`make-theme(paleta: "terracota", tipografia: "editorial-clasico")` · `fondo-editorial(t)` elige light/white según contraste AA]
]

#v(12pt)
#text(size: 10pt, weight: 700)[articulo — plantilla completa]
#v(4pt)
#text(size: 8pt, fill: gray)[El siguiente `#articulo.with(...)` muestra la plantilla editorial A5 usada en `examples/articulo.typ`. Se renderiza en miniatura para este catálogo:]
#v(6pt)
  #block(width: 100%, height: 420pt, clip: true, stroke: 0.7pt + luma(80%), radius: 6pt, fill: fondo-editorial(t-demo), inset: 16pt)[
    // Simulamos la cabecera de articulo sin re-ejecutar `show: articulo`
    #align(center)[
      #box(fill: t-demo.colors.primary.transparentize(85%), inset: (x: 8pt, y: 3pt), radius: 8pt)[
        #text(font: t-demo.fonts.body, size: 7.5pt, weight: 700, tracking: 0.12em, fill: t-demo.colors.primary, upper("Ensayo"))
      ]
      #v(4pt)
      #text(font: t-demo.fonts.display, weight: 900, size: 16pt, fill: t-demo.colors.primary)[Los tiempos hipermodernos]
      #v(4pt)
      #text(font: t-demo.fonts.body, size: 7.5pt, fill: t-demo.colors.dark.transparentize(35%))[Sébastien Charles · 2026]
      #v(10pt)
      #line(length: 100%, stroke: 0.6pt + luma(85%))
    ]
    #v(10pt)
    #set text(font: t-demo.fonts.body, size: 8.5pt, fill: t-demo.colors.dark)
    #set par(justify: true, leading: 0.78em, first-line-indent: 1em)
    #primer-parrafo(alto: 2)[Este optimismo, que caracteriza a la filosofía de las Luces, carece ya de actualidad. Después de las catástrofes del siglo XX, la razón ha perdido su dimensión positiva.]
    Desacreditados el pasado y el futuro, el presente es la referencia esencial de los individuos democráticos.
  ]

#pagebreak()

// ═══════════════════════════════════════════════════════════
// 7. ESCRITURA — pasaje / scripture
// ═══════════════════════════════════════════════════════════
#text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[7 · Escritura]
#v(4pt)
#text(size: 9pt, fill: gray)[`pasaje` · `vs` · `ch` · `scripture` — bloque bíblico con capitular para v1 y superíndices para v2+]
#v(10pt)

#pasaje("Salmo 1", version: "RVR1960", paleta: "granates", tipografia: "revival-vintage")[
  Bienaventurado el varón que no anduvo en consejo de malos, ni estuvo en camino de pecadores, ni en silla de escarnecedores se ha sentado,
  #vs[2] sino que en la ley de Jehová está su delicia, y en su ley medita de día y de noche.
  #vs[3] Será como árbol plantado junto a corrientes de aguas, que da su fruto en su tiempo, y su hoja no cae; y todo lo que hace, prosperará.
  #vs[4] No así los malos, que son como el tamo que arrebata el viento.
]

#v(10pt)
#text(size: 8pt, weight: 700)[scripture() — contenedor neutro]
#v(4pt)
#scripture[
  #ch[1] En el principio creó Dios los cielos y la tierra. #vs[2] Y la tierra estaba desordenada y vacía, y las tinieblas estaban sobre la faz del abismo.
]

#pagebreak()

// ═══════════════════════════════════════════════════════════
// 8. IDIOMAS — lat / gr / he / interlineal
// ═══════════════════════════════════════════════════════════
#text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[8 · Idiomas]
#v(4pt)
#text(size: 9pt, fill: gray)[`lat` · `gr` · `he` · `translit` · `interlineal` — GFS Didot / Libertinus Serif / hebreo RTL]
#v(10pt)

#text(size: 10pt, weight: 700)[Frases sueltas]
#v(4pt)
Los escolásticos hablaban de #lat[creatio ex nihilo] — la creación de la nada.

En griego, #gr[λόγος] ("logos") es la palabra que Juan usa para el Verbo; con tipografía auténtica: #gr(autentico: true)[λόγος] (GFS Didot) vs. #gr(autentico: false)[λόγος] (Libertinus).

En hebreo, #he[בְּרֵאשִׁית] ("bereshit") abre el Génesis — se renderiza RTL automáticamente.

#v(10pt)
#text(size: 10pt, weight: 700)[Interlineal — Juan 1:1 (griego)]
#v(4pt)
#interlineal(
  idioma: "griego",
  (
    (original: [Ἐν], translit: "en", gloss: "en"),
    (original: [ἀρχῇ], translit: "archē", gloss: "[el] principio"),
    (original: [ἦν], translit: "ēn", gloss: "era"),
    (original: [ὁ], translit: "ho", gloss: "el"),
    (original: [λόγος], translit: "lógos", gloss: "Verbo"),
    (original: [καὶ], translit: "kaì", gloss: "y"),
    (original: [θεὸς], translit: "theòs", gloss: "Dios"),
    (original: [ἦν], translit: "ēn", gloss: "era"),
    (original: [ὁ], translit: "ho", gloss: "el"),
    (original: [λόγος], translit: "lógos", gloss: "Verbo"),
  ),
)

#v(8pt)
#text(size: 10pt, weight: 700)[Interlineal — Génesis 1:1 (hebreo RTL)]
#v(4pt)
#interlineal(
  idioma: "hebreo", color: rgb("#8b2e3a"),
  (
    (original: [בְּרֵאשִׁית], translit: "bərēʾšît", gloss: "en el principio"),
    (original: [בָּרָא], translit: "bārāʾ", gloss: "creó"),
    (original: [אֱלֹהִים], translit: "ʾĕlōhîm", gloss: "Dios"),
    (original: [אֵת], translit: "ʾēt", gloss: "—"),
    (original: [הַשָּׁמַיִם], translit: "haššāmayim", gloss: "los cielos"),
  ),
)

#v(10pt)
#text(size: 10pt, weight: 700)[Paralelo ya visto en §5 — referencia cruzada]
#v(4pt)
#text(size: 8pt, fill: gray)[Ver `blockquote-paralelo` en la sección de blockquotes (pp. griego/hebreo con referencia).]

#pagebreak()

// ── Cierre ──
#align(center + horizon)[
  #text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: theme.base.colors.primary)[Fin del catálogo]
  #v(8pt)
  #text(size: 9.5pt, fill: gray)[Todos los elementos visuales de `src/lib.typ` renderizados]
  #v(10pt)
  #grid(columns: 4, gutter: 8pt,
    box(fill: palette.primary, radius: 6pt, inset: 8pt)[#align(center)[#text(fill: white, size: 7.5pt, weight: 700)[15#linebreak()paletas]]],
    box(fill: palette.secondary, radius: 6pt, inset: 8pt)[#align(center)[#text(fill: white, size: 7.5pt, weight: 700)[8#linebreak()parejas]]],
    box(fill: palette.accent, radius: 6pt, inset: 8pt)[#align(center)[#text(fill: white, size: 7.5pt, weight: 700)[10#linebreak()plantillas]]],
    box(fill: palette.dark, radius: 6pt, inset: 8pt)[#align(center)[#text(fill: white, size: 7.5pt, weight: 700)[9#linebreak()blockquotes]]],
  )
  #v(16pt)
  #text(size: 8pt, fill: gray)[`#import "src/lib.typ": *` · `typst compile --root . --font-path Fonts demo.typ demo.pdf`]
]
