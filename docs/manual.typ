#import "../src/lib.typ": *
#import "../src/lib.typ" as lib
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages)

// ─────────────────────────────────────────────────────────────
// docs/manual.typ — Manual de InstaTypst
// Compilar: typst compile --root . --font-path Fonts docs/manual.typ docs/manual.pdf
// ─────────────────────────────────────────────────────────────

// ── Helpers de estilo del manual ──
#let primary = theme.base.colors.primary
#let accent = theme.base.colors.accent
#let muted = luma(45%)
#let faint = luma(62%)

#let h1(body) = {
  v(18pt)
  text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: primary)[#body]
  v(4pt)
  line(length: 100%, stroke: 0.7pt + luma(82%))
  v(6pt)
}
#let h2(body) = {
  v(12pt)
  text(font: theme.base.fonts.display, size: 13pt, weight: 700, fill: primary)[#body]
  v(2pt)
}
#let h3(body) = {
  v(8pt)
  text(font: theme.base.fonts.body, size: 10pt, weight: 700, fill: luma(18%))[#body]
  v(2pt)
}
#let note(body) = block(
  fill: theme.base.colors.light, stroke: (left: 2.6pt + primary),
  inset: (x: 10pt, y: 8pt), radius: 6pt, width: 100%,
)[ #set text(size: 8.5pt, fill: luma(25%)); #set par(leading: 0.7em); #body ]

#let api-table(rows) = table(
  columns: (1.7fr, 2.8fr, 2.2fr),
  stroke: 0.5pt + luma(85%),
  inset: 5pt,
  fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Función*], [*Qué hace*], [*Ejemplo*],
  ..rows.flatten(),
)

#let code-tabs(..bodies) = bodies.pos().join(v(4pt))

// ── Ejemplo con preview en vivo ──
// `dictionary(lib)` convierte TODO lo exportado por lib.typ en un dict —
// se usa como `scope:` de eval(), así que el código que se ve es
// literalmente el código que se ejecuta (no hay copia manual que se
// pueda desincronizar del código real).
#let escope = dictionary(lib)

// Lado a lado: código | render en vivo. Solo sirve para funciones que
// NO arman un canvas (page(...) no se puede anidar en un contenedor —
// ver example-canvas más abajo para esas).
#let example(codigo) = grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  align: (left + horizon, center + horizon),
  block(width: 100%, height: 100%, fill: luma(97%), stroke: 0.5pt + luma(85%), radius: 6pt, inset: 10pt)[
    #set text(size: 8pt)
    #codigo
  ],
  block(width: 100%, height: 100%, fill: white, stroke: 0.5pt + luma(85%), radius: 6pt, inset: 10pt)[
    // sin justificar: en una columna angosta, justify: true (heredado del
    // set par global del manual) fuerza guionado feo y huecos grandes
    #set par(justify: false)
    #eval(codigo.text, mode: "markup", scope: escope)
  ],
)

// Lista de parámetros — items: ((raw-del-parámetro, descripción), ...)
#let options(items) = list(
  ..items.map(it => [#raw(it.at(0)) — #it.at(1)]),
)

// Para las plantillas de canvas: por dentro llaman page(...), y Typst
// prohíbe anidar una página en un contenedor (`box`/`scale`/etc. — no hay
// vuelta, lo comprobamos compilando). No cabe lado a lado. Mejor opción
// disponible: código + opciones en la página A4, render real e íntegro
// en su propia página justo después — page(...) abre y cierra su propia
// página sola, así que el documento vuelve a A4 solo en la siguiente.
#let example-canvas(codigo, opciones: none) = {
  block(width: 100%, fill: luma(97%), stroke: 0.5pt + luma(85%), radius: 6pt, inset: 10pt)[
    #set text(size: 8pt)
    #codigo
  ]
  if opciones != none {
    v(6pt)
    options(opciones)
  }
  v(4pt)
  text(size: 7.5pt, fill: faint, style: "italic")[↓ render a tamaño real en la página siguiente]
  eval(codigo.text, mode: "markup", scope: escope)
}

#set page(paper: "a4", margin: 2cm, fill: rgb("#fdfbf7"))
#set text(font: theme.base.fonts.body, size: 10pt, fill: theme.base.colors.dark, lang: "es")
#set par(justify: true, leading: 0.78em, spacing: 1em)
#set heading(numbering: "1.")
#show link: it => text(fill: primary, underline(it))
#show raw.where(block: false): it => box(fill: luma(94%), inset: (x: 3pt, y: 1.5pt), radius: 3pt, text(size: 8.5pt, it))
#set table(align: left)

// ── PORTADA ──
#align(center + horizon)[
  #text(font: theme.base.fonts.display, size: 38pt, weight: 900, fill: primary)[InstaTypst]
  #v(6pt)
  #text(size: 13pt, fill: muted)[Sistema de diseño en Typst — Manual]
  #v(14pt)
  #box(fill: primary, radius: 8pt, inset: (x: 18pt, y: 8pt))[
    #text(fill: white, size: 10pt, weight: 700)[v0.1.0 · 2026]
  ]
  #v(18pt)
  #text(size: 9pt, fill: faint)[Temas de color y tipografía · Plantillas sociales · Editorial · Escritura · Idiomas]
  #v(20pt)
  #grid(columns: 2, gutter: 10pt, align: left,
    block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 10pt)[
      #text(size: 7.5pt, weight: 700)[Lectura recomendada]
      #v(2pt) #text(size: 7.5pt, fill: muted)[1. `demo.pdf` — catálogo visual (lo que *se ve*)\ 2. Este manual — guía narrativa (cómo *se usa*)]
    ],
    block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 10pt)[
      #text(size: 7.5pt, weight: 700)[Compilación]
      #v(2pt) #text(size: 7.5pt, fill: muted)[`typst compile --root . --font-path Fonts docs/manual.typ` — necesita `Fonts/` o fuentes del sistema]
    ],
  )
  #v(14pt)
  #text(size: 7.5pt, fill: faint)[`#import "@local/instatypst:0.1.0": *` si está instalado · `#import "src/lib.typ": *` dentro del repo]
]
#pagebreak()

// ── ÍNDICE ──
#text(font: theme.base.fonts.display, size: 20pt, weight: 800, fill: primary)[Índice]
#v(8pt)
#outline(indent: 1.2em, depth: 3)
#v(8pt)
#note[
  *Cómo leer este manual.* Cada capítulo tiene una tabla de API + un bloque `typ` copiable + una demo renderizada. Si buscas solo la referencia, salta al #link(<cap-api>)[Apéndice A]. Si vienes de `cristianamente.typ`, ve al #link(<cap-migracion>)[Apéndice B].
]
#pagebreak()

// ═══════════════════════════════════════════════════════════
= Instalación y compilación <cap-instalacion>
#h1[1 · Instalación y compilación]

#h2[1.1 Dos formas de importar]
#grid(columns: (1fr, 1fr), gutter: 12pt,
  block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 11pt)[
    #text(size: 8pt, weight: 700)[Dentro del repo (desarrollo)]
    #v(4pt)
    #text(size: 7.5pt, fill: muted)[Los `examples/` ya usan este modo. Requiere `--root .` porque importan hacia arriba.]
    #v(4pt)
    ```typ
    #import "src/lib.typ": *
    ```
  ],
  block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 11pt)[
    #text(size: 8pt, weight: 700)[Como paquete instalado]
    #v(4pt)
    #text(size: 7.5pt, fill: muted)[Copiado a `~/.local/share/typst/packages/local/instatypst/0.1.0/` sin `Fonts/` ni `examples/`.]
    #v(4pt)
    ```typ
    #import "@local/instatypst:0.1.0": *
    ```
  ],
)

