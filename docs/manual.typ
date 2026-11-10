#import "../src/lib.typ": *
#import "../src/lib.typ" as lib
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, number-format: none, display-name: false, display-icon: false, zebra-fill: none, inset: 5pt, stroke: 0.5pt + luma(85%), fill: luma(97%))

// ─────────────────────────────────────────────────────────────
// docs/manual.typ — Manual de InstaTypst
// Compilar: typst compile --root . --font-path Fonts docs/manual.typ docs/manual.pdf
//
// Todo cabe en la hoja A4. Las láminas (que por dentro son `page(...)`) se
// muestran con `en-caja`, que las escala y las recorta como bloques; el
// código que se ve en cada ejemplo es el que se evalúa, sin copias.
// ─────────────────────────────────────────────────────────────

// ── Estilo ──
#let primary = theme.base.colors.primary
#let accent = theme.base.colors.accent
#let muted = luma(45%)
#let faint = luma(62%)
#let borde = 0.5pt + luma(85%)

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
  stroke: borde, inset: 5pt,
  fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Función*], [*Qué hace*], [*Ejemplo*],
  ..rows.flatten(),
)

// Lista de parámetros: items = ((nombre, descripción), …). La descripción es
// markup, así que admite `código` en línea.
#let opciones(items) = list(
  ..items.map(it => [#raw(it.at(0)) — #eval(it.at(1), mode: "markup")]),
)

// ── Ejemplos ──
// `dictionary(lib)` convierte TODO lo exportado por lib.typ en el `scope` de
// eval: el código que se ve es literalmente el que se ejecuta.
#let escope = dictionary(lib)
#let evaluar(codigo) = eval(codigo, mode: "markup", scope: escope)

#let codigo-bloque(codigo, tam: 8pt) = {
  set text(size: tam)
  raw(codigo, lang: "typ", block: true)
}

// Contenido pequeño (componentes, texto): código | resultado, lado a lado.
#let ejemplo(codigo) = grid(
  columns: (1fr, 1fr), gutter: 10pt, align: (left + horizon, center + horizon),
  codigo-bloque(codigo),
  block(width: 100%, fill: white, stroke: borde, radius: 5pt, inset: 9pt, {
    set par(justify: false)
    evaluar(codigo)
  }),
)

// Lámina: por dentro es `page(...)`. `w` es su ancho natural en pt y `ancho`
// el que ocupa en la hoja; `en-caja` la escala y la recorta.
#let lamina(codigo, w: 1080, ancho: 150pt) = box(
  stroke: borde, radius: 2pt, clip: true,
  en-caja(ancho / (w * 1pt), evaluar(codigo)),
)

// Código y lámina lado a lado, con la lista de parámetros debajo.
#let demo(codigo, w: 1080, ancho: 165pt, opts: none, apilar: false) = {
  block(breakable: false, if apilar {
    codigo-bloque(codigo)
    v(4pt)
    align(center, lamina(codigo, w: w, ancho: ancho))
  } else {
    grid(columns: (1fr, ancho), gutter: 12pt, align: (left + horizon, center + horizon),
      codigo-bloque(codigo), lamina(codigo, w: w, ancho: ancho))
  })
  if opts != none { v(3pt); opciones(opts) }
}

// Galería: `items` = (titulo, codigo, w). Una celda por pieza, `cols` columnas.
#let galeria(items, cols: 3, ancho: 130pt) = grid(
  columns: (1fr,) * cols, gutter: 10pt, row-gutter: 12pt,
  ..items.map(it => block(breakable: false, {
    text(size: 8pt, weight: 700, fill: primary, raw(it.at(0)))
    v(2pt)
    lamina(it.at(1), w: if it.len() > 2 { it.at(2) } else { 1080 }, ancho: ancho)
    v(3pt)
    codigo-bloque(it.at(1), tam: 6.5pt)
  })),
)

// Cita (blockquote-*): contenido de ancho de lienzo (700 pt) reducido al
// ancho de su celda. `alto` fija la altura de las piezas que llenan el alto
// disponible (p. ej. `bq-frame`).
#let cita(codigo, alto: auto) = block(breakable: false, {
  codigo-bloque(codigo, tam: 6.5pt)
  v(3pt)
  block(width: 100%, fill: theme.base.colors.light, radius: 5pt, stroke: borde, clip: true, inset: 4pt,
    layout(sz => {
      let k = sz.width / 700pt
      scale(x: k * 100%, y: k * 100%, reflow: true, origin: top + left,
        block(width: 700pt, height: alto, inset: 10pt, evaluar(codigo)))
    }))
})

#show heading.where(level: 1): it => {
  v(18pt)
  text(font: theme.base.fonts.display, size: 18pt, weight: 800, fill: primary, {
    if it.numbering != none { counter(heading).display(it.numbering); h(0.3em) }
    it.body
  })
  v(4pt)
  line(length: 100%, stroke: 0.7pt + luma(82%))
  v(6pt)
}
#set page(paper: "a4", margin: 2cm, fill: rgb("#fdfbf7"))
#set text(font: theme.base.fonts.body, size: 10pt, fill: theme.base.colors.dark, lang: "es")
#set par(justify: true, leading: 0.78em, spacing: 1em)
#set heading(numbering: "1 ·")
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
  #text(size: 9pt, fill: faint)[Temas · Tipografía · Texto y escritura · Plantillas sociales · Citas · Carteles · Orlas · Curvas]
  #v(24pt)
  #text(size: 8pt, fill: muted)[`demo.pdf` es el catálogo visual (lo que *se ve*); este manual es la guía (cómo *se usa*).]
  #v(14pt)
  #text(size: 7.5pt, fill: faint)[`#import "@local/instatypst:0.1.0": *` · dentro del repo: `#import "src/lib.typ": *`]
]
#pagebreak()

// ── ÍNDICE ──
#text(font: theme.base.fonts.display, size: 20pt, weight: 800, fill: primary)[Índice]
#v(8pt)
#outline(title: none, indent: 1.2em, depth: 2)
#v(8pt)
#note[
  *Cómo leer este manual.* Cada capítulo abre con lo que hace, sigue con una tabla de la API y un ejemplo que se ve y se copia. Si solo buscas la lista de exports, ve al #link(<cap-api>)[Apéndice A]; si vienes de `cristianamente.typ`, al #link(<cap-migracion>)[Apéndice B].
]
#pagebreak()

// ═══════════════════════════════════════════════════════════
= Instalación y estructura <cap-instalacion>

#h2[1.1 Dos formas de importar]
#grid(columns: (1fr, 1fr), gutter: 12pt,
  block(fill: white, stroke: borde, radius: 8pt, inset: 11pt)[
    #text(size: 8pt, weight: 700)[Dentro del repo]
    #v(3pt)
    #text(size: 7.5pt, fill: muted)[Los `examples/` y `trabajos/` usan este modo; compilan con `--root .` porque importan hacia arriba.]
    #v(3pt)
    ```typ
    #import "src/lib.typ": *
    ```
  ],
  block(fill: white, stroke: borde, radius: 8pt, inset: 11pt)[
    #text(size: 8pt, weight: 700)[Como paquete local]
    #v(3pt)
    #text(size: 7.5pt, fill: muted)[`src/` y `typst.toml` enlazados en `~/.local/share/typst/packages/local/instatypst/0.1.0/` (ver `README.md`).]
    #v(3pt)
    ```typ
    #import "@local/instatypst:0.1.0": *
    ```
  ],
)

#h2[1.2 Fuentes y compilación]
El paquete *no empaqueta* fuentes: viven en `Fonts/` del repo y se pasan con `--font-path` o con la variable `TYPST_FONT_PATHS`.

```bash
export TYPST_FONT_PATHS="$PWD/Fonts"
typst compile --root . docs/manual.typ docs/manual.pdf
typst compile pieza.typ pieza.png --ppi 72      # Instagram: 1080 pt → 1080 px
typst compile pieza.typ "salida/p-{p}.png" --ppi 72   # varias páginas: {p}
```

#note[
  *Una sola página por pieza.* Con una única ruta de salida y más de una página, Typst falla con `cannot export multiple images without a page number template`. En una pieza de una página, ese error significa que el texto se desbordó. Tras el error, el PNG anterior sigue en disco sin cambios.
]

#h2[1.3 Formatos de Instagram]
#table(columns: (1.2fr, 1fr, 2.6fr), stroke: borde, inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Destino*], [*Formato*], [*Nota*],
  [Post de feed], [1080×1350 (4:5)], [El más usado. `sizes` no lo trae: pasa `formato: (1080, 1350)`.],
  [Post cuadrado], [1080×1080 (1:1)], [`sizes.instagram`.],
  [Stories y Reels], [1080×1920 (9:16)], [`sizes.story`. No se sube al feed.],
)

#h2[1.4 Estructura del paquete]
```typ
src/lib.typ          # entrypoint: re-exporta todo
  theme, tokens, palettes, contrast        # color y legibilidad
  font-tokens, font-pairings               # tipografía
  dropcaps, articulo, scripture, idiomas   # texto
  social, carrusel, blockquotes, formas    # plantillas, citas y formas
  carteles, orlas, escalera, gozne, folio,
  esquela, linea-tiempo, plano             # carteles (namespace `carteles`)
  fleurones, curvas, superbg/              # ornamentos y fondos
  pliego                                   # `page` que cabe en un documento
examples/            # recetas mínimas; examples/presets/ una por preset
scripts/             # nueva-plantilla.py
docs/manual.typ      # este manual · demo.typ: catálogo visual
```

