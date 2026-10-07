// ─────────────────────────────────────────────────────────────
//  docs/funciones.typ — Referencia de funciones públicas
//  Generado desde src/*.typ — cada función con explicación y código fuente.
//  Compilar: typst compile --root . --font-path Fonts docs/funciones.typ docs/funciones.pdf
// ─────────────────────────────────────────────────────────────

#import "../src/lib.typ": *

#set page(paper: "a4", margin: 2cm, fill: rgb("#fdfbf7"))
#set text(font: theme.base.fonts.body, size: 9.5pt, fill: theme.base.colors.dark, lang: "es")
#set par(justify: true, leading: 0.78em, spacing: 1em)
#set heading(numbering: "1.")
#show raw.where(block: false): it => box(fill: luma(94%), inset: (x: 3pt, y: 1.5pt), radius: 3pt, text(size: 8.5pt, it))

= Referencia de funciones

Cada función pública de `src/*.typ` (sin prefijo `_`), documentada con qué hace, qué parámetros acepta y el código fuente completo tal cual está en el proyecto.

== Tema — `theme.typ`

=== `validate`

`src/theme.typ:46`

```typ
#let validate(t) = {
  for k in required-colors {
    if not k in t.colors { panic("falta el color requerido: " + k) }
  }
  for k in required-fonts {
    if not k in t.fonts { panic("falta la fuente requerida: " + k) }
  }
  t
}
```

=== `define`

`src/theme.typ:59`

```typ
#let define(name, colors: (:), fonts: (:)) = {
  let t = (name: name, colors: base.colors + colors, fonts: base.fonts + fonts)
  validate(t)
  t
}
```

=== `with-color`

`src/theme.typ:66`

```typ
#let with-color(t, key, value) = {
  let colors = t.colors
  colors.insert(key, value)
  validate((name: t.name, colors: colors, fonts: t.fonts))
}
```

=== `with-font`

`src/theme.typ:73`

```typ
#let with-font(t, kind, family) = {
  let fonts = t.fonts
  fonts.insert(kind, if type(family) == array { family } else { (family,) })
  validate((name: t.name, colors: t.colors, fonts: fonts))
}
```

=== `with`

`src/theme.typ:80`

```typ
#let with(t, colors: (:), fonts: (:)) = validate((
  name: t.name,
  colors: t.colors + colors,
  fonts: t.fonts + fonts,
))
```

=== `named`

`src/theme.typ:87`

```typ
#let named(t, name) = (name: name, colors: t.colors, fonts: t.fonts)
```

=== `color`

`src/theme.typ:91`

```typ
#let color(key, t: base) = {
  if not (key in t.colors) { panic("color desconocido: " + key) }
  t.colors.at(key)
}
```

=== `font`

`src/theme.typ:96`

```typ
#let font(kind, t: base) = {
  if not (kind in t.fonts) { panic("fuente desconocida: " + kind) }
  t.fonts.at(kind)
}
```

=== `colors`

`src/theme.typ:101`

```typ
#let colors(t: base) = t.colors
```

=== `fonts`

`src/theme.typ:102`

```typ
#let fonts(t: base) = t.fonts
```

=== `lighten`

`src/theme.typ:105`

```typ
#let lighten(key, amount, t: base) = color(key, t: t).lighten(amount)
```

=== `darken`

`src/theme.typ:106`

```typ
#let darken(key, amount, t: base) = color(key, t: t).darken(amount)
```

=== `fade`

`src/theme.typ:107`

```typ
#let fade(key, opacity, t: base) = color(key, t: t).transparentize(100% - opacity)
```

=== `luminance`

`src/theme.typ:120`

```typ
#let luminance(c) = {
  let comps = c.components()
  let r = comps.at(0)
  let g = comps.at(1, default: r)
  let b = comps.at(2, default: r)
  0.2126 * _chan(r) + 0.7152 * _chan(g) + 0.0722 * _chan(b)
}
```

=== `contrast`

`src/theme.typ:129`

```typ
#let contrast(a, b) = {
  let l1 = luminance(a)
  let l2 = luminance(b)
  (calc.max(l1, l2) + 0.05) / (calc.min(l1, l2) + 0.05)
}
```

=== `is-aa`

`src/theme.typ:136`

```typ
#let is-aa(a, b) = contrast(a, b) >= 4.5
```

