// ─────────────────────────────────────────────────────────────
//  presets/leaves/_kit.typ — las piezas de texto y el contexto de las variantes
//
//  Lo que `leaves` comparte entre sus tres composiciones (flower, diagonal,
//  pattern): la escala de la lámina, las cajas de texto medidas, el rótulo
//  vertical y las guías. `kit(...)` devuelve el diccionario `c` que reciben las
//  variantes; solo se llama dentro de un `context` (usa `measure`).
//
//  Unidades: la lámina de referencia mide 380 de ancho (las cotas de las
//  variantes están en esas unidades); `L(n)` las pasa a pt con k, la escala de v1.
//  Procedencia: v1, carteles/hojas.typ.
// ─────────────────────────────────────────────────────────────

// Texto plano de un contenido (para partir el título en palabras).
#let _plain(c) = {
  if c == none { "" }
  else if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_plain).join("", default: "") }
  else if c.has("child") { _plain(c.child) } // contenido con estilos (`styled`)
  else if c.has("body") { _plain(c.body) }
  else if c.func() == linebreak { "\n" }
  else if c == [ ] { " " }
  else { " " }
}

#let kit(
  width, height, k, roles, parts,
  display: "Poppins", body: "Inter", weight: 800, size: 8.3,
  side: auto, ring: 0.30, hole: 0.185, guides: false,
) = {
  let L(n) = n * k * 1pt
  let (W, H) = (width / L(1), height / L(1))
  let u = L(1)

  // Texto con la caja de línea = altura de mayúscula, que mide `cap` unidades
  // sea cual sea la fuente.
  let cap-box(cap, fam, ..args, content) = {
    let ref = measure(text(font: fam, size: 100pt, top-edge: "cap-height", bottom-edge: "baseline", ..args, [H])).height
    text(font: fam, size: L(cap) / (ref / 100pt), top-edge: "cap-height", bottom-edge: "baseline", ..args, content)
  }
  // Título: cap y paso (entre bases) en unidades, ancho máximo. Devuelve el
  // bloque, su ancho y alto (unidades) y el factor con que se achicó. Una
  // palabra que no cabe achica todo; si tiene más de `lines` renglones también
  // se achica, hasta un 45 %.
  let headline-block(c, cap, step, max-width, upper-case: true, lines: 3, who: "headline") = {
    // (las palabras, del texto antes de `upper`: el contenido que devuelve
    // `upper` ya no deja leer su texto)
    let plain = _plain(c)
    let plain = if upper-case { upper(plain) } else { plain }
    let c = if upper-case { upper(c) } else { c }
    let ta = (weight: weight, tracking: 0em, fill: roles.ink)
    let make(f, w) = {
      let t = cap-box(cap * f, display, ..ta, c)
      let p = par(leading: L((step - cap) * f), justify: false, t)
      if w == none { box(p) } else { block(width: L(w), p) }
    }
    let words = plain.split(regex("\\s+")).filter(x => x != "")
    let word-width(f) = calc.max(0, ..words.map(x => measure(cap-box(cap * f, display, ..ta, x)).width / u))
    let f = 1.0
    while f > 0.45 {
      let free = measure(make(f, none))
      if free.width / u <= max-width {
        let n = calc.round((free.height / u - cap * f) / (step * f)) + 1
        if n <= lines { return (body: make(f, none), w: free.width / u, h: free.height / u, f: f) }
      } else if word-width(f) <= max-width {
        let b = measure(make(f, max-width))
        let n = calc.round((b.height / u - cap * f) / (step * f)) + 1
        if n <= lines { return (body: make(f, max-width), w: max-width, h: b.height / u, f: f) }
      }
      f = f * 0.94
    }
    panic("leaves: `" + who + "` no cabe en " + str(lines) + " renglones de " + str(calc.round(max-width)) + " unidades ni achicado a la mitad; acórtalo o pártelo con `\\`")
  }
  // Párrafo de `size` unidades, paso 11/8,3, en un ancho dado.
  let text-block(c, size, w, step: 1.325, fill: roles.quiet) = {
    let s = L(size)
    let cap-ratio = measure(text(font: body, size: 100pt, [H])).height / 100pt
    block(width: L(w), text(font: body, size: s, fill: fill, weight: 400,
      par(leading: s * (step - cap-ratio), justify: false, c)))
  }
  // El rótulo vertical (se lee de abajo arriba): caja girada.
  let caption-block(c) = rotate(-90deg, reflow: true,
    cap-box(6, display, weight: 800, tracking: 0.06em, fill: roles.ink, upper(c)))
  let put(x, y, content) = place(top + left, dx: L(x), dy: L(y), content)
  let guide-box(x0, y0, x1, y1, c: red) = if guides {
    put(x0, y0, rect(width: L(x1 - x0), height: L(y1 - y0), stroke: 0.8pt + c))
  }

  (
    L: L, W: W, H: H, u: u, M: 42, // M: el margen
    width: width, height: height,
    roles: roles, parts: parts,
    display: display, body: body,
    size: size, side: side, ring: ring, hole: hole, guides: guides,
    cap-box: cap-box, headline-block: headline-block, text-block: text-block,
    caption-block: caption-block, put: put, guide-box: guide-box,
  )
}