#note[
  *Regla de oro.* Toda función que depende de color o tipografía acepta `theme:` explícito (por defecto `theme.base`). Reasignar `palette` o `fonts` después de importar *se ignora en silencio*, porque las plantillas los resuelven por cierre al definirse. Solo `theme:` propaga de verdad (cap. 2).
]

// ═══════════════════════════════════════════════════════════
= Temas — `theme` <cap-temas>

Un tema es un valor inmutable `(name, colors, fonts)`. Paletas, parejas tipográficas, artículo y plantillas derivan de él. `theme.base` trae indigo, rosa y ámbar con Poppins e Inter.

#h2[2.1 Crear y derivar]
#api-table((
  ([`theme.define(name, colors:, fonts:)`], [Crea desde el base, fusionando lo que pases], [`theme.define("m", colors: (primary: rgb("#0EA5E9")))`]),
  ([`theme.with(t, colors:, fonts:)`], [Fusiona varios cambios], [`theme.with(m, colors: (accent: orange))`]),
  ([`theme.with-color(t, key, val)`], [Cambia un color], [`theme.with-color(m, "primary", blue)`]),
  ([`theme.with-font(t, kind, fam)`], [Cambia display o body; `fam` puede ser array], [`theme.with-font(m, "display", "Fraunces")`]),
  ([`theme.named(t, name)`], [Renombra], [`theme.named(m, "marca-v2")`]),
  ([`theme.validate(t)`], [Falla si falta un color o fuente requerido; devuelve `t`], [`theme.validate(m)`]),
))

```typ
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
#announce-post("NUEVO", [Título], [Subtítulo], "@handle", theme: marca)
```

#h2[2.2 Leer valores]
#api-table((
  ([`theme.color(key, t:)`, `theme.font(kind, t:)`], [Acceso; falla si no existe], [`theme.color("primary", marca)`]),
  ([`theme.colors(t)`, `theme.fonts(t)`], [Diccionarios completos], [`for (k, v) in theme.colors(m) { … }`]),
  ([`theme.lighten`, `darken`, `fade`], [Aclarar, oscurecer o hacer transparente un token], [`theme.lighten("primary", 20%, m)`]),
  ([`theme.export(t, ruta)`, `theme.load(ruta)`], [Guardar y cargar un tema como JSON], [`theme.export(m, "marca.json")`]),
))

// ═══════════════════════════════════════════════════════════
= Color — tokens, paletas y contraste <cap-paletas>

#h2[3.1 Tokens]
`color-tokens` reúne 81 colores con nombre semántico (no `familia-NNN`), compartidos por `theme.base` y `palettes`. Se importan con espacio de nombres para no chocar con `font-tokens`.

```typ
#color-tokens.token("denim")        // un color
#color-tokens.tokens.len()          // 81
```

#h2[3.2 Paletas]
15 paletas curadas, cada una una lista de tokens: `noche-azul`, `neon`, `retro`, `oceano`, `granates`, `terracota`, `web-suave`, `vintage`, `arcoiris-pastel`, `marino`, `mediterraneo`, `otono`, `bosque`, `grises` y `algodon`.

#api-table((
  ([`palettes.names()`, `.library`], [Lista de nombres y diccionario completo], [`(palettes.names)()`]),
  ([`palettes.get(name)`], [Array de colores resueltos], [`(palettes.get)("neon")`]),
  ([`palettes.mix(..items)`], [Paleta ad-hoc con tokens y colores sueltos], [`(palettes.mix)("denim", rgb("#123"))`]),
  ([`palettes.as-theme(name)`], [Convierte la paleta en un tema], [`(palettes.as-theme)("terracota")`]),
  ([`palettes.auto-roles(cols)`], [Reparte primary, secondary, accent, dark, light y white], [`(palettes.auto-roles)(colores)`]),
  ([`palettes.swatch`, `.card`, `.catalog`], [Vistas para documentación], [`(palettes.swatch)("neon")`]),
))

#note[
  `palettes.get` y `palettes.names` son funciones guardadas en un diccionario. Llamadas solas funcionan; para *encadenar métodos* hay que envolverlas: `(palettes.get)("granates").at(0)`. Sin paréntesis falla con `cannot directly call dictionary keys`.
]

*Cómo decide `auto-roles`:* `dark` es el color más oscuro y `light` el más claro (por luminancia); los intermedios se ordenan por saturación y dan `primary`, `secondary` y `accent`. En paletas monocromáticas como `granates`, `light` sigue siendo un rojo saturado y no es un neutro.

#h2[3.3 Contraste y legibilidad (WCAG 2.x)]
Vive en `src/contrast.typ`. Blanco sobre negro da 21:1; el mínimo para texto normal es *4,5:1* (AA) y lo ideal 7:1 (AAA).

#api-table((
  ([`luminance(c)`], [Luminancia relativa, 0 a 1], [`luminance(white)`]),
  ([`contrast(a, b)`], [Razón de contraste, 1 a 21], [`contrast(black, white)`]),
  ([`is-aa(a, b)`, `is-aaa(a, b)`], [¿Cumple 4,5:1 / 7:1?], [`is-aa(marca.colors.primary, white)`]),
  ([`readable-on(bg, ..cands)`], [El candidato con mejor contraste sobre `bg`], [`readable-on(bg, white, black)`]),
  ([`auto-pair(bg, candidates:)`], [`(bg:, fg:)` con la tinta más contrastada; con blanco y negro siempre alcanza AA], [`auto-pair(rgb("#691322"))`]),
  ([`auto-pair-tinted(bg, extra:)`], [Igual, con candidatos propios (un crema, un tono del mismo matiz)], [`auto-pair-tinted(bg, extra: (crema,))`]),
))

Para cualquier fondo sRGB, el mejor de blanco y negro da al menos ≈4,58:1, por eso `auto-pair` garantiza AA. Los rojos de `granates` son oscuros-medios: con texto casi negro dan entre 1,6 y 4,1:1. Sobre fondo rojo usa texto crema sobre `wine` (≈10:1) o un rojo claro como `#ff6a4d` (≈7:1) con texto casi negro.

// ═══════════════════════════════════════════════════════════
= Tipografía — tokens y parejas <cap-tipografia>

#h2[4.1 `font-tokens`]
Más de 49 fuentes verificadas compilando. `font-tokens.family("eb-garamond")` devuelve el nombre real para `text(font: …)`.

```typ
#font-tokens.family("eb-garamond")             // "EB Garamond"
#(font-tokens.by-category)("display")          // claves: display, body, mono, hand, ornament
```

La tabla `by-script` documenta qué familias cubren latín, griego y hebreo (la usa `idiomas`).

#note[
  Antes de usar una familia, comprueba su nombre con `typst fonts`: los nombres visibles difieren de los de archivo (`"EB Garamond 12"`, `"EB Garamond 12 All SC"`, `"IM FELL English"`). Un nombre mal escrito puede caer a otra fuente sin avisar.
]

#h2[4.2 `pairings`]
8 parejas curadas, con el mismo patrón que `palettes`: `editorial-clasico`, `editorial-expresivo`, `revival-vintage`, `moderno-suave`, entre otras.

```typ
#pairings.names()                                  // 8
#let t = pairings.as-theme("revival-vintage")       // tema solo con fonts
#let t = make-theme(paleta: "terracota", tipografia: "editorial-clasico")   // color + tipografía
```

#h2[4.3 Ejes variables — `variations:`]
`badge`, `headline` y `subhead` aceptan `variations:` (ejes OpenType). Solo tiene efecto con fuentes variables auténticas: `Bricolage Grotesque` estático lo ignora en silencio; el archivo variable se registra como `Bricolage Grotesque 96pt`.

```typ
#let editorial = theme.define("editorial", fonts: (display: "Fraunces", body: "Bricolage Grotesque 96pt"))
#headline([Con carácter], variations: (wght: 900, opsz: 144, WONK: 1), theme: editorial)
```

// ═══════════════════════════════════════════════════════════
= Capitulares <cap-capitulares>

#h2[5.1 `capitular`]
Letra capital automática: mide el alto real del texto y dimensiona la inicial en proporción.

```typ
#capitular[En un lugar de la Mancha, de cuyo nombre no quiero acordarme…]
#capitular(font: font-tokens.family("eb-garamond"), alto: 3, fill: rgb("#2c2c2c"))[En un lugar…]
#capitular(transformar: smallcaps)[En un lugar…]
```

`alto` (líneas o longitud, 2), `hueco`, `sangria`, `profundidad`, `justificar: auto`, `transformar: none` y `letra: none` (fuerza la inicial).

#block(stroke: borde, radius: 6pt, inset: 10pt, fill: white, {
  set text(size: 9pt)
  capitular(font: (font-tokens.family)("eb-garamond"), alto: 3, fill: rgb("#2c2c2c"))[En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha mucho tiempo que vivía un hidalgo de los de lanza en astillero, adarga antigua, rocín flaco y galgo corredor.]
})