#h2[1.2 Fuentes y compilación]
El paquete *no empaqueta* las fuentes — Typst no lo permite. El usuario aporta `Fonts/` o las tiene instaladas en el sistema. Por eso siempre:

```bash
typst compile --root . --font-path Fonts docs/manual.typ
typst compile --root . --font-path Fonts demo.typ
typst compile --root . --font-path Fonts examples/articulo.typ
```

`typst.toml:13` excluye `Fonts/`, `examples/` y `cristianamente.typ` del paquete publicado — solo `src/` + `typst.toml` viaja.

#h2[1.3 Estructura del paquete]
```typ
src/lib.typ              # entrypoint — re-exporta todo
  theme.typ              # API de temas (colores + fuentes, contraste WCAG)
  tokens.typ             # 96 colores individuales nombrados
  palettes.typ           # 15 paletas curadas + auto-roles
  font-tokens.typ        # 49+ fuentes verificadas
  font-pairings.typ      # 8 parejas tipográficas (display/body/mono)
  dropcaps.typ           # capitular() — letra capital automática
  articulo.typ           # articulo, primer-parrafo, make-theme, fondo-editorial
  scripture.typ          # scripture, vs, ch, pasaje
  idiomas.typ            # lat, gr, he, translit, interlineal
  social.typ             # canvas + componentes + 11 plantillas de post completo
  blockquotes.typ        # 5 legos bq-* (frame/mark/rule/rule-full/attribution) + 14 blockquote-*
examples/                # 12 ejemplos de uso (no van en el paquete)
scripts/nueva-plantilla.py # generador de esqueletos .typ (12 plantillas)
Fonts/                   # ~45 familias usadas por el proyecto
docs/manual.typ          # este manual (tú estás aquí)
demo.typ                 # catálogo visual de todo lo anterior
```

#note[
  *Regla de oro:* cada función que depende de color/tipografía acepta `theme:` explícito (por defecto #raw("theme.base")). No intentes sombrear `#let palette = mi-tema.colors` — no funciona: Typst resuelve `palette` por *closure* dentro de `social.typ:24` en el momento de definir `badge`/`headline`/etc. Solo #raw("theme:") propaga de verdad. Ver #link(<cap-temas>)[cap. 2] y #link(<cap-social>)[cap. 9].
]

// ═══════════════════════════════════════════════════════════
= Temas — `theme` API <cap-temas>
#h1[2 · Temas — `theme` API]

El tema es un valor inmutable `(name, colors, fonts)`. Todo lo demás (paletas, parejas, artículo, plantillas sociales) deriva de él.

#h2[2.1 Crear y derivar]
#api-table((
  ([`theme.base`], [Tema por defecto (indigo/pink/amber + Poppins/Inter)], [`#palette.primary`]),
  ([`theme.define(name, colors:, fonts:)`], [Crea desde el base, fusionando lo que pases], [`#let m = theme.define("m", colors: (primary: rgb("#0EA5E9")))`]),
  ([`theme.with(t, colors:, fonts:)`], [Fusiona varios cambios de golpe], [`#theme.with(m, colors: (accent: orange))`]),
  ([`theme.with-color(t, key, val)`], [Cambia un color], [`#theme.with-color(m, "primary", blue)`]),
  ([`theme.with-font(t, kind, fam)`], [Cambia display/body; `fam` puede ser array], [`#theme.with-font(m, "display", "Fraunces")`]),
  ([`theme.named(t, name)`], [Renombra sin tocar lo demás], [`#theme.named(m, "marca-v2")`]),
))

```typ
#import "src/lib.typ": *
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
#let marca2 = theme.with-color(marca, "accent", rgb("#F59E0B"))
#announce-post("NUEVO", [Título], [Subtítulo], "@handle", theme: marca2)
```

#note[Pasar `theme:` explícito a la plantilla es el *único* mecanismo que funciona. `palette`/`fonts` que ves exportados en `social.typ:35` son alias de conveniencia del tema base para usar en tu markup suelto — no para parametrizar plantillas.]

#h2[2.2 Leer tokens y derivados]
#api-table((
  ([`theme.color(key, t:)` / `theme.font(kind, t:)`], [Acceso con `panic` si no existe], [`#theme.color("primary", marca)`]),
  ([`theme.colors(t)` / `theme.fonts(t)`], [Dicts completos], [`#for (k, v) in theme.colors(m) { ... }`]),
  ([`theme.lighten` / `darken` / `fade`], [Aclarar/oscurecer/transparencia sobre token], [`#theme.lighten("primary", 20%, m)`]),
))

#h2[2.3 Contraste y legibilidad (WCAG 2.x)]
Implementado en `src/theme.typ:109` con _normalización correcta_ (`_chan(v) = v/100%`, no `v/100`): blanco puro → luminancia 1.0, contraste negro/blanco = 21.0.

#api-table((
  ([`theme.luminance(c)`], [Luminancia relativa 0–1], [`#theme.luminance(white) // ~1.0`]),
  ([`theme.contrast(a, b)`], [Ratio 1.0–21.0], [`#theme.contrast(black, white) // 21`]),
  ([`theme.is-aa(a, b)` / `is-aaa`], [¿Cumple AA 4.5 / AAA 7?], [`#theme.is-aa(marca.colors.primary, white)`]),
  ([`theme.readable-on(bg, ..cands)`], [Elige el candidato con mejor contraste sobre `bg`], [`#theme.readable-on(bg, white, black)`]),
))

#h3[Demo: `readable-on` y `is-aa`]
#let t-demo = make-theme(paleta: "granates", tipografia: "revival-vintage")
#let bg-g = t-demo.colors.primary
#let fg-elegido = (theme.readable-on)(bg-g, white, black)
#let aa-ok = (theme.is-aa)(fg-elegido, bg-g)
#block(fill: bg-g, radius: 8pt, inset: 12pt, width: 100%)[
  #text(fill: fg-elegido, weight: 700, size: 9pt)[Fondo `granates.primary` → texto elegido por `readable-on`: #fg-elegido.to-hex() · AA: #aa-ok]
]
#v(4pt) #text(size: 7.5pt, fill: faint)[`granates` es monocromática — por eso `light` no contrasta y `fondo-editorial()` cae a `white` (ver #link(<cap-editorial>)[cap. 5]).]

#h2[2.4 Persistencia]
```typ
#theme.export(marca, "marca.json")   // guarda {name, colors: {k: hex}, fonts}
#let m2 = theme.load("marca.json")    // reconstruye con theme.define
```

#note[`theme.export`/`load` están en el namespace pero no se usan en ningún ejemplo — candidato a retirar si no los necesitas, o a documentar con un `examples/theme-persistencia.typ`.]

// ═══════════════════════════════════════════════════════════
= Colores — tokens y paletas <cap-paletas>
#h1[3 · Colores — tokens y paletas]

#h2[3.1 `color-tokens` — 96 colores individuales]
Viven en `src/tokens.typ:1`, compartidos con `theme.base` y con `palettes`. Acceso namespaced para no chocar con `font-tokens`:

```typ
#import "src/lib.typ": *
#color-tokens.token("sky-400")   // → color
#color-tokens.tokens.at("red-500")
#color-tokens.tokens.len() // 96
```

Se re-exportan también como `palettes.token`/`palettes.tokens` por compatibilidad (`src/palettes.typ:23`).

#h2[3.2 `palettes` — 15 paletas curadas]
Cada paleta es una lista de claves de tokens. Nombres en `src/palettes.typ:25`: `noche-azul`, `neon`, `retro`, `oceano`, `granates`, `terracota`, `web-suave`, `vintage`, `arcoiris-pastel`, `marino`, `mediterraneo`, `otono`, `bosque`, `grises`, `algodon`.