=== `is-aaa`

`src/theme.typ:137`

```typ
#let is-aaa(a, b) = contrast(a, b) >= 7.0
```

=== `readable-on`

`src/theme.typ:140`

```typ
#let readable-on(bg, ..candidates) = {
  let best = none
  let best-r = -1.0
  for c in candidates.pos() {
    let r = contrast(c, bg)
    if r > best-r {
      best-r = r
      best = c
    }
  }
  best
}
```

=== `export`

`src/theme.typ:156`

```typ
#let export(t, path) = {
  let cs = (:)
  for (k, v) in t.colors { cs.insert(k, v.to-hex()) }
  json(path, (name: t.name, colors: cs, fonts: t.fonts))
}
```

=== `load`

`src/theme.typ:163`

```typ
#let load(path) = {
  let data = json(path)
  let cs = (:)
  for (k, hexv) in data.colors { cs.insert(k, rgb(hexv)) }
  define(data.name, colors: cs, fonts: data.fonts)
}
```

== Tokens de color — `tokens.typ`

=== `token`

`src/tokens.typ:115`

```typ
#let token(key) = {
  if not (key in tokens) { panic("token de color desconocido: " + key + " — ver tokens.keys()") }
  tokens.at(key)
}
```

== Paletas — `palettes.typ`

=== `names`

`src/palettes.typ:43`

```typ
#let names() = library.keys()
```

=== `get`

`src/palettes.typ:48`

```typ
#let get(name) = {
  if not (name in library) {
    panic("paleta desconocida: " + name + " — disponibles: " + names().join(", "))
  }
  library.at(name).map(_resolve)
}
```

=== `mix`

`src/palettes.typ:57`

```typ
#let mix(..items) = items.pos().map(_resolve)
```

=== `luminance`

`src/palettes.typ:63`

```typ
#let luminance(c) = {
  let x = c.components()
  let f(v) = {
    let u = v / 100
    if u <= 4.045% { u / 12.92 } else { calc.pow((u + 5.5%) / 105.5%, 2.4) }
  }
  let r = x.at(0)
  let g = x.at(1, default: r)
  let b = x.at(2, default: r)
  21.26% * f(r) + 71.52% * f(g) + 7.22% * f(b)
}
```

=== `saturation`

`src/palettes.typ:76`

```typ
#let saturation(c) = {
  let x = c.components()
  let r = x.at(0) / 100
  let g = x.at(1, default: x.at(0)) / 100
  let b = x.at(2, default: x.at(0)) / 100
  calc.max(r, g, b) - calc.min(r, g, b)
}
```

=== `auto-roles`

`src/palettes.typ:88`

```typ
#let auto-roles(cols) = {
  let sorted-l = cols.sorted(key: c => luminance(c))
  let dark = sorted-l.first()
  let light = sorted-l.last()

  let mids = cols.filter(c => c != dark and c != light)
  if mids.len() == 0 { mids = (dark,) }
  let ranked = mids.sorted(key: c => -saturation(c))

  let pick(i) = if i < ranked.len() { ranked.at(i) } else { ranked.at(calc.rem(i, ranked.len())) }

  (
    dark: dark,
    light: light,
    primary: pick(0),
    secondary: pick(1),
    accent: pick(2),
    white: white,
  )
}
```

=== `as-theme`

`src/palettes.typ:110`

```typ
#let as-theme(name) = (theme.define)(name, colors: auto-roles(get(name)))
```

=== `as-theme-manual`

`src/palettes.typ:113`

```typ
#let as-theme-manual(name, roles) = (theme.define)(name, colors: (
  primary: roles.at(0),
  secondary: roles.at(1),
  accent: roles.at(2),
  dark: roles.at(3),
  light: roles.at(4),
  white: white,
))
```

=== `swatch`

`src/palettes.typ:125`

```typ
#let swatch(name-or-colors, size: 26pt, show-hex: true) = {
  let cols = if type(name-or-colors) == array { name-or-colors } else { get(name-or-colors) }
  let n = cols.len()
  grid(
    columns: (size,) * n,
    gutter: calc.min(8pt, 20pt / n),
    ..cols.map(c => stack(spacing: 3pt,
      box(circle(radius: size / 2 - 1pt, fill: c, stroke: 0.5pt + luma(60%))),
      if show-hex { align(center, text(size: calc.min(6pt, size * 0.24), fill: luma(35%), c.to-hex())) },
    ))
  )
}
```

