// ─────────────────────────────────────────────────────────────
//  mosaic.typ — el preset `mosaic` (en v1, `carteles.mosaico`)
//
//  mosaic = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): author, work, brand, tag, main,
//  conclusion; cada uno también como argumento (`author: […]`).
//  Propiedades: main.size (el tamaño máximo del párrafo), main.min-size (el
//  mínimo legible) y main.font (la tipografía de ese texto).
//  Opciones del preset: variant, thickness, guides, area, anchor, art-scale.
//
//  Portada gráfica de líneas concéntricas y formas macizas: diez arcos
//  paralelos (una «C» abierta o una «U» inclinada a 45°) con círculos y un
//  rombo de contrapunto, y dos líneas de texto con mucho espaciado, una
//  vertical al margen (author) y otra al pie (work). Tres variantes de la misma
//  idea (variants/: "c", "u" y "u-inverted"), con los colores del tema rotando
//  de papel. Por defecto no es un cartel de cita: sin `tag`, `main` ni
//  `conclusion` lleva solo `author` y `work` como rótulos; con ellos suma un
//  título, un párrafo y una palabra apilada, como `tiles`.
//
//  Las medidas salen de una lámina de referencia de 802,5 × 1117,5 y se escalan
//  con el lado menor; en otro formato la composición queda centrada y el papel
//  llena el resto. El texto no va en cajas fijas: el arte se describe como
//  obstáculos (resources/motifs/_huecos.typ) y el texto toma la mayor caja libre
//  según un plan por variante (resources/motifs/_texto.typ). Si el párrafo no
//  cabe ni al mínimo, error: nunca pisa el arte ni baja del mínimo legible.
//
//  `area` acota la composición a una parte de la página, `anchor` la apoya y
//  `art-scale` achica la lámina dentro del área (auto: lo justo para que el texto
//  quepa).
//
//  Escala: la de la lámina (la del lado menor), no `u`; los números de la API
//  (main.size, main.min-size, thickness) son u vía `ctx.len`. Así el párrafo de
//  v1 (`cuerpo`, en px de la lámina) se expresa ahora en px de la imagen.
//
//  Fuentes: los rótulos, Jost (v1; token `jost`, o `fonts:` si se da); el texto,
//  Outfit (v1; token `outfit`, o `main(font: …)`). Ninguna pareja de typography
//  trae las dos. Roles del tema: los cinco más uno propio, `deep` (el azul
//  hondo). `guide` no se usa (lo deriva modules/color).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/resources/motifs/_arcos.typ": arcos, contorno-arcos
#import "/src/resources/motifs/_texto.typ": resolver-bloque
#import "/src/resources/motifs/_huecos.typ": ob-poligono, ob-circulo, ob-rombo, ob-caja
#import "/src/resources/motifs/_lamina.typ": area-trabajo, encajar
#import "variants/c.typ" as _c
#import "variants/u.typ" as _u
#import "variants/u-inverted.typ" as _u-inverted

#let _variants = (c: _c.variant, u: _u.variant, "u-inverted": _u-inverted.variant)

// el mismo tema que mosaico en v1 (papel verdoso, tinta negra, naranja y azul hondo)
#let _default-theme = (
  paper: rgb("#b3dcd4"),
  ink: rgb("#000000"),
  quiet: rgb("#a1a1a1"),
  accent: rgb("#ff832a"),
  deep: rgb("#002b38"),
)

// Lámina de referencia: la zona coloreada, sin el marco blanco (px).
#let _ref = (802.5, 1117.5)

// ── el texto: dónde cabe, a partir del arte ─────────────────
// Distancias en unidades de la lámina.
#let _air = 28 // del texto al arte y a los rótulos (≈ el paso de los arcos de la «C»)
#let _margin = 40 // del texto al borde de la página (el rótulo vertical queda a 40 del suyo)
#let _gap = 28 // entre la pila y la columna de título y párrafo
#let _top = _ref.at(1) - 1064 // primera línea: tan lejos del borde de arriba como el pie del de abajo

