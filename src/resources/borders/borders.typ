// ─────────────────────────────────────────────────────────────
//  resources/borders/borders.typ — el lienzo con orla de fleurones
//
//  Lo comparten bordered-quote, bordered-chapter y bordered-question (en v1,
//  `lienzo-orlado` de orlas.typ y los dos temas de la orla). Aquí vive lo que
//  las tres repetirían: los temas «vino» y «papel», el dibujo de la orla y del
//  marco, el campo donde cada preset pone su composición y el pie común.
//
//  Este recurso aún no tiene nombre ni opciones decididas (la tabla lo llama
//  `border`, sin implementar): las tres lo llaman con sus argumentos de v1.
//
//  El motor de ornamentos (modules/fleurones) NO se importa aquí: una capa de
//  `resources/` solo puede importar otros recursos y `theme-v1`. El preset lo
//  importa y pasa el módulo como `fl`.
//
//  Temas. Cada uno trae los cinco roles de siempre (paper, ink, quiet, accent;
//  `guide` lo deriva modules/color si nadie lo da) y `deep` (v1 `hondo`, el
//  color del marco y de los filetes gruesos): el rol propio que los presets
//  declaran en `extra-roles`. Los otros cuatro colores de la orla (v1 `malla`,
//  `franja`, `orn`, `fil`) no tienen nombre en inglés en la tabla ni en las
//  decisiones: no se inventan; quedan aquí, internos, con su nombre de v1 y su
//  valor de v1 (decisión pendiente). Como en v1, si el tema del usuario cambia
//  paper, ink o accent, se derivan del tema nuevo con las mismas mezclas.
// ─────────────────────────────────────────────────────────────

// Los roles de cada tema, con el nombre que entiende `theme:` del frame.
#let themes = (
  vino: (
    paper: rgb("#5a1220"), ink: rgb("#f0d8d2"), quiet: rgb("#d4a9a2"),
    accent: rgb("#e2bdb5"), deep: rgb("#3e0a15"),
  ),
  papel: (
    paper: rgb("#f6efe4"), ink: rgb("#2b1916"), quiet: rgb("#6b4a44"),
    accent: rgb("#6b1d1d"), deep: rgb("#6b1d1d"),
  ),
)

// Los colores internos de la orla (nombres de v1; pendiente nombrarlos).
#let _inner-themes = (
  vino: (malla: rgb("#661a28"), franja: rgb("#732232"), orn: rgb("#86303d"), fil: rgb("#a24c57")),
  papel: (malla: rgb("#eee2d1"), franja: rgb("#e6d3bd"), orn: rgb("#8e3b3b"), fil: rgb("#8e3b3b")),
)

#let _mix(a, b, p) = color.mix((a, 100% - p), (b, p))

// El `theme:` que se le pasa al scaffold. Un nombre del recurso es su
// diccionario de roles; un diccionario parcial parte de «vino» (como v1, que
// siempre resolvía contra «vino» aunque el preset tuviera otro por defecto) y,
// si cambia `accent` sin dar `deep`, deriva `deep` del acento (como v1).
#let theme-arg(theme) = {
  if type(theme) == str and theme in themes { themes.at(theme) }
  else if type(theme) == dictionary {
    let out = themes.vino + theme
    if "deep" not in theme and "accent" in theme and type(theme.accent) == color and theme.accent != themes.vino.accent {
      out.insert("deep", _mix(theme.accent, black, 35%))
    }
    out
  }
  else { theme }
}

// El tema base contra el que se compara para derivar los colores internos:
// el nombre dado, el del preset si no se dio tema, o «vino» (como v1).
#let base-of(theme, default) = if theme == auto { default } else if type(theme) == str and theme in themes { theme } else { "vino" }

// Los colores internos del tema ya resuelto `tm`: los del tema base, o, si
// `tm` cambió los roles de los que dependen, derivados de `tm` (como v1).
#let inner-colors(tm, base) = {
  let b = themes.at(base)
  let out = _inner-themes.at(base)
  let changed(..roles) = roles.pos().any(r => tm.at(r) != b.at(r))
  if changed("paper", "ink") {
    out.insert("malla", _mix(tm.paper, tm.ink, 6%))
    out.insert("franja", _mix(tm.paper, tm.ink, 13%))
  }
  if changed("paper", "accent") {
    out.insert("orn", _mix(tm.paper, tm.accent, 55%))
    out.insert("fil", _mix(tm.paper, tm.accent, 75%))
  }
  out
}

// «cuadrado», «vertical» o «historia» (alto ≥ 1,6 × ancho).
#let format-kind(w, h) = if h >= 1.6 * w { "historia" } else if h > w { "vertical" } else { "cuadrado" }

// Largo aproximado (en caracteres) de un contenido, para ajustar el cuerpo.
#let text-length(x) = {
  if type(x) == str { x.len() }
  else if x.has("text") { text-length(x.text) }
  else if x.has("children") { x.children.map(text-length).sum(default: 0) }
  else if x.has("body") { text-length(x.body) }
  else if x.func() == [ ].func() { 1 }
  else { 0 }
}

