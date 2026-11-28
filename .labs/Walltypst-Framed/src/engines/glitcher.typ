// ─────────────────────────────────────────────────────────────
//  engines/glitcher.typ — el motor de pasadas y de ajuste de texto
//
//  Un cuerpo, N pasadas de tinta, ajustado a una caja. Es la pieza común de la familia
//  `anaglyph` (la capa `texto` y las pasadas de WallTypst). Hereda el vocabulario del
//  prototipo `.labs/glitcher.typ` (hash, azar, rango) y la semántica de WallTypst
//  (`pasada`, `apilar`, la capa `texto` forma «linea», `en`, `fuente-texto`).
//  Candidato a engine en la fusión (junto a los de reloj, curvas y retículas).
//
//  Una pasada es un diccionario (números = k, la unidad de WallTypst, lado corto / 1000):
//    color      el color de la tinta            opacity  ratio (def. 100 %)
//    stroke     color del contorno | none       width    grosor del contorno, en k (def. 2)
//    fill       relleno sí/no (def. sí, salvo que haya stroke)
//    dx, dy     desplazamiento, en k            long     false: se omite si el texto es largo (`is-long`)
//  Las que no lleven `color` usan el de `base`.
//
//  API:
//    azar(key, seed), rango(key, a, b, seed:)   azar determinista (el de WallTypst)
//    key-words(text, i, n)                      la i-ésima de las n palabras más largas
//    plain(content)                             el texto plano de un contenido
//    line(text, w, h, passes, …)                una línea ajustada al ancho w (y al alto h); `turn` (±90°) y `scale`
//    stacked(text, w, h, passes, …)             la frase repartida en líneas (hasta `lines-max`), cada una a todo el ancho
//    paragraph(text, w, h, passes, …)           la frase como párrafo; baja el tamaño hasta que cabe. `highlight`: una palabra con `mark`
//    longest-word(text), pick-word(text, which) la palabra más larga, o la primera/última
//    glyph(text, passes, …)                     un carácter protagonista con N pasadas; `target-width` lo ajusta a un ancho
//    initial(text)                              la primera letra, en mayúscula
//    bands(text, w, h, fills, inks, indents, …) la frase en bandas de color, una por línea
//    choose(list, key, seed)                    uno de la lista, por clave y semilla
//  Una pasada puede llevar `dx`/`dy` como `(range: (a, b))`: se resuelve con `seed` y `key` (azar determinista).
//    at(cw, ch, x, y, anchor, body, …)          el cuerpo anclado en una caja cw × ch
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": fit-width
#import "../common.typ": legible

#let hash(k) = k.clusters().enumerate().fold(0, (a, (i, c)) =>
  calc.rem(a * 31 + c.codepoints().map(str.to-unicode).sum() + i, 1000003))

#let azar(k, seed) = calc.fract(calc.abs(
  calc.sin(seed * 12.9898 + hash(k) * 0.0078233 + 1.37) * 43758.5453))

#let rango(key, a, b, seed: 1) = {
  let x = a + (b - a) * azar(key, seed)
  if type(a) == int and type(b) == int { int(calc.round(x)) } else { x }
}

// el texto plano de un contenido (cuerpo de un elemento)
#let plain(c) = {
  if type(c) == str { c }
  else if c == none { "" }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(plain).join() }
  else if c.has("body") { plain(c.body) }
  else if repr(c.func()) == "space" { " " }
  else { "" }
}

#let _words(t) = t.split(" ").filter(w => w.trim() != "")
#let _clean(w) = w.replace(regex("^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$"), "")

// las `total` palabras más largas del texto (sin prefijos repetidos), en orden de aparición; la i-ésima (1…total)
#let key-words(t, i, total) = {
  let ws = _words(t).map(_clean).filter(w => w != "")
  let chosen = ()
  for (j, w) in ws.enumerate().sorted(key: ((j, w)) => (-w.clusters().len(), j)) {
    let lw = lower(w)
    if chosen.len() < total and not chosen.any(((_, e)) => lower(e).starts-with(lw) or lw.starts-with(lower(e))) {
      chosen.push((j, w))
    }
  }
  let top = chosen.sorted(key: p => p.first()).map(p => p.last())
  top.at(calc.min(i, top.len()) - 1)
}

