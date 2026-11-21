// ─────────────────────────────────────────────────────────────
//  core/v2/series.typ — el tipo "series": una página de una serie numerada
//
//  Hijos:  title (lo que dice esta página; si falta, el contenido suelto)
//          detail (el desarrollo, bajo el título)
//  Argumentos propios:
//          index, total   la página y cuántas son («3» de «8»); con `repeat`
//                         en frame los pone frame
//          next           abajo a la derecha, salvo en la última página
//                         (por defecto «Desliza →»; none = nunca)
//  Reglas de colocación:
//    · barra de progreso segmentada arriba (un tramo por página, llenos hasta la actual)
//    · contador «03 / 08» bajo la barra (con ceros solo si hay 10 o más páginas)
//    · pie: brand a la izquierda, next a la derecha (no en la última)
//    · el título se achica de 2 en 2 pt (de 124 a 44) hasta caber en su tramo
//    · el bloque título + detalle se centra en el espacio libre, un poco por
//      encima del centro óptico (38 % del sobrante)
// ─────────────────────────────────────────────────────────────

#import "parts.typ": part, read-parts
#import "primitives.typ": dimensions, fit-to-height, resolve-theme, resolve-brand

#let title(body) = part("title", body)
#let detail(body) = part("detail", body)

#let series(
  index,
  total,
  heading,
  body-text: none,
  next: [Desliza →],
  format: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
) = {
  assert(type(index) == int and type(total) == int and index >= 1 and index <= total,
    message: "series: `index` va de 1 a `total` (recibí " + repr(index) + " de " + repr(total) + ")")
  let tm = resolve-theme(theme, "lamina")
  let ink = tm.ink
  let brand = resolve-brand(brand, ink, format)
  let muted = tm.muted
  let accent = if accent == auto { tm.accent } else { accent }
  let (width, height) = dimensions(format)
  let margin = 88pt
  let usable = width - 2 * margin
  let side = calc.min(width, height)

  page(width: width, height: height, margin: 0pt, fill: tm.background, {
    set text(font: "Literata", fill: ink, lang: "es", hyphenate: false)
    set par(leading: 0.3em)

    // barra de progreso: un tramo por página; llenos hasta la actual
    let gap = 10pt
    let segment = (usable - gap * (total - 1)) / total
    for i in range(total) {
      place(
        dx: margin + i * (segment + gap), dy: margin,
        rect(width: segment, height: 10pt, radius: 5pt, fill: if i < index { accent } else { ink.transparentize(85%) }),
      )
    }

    // contador «03 / 08»
    let zeros(n) = if total >= 10 and n < 10 { "0" + str(n) } else { str(n) }
    let y = margin + 10pt + 0.04 * side
    place(dx: margin, dy: y, text(
      font: "Jost", size: 32pt, weight: 700, tracking: 0.12em, fill: accent,
      zeros(index) + " / " + zeros(total),
    ))
    let text-y = y + 32pt + 0.06 * side

    context {
      // pie: brand a la izquierda, next a la derecha (salvo en la última)
      let has-next = next != none and index < total
      let foot = if brand != none or has-next {
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          if brand != none { brand },
          if has-next { text(font: "Jost", size: 34pt, weight: 700, fill: accent, next) },
        )
      }
      let foot-h = if foot != none { measure(block(width: usable, foot)).height } else { 0pt }
      if foot != none { place(dx: margin, dy: height - margin - foot-h, block(width: usable, foot)) }

      // título y detalle: el título se achica hasta caber en su tramo
      let detail-block = if body-text != none {
        block(width: usable, text(font: "Jost", size: 46pt, weight: 400, fill: muted, body-text))
      }
      let air = 0.7 * 46pt
      let detail-h = if detail-block != none { measure(detail-block).height + air } else { 0pt }
      let available = height - text-y - margin - foot-h - 0.04 * height
      let limit = calc.min(height * 0.5, available - detail-h)
      let make-title(s) = block(width: usable, text(size: s, weight: 700, tracking: -0.015em, heading))
      let s = fit-to-height(make-title, 124pt, limit, min: 44pt, step: 2pt)
      let stack = block(width: usable, {
        make-title(s)
        if detail-block != none {
          v(air + 0.05 * s)
          detail-block
        }
      })
      // centrado en el espacio libre, un poco por encima del centro óptico
      let stack-y = text-y + calc.max(0pt, available - measure(stack).height) * 0.38
      place(dx: margin, dy: stack-y, stack)
    }
  })
}

// Adaptador del contrato: lee los hijos del cuerpo y llama al motor.
#let make(
  body,
  format: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  index: 1,
  total: 1,
  next: [Desliza →],
) = {
  let p = read-parts(body)
  series(
    index, total,
    p.at("title", default: p.at("content", default: [])),
    body-text: p.at("detail", default: none),
    next: next, format: format, theme: theme, accent: accent, brand: brand,
  )
}
