// ─────────────────────────────────────────────────────────────
//  anaglyph.typ — el preset `anaglyph`: texto en capas de tinta (familia tipográfica de WallTypst)
//
//  anaglyph = plain (scaffold) + estas reglas, sobre el motor `engines/glitcher.typ`.
//  Una variante por preset de WallTypst:
//
//    variant   WallTypst           qué es
//    "triple"  cartel-tres-tintas  las tres palabras más largas, una por tinta, apiladas y montadas
//    "stacked" cartel-capas-apilado la frase repartida en líneas a todo el ancho, con una tinta de sombra
//    "outline" cartel-capas-contorno lo mismo, con una tinta de relleno y otra solo en contorno
//    "stacked-key" cartel-capas-clave la frase como párrafo, con su palabra más larga resaltada en tinta
//    "swiss-bands" bandas-suizas    la frase en bandas de color con sangría, una por línea
//    "glyph"   cartel-capas        un carácter gigante en dos tintas desplazadas y la cita abajo a la derecha
//    "word"    cartel-capas-palabra la palabra más larga en tres tintas desplazadas, abajo a la derecha
//    "scale"   cartel-capas-escala  una palabra enorme que sangra (girada en vertical) y la frase encima
//    "edge"    cartel-capas-canto   una palabra girada −90° en el canto derecho, a sangre, y el verso
//    "fade"    cartel-degrade       una palabra en cursiva sobre un degradado, y el verso arriba
//    "initial" cartel-inicial       la inicial del epígrafe, gigante y recortada arriba, y el epígrafe abajo a la derecha
//    "circle"  cartel-circulo       un disco enorme al borde, la inicial encima y el epígrafe abajo a la izquierda
//    "monogram" cartel-monograma    una palabra gigante en dos tipografías (relleno y contorno) y el epígrafe
//    "roman"   epigrafe             un numeral romano pálido de fondo y el epígrafe arriba a la derecha, con filete
//    "quote"   cartel-cita          una comilla enorme sangrando por la esquina y la cita en mayúsculas
//    "quote-echo" cartel-cita-eco   comilla de apertura (relleno) y de cierre (contorno), y la cita centrada
//    "quote-mark" cita              viñeta y grano, una comilla sobre la cita, que va a la derecha
//    "twin"    cartel-inicial-gemela la inicial en dos tipografías (relleno y contorno) arriba, y el texto con capitular doble
//    "grotesque" cartel-inicial-grotesca lo mismo en sans condensada (sin cursiva, sin justificar, en versales)
//    "poster"  cartel               un signo gigante en cursiva y el título (kicker, título, bajada) abajo a la derecha
//
//  Elementos que reconoce (elements.typ): main (la frase), verse, author, work, brand.
//  La frase de la que salen las palabras es `main`, o el verso si no hay, o el contenido suelto.
//  Opción: `seed` (def. 1) para el azar de los desplazamientos (`rango`), como la semilla de WallTypst.
//
//    #anaglyph(variant: "triple", artboard: (1920, 1080))[
//      #verse[Es por la misericordia de Jehová que no somos consumidos…]
//      #work[Lamentaciones 3:22–23  ·  RV1909]
//    ]
//
//  WallTypst → V2 (cartel-tres-tintas, una línea por clave del TOML):
//    [vars] t = elegir[3 juegos]      → roles `tint-a/b/c` del tema; el juego por defecto es el que
//                                       WallTypst elige con semilla 1 (el tercero). Pendiente: `seed:`
//                                       derivado por el motor de colores (modules/color, derive.typ)
//    [colors] paper, ink              → tema
//    [fonts] Bebas Neue / Hanken Grotesk → display, body
//    [layout] 12|16|6 col, 12|18 filas, row-gutter 0, margin 70|56, safe escritorio
//                                     → vendor/reticula.typ (temporal)
//    [[layers]] plano                 → el papel del tema
//    [[layers]] texto clave:i/3 ×3    → engines/glitcher: línea ajustada a su celda, una pasada al 82 %
//    [[layers]] ruido                 → recurso `grain`: aún no existe; se dibuja siempre
//    [[blocks]] verse                 → `#verse[…]` + `#work[…]` en su celda, abajo a la derecha
//    [[blocks]] quote (fallback=false)→ pendiente: el `quote` de Typst, sin ejemplo todavía
//    desde = clave:N/3                → el preset deriva las palabras del texto, no hay `desde`
//
//  cartel-capas-apilado → "stacked":
//    [vars] set = elegir[3 juegos]    → tema: paper = set.0, ink = set.3, tint-a = set.1 (frente), tint-b = set.2
//                                       (sombra); el juego por defecto es el de semilla 1 (el primero)
//    [[layers]] texto forma=apilado   → engines/glitcher `stacked`: lines-max 7, leading 0.2, size-max 330,
//                                       umbral 160 (la pasada de sombra, `largo = false`, se omite si la frase es larga),
//                                       dx/dy = rango [5,9] / [4,7] con la clave de WallTypst
//    [[blocks]] quote parts=firma     → `#author[…]` y `#work[…]` en su celda, abajo a la izquierda
//    la frase misma                   → `#main[…]` (WallTypst la sacaba de `quote.text`)
//
//  cartel-capas-clave → "stacked-key" (variante de stacked: la forma `parrafo` en lugar de `apilado`):
//    [vars] tinta = elegir[3]         → tint-a (el primero, semilla 1); paper/ink del TOML
//    [[layers]] ruido                 → debajo del texto (en stacked va encima)
//    [[layers]] texto forma=parrafo   → engines/glitcher `paragraph`: size 150 (380 sin texto: pendiente), leading 0.2,
//                                       celda col 4 span 9 filas 1–7, anclado a la izquierda al centro
//    pasadas                          → sombra (tint-a 32 %, dx 6, dy 5) y tinta con `resalte` = tint-a
//    resaltar = larga                 → `longest-word`: la palabra más larga de la frase
//    la firma de un verso             → autor = la referencia y fuente = la versión (como b-cita)
//
//  bandas-suizas → "swiss-bands" (el nombre `bands` ya es un preset de V2): juego = tint-a…d (el tercero, semilla 1);
//    bandas con tintas (paper, paper, paper, ink), sangrías por aspecto, pad 0,3, separación 0,14, 6 líneas, size-max 150;
//    sin grano; engines/glitcher `bands`. Firma en col 3 span 10 (no 4/9).
//
//  cartel-capas → "glyph": `#glyph[?]` (el carácter; sin él, WallTypst lo elige al azar: `choose` con la semilla);
//    dos pasadas (tint-a 80 %, tint-b 70 % con dx 46, dy 28), Bodoni Moda cursiva, 1350|1100 k, ancla por aspecto
//    (con texto 0,36/0,5 | 0,5/0,32; sin texto 0,55/0,5); grano 9 %; la cita (`#main`) a 104 k en mayúsculas, abajo a la derecha,
//    con su firma (fuente en cursiva). Pendiente: el bloque `text` (título) de la plantilla, sin ejemplo.
//
//  cartel-capas-palabra → "word"; -escala → "scale"; -canto → "edge"; cartel-degrade → "fade":
//    una palabra de la frase (`longest-word`, o la primera/última, elegida con `choose` y la semilla) en `glitcher.line`,
//    con `turn` y `scale` donde la plantilla trae `giro` y `escala`; sin frase, la palabra por defecto de WallTypst
//    (GRACIA / GLORIA / gracia) y su celda de `sin-texto`. Colores: el juego de semilla 1 de cada plantilla.
//
//  cartel-capas-contorno → "outline": igual que stacked, con size-max 300, umbral 150; pasadas: relleno
//    (set.1, 85 %, dx/dy = rango [6,12] / [5,9]) y contorno (set.2, 1,6 k, sin relleno, `largo = false`).
//    Tema: paper = set.0, ink = set.2, tint-a = set.1. La frase es `#epigraph[…]` (WallTypst: `epigraph.text`).
//
//  Escala: k = lado corto / 1000, la de WallTypst, para poder medir la paridad.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ": superbg
#import "engines/glitcher.typ" as glitcher
#import "vendor/reticula.typ": reticula
#import "common.typ": verse-block, in-cell, aspect, pick, legible, block-at, title-block
#import "/src/resources/dropcaps/dropcaps.typ": capitular