#api-table((
  ([`palettes.names() / .library`], [Lista y dict completo], [`#palettes.names()`]),
  ([`palettes.get(name)`], [Array de colores resueltos], [`#palettes.get("neon")`]),
  ([`palettes.mix(..items)`], [Paleta ad-hoc (tokens o colores sueltos)], [`#palettes.mix("sky-400", rgb("#123"))`]),
  ([`palettes.as-theme(name)`], [Convierte a tema vía `auto-roles`], [`#let t = (palettes.as-theme)("terracota")`]),
  ([`palettes.auto-roles(cols)`], [Asigna primary/secondary/accent/dark/light/white por luminancia + saturación], [`#palettes.auto-roles(palettes.get("neon"))`]),
  ([`palettes.swatch / .card / .catalog`], [Visuales para docs/demo], [`#(palettes.catalog)(columns: 3)`]),
))

```typ
#let terracota = (palettes.as-theme)("terracota")
#announce-post("NUEVO", [Título], [Subtítulo], "@handle", theme: terracota)
```

#h2[3.3 Cómo `auto-roles` decide]
`src/palettes.typ:88`: `dark` = más oscuro, `light` = más claro (por `luminance()`), intermedios ordenados por saturación descendente → `primary` (más saturado), luego `secondary`, `accent`. `white` siempre es blanco puro. En paletas monocromáticas (ej. `granates`) `light` puede quedar rojizo y no pasar AA — ahí `fondo-editorial()` corrige (ver #link(<cap-editorial>)[cap. 5]).

#h3[Demo rápida: `swatch` y `roles`]
#let neon = (palettes.as-theme)("neon")
#let marino = (palettes.as-theme)("marino")
#grid(columns: 2, gutter: 10pt,
  block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 10pt)[
    #text(size: 7.5pt, weight: 700)[neon — roles]
    #v(4pt)
    #for k in ("primary","secondary","accent","dark","light","white") {
      [#text(size: 6.5pt, weight: 600)[#k] #h(4pt) #box(circle(radius: 6pt, fill: neon.colors.at(k), stroke: 0.4pt + luma(75%))) #h(4pt) #text(size: 5.5pt, fill: faint, neon.colors.at(k).to-hex()) #linebreak()]
    }
    #v(6pt) #(palettes.swatch)("neon", size: 14pt)
  ],
  block(fill: white, stroke: 0.6pt + luma(85%), radius: 8pt, inset: 10pt)[
    #text(size: 7.5pt, weight: 700)[marino — roles]
    #v(4pt)
    #for k in ("primary","secondary","accent","dark","light","white") {
      [#text(size: 6.5pt, weight: 600)[#k] #h(4pt) #box(circle(radius: 6pt, fill: marino.colors.at(k), stroke: 0.4pt + luma(75%))) #h(4pt) #text(size: 5.5pt, fill: faint, marino.colors.at(k).to-hex()) #linebreak()]
    }
    #v(6pt) #(palettes.swatch)("marino", size: 14pt)
  ],
)

// ═══════════════════════════════════════════════════════════
= Tipografía — tokens y parejas <cap-tipografia>
#h1[4 · Tipografía — tokens y parejas]

#h2[4.1 `font-tokens` — 49+ fuentes verificadas]
Cada fuente está verificada compilando (ver `src/font-tokens.typ:1`). API:

```typ
#font-tokens.family("eb-garamond") // → "EB Garamond" (nombre real para Typst)
#font-tokens.tokens.len()           // 49+
```

Tabla `by-script` documenta qué familias cubren latín/griego/hebreo (usado por `idiomas.typ:21`).

#h2[4.2 `pairings` — 8 parejas curadas]
Mismo patrón que `palettes` (`src/font-pairings.typ:1`). Nombres (ver `src/font-pairings.typ`): `editorial-clasico`, `editorial-expresivo`, `revival-vintage`, `moderno-suave`, etc. (8 en total).

```typ
#pairings.names()                       // 8
#(pairings.catalog)(columns: 3)           // carta visual como en demo §2
#let t = pairings.as-theme("revival-vintage") // → tema solo con fonts
#pairings.resolve("revival-vintage")    // → dict {display, body, mono} sin envolver en theme
```

Combinar color + tipografía en un solo tema:

```typ
#let t = make-theme(paleta: "terracota", tipografia: "editorial-clasico")
```

#h2[4.3 Ejes variables — `variations:`]
`badge`, `headline` y `subhead` aceptan `variations:` (dict de ejes OpenType). Solo tiene efecto con fuentes variables auténticas (`src/social.typ:84`).

*Importante* (`examples/variable-fonts.typ:10`): `Bricolage Grotesque` estático ignora `variations:` en silencio. El archivo variable real se registra como *`Bricolage Grotesque 96pt`*:

```typ
#let editorial-variable = theme.define("editorial-variable", fonts: (
  display: "Fraunces",                   // wght 100-900 · opsz 9pt-144pt · SOFT/WONK
  body: "Bricolage Grotesque 96pt",     // wght 200-800 · wdth 75%-100% · opsz 12pt-96pt
))
#headline([Tipografía con carácter], variations: (wght: 900, opsz: 144, WONK: 1), theme: editorial-variable)
#badge("EDICIÓN LIMITADA", variations: (wdth: 75, wght: 700), theme: editorial-variable)
#subhead([Fina y ancha], variations: (wdth: 100, wght: 300), theme: editorial-variable)
```

#note[Ver `examples/variable-fonts.typ:1` y la demo de `opsz`/`SOFT`/`WONK` en 2 slides. Si copias esa receta a tu proyecto, compila con `--font-path Fonts` para que `Fraunces` y `Bricolage Grotesque 96pt` existan.]

// ═══════════════════════════════════════════════════════════
= Capitulares — `capitular()` <cap-capitulares>
#h1[5 · Capitulares — `capitular()`]

Port tipográfico de la letra capital automática (`src/dropcaps.typ:201`).

```typ
#capitular[En un lugar de la Mancha, de cuyo nombre no quiero acordarme, ...]
#capitular(font: font-tokens.family("eb-garamond"), alto: 3, fill: rgb("#2c2c2c"))[En un lugar ...]
#capitular(alto: 2, hueco: 0.08em, sangria: 0pt, profundidad: 0pt)[En un lugar ...]
#capitular(transformar: smallcaps)[En un lugar ...] // versalitas
```

Parámetros: `alto` (líneas o longitud, default 2), `hueco`, `sangria`, `profundidad`, `justificar: auto`, `transformar: none`, `letra: none` (si quieres forzar la inicial). Internamente mide el alto real del texto y dimensiona la inicial por factor; respeta `top-edge: "bounds"`/`bottom-edge`.

#h3[Demo — 3 familias]
#set text(size: 9pt)
#set par(justify: true, leading: 0.78em)
#capitular(font: (font-tokens.family)("eb-garamond"), alto: 3, fill: rgb("#2c2c2c"))[En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha mucho tiempo que vivía un hidalgo de los de lanza en astillero...]
#v(4pt) #text(size: 6.5pt, fill: faint)[EB Garamond]
#v(6pt)
#capitular(font: (font-tokens.family)("ysabeau"), alto: 3, fill: rgb("#7a1f1f"))[Una olla de algo más vaca que carnero, salpicón las más noches, duelos y quebrantos los sábados...]
#v(4pt) #text(size: 6.5pt, fill: faint)[Ysabeau]
#v(6pt)
#capitular(font: (font-tokens.family)("im-fell-english"), alto: 3, fill: rgb("#2c4a3a"))[El resto della concluían sayo de velarte, calzas de velludo para las fiestas...]
#v(4pt) #text(size: 6.5pt, fill: faint)[IM Fell English · `transformar:` disponible para versalitas]
#set par(justify: true, leading: 0.78em)