#let _text(
  v, X, Y, L, page-box, work-area,
  color: black, labels: "Jost", thickness: 7.5,
  author: none, work: none, brand: none,
  tag: none, main: none, conclusion: none,
  size: auto, min-size: auto, text-font: "Outfit", guides: false, who: "mosaic",
  stack-min: 0.45, probe: false,
) = {
  let (ox, oy, width, height) = page-box
  let (ax, ay, aw, ah) = work-area
  let u = L(1)
  let a = v.arcs
  // ── el arte, como obstáculos (de los mismos números con que se dibuja) ──
  let lines = contorno-arcos(a.center, a.radius, lineas: 10, paso: a.step, grosor: thickness,
    desde: a.at("from", default: 0deg), hasta: a.at("to", default: 360deg),
    eje: a.at("axis", default: none), cola: a.tail)
  let obs = lines.map(p => ob-poligono(p, aire: _air))
  obs += v.circles.map(c => ob-circulo(c.center, c.d / 2, aire: _air))
  obs += v.rhombi.map(r => ob-rombo(r.center, r.diag, aire: _air))
  // los rótulos, medidos con su tipografía
  let label(t) = measure(text(font: labels, size: L(19), tracking: 0.65em, weight: 400, upper(t)))
  if author != none {
    let m = label(author)
    obs.push(ob-caja((v.title.x - 9.5, v.title.y, v.title.x + 9.5, v.title.y + m.width / u), aire: _air))
  }
  let foot-top = 1064 - 19
  if work != none {
    let m = label(work)
    obs.push(ob-caja((v.foot-x - m.width / u, foot-top, v.foot-x, foot-top + m.height / u + 5), aire: _air))
  }
  if brand != none {
    let m = measure(brand)
    obs.push(ob-caja((45, _ref.at(1) - 40 - m.height / u, 45 + m.width / u, _ref.at(1) - 40), aire: _air))
  }
  // el área de trabajo (por defecto, la página entera) en unidades de la
  // lámina, menos el margen
  let lim = ((ax - ox) / u + _margin, (ay - oy) / u + _margin, (ax + aw - ox) / u - _margin, (ay + ah - oy) / u - _margin)

  // ── los planes, por orden de preferencia ──
  // el texto arranca donde arranca el motivo de líneas, y la pila se alinea
  // con el borde derecho del pie
  let left-edge = calc.min(..lines.map(p => calc.min(..p.map(q => q.at(0)))))
  let foot = v.foot-x
  let plans = ()
  // apaisado: si al lado de la lámina queda una banda ancha, el texto va
  // ahí: primero del lado contrario al rótulo vertical, luego del otro
  let rot-x0 = if author != none { v.title.x - 9.5 } else { _ref.at(0) }
  let rot-x1 = if author != none { v.title.x + 9.5 } else { 0 }
  let art-left = calc.min(left-edge, rot-x0) - 2 * _air // donde acaba, por la izquierda, el arte
  let art-right = calc.max(foot, rot-x1) + 2 * _air // y por la derecha
  // a la derecha: la columna arranca pasado el arte; la pila, al borde de la página
  let side-right = (pila: (x: lim.at(2), y: _top), columna: (x: art-right, y: _top, hasta: lim.at(2)))
  // a la izquierda: la columna al borde de la página; la pila, junto al arte
  let side-left = (pila: (x: art-left, y: _top), columna: (x: lim.at(0), y: _top, hasta: art-left))
  let sides = if v.title.x < _ref.at(0) / 2 { (side-right, side-left) } else { (side-left, side-right) }
  for l in sides {
    if calc.abs(l.columna.hasta - l.columna.x) >= 300 { plans.push(l) }
  }
  // la banda de arriba, a la altura de la lámina; si no cabe, más arriba
  // (en formatos más altos que la lámina hay sitio sobre ella)
  let ys = (_top,)
  let y = _top - 10
  while y > lim.at(1) { ys.push(y); y -= 10 }
  if lim.at(1) < _top { ys.push(lim.at(1)) }
  for y in ys { plans.push((pila: (x: foot, y: y), columna: (x: left-edge, y: y, hasta: foot))) }
  if v.plans == "diagonal" {
    // pila arriba a la derecha y el bloque abajo a la derecha, sobre el pie:
    // los dos al borde del pie, a uno y otro lado del brazo largo
    let low = if work != none { foot-top - _air - 1 } else { 1064 }
    plans.push((pila: (x: foot, y: _top),
      columna: (x: foot, y: low, alinear: "derecha", ancla: "abajo", hasta: lim.at(0))))
  }

  let k = _ref.at(0) / 300
  resolver-bloque(L, X, Y, color, color, plans, obs, lim, k: k, pila-min: stack-min, probar: probe,
    etiqueta: tag, frase: main, remate: conclusion,
    // size y min-size llegan en pt (ya pasados por `ctx.len`); la capa los pide en unidades de la lámina
    cuerpo: if size == auto { 7.4 * k } else { size / u },
    // a 1080 px de ancho, 22 px; en otro ancho, en proporción
    minimo: if min-size == auto { 22pt * (width / 1080pt) / u } else { min-size / u },
    junta: _gap, fuente: text-font, guias: guides, quien: who)
}