=== `card`

`src/palettes.typ:139`

```typ
#let card(name, width: 250pt) = {
  let cols = get(name)
  let n = cols.len()
  let inner = width - 28pt
  let s = calc.min(34pt, (inner - calc.min(8pt, 20pt / n) * (n - 1)) / n)
  block(
    width: width,
    fill: white,
    stroke: 0.75pt + luma(85%),
    radius: 10pt,
    inset: 14pt,
  )[
    #text(size: 11pt, weight: "bold")[#name]
    #v(7pt)
    #swatch(cols, size: s)
  ]
}
```

=== `catalog`

`src/palettes.typ:158`

```typ
#let catalog(columns: 3, gutter: 16pt) = grid(
  columns: columns,
  column-gutter: gutter,
  row-gutter: gutter,
  ..names().map(n => card(n)),
)
```

== Tokens de fuente — `font-tokens.typ`

=== `token`

`src/font-tokens.typ:94`

```typ
#let token(key) = {
  if not (key in tokens) { panic("token de fuente desconocido: " + key + " — ver font-tokens.tokens.keys()") }
  tokens.at(key)
}
```

=== `family`

`src/font-tokens.typ:100`

```typ
#let family(key) = token(key).family
```

=== `by-category`

`src/font-tokens.typ:103`

```typ
#let by-category(cat) = tokens.keys().filter(k => tokens.at(k).category == cat)
```

=== `by-script`

`src/font-tokens.typ:109`

```typ
#let by-script(script) = tokens.keys().filter(k => script in tokens.at(k).at("scripts", default: ("latin",)))
```

== Parejas tipográficas — `font-pairings.typ`

=== `names`

`src/font-pairings.typ:28`

```typ
#let names() = library.keys()
```

=== `get`

`src/font-pairings.typ:29`

```typ
#let get(name) = {
  if not (name in library) {
    panic("pareja desconocida: " + name + " — disponibles: " + names().join(", "))
  }
  library.at(name)
}
```

=== `resolve`

`src/font-pairings.typ:38`

```typ
#let resolve(name) = {
  let roles = get(name)
  let out = (:)
  for (role, key) in roles { out.insert(role, family(key)) }
  out
}
```

=== `as-theme`

`src/font-pairings.typ:46`

```typ
#let as-theme(name, theme-name: none) = {
  let theme-name = if theme-name == none { name } else { theme-name }
  (theme.define)(theme-name, fonts: resolve(name))
}
```

=== `card`

`src/font-pairings.typ:64`

```typ
#let card(name, width: 230pt, size: 20pt) = {
  let roles = get(name)
  block(
    width: width, fill: white, stroke: 0.75pt + luma(85%), radius: 10pt, inset: 14pt,
  )[
    #text(size: 10pt, weight: "bold", font: "Inter")[#name]
    #v(8pt)
    #stack(spacing: 10pt, ..roles.pairs().map(((role, key)) => _sample(role, key, size)))
  ]
}
```

=== `catalog`

`src/font-pairings.typ:76`

```typ
#let catalog(columns: 2, gutter: 16pt) = grid(
  columns: columns,
  column-gutter: gutter,
  row-gutter: gutter,
  ..names().map(n => card(n)),
)
```

== Capitulares — `dropcaps.typ`

=== `capitular`

`src/dropcaps.typ:211`