// ═══════════════════════════════════════════════════════════
= Editorial — `articulo` <cap-editorial>
#h1[6 · Editorial — `articulo`]

Junta paleta + pareja + capitular en un solo tema (`src/articulo.typ:1`).

#h2[6.1 `make-theme` y `fondo-editorial`]
```typ
#let t = make-theme(paleta: "terracota", tipografia: "editorial-clasico")
#fondo-editorial(t) // → t.colors.light si pasa AA sobre primary+dark, si no white
```

`fondo-editorial` (`src/articulo.typ:38`) evita texto ilegible cuando `light` no es claro (ej. `granates`).

#h2[6.2 `articulo` y `primer-parrafo`]
```typ
#import "src/lib.typ": *
#show: articulo.with(
  titulo: "Los tiempos hipermodernos",
  categoria: "Ensayo",
  autor: "Sébastien Charles",
  fecha: "2026",
  paleta: "terracota",
  tipografia: "editorial-clasico",
  paper: "a5", // o "a4"
)
#primer-parrafo[Este optimismo, que caracteriza a la filosofía de las Luces, ...]
Resto del cuerpo. Usa = y == para encabezados — salen en display/primary.
```

El tema activo viaja por `state("articulo-tema")` (`src/articulo.typ:60`) para que `primer-parrafo` lo lea fuera del scope léxico de `articulo()`.

#note[No intentes `#let palette = t.colors` para personalizar — `articulo` y `primer-parrafo` leen el `state`, no tu `let`.]

#h2[6.3 Demo en miniatura]
#let t2 = make-theme(paleta: "terracota", tipografia: "editorial-clasico")
#block(width: 100%, height: 250pt, clip: true, stroke: 0.6pt + luma(80%), radius: 8pt, fill: fondo-editorial(t2), inset: 14pt)[
  #align(center)[
    #box(fill: t2.colors.primary.transparentize(85%), inset: (x: 7pt, y: 2.5pt), radius: 8pt)[
      #text(font: t2.fonts.body, size: 6.5pt, weight: 700, tracking: 0.12em, fill: t2.colors.primary, upper("Ensayo"))
    ]
    #v(3pt)
    #text(font: t2.fonts.display, weight: 900, size: 14pt, fill: t2.colors.primary)[Los tiempos hipermodernos]
    #v(2pt)
    #text(font: t2.fonts.body, size: 7pt, fill: t2.colors.dark.transparentize(35%))[Sébastien Charles · 2026]
    #v(8pt) #line(length: 100%, stroke: 0.5pt + luma(85%))
  ]
  #v(8pt)
  #set text(font: t2.fonts.body, size: 7.5pt, fill: t2.colors.dark)
  #set par(justify: true, leading: 0.75em, first-line-indent: 1em)
  #primer-parrafo(alto: 2)[Este optimismo, que caracteriza a la filosofía de las Luces, carece ya de actualidad. Después de las catástrofes del siglo XX, la razón ha perdido su dimensión positiva.]
  Desacreditados el pasado y el futuro, el presente es la referencia esencial.
]
#v(4pt) #text(size: 7.5pt, fill: faint)[Plantilla A5 real en `examples/articulo.typ` — arriba, vista a escala para el manual.]

// ═══════════════════════════════════════════════════════════
= Escritura — `scripture` / `pasaje` <cap-escritura>
#h1[7 · Escritura — `scripture` / `pasaje`]

Versículos con capitular para v1 y superíndices para v2+ (`src/scripture.typ:1`).

#h2[7.1 Primitivas]
#api-table((
  ([`scripture[..]`], [Contenedor neutro (Public Sans, fondo tenue)], [`#scripture[#ch[1] En el principio... #vs[2] Y la tierra...]`]),
  ([`ch[1]`], [Número de capítulo grande (26pt, bold)], [`#ch[1]`]),
  ([`vs[2]`], [Número de versículo en superíndice (EB Garamond, 8pt)], [`Bienaventurado ... #vs[2] sino que...`]),
))

#h2[7.2 `pasaje` — receta combinada]
```typ
#pasaje("Salmo 1", version: "RVR1960", paleta: "granates", tipografia: "revival-vintage")[
  Bienaventurado el varón que no anduvo en consejo de malos,
  #vs[2] sino que en la ley de Jehová está su delicia,
  #vs[3] Será como árbol plantado junto a corrientes de aguas, ...
]

#pasaje("Génesis 1", capitular-alto: 2, paleta: "oceano")[En el principio...]
```

`pasaje` arma el tema con `make-theme`, elige fondo con `fondo-editorial`, y delega la primera línea a `capitular(display, primary, capitular-alto)`; `vs`/`ch` ya están disponibles si los usas dentro.

#h3[Demo]
#pasaje("Salmo 1", version: "RVR1960", paleta: "granates", tipografia: "revival-vintage")[
  Bienaventurado el varón que no anduvo en consejo de malos, ni estuvo en camino de pecadores, ni en silla de escarnecedores se ha sentado,
  #vs[2] sino que en la ley de Jehová está su delicia, y en su ley medita de día y de noche.
  #vs[3] Será como árbol plantado junto a corrientes de aguas, que da su fruto en su tiempo, y su hoja no cae; y todo lo que hace, prosperará.
]

// ═══════════════════════════════════════════════════════════
= Idiomas — `lat` / `gr` / `he` / `interlineal` <cap-idiomas>
#h1[8 · Idiomas — `lat` / `gr` / `he` / `interlineal`]

Cada función usa la fuente verificada por guion (`src/idiomas.typ:7`): latín → EB Garamond itálica; griego → GFS Didot (auténtico) o Libertinus Serif; hebreo → Libertinus Serif (única con niqqud).

```typ
Los escolásticos hablaban de #lat[creatio ex nihilo].
En griego, #gr[λόγος] — auténtico: #gr(autentico: true)[λόγος].
En hebreo, #he[בְּרֵאשִׁית] — RTL automático.
```

#api-table((
  ([`lat[..]`], [Latín, EB Garamond itálica, `lang: "la"`], [`#lat[creatio ex nihilo]`]),
  ([`gr[..]` / `gr(autentico: true)`], [Griego politónico; `autentico` usa GFS Didot], [`#gr[λόγος]`]),
  ([`he[..]`], [Hebreo con niqqud, `dir: rtl` forzado], [`#he[בְּרֵאשִׁית]`]),
  ([`translit[..]`], [Transliteración romanizada itálica], [`#translit[bereshit]`]),
))

#h2[8.1 `interlineal` — palabra por palabra]
```typ
#interlineal(
  idioma: "griego", // "griego" | "hebreo" | "latin"
  (
    (original: [Ἐν], translit: "en", gloss: "en"),
    (original: [ἀρχῇ], translit: "archē", gloss: "[el] principio"),
    (original: [λόγος], translit: "lógos", gloss: "Verbo"),
  ),
)
```

*Orden siempre en lectura natural* — `idioma: "hebreo"` pone el `grid` en `dir: rtl` y voltea el layout visual sin necesidad de invertir el array (`src/idiomas.typ:49`).