#let _themes = (
  triple: (
    paper: rgb("#f3ede2"),
    ink: rgb("#16120f"),
    accent: none,
    tint-a: rgb("#e8432a"),
    tint-b: rgb("#1d4fd8"),
    tint-c: rgb("#f2b705"),
  ),
)
#let _themes = _themes + (
  stacked: (
    paper: rgb("#f1ebe0"),
    ink: rgb("#16120f"),
    accent: none,
    tint-a: rgb("#ff4f8b"),
    tint-b: rgb("#1d3fd8"),
  ),
)
#let _themes = _themes + (
  outline: (
    paper: rgb("#121212"),
    ink: rgb("#f4eee3"),
    accent: none,
    tint-a: rgb("#ff5d8f"),
  ),
)
#let _themes = _themes + (
  stacked-key: (
    paper: rgb("#f2ece1"),
    ink: rgb("#16120f"),
    accent: none,
    tint-a: rgb("#e2412b"),
  ),
)
#let _themes = _themes + (
  swiss-bands: (
    paper: rgb("#efe9de"),
    ink: rgb("#16120f"),
    accent: none,
    tint-a: rgb("#2f5bd8"),
    tint-b: rgb("#16120f"),
    tint-c: rgb("#f07c5d"),
    tint-d: rgb("#9fc1b3"),
  ),
  glyph: (
    paper: rgb("#f4eee3"),
    ink: rgb("#14110f"),
    accent: none,
    tint-a: rgb("#00a39a"),
    tint-b: rgb("#ff8a3d"),
  ),
)
#let _themes = _themes + (
  word: (
    paper: rgb("#f3ede2"),
    ink: rgb("#16120f"),
    accent: none,
    tint-a: rgb("#e8432a"),
    tint-b: rgb("#1d4fd8"),
    tint-c: rgb("#f2b705"),
  ),
  scale: (
    paper: rgb("#10213a"),
    ink: rgb("#f1e9d8"),
    accent: none,
    tint-a: rgb("#1c3a60"),
    tint-b: rgb("#ff7a59"),
  ),
  edge: (
    paper: rgb("#f1ebe0"),
    ink: rgb("#16120f"),
    accent: none,
    tint-a: rgb("#ff5d5d"),
    tint-b: rgb("#1d3fd8"),
  ),
  fade: (
    paper: rgb("#0f1a24"),
    ink: rgb("#f0ece2"),
    accent: rgb("#9fd0d9"),
    tint-a: rgb("#2f5f6e"),
  ),
)
#let _themes = _themes + (
  initial: (paper: rgb("#f2ede3"), ink: rgb("#1f1b17"), quiet: rgb("#6f665b"), accent: rgb("#d6452b")),
  circle: (paper: rgb("#efe0dc"), ink: rgb("#5a2f36"), accent: none, tint-a: rgb("#ddc1bc")),
  monogram: (paper: rgb("#f4efe4"), ink: rgb("#1a1611"), accent: none, tint-a: rgb("#3d3470"), tint-b: rgb("#c2563f")),
  roman: (paper: rgb("#f5f1e8"), ink: rgb("#2a2622"), quiet: rgb("#7d7468"), accent: none, tint-a: rgb("#e6dfd1")),
  quote: (paper: rgb("#2343b3"), ink: rgb("#f5eee2"), accent: none, tint-a: rgb("#1c389b"), tint-b: rgb("#ffc94a")),
  quote-echo: (paper: rgb("#f4eee3"), ink: rgb("#1b1714"), quiet: rgb("#6f6252"), accent: rgb("#b5442f")),
  quote-mark: (paper: rgb("#6e2a1e"), ink: rgb("#f3ead9"), accent: rgb("#e9b54c")),
)
#let _themes = _themes + (
  twin: (paper: rgb("#f3eee5"), ink: rgb("#1f1b17"), accent: rgb("#c8452c")),
  grotesque: (paper: rgb("#14161b"), ink: rgb("#ece6d8"), accent: rgb("#ff6a3d")),
)
#let _themes = _themes + (
  poster: (paper: rgb("#e2492f"), ink: rgb("#17120f"), accent: none, tint-a: rgb("#c63b23")),
)
#let _extra = (poster: ("tint-a",), twin: (), grotesque: (), initial: (), circle: ("tint-a",), monogram: ("tint-a", "tint-b"), roman: ("tint-a",), quote: ("tint-a", "tint-b"),
  quote-echo: (), quote-mark: (), word: ("tint-a", "tint-b", "tint-c"), scale: ("tint-a", "tint-b"), edge: ("tint-a", "tint-b"), fade: ("tint-a",),
  triple: ("tint-a", "tint-b", "tint-c"), stacked: ("tint-a", "tint-b"), outline: ("tint-a",),
  stacked-key: ("tint-a",), swiss-bands: ("tint-a", "tint-b", "tint-c", "tint-d"), glyph: ("tint-a", "tint-b"))

// la frase: `main`, o el epígrafe, o el verso, o el contenido suelto
#let _phrase(ctx) = {
  let p = ctx.parts
  glitcher.plain(if "main" in p { p.main.body } else if "epigraph" in p { p.epigraph.body } else if "verse" in p { p.verse.body } else { ctx.loose })
}

