// ─────────────────────────────────────────────────────────────
//  tableau.typ — el preset `tableau`: composición libre, arte con texto
//
//  Una escena compuesta donde el **arte manda** y el texto la acompaña (a diferencia de `anaglyph`, donde la
//  tipografía es la imagen, y de `inscription`, donde el verso es lo central). Una forma, un horizonte, una trama:
//  lo que cada plantilla de WallTypst dibuja con capas gráficas más un bloque de título o un verso.
//
//  tableau = plain (scaffold) + estas reglas. Una variante por preset de WallTypst:
//
//    variant      WallTypst        qué es
//    "cross"      cartel-cruz      una cruz latina descomunal, tono sobre tono, que sangra; el verso abajo a la derecha
//    "eclipse"    eclipse          un eclipse con corona ámbar (auras y un anillo) sobre azul noche; el título abajo
//    "void"       vacio            un horizonte de un pelo y un sol pequeño; el resto es silencio
//    "riso"       riso             dos tintas de trama de puntos mal registradas sobre papel; grotesca gruesa
//    "arch"       cartel-arco      dos semidiscos anidados, tono sobre tono, bajo el borde inferior; el verso arriba a la derecha
//
//  Elementos que reconoce (elements.typ): tag, main, subhead (el bloque de título: kicker, título y bajada),
//  verse + work (en `cross`), brand. Opción: `seed` (def. 1), el azar de las posiciones (`rango`).
//
//    #tableau(variant: "eclipse", artboard: (1920, 1080))[
//      #tag[Cuaderno]
//      #main[Lo que se hace despacio dura]
//      #subhead[Notas de taller, otoño de 2026]
//    ]
//
//  WallTypst → V2:
//    [[layers]] plano                → el papel del tema
//    [[layers]] rect (cross)         → rectángulos centrados en su punto (x, y), en k
//    [[layers]] aura/circulo/anillo (eclipse) → superbg `aura` (dos capas), un disco y un anillo
//    [[layers]] linea/circulo (void) → un filete a todo el ancho y un disco; el radio sale de `rango` [14, 22]
//    [[layers]] halftone ×2 (riso)   → superbg `halftone`, radial, con el segundo juego desplazado (dx 5, dy 3)
//    [[layers]] ruido/vignette       → recurso `grain`: aún no existe; se dibuja siempre, como en WallTypst
//    [text] / [[blocks]] verse       → `title-block` (kicker, título, filete, bajada) / `verse-block`
//    [vars] elegir[…]                → el juego por defecto es el que WallTypst elige con semilla 1
//    [vars] cx, cy = rango           → `glitcher.rango`, con la clave de WallTypst y `seed`
//    desde / datos                   → desaparecen: el título es `#main`, el kicker `#tag`, la bajada `#subhead`
//
//  Escala: k = lado corto / 1000, la de WallTypst, para poder medir la paridad.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ": superbg
#import "engines/glitcher.typ" as glitcher
#import "common.typ": verse-block, aspect, pick, block-at, title-block

#let _themes = (
  cross: (paper: rgb("#e6e7e2"), ink: rgb("#1d1a17"), accent: none, tint-a: rgb("#d6d9d2")),
  eclipse: (paper: rgb("#0b0f15"), ink: rgb("#ece4d4"), accent: rgb("#d9a05b"), deep: rgb("#1d4857"), wine: rgb("#7a3b2e")),
  void: (paper: rgb("#d3d6db"), ink: rgb("#262624"), accent: rgb("#c4532f")),
  riso: (paper: rgb("#f2ede3"), ink: rgb("#1b6670"), accent: none, tint-a: rgb("#ff4f93")),
  arch: (paper: rgb("#e7dcd6"), ink: rgb("#241d16"), accent: rgb("#3f6b8a"), tint-a: rgb("#d5bfb4")),
)
#let _extra = (cross: ("tint-a",), eclipse: ("deep", "wine"), void: (), riso: ("tint-a",), arch: ("tint-a",))

// un sector circular (una porción de disco, o el disco entero si abarca 360°): WallTypst `sector`. `r` en pt, ángulos en grados
#let _sector(r, from, to, fill) = {
  let n = calc.max(8, int(calc.abs(to - from) / 3))
  let pts = range(n + 1).map(i => {
    let a = (from + (to - from) * i / n) * 1deg
    (r + r * calc.cos(a), r + r * calc.sin(a))
  })
  let pts = if calc.abs(to - from) >= 360 { pts } else { ((r, r),) + pts }
  box(width: 2 * r, height: 2 * r, place(polygon(fill: fill, ..pts)))
}