#interlineal(
  idioma: "griego",
  (
    (original: [Ἐν], translit: "en", gloss: "en"),
    (original: [ἀρχῇ], translit: "archē", gloss: "[el] principio"),
    (original: [ἦν], translit: "ēn", gloss: "era"),
    (original: [ὁ], translit: "ho", gloss: "el"),
    (original: [λόγος], translit: "lógos", gloss: "Verbo"),
  ),
)
#interlineal(
  idioma: "hebreo", color: rgb("#8b2e3a"),
  (
    (original: [בְּרֵאשִׁית], translit: "bərēʾšît", gloss: "en el principio"),
    (original: [בָּרָא], translit: "bārāʾ", gloss: "creó"),
    (original: [אֱלֹהִים], translit: "ʾĕlōhîm", gloss: "Dios"),
    (original: [הַשָּׁמַיִם], translit: "haššāmayim", gloss: "los cielos"),
  ),
)
#note[Para un versículo completo en dos columnas (original + traducción) usa `blockquote-paralelo` (#link(<cap-blockquotes>)[cap. 12.1]).]

// ═══════════════════════════════════════════════════════════
= Fundaciones — `canvas` <cap-canvas>
#h1[9 · Fundaciones — `canvas`]

#h2[9.1 Tamaños y superficies]
```typ
#canvas(sizes.instagram, [ ... ]) // 1080×1080
#canvas(sizes.story, [ ... ])     // 1080×1920
#canvas(sizes.twitter, [ ... ])   // 1600×900
#canvas(sizes.linkedin, [ ... ])  // 1200×1200

#bg(palette.white)                                  // fondo plano
#gradient-bg(from: palette.primary, to: palette.secondary) // degradado 135°
#blob(-200pt, -150pt, 400, white)                   // círculo decorativo
#pad(page-pad)[ ... ]                               // inset 80pt estándar
```

`sizes` y `page-pad`/`radius` en `src/social.typ:39`. `canvas` acepta `theme:` (por defecto `theme.base`) y usa `theme.colors.light` como fill.

#h2[9.2 Alias `palette` / `fonts`]
```typ
#palette.primary  // → theme.base.colors.primary (atajo para tu markup suelto)
#fonts.display    // → theme.base.fonts.display
```

Válido para tu propio contenido; no para parametrizar plantillas (ver #link(<cap-temas>)[cap. 2]).

// ═══════════════════════════════════════════════════════════
= Componentes base <cap-componentes>
#h1[10 · Componentes base]

Todos a escala de `canvas` de 1080pt; si los usas en A4, escala como en `demo.typ:177`.

#api-table((
  ([`badge(body, color:, variations:, theme:)`], [Píldora 22pt, borde 1.5pt, fondo 30%], [`#badge("NUEVO", color: palette.primary)`]),
  ([`headline(body, size: 72pt, ...)`], [Titular display 800], [`#headline([Titular 72pt], size: 72pt)`]),
  ([`subhead(body, size: 34pt, ...)`], [Apoyo body], [`#subhead([Texto de apoyo], size: 34pt)`]),
  ([`avatar("MJ", bg-color:, size: 90pt)`], [Círculo con iniciales (38% del size)], [`#avatar("MJ", size: 90pt)`]),
  ([`avatar-row(name, role, initials)`], [Avatar + nombre/rol], [`#avatar-row("María J.", "CM", "MJ")`]),
  ([`stat(value, label)`], [Número gigante 140pt + etiqueta], [`#stat("+240%", "más alcance")`]),
  ([`progress(pct, height: 14pt)`], [Barra 100% con fill proporcional], [`#progress(0.72)`]),
  ([`divider()`], [Líneas + punto central], [`#divider()`]),
  ([`footer(handle, color:)`], [Handle alineado abajo/izquierda], [`#footer("@mi_marca", color: white)`]),
))

