// ─────────────────────────────────────────────────────────────
//  inscription.typ — `inscription` de V2 más las variantes de verso de WallTypst
//
//  Extensión de laboratorio: las 15 variantes de V2 (`src/presets/inscription`) se delegan tal cual;
//  las nuevas son scaffold + reglas, sobre las mismas piezas de Framed (common, engines, vendor).
//  No se toca `src/`. En la fusión, cada variante nueva pasa a `src/presets/inscription/variants/`.
//
//    variant      WallTypst            qué es
//    "night"      verso-noche          fondo casi negro con viñeta y grano; el verso en cursiva, a la derecha
//    "dawn"       verso-alba           papel claro con un horizonte y un sol; el verso arriba y la referencia abajo
//    "psalm"      salmo-columna        el verso justificado al centro, con el número y el capítulo a un lado y las referencias cruzadas al otro
//    "parchment"  verso-pergamino      papel envejecido con doble filete, capitular ornamentada y una flor antes de la referencia
//    "ruler"      escala-versiculos    una escala graduada (`#ruler(total:, current:)`) con el versículo marcado y el verso encima
//
//  Elementos que reconoce (elements.typ): verse (o epigraph, o main), work (la referencia), brand.
//  La referencia con versión se escribe con cadena literal para conservar los espacios:
//  `#work[#"Lamentaciones 3:22–23  ·  RV1909"]`.
//
//    #inscription(variant: "night", artboard: (1920, 1080))[
//      #verse[Es por la misericordia de Jehová que no somos consumidos…]
//      #work[#"Lamentaciones 3:22–23  ·  RV1909"]
//    ]
//
//  WallTypst → V2:
//    verso-noche  [colors] bg/ink/ember (deep: sin uso) → paper/ink/accent. Los dos círculos de la luna (`cuando = sin-texto`)
//                 solo se dibujan sin verso. Grano blanco 8 %, viñeta negra 45 %. Bloque `verse`: a la derecha,
//                 margen 100, cursiva, filete entre texto y referencia (ember).
//    verso-alba   [vars] bg = elegir[3] (semilla 1: el tercero), col/fila por aspecto → celdas de la retícula;
//                 [[layers]] ruido 4 %, linea (celda `fila`, a sangre en x), circulo (celda `col` × `fila`);
//                 dos bloques `verse`: `parts = text` (abajo a la izquierda, inset 56) y `parts = ref` (arriba, inset 36).
//
//  Escala: k = lado corto / 1000, la de WallTypst, para poder medir la paridad.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ": superbg
#import "/src/presets/inscription/inscription.typ" as v2
#import "engines/glitcher.typ" as glitcher
#import "vendor/reticula.typ": reticula
#import "common.typ": verse-block, in-cell, aspect, pick, anchors, legible
#import "/src/resources/dropcaps/dropcaps.typ": capitular-ornamentada
#import "/src/modules/fleurones/fleurones.typ" as fleurones

#let _themes = (
  night: (paper: rgb("#0d1117"), ink: rgb("#ece4d4"), accent: rgb("#d6a35f")),
  dawn: (paper: rgb("#e6e1d8"), ink: rgb("#22211f"), accent: rgb("#c4532f"), quiet: rgb("#6b6862")),
  ruler: (paper: rgb("#f1ece2"), ink: rgb("#1f1b17"), accent: rgb("#c4452b")),
  psalm: (paper: rgb("#f4f0e8"), ink: rgb("#26221d"), accent: rgb("#9a3b28"), quiet: rgb("#7c7366")),
  parchment: (paper: rgb("#efe7d6"), ink: rgb("#2b2420"), accent: rgb("#8a2f22")),
)

// «Salmos 46:10» → (libro, capítulo, versículo): WallTypst `ref-partes`
#let _ref-parts(r) = {
  let m = glitcher.plain(r).match(regex("^(.+?)\s+(\d+):(\d+)"))
  if m == none { none } else { (book: m.captures.at(0), chapter: m.captures.at(1), verse: m.captures.at(2)) }
}