// una pasada pintada sobre una línea de texto: WallTypst `pinta-linea`.
// Si la pasada lleva `mark` (un color) y se da `highlight` (una palabra), solo esa palabra usa `mark`.
#let _paint(p, base, k, style, size, txt, highlight: none) = {
  let c = p.at("color", default: base)
  let op = p.at("opacity", default: 100%)
  let st = p.at("stroke", default: none)
  let stroke = if st != none { p.at("width", default: 2) * k + st.transparentize(100% - op) }
  let fill = if p.at("fill", default: st == none) { c.transparentize(100% - op) } else { c.transparentize(100%) }
  let et(f) = (font: p.at("font", default: style.font), size: size, weight: style.weight, style: style.style, tracking: style.tracking,
    fill: f, stroke: stroke, top-edge: style.top-edge, bottom-edge: style.at("bottom-edge", default: "baseline"))
  if highlight != none and "mark" in p {
    let rc = p.mark.transparentize(100% - op)
    txt.split(" ").map(w => text(..et(if _clean(w) == _clean(highlight) { rc } else { fill }), w)).join(text(..et(fill), " "))
  } else { text(..et(fill), txt) }
}

// una línea que ocupa el ancho `w` de su caja (y se achica si no cabe en `h`), con N pasadas.
// `k`: la unidad de WallTypst como longitud. Devuelve un contenido del tamaño de la última pasada.
// los `dx`/`dy` de una pasada pueden ser `(range: (a, b))`: azar determinista por clave y semilla
#let _resolve(passes, key, seed) = passes.enumerate().map(((i, p)) => {
  let out = p
  for name in ("dx", "dy") {
    let v = p.at(name, default: none)
    if type(v) == dictionary and "range" in v {
      out.insert(name, rango(key + "." + str(i) + "." + name, v.range.at(0), v.range.at(1), seed: seed))
    }
  }
  out
})

#let line(txt, w, h, passes, k, font: "", base: black, weight: "regular", style: "normal", tracking: 0em,
    size-max: 99999, top-edge: "cap-height", align-to: left, is-long: false, turn: 0, scale: 1,
    seed: 1, key: "passes") = context {
  let st = (font: font, weight: weight, style: style, tracking: tracking, top-edge: top-edge)
  // girada 90°, la caja se intercambia; `scale` agranda la caja (WallTypst: `escala` de la capa)
  let (w, h) = if calc.abs(turn) == 90 { (h, w) } else { (w, h) }
  let (w, h) = (w * scale, h * scale)
  // el ancho de la caja: `fit-width` de scaffold (V2), no una copia
  let sz = calc.min(fit-width(s => _paint((:), black, k, st, s, txt), w), size-max * k)
  let f = calc.min(1, h / sz)
  let ps = _resolve(passes, key, seed)
  let ps = if is-long { ps.filter(p => p.at("long", default: true)) } else { ps }
  let piece(p) = block(above: 0pt, below: 0pt, inset: (top: 0pt),
    align(align-to, box(width: w * f, align(align-to, _paint(p, base, k, st, sz * f, txt)))))
  let layers = ps.map(p => place(top + left, dx: p.at("dx", default: 0) * k, dy: p.at("dy", default: 0) * k, piece(p)))
  let box-size = measure(piece(ps.last()))
  rotate(turn * 1deg, reflow: true, box(width: box-size.width, height: box-size.height, layers.join()))
}

// la frase en `n` líneas de longitud parecida (WallTypst `partir-lineas`)
#let _split-lines(t, n) = {
  let ws = _words(t)
  if n <= 1 or ws.len() <= 1 { return (ws.join(" "),) }
  let total = ws.map(w => w.clusters().len() + 1).sum()
  let target = total / n
  let lines = ()
  let current = ()
  let len = 0
  for w in ws {
    let l = w.clusters().len() + 1
    if current.len() > 0 and len + l / 2 > target and lines.len() < n - 1 { lines.push(current.join(" ")); current = (); len = 0 }
    current.push(w); len += l
  }
  if current.len() > 0 { lines.push(current.join(" ")) }
  lines
}