#h3[Demos escaladas para A4]
#scale(x: 55%, y: 55%, reflow: true)[#badge("NUEVO", color: palette.primary) #h(6pt) #badge("TIP 3", color: palette.accent)]
#v(6pt)
#scale(x: 88%, y: 88%, reflow: true)[#headline([Titular 72pt → 38pt en A4], size: 38pt)]
#subhead([Texto de apoyo 34pt → 18pt en demo A4], size: 18pt)
#v(6pt)
#grid(columns: 2, gutter: 10pt,
  block(fill: white, radius: 8pt, inset: 8pt, stroke: 0.5pt + luma(85%))[
    #avatar("MJ", bg-color: palette.primary, size: 40pt) #h(6pt) #avatar("AA", bg-color: palette.secondary, size: 40pt) #h(6pt) #avatar("PG", bg-color: palette.accent, size: 40pt)
  ],
  block(fill: white, radius: 8pt, inset: 8pt, stroke: 0.5pt + luma(85%))[
    #scale(x: 55%, y: 55%, reflow: true)[#avatar-row("María J.", "Community Manager", "MJ", bg-color: palette.primary)]
  ],
)
#v(6pt)
#block(fill: white, radius: 8pt, inset: 8pt, stroke: 0.5pt + luma(85%), width: 100%)[
  #grid(columns: 3, gutter: 10pt, align: (center, center, center),
    scale(x: 38%, y: 38%, reflow: true)[#stat("+240%", "más alcance", color: palette.primary)],
    block(width: 100%)[#progress(0.72, color: palette.secondary, height: 6pt) #v(4pt) #progress(0.35, color: palette.accent, height: 6pt)],
    block(width: 100%)[#divider(color: palette.primary)],
  )
]

// ═══════════════════════════════════════════════════════════
= Plantillas sociales <cap-social>
#h1[11 · Plantillas sociales]

Todas devuelven un `canvas` (un `page(...)` a tamaño de plataforma) listo para exportar a PNG/PDF. El parámetro `theme:` se propaga internamente a `badge`/`headline`/etc. por closure (ver nota de `social.typ:14`). Por eso cada ejemplo de abajo sale en su propia página a tamaño real inmediatamente después del código — Typst no permite anidar una página dentro de un bloque, así que no cabe un lado a lado con miniatura (ver el comentario en `docs/manual.typ` junto a `example-canvas`).

#h2[11.1 `quote-post`]
Cita centrada sobre degradado + blobs decorativos.
#example-canvas(```typ
#quote-post([El diseño no es cómo se ve. Es cómo funciona.], "Steve Jobs", "@mi_marca")
```, opciones: (
  ("quote", "contenido de la cita"),
  ("author", "nombre del autor"),
  ("handle", "@usuario, esquina inferior"),
  ("size:", "sizes.instagram (default) · story · twitter · linkedin"),
  ("c1:, c2:", "colores del degradado (default primary → secondary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.2 `announce-post`]
Badge + titular + subtítulo + botón "Saber más →".
#example-canvas(```typ
#announce-post("NUEVO", [Lanzamos la 2.0], [Rediseñamos todo.], "@mi_marca")
```, opciones: (
  ("tagline, title, subtitle, handle", "posicionales, en ese orden"),
  ("size:", "default sizes.instagram"),
  ("color:", "badge + botón (default primary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.3 `tip-card`]
Tip numerado sobre fondo `dark`, con el número como marca de agua.
#example-canvas(```typ
#tip-card(3, [Publica seguido], [La constancia entrena al algoritmo.], "@mi_marca")
```, opciones: (
  ("n, title, description, handle", "posicionales"),
  ("size:", "default sizes.instagram"),
  ("color:", "número + acentos (default accent)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.4 `carousel-cover`]
Portada de carrusel con "Desliza →" y conteo de páginas.
#example-canvas(```typ
#carousel-cover("GUÍA", [5 errores que matan tu alcance], "@mi_marca", n-pages: 6)
```, opciones: (
  ("kicker, title, handle", "posicionales"),
  ("n-pages:", "cuántos puntos de paginación (default 6)"),
  ("size:", "default sizes.instagram"),
  ("c1:, c2:", "degradado (default dark → primary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.5 `carousel-slide`]
Slide interior con `progress(n/total)` integrado.
#example-canvas(```typ
#carousel-slide(2, 6, [Error #2], [No programar el contenido con anticipación.], "@mi_marca")
```, opciones: (
  ("n, total, title, body-text, handle", "posicionales — n/total alimenta la barra de progreso"),
  ("size:", "default sizes.instagram"),
  ("color:", "barra + acentos (default primary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.6 `stat-card`]
Número gigante (`stat`) centrado + `divider`.
#example-canvas(```typ
#stat-card("+240%", "más alcance", "en 3 meses de constancia", "@mi_marca")
```, opciones: (
  ("value, label, caption, handle", "posicionales"),
  ("size:", "default sizes.instagram"),
  ("color:", "número + divisor (default primary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.7 `event-post`]
Evento en formato story (1080×1920) con caja de fecha.
#example-canvas(```typ
#event-post("12", "SEPT", [Noche de alabanza], [7:00pm · Auditorio principal], "@mi_marca")
```, opciones: (
  ("day, month, title, details, handle", "posicionales"),
  ("size:", "default sizes.story (no instagram, a diferencia de las demás)"),
  ("color:", "caja de fecha + acentos (default secondary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.8 `testimonial-post`]
Testimonio con `avatar-row` (iniciales, no foto — para foto real ver `quote-social` §11.9).
#example-canvas(```typ
#testimonial-post([Cambió cómo publicamos.], "María J.", "Community Manager", "MJ", "@mi_marca")
```, opciones: (
  ("quote, name, role, initials, handle", "posicionales — initials es explícito, no se deriva de name"),
  ("size:", "default sizes.instagram"),
  ("color:", "avatar + acentos (default primary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.9 `quote-social`]
Cita con foto real o iniciales, atribución dentro de la misma tarjeta (posición declarativa), y notas laterales opcionales. Para resaltar palabras dentro de la cita usa el `#raw("#highlight[...]")` nativo de Typst, no una API propia.
#example-canvas(```typ
#quote-social(
  [La constancia entrena al algoritmo... y a tu #highlight[audiencia].],
  "Luis Felipe Reyes de los Reyes",
  iniciales: "LR",
  atribucion: "arriba",
)
```, opciones: (
  ("cita, nombre", "posicionales"),
  ("iniciales:", "fallback si no hay foto: — explícito, no se deriva de nombre"),
  ("foto:", "ruta a imagen (usa `/` inicial — relativa a la raíz del proyecto, no al archivo que llama)"),
  ("atribucion:", [`"abajo"` (default) o `"arriba"` — dónde va foto+nombre respecto a la cita]),
  ("comilla:", "muestra la comilla decorativa sobre la cita (default false)"),
  ("nota-izq:, nota-der:", "dict (icono:, texto:) o none — notas decorativas en las esquinas inferiores"),
  ("size:, color:, theme:", "como el resto de la familia"),
))

#h2[11.10 `poll-story`]
Encuesta en formato story con 2 opciones.
#example-canvas(```typ
#poll-story([¿Reels o carrusel?], [Reels 🎬], [Carrusel 📊], "@mi_marca")
```, opciones: (
  ("question, option-a, option-b, handle", "posicionales"),
  ("size:", "default sizes.story"),
  ("c1:, c2:", "degradado de fondo (default primary → secondary)"),
  ("theme:", "tema (default theme.base)"),
))

#h2[11.11 `versus-post`]
Comparación en 2 columnas ("Sin" / "Con") con `vs-badge` central.
#example-canvas(```typ
#versus-post(
  "Sin estrategia", ("Publicar al azar", "Sin identidad visual"),
  "Con sistema", ("Calendario de contenido", "Plantillas consistentes"),
  "@mi_marca",
)
```, opciones: (
  ("left-title, left-items, right-title, right-items, handle", "posicionales — *-items es un array de strings"),
  ("size:", "default sizes.instagram"),
  ("bad:, good:", "color de las marcas ✕/✓ (default rojo/verde)"),
  ("theme:", "tema (default theme.base)"),
))

#note[Todas aceptan `theme:` explícito para personalizar colores/fuentes sin sombrear `palette`/`fonts` (regla de oro, cap. 2). Ver `demo.pdf` §4 para las 11 juntas en una sola vista de catálogo.]

// ═══════════════════════════════════════════════════════════
= Blockquotes <cap-blockquotes>
#h1[12 · Blockquotes]

A diferencia de las plantillas sociales, estas *no* son un canvas: son bloques para insertar en cualquier página o dentro de un `canvas` (viven en `src/blockquotes.typ`, no en `social.typ` — ver cap. 1). Convención uniforme: `body` posicional primero, `autor:`/`fuente:` nombrados y opcionales, `color:` + `theme:` + `size:` presentes. Como no arman una página, sí caben lado a lado con su preview real (`example()`, código | render — a diferencia de las plantillas de canvas del capítulo anterior).

#h2[12.0 Control de tamaño — `size:`]

Cada función de esta familia (salvo `blockquote-grid`, que no compone texto propio, y los legos puramente gráficos `bq-frame`/`bq-rule`/`bq-rule-full`) acepta `size: auto`. `auto` conserva el tamaño de cuerpo original de esa plantilla — nada cambia si no pasas `size:`. Pasar un largo explícito fija el tamaño del elemento principal (el cuerpo de la cita, o `termino` en `blockquote-definition`) y *todo* lo demás dentro de esa misma llamada — comilla decorativa, atribución, ícono, badge — se re-escala en la misma proporción, calculada como `k = tu-tamaño / tamaño-base-de-esa-plantilla`. Es un control por-llamada: dos citas con el mismo `theme:` pueden pedir tamaños distintos sin pisarse.

#note[Antes de esta convención, cada plantilla traía sus tamaños como números pt sueltos sin relación entre sí — así se colaron los bugs de texto ilegible en `blockquote-lateral`/`bq-attribution` que motivaron el rediseño de la campaña Warfield. `size:` es la forma soportada de ajustar el tamaño desde donde se llama la plantilla, en vez de editar el pt fijo dentro de `blockquotes.typ`.]

#pagebreak(weak: true)
#h3[Demo: el mismo `blockquote-card`, dos tamaños]
Fíjate en la línea de autor: en el segundo ejemplo no se tocó, pero creció en la misma proporción que el cuerpo.
#block(breakable: false)[
  #example(```typ
  #blockquote-card([Tamaño normal.], autor: "Warfield")
  ```)
]
#v(6pt)
#block(breakable: false)[
  #example(```typ
  #blockquote-card([Tamaño normal.], autor: "Warfield", size: 44pt)
  ```)
]

#h2[12.1 Clásicos GFM]

#h3[`blockquote-editorial`]
Doble borde + comilla 60pt + itálica.
#example(```typ
#blockquote-editorial([La disciplina supera al talento cuando el talento no se disciplina.], autor: "Anónimo")
```)
#options((
  ("body", "cuerpo de la cita, posicional"),
  ("autor:, fuente:", "opcionales"),
  ("color:, theme:", "default primary / theme.base"),
  ("size:", "auto (32pt) — ver 12.0; escala también la comilla y la línea de atribución"),
))

#h3[`blockquote-bar`]
Barra izquierda de color.
#example(```typ
#blockquote-bar([La constancia entrena al algoritmo... y a tu audiencia.], autor: "Equipo de redes")
```)
#options((
  ("body", "posicional"),
  ("variante:", [`"default"` (32pt) · `"grande"` (44pt) · `"acento"`]),
  ("autor:, fuente:, color:, theme:", "como el resto de la familia"),
  ("size:", "auto — sobreescribe el tamaño que ya da `variante:`; la atribución escala con él"),
))

#h3[`blockquote-card`]
Tarjeta con barra superior de color.
#example(```typ
#blockquote-card([El diseño es la ropa que le pones a las ideas.], autor: "Anónimo", fuente: "Manual")
```)
#options((
  ("body, autor:, fuente:, color:, theme:", "misma convención uniforme"),
  ("size:", "auto (32pt) — ver 12.0"),
))

#h3[`blockquote-hero`]
Centrada, dramática — comilla 86pt.
#example(```typ
#blockquote-hero([Publica seguido. La constancia entrena al algoritmo.], autor: "Equipo de redes")
```)
#options((
  ("body, autor:, fuente:, color:, theme:", "misma convención uniforme"),
  ("size:", "auto (48pt) — escala también la comilla 86pt y la atribución"),
))

#h3[`blockquote-avatar`]
Tarjeta con `avatar-row` (#link(<cap-componentes>)[cap. 10]) si hay iniciales.
#example(```typ
#blockquote-avatar([Cambió cómo publicamos.], autor: "María J.", fuente: "Community Manager", iniciales: "MJ")
```)
#options((
  ("body", "posicional"),
  ("iniciales:", "explícito — *no* se deriva de autor (evita el bug de `cristianamente.typ:444` si autor no es texto plano)"),
  ("autor:, fuente:, color:, theme:", "como el resto de la familia"),
  ("size:", "auto (28pt) — ver 12.0"),
))

#h3[`blockquote-hand`]
Manuscrita (Caveat) — requiere `--font-path Fonts`.
#example(```typ
#blockquote-hand([Escrito a mano, para que se sienta humano.], autor: "Equipo de redes")
```)
#options((
  ("body, autor:, color:, theme:", "misma convención uniforme"),
  ("size:", "auto (40pt) — escala también la firma del autor"),
))

#h3[`blockquote-paralelo`]
Original (griego/hebreo) + traducción en 2 columnas.
#example(```typ
#blockquote-paralelo("λόγος", "Palabra / razón", idioma: "griego", referencia: "Juan 1:1")
```)
#options((
  ("original, traduccion", "posicionales"),
  ("idioma:", [`"griego"` (default) o `"hebreo"` — invierte el grid a RTL]),
  ("autentico:", "true usa GFS Didot para griego (default); false usa Libertinus Serif"),
  ("referencia:, color:, theme:", "opcionales"),
  ("size:", "auto (24pt, tamaño del texto original) — escala traducción y referencia con él"),
))

#h3[`blockquote-lateral`]
Atribución rotada 270°, numeración opcional.
#example(```typ
#blockquote-lateral([El estilo es la respuesta a la pregunta: ¿cómo?], autor: "Pascal", n: 1)
```)
#options((
  ("body", "posicional"),
  ("n:", "número opcional (esquina)"),
  ("autor:, fuente:, color:, theme:", "como el resto de la familia"),
  ("size:", "auto (32pt) — escala también la etiqueta rotada"),
))

#h3[`blockquote-grid`]
Varias `blockquote-avatar` en 2–3 columnas.
#example(```typ
#blockquote-grid(columnas: 2, (
  blockquote-avatar([Uno.], autor: "A", iniciales: "AA"),
  blockquote-avatar([Dos.], autor: "B", iniciales: "BB"),
))
```)
#options((
  ("tarjetas", "array de content (normalmente blockquote-avatar(...))"),
  ("columnas:", "2 (default) o 3"),
))
#note[`blockquote-grid` no tiene `size:` propio — no compone texto, solo acomoda tarjetas ya armadas. Pasa `size:` a cada `blockquote-avatar(...)` dentro del array si quieres ajustarlas.]

#h2[12.2 Nuevos — no-GFM]

#h3[`blockquote-pull`]
Pull-quote — comilla 180pt detrás + filete 48pt.
#example(```typ
#blockquote-pull([La tipografía es la ropa que le pones a las ideas.], autor: "Anónimo", fuente: "Manual")
```)
#options((
  ("body", "posicional"),
  ("marca:", [glifo de comilla — `none` para la variante minimal, sin marca detrás]),
  ("autor:, fuente:, color:, theme:", "como el resto de la familia"),
  ("size:", "auto (46pt) — escala también la comilla 180pt y la atribución"),
))

#h3[`blockquote-definition`]
Glosario — badge de origen + pills de términos relacionados.
#example(```typ
#blockquote-definition("Sola Scriptura", pronunciacion: "so-la skrip-tu-ra", origen: "latín", relacionados: ("Sola Fide",))[Doctrina según la cual la Escritura es la única autoridad infalible.]
```)
#options((
  ("termino, body", "posicionales — body va al final como content block"),
  ("pronunciacion:, origen:, relacionados:", "opcionales — relacionados es un array de strings"),
  ("color:, theme:", "default primary / theme.base"),
  ("size:", "auto (40pt, tamaño de `termino`) — escala pronunciación, badge, cuerpo y pills"),
))

#h3[`blockquote-callout`]
Callout con ícono + variante.
#example(```typ
#blockquote-callout(variante: "tip", titulo: "Tip", icono: "✦")[Carruseles de 6–8 slides retienen 2× más que una imagen.]
```)
#options((
  ("body", "posicional"),
  ("variante:", [`"tip"` · `"info"` · `"warn"` · `"hand"` (hand delega a Caveat — requiere `--font-path Fonts`)]),
  ("titulo:, icono:, color:, theme:", "opcionales"),
  ("size:", "auto (26pt, o 28pt en \"hand\") — escala también ícono y título"),
))

#h3[`blockquote-poetry`]
Verso — sangría colgante, sin justificar.
#example(```typ
#blockquote-poetry(autor: "Borges")[El aleph es uno de los puntos \ que contiene todos los puntos.]
```)
#options((
  ("body", "posicional — usa `\\` para saltos de verso"),
  ("autor:, color:, theme:", "opcionales"),
  ("size:", "auto (26pt) — escala también la línea de autor"),
))

#h3[`blockquote-timeline`]
Línea temporal — fecha + regla vertical.
#example(```typ
#blockquote-timeline("2024", [Se publicó la primera versión del sistema.])
```)
#options((
  ("fecha, body", "posicionales"),
  ("color:, theme:", "default primary / theme.base"),
  ("size:", "auto (22pt) — escala la fecha con el cuerpo; la regla vertical es gráfica y no cambia"),
))

#note[Para hebreo RTL, `blockquote-paralelo` invierte el `grid` cuando `idioma: "hebreo"` — el original queda a la derecha visualmente pero se escribe normal en el array.]

#h2[12.3 Legos — primitives componibles]
Cada `blockquote-*` anterior es una *receta* con los mismos 4 legos. Exponerlos permite armar brutalista/glass/editorial sin pedir `estilo:` monolítico — edificio de legos.

#h3[`bq-frame`]
El contenedor — 3 acabados.
#example(```typ
#bq-frame(tipo: "hard")[#text(weight: 900, upper[La constancia entrena al algoritmo.])]
```)
#options((
  ("body", "posicional"),
  ("tipo:", [`"soft"` (modern, radius 24pt, default) · `"hard"` (brutal, radius 0 + borde 3.5pt) · `"glass"` (degradado translúcido + borde 0.6pt)]),
  ("color:, theme:, radius:, inset:", "opcionales — radius:/inset: sobreescriben el default de cada tipo"),
))

#h3[`bq-mark`]
Comilla decorativa suelta.
#example(```typ
#bq-mark("“", size: 40pt)
```)
#options((
  ("texto", "posicional — el glifo"),
  ("size:", "default 60pt"),
  ("detras:", "true la pone grande (180pt) y semitransparente detrás, como en blockquote-pull"),
  ("fill:, theme:", "opcionales"),
))

#h3[`bq-rule` / `bq-rule-full`]
Filete corto o línea completa.
#example(```typ
#bq-rule(width: 36pt, color: red)
```)
#options((
  ("width:", "solo en bq-rule — default 48pt; bq-rule-full siempre ocupa 100%"),
  ("color:, theme:", "default primary / theme.base"),
))

#h3[`bq-attribution`]
Línea de autor/fuente, 3 modos.
#example(```typ
#bq-attribution(autor: "Mies van der Rohe", modo: "mono")
```)
#options((
  ("autor:, fuente:", "opcionales — formato \"— Autor · Fuente\""),
  ("modo:", [`"pro"` (default, — Autor · Fuente) · `"mono"` (caja DM Mono) · `"caps"` (tracking 0.12em, mayúsculas)]),
  ("color:, theme:", "opcionales"),
  ("size:", "auto — escala el modo activo como conjunto (16pt en mono/caps, 20pt en pro)"),
))

// ═══════════════════════════════════════════════════════════
= Herramientas CLI — `nueva-plantilla.py` <cap-cli>
#h1[13 · Herramientas CLI — `nueva-plantilla.py`]

Genera un `.typ` listo para editar/compilar para cualquiera de las 12 plantillas (10 de `social.typ` + `articulo` + `pasaje`) — ver `scripts/nueva-plantilla.py:36`.

```bash
python3 scripts/nueva-plantilla.py --listar
python3 scripts/nueva-plantilla.py announce-post mi-post.typ \
  --paleta terracota --tipografia editorial-clasico \
  --campo tagline=NUEVO --campo title="Mi título"