#h2[5.2 `capitular-ornamentada`]
Capitulares iluminadas con las iniciales EB Garamond (dos capas: trazo y ornamento).

```typ
#capitular-ornamentada(alto: 3, estilo: "rubricada", desgaste: 0.3)[En el principio creó Dios los cielos y la tierra.]
#inicial-ornamentada("E", size: 120pt, estilo: "invertida")   // solo la letra
```

#opciones((
  ("estilo:", "`\"una-tinta\"` (default), `\"invertida\"`, `\"rubricada\"` o `\"tema\"`"),
  ("alto:, hueco:", "alto en líneas o longitud (3) y aire junto a la letra (0,3em)"),
  ("marco:", "`true` dibuja el doble filete alrededor de la letra"),
  ("desgaste:", "0 a 1: tinta gastada"),
  ("tinta:, fill:, ornamento:", "colores de la letra y del ornamento; si faltan, salen del estilo"),
))

// ═══════════════════════════════════════════════════════════
= Artículo y escritura <cap-editorial>

#h2[6.1 `articulo`]
Junta paleta, pareja tipográfica y capitular en un solo tema. El tema activo viaja por un `state`, así que `primer-parrafo` lo lee aunque esté fuera del alcance léxico de `articulo()`.

```typ
#show: articulo.with(titulo: "Los tiempos hipermodernos", categoria: "Ensayo",
  autor: "Sébastien Charles", fecha: "2026", paleta: "terracota",
  tipografia: "editorial-clasico", paper: "a5")
#primer-parrafo[Este optimismo, que caracteriza a la filosofía de las Luces, …]
```

`make-theme(paleta:, tipografia:)` arma el tema y `fondo-editorial(t)` elige `light` si pasa AA, o `white` si no (el caso de `granates`). Plantilla A5 completa en `examples/articulo.typ`.

#h2[6.2 `pasaje` y `scripture`]
Versículos con capitular para el primero y superíndices para los siguientes.

#api-table((
  ([`scripture[…]`], [Contenedor neutro], [`scripture[#ch[1] En el principio… #vs[2] Y la tierra…]`]),
  ([`ch[1]`], [Número de capítulo grande], [`ch[1]`]),
  ([`vs[2]`], [Número de versículo en superíndice], [`vs[2]`]),
  ([`pasaje(ref, version:, paleta:, tipografia:, capitular-alto:)`], [Receta completa: tema + fondo + capitular], [`pasaje("Salmo 1", version: "RVR1960")[…]`]),
  ([`set-body-font`], [`show:` que fija el cuerpo a Inter], [`#show: set-body-font`]),
))

#pasaje("Salmo 1", version: "RVR1960", paleta: "granates", tipografia: "revival-vintage")[
  Bienaventurado el varón que no anduvo en consejo de malos, ni estuvo en camino de pecadores, ni en silla de escarnecedores se ha sentado,
  #vs[2] sino que en la ley de Jehová está su delicia, y en su ley medita de día y de noche.
]

// ═══════════════════════════════════════════════════════════
= Idiomas — `lat`, `gr`, `he`, `interlineal` <cap-idiomas>

Cada función usa la fuente verificada para su guion: latín en EB Garamond cursiva; griego en GFS Didot (`autentico: true`) o Libertinus Serif; hebreo en Libertinus Serif, la única con niqqud.

#api-table((
  ([`lat[…]`], [Latín, `lang: "la"`], [`lat[creatio ex nihilo]`]),
  ([`gr[…]`, `gr(autentico: true)[…]`], [Griego politónico], [`gr[λόγος]`]),
  ([`he[…]`], [Hebreo con niqqud, derecha a izquierda], [`he[בְּרֵאשִׁית]`]),
  ([`translit[…]`], [Transliteración romanizada], [`translit[bereshit]`]),
  ([`orn[…]`], [Ornamento de apertura o cierre: `cierre` ❧, `apertura` ☙, `flor` ❦, `parrafo` ❡; cualquier otra letra pasa por la fuente Orments], [`orn[flor]`]),
))

#h2[7.1 `interlineal`]
Palabra por palabra. El orden del array es siempre el de lectura: `idioma: "hebreo"` voltea la rejilla a `rtl` sin que inviertas los datos.

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

```typ
#interlineal(idioma: "griego", ((original: [Ἐν], translit: "en", gloss: "en"), …))
```

Para un versículo completo en dos columnas usa `blockquote-paralelo` (cap. 10).

// ═══════════════════════════════════════════════════════════
= Lienzo, fondos y componentes <cap-canvas>

#h2[8.1 `canvas` y tamaños]
`canvas(size, body, theme:)` produce una página a lienzo completo (`margin: 0pt`, fondo `theme.colors.light`). Las plantillas sociales son `canvas` con contenido.

```typ
#canvas(sizes.instagram, [ … ])   // 1080×1080
#canvas(sizes.story, [ … ])       // 1080×1920
#canvas((1080, 1350), [ … ])      // 4:5, el formato de feed más usado
#bg(palette.white)   #gradient-bg(from: palette.primary, to: palette.secondary)   #blob(-200pt, -150pt, 400, white)
```

`sizes`: `instagram` 1080×1080, `story` 1080×1920, `twitter` 1600×900, `linkedin` 1200×1200. `page-pad` (80pt) y `radius` (24pt) son los márgenes y esquinas estándar. `palette` y `fonts` son alias del tema base para tu markup suelto; no sirven para parametrizar plantillas.

#h2[8.2 Fondos componibles — `superbg`]
Namespace vendorizado en `src/superbg/` (no importa nada del paquete; también existe como `@local/superbg:0.1.0`). Va como *primer hijo* de `canvas()` y reemplaza al fondo nativo. Tres niveles, una sola puerta (`superbg.superbg`):

- *Presets* (22): `superbg.superbg("neon-aura", theme:, size:)`; `superbg.lista-presets()` los enumera.
- *Constructores*: `bg-gradiente`, `bg-aura`, `bg-malla`, `bg-topo`, `bg-patron`, entre otros; se combinan con `+`.
- *Motor de capas*: un diccionario `(capas: (…))`, cada capa con su `tipo:` (`"plano"`, `"gradiente"`, `"aura"`, `"malla"`, `"patron"`, `"vignette"`, `"topo"`, `"halftone"`, `"rayos"`, `"memphis"`, `"imagen"`, `"frame"`, `"vidrio"`) apiladas en orden; parámetros en `src/superbg/core.typ`.

#demo(```typ
#canvas(sizes.instagram, theme: theme.base)[
  #superbg.superbg((capas: (
    (tipo: "gradiente", from: palette.dark, to: palette.primary),
    (tipo: "aura", colores: (palette.secondary, palette.accent)),
    (tipo: "patron", patron: "dots", color: white, opacidad: 12%),
    (tipo: "vignette", intensidad: 28%),
  )), size: sizes.instagram, theme: theme.base)
  #pad(page-pad)[#headline([Fondo de marca], color: white, theme: theme.base)]
]
```.text)

#h2[8.3 Componentes]
Pensados para un lienzo de 1080 pt; en la hoja A4 se muestran reducidos.

#api-table((
  ([`badge(body, color:, variations:, theme:)`], [Píldora con borde y fondo al 30 %], [`badge("NUEVO", color: palette.primary)`]),
  ([`headline(body, size: 72pt)`], [Titular display 800], [`headline([Titular])`]),
  ([`subhead(body, size: 34pt)`], [Texto de apoyo], [`subhead([Apoyo])`]),
  ([`avatar("MJ", bg-color:, size: 90pt)`], [Círculo con iniciales], [`avatar("MJ", size: 90pt)`]),
  ([`avatar-row(name, role, initials)`], [Avatar con nombre y rol], [`avatar-row("María J.", "CM", "MJ")`]),
  ([`stat(value, label)`], [Número gigante con etiqueta], [`stat("+240%", "más alcance")`]),
  ([`progress(pct, height: 14pt)`], [Barra con relleno proporcional], [`progress(0.72)`]),
  ([`divider()`], [Líneas con punto central], [`divider()`]),
  ([`footer(handle, color:)`], [Handle abajo; con `logo:` mide el alto del texto y lo iguala], [`footer("@mi_marca")`]),
))

#h2[8.4 Formas y auras]
- `formas.bocadillo(w:, h:, r:, lado:, tail-w:, tail-h:, fill:)`: la *forma sola*, sin texto, lista como fondo de cualquier bloque. `lado:` es `"izq"`, `"der"` o `"centro"` (posición de la cola).
- `formas.cinta(w:, h:, muesca:, fill:)`: cinta con los extremos en V; `muesca` controla cuánto se hunde.
- `aura-bg(colores, size:, r:, blur:, posiciones:, panel:, panel-blur:, tinte:)`: manchas de color difuminadas; `colores` es un array.
- `cita-canvas(contenido, handle, size:, bg-color:, gradient:, footer-scale:)`: lienzo completo para una cita. Para texto sobre nada usa `theme.colors.white`, no `light`.

// ═══════════════════════════════════════════════════════════
= Plantillas sociales <cap-social>

Cada plantilla es un `canvas` completo: una página, una imagen. Los argumentos van en posicionales (el contenido) y el resto por nombre, con `theme:` siempre al final. Todas aceptan `size:`, `color:` (o `c1:`, `c2:` en las de degradado) y `theme:`.

#h2[9.1 Feed — 1080×1080]
#galeria((
  ("quote-post", ```typ
