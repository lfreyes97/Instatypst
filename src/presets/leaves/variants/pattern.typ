// ─────────────────────────────────────────────────────────────
//  presets/leaves/variants/pattern.typ — variant: "pattern" (en v1, composición "patron")
//
//  Una cinta de pares de hojas a 45° que el borde recorta; el título y el
//  párrafo (prose) abajo a la izquierda, el rótulo (caption) arriba a la
//  derecha. La cinta se corre sola (perpendicular a sí misma) hasta dejar
//  libres los dos rincones del texto. No usa footer, tag ni note.
//
//  Una variante de leaves es una función `c => contenido`. Medidas en unidades
//  de la lámina de 380.
// ─────────────────────────────────────────────────────────────

#import "/src/resources/motifs/_hojas-piezas.typ": pareja

#let variant(c) = {
  let (L, W, H, M, u, roles, parts) = (c.L, c.W, c.H, c.M, c.u, c.roles, c.parts)
  let (put, guide-box) = (c.put, c.guide-box)
  let (headline, prose, caption) = (parts.headline, parts.prose, parts.caption)

  // ── texto abajo a la izquierda, rótulo arriba a la derecha ──
  let base = H - 46
  let tw-max = 0.62 * W - M
  let t = (c.headline-block)(headline, 25, 32.8, tw-max, lines: 2)
  let (fw, fh) = (0, 0)
  let b = none
  if prose != none {
    fw = calc.min(0.355 * W, 150, tw-max)
    b = (c.text-block)(prose, c.size, fw)
    fh = measure(b).height / u
  }
  let sep = if prose == none { 0 } else { 19.4 }
  let ty = base - fh - sep - t.h
  put(M, ty, t.body)
  guide-box(M, ty, M + t.w, ty + t.h)
  if b != none {
    put(M, base - fh, b)
    guide-box(M, base - fh, M + fw, base)
  }
  let (rx0, ry1) = (W - M, M)
  if caption != none {
    let r = (c.caption-block)(caption)
    let m = measure(r)
    rx0 = W - M - m.width / u
    ry1 = M + m.height / u
    put(rx0, M, r)
    guide-box(rx0, M, W - M, ry1)
  }

  // ── la cinta: pares de hojas cuyas puntas caen sobre la recta y = x + d.
  // Una hoja de la cinta llega como mucho a (1 + √2/2) lados de la recta,
  // medido en y − x. `d` queda en el medio de lo que dejan libre el texto
  // (abajo a la izquierda) y el rótulo (arriba a la derecha); si no hay sitio,
  // las hojas se achican. ──
  let reach = 1 + calc.sqrt(2) / 2
  let (air-t, air-r) = (46, 42)
  // los rincones del texto: el de arriba a la derecha de cada pieza
  let corners-t = ((M + t.w, ty),) + if b != none { ((M + fw, base - fh),) } else { () }
  let lim-t = calc.min(..corners-t.map(((x, y)) => y - x)) - air-t
  let lim-r = if caption == none { M - (W - M) } else { ry1 - rx0 } + air-r
  let S0 = if c.side == auto { 83 } else { c.side }
  let S = S0
  while lim-t - lim-r < 2 * reach * S and S > 0.5 * S0 { S = S * 0.95 }
  if lim-t - lim-r < 2 * reach * S {
    panic("leaves: la cinta de hojas no cabe entre el texto y el rótulo; acorta el título o la frase, quita el rótulo o usa un formato más alto")
  }
  let d = (lim-t + lim-r) / 2
  let step = 0.8 * S
  if c.guides {
    for dd in (d, d - reach * S, d + reach * S) {
      place(top + left, line(start: (0pt, L(dd)), end: (L(H - dd), c.height), stroke: 0.8pt + blue))
    }
  }
  // puntas en x = M + i·step; todas las que caen en la página
  let i0 = calc.floor((-S - M) / step)
  let i1 = calc.ceil((W + S - M) / step)
  place(top + left, box(width: c.width, height: c.height, clip: true, {
    for i in range(i0, i1 + 1) {
      let (px, py) = (M + i * step, M + i * step + d)
      if px < 0 or px > W or py < 0 or py > H { continue }
      let (c1, c2) = if calc.rem(calc.abs(i), 2) == 0 { (roles.accent, roles.deep) } else { (roles.deep, roles.accent) }
      put(px - S, py - S, pareja(L(S), c1, c2, roles.paper, diagonal: "subida", r-anillo: c.ring, r-hueco: c.hole))
    }
  }))
}