# dentro del repo → import relativo
python3 scripts/nueva-plantilla.py quote-post examples/mi-cita.typ --repo

# compilar al generar (usa Fonts/ por defecto; --fonts otra ruta)
python3 scripts/nueva-plantilla.py tip-card tip.typ --paleta bosque --compilar
```

Por defecto emite `#import "@local/instatypst:0.1.0": *` (paquete instalado); con `--repo` emite `#import "../src/lib.typ": *`.

*Casos especiales* (`scripts/nueva-plantilla.py:155`): `articulo` usa `#show: articulo.with(...)` con `paleta:`/`tipografia:` directos; `pasaje` usa `#pasaje("Ref", version: ..., paleta:, tipografia:)[...]` — ninguno usa `theme:` porque arman el tema internamente vía `make-theme()`.

#pagebreak()

// ═══════════════════════════════════════════════════════════
= Apéndice A — Referencia rápida de `lib.typ` <cap-api>
#h1[Apéndice A — Referencia rápida de `lib.typ`]

`src/lib.typ:27` re-exporta:

#table(columns: (1.9fr, 3fr), stroke: 0.5pt + luma(85%), inset: 6pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Export*], [*Origen*],
  [`theme`], [`theme.typ` — namespace con `base`, `define`, `with`, `with-color`, `with-font`, `named`, `color`, `font`, `colors`, `fonts`, `lighten`/`darken`/`fade`, `luminance`/`contrast`/`is-aa`/`is-aaa`/`readable-on`, `export`/`load`],
  [`palettes`], [`palettes.typ` — `tokens`/`token`, `library`, `names`, `get`, `mix`, `auto-roles`, `as-theme`, `as-theme-manual`, `swatch`, `card`, `catalog`, `luminance`, `saturation`],
  [`pairings`], [`font-pairings.typ` — `names`, `get`, `resolve`, `as-theme`, `catalog`, `card`, `swatch` (paralelo a palettes)],
  [`color-tokens` / `font-tokens`], [`tokens.typ` / `font-tokens.typ` — `tokens` dict + `token(key)`/`family(key)` namespaced para no chocar],
  [`capitular`], [`dropcaps.typ` — `capitular(body, letra:, alto:, hueco:, sangria:, profundidad:, justificar:, transformar:, ..text-args)`],
  [`articulo, primer-parrafo, make-theme, fondo-editorial`], [`articulo.typ`],
  [`scripture, vs, ch, pasaje`], [`scripture.typ`],
  [`lat, gr, he, translit, interlineal`], [`idiomas.typ`],
  [`canvas, bg, gradient-bg, blob, sizes, page-pad, radius, palette, fonts, badge, headline, subhead, footer, avatar, avatar-row, stat, progress, divider, quote-post, announce-post, tip-card, carousel-cover, carousel-slide, stat-card, event-post, testimonial-post, quote-social, poll-story, versus-post, vs-badge`], [`social.typ`],
  [`bq-frame, bq-mark, bq-rule, bq-rule-full, bq-attribution, blockquote-*`], [`blockquotes.typ` — depende de `social.typ` (`radius`, `avatar-row`, `palette`) en una sola dirección],
)