```typ
#let capitular(
  cuerpo,
  letra: none,
  alto: 2,
  justificar: auto,
  hueco: 0.08em,
  sangria: 0pt,
  profundidad: 0,
  transformar: none,
  ..args-texto,
) = layout(reg => {
  let args = args-texto
  if alto != auto {
    if "top-edge" not in args.named() {
      args = arguments(..args, top-edge: "bounds")
    }
    if "bottom-edge" not in args.named() {
      args = arguments(..args, bottom-edge: "bounds")
    }
  }

  let (inicial, resto) = if letra != none {
    (letra, cuerpo)
  } else {
    let (l, r) = _extraer(cuerpo)
    assert(l != none, message: "el cuerpo no contiene ninguna letra inicial")
    (l, r)
  }

  if transformar != none {
    inicial = context transformar(inicial)
  }

  let alto-letra = if alto == auto {
    measure(text(..args.named(), inicial)).height
  } else {
    _resolver-alto(alto)
  }
  let prof = _resolver-alto(profundidad)

  let caja-letra = box(height: alto-letra + prof, _dimensionado(alto-letra, inicial, ..args))
  let ancho-letra = measure(caja-letra).width

  let justificar = if justificar == auto { par.justify } else { justificar }

  let acotado = box.with(width: reg.width - ancho-letra - hueco)

  let i = 1
  let posicion-top = 0pt
  let altura-previa = 0pt
  let (primera, segunda, sep) = while true {
    let (a, b, _) = _dividir(resto, i)
    let a = {
      set par(hanging-indent: sangria, justify: justificar)
      a
    }
    let altura = measure(acotado(a)).height
    let (_, nueva, _) = _dividir(a, -1)
    posicion-top = calc.max(
      posicion-top,
      altura - measure(nueva).height - par.leading.to-absolute(),
    )

    if posicion-top >= alto-letra + prof - 1e-6pt and altura > altura-previa {
      _dividir(resto, i - 1)
      break
    }

    if b == none {
      (a, none, none)
      break
    }

    i += 1
    altura-previa = altura
  }

  set par(justify: justificar)

  let hay-salto = type(sep) == content and sep.func() in (linebreak, parbreak)
  if not hay-salto {
    let s = _dividir(primera, -1).at(2)
    hay-salto = type(s) == content and s.func() in (linebreak, parbreak)
  }

  let ultimo-de-primera = _dividir(primera, -1).at(1)
  let primero-de-segunda = if segunda == none { none } else { _dividir(segunda, 1).at(0) }

  let envuelve(body-content) = if _en-linea(ultimo-de-primera) {
    box(body-content) + linebreak()
  } else {
    block(body-content)
  }

  envuelve(grid(
    column-gutter: hueco,
    columns: (ancho-letra, 1fr),
    caja-letra,
    {
      set par(hanging-indent: sangria)
      primera
      if not hay-salto and _en-linea(ultimo-de-primera) and _en-linea(primero-de-segunda) {
        linebreak(justify: justificar)
      }
    },
  ))

  if type(sep) == content and sep.func() in (linebreak, parbreak) { sep }

  segunda
})
```

== Plantilla editorial — `articulo.typ`

=== `make-theme`

`src/articulo.typ:25`

```typ
#let make-theme(paleta: none, tipografia: none, nombre: none) = {
  let t = theme.base
  if paleta != none { t = (theme.with)(t, colors: (palettes.as-theme)(paleta).colors) }
  if tipografia != none { t = (theme.with)(t, fonts: (pairings.resolve)(tipografia)) }
  let nombre = if nombre != none {
    nombre
  } else {
    (paleta, tipografia).filter(x => x != none).join("+")
  }
  if nombre != "" { t = (theme.named)(t, nombre) }
  t
}
```

=== `fondo-editorial`

`src/articulo.typ:48`

```typ
#let fondo-editorial(t) = {
  let ok = (theme.is-aa)(t.colors.primary, t.colors.light) and (theme.is-aa)(t.colors.dark, t.colors.light)
  if ok { t.colors.light } else { t.colors.white }
}
```

=== `articulo`

`src/articulo.typ:62`