// la escala graduada de WallTypst (capa `regla`): marcas, rótulos cada 5 y una marca destacada. `w`, `h` en pt; `k` la unidad
#let _ruler(ctx, props, w, h, k) = {
  let L(v) = v * k
  let (ink, accent) = (ctx.tm.ink, ctx.tm.accent)
  let total = props.at("total", default: 30)
  let current = props.at("current", default: none)
  let step = w / calc.max(1, total - 1)
  let fs = L(17)
  let base = h * 0.3
  let thick = L(2)
  let body-font = (ctx.font)("DM Mono")
  let marks = range(1, total + 1).map(n => {
    let x = (n - 1) * step
    let major = n == 1 or calc.rem(n, 5) == 0
    let len = if major { h * 0.32 } else { h * 0.16 }
    let tick = place(top + left, line(start: (x, base - len), end: (x, base), stroke: (paint: ink, thickness: if major { thick } else { thick * 0.6 })))
    let label = if major and (current == none or calc.abs(n - current) > 2) {
      place(top + left, dx: x - fs * 2, dy: base + fs * 0.5, box(width: fs * 4, align(center,
        text(font: body-font, size: fs, fill: ink, number-width: "tabular", str(n)))))
    }
    tick + label
  }).join()
  let highlight = if current != none and current >= 1 and current <= total {
    let x = (current - 1) * step
    let fa = fs * 3.4
    place(top + left, line(start: (x, base - h * 0.62), end: (x, base + fs * 0.2), stroke: (paint: accent, thickness: thick * 2)))
    place(top + left, dx: x - fa * 2, dy: base + fs * 0.6, box(width: fa * 4, align(center,
      text(font: (ctx.font)("Fraunces"), size: fa, fill: accent, number-width: "tabular", str(current)))))
  }
  let axis = place(top + left, line(start: (0pt, base), end: (w, base), stroke: (paint: ink, thickness: thick)))
  box(width: w, height: h, axis + marks + highlight)
}

// el texto del verso: `verse`, o el epígrafe, o `main`, o el contenido suelto
#let _text(ctx) = {
  let p = ctx.parts
  if "verse" in p { p.verse.body } else if "epigraph" in p { p.epigraph.body } else if "main" in p { p.main.body } else if ctx.has-loose { ctx.loose } else { none }
}