#quote-post([El diseño no es cómo se ve. Es cómo funciona.], "Steve Jobs", "@mi_marca")
```.text),
  ("announce-post", ```typ
#announce-post("NUEVO", [Lanzamos la 2.0], [Rediseñamos todo.], "@mi_marca")
```.text),
  ("tip-card", ```typ
#tip-card(3, [Publica seguido], [La constancia entrena al algoritmo.], "@mi_marca")
```.text),
  ("carousel-cover", ```typ
#carousel-cover("GUÍA", [5 errores que matan tu alcance], "@mi_marca", n-pages: 6)
```.text),
  ("carousel-slide", ```typ
#carousel-slide(2, 6, [Error #2], [No programar el contenido con anticipación.], "@mi_marca")
```.text),
  ("stat-card", ```typ
#stat-card("+240%", "más alcance", "en 3 meses de constancia", "@mi_marca")
```.text),
  ("testimonial-post", ```typ
#testimonial-post([Cambió cómo publicamos.], "María J.", "Community Manager", "MJ", "@mi_marca")
```.text),
  ("quote-social", ```typ
#quote-social(
  [La constancia entrena al algoritmo... y a tu #highlight[audiencia].],
  "Luis Felipe Reyes de los Reyes",
  iniciales: "LR",
  atribucion: "arriba",
)
```.text),
  ("versus-post", ```typ
#versus-post(
  "Sin estrategia", ("Publicar al azar", "Sin identidad visual"),
  "Con sistema", ("Calendario de contenido", "Plantillas consistentes"),
  "@mi_marca",
)
```.text),
)), cols: 3, ancho: 140pt)

#h2[9.2 Stories — 1080×1920]
#galeria((
  ("event-post", ```typ
#event-post("12", "SEPT", [Noche de alabanza], [7:00pm · Auditorio principal], "@mi_marca")
```.text, 1080),
  ("poll-story", ```typ
#poll-story([¿Reels o carrusel?], [Reels 🎬], [Carrusel 📊], "@mi_marca")
```.text, 1080),
), cols: 3, ancho: 100pt)

#h2[9.3 Argumentos]
#table(columns: (1.5fr, 3.6fr), stroke: borde, inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Plantilla*], [*Posicionales y opciones propias*],
  [`quote-post`], [`quote, author, handle` · `c1:, c2:` degradado (primary → secondary)],
  [`announce-post`], [`tagline, title, subtitle, handle` · `color:` badge y botón],
  [`tip-card`], [`n, title, description, handle` · número como marca de agua sobre `dark`],
  [`carousel-cover`], [`kicker, title, handle` · `n-pages:` puntos de paginación (6) · `c1:, c2:`],
  [`carousel-slide`], [`n, total, title, body-text, handle` · `n/total` alimenta la barra de progreso],
  [`stat-card`], [`value, label, caption, handle` · número gigante y `divider`],
  [`event-post`], [`day, month, title, details, handle` · `size:` por defecto `sizes.story`],
  [`testimonial-post`], [`quote, name, role, initials, handle` · `initials` es explícito, no se deriva de `name`],
  [`quote-social`], [`cita, nombre` · `iniciales:`, `foto:` (ruta desde la raíz del proyecto), `atribucion:` `"abajo"`/`"arriba"`, `comilla:`, `nota-izq:`, `nota-der:` (`(icono:, texto:)`). Para resaltar palabras usa el `#highlight[…]` nativo de Typst],
  [`poll-story`], [`question, option-a, option-b, handle` · `size:` por defecto `sizes.story` · `c1:, c2:`],
  [`versus-post`], [`left-title, left-items, right-title, right-items, handle` · los `*-items` son arrays de strings · `bad:, good:` color de ✕ y ✓ · `vs-badge` es el círculo central],
)

#h2[9.4 Carrusel — `carrusel.typ`]
Un motor y cuatro piezas para armar las diapositivas de un carrusel. *No es automático*: cada diapositiva se arma a mano con la misma carrocería (barra superior, cuerpo, pie con contador y «desliza»).

#demo(```typ
#carrusel-slide("@mi_marca", label: "Tesis", n: 2, total: 6,
  title: [La gracia es gratuita], body: [Texto de desarrollo.],
  referencia: [Efesios 2:8])
```.text, apilar: true, ancho: 140pt)

#opciones((
  ("carrusel-slide(marca, label:, n:, total:, numeral:, title:, title-size:, body:, body-size:, body-italic:, referencia:, swipe:, size:, fondo:, color:, theme:)", "título y cuerpo, con referencia opcional. `numeral:` pone un número gigante de fondo («razón 1 de 5»); `body-italic:` atenúa el cuerpo"),
  ("carrusel-slide-definicion(marca, label:, n:, total:, termino:, pronunciacion:, origen:, body:, …)", "término, pronunciación y origen, para una diapositiva «¿qué es X?»"),
  ("topbar, pie-carrusel, dots, numeral-fondo, referencia-carrusel", "las piezas sueltas de la carrocería"),
  ("fondo-carrusel(fondo, n, size)", "fondo de la diapositiva `n` (desde 1): `none`; un `curvas.campo` (ventana n − 1, continua con las vecinas; su formato debe ser `size`); una función `n => contenido`; o un contenido fijo"),
))

// ═══════════════════════════════════════════════════════════
= Blockquotes <cap-blockquotes>

Familia de citas con una convención única: el cuerpo va primero, luego `autor:` y `fuente:` por nombre, y `theme:` al final. Están pensadas para un lienzo social y por eso usan cuerpos de 26–44 pt; en el manual se muestran reducidas.

#h2[10.1 Control de tamaño — `size:`]
Todas aceptan `size:` (`auto` por defecto), que fija el cuerpo y escala en la misma proporción la comilla, la atribución y los adornos. Las líneas y reglas son gráficos y no escalan.

#grid(columns: (1fr, 1fr), gutter: 10pt,
  cita(```typ
#blockquote-card([Tamaño normal.], autor: "Warfield")
```.text),
  cita(```typ
#blockquote-card([Tamaño normal.], autor: "Warfield", size: 44pt)
```.text),
)

#h2[10.2 Citas de uso general]
#grid(columns: (1fr, 1fr), gutter: 10pt, row-gutter: 12pt,
  cita(```typ
#blockquote-editorial([La disciplina supera al talento cuando el talento no se disciplina.], autor: "Anónimo")
```.text),
  cita(```typ
#blockquote-bar([La constancia entrena al algoritmo… y a tu audiencia.], autor: "Equipo de redes")
```.text),
  cita(```typ
#blockquote-card([El diseño es la ropa que le pones a las ideas.], autor: "Anónimo", fuente: "Manual")
```.text),
  cita(```typ
#blockquote-hero([Publica seguido. La constancia entrena al algoritmo.], autor: "Equipo de redes")
```.text),
  cita(```typ
#blockquote-avatar([Cambió cómo publicamos.], autor: "María J.", fuente: "Community Manager", iniciales: "MJ")
```.text),
  cita(```typ
#blockquote-hand([Escrito a mano, para que se sienta humano.], autor: "Equipo de redes")
```.text),
)

#table(columns: (1.6fr, 3.4fr), stroke: borde, inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Función*], [*Opciones propias*],
  [`blockquote-editorial`], [Doble borde, comilla grande e itálica],
  [`blockquote-bar`], [`variante:` `"default"`, `"grande"` (44pt) o `"acento"`],
  [`blockquote-card`], [Barra superior de acento y pie de atribución],
  [`blockquote-hero`], [Centrada y a todo el ancho; para abrir una diapositiva o sección],
  [`blockquote-avatar`], [`iniciales:` explícito (no se deriva de `autor`, para no fallar si `autor` no es texto plano)],
  [`blockquote-hand`], [Caveat; necesita `Fonts/`],
)

#h2[10.3 Citas con función propia]
#grid(columns: (1fr, 1fr), gutter: 10pt, row-gutter: 12pt,
  cita(```typ
#blockquote-pull([La tipografía es la ropa que le pones a las ideas.], autor: "Anónimo", fuente: "Manual")
```.text),
  cita(```typ
#blockquote-lateral([El estilo es la respuesta a la pregunta: ¿cómo?], autor: "Pascal", n: 1)
```.text),
  cita(```typ
#blockquote-definition("Sola Scriptura", pronunciacion: "so-la skrip-tu-ra", origen: "latín", relacionados: ("Sola Fide",))[Doctrina según la cual la Escritura es la única autoridad infalible.]
```.text),
  cita(```typ
#blockquote-callout(variante: "tip", titulo: "Tip", icono: "✦")[Carruseles de 6–8 slides retienen 2× más que una imagen.]
```.text),
  cita(```typ
#blockquote-poetry(autor: "Borges")[El aleph es uno de los puntos \ que contiene todos los puntos.]
```.text),
  cita(```typ
#blockquote-timeline("2024", [Se publicó la primera versión del sistema.])
```.text),
  cita(```typ
#blockquote-paralelo("λόγος", "Palabra / razón", idioma: "griego", referencia: "Juan 1:1")
```.text),
  cita(```typ