```typ
#let articulo(
  titulo: none,
  categoria: none,
  autor: none,
  fecha: none,
  paleta: none,
  tipografia: none,
  paper: "a5",
  doc,
) = {
  let t = make-theme(paleta: paleta, tipografia: tipografia)
  _tema-activo.update(t)

  set page(paper: paper, margin: 2.2cm, fill: fondo-editorial(t), numbering: "1", number-align: center)
  set text(font: t.fonts.body, fill: t.colors.dark, size: 11pt, lang: "es")
  set par(justify: true, leading: 0.8em, first-line-indent: 1em, spacing: 1.1em)

  show heading.where(level: 1): it => block(above: 1.8em, below: 1em)[
    #set text(font: t.fonts.display, weight: 800, size: 17pt, fill: t.colors.primary)
    #set par(first-line-indent: 0pt)
    #it.body
  ]
  show heading.where(level: 2): it => block(above: 1.4em, below: 0.7em)[
    #set text(font: t.fonts.display, weight: 700, size: 13pt, fill: t.colors.primary)
    #set par(first-line-indent: 0pt)
    #it.body
  ]
  show link: it => text(fill: t.colors.secondary, it)

  if titulo != none {
    align(center)[
      #if categoria != none [
        #box(fill: t.colors.primary.transparentize(85%), inset: (x: 8pt, y: 3pt), radius: 8pt)[
          #text(font: t.fonts.body, size: 7.5pt, weight: 700, tracking: 0.12em, fill: t.colors.primary, upper(categoria))
        ]
        #v(0.6em)
      ]
      #text(font: t.fonts.display, weight: 900, size: 22pt, fill: t.colors.primary, titulo)
      #if autor != none or fecha != none [
        #v(0.5em)
        #text(font: t.fonts.body, size: 8.5pt, fill: t.colors.dark.transparentize(35%))[
          #if autor != none [#autor]
          #if autor != none and fecha != none [ · ]
          #if fecha != none [#fecha]
        ]
      ]
    ]
    v(1.6em)
  }

  doc
}
```

=== `primer-parrafo`

`src/articulo.typ:119`

```typ
#let primer-parrafo(body, alto: 3, ..args) = context {
  let t = _tema-activo.get()
  (capitular)(body, font: t.fonts.display, fill: t.colors.primary, alto: alto, ..args)
}
```

== Citas bíblicas — `scripture.typ`

=== `scripture`

`src/scripture.typ:15`

```typ
#let scripture(body) = {
  set text(font: family("public-sans"))
  set par(leading: 1em, hanging-indent: 1em)
  block(
    fill: luma(248),
    inset: 8pt,
    radius: 8pt,
    pad(x: 2em, y: 2em)[#body],
  )
}
```

=== `vs`

`src/scripture.typ:26`

```typ
#let vs(body) = {
  set text(font: family("eb-garamond"))
  super(typographic: true, baseline: -0.4em, size: 8pt)[*#body*]
}
```

=== `ch`

`src/scripture.typ:31`

```typ
#let ch(body) = {
  set text(font: family("public-sans"), size: 26pt, weight: "bold")
  box(inset: (x: 3pt, y: -50%))[#body]
}
```

=== `set-body-font`

`src/scripture.typ:36`

```typ
#let set-body-font(doc) = {
  set text(font: family("inter"))
  doc
}
```

=== `pasaje`

`src/scripture.typ:58`

```typ
#let pasaje(
  referencia,
  version: none,
  paleta: none,
  tipografia: none,
  capitular-alto: 2,
  doc,
) = {
  let t = make-theme(paleta: paleta, tipografia: tipografia)
  block(
    fill: fondo-editorial(t),
    stroke: (left: 3pt + t.colors.primary),
    inset: (x: 24pt, y: 20pt),
    radius: 4pt,
    width: 100%,
  )[
    #text(font: t.fonts.display, weight: 700, size: 13pt, fill: t.colors.primary, referencia)
    #if version != none [#text(font: t.fonts.body, size: 9pt, fill: t.colors.dark.transparentize(40%))[ (#version)]]
    #v(10pt)
    #set text(font: t.fonts.body, fill: t.colors.dark, size: 11pt)
    #set par(justify: true, leading: 0.85em, hanging-indent: 1em)
    #(capitular)(doc, font: t.fonts.display, fill: t.colors.primary, alto: capitular-alto)
  ]
}
```

== Idiomas — `idiomas.typ`

=== `lat`

`src/idiomas.typ:24`

```typ
#let lat(body) = text(font: family("eb-garamond"), style: "italic", lang: "la")[#body]
```

=== `gr`

`src/idiomas.typ:29`

```typ
#let gr(body, autentico: false) = text(
  font: if autentico { "GFS Didot" } else { family("libertinus-serif") },
  lang: "el",
)[#body]
```

=== `he`

`src/idiomas.typ:35`

```typ
#let he(body) = text(font: family("libertinus-serif"), lang: "he", dir: rtl)[#body]
```

=== `translit`

`src/idiomas.typ:40`

```typ
#let translit(body, color: none) = if color == none {
  text(style: "italic")[#body]
} else {
  text(style: "italic", fill: color)[#body]
}
```

=== `orn`

`src/idiomas.typ:64`