// Pie común dentro del campo: roseta y, si hay, la firma.
#let footer-block(fl, c, font-sc, brand) = align(center)[
  #fl.roseta(46pt, c.orn)
  #if brand != none {
    v(16pt)
    text(font: font-sc, size: 24pt, tracking: 0.18em, fill: c.quiet)[#brand]
  }
]

// ── Lienzo: orla + campo. `body-fn` recibe (c, ancho, alto, tipo). ──
//   fl        el módulo fleurones
//   ctx       el contexto del scaffold (width, height, tm)
//   inner     los colores internos (inner-colors)
//   font      la familia del texto
//   border    qué lados llevan orla: "completa", "arriba", "abajo",
//             "arriba-abajo", "izquierda", "derecha", "lateral", "columna",
//             "ninguna"
//   chain     un marco de `fleurones.cadenas`
#let bordered-canvas(fl, ctx, inner, font, border, chain, body-fn) = {
  let (W, H) = (ctx.width, ctx.height)
  let tipo = format-kind(W / 1pt, H / 1pt)
  let c = ctx.tm + inner
  let M = 34pt
  let T = fl.cadenas.at(chain).grosor
  let G = fl.grosor-tira(chain)
  let libre = 70pt // margen de los lados sin orla
  let tira(largo) = fl.tira(largo, chain, c.orn, c.deep, c.fil)
  set text(font: font, fill: c.ink, lang: "es", hyphenate: false)
  set par(justify: false, first-line-indent: 0pt, spacing: 0pt)
  if border == "completa" {
    place(top + left, dx: M, dy: M, fl.orla(chain, W - 2 * M, H - 2 * M, c.orn))
    place(top + left, dx: M - 6pt, dy: M - 6pt,
      rect(width: W - 2 * M + 12pt, height: H - 2 * M + 12pt, stroke: 1.2pt + c.deep))
    place(top + left, dx: M + T + 7pt, dy: M + T + 7pt,
      rect(width: W - 2 * (M + T + 7pt), height: H - 2 * (M + T + 7pt), stroke: 2pt + c.deep))
    place(top + left, dx: M + T + 13pt, dy: M + T + 13pt,
      rect(width: W - 2 * (M + T + 13pt), height: H - 2 * (M + T + 13pt), stroke: 0.9pt + c.fil))
    let X = M + T + 13pt
    if tipo == "historia" {
      // franjas de malla arriba y abajo: la zona que tapa la interfaz
      let zona = 150pt
      let wc = W - 2 * X
      for (dy, al) in ((X, top), (H - X - zona, bottom)) {
        place(top + left, dx: X, dy: dy, fl.diaper(fl.f1, "AD", wc, zona, 75pt, c.franja))
        let yl = if al == top { dy + zona } else { dy }
        place(top + left, dx: X, dy: yl - 5pt, line(length: wc, stroke: 2pt + c.deep))
        place(top + left, dx: X, dy: yl + 1pt, line(length: wc, stroke: 0.9pt + c.fil))
      }
    }
    place(top + left, dx: X, dy: X, box(width: W - 2 * X, height: H - 2 * X, body-fn(c, W - 2 * X, H - 2 * X, tipo)))
  } else {
    let lados = (
      arriba: ("t",), abajo: ("b",), "arriba-abajo": ("t", "b"),
      izquierda: ("l",), derecha: ("r",), lateral: ("l", "r"),
      columna: ("col",), ninguna: (),
    ).at(border)
    let col = if tipo == "cuadrado" { 210pt } else { 240pt }
    // márgenes del campo
    let mt = if "t" in lados { M + G + 30pt } else { libre }
    let mb = if "b" in lados { M + G + 30pt } else { libre }
    let ml = if "l" in lados { M + G + 30pt } else if "col" in lados { col + G + 40pt } else { libre }
    let mr = if "r" in lados { M + G + 30pt } else { libre }
    if "t" in lados { place(top + left, dx: M, dy: M, tira(W - 2 * M)) }
    if "b" in lados { place(top + left, dx: M, dy: H - M - G, rotate(180deg, tira(W - 2 * M))) }
    if "l" in lados {
      place(top + left, dx: M, dy: M, box(width: G, height: H - 2 * M,
        place(center + horizon, rotate(-90deg, reflow: true, tira(H - 2 * M)))))
    }
    if "r" in lados {
      place(top + left, dx: W - M - G, dy: M, box(width: G, height: H - 2 * M,
        place(center + horizon, rotate(90deg, reflow: true, tira(H - 2 * M)))))
    }
    if "col" in lados {
      // columna de malla a sangre, cerrada por la tira a su derecha
      place(top + left, fl.diaper(fl.f1, "AD", col, H, 80pt, c.franja))
      place(top + left, dx: col, dy: 0pt, box(width: G, height: H,
        place(center + horizon, rotate(90deg, reflow: true, tira(H)))))
    }
    place(top + left, dx: ml, dy: mt,
      box(width: W - ml - mr, height: H - mt - mb, body-fn(c, W - ml - mr, H - mt - mb, tipo)))
  }
}