#blockquote-grid(columnas: 2, (
  blockquote-avatar([Uno.], autor: "A", iniciales: "AA"),
  blockquote-avatar([Dos.], autor: "B", iniciales: "BB"),
))
```.text),
)

#table(columns: (1.6fr, 3.4fr), stroke: borde, inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Función*], [*Opciones propias*],
  [`blockquote-pull`], [`marca:` (`"“"`; `none` la quita). Comilla gigante detrás del texto; para portadas y carruseles],
  [`blockquote-lateral`], [`n:` numeración opcional. Atribución vertical rotada],
  [`blockquote-definition`], [`termino, body` · `pronunciacion:`, `origen:`, `relacionados:` (array de pills)],
  [`blockquote-callout`], [`titulo:`, `icono:`, `variante:` `"tip"`, `"info"`, `"warn"` o `"hand"`],
  [`blockquote-poetry`], [Respeta saltos de línea, sin justificar, sangría colgante],
  [`blockquote-timeline`], [`fecha, body`; la regla vertical no escala],
  [`blockquote-paralelo`], [`original, traduccion` · `idioma:` `"griego"` o `"hebreo"` (rtl), `autentico:`, `referencia:`],
  [`blockquote-grid`], [`tarjetas` (array de `blockquote-avatar`) · `columnas:` 2 o 3],
)

#h2[10.4 Legos para armar citas propias]
Cinco piezas que usan las anteriores y se combinan libremente:
#grid(columns: (1fr, 1fr), gutter: 10pt, row-gutter: 12pt,
  cita(```typ
#bq-frame(tipo: "hard")[#text(weight: 900, upper[La constancia entrena al algoritmo.])]
```.text, alto: 150pt),
  cita(```typ
#bq-mark("“", size: 40pt)   #bq-rule(width: 36pt, color: red)
```.text),
  cita(```typ
#bq-attribution(autor: "Mies van der Rohe", modo: "mono")
```.text),
)
#opciones((
  ("bq-frame(body, tipo:, color:, radius:, inset:)", "contenedor; `tipo:` `\"soft\"` (por defecto) o `\"hard\"`"),
  ("bq-mark(texto, size:, fill:, detras:)", "comilla o marca decorativa"),
  ("bq-rule(color:, width:)", "filete corto; `bq-rule-full` ocupa todo el ancho"),
  ("bq-attribution(autor:, fuente:, modo:, color:, size:)", "línea de autor; 3 modos (`\"pro\"`, `\"mono\"`, `\"caps\"`)"),
))

// ═══════════════════════════════════════════════════════════
= Carteles editoriales — `carteles` <cap-carteles>

`carteles` es un namespace de *presets*: cada llamada produce *una página = una imagen*, con el color y la tipografía ya resueltos. A diferencia de las plantillas sociales (cap. 9), no parten de un `theme`: llevan su propia paleta como parámetros con valores por defecto, y se ajustan solos al formato y al largo del texto.

```typ
#carteles.liso([Todo es gracia.])                       // 1080×1350 por defecto
#carteles.suizo([La única esperanza es], [GRACIA])
```

#note[
  *Formato.* Casi todos aceptan `formato: (ancho, alto)` en píxeles. Para el feed de Instagram usa `(1080, 1350)` (4:5) o `(1080, 1080)` (1:1). `(1080, 1920)` es solo para Stories y Reels: no se sube al feed. `sizes` (cap. 8) no trae 4:5; escríbelo explícito.
]

Compila con `--ppi 72` y obtienes 1080 px por cada 1080 pt de lienzo.

#h2[11.1 `carteles.liso` — texto sobre fondo sólido]

El preset más simple: un fondo, un texto. El texto toma *el mayor cuerpo que cabe* (baja de `cuerpo-max` de 2 en 2 pt hasta entrar) y la tinta sale sola (blanco o negro) según el fondo. El bloque se coloca en el centro óptico: el aire de arriba es 2/3 del de abajo.

#demo(```typ
#carteles.liso(
  [El calvinismo es simplemente la religión en su pureza.],
  formato: (1080, 1350), autor: [B. B. Warfield],
  fondo: rgb("#691322"), fuente: "EB Garamond 12", peso: 500,
)
```.text, opts: (
  ("texto", "contenido; el cuerpo se ajusta solo"),
  ("formato:", "default (1080, 1350)"),
  ("autor:, marca:", "`autor` va bajo el texto con «—»; `marca` abajo a la izquierda (p. ej. el logo) y reserva su espacio"),
  ("fondo:", "un color (default `#141414`), o un preset de `superbg` (`\"papel-viejo\"`, `\"noche\"`…) o un dict de capas"),
  ("tinta:", "`auto` = blanco o negro según el fondo (`readable-on`)"),
  ("fuente:, peso:", "default `\"Hanken Grotesk\"`, 700"),
  ("cuerpo:, cuerpo-max:", "`cuerpo` fija el tamaño; con `auto`, parte de `cuerpo-max` (150pt) y baja"),
  ("alinear:, margen:", "`left` por defecto; margen 96pt"),
  ("desgaste:", "0 a 1: tinta gastada (útil con papeles de `superbg`)"),
))

#h2[11.2 `carteles.suizo` — remate a todo el ancho]

Cartel suizo: una palabra-remate ocupa *todo el ancho útil* en un solo color de acento; el resto de la frase, pequeño y en sans, cuelga de una retícula de columnas visible, y una flecha baja de la frase al remate. Cabecera y pie entre filetes.

#demo(```typ
#carteles.suizo(
  [La única esperanza es],             // frase
  [GRACIA],                            // remate: llena el ancho
  autor: [Soli Deo Gloria], etiqueta: [Tesis], planteo: [¿Dónde descansa la conciencia?],
  papel: rgb("#f3f0e9"), tinta: rgb("#141414"), acento: rgb("#c8102e"),
)
```.text, opts: (
  ("frase, remate", "lo que se lee antes del remate, y la palabra que llena el ancho"),
  ("autor:, fechas:", "cabecera (izquierda / columna 3)"),
  ("etiqueta:, planteo:", "bloque superior: rótulo en acento + pregunta. La frase nunca sube por encima del planteo (se achica)"),
  ("papel:, tinta:, acento:, linea:, gris:", "los cinco colores del cartel"),
  ("fuente:, fuente-rotulos:, fuente-remate:", "default `Hanken Grotesk`, `Inter`, `Bebas Neue`"),
  ("cuerpo-frase:, columnas:, margen:, medianil:, aire:", "geometría de la retícula (default 66pt, 6 columnas, 64pt, 24pt, 150pt)"),
  ("flecha:, frase-y:, flecha-hasta:", "`flecha: false` la quita; los otros dos en `auto` se calculan, o se fijan con un largo"),
))

#h2[11.3 `carteles.demostracion` — la cita como demostración]

La cita como demostración numerada sobre pizarra: renglones numerados en mono. La palabra que *se sostiene* va enorme con ⊢; la que *no se sigue*, con ⊬. Una raya de deducción punteada separa los grupos.

#demo(```typ
#carteles.demostracion((
  ([Dios es soberano],),                                    // un renglón de lectura
  ((afirma: [la gracia]), (niega: [el mérito])),            // ⊢ y ⊬
), formato: (1080, 1080), autor: [Ejemplo], fondo: rgb("#0d1014"))
```.text, opts: (
  ("grupos", "array de grupos; un solo grupo puede pasarse plano. Un renglón es un contenido (lectura), `(afirma: c)` (⊢, en `claro`) o `(niega: c)` (⊬, apagado); acepta `signo:` y `cuerpo:`"),
  ("formato:", "default `(1080, 1080)`"),
  ("autor:, obra:, marca:, encabezado:", "pie y cabecera opcionales"),
  ("fondo:, claro:, texto:, apagado:, acento:", "colores de pizarra"),
  ("fuente:, fuente-mono:", "default `Instrument Sans`, `DM Mono`"),
  ("cuerpo-lectura:, cuerpo-max:, margen:, aire-raya:", "tamaños; si el bloque no cabe en el alto, todo se achica en proporción"),
  ("cuadricula:, inicio:", "cuadrícula de fondo (true) y `y` del primer grupo (`auto` reparte 1:2)"),
))

#h2[11.4 `carteles.plano` — lámina de plano técnico]

Azul de calco: retícula fina con líneas maestras, marco, cota y cajetín. El texto va sobre la retícula; las palabras de `destacar` se pintan en acento.

#demo(```typ
#carteles.plano([La gracia es el plano, no el andamio.],
  destacar: ("gracia",), autor: [L. F.], obra: [Soteriología],
  escala: [1 : 1], hoja: [1 / 1])