```typ
#let orn(body, size: 1em, fill: none) = {
  let clave = if type(body) == str {
    body
  } else if type(body) == content and body.func() == text {
    body.text
  } else {
    none
  }
  let (fuente, glifo) = (
    cierre: (family("libertinus-serif"), "❧"),
    apertura: (family("libertinus-serif"), "☙"),
    flor: (family("cormorant"), "❦"),
    parrafo: (family("bodoni-moda"), "❡"),
  ).at(clave, default: (family("orments"), body))
  if fill == none {
    text(font: fuente, size: size, glifo)
  } else {
    text(font: fuente, size: size, fill: fill, glifo)
  }
}
```

=== `interlineal`

`src/idiomas.typ:95`

```typ
#let interlineal(
  palabras,
  idioma: "griego", // "griego" | "hebreo" | "latin"
  color: none,
  theme: theme.base,
  tam-original: 22pt,
  tam-translit: 10pt,
  tam-gloss: 9pt,
  gutter: 14pt,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  let es-rtl = idioma == "hebreo"
  let lengua = if idioma == "hebreo" { "he" } else if idioma == "griego" { "el" } else { "la" }
  let fuente-original = if idioma == "hebreo" {
    family("libertinus-serif")
  } else if idioma == "griego" {
    "GFS Didot"
  } else {
    family("eb-garamond")
  }

  block(width: 100%, above: 20pt, below: 20pt)[
    #set text(dir: if es-rtl { rtl } else { ltr })
    #grid(
      columns: (auto,) * palabras.len(),
      column-gutter: gutter,
      ..palabras.map(p => align(center)[
        #text(font: fuente-original, size: tam-original, lang: lengua, p.original)
        #v(5pt)
        #translit(text(size: tam-translit, p.translit), color: color)
        #v(2pt)
        #text(font: theme.fonts.body, size: tam-gloss, fill: gray.darken(10%), p.gloss)
      ]),
    )
  ]
}
```

== Formas SVG — `formas.typ`

=== `bocadillo`

`src/formas.typ:86`

```typ
#let bocadillo(w: 210pt, h: 140pt, r: 18pt, lado: "izq", tail-w: 28pt, tail-h: 22pt, fill: black) = {
  let w-n = w / 1pt
  let h-n = h / 1pt
  let r-n = r / 1pt
  let tw-n = tail-w / 1pt
  let th-n = tail-h / 1pt
  let tail-x = if lado == "izq" {
    r-n + 8
  } else if lado == "der" {
    w-n - r-n - 8 - tw-n
  } else {
    w-n / 2 - tw-n / 2
  }
  image(
    bytes(_svg-bocadillo(w-n, h-n, r-n, tail-x, tw-n, th-n, fill.to-hex())),
    format: "svg",
    width: w,
    height: h + tail-h,
  )
}
```

=== `cinta`

`src/formas.typ:126`

```typ
#let cinta(w: 260pt, h: 60pt, muesca: 16pt, fill: black) = {
  let w-n = w / 1pt
  let h-n = h / 1pt
  let m-n = muesca / 1pt
  image(
    bytes(_svg-cinta(w-n, h-n, m-n, fill.to-hex())),
    format: "svg",
    width: w,
    height: h,
  )
}
```

=== `blob`

`src/formas.typ:166`

```typ
#let blob(nombre, w: 180pt, h: auto, fill: black) = {
  let b = _blobs.at(nombre, default: none)
  if b == none {
    panic("formas.blob: nombre desconocido \"" + nombre + "\" — disponibles: " + _blobs.keys().join(", "))
  }
  let (x0, y0, bw, bh) = b.vb
  let h = if h == auto { w * bh / bw } else { h }
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='" + str(x0) + " " + str(y0) + " " + str(bw) + " " + str(bh) + "'><path d='" + b.d + "' fill='" + fill.to-hex() + "'/></svg>"
  image(bytes(svg), format: "svg", width: w, height: h)
}
```

== Canvas sociales — `social.typ`

=== `canvas`

`src/social.typ:51`

```typ
#let canvas(size, body, theme: theme.base) = page(
  width: size.at(0) * 1pt,
  height: size.at(1) * 1pt,
  margin: 0pt,
  fill: theme.colors.light,
  body,
)
```

=== `bg`

`src/social.typ:59`

