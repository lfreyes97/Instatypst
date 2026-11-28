// ─────────────────────────────────────────────────────────────
//  hinge.typ — el preset `hinge` (en v1, `carteles.gozne`): cita + diagrama radial
//
//  hinge = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): quote, list, pivot, author, work, brand;
//  cada uno también como argumento (`author: […]`). `quote` y `list` son los de
//  Typst: la cita entera y la lista de hojas (un ítem por hoja, la hoja i lleva el
//  disco i). `pivot` es el concepto del centro del diagrama (1–2 renglones).
//  Opciones del preset: angles, positions. El resto viaja en el tema (paper, ink,
//  quiet, accent, light) y en `fonts`.
//
//  De un lado la cita entera, con llamadas numeradas voladas; del otro, un gozne
//  visto desde arriba —el perno es la idea central— con N hojas que giran sobre
//  él, cada una con su disco numerado y su rótulo, igual que las llamadas de la
//  cita. Flechas de giro entre hojas y la órbita punteada del giro completo.
//
//  Disposición según el formato: apaisado (ancho > 1,2 × alto) -> cita a la
//  izquierda, diagrama a la derecha; vertical o cuadrado -> cita arriba, diagrama
//  debajo, pie a todo el ancho. El formato por defecto es 1600×900 ("twitter").
//
//    #frame(preset: "hinge", author: [B. B. Warfield], work: [La imputación])[
//      #quote[[La imputación] es el gozne … la raza#callout(1), …]
//      #pivot[La \ imputación]
//      #list([La pecaminosidad \ de la raza], [La satisfacción \ de Cristo], …)
//    ]
//
//  La llamada de la cita: una cifra volada con la etiqueta `<hinge-callout>`; el
//  preset le da el color de acento y la letra del pie (show rule sobre la
//  etiqueta), así que no hay que repetirlos. La función que la escribe no existe
//  aún (v1 `llamada`, sin entrada en la tabla): ver «Pendiente».
//
//  Opciones del preset:
//    angles      ángulos de las hojas; auto = la primera hacia arriba y el resto
//                repartido parejo en sentido horario
//    positions   array de (x:, y:, side:) por hoja (v1 `rotulos`, `lado`): caja de
//                330 de ancho en (x, y), con el disco a la izquierda (side: left)
//                o a la derecha (side: right); auto = cada rótulo pegado al
//                extremo de su hoja
//
//  Escala: el tipo escala con √(ancho × alto) (1 en 1600×900) y el diagrama, con
//  lo que quepa en su zona. Es la `u` de v1; aquí se llama `k` y se conserva por
//  la paridad (no es la `u` de V2). Con 4 o más hojas, hojas y flechas se afinan
//  para no tocarse; hasta 5 se sostiene.
//
//  Roles del tema: los cinco más uno propio, `light` (la cifra y el perno, sobre
//  el acento), que pasa por modules/color como los demás. `guide` no lo usa.
//  Fuentes: Instrument Sans (rótulos y pie) y Libre Baskerville (la cita); ninguna
//  pareja de typography las trae juntas, se toman sueltas por `ctx.font`. `fonts:
//  (body: …, main: …)` las sobreescribe: `body` rotula y `main` es la cita (ojo:
//  el scaffold iguala `main` a `body` si solo se da `body`).
//
//  Pendiente (decisiones sin tomar; se mantiene el comportamiento de v1):
//    · `diagram` (v1 `diagrama`, recurso:diagram): v1 permitía fijar a mano
//      (x:, y:, escala:) la caja del dibujo; aquí el diagrama se coloca siempre
//      solo, centrado en su zona.
//    · el fondo de papel de plano (cuadrícula tenue + grano) es un recurso que no
//      existe: se dibuja siempre, con superbg.
//    · la llamada de la cita (`llamada` en v1) no está traducida; los tests la
//      escriben a mano con la etiqueta `<hinge-callout>`.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ" as superbg

#let _default-theme = (
  paper: rgb("#ece8df"),
  ink: rgb("#1f262d"),
  quiet: rgb("#525a61"), // ≈ 6:1 sobre el papel
  accent: rgb("#a8361f"), // ≈ 5.6:1 sobre el papel
  // sin `guide`: v1 no lo tenía y hinge no lo usa; modules/color lo deriva
  light: rgb("#f7f1e6"),
)

// Texto plano de un contenido (para medir palabra por palabra).
#let _plain-text(c) = {
  if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_plain-text).join() }
  else if c.has("body") { _plain-text(c.body) }
  else if c == [ ] { " " }
  else { "" }
}

