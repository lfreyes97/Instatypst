// ─────────────────────────────────────────────────────────────
//  scaffold.typ — el andamio sobre engine_v1 (Instatypst)
//
//  Contrato semántico en inglés que se traduce 1:1 a `carteles.suizo`
//  (src/). Quien dibuja es engine_v1; esto solo pone nombres:
//
//    eyebrow   → etiqueta        author → autor      format → formato
//    question  → planteo         dates  → fechas     brand  → marca
//    statement → frase           accent → acento     theme  → tema
//    headline  → remate  (alias: display)
//
//  La prueba es `just cmp suizo`: el PNG debe ser idéntico al de
//  llamar a carteles.suizo directamente.
//
//  `type` es "swiss" (la retícula de diseño suizo). El nombre `grid`
//  queda reservado para la grilla real de WallTypst.
//
//  TEMPORAL: desaparece cuando exista engine_v2. La tabla de nombres
//  completa vive en docs/traduccion.md.
// ─────────────────────────────────────────────────────────────

#import "../src/lib.typ": carteles

// Los hijos semánticos guardan su clase y su contenido en metadata.
#let _part(kind, body) = [#metadata((kind: kind, body: body)) <part>]
#let eyebrow(body) = _part("eyebrow", body)
#let question(body) = _part("question", body)
#let statement(body) = _part("statement", body)
#let headline(body) = _part("headline", body)
#let display(body) = _part("headline", body)  // alias de headline

#let _flatten(c) = if c.has("children") { c.children.map(_flatten).flatten() } else { (c,) }

#let _parts(body) = {
  let found = (:)
  let plain = ()
  for c in _flatten(body) {
    if c.func() == metadata {
      if "kind" in c.value { found.insert(c.value.kind, c.value.body) }
    } else if repr(c.func()) != "space" {
      plain.push(c)
    }
  }
  found + (content: plain.fold([], (a, b) => a + b))
}

#let frame(
  type: "swiss",
  format: (1080, 1350),
  theme: "suizo",
  accent: auto,
  brand: none,
  author: none,
  dates: none,
  body,
) = {
  if type != "swiss" {
    panic("frame: tipo desconocido " + repr(type) + " (por ahora solo \"swiss\")")
  }
  let p = _parts(body)
  let extra = (tema: theme)
  if accent != auto { extra.insert("acento", accent) }
  carteles.suizo(
    p.at("statement", default: p.at("content", default: [])),
    p.at("headline", default: []),
    formato: format,
    etiqueta: p.at("eyebrow", default: none),
    planteo: p.at("question", default: none),
    autor: author, fechas: dates, marca: brand,
    ..extra,
  )
}