// la frase apilada: de las opciones de 1 a `lines-max` líneas elige la de mayor área útil; cada línea a todo el ancho
#let stacked(txt, w, h, passes, k, font: "", base: black, weight: "regular", style: "normal", tracking: 0em,
    size-max: 99999, lines-max: 7, lead: 0.12, top-edge: "cap-height", align-to: left, is-long: false,
    seed: 1, key: "passes") = context {
  let st = (font: font, weight: weight, style: style, tracking: tracking, top-edge: top-edge)
  let ps = _resolve(passes, key, seed)
  let ps = if is-long { ps.filter(p => p.at("long", default: true)) } else { ps }
  let s0 = 100pt
  let plan(n) = {
    let ls = _split-lines(txt, n)
    let tm = ls.map(l => calc.min(s0 * (w / measure(_paint((:), black, k, st, s0, l)).width), size-max * k))
    (ls, tm, tm.sum() + tm.slice(1).map(x => x * lead).sum(default: 0pt))
  }
  let area(o) = { let f = calc.min(1, h / o.at(2)); o.at(2) / 1pt * f * f }
  let (lines, sizes, total) = range(1, lines-max + 1).map(plan).sorted(key: area).last()
  let f = calc.min(1, h / total)
  let piece(p) = stack(dir: ttb, spacing: 0pt, ..lines.zip(sizes).enumerate().map(((j, (l, sz))) => {
    let sz = sz * f
    block(above: 0pt, below: 0pt, inset: (top: if j == 0 { 0pt } else { sz * lead }),
      align(align-to, box(width: w * f, align(align-to, _paint(p, base, k, st, sz, l)))))
  }))
  let layers = ps.map(p => place(top + left, dx: p.at("dx", default: 0) * k, dy: p.at("dy", default: 0) * k, piece(p)))
  let box-size = measure(piece(ps.last()))
  box(width: box-size.width, height: box-size.height, layers.join())
}

// una palabra del texto: "primera", "larga" o "ultima" (WallTypst `desde`)
#let pick-word(t, which) = {
  let ws = _words(t).map(_clean).filter(w => w != "")
  if which == "primera" { ws.first() } else if which == "ultima" { ws.last() } else { ws.sorted(key: w => -w.clusters().len()).first() }
}

// la palabra más larga del texto (la primera si hay empate): WallTypst `desde = larga`
#let longest-word(t) = {
  let ws = _words(t).map(_clean).filter(w => w != "")
  ws.sorted(key: w => -w.clusters().len()).first()
}

// la frase como párrafo: el tamaño baja (×0,95) hasta que cabe en `h`; cada pasada ajusta el suyo (como WallTypst)
#let paragraph(txt, w, h, passes, k, font: "", base: black, weight: "regular", style: "normal", tracking: 0em,
    size: 120, lead: 0.12, top-edge: "cap-height", align-to: left, is-long: false, highlight: none,
    seed: 1, key: "passes") = context {
  let st = (font: font, weight: weight, style: style, tracking: tracking, top-edge: top-edge)
  let ps = _resolve(passes, key, seed)
  let ps = if is-long { ps.filter(p => p.at("long", default: true)) } else { ps }
  let piece(p, sz) = block(width: w, {
    set par(leading: lead * sz, justify: false)
    align(align-to, _paint(p, base, k, st, sz, txt, highlight: highlight))
  })
  let fitted(p) = {
    let sz = size * k
    while sz > 10pt and measure(piece(p, sz)).height > h { sz = sz * 0.95 }
    piece(p, sz)
  }
  let layers = ps.map(p => place(top + left, dx: p.at("dx", default: 0) * k, dy: p.at("dy", default: 0) * k, fitted(p)))
  let box-size = measure(fitted(ps.last()))
  box(width: box-size.width, height: box-size.height, layers.join())
}