// la firma de un texto: el autor y la fuente, apilados. Todo en k de WallTypst; los valores por defecto son los de `b-cita`
#let _signature(ctx, au, wk, k, size: 60, min-size: 18, step: 3.4, ratio: 1.618, tracking: 0.18, weight: 700,
    font: "Hanken Grotesk", case: "upper", dash: "", source-style: "normal", align-to: left,
    author-color: auto, source-color: auto) = {
  let fs = calc.max(min-size * k, size * k / calc.pow(ratio, step))
  let body-font = (ctx.font)(font)
  let author-text = if au == none { none } else {
    let t = [#dash#au.body]
    if case == "upper" { upper(t) } else if case == "smallcaps" { smallcaps(t) } else { t }
  }
  // como todo texto en WallTypst (`pinta`/`legible`): si el color no se lee sobre el papel, el de mayor contraste
  let readable(c) = legible(if c == auto { ctx.tm.ink } else { c }, ctx.tm.paper, ctx.tm.ink, fs)
  let pieces = (
    if au != none { text(font: body-font, size: fs, weight: weight, tracking: tracking * 1em, fill: readable(author-color), author-text) },
    if wk != none { text(font: body-font, size: fs, style: source-style, fill: readable(source-color), wk.body) },
  ).filter(x => x != none)
  stack(dir: ttb, spacing: fs * 0.5, ..pieces.map(x => align(align-to, x)))
}

// el texto de la cita o epígrafe: `main`, o el epígrafe, o el verso
#let _body(ctx) = {
  let p = ctx.parts
  if "main" in p { p.main.body } else if "epigraph" in p { p.epigraph.body } else if "verse" in p { p.verse.body } else { none }
}

// un glifo anclado en el lienzo, o en una celda (`cell`): `x`, `y` en fracciones de la caja; dx/dy en k
#let _glyph(ctx, sign, passes, k, font, size, x, y, anchor, seed, key, cell: none, dx: 0, dy: 0, style: "normal", weight: "regular",
    target-width: none, size-max: 99999, align-to: top + left) = {
  let g = glitcher.glyph(sign, passes, k, font: font, base: ctx.tm.ink, weight: weight, style: style, size: size,
    target-width: target-width, size-max: size-max, align-to: align-to, seed: seed, key: key)
  if cell == none {
    glitcher.at(ctx.width, ctx.height, x, y, anchor, dx: dx * k, dy: dy * k, g)
  } else {
    let (cw, ch) = (cell.w * 1pt, cell.h * 1pt)
    place(top + left, dx: cell.x * 1pt, dy: cell.y * 1pt, box(width: cw, height: ch, glitcher.at(cw, ch, x, y, anchor, dx: dx * k, dy: dy * k, g)))
  }
}

// la capitular doble de WallTypst: la inicial en `lines` líneas, con pasadas (cada una puede traer otra fuente),
// y la puntuación inicial colgada; `capitular` (V2, resources/dropcaps) la integra en el párrafo.
#let _dropcap-double(ctx, txt, s, k, lines: 3, font: "", style: "normal", passes: (), gap: 0.12) = context {
  let cs = txt.clusters()
  let i = cs.position(c => c.match(regex("[\p{L}\p{N}]")) != none)
  if i == none { return txt }
  let (pre, letter, rest) = (cs.slice(0, i).join(), cs.at(i), cs.slice(i + 1).join())
  let height = measure([x\ ] * lines).height
  let base = (font: font, weight: "regular", style: style, top-edge: "bounds", bottom-edge: "bounds", size: 100pt)
  let sz = 100pt * (height / measure(text(..base, letter)).height)
  let letter-box = glitcher.glyph(letter, passes, k, font: font, base: ctx.tm.accent, style: style, size-abs: sz, align-to: bottom + center)
  let letter-box = if pre == none or pre == "" { letter-box } else {
    box({
      place(top + left, dx: -measure(text(size: s, pre)).width - s * 0.08, text(size: s, fill: ctx.tm.accent, pre))
      letter-box
    })
  }
  capitular([#rest], letra: letter-box, alto: auto, hueco: s * gap)
}

// la retícula de las variantes de una palabra (columnas por aspecto; filas y margen según la plantilla)
#let _layout(width, height, ku, asp, rows: (apaisado: 8, vertical: 12), margin: (apaisado: 80, vertical: 56)) = reticula(
  width / 1pt, height / 1pt, ku, (columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick(rows, asp),
    gutter: 24, margin: pick(margin, asp), safe: "escritorio"))

// la palabra: una línea ajustada a su celda y anclada en ella
#let _word(c, word, passes, k, x, y, anchor, font, base, seed, key, weight: "regular", style: "normal", turn: 0, scale: 1, dy: 0pt) = {
  let (cw, ch) = (c.w * 1pt, c.h * 1pt)
  place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: cw, height: ch,
    glitcher.at(cw, ch, x, y, anchor, dy: dy, glitcher.line(word, cw, ch, passes, k, font: font, base: base,
      weight: weight, style: style, turn: turn, scale: scale, seed: seed, key: key))))
}