// escalas que prueba `art-scale: auto`, de mayor a menor
#let _art-scales = (1, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6)

#let _rules(ctx, variant, thickness, guides, area, anchor, art-scale) = {
  if variant == auto { variant = "c" }
  if variant not in _variants {
    panic("mosaic: variante desconocida " + repr(variant) + " (hay: " + _variants.keys().join(", ") + ")")
  }
  let v = _variants.at(variant)
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let artboard = (width / 1pt, height / 1pt)
  let art-scale = if type(art-scale) == ratio { art-scale / 100% } else { art-scale }
  if art-scale != auto and (type(art-scale) not in (int, float) or art-scale <= 0 or art-scale > 1) {
    panic("mosaic: `art-scale` es auto o una fracción entre 0 y 1, no " + repr(art-scale))
  }
  // el rectángulo de trabajo (por defecto, la página entera)
  let work-area = area-trabajo(artboard, area: area, ancla: anchor, quien: "mosaic")

  let p = ctx.parts
  let part(k) = p.at(k, default: none)
  let body-of(k) = { let x = part(k); if x == none { none } else { x.body } }
  let (author, work, tag, conclusion) = ("author", "work", "tag", "conclusion").map(body-of)
  let mp = part("main")
  // el texto principal: `main` más el contenido suelto
  let main = if mp == none { if ctx.has-loose { ctx.loose } else { none } } else if ctx.has-loose { mp.body + parbreak() + ctx.loose } else { mp.body }
  let props = if mp == none { (:) } else { mp.props }
  let size = if "size" in props { (ctx.len)(props.size) } else { auto }
  let min-size = if "min-size" in props { (ctx.len)(props.min-size) } else { auto }
  let text-font = if "font" in props { (ctx.font)(props.font) } else { (ctx.font)("outfit") }
  let labels = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("jost") }
  let brand = ctx.brand
  let has-text = tag != none or main != none or conclusion != none
  let line-weight(L) = if thickness == auto { v.thickness } else { (ctx.len)(thickness) / L(1) }

  // La lámina de referencia encajada en el área (centrada, o según `anchor`),
  // a una fracción `q` del tamaño con que la llena: su esquina y sus medidas.
  let sheet(q) = {
    let (ox, oy, s) = encajar(work-area, _ref, ancla: anchor, escala: q)
    (ox: ox, oy: oy, X: u => ox + u * s * 1pt, Y: u => oy + u * s * 1pt, L: u => u * s * 1pt)
  }
  let layer(g, probe, stack-min: 0.45) = _text(v, g.X, g.Y, g.L, (g.ox, g.oy, width, height), work-area,
    color: tm.at(v.text), labels: labels, thickness: line-weight(g.L),
    author: author, work: work, brand: brand, tag: tag, main: main, conclusion: conclusion,
    size: size, min-size: min-size, text-font: text-font, guides: guides,
    who: "mosaic(variant: " + repr(variant) + ")", stack-min: stack-min, probe: probe)

  let draw(g, stack-min: 0.45) = {
    let (X, Y, L) = (g.X, g.Y, g.L)
    // ── las líneas ──
    let a = v.arcs
    arcos(
      (X(a.center.at(0)), Y(a.center.at(1))),
      L(a.radius),
      lineas: 10,
      paso: L(a.step),
      grosor: L(line-weight(L)),
      desde: a.at("from", default: 0deg),
      hasta: a.at("to", default: 360deg),
      eje: a.at("axis", default: none),
      cola: (L(a.tail.at(0)), L(a.tail.at(1))),
      color: tm.at(a.color),
    )

    // ── círculos macizos (encima de las líneas, como en la lámina) ──
    for c in v.circles {
      let d = L(c.d)
      place(top + left, dx: X(c.center.at(0)) - d / 2, dy: Y(c.center.at(1)) - d / 2,
        circle(radius: d / 2, fill: tm.at(c.color)))
    }
    // ── rombos: un cuadrado girado 45°, de diagonal `diag` ──
    for r in v.rhombi {
      let side = L(r.diag) / calc.sqrt(2)
      place(top + left, dx: X(r.center.at(0)) - side / 2, dy: Y(r.center.at(1)) - side / 2,
        rotate(45deg, origin: center, rect(width: side, height: side, fill: tm.at(r.color))))
    }

    // ── rótulos ──
    set text(font: labels, fill: tm.at(v.text), size: L(19), tracking: 0.65em, weight: 400)
    if author != none {
      place(top + left, dx: X(v.title.x) - L(19) / 2, dy: Y(v.title.y),
        rotate(90deg, reflow: true, upper(author)))
    }
    if work != none {
      place(top + right, dx: -(width - X(v.foot-x)), dy: Y(1064) - L(19),
        upper(work))
    }
    // ── título, párrafo y pila (como en tiles), si se pidieron ──
    if has-text { context layer(g, false, stack-min: stack-min) }
    if brand != none {
      place(bottom + left, dx: X(45), dy: -(height - Y(_ref.at(1)) + L(40)), brand)
    }
    if guides {
      // el área de trabajo, en verde (los obstáculos y las cajas del texto
      // los dibuja la capa de texto)
      let (ax, ay, aw, ah) = work-area
      place(top + left, dx: ax, dy: ay, rect(width: aw, height: ah, stroke: (paint: green, thickness: 1pt, dash: "dashed")))
    }
  }

  // El lienzo pinta `paper`; el papel de la variante puede ser otro rol, así
  // que se cubre la página con él.
  place(top + left, rect(width: width, height: height, fill: tm.at(v.paper), stroke: none))
  if art-scale == auto and has-text {
    // el arte cede: la mayor escala (de 1 a 0,6 del área) con la que el
    // texto cabe, primero sin que la pila baje del 80 % (el arte se achica
    // antes que ella) y, si así no cabe, dejándola ceder como siempre; si
    // ni así, se dibuja a 0,6 y la capa de texto da el error
    context {
      let done = none
      for pm in (0.8, 0.45) {
        let q = _art-scales.find(q => layer(sheet(q), true, stack-min: pm))
        if q != none { done = (q: q, pm: pm); break }
      }
      if done == none { done = (q: _art-scales.last(), pm: 0.45) }
      draw(sheet(done.q), stack-min: done.pm)
    }
  } else {
    draw(sheet(if art-scale == auto { 1 } else { art-scale }))
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  variant: "c",
  thickness: auto,
  guides: false,
  area: 1,
  anchor: center + horizon,
  art-scale: 1,
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
  extra-roles: ("deep",),
  known: ("author", "work", "brand", "tag", "main", "conclusion"),
  fn: "mosaic",
  elements: elements,
  rules: ctx => _rules(ctx, variant, thickness, guides, area, anchor, art-scale),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "mosaic", make: make, variants: _variants.keys())
#let mosaic = frame.with(preset: preset)
