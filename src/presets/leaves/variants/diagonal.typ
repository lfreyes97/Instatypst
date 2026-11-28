// ─────────────────────────────────────────────────────────────
//  presets/leaves/variants/diagonal.typ — variant: "diagonal" (en v1, composición "diagonal")
//
//  Dos hojas que se tocan por la punta, un punto negro y el título apilado
//  abajo; párrafo (prose) arriba a la izquierda; a la derecha, el rótulo
//  (caption) en vertical sobre un filete que baja hasta la base del título.
//  No usa footer, tag ni note.
//
//  Una variante de leaves es una función `c => contenido`. Medidas en unidades
//  de la lámina de 380.
// ─────────────────────────────────────────────────────────────

#import "/src/resources/motifs/_hojas-piezas.typ": pareja

#let variant(c) = {
  let (L, W, H, M, u, roles, parts) = (c.L, c.W, c.H, c.M, c.u, c.roles, c.parts)
  let (put, guide-box) = (c.put, c.guide-box)
  let (headline, prose, caption) = (parts.headline, parts.prose, parts.caption)

  // ── el rótulo arriba a la derecha y el filete que baja de él ──
  let base = H - 52
  let fx = W - M - 3 // eje del rótulo y del filete
  let caption-foot = M
  if caption != none {
    let r = (c.caption-block)(caption)
    let m = measure(r)
    put(fx - m.width / u / 2, M, r)
    caption-foot = M + m.height / u + 16
  }
  place(top + left, dx: L(fx) - L(0.65), dy: L(caption-foot), rect(width: L(1.3), height: L(base - caption-foot), fill: roles.ink))

  // ── arriba a la izquierda, el párrafo ──
  let ceiling = M
  let fw = 0
  if prose != none {
    fw = calc.min(0.355 * W, 150, fx - 24 - M)
    let b = (c.text-block)(prose, c.size, fw)
    let h = measure(b).height / u
    put(M, M, b)
    guide-box(M, M, M + fw, M + h)
    ceiling = M + h
  }

  // ── abajo: el título apilado, y el punto encima ──
  let t = (c.headline-block)(headline, 24.5, 32.4, fx - 24 - M)
  put(M, base - t.h, t.body)
  guide-box(M, base - t.h, M + t.w, base)
  let d = 22.7
  let dot-y = base - t.h - 14 - d
  put(M, dot-y, circle(radius: L(d / 2), fill: roles.ink))

  // ── el par. Dos sitios posibles: entre el párrafo y el punto, apoyado sobre
  // el punto (si sobra mucho alto, centrado), como la referencia; o centrado
  // entre los textos de la izquierda y el filete (en apaisado). Gana el que lo
  // deja más grande ──
  let (x0, x1) = (M - 4, fx - 24)
  let (y0, y1) = (ceiling + 30, dot-y - 14)
  let sa = calc.min(0.4 * (x1 - x0), (y1 - y0) / 2)
  let xb = M + calc.max(t.w, fw) + 30
  let sb = 0.84 * calc.min(x1 - xb, base - M) / 2
  let S = if c.side == auto { calc.max(sa, sb) } else { c.side }
  if S < 30 {
    panic("leaves: el par no cabe (queda un lado de " + str(calc.round(S)) + " unidades); acorta los textos o usa un formato más alto")
  }
  let (px, py) = if sa >= sb {
    let spare = (y1 - y0) - 2 * S
    (x0, if spare <= S { y1 - 2 * S } else { (y0 + y1) / 2 - S })
  } else {
    ((xb + x1) / 2 - S, (M + base) / 2 - S)
  }
  if sa >= sb { guide-box(x0, y0, x1, y1, c: blue) } else { guide-box(xb, M, x1, base, c: blue) }
  put(px, py, pareja(L(S), roles.deep, roles.accent, roles.paper, r-anillo: c.ring, r-hueco: c.hole))
}