#let _rules(ctx, variant, seed) = {
  let part(k) = ctx.parts.at(k, default: none)
  let (width, height) = (ctx.width, ctx.height)
  let k = calc.min(width, height) / 1000
  let ku = k / 1pt
  let asp = aspect(width, height)
  let size = (width / 1pt, height / 1pt)

  if variant == "triple" {
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 12, vertical: 18), asp),
      gutter: 24, row-gutter: 0, margin: pick((apaisado: 70, vertical: 56), asp), safe: "escritorio"))
    let phrase = _phrase(ctx)
    let family = (ctx.font)("Bebas Neue")

    // tres palabras, una por tinta y fila; las filas se solapan y las tintas van al 82 %
    let rows = (
      (i: 1, tint: ctx.tm.tint-a, x: 0, y: 1, anchor: "bottom-left",
        cell: (apaisado: (col: 2, span: 11, row: 1, rows: 5), ultra: (col: 3, span: 14, row: 1, rows: 5), vertical: (col: 1, span: 6, row: 3, rows: 4))),
      (i: 2, tint: ctx.tm.tint-b, x: 1, y: 0.5, anchor: "right",
        cell: (apaisado: (col: 2, span: 11, row: 4, rows: 5), ultra: (col: 3, span: 14, row: 4, rows: 5), vertical: (col: 1, span: 6, row: 6, rows: 4))),
      (i: 3, tint: ctx.tm.tint-c, x: 0, y: 0, anchor: "top-left",
        cell: (apaisado: (col: 2, span: 11, row: 7, rows: 4), ultra: (col: 3, span: 14, row: 7, rows: 4), vertical: (col: 1, span: 6, row: 9, rows: 4))),
    )
    for r in rows {
      let c = cell(pick(r.cell, asp))
      let (cw, ch) = (c.w * 1pt, c.h * 1pt)
      let word = upper(glitcher.key-words(phrase, r.i, 3))
      place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: cw, height: ch,
        glitcher.at(cw, ch, r.x, r.y, r.anchor,
          glitcher.line(word, cw, ch, ((color: r.tint, opacity: 82%),), k, font: family, base: ctx.tm.ink))))
    }
    place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 8%),), size: size))

    let v = part("verse")
    if v != none {
      let work = part("work")
      let c = cell(pick((apaisado: (col: 7, span: 6, row: 11, rows: 2), ultra: (col: 10, span: 7, row: 11, rows: 2),
        vertical: (col: 1, span: 6, row: 14, rows: 5)), asp))
      let left-side = asp == "vertical"
      in-cell(c, if left-side { "bottom-left" } else { "bottom-right" }, verse-block(ctx, v.body, if work == none { none } else { work.body }, k,
        width: c.w / ku, height: c.h / ku, margin-x: 0, margin-y: 0, size: 24, min-size: 16, leading: 0.3, font: "Hanken Grotesk",
        weight: 600, ref-font: "Hanken Grotesk", ref-weight: 700, ref-tracking: 0.16, ref-step: 1, ref-min: 15,
        ref-color: ctx.tm.ink, gap: 12, align-to: if left-side { left } else { right }))
    }
  } else if variant in ("stacked", "outline", "stacked-key") {
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 8, vertical: 12), asp),
      gutter: 24, margin: pick((apaisado: 80, vertical: 56), asp), safe: "escritorio"))
    let phrase = upper(_phrase(ctx))
    // lo que cambia entre las dos: las pasadas, el tope de tamaño y el umbral de «frase larga»
    let cfg = if variant == "stacked-key" {
      (size-max: 0, threshold: 99999, passes: (
        (color: ctx.tm.tint-a, opacity: 32%, dx: 6, dy: 5),
        (color: ctx.tm.ink, mark: ctx.tm.tint-a),
      ))
    } else if variant == "stacked" {
      (size-max: 330, threshold: 160, passes: (
        (color: ctx.tm.tint-b, opacity: 65%, long: false, dx: (range: (5, 9)), dy: (range: (4, 7))),
        (color: ctx.tm.tint-a, opacity: 95%),
      ))
    } else {
      (size-max: 300, threshold: 150, passes: (
        (color: ctx.tm.tint-a, opacity: 85%, dx: (range: (6, 12)), dy: (range: (5, 9))),
        (color: ctx.tm.ink, stroke: ctx.tm.ink, width: 1.6, fill: false, long: false),
      ))
    }
    let c = cell(pick((apaisado: (col: 4, span: 9, row: 1, rows: 7), ultra: (col: 7, span: 10, row: 1, rows: 7),
      vertical: (col: 1, span: 6, row: 2, rows: 9)), asp))
    let (cw, ch) = (c.w * 1pt, c.h * 1pt)
    if variant == "stacked-key" {
      place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 7%),), size: size))
      let text-source = glitcher.plain(if "main" in ctx.parts { ctx.parts.main.body } else { ctx.loose })
      place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: cw, height: ch,
        glitcher.at(cw, ch, 0, 0.5, "left", glitcher.paragraph(phrase, cw, ch, cfg.passes, k,
          font: (ctx.font)("Bebas Neue"), base: ctx.tm.ink, size: 150, lead: 0.2,
          highlight: upper(glitcher.longest-word(text-source)), seed: seed, key: "p.layers.2.pasadas"))))
    } else {
      place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: cw, height: ch,
        glitcher.at(cw, ch, 0, 0, "top-left", glitcher.stacked(phrase, cw, ch, cfg.passes, k,
          font: (ctx.font)("Bebas Neue"), base: ctx.tm.ink, lines-max: 7, lead: 0.2, size-max: cfg.size-max,
          is-long: phrase.clusters().len() > cfg.threshold, seed: seed, key: "p.layers.1.pasadas"))))
    }
    // el grano: solo en `stacked` (contorno no tiene capa `ruido`)
    if variant == "stacked" { place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 8%),), size: size)) }

    // la firma: autor y fuente, abajo a la izquierda de su celda
    let (au, wk) = (part("author"), part("work"))
    if au != none or wk != none {
      let c = cell(pick((apaisado: (col: 4, span: 9, row: 8, rows: 1), ultra: (col: 7, span: 10, row: 8, rows: 1),
        vertical: (col: 1, span: 6, row: 12, rows: 1)), asp))
      in-cell(c, "bottom-left", block(width: c.w * 1pt, _signature(ctx, au, wk, k)))
    }
  } else if variant == "swiss-bands" {
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 8, vertical: 12), asp),
      gutter: 24, margin: pick((apaisado: 80, vertical: 56), asp), safe: "escritorio"))
    let c = cell(pick((apaisado: (col: 3, span: 10, row: 1, rows: 7), ultra: (col: 5, span: 12, row: 1, rows: 7),
      vertical: (col: 1, span: 6, row: 2, rows: 9)), asp))
    let (cw, ch) = (c.w * 1pt, c.h * 1pt)
    let tm = ctx.tm
    place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: cw, height: ch,
      glitcher.at(cw, ch, 0, 0.5, "left", glitcher.bands(upper(_phrase(ctx)), cw, ch,
        (tm.tint-a, tm.tint-b, tm.tint-c, tm.tint-d), (tm.paper, tm.paper, tm.paper, tm.ink),
        pick((apaisado: (0, 90, 30, 140, 60, 0), vertical: (0, 40, 10, 60, 20, 0)), asp), k,
        font: (ctx.font)("Bebas Neue"), fallback: tm.ink, pad: 0.3, sep: 0.14, size-max: 150, lines-max: 6))))
    let (au, wk) = (part("author"), part("work"))
    if au != none or wk != none {
      let c = cell(pick((apaisado: (col: 3, span: 10, row: 8, rows: 1), ultra: (col: 5, span: 12, row: 8, rows: 1),
        vertical: (col: 1, span: 6, row: 12, rows: 1)), asp))
      in-cell(c, "bottom-left", block(width: c.w * 1pt, _signature(ctx, au, wk, k)))
    }
  } else if variant == "glyph" {
    // un carácter gigante en dos tintas desplazadas, y la cita abajo a la derecha
    let with-text = "main" in ctx.parts
    let sign = if "glyph" in ctx.parts { glitcher.plain(ctx.parts.glyph.body) } else { glitcher.choose(("&", "§", "?", "*"), "p.vars.signo", seed) }
    let gx = if with-text { pick((apaisado: 0.36, vertical: 0.5), asp) } else { 0.55 }
    let gy = if with-text { pick((apaisado: 0.5, vertical: 0.32), asp) } else { 0.5 }
    glitcher.at(width, height, gx, gy, "center", glitcher.glyph(sign, (
      (color: ctx.tm.tint-a, opacity: 80%),
      (color: ctx.tm.tint-b, opacity: 70%, dx: 46, dy: 28),
    ), k, font: (ctx.font)("Bodoni Moda"), style: "italic", size: pick((apaisado: 1350, vertical: 1100), asp), seed: seed, key: "p.layers"))
    place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 9%),), size: size))

    if with-text {
      let (au, wk) = (part("author"), part("work"))
      let sig = if au != none or wk != none {
        _signature(ctx, au, wk, k, size: 104, min-size: 19, step: 3.6, tracking: 0.14, source-style: "italic", align-to: right)
      }
      place(bottom + right, dx: -80 * k, dy: -80 * k, verse-block(ctx, ctx.parts.main.body, none, k,
        width: pick((apaisado: 820, vertical: 900), asp), height: pick((apaisado: 520, vertical: 760), asp),
        size: 104, min-size: 52, leading: 0.2, font: "Bebas Neue", text-case: "upper", gap: 20, align-to: right, signature: sig))
    }
  } else if variant == "word" {
    let ku = k / 1pt
    let cell = _layout(width, height, ku, asp)
    let phrase = _phrase(ctx)
    let with-text = phrase != ""
    let tm = ctx.tm
    let c = cell(if with-text { pick((apaisado: (col: 3, span: 10, row: 1, rows: 5), ultra: (col: 5, span: 12, row: 1, rows: 5),
      vertical: (col: 1, span: 6, row: 2, rows: 5)), asp) } else { (col: 1, row: 2, rows: 6) })
    _word(c, if with-text { upper(glitcher.longest-word(phrase)) } else { "GRACIA" }, (
      (color: tm.tint-c, opacity: 70%, dx: (range: (-30, -18)), dy: 12),
      (color: tm.tint-b, opacity: 75%, dx: (range: (-16, -8)), dy: -8),
      (color: tm.tint-a, opacity: 85%),
    ), k, 1, 1, "bottom-right", (ctx.font)("Bebas Neue"), tm.ink, seed, "p.layers.1.pasadas")
    place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 8%),), size: size))
    if "main" in ctx.parts {
      let (au, wk) = (part("author"), part("work"))
      let c = cell(pick((apaisado: (col: 3, span: 10, row: 6, rows: 3), ultra: (col: 5, span: 12, row: 6, rows: 3),
        vertical: (col: 1, span: 6, row: 8, rows: 5)), asp))
      in-cell(c, "bottom-right", verse-block(ctx, ctx.parts.main.body, none, k, width: c.w / ku, height: calc.min(300, c.h / ku),
        margin-x: 0, margin-y: 0, size: 40, min-size: 26, leading: 0.3, weight: 600, font: "Hanken Grotesk", gap: 16, align-to: right,
        signature: if au != none or wk != none { _signature(ctx, au, wk, k, size: 40, min-size: 18, step: 2, tracking: 0.16, source-style: "italic", align-to: right) }))
    }
  } else if variant == "scale" {
    let ku = k / 1pt
    let cell = _layout(width, height, ku, asp)
    let phrase = _phrase(ctx)
    let with-text = phrase != ""
    let tm = ctx.tm
    let c = cell(pick((apaisado: (col: 3, span: 10, row: 1, rows: 8, bleed: "right"), ultra: (col: 5, span: 12, row: 1, rows: 8, bleed: "right"),
      vertical: (col: 1, span: 6, row: 1, rows: 12, bleed: true)), asp))
    _word(c, if with-text { upper(glitcher.longest-word(phrase)) } else { "GLORIA" }, ((color: tm.tint-a),), k,
      pick((apaisado: 0.62, vertical: 0.5), asp), 0.5, "center", (ctx.font)("Bebas Neue"), tm.ink, seed, "p.layers.1.pasadas",
      turn: pick((apaisado: 0, vertical: -90), asp), scale: if with-text { pick((apaisado: 1.25, vertical: 1.1), asp) } else { 0.9 })
    if with-text {
      let c = cell(pick((apaisado: (col: 6, span: 6, row: 2, rows: 5), ultra: (col: 9, span: 7, row: 2, rows: 5),
        vertical: (col: 1, span: 6, row: 3, rows: 7)), asp))
      let (cw, ch) = (c.w * 1pt, c.h * 1pt)
      place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: cw, height: ch,
        glitcher.at(cw, ch, 0, 0.5, "left", glitcher.paragraph(upper(phrase), cw, ch, (
          (color: tm.tint-b, opacity: 80%, dx: 5, dy: 4), (color: tm.ink),
        ), k, font: (ctx.font)("Bebas Neue"), base: tm.ink, size: 110, lead: 0.16, is-long: phrase.clusters().len() > 220))))
      let (au, wk) = (part("author"), part("work"))
      if au != none or wk != none {
        let c = cell(pick((apaisado: (col: 6, span: 6, row: 7, rows: 2), ultra: (col: 9, span: 7, row: 7, rows: 2),
          vertical: (col: 1, span: 6, row: 11, rows: 2)), asp))
        in-cell(c, "bottom-left", block(width: c.w * 1pt, _signature(ctx, au, wk, k, author-color: tm.tint-b, source-color: tm.ink)))
      }
    }
  } else if variant == "edge" {
    let ku = k / 1pt
    let cell = _layout(width, height, ku, asp)
    let phrase = _phrase(ctx)
    let with-text = phrase != ""
    let tm = ctx.tm
    let which = glitcher.choose(("primera", "larga", "ultima"), "p.vars.palabra", seed)
    let c = cell(if with-text { pick((apaisado: (col: 11, span: 2, row: 1, rows: 8, bleed: "y"), ultra: (col: 15, span: 2, row: 1, rows: 8, bleed: "y"),
      vertical: (col: 5, span: 2, row: 1, rows: 12, bleed: "y")), asp) } else { pick((apaisado: (col: 9, span: 4, row: 1, rows: 8, bleed: "y"),
      ultra: (col: 12, span: 5, row: 1, rows: 8, bleed: "y"), vertical: (col: 3, span: 4, row: 1, rows: 12, bleed: "y")), asp) })
    _word(c, if with-text { upper(glitcher.pick-word(phrase, which)) } else { "GRACIA" }, (
      (color: tm.tint-a, opacity: 85%, dx: -10, dy: 8),
      (color: tm.tint-b, stroke: tm.tint-b, width: 2, fill: false),
    ), k, 1, 0.5, "right", (ctx.font)("Bebas Neue"), tm.ink, seed, "p.layers.1.pasadas", turn: -90)
    let cb = cell(pick((apaisado: (col: 4, span: 6, row: 2, rows: 6), ultra: (col: 7, span: 7, row: 2, rows: 6),
      vertical: (col: 1, span: 4, row: 3, rows: 9)), asp))
    let (au, wk) = (part("author"), part("work"))
    if part("verse") != none {
      in-cell(cb, "bottom-left", verse-block(ctx, part("verse").body, if wk == none { none } else { wk.body }, k, width: cb.w / ku, height: cb.h / ku,
        margin-x: 0, margin-y: 0, size: 60, min-size: 30, leading: 0.28, font: "DM Serif Display", ref-font: "Hanken Grotesk", ref-weight: 700,
        ref-tracking: 0.18, ref-step: 3.2, ref-min: 18, ref-color: tm.ink, gap: 20, align-to: left))
    } else if part("epigraph") != none {
      in-cell(cb, "bottom-left", verse-block(ctx, part("epigraph").body, none, k, width: cb.w / ku, height: cb.h / ku,
        margin-x: 0, margin-y: 0, size: 60, min-size: 30, leading: 0.28, font: "DM Serif Display", gap: 20, align-to: left,
        signature: if au != none or wk != none { _signature(ctx, au, wk, k, size: 60, min-size: 18, step: 3.2, tracking: 0.18, source-style: "italic") }))
    }
  } else if variant == "fade" {
    let ku = k / 1pt
    let cell = _layout(width, height, ku, asp, rows: (apaisado: 10, vertical: 14), margin: (apaisado: 72, vertical: 56))
    let phrase = _phrase(ctx)
    let tm = ctx.tm
    place(top + left, superbg(((tipo: "gradiente", from: tm.paper, to: tm.tint-a, angulo: 90deg),
      (tipo: "ruido", color: white, opacidad: 9%)), size: size))
    let c = cell(pick((apaisado: (row: 6, rows: 4, bleed: true), vertical: (row: 9, rows: 6, bleed: true)), asp))
    _word(c, lower(if phrase != "" { glitcher.longest-word(phrase) } else { "gracia" }), ((color: tm.accent, opacity: 92%),), k,
      0.5, 1, "bottom", (ctx.font)("Fraunces"), tm.ink, seed, "p.layers.2.pasadas", weight: 600, style: "italic",
      dy: pick((apaisado: 40, vertical: -40), asp) * k)
    let v = part("verse")
    if v != none {
      let work = part("work")
      let cb = cell(pick((apaisado: (col: 6, span: 7, row: 1, rows: 5), ultra: (col: 9, span: 8, row: 1, rows: 5),
        vertical: (col: 1, span: 6, row: 2, rows: 7)), asp))
      let right-side = asp != "vertical"
      in-cell(cb, if right-side { "top-right" } else { "top-left" }, verse-block(ctx, v.body, if work == none { none } else { work.body }, k,
        width: cb.w / ku, height: cb.h / ku, margin-x: 0, margin-y: 0, size: 56, min-size: 30, leading: 0.34, font: "Literata",
        ref-font: "DM Mono", ref-tracking: 0.14, ref-step: 3, ref-min: 19, ref-color: tm.accent, rule: true, rule-length: 56, rule-width: 1.6,
        gap: 30, align-to: if right-side { right } else { left }))
    }
  } else if variant in ("initial", "circle", "monogram", "roman") {
    let tm = ctx.tm
    let body = _body(ctx)
    let text-plain = if body == none { "" } else { glitcher.plain(body) }
    let with-text = text-plain != ""
    let given = if "glyph" in ctx.parts { glitcher.plain(ctx.parts.glyph.body) } else { none }
    let bodoni = (ctx.font)("Bodoni Moda")
    // el bloque de texto (epígrafe) y su firma, por variante
    let (au, wk) = (part("author"), part("work"))
    if variant == "initial" {
      let sign = if given != none { given } else if with-text { glitcher.initial(text-plain) } else { glitcher.choose(("R", "G", "S", "A"), "p.layers.1.contenido", seed) }
      _glyph(ctx, sign, ((color: tm.accent),), k, bodoni, if with-text { pick((apaisado: 1150, vertical: 1050), asp) } else { 1400 },
        if with-text { pick((apaisado: 0.74, vertical: 0.6), asp) } else { pick((apaisado: 0.66, vertical: 0.55), asp) },
        if with-text { 0 } else { 0.5 }, if with-text { "top" } else { "center" }, seed, "p.layers.1.pasadas",
        dy: if with-text { -400 } else { 0 }, style: "italic")
      if body != none {
        block-at("bottom-right", 100, 90, k, verse-block(ctx, body, none, k, width: pick((apaisado: 900, vertical: 900), asp),
          height: pick((apaisado: 340, vertical: 700), asp), margin-x: 100, margin-y: 90, size: 58, min-size: 30, style: "italic",
          leading: 0.26, font: "Bodoni Moda", gap: 22, align-to: right,
          signature: _signature(ctx, au, wk, k, size: 58, min-size: 19, step: 3.4, tracking: 0.16, weight: 600, source-style: "italic",
            align-to: right, source-color: tm.quiet)))
      }
    } else if variant == "circle" {
      let r = pick((apaisado: 760, ultra: 700, vertical: 620), asp) * k
      let cx = pick((apaisado: 1.0, ultra: 0.9, vertical: 0.84), asp)
      let cy = pick((apaisado: 0.48, vertical: 0.32), asp)
      place(top + left, dx: cx * width - r, dy: cy * height - r, circle(radius: r, fill: tm.tint-a))
      let sign = if given != none { given } else if with-text { glitcher.initial(text-plain) } else { glitcher.choose(("R", "G", "S", "A"), "p.layers.2.contenido", seed) }
      _glyph(ctx, sign, ((color: tm.ink, opacity: 82%),), k, bodoni, pick((apaisado: 560, ultra: 540, vertical: 480), asp),
        pick((apaisado: 0.82, ultra: 0.8, vertical: 0.76), asp), cy, "center", seed, "p.layers.2.pasadas", style: "italic")
      place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 5%),), size: size))
      if body != none {
        let (mx, my) = (pick((apaisado: 200, vertical: 150), asp), pick((apaisado: 96, vertical: 70), asp))
        block-at("bottom-left", mx, my, k, verse-block(ctx, body, none, k, width: pick((apaisado: 640, vertical: 760), asp),
          height: pick((apaisado: 420, vertical: 520), asp), margin-x: mx, margin-y: my, size: 62, min-size: 34, style: "italic",
          leading: 0.28, font: "Bodoni Moda", gap: 24, align-to: left,
          signature: _signature(ctx, au, wk, k, size: 62, min-size: 18, step: 3.2, tracking: 0.14, weight: 600, source-style: "italic")))
      }
    } else if variant == "monogram" {
      let word = if given != none { given } else { glitcher.choose(("REDEMPTIO", "MISERICORDIA", "SALUS", "GRATIA"), "p.vars.palabra", seed) }
      let target = pick((apaisado: 0.76, vertical: 0.88), asp) * width
      let gy = pick((apaisado: 0.36, vertical: 0.26), asp)
      _glyph(ctx, word, ((color: tm.tint-a, dx: -28, dy: 22),), k, (ctx.font)("Prata"), 1150, 0.5, gy, "center", seed, "p.layers.1.pasadas",
        target-width: target, size-max: 1500)
      _glyph(ctx, word, ((color: tm.tint-b, opacity: 85%, stroke: tm.tint-b, width: 5, fill: false, dx: 34, dy: -18),), k,
        (ctx.font)("Cormorant Garamond"), 1150, 0.5, gy, "center", seed, "p.layers.2.pasadas", style: "italic", target-width: target, size-max: 1500)
      place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 6%),), size: size))
      if body != none {
        block-at("bottom-right", 100, 90, k, verse-block(ctx, body, none, k, width: pick((apaisado: 880, vertical: 900), asp),
          height: pick((apaisado: 340, vertical: 680), asp), margin-x: 100, margin-y: 90, size: 56, min-size: 28, style: "italic",
          leading: 0.24, font: "Cormorant Garamond", gap: 20, align-to: right,
          signature: _signature(ctx, au, wk, k, size: 56, min-size: 18, step: 3.4, tracking: 0.16, weight: 600, source-style: "italic", align-to: right)))
      }
    } else {
      // roman: grano, un numeral romano pálido y el epígrafe arriba a la derecha
      place(top + left, superbg(((tipo: "ruido", color: rgb("#5a4a30"), opacidad: 5%),), size: size))
      let sign = if given != none { given } else { glitcher.choose(("I", "II", "III", "IV", "V", "VII", "IX", "XII"), "p.layers.2.contenido", seed) }
      _glyph(ctx, sign, ((color: tm.tint-a),), k, (ctx.font)("Cormorant Garamond"), 620, pick((apaisado: 0.66, vertical: 0.5), asp),
        pick((apaisado: 0.66, vertical: 0.6), asp), "center", seed, "p.layers.2.pasadas", weight: 300)
      if body != none {
        block-at("top-right", 120, 150, k, verse-block(ctx, body, none, k, width: 720, height: 480, margin-x: 120, margin-y: 150, size: 50,
          min-size: 30, style: "italic", leading: 0.38, font: "EB Garamond 12", gap: 22, align-to: right, rule: true, rule-length: 40,
          rule-width: 1.2, ref-color: tm.quiet,
          signature: _signature(ctx, au, wk, k, size: 50, min-size: 20, step: 1.6, ratio: 1.333, tracking: 0.04, weight: 400, font: "EB Garamond 12",
            case: "smallcaps", dash: "— ", source-style: "italic", align-to: right, source-color: tm.quiet)))
      }
    }
  } else if variant in ("quote", "quote-echo") {
    let ku = k / 1pt
    let tm = ctx.tm
    let body = _body(ctx)
    let with-text = body != none
    let (au, wk) = (part("author"), part("work"))
    let cell = _layout(width, height, ku, asp, margin: if variant == "quote" { (apaisado: 90, vertical: 64) } else { (apaisado: 80, vertical: 56) })
    if variant == "quote" {
      let gc = if with-text {
        cell((col: 1, span: pick((apaisado: 5, ultra: 7, vertical: 6), asp), row: 1, rows: 4, bleed: true, safe: false))
      } else { cell((safe: false)) }
      _glyph(ctx, "“", ((color: tm.tint-a),), k, (ctx.font)("DM Serif Display"), pick((apaisado: 1500, vertical: 1300), asp),
        if with-text { 0 } else { 0.5 }, if with-text { 0 } else { 0.45 }, if with-text { "top-left" } else { "center" }, seed, "p.layers.1.pasadas",
        cell: gc, dx: if with-text { -60 } else { 0 }, dy: if with-text { -30 } else { 0 })
      place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 7%),), size: size))
      if with-text {
        let c = cell(pick((apaisado: (col: 6, span: 7, row: 2, rows: 6), ultra: (col: 9, span: 8, row: 2, rows: 6), vertical: (col: 1, span: 6, row: 5, rows: 8)), asp))
        in-cell(c, if asp == "vertical" { "bottom-left" } else { "left" }, verse-block(ctx, body, none, k, width: c.w / ku, height: c.h / ku,
          margin-x: 0, margin-y: 0, size: 120, min-size: 56, leading: 0.2, font: "Bebas Neue", text-case: "upper", gap: 26, align-to: left,
          signature: _signature(ctx, au, wk, k, size: 120, min-size: 20, step: 3.2, tracking: 0.14, weight: 600, source-style: "italic",
            author-color: tm.tint-b, source-color: tm.ink)))
      }
    } else {
      let size-g = pick((apaisado: 460, vertical: 400), asp)
      let c1 = cell(pick((apaisado: (col: 2, span: 2, row: 1, rows: 3), ultra: (col: 3, span: 2, row: 1, rows: 3), vertical: (col: 1, span: 2, row: 2, rows: 3)), asp))
      let c2 = cell(pick((apaisado: (col: 11, span: 2, row: 6, rows: 3), ultra: (col: 13, span: 2, row: 6, rows: 3), vertical: (col: 5, span: 2, row: 10, rows: 3)), asp))
      _glyph(ctx, "“", ((color: tm.accent),), k, (ctx.font)("Bodoni Moda"), size-g, 0, 0, "top-left", seed, "p.layers.1.pasadas",
        cell: c1, dy: -30, weight: 700)
      _glyph(ctx, "”", ((color: tm.ink, stroke: tm.ink, width: 2.4, fill: false),), k, (ctx.font)("Cormorant Garamond"), size-g, 1, 1, "bottom-right", seed,
        "p.layers.2.pasadas", cell: c2)
      place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 6%),), size: size))
      if with-text {
        let c = cell(pick((apaisado: (col: 4, span: 7, row: 2, rows: 6), ultra: (col: 6, span: 8, row: 2, rows: 6), vertical: (col: 1, span: 6, row: 4, rows: 6)), asp))
        in-cell(c, "center", verse-block(ctx, body, none, k, width: c.w / ku, height: c.h / ku, margin-x: 0, margin-y: 0, size: 70, min-size: 34,
          leading: 0.3, font: "Fraunces", gap: 22, align-to: center,
          signature: _signature(ctx, au, wk, k, size: 70, min-size: 20, step: 3.2, tracking: 0.14, weight: 600, source-style: "italic",
            align-to: center, author-color: tm.accent, source-color: tm.quiet)))
      }
    }
  } else if variant == "quote-mark" {
    let tm = ctx.tm
    let body = _body(ctx)
    place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 9%), (tipo: "vignette", color: black, intensidad: 30%)), size: size))
    // (la comilla de fondo solo se dibuja sin texto)
    if body == none {
      _glyph(ctx, "“", ((color: tm.ink, opacity: 10%),), k, (ctx.font)("DM Serif Display"), 900, pick((apaisado: 0.7, vertical: 0.55), asp), 0.42, "center", seed, "p.layers.2.pasadas")
    } else {
      let (au, wk) = (part("author"), part("work"))
      let mark = move(dx: -6 * k, text(font: (ctx.font)("DM Serif Display"), size: 360 * k, fill: tm.accent, top-edge: "bounds", bottom-edge: "bounds", "“"))
      block-at("right", 110, 110, k, verse-block(ctx, body, none, k, width: pick((apaisado: 780, vertical: 860), asp),
        height: pick((apaisado: 640, vertical: 1000), asp), margin-x: 110, margin-y: 110, size: 60, min-size: 28, weight: 400, leading: 0.3,
        font: "Fraunces", gap: 30, align-to: left, mark: mark,
        signature: _signature(ctx, au, wk, k, size: 60, min-size: 20, step: 2, tracking: 0.04, weight: 400, font: "Fraunces", case: "smallcaps",
          dash: "— ", source-style: "italic", author-color: tm.accent, source-color: tm.ink)))
    }
  } else if variant in ("twin", "grotesque") {
    let ku = k / 1pt
    let tm = ctx.tm
    let cfg = if variant == "twin" {
      (style: "italic", justify: true, case: "smallcaps", display: "Bodoni Moda", body: "EB Garamond 12", eco: "Cormorant Garamond")
    } else {
      (style: "normal", justify: false, case: "upper", display: "Bebas Neue", body: "Hanken Grotesk", eco: "Outfit")
    }
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 12, vertical: 16), asp),
      gutter: 24, margin: pick((apaisado: 64, vertical: 56), asp), safe: "escritorio"))
    let body = _body(ctx)
    let text-plain = if body == none { "" } else { glitcher.plain(body) }
    let with-text = text-plain != ""
    let sign = if "glyph" in ctx.parts { glitcher.plain(ctx.parts.glyph.body) } else if with-text { glitcher.initial(text-plain) } else { "G" }
    let gc = if with-text {
      cell(pick((apaisado: (col: 4, span: 6, row: 1, rows: 5, bleed: "top"), ultra: (col: 6, span: 6, row: 1, rows: 5, bleed: "top"),
        vertical: (col: 1, span: 6, row: 1, rows: 6, bleed: "top")), asp))
    } else { cell((safe: false)) }
    _glyph(ctx, sign, (
      (color: tm.accent, opacity: 85%, dx: 14, dy: 10),
      (font: (ctx.font)(cfg.eco), stroke: tm.ink, width: 2.2, fill: false),
    ), k, (ctx.font)(cfg.display), if with-text { 520 } else { 900 }, 0.5, if with-text { 1 } else { 0.5 },
      if with-text { "bottom" } else { "center" }, seed, "p.layers.1.pasadas", cell: gc, style: cfg.style, align-to: bottom + center)
    if with-text {
      let (au, wk) = (part("author"), part("work"))
      let cb = cell(pick((apaisado: (col: 4, span: 6, row: 7, rows: 6), ultra: (col: 6, span: 6, row: 7, rows: 6),
        vertical: (col: 1, span: 6, row: 8, rows: 8)), asp))
      let capital(s) = _dropcap-double(ctx, text-plain, s, k, lines: 3, font: (ctx.font)(cfg.display), style: cfg.style, passes: (
        (color: tm.accent, opacity: 85%, dx: 3, dy: 2),
        (font: (ctx.font)(cfg.eco), stroke: tm.ink, width: 0.8, fill: false),
      ))
      let is-verse = part("verse") != none
      in-cell(cb, "top", verse-block(ctx, capital, if is-verse and wk != none { wk.body } else { none }, k, width: cb.w / ku, height: cb.h / ku,
        margin-x: 0, margin-y: 0, size: 46, min-size: 24, leading: 0.4, font: cfg.body, justify: cfg.justify, hyphenate: cfg.justify,
        ref-font: cfg.body, ref-case: cfg.case, ref-tracking: 0.08, ref-step: 2, ref-min: 20, ref-color: tm.accent, ref-align: center,
        gap: 26, align-to: left,
        signature: if not is-verse and (au != none or wk != none) {
          _signature(ctx, au, wk, k, size: 46, min-size: 20, step: 2, tracking: 0.04, weight: 400, font: cfg.body, case: cfg.case,
            source-style: "italic", author-color: tm.accent, source-color: tm.ink)
        }))
    }
  } else if variant == "poster" {
    // un signo gigante (cursiva) y el título abajo a la derecha; el signo cede el centro si hay título
    let tm = ctx.tm
    let with-text = "main" in ctx.parts
    let sign = if "glyph" in ctx.parts { glitcher.plain(ctx.parts.glyph.body) } else { glitcher.choose(("&", "?", "§", "&"), "p.layers.1.contenido", seed) }
    _glyph(ctx, sign, ((color: tm.tint-a),), k, (ctx.font)("Bodoni Moda"), pick((apaisado: 1350, vertical: 1150), asp),
      if with-text { pick((apaisado: 0, vertical: 0.5), asp) } else { pick((apaisado: 0.66, vertical: 0.55), asp) },
      if with-text { pick((apaisado: 0.52, vertical: 0.3), asp) } else { pick((apaisado: 0.5, vertical: 0.4), asp) },
      if with-text { pick((apaisado: "left", vertical: "center"), asp) } else { "center" }, seed, "p.layers.1.pasadas",
      dx: if with-text and asp != "vertical" { -110 } else { 0 }, style: "italic")
    place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 7%),), size: size))
    if with-text {
      block-at("bottom-right", 76, 76, k, title-block(ctx, part("tag"), ctx.parts.main, part("subhead"), k, size: 150, ratio: 1.618, width: 900, margin: 76,
        leading: 0.14, gap: 14, sub-step: 4, kicker-step: 3, align-to: right, font: "Bebas Neue", sub-font: "Hanken Grotesk", sub-weight: 600,
        sub-case: "upper", sub-tracking: 0.14em))
    }
  }
  if ctx.brand != none { place(bottom + left, dx: 70 * k, dy: -70 * k, ctx.brand) }
}

#let variants = ("triple", "stacked", "outline", "stacked-key", "swiss-bands", "glyph", "word", "scale", "edge", "fade", "initial", "circle", "monogram", "roman", "quote", "quote-echo", "quote-mark", "twin", "grotesque", "poster")

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  variant: "triple",
  seed: 1,
  ..elements,
) = {
  let variant = if variant == auto { "triple" } else { variant }
  assert(variant in variants, message: "anaglyph: variante desconocida " + repr(variant) + " (hay: " + variants.join(", ") + ")")
  scaffold(
    body,
    artboard: artboard,
    theme: theme,
    accent: accent,
    brand: brand,
    fonts: fonts,
    default-theme: _themes.at(variant),
    default-fonts: none,
    extra-roles: _extra.at(variant),
    known: ("main", "epigraph", "verse", "author", "work", "glyph", "tag", "subhead", "brand"),
    fn: "anaglyph",
    elements: elements,
    rules: ctx => _rules(ctx, variant, seed),
  )
}

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "anaglyph", make: make, variants: variants, artboard: (1920, 1080))
#let anaglyph = frame.with(preset: preset)