```typ
#let bg(color) = {
  place(rect(width: 100%, height: 100%, fill: color))
}
```

=== `gradient-bg`

`src/social.typ:64`

```typ
#let gradient-bg(from: none, to: none, theme: theme.base) = {
  let from = if from == none { theme.colors.primary } else { from }
  let to = if to == none { theme.colors.secondary } else { to }
  place(
    rect(width: 100%, height: 100%,
      fill: gradient.linear(angle: 135deg, from, to)),
  )
}
```

=== `blob`

`src/social.typ:74`

```typ
#let blob(x, y, size, color, opacity: 20%) = place(
  dx: x, dy: y,
  circle(radius: size * 1pt, fill: color.transparentize(100% - opacity)),
)
```

=== `aura-bg`

`src/social.typ:136`

```typ
#let aura-bg(colores, size: sizes.instagram, r: auto, blur: auto, posiciones: auto, panel: none, panel-blur: auto, tinte: white) = {
  let w = size.at(0)
  let h = size.at(1)
  let n = colores.len()
  let r = if r == auto { calc.min(w, h) * 0.38 } else { r }
  let blur = if blur == auto { r * 0.55 } else { blur }
  let centros = if posiciones == auto {
    range(n).map(i => {
      let t = if n == 1 { 0.5 } else { i / (n - 1) }
      (w * (0.3 + 0.4 * t), h * (0.3 + 0.4 * (1 - t)))
    })
  } else {
    posiciones
  }
  let circulos = range(n).map(i => (centros.at(i).at(0), centros.at(i).at(1), r, colores.at(i).to-hex()))
  place(image(
    bytes(_svg-aura(w, h, blur, circulos, panel: panel, panel-blur: panel-blur, tinte: tinte)),
    format: "svg", width: 100%, height: 100%,
  ))
}
```

=== `badge`

`src/social.typ:163`

```typ
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
```

=== `headline`

`src/social.typ:178`

```typ
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
```

=== `subhead`

`src/social.typ:191`

```typ
#let subhead(body, color: gray.darken(30%), size: 34pt, variations: (:), theme: theme.base) = text(
  font: theme.fonts.body,
  fill: color,
  size: size,
  variations: variations,
  body,
)
```

=== `footer`

`src/social.typ:200`

```typ
#let footer(handle, logo: none, color: white, theme: theme.base) = align(
  bottom + start,
  grid(
    columns: (auto, 1fr),
    align: (left, right),
    if logo != none { image(logo, height: 40pt) } else { h(0pt) },
    text(font: theme.fonts.body, fill: color, size: 26pt, weight: 600, handle),
  ),
)
```

=== `quote-post`

`src/social.typ:213`

```typ
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
```

=== `cita-canvas`

`src/social.typ:279`

```typ
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
```

=== `announce-post`

`src/social.typ:310`

```typ
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
```

=== `tip-card`

`src/social.typ:341`

```typ
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
```

=== `avatar`

`src/social.typ:370`

```typ
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
```

=== `avatar-row`

`src/social.typ:384`

```typ
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
```

=== `stat`

`src/social.typ:399`

```typ
#let stat(value, label, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  align(center)[
    #text(font: theme.fonts.display, size: 140pt, weight: 900, fill: color, value)
    #linebreak()
    #text(font: theme.fonts.body, size: 34pt, fill: gray.darken(20%), label)
  ]
}
```

=== `progress`

`src/social.typ:409`

```typ
#let progress(pct, color: none, height: 14pt, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  box(width: 100%, height: height, radius: height,
    fill: color.transparentize(80%), clip: true)[
      #box(width: pct * 100%, height: 100%, radius: height, fill: color)
    ]
}
```

=== `divider`

`src/social.typ:418`

```typ
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
```

=== `carousel-cover`

`src/social.typ:432`

```typ
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
```

=== `carousel-slide`

`src/social.typ:464`

```typ
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
```

=== `stat-card`

`src/social.typ:490`

```typ
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
```

=== `vs-badge`

`src/social.typ:519`

```typ
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
```

=== `event-post`

`src/social.typ:533`

```typ
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
```

=== `testimonial-post`

`src/social.typ:572`

```typ
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
```

=== `quote-social`

`src/social.typ:616`

```typ
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
```

=== `poll-story`