#let _rules(ctx, variant, seed) = {
  let part(k) = ctx.parts.at(k, default: none)
  let (width, height) = (ctx.width, ctx.height)
  let k = calc.min(width, height) / 1000
  let ku = k / 1pt
  let (w-px, h-px) = (width / 1pt, height / 1pt)
  let asp = aspect(width, height)
  let size = (w-px, h-px)
  let tm = ctx.tm
  let title = if "main" in ctx.parts { ctx.parts.main } else { none }

  if variant == "cross" {
    let cx = pick((apaisado: 0.74, ultra: 0.78, vertical: 0.62), asp)
    let cy = pick((apaisado: 0.3, vertical: 0.32), asp)
    let bar(x, y, w, h) = place(top + left, dx: x * width - w * k / 2, dy: y * height - h * k / 2, rect(width: w * k, height: h * k, fill: tm.tint-a))
    bar(cx, 0.5, 150, 1600)
    bar(cx, cy, 640, 150)
    let v = part("verse")
    if v != none {
      let work = part("work")
      block-at("bottom-right", 100, 100, k, verse-block(ctx, v.body, if work == none { none } else { work.body }, k,
        width: pick((apaisado: 860, vertical: 900), asp), height: pick((apaisado: 400, vertical: 700), asp), margin-x: 100, margin-y: 100,
        size: 62, min-size: 32, leading: 0.28, font: "Bodoni Moda", ref-font: "Hanken Grotesk", ref-case: "upper", ref-weight: 600,
        ref-tracking: 0.16, ref-step: 3.4, ref-min: 19, ref-color: tm.ink, gap: 22, align-to: right))
    }
  } else if variant == "eclipse" {
    // el centro del eclipse: azar por semilla (con la clave de WallTypst), o fijo en vertical
    let cx = if asp == "vertical" { 0.5 } else { glitcher.rango("p.vars.cx", 0.60, 0.72, seed: seed) }
    let cy = if asp == "vertical" { 0.34 } else { glitcher.rango("p.vars.cy", 0.36, 0.44, seed: seed) }
    let at(dx, dy) = (cx * w-px + dx * ku, cy * h-px + dy * ku)
    place(top + left, superbg((
      (tipo: "aura", colores: (tm.deep, tm.wine, tm.accent), posiciones: (at(30, 40), at(40, -30), at(-60, -70)), r: 235 * ku, blur: 95 * ku),
      (tipo: "aura", colores: (rgb("#f3c98a"),), posiciones: (at(-150, -185),), r: 26 * ku, blur: 22 * ku),
    ), size: size))
    place(top + left, dx: cx * width - 236 * k, dy: cy * height - 236 * k, circle(radius: 236 * k, fill: tm.paper))
    place(top + left, dx: cx * width - 237 * k, dy: cy * height - 237 * k,
      circle(radius: 237 * k, fill: none, stroke: 1.6 * k + tm.accent.transparentize(20%)))
    place(top + left, superbg(((tipo: "ruido", color: white, opacidad: 5%), (tipo: "vignette", color: black, intensidad: 45%)), size: size))
    if title != none {
      block-at("bottom-right", 90, 90, k, title-block(ctx, part("tag"), title, part("subhead"), k, size: 104, ratio: 1.5, width: 640, margin: 90,
        leading: 0.14, gap: 26, sub-step: 3.4, align-to: right, font: "Cormorant Garamond", style: "italic", weight: 300,
        sub-font: "DM Mono", sub-case: "upper", sub-tracking: 0.14em, sub-color: tm.accent, kicker-color: tm.accent,
        rule: "between", rule-length: 64, rule-width: 1.4, rule-color: tm.accent))
    }
  } else if variant == "void" {
    let hy = pick((apaisado: 0.667, vertical: 0.62), asp)
    let sx = pick((apaisado: 0.667, vertical: 0.333), asp)
    place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 4%),), size: size))
    place(top + left, line(start: (0pt, hy * height), end: (width, hy * height), stroke: (paint: tm.ink.transparentize(45%), thickness: 1.4 * k, cap: "butt")))
    let r = glitcher.rango("p.layers.3.r", 14, 22, seed: seed) * k
    place(top + left, dx: sx * width - r, dy: hy * height - r, circle(radius: r, fill: tm.accent))
    if title != none {
      // el texto cuelga bajo el sol, desplazado 56 k
      let block = title-block(ctx, part("tag"), title, part("subhead"), k, size: 46, ratio: 1.333, width: 500, margin: 80, leading: 0.2, gap: 16,
        sub-step: 2, align-to: left, font: "Instrument Sans", weight: 500, tracking: -0.01em, sub-font: "Instrument Sans")
      glitcher.at(width, height, sx, hy, "top-left", block, dy: 56 * k)
    }
  } else if variant == "riso" {
    let cx = if asp == "vertical" { 0.62 } else { glitcher.rango("p.vars.cx", 0.70, 0.80, seed: seed) }
    let cy = if asp == "vertical" { 0.24 } else { glitcher.rango("p.vars.cy", 0.18, 0.28, seed: seed) }
    let dots(color, r-max, r-min, op) = superbg(((tipo: "halftone", fondo: none, color: color, direccion: "radial", centro: (cx * w-px, cy * h-px),
      paso: calc.max(1, int(calc.round(24 * ku))), r-max: r-max * ku, r-min: r-min * ku, opacidad: op),), size: (int(calc.round(w-px)), int(calc.round(h-px))))
    place(top + left, dots(tm.tint-a, -6, 13, 92%))
    place(top + left, dx: 5 * k, dy: 3 * k, dots(tm.ink, -5, 8, 80%))
    place(top + left, superbg(((tipo: "ruido", color: rgb("#3a2f20"), opacidad: 10%),), size: size))
    if title != none {
      block-at("bottom-right", 80, 80, k, title-block(ctx, part("tag"), title, part("subhead"), k, size: 96, ratio: 1.618, width: 760, margin: 80,
        leading: 0.1, gap: 18, sub-step: 2.4, align-to: right, font: "Bricolage Grotesque 96pt", weight: 800, tracking: -0.03em,
        sub-font: "Bricolage Grotesque", sub-weight: 600))
    }
  } else if variant == "arch" {
    // dos semidiscos anidados, tono sobre tono, que nacen bajo el borde inferior; el centro cambia por semilla
    let cx = if asp == "vertical" { 0.5 } else { glitcher.choose((0.24, 0.3, 0.36), "p.vars.cx", seed) }
    let cy = pick((apaisado: 1.06, ultra: 1.08, vertical: 1.02), asp)
    let (r1, r2) = (pick((apaisado: 760, ultra: 860, vertical: 760), asp) * k, pick((apaisado: 520, ultra: 600, vertical: 540), asp) * k)
    place(top + left, dx: cx * width - r1, dy: cy * height - r1, _sector(r1, 180, 360, tm.tint-a))
    place(top + left, dx: cx * width - r2, dy: cy * height - r2, _sector(r2, 180, 360, tm.accent.transparentize(62%)))
    place(top + left, superbg(((tipo: "ruido", color: rgb("#4a3b2a"), opacidad: 5%),), size: size))
    let v = part("verse")
    if v != none {
      let work = part("work")
      let m = pick((apaisado: 100, ultra: 110, vertical: 72), asp)
      block-at(if asp == "vertical" { "top-left" } else { "top-right" }, m, m, k, verse-block(ctx, v.body, if work == none { none } else { work.body }, k,
        width: pick((apaisado: 700, ultra: 840, vertical: 880), asp), height: pick((apaisado: 520, vertical: 760), asp), margin-x: m, margin-y: m,
        size: pick((apaisado: 66, ultra: 72, vertical: 56), asp), min-size: 32, ratio: 1.5, leading: 0.28, font: "Fraunces", ref-font: "DM Mono",
        ref-case: "upper", ref-tracking: 0.14, ref-step: 3.4, ref-min: 18, ref-color: tm.accent, rule: true, rule-length: 56, rule-width: 1.6,
        gap: 22, align-to: if asp == "vertical" { left } else { right }))
    }
  }
  if ctx.brand != none { place(bottom + left, dx: 70 * k, dy: -70 * k, ctx.brand) }
}

#let variants = ("cross", "eclipse", "void", "riso", "arch")

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  variant: "eclipse",
  seed: 1,
  ..elements,
) = {
  let variant = if variant == auto { "eclipse" } else { variant }
  assert(variant in variants, message: "tableau: variante desconocida " + repr(variant) + " (hay: " + variants.join(", ") + ")")
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
    known: ("main", "tag", "subhead", "verse", "work", "brand"),
    fn: "tableau",
    elements: elements,
    rules: ctx => _rules(ctx, variant, seed),
  )
}

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "tableau", make: make, variants: variants, artboard: (1920, 1080))
#let tableau = frame.with(preset: preset)
