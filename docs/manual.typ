#import "../src/lib.typ": *
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
  social.typ             # canvas + componentes + 10 plantillas + 9 blockquotes
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
#note[Para un versículo completo en dos columnas (original + traducción) usa `blockquote-paralelo` (#link(<cap-blockquotes>)[cap. 10.2]).]

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

Todas devuelven un `canvas` listo para exportar a PNG/PDF. El parámetro `theme:` se propaga internamente a `badge`/`headline`/etc. por closure (ver nota de `social.typ:14`).

#api-table((
  ([`quote-post(quote, author, handle, size:, c1:, c2:, theme:)`], [Cita centrada sobre degradado + blobs], [`#quote-post([Cita], "Autor", "@h")`]),
  ([`announce-post(tagline, title, subtitle, handle, theme:)`], [Badge + titular + botón "Saber más →"], [`#announce-post("NUEVO", [T], [S], "@h")`]),
  ([`tip-card(n, title, description, handle, theme:)`], [Tip numerado sobre `dark` + número marca de agua], [`#tip-card(3, [T], [D], "@h")`]),
  ([`carousel-cover(kicker, title, handle, n-pages:, theme:)`], [Portada carrusel "Desliza →"], [`#carousel-cover("GUÍA", [T], "@h", n-pages: 6)`]),
  ([`carousel-slide(n, total, title, body-text, handle, theme:)`], [Slide interior con `progress(n/total)`], [`#carousel-slide(2, 6, [T], [B], "@h")`]),
  ([`stat-card(value, label, caption, handle, theme:)`], [`stat` centrado + `divider`], [`#stat-card("+240%", [L], [C], "@h")`]),
  ([`event-post(day, month, title, details, handle, theme:)`], [Evento story (1080×1920) — caja fecha], [`#event-post("12", "SEPT", [T], [D], "@h")`]),
  ([`testimonial-post(quote, name, role, initials, handle, theme:)`], [Testimonio + `avatar-row`], [`#testimonial-post([Q], "M", "CM", "MJ", "@h")`]),
  ([`poll-story(question, a, b, handle, theme:)`], [Encuesta story — 2 opciones], [`#poll-story([¿Qué?], [A], [B], "@h")`]),
  ([`versus-post(l-title, l-items, r-title, r-items, handle, theme:)`], [Comparación 2 columnas + badge VS], [`#versus-post("Sin", (...), "Con", (...), "@h")`]),
))

#note[Ver `demo.pdf` §4 para cada plantilla a tamaño real (1080×1080 o 1080×1920 con `vs-badge` en `versus-post`). Dentro de este manual caben solo las tablas; el render a escala completa rompería la paginación A4.]

```typ
#let marca = (palettes.as-theme)("terracota")
#quote-post([El diseño no es cómo se ve. Es cómo funciona.], "Steve Jobs", "@mi_marca", theme: marca)
#announce-post("NUEVO", [Lanzamos la 2.0], [Rediseñamos todo.], "@mi_marca", theme: marca)
#versus-post("Sin estrategia", ([Azar], [Sin identidad]), "Con sistema", ([Calendario], [Plantillas]), "@mi_marca", theme: marca)
```

// ═══════════════════════════════════════════════════════════
= Blockquotes <cap-blockquotes>
#h1[12 · Blockquotes]

A diferencia de las plantillas sociales, estas *no* son un canvas: son bloques para insertar en cualquier página o dentro de un `canvas` (`src/social.typ:549`). Convención uniforme: `body` posicional primero, `autor:`/`fuente:` nombrados y opcionales, `color:` + `theme:` presentes.

#h2[12.1 Catálogo — 9 clásicos GFM + 5 nuevos con finetuning]
#api-table((
  ([`blockquote-editorial(body, autor:, fuente:)`], [Doble borde + comilla 60pt + itálica], [Demo 1/9]),
  ([`blockquote-bar(body, variante:)`], [Barra izquierda; `variante`: default/grande/acento], [Demo 2–4/9]),
  ([`blockquote-card(body, autor:, fuente:)`], [Tarjeta con barra superior de color], [Demo 5/9]),
  ([`blockquote-hero(body, autor:, fuente:)`], [Centrada dramática, comilla 86pt], [Demo 6/9, sobre gradiente]),
  ([`blockquote-avatar(body, autor:, fuente:, iniciales:)`], [Tarjeta con `avatar-row` si hay iniciales], [Demo 7/9 + grid]),
  ([`blockquote-hand(body, autor:)`], [Manuscrita Caveat — requiere `--font-path Fonts`], [Demo 8/9]),
  ([`blockquote-paralelo(orig, trad, idioma:, referencia:)`], [Griego/hebreo + traducción en 2 cols], [Demo 9a/b/9]),
  ([`blockquote-lateral(body, n:, autor:, fuente:)`], [Cita con atribución rotada 270° + numeración], [Demo 10/9]),
  ([`blockquote-grid(tarjetas, columnas:)`], [Grid de `blockquote-avatar` en 2–3 cols], [Demo 7/9]),
))
#h3[Nuevos — no-GFM]
#api-table((
  ([`blockquote-pull(body, autor:, fuente:, marca:)`], [Pull-quote — comilla 180pt detrás + filete 48pt; `marca: none` minimal], [Demo 11–12/14]),
  ([`blockquote-definition(termino, body, pronunciacion:, origen:, relacionados:)`], [Glosario — badge origen + pills relacionados], [Demo 13/14]),
  ([`blockquote-callout(body, titulo:, icono:, variante:)`], [Callout — `variante: tip/info/warn/hand` (hand = Caveat)], [Demo 14a/14]),
  ([`blockquote-poetry(body, autor:)`], [Verso — sangría colgante, sin justificar], [Demo 14b/14]),
  ([`blockquote-timeline(fecha, body)`], [Línea temporal — fecha + regla vertical], [Demo 14b/14]),
))