```.text, opts: (
  ("texto", "los cortes de línea, a mano si se quieren"),
  ("autor:, obra:", "van en el cajetín (autor = «dibujó», obra = «plano»)"),
  ("fondo:, linea:, acento:", "el azul; la retícula, el marco y la cota (`auto` = blanco azulado); el color de lo destacado"),
  ("destacar:", "array de palabras del texto que van en acento"),
  ("paso:, maestra:", "lado de la celda fina y cada cuántas celdas va una línea gruesa"),
  ("cota:", "`auto` = línea sola · contenido = rótulo en medio · `none` = sin cota"),
  ("cajetin:, escala:, hoja:, marcas:", "cajetín (true/false) y sus dos casillas; letras y números en los bordes"),
))

Pensado para 1080×1350; en otros formatos las medidas se escalan con el lado menor.

#h2[11.5 Piezas sueltas]

Los presets se construyen con tres piezas que también se usan solas:

#api-table((
  ([`carteles.reticula(ancho, columnas: 6, margen: 64pt, medianil: 24pt)`], [Retícula de columnas: `x.at(i)` es el borde izquierdo de la columna i; `span.at(n)`, el ancho de n columnas con medianiles], [`#let r = carteles.reticula(1080pt)`]),
  ([`carteles.cuerpo-al-ancho(hacer, ancho)`], [Tamaño de letra con el que `hacer(tamaño)` ocupa exactamente `ancho`. Se mide una vez a 100pt y se escala. Va dentro de `context`], [`context carteles.cuerpo-al-ancho(t => text(size: t)[GRACIA], 600pt)`]),
  ([`carteles.rayar(cuerpo, color:, trazo:, grosor:, vaciar:)`], [Tachado en línea para negar una palabra o un prefijo. `trazo: "recto"` (como `strike`) o `"lapiz"` (línea de corrector a mano)], [`#carteles.rayar[ir]racional`]),
))

#ejemplo("#carteles.rayar[ir]racional  ·  #carteles.rayar(trazo: \"lapiz\")[tachado a lápiz]")

// ═══════════════════════════════════════════════════════════
= Series de carteles <cap-series>

Cinco presets de composición más específica. Cada uno vive en su archivo (`escalera.typ`, `gozne.typ`, `folio.typ`, `esquela.typ`, `linea-tiempo.typ`), se llama desde `carteles` y tiene un ejemplo mínimo en `examples/presets/`.

#h2[12.1 `carteles.escalera` — peldaños hacia un clímax]

Una frase que baja en escalones hasta un *clímax* grande en cursiva, sobre curvas de nivel que convergen en el remate. Los cuerpos se escalan al ancho del formato (base 1080), se achican si una línea no cabe, y el aire entre peldaños se estira (hasta 2,2×) para llenar el alto.

#demo(```typ
#carteles.escalera(
  ([Ni por obras,], [ni por méritos,], [ni por esfuerzo,]),   // peldaños
  [sino por gracia.],                                          // clímax
  coda: [Efesios 2:8-9], formato: (1080, 1920),
)
```.text, opts: (
  ("peldanos", "array de peldaños, o array de grupos (más aire entre grupos; cada grupo vuelve a empezar desde el margen)"),
  ("climax, coda", "el remate grande en cursiva y una línea más chica debajo"),
  ("autor:, obra:, marca:", "cabecera arriba a la izquierda y logo a la derecha"),
  ("alinear:, paso:", "alineación del clímax (`center`, `left`, `right`); cuánto avanza cada escalón (0,163 del ancho útil)"),
  ("curvas:, cumbre:, anillos:", "curvas de nivel de fondo (`auto`, un color, `none`, o un `curvas.campo` para decks continuos con `indice:`); dónde convergen; cuántos anillos"),
  ("fondo:, tinta:, suave:, acento:, fuente:", "paleta y tipografía (default `Literata`)"),
  ("cuerpo:, cuerpo-climax:, cuerpo-coda:, margen:, cabecera-y:, climax-y:, decorado:", "tamaños y posiciones a mano; `decorado` es contenido de fondo propio"),
))

El formato por defecto es `(1080, 1920)` (Stories); para el feed pasa `formato: (1080, 1350)`. Con `carteles.curvas-de-nivel(cumbre, color, n:, sep:, pasos:)` se dibujan las curvas de nivel solas.

#h2[12.2 `carteles.gozne` — cita con diagrama de hojas]

Una cita con llamadas numeradas, y al lado un diagrama de un *perno* con *hojas* (un disco por hoja). Marca en la cita la hoja n con `#carteles.llamada(n)`.

#demo(```typ
#carteles.gozne(
  [Cristo murió por #carteles.llamada(1)su pueblo y resucitó #carteles.llamada(2)para justificarlo.],
  [Evangelio],                       // rótulo del perno
  ([Muerte], [Resurrección]),        // una hoja por cada llamada
  formato: (1600, 900), autor: [Ejemplo],
)
```.text, w: 1600, apilar: true, ancho: 300pt, opts: (
  ("cita, centro, hojas", "la cita con sus llamadas; el rótulo del perno (1–2 renglones); un rótulo por hoja"),
  ("formato:", "default `(1600, 900)`. Apaisado: cita a la izquierda, diagrama a la derecha; vertical o cuadrado: cita arriba, diagrama debajo"),
  ("autor:, obra:, marca:", "pie"),
  ("papel:, tinta:, gris:, acento:, claro:", "colores (los grises y el acento están medidos a ≈ 6:1 sobre el papel)"),
  ("fuente:, fuente-cita:", "default `Instrument Sans`, `Libre Baskerville`"),
  ("angulos:, diagrama:, rotulos:", "a mano, todo opcional: ángulos de las hojas, posición y escala del dibujo, posición de cada rótulo"),
))

Hasta 5 hojas se sostiene; con 4 o más, las hojas y las puntas de las flechas se afinan para no tocarse.

#h2[12.3 `carteles.folio` — folio de manuscrito]

Un pasaje como página de manuscrito: primera letra en capitular rubricada, glosa al margen, cabecera de molinetes y pergamino con textura. Pensado para el cuadrado 1080×1080.

#demo(```typ
#carteles.folio(
  [Ten piedad de mí, oh Dios, conforme a tu misericordia.],
  glosa: ([Salmo], [51]), autor: [Ejemplo],
)
```.text, opts: (
  ("texto", "el pasaje; su primera letra va en capitular"),
  ("glosa:", "`(arriba, abajo)`: las dos líneas de la glosa al margen, la segunda más grande · `none`"),
  ("autor:, marca:", "pie en versalitas; contenido al pie a la derecha"),
  ("cabecera:", "`auto` (banda de molinetes recortada) · un nombre de `fleurones.guardas` · `none`"),
  ("relleno:", "glifo de FLOWERS 2 que completa la última línea · `none`"),
  ("cuerpo:", "`auto` = 66pt, achicándose de 2 en 2 si no cabe"),
  ("capitular:", "argumentos de `capitular-ornamentada` (`alto`, `estilo`, `desgaste`…)"),
  ("tinta:, rubrica:, pergamino:, textura:", "colores y textura de papel"),
))

#h2[12.4 `carteles.esquela` — esquela de luto]

Una esquela: nombre en versalitas grandes, anuncio y duelo en cursiva, cruz, viñetas y una orla. Útil como pieza irónica o solemne. Pensada para el retrato 1080×1350.

#demo(```typ
#carteles.esquela([Legalismo],
  anuncio: [Ha fallecido], duelo: [No lo lloraremos.],
  orla: "luto", simbolo: "cruz")
```.text, opts: (
  ("nombre", "el «difunto»: una palabra o dos, en versalitas grandes (se achica si no cabe)"),
  ("anuncio:, duelo:", "frases de arriba y de abajo, en cursiva"),
  ("autor:, obra:, marca:", "pie"),
  ("orla:", "`\"luto\"` (banda negra gruesa) · un marco de `fleurones.cadenas` · `none`"),
  ("interior:", "lo que corre por dentro de la orla: `\"filete\"` · un marco de `cadenas` · `none`"),
  ("simbolo:", "`\"cruz\"` (latina) · contenido · `none`"),
  ("vineta:, vineta-pie:", "`auto` · un nombre de `fleurones.vinetas` · contenido · `none`"),
  ("papel:, luto:, sepia:, textura:", "colores y textura"),
))

#h2[12.5 `carteles.linea-tiempo` — estaciones sobre una línea]

Frases de arriba abajo sobre una línea vertical, con rótulos en los extremos y un remate destacado junto al final. Si las frases no caben, todo se achica de a 5 %; si sobra mucho, crece hasta 1,25×.