// El tamaño más grande (de `max` hacia abajo, de a `step`) con el que
// `make(tamaño)` cabe en `width` × `height`, sin que su palabra más larga se
// salga del ancho. Usar dentro de `context`.
#let _fit(make, width, height, text-body: none, max: 140pt, min: 24pt, step: 2pt) = {
  let words = if text-body == none { () } else {
    _plain-text(text-body).split(regex("\\s+")).filter(p => p != "")
  }
  let fits(s) = {
    let longest = if words.len() == 0 { 0pt } else {
      calc.max(..words.map(p => measure(text(size: s, p)).width))
    }
    longest <= width and measure(block(width: width, make(s))).height <= height
  }
  let s = max
  while s > min and not fits(s) { s -= step }
  make(s)
}

// Aplana el cuerpo y separa lo que hinge lee de él: la cita (el `quote`, o el
// contenido suelto si no lo hay) y las hojas (los ítems del `list`).
#let _flatten(c) = if c.has("children") and c.func() not in (list, enum, terms) {
  c.children.map(_flatten).flatten()
} else { (c,) }

#let _read-body(body) = {
  let quote-body = none
  let loose = ()
  let leaves = ()
  for c in _flatten(body) {
    if c.func() == list {
      leaves += c.children.map(i => i.body)
    } else if c.func() == list.item {
      leaves.push(c.body)
    } else if c.func() == quote {
      quote-body = c.body
    } else if c.func() == metadata or repr(c.func()) in ("space", "parbreak") {
      // los elementos los lee read-parts; el espacio no cuenta
    } else {
      loose.push(c)
    }
  }
  (quote: if quote-body != none { quote-body } else { loose.fold([], (a, b) => a + b) }, leaves: leaves)
}