`src/social.typ:706`

```typ
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
```

=== `versus-post`

`src/social.typ:742`

```typ
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
```

== Citas tipográficas — `blockquotes.typ`

=== `blockquote-editorial`

`src/blockquotes.typ:46`

```typ
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
```

=== `blockquote-bar`

`src/blockquotes.typ:75`

```typ
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
```

=== `blockquote-card`

`src/blockquotes.typ:101`

```typ
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
```

=== `blockquote-hero`

`src/blockquotes.typ:132`

```typ
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
```

=== `blockquote-avatar`

`src/blockquotes.typ:154`

```typ
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
```

=== `blockquote-hand`

`src/blockquotes.typ:184`

```typ
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
```

=== `blockquote-grid`

`src/blockquotes.typ:202`

```typ
#let blockquote-grid(tarjetas, columnas: 2) = block(width: 100%, above: 24pt, below: 24pt)[
  #grid(columns: (1fr,) * columnas, gutter: 24pt, ..tarjetas)
]
```

=== `blockquote-paralelo`

`src/blockquotes.typ:211`

```typ
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
```

=== `blockquote-lateral`

`src/blockquotes.typ:254`

```typ
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
```

=== `blockquote-pull`

`src/blockquotes.typ:302`

```typ
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
```

=== `blockquote-definition`

`src/blockquotes.typ:332`

```typ
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
```

=== `blockquote-callout`

`src/blockquotes.typ:359`

```typ
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
```

=== `blockquote-poetry`

`src/blockquotes.typ:388`

```typ
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
```

=== `blockquote-timeline`

`src/blockquotes.typ:404`

```typ
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
```

=== `bq-mark`

`src/blockquotes.typ:422`

```typ
#let bq-mark(texto, size: 60pt, fill: none, theme: theme.base, detras: false) = {
  let fill = if fill == none { theme.colors.primary.transparentize(75%) } else { fill }
  if detras {
    place(dx: -10pt, dy: -30pt)[#text(font: theme.fonts.display, size: 180pt, fill: fill.transparentize(30%), weight: 900, texto)]
  } else {
    text(font: theme.fonts.display, size: size, fill: fill, weight: 900, texto)
  }
}
```

=== `bq-rule`

`src/blockquotes.typ:431`

```typ
#let bq-rule(color: none, width: 48pt, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  box(fill: color, height: 3pt, width: width, radius: 1.5pt)
}
```

=== `bq-rule-full`

`src/blockquotes.typ:436`

```typ
#let bq-rule-full(color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.primary } else { color }
  line(length: 100%, stroke: 0.75pt + color.transparentize(70%))
}
```

=== `bq-attribution`

`src/blockquotes.typ:446`

```typ
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
```

=== `bq-frame`

`src/blockquotes.typ:474`

```typ
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
```

== Carrusel — `carrusel.typ`

=== `dots`

`src/carrusel.typ:30`

```typ
#let dots(activo, total: 8, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  stack(dir: ltr, spacing: 10pt,
    ..range(1, total + 1).map(i => circle(
      radius: 4.5pt,
      fill: if i == activo { color } else { gray.lighten(60%) },
    ))
  )
}
```

=== `topbar`

`src/carrusel.typ:41`

```typ
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
```

=== `pie-carrusel`

`src/carrusel.typ:53`

```typ
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
```

=== `numeral-fondo`

`src/carrusel.typ:69`

```typ
#let numeral-fondo(txt, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.secondary } else { color }
  place(top + right, dx: 8pt, dy: -56pt)[
    #text(font: theme.fonts.display, weight: 900, size: 226pt, fill: color.transparentize(93%))[#txt]
  ]
}
```

=== `referencia-carrusel`

`src/carrusel.typ:79`

```typ
#let referencia-carrusel(texto, color: none, theme: theme.base) = {
  let color = if color == none { theme.colors.accent } else { color }
  box(stroke: (left: 3.5pt + color.transparentize(55%)), inset: (left: 18pt))[
    #text(font: theme.fonts.body, weight: 800, size: 13pt, tracking: 0.16em, fill: color, upper(texto))
  ]
}
```

=== `carrusel-slide`

`src/carrusel.typ:90`

```typ
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
```

=== `carrusel-slide-definicion`

`src/carrusel.typ:136`

```typ
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
```