#demo(```typ
#carteles.linea-tiempo(
  ([Creación], [Caída], [Promesa]),
  origen: [Génesis], fin: [Apocalipsis],
  remate: [Y todo es hecho nuevo.],
)
```.text, opts: (
  ("estaciones", "array de contenidos: las frases, de arriba abajo"),
  ("origen:, fin:", "rótulos de los extremos (mayúsculas espaciadas)"),
  ("remate:", "la última frase, destacada junto al final"),
  ("autor:, obra:, marca:", "pie"),
  ("fondo:, tinta:, acento:, suave:", "colores"),
  ("fuente:, fuente-rotulos:, cuerpo:, cuerpo-remate:", "default `Literata`, `Jost`, 54pt y 84pt"),
  ("y:", "`auto` reparte parejo; o un array de largos (uno por estación, más uno para el remate)"),
))

// ═══════════════════════════════════════════════════════════
= Orlas y fleurones <cap-orlas>

`fleurones` es el motor de orlas, bandas y mallas hechas con la tipografía IM FELL FLOWERS. `orlas.typ` lo usa para tres composiciones listas (cita, capítulo y pregunta) que se llaman desde `carteles`.

#note[
  *Licencia.* IM FELL FLOWERS exige la nota de `fleurones.credito` donde el medio lo pida (créditos, pie de foto). Las piezas no la estampan. Ver `Fonts/IM_Fell_Flowers/LICENCIA.txt`.
]

#h2[13.1 Presets por uso — `fleurones`]

Todos devuelven contenido que se coloca donde convenga; el `color` va siempre como argumento.

#api-table((
  ([`fleurones.orla(nombre, ancho, alto, color, grosor:)`], [Marco completo con una cadena de la tabla; con otro `grosor`, el aire entre motivos se escala], [`#fleurones.orla("ojivas", 800pt, 800pt, black)`]),
  ([`fleurones.guarda(nombre, largo, color, alto:)`], [Banda solo horizontal], [`#fleurones.guarda("guirnalda", 600pt, black)`]),
  ([`fleurones.vineta(nombre, alto, color)`], [Viñeta a su proporción natural], [`#fleurones.vineta("cruz", 40pt, black)`]),
  ([`fleurones.roseta(lado, color, tipo:)`], [Roseta; `"molinete"` son los cuatro molinetes de F2 en cruz], [`#fleurones.roseta(120pt, black)`]),
  ([`fleurones.medallon(lado, color)`], [F1 «Q» espejado en cuatro cuadrantes], [`#fleurones.medallon(120pt, black)`]),
  ([`fleurones.cabecera(ancho, color, guarda:, linea:, alto:)`], [Una guarda entre dos filetes, a todo el ancho], [`#fleurones.cabecera(600pt, black)`]),
  ([`fleurones.separador(ancho, color, vineta:, linea:, alto:, grosor:)`], [Filete — viñeta — filete], [`#fleurones.separador(400pt, black)`]),
  ([`fleurones.asterismo(alto, color, vineta:)`], [Tres viñetas en triángulo (⁂), el corte de sección clásico], [`#fleurones.asterismo(36pt, black)`]),
  ([`fleurones.remate(alto, color, vineta:, filas: (3, 2, 1))`], [Cul-de-lampe: viñetas en triángulo invertido; `filas` cuenta las de cada fila], [`#fleurones.remate(30pt, black)`]),
  ([`fleurones.friso(ancho, color, linea, alto:)`], [Banda de cartuchos entre dos filetes], [`#fleurones.friso(600pt, black, gray)`]),
))

#h2[13.2 Tablas de nombres]

Los nombres válidos viven en cuatro tablas de `fleurones`; el manual no las copia para no quedar desactualizado: consúltalas con `fleurones.cadenas.keys()`, `fleurones.guardas.keys()` y `fleurones.vinetas.keys()`. A la fecha:

- *`cadenas`* (marcos): ojivas, cartuchos, follaje, flores, eslabones, celosía, trenza, damasco, bordado, anillas, lises, zarcillos, encaje, corazones, ondas, espirales, cadeneta, crucetas, margaritas, rosetones.
- *`guardas`* (bandas): guirnalda, volutas, hojas, hojarasca, cresteria, lises, copas, palmetas, follaje, acantos, óvalos, vaivén, zarcillos, encaje.
- *`vinetas`*: cruz, flor, rosa, lis, copa, ramo, palmeta, hoja, molinete, mano, mano-izq, acanto, candelabro, broche, trébol, guirnalda, follaje, cresta.

Además del motor de bajo nivel para armar mallas propias: `banda`, `marco`, `diaper`, `filetes`, `tira`, `grosor-tira`, `caja`, `divisor`, `ancho-natural`, `gl`, `alternar`, `espejo4` y `giro4` (ver `src/fleurones.typ`).

#h2[13.3 Composiciones — `orlas.typ`]

Tres piezas sobre un lienzo con orla, accesibles desde `carteles`. Cada llamada es *una página*.

#demo(```typ
#carteles.cita-orlada(
  [Nada hay tan práctico como una buena teología.],
  autor: [Ejemplo], fuente: [Obra], formato: (1080, 1080), tema: "papel",
)
```.text, opts: (
  ("carteles.cita-orlada(texto, encabezado:, autor:, fuente:, formato:, tema:, firma:, tamano:, orla:, cadena:)", "comillas de fleurón, texto en cursiva, autor y fuente"),
  ("carteles.capitulo-orlado(numero, titulo, subtitulo:, llamada:, rotulo:, obra:, autor:, formato:, tema:, firma:, orla:, cadena:)", "anuncio de lectura o de serie sobre malla"),
  ("carteles.pregunta-orlada(texto, encabezado:, fuente:, pista:, formato:, tema:, firma:, orla:, cadena:)", "pregunta de estudio: friso arriba, banda abajo"),
  ("carteles.lienzo-orlado(formato, tema, cuerpo, orla:, cadena:)", "el lienzo solo; `cuerpo` recibe `(c, ancho, alto, tipo)` para armar composiciones propias"),
  ("tema:", "`\"vino\"` (cubierta) · `\"papel\"` (interior) · o un dict con las mismas claves que `temas.vino`"),
  ("orla:", "`\"completa\"` · `\"arriba\"` · `\"abajo\"` · `\"arriba-abajo\"` · `\"izquierda\"` · `\"derecha\"` · `\"lateral\"` · `\"columna\"` · `\"ninguna\"`"),
  ("cadena:", "cualquier marco de `fleurones.cadenas`"),
))

El formato se clasifica en *cuadrado*, *vertical* o *historia* (alto ≥ 1,6 × ancho) y la composición se ajusta a eso.

// ═══════════════════════════════════════════════════════════
= Curvas continuas — `curvas` <cap-curvas>

Un carrusel se lee como una sola tira: la curva que sale por el borde derecho de una diapositiva entra por el izquierdo de la siguiente. Para eso cada fondo es un *campo* que vive en un espacio de N diapositivas de ancho, y cada diapositiva dibuja solo su *ventana*. Los puntos salen de una función determinista de coordenadas globales (con `semilla`), así que los bordes coinciden exactamente.

#api-table((
  ([`curvas.campo(tipo, diapositivas: 5, formato: (1080, 1080), semilla: 1, color:, grosor:, opacidad:, ..opciones)`], [Especificación del campo; no dibuja nada. `formato` es el de *una* diapositiva], [`#let c = curvas.campo("topo", diapositivas: 5)`]),
  ([`curvas.ventana(c, i)`], [Fondo de la diapositiva `i` (desde 0), a lienzo completo y recortado], [`#curvas.ventana(c, 2)`]),
  ([`curvas.panorama(c)`], [El campo entero de una vez (banner, verificación)], [`#curvas.panorama(c)`]),
))

#h2[14.1 Familias y opciones]

Cada familia (`tipo`) acepta opciones propias por nombre:

#table(columns: (1fr, 3fr), stroke: 0.5pt + luma(85%), inset: 6pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Tipo*], [*Opciones*],
  [`"topo"`], [Curvas de nivel de un terreno con varias cumbres. `cumbres:` (default una por diapositiva más una), `sep:` (distancia entre curvas, pt), `maestra:` (cada cuántas, una más gruesa)],
  [`"ondas"`], [Ondas horizontales. `lineas:` (13), `amplitud:` (fracción del alto, 0,11), `largo:` (en diapositivas), `relleno:` (`true` = bandas alternadas)],
  [`"flujo"`], [Líneas de corriente sobre un campo suave. `separacion:` entre semillas (92), `pasos:` de integración (34), `escala:` de los remolinos],
  [`"paralelas"`], [Haz de paralelas que se deforma sin cruzarse. `lineas:` (24), `amplitud:` (0,2), `largo:`],
  [`"cinta"`], [Una sola cinta gruesa que atraviesa todo. `ancho:` (fracción del alto, 0,035), `bucles:` (con rizos), `hueco:` (un color la deja hueca, con ese color adentro), `largo:`],
  [`"orbitas"`], [Elipses alrededor de centros repartidos. `centros:` (uno por diapositiva), `anillos:` por centro, `astros:` (un disco sobre algunas órbitas)],
)

Opciones comunes de `campo`: `color`, `grosor`, `opacidad`, `semilla`.

#demo(```typ
#let c = curvas.campo("topo", diapositivas: 3, formato: (1080, 1080), color: rgb("#8fb8a4"), opacidad: 45%)
#pliego(width: 1080pt, height: 1080pt, margin: 0pt, fill: rgb("#10302a"), curvas.ventana(c, 1))
```.text)

#note[
  El dibujo es nativo (`curve`/`polygon`), no SVG: un SVG armado con `str()` escribe los negativos con «−» (U+2212) y el visor descarta esas curvas. Para ver las seis familias, `examples/presets/curvas.typ`.
]


// ═══════════════════════════════════════════════════════════
= Herramientas <cap-cli>

#h2[15.1 `nueva-plantilla.py`]
Genera un `.typ` listo para editar y compilar para cualquiera de las 12 plantillas (10 de `social.typ`, más `articulo` y `pasaje`).

```bash
python3 scripts/nueva-plantilla.py --listar
python3 scripts/nueva-plantilla.py announce-post mi-post.typ \
  --paleta terracota --tipografia editorial-clasico \
  --campo tagline=NUEVO --campo title="Mi título"