#h3[Ejemplos compactos (dentro de A4)]
#blockquote-bar([La constancia entrena al algoritmo... y a tu audiencia.], autor: "Equipo de redes", color: palette.secondary)
#blockquote-callout(variante: "tip", titulo: "Tip", icono: "✦")[Carruseles de 6–8 slides retienen 2× más que una imagen.]
#blockquote-definition("Sola Scriptura", pronunciacion: "so-la skrip-tu-ra", origen: "latín", relacionados: ("Sola Fide",), color: palette.primary)[Doctrina según la cual la Escritura es la única autoridad infalible.]
#blockquote-pull([La tipografía es la ropa que le pones a las ideas.], autor: "Anónimo", fuente: "Manual", color: palette.secondary)
#blockquote-poetry(autor: "Borges", color: palette.primary)[El aleph es uno de los puntos \ que contiene todos los puntos.]

#note[Para hebreo RTL, `blockquote-paralelo` invierte el `grid` cuando `idioma: "hebreo"` — el original queda a la derecha visualmente pero se escribe normal en el array. `blockquote-avatar` requiere `iniciales:` explícito para no romper si `autor` no es texto plano (bug corregido de `cristianamente.typ:444`). `blockquote-callout` con `variante: "hand"` delega el cuerpo a Caveat (requiere `--font-path Fonts`).]

#h2[12.2 Legos — primitives componibles]
Cada `blockquote-*` anterior es una *receta* con los mismos 4 legos. Exponerlos permite armar brutalista/glass/editorial sin pedir `estilo:` monolítico — edificio de legos.

#api-table((
  ([`bq-frame(body, tipo:)`], [`tipo: "soft" (modern, radius 24pt) / "hard" (brutal, radius 0 + borde 3.5pt black) / "glass" (gradient translúcido + borde 0.6pt)`], [`#bq-frame(tipo: "hard")[...]`]),
  ([`bq-mark(texto, detras:)`], [Comilla suelta; `detras: true` la pone 180pt detrás como en `blockquote-pull`], [`#bq-mark("“", detras: true)`]),
  ([`bq-rule(width:, color:)` / `bq-rule-full`], [Filete corto (default 48pt) o línea 100%], [`#bq-rule(width: 36pt)`]),
  ([`bq-attribution(autor:, fuente:, modo:)`], [`modo: "pro" (— Autor · Fuente) / "mono" (DM Mono caja) / "caps" (tracking 0.12em)`], [`#bq-attribution(autor: "Mies", modo: "mono")`]),
))

```typ
// Card modern (soft) vs brutal (hard) vs glass — mismo contenido
#bq-frame(tipo: "soft")[... #bq-rule() #bq-attribution(autor: "Mies", modo: "pro")]
#bq-frame(tipo: "hard")[#text(upper[...]) #bq-rule(color: red) #bq-attribution(autor: "Mies", modo: "mono")]
#bq-frame(tipo: "glass", color: palette.primary)[... #bq-attribution(modo: "caps")]

// Pull con marca detrás + composición libre callout
#bq-mark("“", detras: true) + #bq-rule(width: 36pt)
#bq-frame(tipo: "hard", inset: 16pt)[#grid(columns: (auto, 1fr), gutter: 12pt, text("⚠"), [#text(upper[Warn]) #body])]
```

#h3[Ejemplos compactos — legos]
#bq-frame(tipo: "soft", inset: 10pt)[
  #text(style: "italic", size: 9pt)[La constancia entrena al algoritmo.] #v(4pt) #bq-rule(width: 24pt) #v(4pt) #bq-attribution(autor: "Equipo de redes", modo: "pro")
]
#bq-frame(tipo: "hard", inset: 10pt)[
  #text(weight: 900, size: 9pt, upper[La constancia entrena al algoritmo.]) #v(4pt) #bq-rule(color: rgb("#ff3b30"), width: 24pt) #v(4pt) #bq-attribution(autor: "Equipo de redes", modo: "mono")
]
#bq-frame(tipo: "glass", color: palette.primary, inset: 10pt)[
  #text(style: "italic", size: 9pt)[La constancia entrena al algoritmo.] #v(4pt) #bq-attribution(autor: "Equipo de redes", modo: "caps", color: palette.primary)
]
#v(4pt)
#bq-mark("“", fill: palette.secondary.transparentize(65%), detras: true)
#pad(x: 10pt)[#text(font: theme.base.fonts.display, weight: 800, size: 11pt)[La tipografía es la ropa de las ideas.] #v(4pt) #bq-rule(width: 24pt) #v(4pt) #bq-attribution(autor: "Anónimo", fuente: "Manual", modo: "pro")]

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
  [`canvas, bg, gradient-bg, blob, sizes, page-pad, radius, palette, fonts, badge, headline, subhead, footer, avatar, avatar-row, stat, progress, divider, quote-post, announce-post, tip-card, carousel-cover, carousel-slide, stat-card, event-post, testimonial-post, poll-story, versus-post, vs-badge, blockquote-*`], [`social.typ`],
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