#note[`cristianamente.typ` *no* forma parte del paquete (`typst.toml:13` lo excluye). Se conserva como referencia/legado — ver #link(<cap-migracion>)[Apéndice B].]

// ═══════════════════════════════════════════════════════════
= Apéndice B — Migración desde `cristianamente.typ` <cap-migracion>
#h1[Apéndice B — Migración desde `cristianamente.typ`]

`cristianamente.typ:1` es el paquete previo (tema "Paper" de cristianamente.xyz, con `color`, `font`, `radius`, `articulo`, `cita-*`, `escritura`, `definicion`, etc.). Se conserva sin integrar. Si vienes de ahí:

#table(columns: (2fr, 2fr, 2fr), stroke: 0.5pt + luma(85%), inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Antes (`cristianamente.typ`)*], [*Ahora (`src/lib.typ`)*], [*Notas*],
  [`color` / `color-dark`], [`theme.base.colors` / `palettes.as-theme`], [`auto-roles` elige roles; `white` siempre blanco],
  [`font.display/serif/sans/mono/hand1`], [`theme.base.fonts` + `font-tokens.family` + `pairings`], [8 parejas curadas; `mono` no es Iosevka sino `font-tokens` verificado],
  [`articulo(...)` Paper], [`articulo` + `make-theme(paleta:, tipografia:)` + `fondo-editorial`], [Ahora `state("articulo-tema")` en vez de `let` local],
  [`cita-editorial` / `cita-bloque` / `cita-tarjeta` / `cita-heroica` / `cita-manuscrita`], [`blockquote-editorial` / `blockquote-bar` / `blockquote-card` / `blockquote-hero` / `blockquote-hand`], [Convención unificada `body` primero + `autor:`/`fuente:` + `theme:`; `blockquote-avatar` pide `iniciales:` explícito],
  [`escritura` / `ScriptureBlock`], [`scripture` / `pasaje` + `vs` + `ch`], [`pasaje` usa `capitular` para v1, no número],
  [`definicion` / `ver-tambien` / `grid-citas`], [— (sin puerto directo)], [Patrones de sitio sin equivalente de canvas; recreables con `block`+`grid`+`theme`],
)

#note[No hay *compat* automático. La forma más rápida de migrar un doc: genera un esqueleto con `scripts/nueva-plantilla.py:13` para la plantilla que te corresponde y copia el contenido. Para artículos largos, usa `articulo` + `primer-parrafo` + `blockquote-*` en lugar de `cita-*`.]


// ── Cierre ──
#v(24pt)
#align(center)[
  #text(font: theme.base.fonts.display, size: 11pt, weight: 800, fill: primary)[Fin del manual]
  #v(4pt)
  #text(size: 8pt, fill: faint)[InstaTypst · `src/lib.typ` · `demo.pdf` para el catálogo visual completo · `examples/` para 12 recetas mínimas]
  #v(6pt)
  #text(size: 7.5pt, fill: gray)[`#import "@local/instatypst:0.1.0": *` · `typst compile --root . --font-path Fonts docs/manual.typ docs/manual.pdf`]
]
