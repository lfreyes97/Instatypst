// ─────────────────────────────────────────────────────────────
//  common.typ — piezas que comparten los presets de Framed (timepiece, anaglyph…)
//
//  Auditoría contra V2 (27 nov 2026): lo que aquí vive NO existe en V2 como pieza
//  exportada. `scaffold.fit-width` sí existe y se usa (engines/glitcher.typ); el ajuste
//  multiplicativo de `verse-block` (×0,95, el de WallTypst) no es `fit-down` (aditivo, en pt).
//
//    legible(c, on, ink, size)     c, o el de mayor contraste (`readable-on`) si no se lee sobre `on`
//    aspect(width, height)         "apaisado" | "ultra" | "vertical"
//    pick(v, asp)                  el valor de `{ apaisado:, ultra:, vertical: }` para ese aspecto
//    in-cell(c, anchor, body)      el cuerpo anclado dentro de una celda de la retícula
//    verse-block(ctx, body, ref, k, …)   el verso o la cita: el mayor tamaño que cabe, y su referencia o su `signature` ya armada
//
//  Destino en la fusión: `aspect`/`pick` son el «lenguaje de valores» abierto de la Spec;
//  `in-cell` va con el engine de retículas; `verse-block` con el elemento `verse`.
// ─────────────────────────────────────────────────────────────

#import "/src/modules/color/palettes/contrast.typ": contrast, readable-on

// el color, o la tinta si no se lee sobre el fondo (como `legible` de WallTypst)
// si `c` no se lee sobre `on`, el de mayor contraste entre `c`, la tinta, blanco y negro (como `legible` de WallTypst,
// con `readable-on` de V2)
#let legible(c, on, ink, size) = if contrast(c, on) >= (if size >= 24pt { 3 } else { 4.5 }) { c } else {
  readable-on(on, c, ink, white, black)
}

// el verso: el mayor tamaño (bajando de 5 en 5 %) con el que cabe en `height`.
// Todo en k de WallTypst; los valores por defecto son los de WallTypst.
#let verse-block(ctx, body, ref, k, width: 700, height: 520, margin-x: 80, margin-y: 80, size: 64, min-size: 24,
    ratio: 1.618, leading: 0.42, font: "Fraunces", weight: 400, style: "normal", ref-font: "Instrument Sans",
    ref-weight: 400, ref-tracking: 0.14, ref-step: 2.5, ref-min: 17, ref-color: auto, gap: 24, rule: false,
    align-to: left, text-case: none, signature: none, rule-length: 40, rule-width: 1.4, mark: none,
    justify: false, hyphenate: false, ref-case: "upper", ref-align: auto, tracking: 0em, parts: "all", ornament: none) = {
  let L(v) = v * k
  let (paper, ink, accent) = (ctx.tm.paper, ctx.tm.ink, ctx.tm.accent)
  let on(c, s) = legible(c, paper, ink, s)
  let w = calc.min(L(width), ctx.width - 2 * L(margin-x))
  let h = calc.min(L(height), ctx.height - 2 * L(margin-y))
  let smax = L(size)
  let rs = calc.max(L(ref-min), smax / calc.pow(ratio, ref-step))
  let rc = if ref-color == auto { ink } else { ref-color }
  let make(s) = block(width: w, {
    set par(leading: leading * s, justify: justify)
    set text(costs: (runt: 500%, widow: 300%, orphan: 300%), hyphenate: hyphenate)
    set text(lang: "es") if hyphenate
    // `body` puede ser una función del tamaño (la capitular lo necesita)
    let t = if type(body) == function {
      set text(font: (ctx.font)(font), size: s, weight: weight, style: style, fill: on(ink, s))
      body(s)
    } else {
      text(font: (ctx.font)(font), size: s, weight: weight, style: style, tracking: tracking, fill: on(ink, s), if text-case == "upper" { upper(body) } else { body })
    }
    let line-rule = if rule { line(length: L(rule-length), stroke: L(rule-width) + on(rc, 0pt)) }
    let r = if signature != none { signature } else if ref != none {
      text(font: (ctx.font)(ref-font), size: rs, weight: ref-weight, tracking: ref-tracking * 1em, fill: on(rc, rs),
        if ref-case == "smallcaps" { smallcaps(ref) } else if ref-case == "upper" { upper(ref) } else { ref })
    }
    let ref-al = if ref-align == auto { align-to } else { ref-align }
    // `parts`: "all", "text" (sin referencia ni filete) o "ref" (solo la referencia)
    let items = if parts == "ref" { ((r, ref-al),) } else if parts == "text" { ((mark, align-to), (t, align-to)) } else {
      ((mark, align-to), (t, align-to), (if ornament != none { ornament } else { line-rule }, ref-al), (r, ref-al))
    }
    stack(dir: ttb, spacing: L(gap), ..items
      .filter(p => p.first() != none).map(p => align(p.last(), p.first())))
  })
  context {
    let s = smax
    while s > L(min-size) and measure(make(s), width: w).height > h { s = s * 0.95 }
    make(s)
  }
}