#let _rules(ctx, variant, seed) = {
  let part(k) = ctx.parts.at(k, default: none)
  let (width, height) = (ctx.width, ctx.height)
  let k = calc.min(width, height) / 1000
  let ku = k / 1pt
  let asp = aspect(width, height)
  let size = (width / 1pt, height / 1pt)
  let tm = ctx.tm
  let body = _text(ctx)
  let work = part("work")
  let ref = if work == none { none } else { work.body }

  if variant == "night" {
    // la luna (dos círculos) solo si no hay verso
    if body == none {
      let (cx, cy, r) = (pick((apaisado: 0.7, vertical: 0.6), asp) * width, 0.4 * height, 64 * k)
      place(top + left, dx: cx - r, dy: cy - r, circle(radius: r, fill: tm.accent.transparentize(15%)))
      place(top + left, dx: cx - 62 * k + 17 * k, dy: cy - 62 * k, circle(radius: 62 * k, fill: tm.paper))
    }
    place(top + left, superbg(((tipo: "ruido", color: white, opacidad: 8%), (tipo: "vignette", color: black, intensidad: 45%)), size: size))
    if body != none {
      place(horizon + right, dx: -100 * k, verse-block(ctx, body, ref, k, width: pick((apaisado: 760, vertical: 840), asp),
        height: pick((apaisado: 640, vertical: 900), asp), margin-x: 100, margin-y: 100, size: 78, min-size: 38, ratio: 1.5, leading: 0.36,
        font: "Cormorant Garamond", weight: 400, style: "italic", ref-font: "EB Garamond 12", ref-case: "smallcaps", ref-tracking: 0.1,
        ref-step: 2.8, ref-min: 22, ref-color: tm.accent, rule: true, rule-length: 56, rule-width: 1.4, gap: 30, align-to: left))
    }
  } else if variant == "dawn" {
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 10, vertical: 12), asp),
      gutter: 24, margin: pick((apaisado: 80, vertical: 56), asp), safe: "escritorio"))
    let col = pick((apaisado: 7, ultra: 9, vertical: 2), asp)
    let row = pick((apaisado: 8, vertical: 9), asp)
    let span = pick((apaisado: 6, ultra: 7, vertical: 5), asp)
    place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 4%),), size: size))
    // el horizonte (una línea a sangre en x) y el sol (un disco en el cruce con su columna)
    let horizon-cell = cell((row: row, rows: 1, bleed: "x"))
    place(top + left, dx: horizon-cell.x * 1pt, dy: horizon-cell.y * 1pt, line(length: horizon-cell.w * 1pt,
      stroke: (paint: tm.ink.transparentize(55%), thickness: 1.4 * k, cap: "butt")))
    let sun-cell = cell((col: col, span: 1, row: row, rows: 1))
    place(top + left, dx: sun-cell.x * 1pt - 13 * k, dy: sun-cell.y * 1pt - 13 * k, circle(radius: 13 * k, fill: tm.accent))
    if body != none {
      let rows-text = pick((apaisado: 7, vertical: 8), asp)
      let c1 = cell((col: col, span: span, row: 1, rows: rows-text))
      in-cell(c1, "bottom-left", verse-block(ctx, body, none, k, width: c1.w / ku, height: c1.h / ku - 56, margin-x: 0, margin-y: 0, size: 60,
        min-size: 34, ratio: 1.5, leading: 0.4, weight: 500, tracking: -0.012em, font: "Instrument Sans", parts: "text", align-to: left),
        inset: (bottom: 56), k: k)
      let c2 = cell((col: col, span: span, row: row, rows: 2))
      in-cell(c2, "top-left", verse-block(ctx, none, ref, k, width: c2.w / ku, height: c2.h / ku - 36, margin-x: 0, margin-y: 0, size: 50,
        ratio: 1.5, ref-font: "Instrument Sans", ref-case: "upper", ref-weight: 500, ref-tracking: 0.14, ref-color: tm.quiet, ref-step: 3,
        ref-min: 18, parts: "ref", align-to: left), inset: (top: 36), k: k)
    }
  } else if variant == "ruler" {
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 10, vertical: 14), asp),
      gutter: 24, margin: pick((apaisado: 90, vertical: 60), asp), safe: "escritorio"))
    let rc = cell(pick((apaisado: (row: 7, rows: 2), vertical: (row: 10, rows: 2)), asp))
    let rp = if part("ruler") == none { (:) } else { part("ruler").props }
    place(top + left, dx: rc.x * 1pt, dy: rc.y * 1pt, _ruler(ctx, rp, rc.w * 1pt, rc.h * 1pt, k))
    if body != none {
      let c = cell(pick((apaisado: (col: 3, span: 8, row: 1, rows: 6), ultra: (col: 4, span: 10, row: 1, rows: 6), vertical: (col: 1, span: 6, row: 2, rows: 8)), asp))
      in-cell(c, "bottom", verse-block(ctx, body, ref, k, width: c.w / ku, height: c.h / ku - 40, margin-x: 0, margin-y: 0, size: 60, min-size: 30,
        leading: 0.3, font: "Fraunces", ref-font: "DM Mono", ref-case: "upper", ref-tracking: 0.14, ref-step: 3.2, ref-min: 18, ref-color: tm.accent,
        gap: 34, align-to: center), inset: (bottom: 40), k: k)
    }
  } else if variant == "psalm" {
    // marginalia: el número y el capítulo a un lado, el texto al centro y las referencias cruzadas al otro
    place(top + left, superbg(((tipo: "ruido", color: rgb("#5a4a30"), opacidad: 4%),), size: size))
    if body != none {
      let vp = if part("verse") == none { (:) } else { part("verse").props }
      let note-w = pick((apaisado: 160, vertical: 130), asp)
      let note-gap = pick((apaisado: 40, vertical: 30), asp)
      let full = calc.min(pick((apaisado: 1060, vertical: 900), asp), width / k - 2 * 80)
      let center-w = full - 2 * (note-w + note-gap)
      let rs = calc.max(20 * k, 60 * k / calc.pow(1.618, 2.6))
      let rp = if ref == none { none } else { _ref-parts(ref) }
      let font-body = (ctx.font)("EB Garamond 12")
      let num = if rp != none { align(right, text(font: font-body, size: 64 * k, fill: tm.accent, number-width: "tabular", rp.verse)) }
      let cap = if rp != none { align(right, text(font: font-body, size: rs * 0.9, fill: tm.accent, tracking: 0.14em, upper(rp.book) + " " + rp.chapter)) }
      let xr = vp.at("xrefs", default: ())
      let notes = if xr.len() > 0 {
        stack(dir: ttb, spacing: rs * 0.7,
          text(font: font-body, size: rs * 0.8, fill: tm.accent, tracking: 0.16em, upper(vp.at("xrefs-label", default: "Véase"))),
          ..xr.map(r => text(font: font-body, size: 26 * k, fill: legible(tm.accent, tm.paper, tm.ink, rs), r)))
      }
      let center = verse-block(ctx, body, none, k, width: center-w, height: pick((apaisado: 600, vertical: 1100), asp), margin-x: 0, margin-y: 80, size: 60,
        min-size: 30, leading: 0.42, font: "EB Garamond 12", justify: true, hyphenate: true, parts: "text", align-to: left)
      glitcher.at(width, height, 0.5, 0.5, "center", grid(columns: (note-w * k, center-w * k, note-w * k), column-gutter: note-gap * k,
        stack(dir: ttb, spacing: rs * 0.6, ..(num, cap).filter(x => x != none)), center, notes))
    }
  } else if variant == "parchment" {
    place(top + left, superbg(((tipo: "papel", color: tm.paper, mancha: rgb("#9a7b4f"), manchas: 12%, fibras: 14%, grano: 22%, oxido: 0, bordes: 6%,
      semilla: seed * 31 + 1),), size: size))
    // el doble filete del copista
    let m = 44 * k
    let stroke = (paint: tm.ink.transparentize(15%), thickness: 3 * k)
    place(top + left, dx: m, dy: m, rect(width: width - 2 * m, height: height - 2 * m, stroke: stroke))
    let d = m + 9 * k
    place(top + left, dx: d, dy: d, rect(width: width - 2 * d, height: height - 2 * d, stroke: (paint: stroke.paint, thickness: stroke.thickness * 0.4)))
    if body != none {
      let cx = pick((apaisado: 0.68, ultra: 0.72, vertical: 0.5), asp)
      let dc = legible(tm.accent, tm.paper, tm.ink, 0pt)
      let capital(s) = capitular-ornamentada(glitcher.plain(body), alto: 3, marco: false, tinta: dc, fill: dc)
      let block = verse-block(ctx, capital, ref, k, width: pick((apaisado: 680, vertical: 760), asp), height: pick((apaisado: 640, vertical: 1000), asp),
        size: 50, min-size: 28, ratio: 1.5, leading: 0.42, font: "EB Garamond 12", justify: true, hyphenate: true, ref-font: "EB Garamond 12",
        ref-case: "smallcaps", ref-tracking: 0.08, ref-step: 2.2, ref-min: 22, ref-color: tm.ink, ref-align: center, gap: 26, align-to: left,
        ornament: fleurones.vineta("flor", 24 * k, tm.accent))
      glitcher.at(width, height, cx, 0.5, "center", block)
    }
  }
  if ctx.brand != none { place(bottom + left, dx: 70 * k, dy: -70 * k, ctx.brand) }
}

#let _new = ("night", "dawn", "ruler", "psalm", "parchment")
#let variants = v2.variants + _new

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  variant: auto,
  guides: false,
  seed: 1,
  ..elements,
) = {
  if variant in _new {
    scaffold(
      body,
      artboard: artboard,
      theme: theme,
      accent: accent,
      brand: brand,
      fonts: fonts,
      default-theme: _themes.at(variant),
      default-fonts: none,
      known: ("verse", "epigraph", "main", "work", "ruler", "brand"),
      fn: "inscription",
      elements: elements,
      rules: ctx => _rules(ctx, variant, seed),
    )
  } else {
    // las 15 variantes de V2, sin tocarlas
    (v2.make)(body, artboard: artboard, theme: theme, brand: brand, variant: variant, guides: guides)
  }
}

#let preset = (name: "inscription", make: make, variants: variants)
#let inscription = frame.with(preset: preset)