#let _rules(ctx, angles, positions) = {
  let part(kind) = { let e = ctx.parts.at(kind, default: none); if e == none { none } else { e.body } }
  let (author, work, pivot) = (part("author"), part("work"), part("pivot"))
  let read = _read-body(ctx.body)
  let quote-body = if part("quote") != none { part("quote") } else { read.quote }
  let leaves = if part("list") != none { part("list") } else { read.leaves }
  let pivot = if pivot == none { [] } else { pivot }
  let (W, H, tm) = (ctx.width, ctx.height, ctx.tm)
  let (paper, ink, quiet, accent, light) = (tm.paper, tm.ink, tm.quiet, tm.accent, tm.light)
  let brand = ctx.brand
  let formato = (W / 1pt, H / 1pt)
  // unidad tipográfica: 1 en 1600×900, crece con el área
  let k = calc.sqrt(formato.at(0) * formato.at(1)) / calc.sqrt(1600 * 900)
  let landscape = W > H * 1.2

  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("instrument-sans") }
  let quote-family = if "main" in ctx.fonts { ctx.fonts.main } else { (ctx.font)("libre-baskerville") }

  let n = leaves.len()
  let angs = if angles == auto { range(n).map(i => -90deg + i * 360deg / n) } else { angles }
  let step = 360deg / n
  // con 4 o más hojas se afinan hojas y flechas para que no se toquen
  let thin = if n <= 3 { 1 } else { step / 120deg }
  let esc(v) = if thin == 1 { v } else { v * thin }

  // ── El gozne (SVG): caja de 760×740, perno en (380, 380) ──
  let cx = 380
  let cy = 380
  let polar(r, a) = (cx + r * calc.cos(a), cy + r * calc.sin(a))
  let pt(p) = str(p.at(0)) + " " + str(p.at(1))
  let mw = esc(40) // medio ancho de la hoja

  let leaf(a) = {
    let nn = a + 90deg
    let (r0, r1) = (96, 292)
    let esq = (polar(r0, a), polar(r1, a))
    let off(p, s) = (p.at(0) + s * mw * calc.cos(nn), p.at(1) + s * mw * calc.sin(nn))
    let d = "M " + pt(off(esq.at(0), 1)) + " L " + pt(off(esq.at(1), 1)) + " L " + pt(off(esq.at(1), -1)) + " L " + pt(off(esq.at(0), -1)) + " Z"
    let holes = (165, 240).map(r => {
      let p = polar(r, a)
      "<circle cx='" + str(p.at(0)) + "' cy='" + str(p.at(1)) + "' r='" + str(esc(11)) + "' fill='" + paper.to-hex() + "'/>"
    }).join("")
    "<path d='" + d + "' fill='" + ink.to-hex() + "' stroke='" + ink.to-hex() + "' stroke-width='10' stroke-linejoin='round'/>" + holes
  }

  // Arco de giro entre dos hojas, con punta de flecha al final.
  let arc(a) = {
    let r = 190
    let (a0, a1) = (a + step * 28 / 120, a + step * 92 / 120)
    let p0 = polar(r, a0)
    let p1 = polar(r, a1)
    // punta: triángulo tangente al final del arco
    let t = a1 + 90deg
    let nn = a1
    let base = esc(15)
    let q1 = (p1.at(0) + base * calc.cos(nn), p1.at(1) + base * calc.sin(nn))
    let q2 = (p1.at(0) - base * calc.cos(nn), p1.at(1) - base * calc.sin(nn))
    let tip = (p1.at(0) + esc(26) * calc.cos(t), p1.at(1) + esc(26) * calc.sin(t))
    "<path d='M " + pt(p0) + " A " + str(r) + " " + str(r) + " 0 0 1 " + pt(p1) + "' fill='none' stroke='" + accent.to-hex() + "' stroke-width='5' stroke-linecap='round'/>" + "<path d='M " + pt(q1) + " L " + pt(tip) + " L " + pt(q2) + " Z' fill='" + accent.to-hex() + "'/>"
  }

  let svg = (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 760 740'>",
    // órbita: el giro completo de las hojas
    "<circle cx='380' cy='380' r='330' fill='none' stroke='" + ink.to-hex() + "' stroke-opacity='0.35' stroke-width='2' stroke-dasharray='4 12' stroke-linecap='round'/>",
    angs.map(arc).join(""),
    angs.map(leaf).join(""),
    // perno (nudillo del gozne)
    "<circle cx='380' cy='380' r='112' fill='" + accent.to-hex() + "'/>",
    "<circle cx='380' cy='380' r='98' fill='none' stroke='" + light.to-hex() + "' stroke-opacity='0.55' stroke-width='2'/>",
    "</svg>",
  ).join("")

  // ── Rótulos de las hojas ──
  // Disco numerado, como la llamada de la cita.
  let disc(i) = box(baseline: 0.18em, circle(radius: 17pt * k, fill: accent, inset: 0pt,
    align(center + horizon, text(weight: 700, size: 22pt * k, fill: light, str(i)))))
  // Lleva fondo de papel para cortar la órbita punteada por detrás.
  let label(i, body, side) = {
    let t = text(size: 30pt * k, weight: 600, par(leading: 0.3em, body))
    let cells = if side == left { (disc(i), t) } else { (t, disc(i)) }
    block(fill: paper, inset: (x: 8pt * k, y: 6pt * k),
      grid(columns: 2, column-gutter: 12pt * k, align: (side + top, side + top), ..cells))
  }

  // Lado y posición automáticos de cada rótulo, relativos al perno, a
  // escala s. Devuelve (x, y, lado) de la esquina superior izquierda.
  let place-label(a, s, w, h) = {
    let (c, sn) = (calc.cos(a), calc.sin(a))
    let hw = (mw + 5) * s * 1pt // medio grosor de la hoja, con su trazo
    let (tx, ty) = (292 * s * c * 1pt, 292 * s * sn * 1pt) // punta de la hoja
    if calc.abs(c) < 0.5 {
      // casi vertical: al costado izquierdo de la punta
      let x = tx - hw - 7pt * s - w
      let y = if sn < 0 { ty - 32pt * s } else { ty + 32pt * s - h }
      (x, y, right)
    } else {
      // debajo (o encima) de la punta. Corrido hacia el perno solo si la
      // hoja va en diagonal (como en la 07); si es casi horizontal, hacia
      // el perno pisaría la flecha que llega por debajo, y si es empinada,
      // chocaría con el rótulo de la hoja vecina: ahí, hacia afuera.
      let shift = if calc.abs(sn) >= 0.4 and calc.abs(c) >= 0.7 { -0.2 } else { 0.2 }
      let x = tx + (if c > 0 { shift } else { -shift }) * w - w / 2
      let y = if sn >= 0 { ty + hw * calc.abs(c) + 35pt * s } else { ty - hw * calc.abs(c) - 35pt * s - h }
      (x, y, left)
    }
  }

  {
    set text(font: family, fill: ink, lang: "es", hyphenate: false)
    show <hinge-callout>: it => text(font: family, weight: 700, fill: accent, it)

    // Papel de plano: cuadrícula tenue + grano (pendiente: recurso).
    superbg.superbg((capas: (
      (tipo: "plano", color: paper),
      (tipo: "patron", patron: "grid", color: ink, paso: 40, grosor: 1, opacidad: 6%),
      (tipo: "ruido", color: ink, opacidad: 4%),
    )), size: formato)

    let make-quote(s) = text(font: quote-family, size: s, par(leading: 0.66em, quote-body))
    let footer = text(size: 30pt * k)[
      #if author != none { text(weight: 700, author) } #h(8pt * k) #if work != none { text(fill: quiet)[— #emph(work)] }
    ]

    context {
      // ── Cita, pie y zona del diagrama, según el formato ──
      let (zone, layout) = if landscape {
        (
          (x: W * 820 / 1600, y: H * 40 / 900, w: W * 760 / 1600, h: H * 740 / 900),
          {
            // Columna de la cita (centrada en vertical sobre el pie)
            place(top + left, dx: W * 96 / 1600, dy: H * 80 / 900, block(width: W * 660 / 1600, height: H * 640 / 900, align(horizon,
              _fit(make-quote, W * 660 / 1600, H * 620 / 900, text-body: quote-body, max: 46pt * k, min: 32pt * k, step: 1pt),
            )))
            // Pie: atribución y marca, bajo la columna
            place(top + left, dx: W * 96 / 1600, dy: H * 772 / 900, line(length: W * 660 / 1600, stroke: 1.2pt * k + ink))
            place(top + left, dx: W * 96 / 1600, dy: H * 796 / 900, footer)
            if brand != none { place(top + right, dx: -W * 96 / 1600, dy: H * 794 / 900, brand) }
          },
        )
      } else {
        let m = W * 0.08
        let footer-y = H - 128pt * k
        // cita arriba: hasta el 42 % del alto útil
        let room = footer-y - m - 40pt * k
        let c = _fit(make-quote, W - 2 * m, room * 0.42, text-body: quote-body, max: 46pt * k, min: 26pt * k, step: 1pt)
        let hc = measure(block(width: W - 2 * m, c)).height
        let y0 = m + hc + 40pt * k
        (
          (x: m, y: y0, w: W - 2 * m, h: footer-y - 30pt * k - y0),
          {
            place(top + left, dx: m, dy: m, block(width: W - 2 * m, c))
            // pie a todo el ancho
            place(top + left, dx: m, dy: footer-y, line(length: W - 2 * m, stroke: 1.2pt * k + ink))
            place(top + left, dx: m, dy: footer-y + 24pt * k, footer)
            if brand != none { place(top + right, dx: -m, dy: footer-y + 22pt * k, brand) }
          },
        )
      }
      layout

      // ── Escala y posición del diagrama ──
      let sizes = leaves.enumerate().map(((i, body)) => {
        let side = if positions == auto { place-label(angs.at(i), 1, 0pt, 0pt).at(2) } else { positions.at(i).side }
        measure(label(i + 1, body, side))
      })
      // caja que ocupan órbita + rótulos, relativa al perno, a escala s
      let extent(s) = {
        let r = 331pt * s
        let (x0, y0, x1, y1) = (-r, -r, r, r)
        for (i, a) in angs.enumerate() {
          let (w, h) = (sizes.at(i).width, sizes.at(i).height)
          let (x, y, _) = place-label(a, s, w, h)
          x0 = calc.min(x0, x)
          y0 = calc.min(y0, y)
          x1 = calc.max(x1, x + w)
          y1 = calc.max(y1, y + h)
        }
        (x0, y0, x1, y1)
      }
      let (X, Y, s) = {
        let s = k
        let (x0, y0, x1, y1) = extent(s)
        while s > 0.2 and (x1 - x0 > zone.w or y1 - y0 > zone.h) {
          s -= 0.01
          (x0, y0, x1, y1) = extent(s)
        }
        // perno donde la caja queda centrada en la zona
        let pcx = zone.x + (zone.w - (x1 - x0)) / 2 - x0
        let pcy = zone.y + (zone.h - (y1 - y0)) / 2 - y0
        (pcx - 380pt * s, pcy - 380pt * s, s)
      }

      place(top + left, dx: X, dy: Y, image(bytes(svg), format: "svg", width: 760pt * s, height: 740pt * s))

      // Concepto del perno.
      place(top + left, dx: X + 380pt * s - 100pt * s, dy: Y + 380pt * s - 40pt * s, block(width: 200pt * s, height: 80pt * s,
        align(center + horizon, text(size: 30pt * s, weight: 700, fill: light, par(leading: 0.3em, pivot)))))

      // Rótulos de las hojas, al extremo de cada una.
      for (i, body) in leaves.enumerate() {
        if positions != auto {
          let r = positions.at(i)
          place(top + left, dx: r.x, dy: r.y, block(width: 330pt * k, align(r.side, label(i + 1, body, r.side))))
        } else {
          let (w, h) = (sizes.at(i).width, sizes.at(i).height)
          let (x, y, side) = place-label(angs.at(i), s, w, h)
          place(top + left, dx: X + 380pt * s + x, dy: Y + 380pt * s + y, label(i + 1, body, side))
        }
      }
    }
  }
}

#let make(
  body,
  artboard: (1600, 900),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  angles: auto,
  positions: auto,
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  theme: theme,
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: _default-theme,
  default-fonts: none,
  extra-roles: ("light",),
  known: ("quote", "list", "pivot", "author", "work", "brand"),
  fn: "hinge",
  elements: elements,
  rules: ctx => _rules(ctx, angles, positions),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia. El formato por
// defecto de v1 era 1600×900.
#let preset = (name: "hinge", make: make, variants: (), artboard: "twitter")
#let hinge = frame.with(preset: preset)
