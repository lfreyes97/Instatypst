// ─────────────────────────────────────────────────────────────
//  presets/leaves/variants/flower.typ — variant: "flower" (en v1, composición "flor")
//
//  Cuatro hojas en 2 × 2 con la punta al centro. Título arriba a la izquierda y
//  párrafo arriba a la derecha; abajo, un segundo título (footer), una etiqueta
//  (tag) con nota (note) y una barra negra que sangra por la derecha; el rótulo
//  (caption) en vertical, a la izquierda de la flor. Es la composición por
//  defecto de leaves, y la única que usa footer, tag y note.
//
//  Una variante de leaves es una función `c => contenido` (el contexto lo arma
//  _kit.typ). Medidas en unidades de la lámina de 380.
// ─────────────────────────────────────────────────────────────

#import "/src/resources/motifs/_hojas-piezas.typ": flor

#let variant(c) = {
  let (L, W, H, M, u, roles, parts) = (c.L, c.W, c.H, c.M, c.u, c.roles, c.parts)
  let (put, guide-box) = (c.put, c.guide-box)
  let (headline, prose, caption) = (parts.headline, parts.prose, parts.caption)
  let (footer, tag, note) = (parts.footer, parts.tag, parts.note)

  // ── arriba: título a la izquierda, párrafo en la columna derecha ──
  // (la columna derecha no pasa de 124 de ancho: en apaisado se va a la
  // derecha y deja una columna central para la flor)
  let colx = calc.max(0.605 * W, W - 44 - 124)
  let right = W - 44
  let t = (c.headline-block)(headline, 22, 28, colx - M - 18)
  put(M, M, t.body)
  guide-box(M, M, M + t.w, M + t.h)
  let fh = 0
  if prose != none {
    let b = (c.text-block)(prose, c.size, right - colx)
    fh = measure(b).height / u
    put(colx, M, b)
    guide-box(colx, M, right, M + fh)
  }
  let ceiling = M + calc.max(t.h, fh)

  // ── abajo: el pie a la izquierda; etiqueta, nota y barra a la derecha ──
  let base = H - 50
  let bar = 8.7
  // la barra acompaña a la etiqueta y la nota (sola, sin nada encima, sobra)
  if tag != none or note != none {
    place(top + left, dx: L(colx), dy: L(base - bar), rect(width: c.width - L(colx), height: L(bar), fill: roles.ink))
  }
  let floor-y = base - bar - 11
  let pw = 0
  if footer != none {
    let p = (c.headline-block)(footer, 18.5, 23.4, colx - M - 14, upper-case: false, lines: 2, who: "footer")
    put(M, base - p.h, p.body)
    guide-box(M, base - p.h, M + p.w, base)
    floor-y = calc.min(floor-y, base - p.h)
    pw = p.w
  }
  let y = base - bar - 11 // base de la última línea de la nota
  if note != none {
    let b = (c.text-block)(note, 5.6, right - colx, step: 1.28, fill: roles.ink)
    let h = measure(b).height / u
    put(colx, y - h, b)
    guide-box(colx, y - h, right, y)
    y -= h + 6.7
  }
  if tag != none {
    let e = (c.cap-box)(8.7, c.display, weight: 700, fill: roles.ink, tag)
    let d = 7.4
    put(colx, y - 8.7 / 2 - d / 2, circle(radius: L(d / 2), fill: roles.ink))
    put(colx + d + 4.6, y - 8.7, e)
    y -= 8.7
  }
  floor-y = calc.min(floor-y, y)

  // ── la flor, con el rótulo a su izquierda. Dos sitios posibles: el hueco
  // entre las dos bandas (a lo ancho, como la referencia) o la columna entre
  // los textos de la izquierda y la columna derecha (a lo alto, en apaisado);
  // gana el que la deja más grande ──
  let rw = if caption == none { 0 } else { measure((c.caption-block)(caption)).width / u + 27 }
  let x0 = M + rw
  let sa = calc.min(0.84 * (right - x0), 0.645 * (floor-y - ceiling)) / 2
  let xb = M + calc.max(t.w, pw) + 30
  let sb = 0.84 * calc.min(colx - 30 - (xb + rw), base - M) / 2
  let (rx, x0, x1, y0, y1, S) = if sa >= sb { (M, x0, right, ceiling, floor-y, sa) } else { (xb, xb + rw, colx - 30, M, base, sb) }
  guide-box(x0, y0, x1, y1, c: blue)
  let S = if c.side == auto { S } else { c.side }
  if S < 30 {
    panic("leaves: la flor no cabe (queda un lado de " + str(calc.round(S)) + " unidades); acorta los textos o usa un formato más alto")
  }
  let (cx, cy) = ((x0 + x1) / 2, (y0 + y1) / 2)
  put(cx - S, cy - S, flor(L(S), roles.deep, roles.accent, roles.paper, r-anillo: c.ring, r-hueco: c.hole))
  if caption != none {
    let r = (c.caption-block)(caption)
    let rh = measure(r).height / u
    put(rx, cy - rh / 2, r)
  }
}