python3 scripts/nueva-plantilla.py quote-post examples/mi-cita.typ --repo   # import relativo
python3 scripts/nueva-plantilla.py tip-card tip.typ --paleta bosque --compilar
```

Por defecto emite `#import "@local/instatypst:0.1.0": *`; con `--repo`, `#import "../src/lib.typ": *`. `articulo` y `pasaje` no usan `theme:` porque arman el tema por dentro con `make-theme()`.

#h2[15.2 `pliego` y `en-caja` — mostrar láminas dentro de un documento]
Los presets arman *una página por pieza*, y Typst no permite anidar una página en un contenedor. Por eso todos llaman a `pliego(...)` en vez de `page(...)`:

- Fuera de `en-caja`, `pliego(width:, height:, margin:, fill:, cuerpo)` es exactamente `page(...)`.
- Dentro de `en-caja(k, …)`, es un bloque de `width × height` con el mismo fondo, escalado por `k` y recortado.

```typ
#en-caja(0.15, carteles.liso([Todo es gracia.]))    // cabe en una A4, a 15 %
#en-caja(150pt / 1080pt, carteles.suizo([La única esperanza es], [GRACIA]))
```

Así se hizo este manual: cada lámina se evalúa en vivo y se reduce a su sitio, sin renderizar nada aparte. Si escribes tu propio preset, usa `pliego` en vez de `page` para que también se pueda anidar.

#h2[15.3 Servidor MCP]
`mcp/server.py` expone el paquete a Claude Code y a otros clientes MCP. Es un envoltorio delgado: lee paletas, plantillas y fuentes del repo en vivo y compila con el `typst` del sistema.

```bash
claude mcp add --scope user instatypst -- uv run --script /ruta/a/Instatypst/mcp/server.py
```

#table(columns: (1.5fr, 3.6fr), stroke: borde, inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Herramienta*], [*Qué hace*],
  [`ayuda`], [Devuelve `SKILL.md`],
  [`listar_paletas`, `listar_plantillas`, `ver_plantilla`, `listar_fuentes`], [Descubrimiento en vivo; una paleta o preset nuevo aparece sin tocar el servidor],
  [`contraste`], [Razón WCAG entre dos colores `#RRGGBB`, con veredicto AA/AAA],
  [`tarjeta_texto`], [Tarjeta de texto sobre fondo liso con `carteles.liso`; formatos `feed-4x5`, `feed-1x1` y `story`],
  [`compilar`, `renderizar`], [PNG de un `.typ` o de código dado; detectan el desborde de página],
  [`verificar`], [Compila los `.typ` de una carpeta y reporta cuáles fallan (prueba de regresión)],
  [`auditar_paletas`], [Marca paletas cuyos roles no alcanzan el contraste mínimo],
  [`api`, `cobertura_manual`], [Firmas reales de `src/` y qué funciones públicas no menciona este manual],
)

// ═══════════════════════════════════════════════════════════
#[#set heading(numbering: none); #heading(level: 1)[Apéndice A — Referencia rápida de `lib.typ`] <cap-api>]

`src/lib.typ` re-exporta:

#table(columns: (1.9fr, 3fr), stroke: borde, inset: 6pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Export*], [*Origen*],
  [`theme`], [`theme.typ`: `base`, `define`, `with`, `with-color`, `with-font`, `named`, `color`, `font`, `colors`, `fonts`, `lighten`, `darken`, `fade`, `validate`, `export`, `load` (cap. 2)],
  [`palettes`], [`palettes.typ`: `tokens`, `token`, `library`, `names`, `get`, `mix`, `auto-roles`, `as-theme`, `as-theme-manual`, `swatch`, `card`, `catalog`, `luminance`, `saturation` (cap. 3)],
  [`luminance`, `contrast`, `is-aa`, `is-aaa`, `readable-on`, `auto-pair`, `auto-pair-tinted`], [`contrast.typ` (cap. 3.3)],
  [`pairings`], [`font-pairings.typ`: `names`, `get`, `resolve`, `as-theme`, `catalog`, `card`, `swatch` (cap. 4)],
  [`color-tokens`, `font-tokens`], [`tokens.typ`, `font-tokens.typ`: `tokens`, `token(key)`, `family(key)`, `by-category` (con espacio de nombres)],
  [`capitular`, `capitular-ornamentada`, `inicial-ornamentada`], [`dropcaps.typ` (cap. 5)],
  [`articulo`, `primer-parrafo`, `make-theme`, `fondo-editorial`], [`articulo.typ` (cap. 6)],
  [`scripture`, `vs`, `ch`, `pasaje`, `set-body-font`], [`scripture.typ` (cap. 6)],
  [`lat`, `gr`, `he`, `translit`, `interlineal`, `orn`], [`idiomas.typ` (cap. 7)],
  [`canvas`, `bg`, `gradient-bg`, `blob`, `sizes`, `page-pad`, `radius`, `palette`, `fonts`, `badge`, `headline`, `subhead`, `footer`, `avatar`, `avatar-row`, `stat`, `progress`, `divider`, `aura-bg`, `cita-canvas`], [`social.typ`: lienzo y componentes (cap. 8)],
  [`quote-post`, `announce-post`, `tip-card`, `carousel-cover`, `carousel-slide`, `stat-card`, `event-post`, `testimonial-post`, `quote-social`, `poll-story`, `versus-post`], [`social.typ`: plantillas (cap. 9)],
  [`carrusel-slide`, `carrusel-slide-definicion`, `topbar`, `pie-carrusel`, `dots`, `numeral-fondo`, `referencia-carrusel`, `fondo-carrusel`], [`carrusel.typ` (cap. 9.4)],
  [`blockquote-*`, `bq-frame`, `bq-mark`, `bq-rule`, `bq-rule-full`, `bq-attribution`], [`blockquotes.typ` (cap. 10)],
  [`formas`], [`formas.typ`: `bocadillo`, `cinta` (cap. 8.4)],
  [`superbg`], [`superbg/`: fondos componibles (cap. 8.2)],
  [`carteles`], [`carteles.typ`: `liso`, `suizo`, `demostracion`, `plano`, `escalera`, `gozne`, `llamada`, `folio`, `esquela`, `linea-tiempo`, `curvas-de-nivel`, `lienzo-orlado`, `cita-orlada`, `capitulo-orlado`, `pregunta-orlada`, `reticula`, `cuerpo-al-ancho`, `rayar` (cap. 11 a 13)],
  [`fleurones`], [`fleurones.typ`: `orla`, `guarda`, `vineta`, `roseta`, `medallon`, `cabecera`, `separador`, `asterismo`, `remate`, `friso`, tablas `cadenas`, `guardas`, `vinetas` (cap. 13)],
  [`curvas`], [`curvas.typ`: `campo`, `ventana`, `panorama` (cap. 14)],
  [`pliego`, `en-caja`], [`pliego.typ`: `page` que cabe en un documento (cap. 15.2)],
)

// ═══════════════════════════════════════════════════════════
#[#set heading(numbering: none); #heading(level: 1)[Apéndice B — Migración desde `cristianamente.typ`] <cap-migracion>]

`cristianamente.typ` es el paquete previo (tema «Paper» de cristianamente.xyz). Se conserva fuera del paquete publicado (`typst.toml` lo excluye). Si vienes de ahí:

#table(columns: (2fr, 2fr, 2fr), stroke: borde, inset: 5pt, fill: (_, y) => if y == 0 { luma(96%) } else { white },
  [*Antes*], [*Ahora*], [*Notas*],
  [`color` / `color-dark`], [`theme.base.colors` / `palettes.as-theme`], [`auto-roles` elige roles; `white` siempre es blanco],
  [`font.display/serif/sans/mono/hand1`], [`theme.base.fonts`, `font-tokens.family`, `pairings`], [8 parejas curadas],
  [`articulo(...)` Paper], [`articulo` + `make-theme(paleta:, tipografia:)` + `fondo-editorial`], [Ahora el tema viaja por `state`],
  [`cita-editorial`, `cita-bloque`, `cita-tarjeta`, `cita-heroica`, `cita-manuscrita`], [`blockquote-editorial`, `-bar`, `-card`, `-hero`, `-hand`], [`body` primero, luego `autor:`, `fuente:` y `theme:`; `blockquote-avatar` pide `iniciales:`],
  [`escritura` / `ScriptureBlock`], [`scripture`, `pasaje`, `vs`, `ch`], [`pasaje` usa `capitular` para el primer versículo],
  [`definicion`], [`blockquote-definition`], [Mismo patrón con `pronunciacion:`, `origen:`, `relacionados:`],
  [`ver-tambien`, `grid-citas`], [`blockquote-grid` (para tarjetas con avatar)], [Sin equivalente directo del primero],
)

#note[No hay compatibilidad automática. La forma más rápida de migrar un documento es generar un esqueleto con `scripts/nueva-plantilla.py` y copiar el contenido. Para artículos largos, usa `articulo`, `primer-parrafo` y `blockquote-*` en lugar de `cita-*`.]

#v(24pt)
#align(center)[
  #text(font: theme.base.fonts.display, size: 11pt, weight: 800, fill: primary)[Fin del manual]
  #v(4pt)
  #text(size: 8pt, fill: faint)[`src/lib.typ` · `demo.pdf` para el catálogo visual · `examples/` para las recetas mínimas]
]