// aspecto del artboard y valor por aspecto (`{ apaisado, ultra, vertical }` de WallTypst)
#let aspect(width, height) = if width < height { "vertical" } else if width / height > 2 { "ultra" } else { "apaisado" }
#let pick(v, asp) = if type(v) == dictionary and ("apaisado" in v or "vertical" in v or "ultra" in v) {
  if asp in v { v.at(asp) } else if asp == "ultra" and "apaisado" in v { v.apaisado } else { v.at("apaisado", default: v.at("vertical", default: none)) }
} else { v }

#let anchors = ("top-left": top + left, "top": top + center, "top-right": top + right, "left": horizon + left,
  "center": horizon + center, "right": horizon + right, "bottom-left": bottom + left, "bottom": bottom + center,
  "bottom-right": bottom + right)

// un cuerpo dentro de una celda de la retícula, anclado en ella
#let in-cell(c, anchor, body, inset: (:), k: 1pt) = place(top + left, dx: c.x * 1pt, dy: c.y * 1pt,
  box(width: c.w * 1pt, height: c.h * 1pt, inset: inset.pairs().map(((side, v)) => (side, v * k)).to-dict(), align(anchors.at(anchor), body)))

// un bloque colocado por posición y márgenes (WallTypst `colocar`), en k
#let block-at(position, mx, my, k, body) = {
  let (v, h) = if position == "right" { (horizon, right) } else {
    let parts = position.split("-")
    ((top: top, bottom: bottom).at(parts.first()), (left: left, right: right).at(parts.last()))
  }
  place(v + h, dx: if h == right { -mx * k } else { mx * k }, dy: if v == top { my * k } else if v == bottom { -my * k } else { 0pt }, body)
}

// el bloque de título de WallTypst (`bloque`): kicker, título, filete opcional y bajada, apilados y alineados; en k.
// Los valores por defecto son los de WallTypst; `color: auto` es la tinta del tema.
#let title-block(ctx, tag, main, sub, k, size: 90, ratio: 1.618, width: 600, margin: 80, leading: 0.12, gap: 24,
    sub-step: 2, kicker-step: 3, align-to: left,
    font: "", weight: "regular", style: "normal", tracking: 0em, color: auto,
    sub-font: "", sub-weight: "regular", sub-style: "normal", sub-tracking: 0em, sub-case: none, sub-color: auto,
    kicker-color: auto, rule: none, rule-length: 120, rule-width: 2, rule-color: auto) = {
  let L(v) = v * k
  let s = L(size)
  let ink = ctx.tm.ink
  let on(c, sz) = legible(c, ctx.tm.paper, ink, sz)
  let c0 = if color == auto { ink } else { color }
  let c-sub = if sub-color == auto { c0 } else { sub-color }
  let c-kick = if kicker-color == auto { c-sub } else { kicker-color }
  let cased(t, mode) = if mode == "upper" { upper(t) } else { t }
  let title = { set par(leading: leading * s, spacing: leading * s); text(font: (ctx.font)(font), size: s, weight: weight, style: style, tracking: tracking, fill: on(c0, s), main.body) }
  let ss = s / calc.pow(ratio, sub-step)
  let sub-line = if sub != none {
    set par(leading: 0.45 * ss)
    text(font: (ctx.font)(sub-font), size: ss, weight: sub-weight, style: sub-style, tracking: sub-tracking, fill: on(c-sub, ss), cased(sub.body, sub-case))
  }
  let ks = s / calc.pow(ratio, kicker-step)
  let kicker = if tag != none { text(font: (ctx.font)(sub-font), size: ks, weight: "medium", tracking: 0.18em, fill: on(c-kick, ks), upper(tag.body)) }
  let rc = on(if rule-color == auto { c-sub } else { rule-color }, 0pt)
  let line-rule = if rule == "between" { align(align-to, line(length: L(rule-length), stroke: L(rule-width) + rc)) }
  let pieces = (kicker, title, line-rule, sub-line).filter(x => x != none)
  let avail = calc.min(L(width), ctx.width - 2 * L(margin))
  context {
    let w = calc.max(..pieces.map(x => measure(x, width: avail).width))
    block(width: w, stack(dir: ttb, spacing: L(gap), ..pieces.map(x => align(align-to, x))))
  }
}