// uno de la lista, por clave y semilla: WallTypst `{ elegir = [...] }`
#let choose(list, key, seed) = list.at(calc.min(list.len() - 1, int(azar(key, seed) * list.len())))

// un carácter protagonista con N pasadas, sin ajuste: WallTypst capa `glifo`. `size` en k.
#let glyph(txt, passes, k, font: "", base: black, weight: "regular", style: "normal", tracking: 0em, size: 100,
    target-width: none, size-max: 99999, align-to: top + left, size-abs: none, seed: 1, key: "passes") = context {
  let st = (font: font, weight: weight, style: style, tracking: tracking, top-edge: "bounds", bottom-edge: "bounds")
  let ps = _resolve(passes, key, seed)
  // `target-width`: el ancho que debe medir (WallTypst `ancho-w`); el tamaño no pasa de `size-max`; `size-abs`: un tamaño en pt
  let sz = if size-abs == none { size * k } else { size-abs }
  let sz = if target-width == none { sz } else {
    calc.min(sz * (target-width / measure(_paint((:), black, k, st, sz, txt)).width), size-max * k)
  }
  let piece(p) = _paint(p, base, k, st, sz, txt)
  let layers = ps.map(p => place(align-to, dx: p.at("dx", default: 0) * k, dy: p.at("dy", default: 0) * k, piece(p)))
  let box-size = measure(piece(ps.last()))
  box(width: box-size.width, height: box-size.height, layers.join())
}

// la primera letra del texto, en mayúscula (WallTypst `desde = initial`)
#let initial(t) = {
  let c = t.clusters().find(c => c.match(regex("\p{L}")) != none)
  if c == none { none } else { upper(c) }
}

// la frase en bandas de color, una por línea, con sangría; el texto de cada banda se lee sobre su fondo.
// `fills`/`inks`/`indents` se repiten cíclicamente (`indents` en k). WallTypst forma `bandas`.
#let bands(txt, w, h, fills, inks, indents, k, font: "", fallback: black, pad: 0.28, sep: 0.12, size-max: 99999,
    lines-max: 6, weight: "regular", style: "normal", tracking: 0em) = context {
  let est(sz, f) = (font: font, size: sz, weight: weight, style: style, tracking: tracking, fill: f,
    top-edge: "cap-height", bottom-edge: "baseline")
  let indent(i) = indents.at(calc.rem(i, indents.len())) * k
  let plan(n) = {
    let ls = _split-lines(txt, n)
    let s0 = 100pt
    let widths = ls.map(l => measure(text(..est(s0, black), l)).width + 2 * pad * s0)
    let sz-w = calc.min(..ls.enumerate().map(((i, l)) => s0 * ((w - indent(i)) / widths.at(i))))
    let sz-h = h / (ls.len() * (1 + 2 * pad * 0.8 + sep))
    (ls, calc.min(sz-w, sz-h, size-max * k))
  }
  let (ls, sz) = range(1, lines-max + 1).map(plan).sorted(key: p => p.at(1)).last()
  stack(dir: ttb, spacing: sz * sep, ..ls.enumerate().map(((i, l)) => {
    let fill = fills.at(calc.rem(i, fills.len()))
    std.pad(left: indent(i), box(fill: fill, inset: (x: sz * pad, y: sz * pad * 0.8),
      text(..est(sz, legible(inks.at(calc.rem(i, inks.len())), fill, fallback, sz)), l)))
  }))
}

#let _factor(a) = (
  if a == "left" or a.ends-with("left") { 0 } else if a == "right" or a.ends-with("right") { 1 } else { 0.5 },
  if a.starts-with("top") { 0 } else if a.starts-with("bottom") { 1 } else { 0.5 },
)

// el cuerpo anclado en una caja cw × ch (WallTypst `en`): (x, y) en fracciones de la caja
#let at(cw, ch, x, y, anchor, body, dx: 0pt, dy: 0pt) = context {
  let (fx, fy) = _factor(anchor)
  let s = measure(body)
  place(top + left, dx: x * cw - s.width * fx + dx, dy: y * ch - s.height * fy + dy, body)
}
