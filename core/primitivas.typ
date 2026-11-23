// ─────────────────────────────────────────────────────────────
//  core/primitivas.typ — primitivas headless, sin imports
//
//  Esta es la capa de abajo. Mide, coloca, esquiva y ajusta;
//  NO decide colores, tipografías ni composición. Un preset o un
//  estilo propio (el "usuario") importa este archivo y compone.
//
//  Código adaptado de:
//    src/carteles/_base.typ    -> medida, escala, area-trabajo,
//                                 encajar, cuerpo-al-ancho, ajustar-alto
//    src/carteles/_huecos.typ  -> obstáculos y caja libre
//    WallTypst templates/wall.typ + docs/layout.md
//                              -> rejilla, breakpoints, zona segura,
//                                 celda, bleed y depuración
//
//  Se copia en vez de importarse a propósito: quien trae este
//  archivo a su proyecto es dueño del código (modelo shadcn).
// ─────────────────────────────────────────────────────────────

// ══ 1. Geometría y ajuste (de _base.typ) ══════════════════════

// Tamaño del lienzo en pt, desde px.
#let medida(formato) = (formato.at(0) * 1pt, formato.at(1) * 1pt)

// Factor para llevar medidas pensadas sobre `base` al lienzo.
// Manda el lado menor: nada se sale de la página.
#let escala(formato, base: (1080, 1080)) = calc.min(formato.at(0) / base.at(0), formato.at(1) / base.at(1))

#let _fraccion(f, quien) = {
  let v = if type(f) == ratio { f / 100% } else { f }
  if type(v) not in (int, float) or v <= 0 or v > 1 {
    panic(quien + ": se esperaba una fracción > 0 y <= 1, no " + repr(f))
  }
  v
}

// (fx, fy): 0 = izquierda/arriba, 0,5 = centro, 1 = derecha/abajo.
#let _ancla(ancla) = {
  let fx = (left: 0, center: 0.5, right: 1)
  let fy = (top: 0, horizon: 0.5, bottom: 1)
  let x = if ancla.x == none { 0.5 } else { fx.at(repr(ancla.x), default: 0.5) }
  let y = if ancla.y == none { 0.5 } else { fy.at(repr(ancla.y), default: 0.5) }
  (x, y)
}

// Rectángulo de trabajo (x, y, ancho, alto) en pt. `area` acota,
// `ancla` apoya el rectángulo dentro de la página.
#let area-trabajo(formato, area: 1, ancla: center + horizon, quien: "area") = {
  if type(ancla) != alignment {
    panic(quien + ": `ancla` es una alineación, no " + repr(ancla))
  }
  let (ancho, alto) = medida(formato)
  let (fw, fh) = if type(area) == array {
    if area.len() != 2 { panic(quien + ": `area` como par es (ancho, alto)") }
    area.map(f => _fraccion(f, quien))
  } else {
    let f = _fraccion(area, quien)
    (f, f)
  }
  let (w, h) = (ancho * fw, alto * fh)
  let (ax, ay) = _ancla(ancla)
  ((ancho - w) * ax, (alto - h) * ay, w, h)
}

// Una lámina de `base` px encajada en un rect en pt.
// Devuelve (ox, oy, s): esquina de la lámina y su escala.
#let encajar(rect, base, ancla: center + horizon, escala: 1) = {
  let (x, y, w, h) = rect
  let s = calc.min(w / 1pt / base.at(0), h / 1pt / base.at(1)) * escala
  let (ax, ay) = _ancla(ancla)
  (x + (w - base.at(0) * s * 1pt) * ax, y + (h - base.at(1) * s * 1pt) * ay, s)
}

// Tamaño con el que `hacer(tamaño)` mide exactamente `ancho`.
// Usar dentro de `context`.
#let cuerpo-al-ancho(hacer, ancho) = 100pt * (ancho / measure(hacer(100pt)).width)

// Mayor tamaño <= `desde` con el que `hacer(tamaño)` cabe en `alto`.
// Se detiene en `minimo`. Usar dentro de `context`.
#let ajustar-alto(hacer, desde, alto, minimo: 24pt, paso: 2pt) = {
  let s = desde
  while s > minimo and measure(hacer(s)).height > alto { s -= paso }
  s
}

// ══ 2. Rejilla (de WallTypst) ══════════════════════════════════

// Breakpoints por ancho, de mayor a menor.
#let _anchos = (("xxl", 3840), ("xl", 2560), ("lg", 1920), ("md", 1280), ("sm", 0))
#let _claves-bp = ("vertical", "apaisado", "ultra") + _anchos.map(a => a.first())

// Zonas seguras en unidades u (1/1000 del lado corto).
#let _seguro-nombrado = (
  ninguna: (:),
  escritorio: (left: 150, top: 56, bottom: 80),
  gnome: (top: 48),
  windows: (left: 150, bottom: 76),
  macos: (left: 0, top: 40, bottom: 90),
)

#let _anclas-celda = (
  "top-left": top + left, "top": top + center, "top-right": top + right,
  "left": horizon + left, "center": horizon + center, "right": horizon + right,
  "bottom-left": bottom + left, "bottom": bottom + center, "bottom-right": bottom + right,
)

// Resuelve un valor que puede venir por aspecto o por ancho.
// Prioridad: aspecto exacto -> ancho -> ultra cae a apaisado -> vertical.
#let _resolver(v, bp) = {
  if type(v) == dictionary and v.keys().any(k => k in _claves-bp) {
    let ancho = _anchos.find(((n, x)) => bp.ancho-px >= x and n in v)
    let elegido = if bp.aspecto in v { v.at(bp.aspecto) }
      else if ancho != none { v.at(ancho.first()) }
      else if bp.aspecto == "ultra" and "apaisado" in v { v.at("apaisado") }
      else { v.at("vertical", default: v.at("apaisado", default: v.at("sm", default: none))) }
    _resolver(elegido, bp)
  } else if type(v) == dictionary {
    v.pairs().map(((k, x)) => (k, _resolver(x, bp))).to-dict()
  } else if type(v) == array {
    v.map(x => _resolver(x, bp))
  } else { v }
}

// Construye la rejilla. Devuelve un dict con el estado y las
// operaciones `contenedor`, `celda`, `en-celda` y `depuracion`.
#let rejilla(
  formato,
  columns: 12, rows: 12,
  gutter: 24, row-gutter: auto,
  margin: 80, container: "fluid", max-width: 1,
  safe: "ninguna", debug: false,
) = {
  let (ancho, alto) = medida(formato)
  let u = calc.min(ancho, alto) / 1000
  let bp = (
    aspecto: if ancho < alto { "vertical" } else if ancho / alto > 2 { "ultra" } else { "apaisado" },
    ancho-px: formato.at(0),
  )

  let nc = _resolver(columns, bp)
  let nr = _resolver(rows, bp)
  let gut = _resolver(gutter, bp)
  let rg0 = _resolver(row-gutter, bp)
  let rgut = if rg0 == auto { gut } else { rg0 }
  let mg = _resolver(margin, bp)
  let (mx0, my0) = if type(mg) == array { (mg.at(0), mg.at(1)) } else { (mg, mg) }
  let cont = _resolver(container, bp)
  let mw = _resolver(max-width, bp)
  let dbg = _resolver(debug, bp)
  let sf = _resolver(safe, bp)
  let sf = if type(sf) == str { _seguro-nombrado.at(sf, default: (:)) } else { sf }

  let lay = (
    ancho: ancho, alto: alto, u: u,
    columnas: nc, filas: nr,
    gutter: gut * u, row-gutter: rgut * u,
    mx: mx0 * u, my: my0 * u,
    max-width: if mw <= 1 { mw * ancho } else { mw * u },
    container: cont,
    safe: ("left", "top", "right", "bottom").map(k => (k, sf.at(k, default: 0) * u)).to-dict(),
    debug: dbg,
  )

  let contenedor(seguro: true) = {
    let s = if seguro { lay.safe } else { (left: 0pt, top: 0pt, right: 0pt, bottom: 0pt) }
    let (ax, ay) = (s.left, s.top)
    let (aw, ah) = (ancho - s.left - s.right, alto - s.top - s.bottom)
    let w = aw - 2 * lay.mx
    let w = if lay.container == "fixed" { calc.min(lay.max-width, w) } else { w }
    (x: ax + (aw - w) / 2, y: ay + lay.my, w: w, h: ah - 2 * lay.my)
  }

  let celda(g) = {
    let k = contenedor(seguro: g.at("safe", default: true))
    let (n, nr) = (lay.columnas, lay.filas)
    let cw = (k.w - (n - 1) * lay.gutter) / n
    let rh = (k.h - (nr - 1) * lay.row-gutter) / nr
    let col = g.at("col", default: 1) + g.at("offset", default: 0)
    let span = g.at("span", default: n - col + 1)
    let span = if span == "full" { n - col + 1 } else { span }
    let row = g.at("row", default: 1) + g.at("row-offset", default: 0)
    let rows = g.at("rows", default: nr - row + 1)
    let rows = if rows == "full" { nr - row + 1 } else { rows }
    let x = k.x + (col - 1) * (cw + lay.gutter)
    let y = k.y + (row - 1) * (rh + lay.row-gutter)
    let w = span * cw + (span - 1) * lay.gutter
    let h = rows * rh + (rows - 1) * lay.row-gutter
    let b = g.at("bleed", default: false)
    let lados = if b == true { ("left", "right", "top", "bottom") }
      else if b == "x" { ("left", "right") }
      else if b == "y" { ("top", "bottom") }
      else if b == false { () } else { (b,) }
    let (x, w) = if "left" in lados and col == 1 { (0pt, w + x) } else { (x, w) }
    let w = if "right" in lados and col + span - 1 == n { ancho - x } else { w }
    let (y, h) = if "top" in lados and row == 1 { (0pt, h + y) } else { (y, h) }
    let h = if "bottom" in lados and row + rows - 1 == nr { alto - y } else { h }
    (x: x, y: y, w: w, h: h)
  }

  let en-celda(g, cuerpo) = {
    let c = celda(g)
    let i = g.at("inset", default: 0)
    let i = if type(i) == dictionary {
      i.pairs().map(((k, v)) => (k, v * u)).to-dict()
    } else { i * u }
    place(top + left, dx: c.x, dy: c.y, box(width: c.w, height: c.h, inset: i,
      align(_anclas-celda.at(g.at("align", default: "top-left")), cuerpo)))
  }

  let depuracion() = {
    if not lay.debug { none } else {
      let piezas = ()
      let rojo = rgb("#ff2d55")
      let cian = rgb("#00b7ff")
      let verde = rgb("#30d158")
      let s = lay.safe
      let franja(x, y, w, h, color) = if w > 0pt and h > 0pt {
        place(top + left, dx: x, dy: y, rect(width: w, height: h, fill: color.transparentize(82%), stroke: none))
      } else { [] }
      piezas.push(franja(0pt, 0pt, s.left, alto, rojo))
      piezas.push(franja(ancho - s.right, 0pt, s.right, alto, rojo))
      piezas.push(franja(s.left, 0pt, ancho - s.left - s.right, s.top, rojo))
      piezas.push(franja(s.left, alto - s.bottom, ancho - s.left - s.right, s.bottom, rojo))
      let k = contenedor()
      let cw = (k.w - (lay.columnas - 1) * lay.gutter) / lay.columnas
      let rh = (k.h - (lay.filas - 1) * lay.row-gutter) / lay.filas
      for i in range(lay.columnas) {
        piezas.push(place(top + left, dx: k.x + i * (cw + lay.gutter), dy: k.y,
          rect(width: cw, height: k.h, fill: cian.transparentize(88%), stroke: none)))
      }
      for j in range(lay.filas) {
        piezas.push(place(top + left, dx: k.x, dy: k.y + j * (rh + lay.row-gutter),
          rect(width: k.w, height: rh, fill: verde.transparentize(92%), stroke: none)))
      }
      piezas.fold([], (a, b) => a + b)
    }
  }

  lay + (
    contenedor: contenedor,
    celda: celda,
    en-celda: en-celda,
    depuracion: depuracion,
  )
}

// ══ 3. Obstáculos y caja libre (de _huecos.typ) ════════════════


#let _xs(pts) = pts.map(p => p.at(0))
#let _ys(pts) = pts.map(p => p.at(1))

#let ob-poligono(pts, aire: 0) = (
  tipo: "poligono", pts: pts, aire: aire,
  bb: (calc.min(.._xs(pts)), calc.min(.._ys(pts)), calc.max(.._xs(pts)), calc.max(.._ys(pts))),
)
#let ob-circulo(c, r, aire: 0) = (
  tipo: "circulo", c: c, r: r, aire: aire,
  bb: (c.at(0) - r, c.at(1) - r, c.at(0) + r, c.at(1) + r),
)
#let ob-caja(caja, aire: 0) = (tipo: "caja", caja: caja, aire: aire, bb: caja)
#let ob-rombo(c, diag, aire: 0) = {
  let h = diag / 2
  ob-poligono(((c.at(0) - h, c.at(1)), (c.at(0), c.at(1) - h),
    (c.at(0) + h, c.at(1)), (c.at(0), c.at(1) + h)), aire: aire)
}

#let _solapa(a0, a1, b0, b1) = a0 < b1 and b0 < a1

// ¿La caja `r` se acerca a `ob` menos de su aire?
#let choca(r, ob) = {
  let m = ob.aire
  let (x0, y0, x1, y1) = (r.at(0) - m, r.at(1) - m, r.at(2) + m, r.at(3) + m)
  let bb = ob.bb
  if not (_solapa(x0, x1, bb.at(0), bb.at(2)) and _solapa(y0, y1, bb.at(1), bb.at(3))) { return false }
  if ob.tipo == "caja" { return true }
  if ob.tipo == "circulo" {
    let (cx, cy) = ob.c
    let dx = calc.max(r.at(0) - cx, 0pt, cx - r.at(2)) / 1pt
    let dy = calc.max(r.at(1) - cy, 0pt, cy - r.at(3)) / 1pt
    let rr = (ob.r + m) / 1pt
    return dx * dx + dy * dy < rr * rr
  }
  let pts = ob.pts
  let esq = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
  let n = pts.len()
  for i in range(n) {
    let (p, q) = (pts.at(i), pts.at(calc.rem(i + 1, n)))
    let (nx, ny) = (p.at(1) - q.at(1), q.at(0) - p.at(0))
    let a = pts.map(v => v.at(0) * nx + v.at(1) * ny)
    let b = esq.map(v => v.at(0) * nx + v.at(1) * ny)
    if not _solapa(calc.min(..a), calc.max(..a), calc.min(..b), calc.max(..b)) { return false }
  }
  true
}

// ¿La caja está dentro de `limites` y lejos de todos los obstáculos?
#let libre(r, obstaculos, limites) = (
  r.at(0) >= limites.at(0) and r.at(1) >= limites.at(1)
    and r.at(2) <= limites.at(2) and r.at(3) <= limites.at(3)
    and obstaculos.all(o => not choca(r, o))
)

// Un obstáculo derivado de una celda de la rejilla.
#let ob-celda(g, rej, aire: 0) = {
  let c = (rej.celda)(g)
  ob-caja((c.x, c.y, c.x + c.w, c.y + c.h), aire: aire)
}

// La mayor caja libre dentro de `limites`, descontando obstáculos.
// Corta el espacio por los bordes de los obstáculos (más su aire),
// prueba cada rectángulo y se queda con el de mayor área.
// Devuelve `none` si no hay sitio.
#let mayor-caja-libre(obstaculos, limites) = {
  let (x0, y0, x1, y1) = limites
  let xs = (x0, x1)
  let ys = (y0, y1)
  for o in obstaculos {
    let bb = o.bb
    let m = o.aire
    for v in (bb.at(0) - m, bb.at(2) + m) { xs.push(calc.min(calc.max(v, x0), x1)) }
    for v in (bb.at(1) - m, bb.at(3) + m) { ys.push(calc.min(calc.max(v, y0), y1)) }
  }
  let xs = xs.dedup().sorted()
  let ys = ys.dedup().sorted()
  let mejor = none
  let area = -1.0
  for i in range(xs.len() - 1) {
    for j in range(ys.len() - 1) {
      let r = (xs.at(i), ys.at(j), xs.at(i + 1), ys.at(j + 1))
      if libre(r, obstaculos, limites) {
        let a = ((r.at(2) - r.at(0)) / 1pt) * ((r.at(3) - r.at(1)) / 1pt)
        if a > area { area = a; mejor = r }
      }
    }
  }
  mejor
}

// Depuración de obstáculos. X, Y y L convierten coordenadas de la
// lámina al lienzo (identidad si ya trabajas en pt).
#let dibujar-obstaculos(obstaculos, X, Y, L, color: red) = {
  for o in obstaculos {
    if o.tipo == "poligono" {
      place(top + left, polygon(stroke: 0.6pt + color, ..o.pts.map(p => (X(p.at(0)), Y(p.at(1))))))
    } else if o.tipo == "circulo" {
      place(top + left, dx: X(o.c.at(0) - o.r), dy: Y(o.c.at(1) - o.r),
        circle(radius: L(o.r), stroke: 0.6pt + color))
    } else {
      let c = o.caja
      place(top + left, dx: X(c.at(0)), dy: Y(c.at(1)),
        rect(width: L(c.at(2) - c.at(0)), height: L(c.at(3) - c.at(1)), stroke: 0.6pt + color))
    }
  }
}

// ══ 4. Utilidades de campaña (de trabajos/campana/_comun.typ) ═══
// 20 láminas, 20 composiciones distintas. Esto NO es una plantilla:
// no impone composición. Solo lo que se copiaría 20 veces y los dos
// hilos comunes: formato y marca a escala proporcional.

#let formatos = (
  retrato: (1080, 1350),
  cuadrado: (1080, 1080),
  instagram: (1080, 1080),
  story: (1080, 1920),
  twitter: (1600, 900),
  linkedin: (1200, 1200),
)

// Contenido -> texto plano (para medir palabra por palabra).
#let plano(c) = {
  if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(plano).join() }
  else if c.has("body") { plano(c.body) }
  else if c == [ ] { " " }
  else { "" }
}

// El mayor tamaño con el que `hacer(tamaño)` cabe en `ancho` x `alto`.
// Exige además que la palabra más larga quepa en `ancho`: Typst deja
// que una palabra sin cortes se salga sin crecer en alto, y medir solo
// el alto no basta. Usar dentro de `context`.
#let ajustar(hacer, ancho, alto, texto: none, max: 140pt, min: 24pt, paso: 2pt) = {
  let palabras = if texto == none { () } else {
    plano(texto).split(regex("\\s+")).filter(p => p != "")
  }
  let cabe(s) = {
    let larga = if palabras.len() == 0 { 0pt } else {
      calc.max(..palabras.map(p => measure(text(size: s, p)).width))
    }
    larga <= ancho and measure(block(width: ancho, hacer(s))).height <= alto
  }
  let s = max
  while s > min and not cabe(s) { s -= paso }
  hacer(s)
}

// Marca proporcional: el alto es una fracción de √(ancho × alto), así
// ocupa la misma parte del lienzo en cuadrado, retrato, story o twitter.
// Devuelve `(color, lienzo) -> contenido`, para pasarla como `marca:`.
#let marca(texto, proporcion: 1 / 30) = (color, lienzo) => {
  let (w, h) = lienzo
  let alto = calc.sqrt(w * h) * proporcion * 1pt
  text(fill: color, size: alto, weight: 700, tracking: 0.08em, texto)
}

// Atribución de la serie: autor y obra, siempre igual.
#let atribucion(autor, obra, color, tamaño: 11pt) = {
  text(fill: color, size: tamaño, [#autor · _[#obra]_])
}

// ══ 5. Piezas de los presets (de carteles.typ / _temas.typ / pliego.typ) ══
// Lo que un preset como `suizo` necesita y antes vivía en módulos aparte.

// Retícula de una dimensión: posiciones de columna, ancho de columna
// y ancho útil. La retícula visible de `suizo` se dibuja con esto.
#let reticula(ancho, columnas: 6, margen: 64pt, medianil: 24pt) = {
  let util = ancho - 2 * margen
  let col = (util - (columnas - 1) * medianil) / columnas
  (
    columnas: columnas,
    margen: margen,
    medianil: medianil,
    util: util,
    col: col,
    x: range(columnas).map(i => margen + i * (col + medianil)),
    span: (0pt,) + range(1, columnas + 1).map(n => n * col + (n - 1) * medianil),
  )
}

// Registro de temas (el de la lámina 01 y el de Bauhaus, suficiente
// para las recetas) y derivación de roles.
#let temas-lamina = (
  suizo: (
    fondo: rgb("#f3f0e9"),
    tinta: rgb("#141414"),
    suave: rgb("#5c5850"),
    acento: rgb("#c8102e"),
    linea: rgb("#d9d3c7"),
  ),
  bauhaus: (
    fondo: rgb("#ece3cf"),
    tinta: rgb("#141414"),
    suave: rgb("#5b564c"),
    acento: rgb("#d3261b"),
    amarillo: rgb("#f2b705"),
    azul: rgb("#1b4f9c"),
  ),
  lamina: (
    fondo: rgb("#f7f7f3"),
    tinta: rgb("#14213d"),
    suave: rgb("#454f63"),
    acento: rgb("#0f766e"),
  ),
)
#let _mezcla(a, b, p) = color.mix((a, 100% - p), (b, p), space: oklab)
#let derivados-lamina = (
  suizo: (linea: (de: ("fondo", "tinta"), f: c => _mezcla(c.fondo, c.tinta, 12%))),
)
#let resolver-tema(tema, defecto: none, registro: temas-lamina, derivados: auto) = {
  let buscar(nombre) = {
    if not nombre in registro { panic("tema desconocido: " + repr(nombre)) }
    registro.at(nombre)
  }
  let base = if defecto == none { (:) } else { buscar(defecto) }
  let dado = if type(tema) == str { buscar(tema) }
    else if type(tema) == dictionary { tema }
    else { panic("tema: se esperaba nombre o diccionario, no " + repr(type(tema))) }
  let resuelto = base + dado
  let derivados = if derivados == auto { derivados-lamina.at(str(defecto), default: (:)) } else { derivados }
  for (rol, d) in derivados {
    let cambia = d.de.any(r => r in dado and dado.at(r) != base.at(r, default: none))
    if not rol in dado and cambia { resuelto.insert(rol, (d.f)(resuelto)) }
  }
  resuelto
}

// page() que también cabe dentro de una caja (para catálogos/manuales).
#let pliego(..args) = context {
  let c = text.costs.hyphenation
  let n = args.named()
  let cuerpo = args.pos().first()
  if c < 200% {
    page(..n, cuerpo)
  } else {
    let k = (c - 200%) / 100%
    scale(
      x: k * 100%, y: k * 100%, reflow: true,
      block(width: n.width, height: n.height, fill: n.at("fill", default: none), clip: true, cuerpo),
    )
  }
}

// `marca:` puede ser contenido ya hecho o una función (color, lienzo).
#let resolver-marca(marca, color, formato) = if type(marca) == function { marca(color, formato) } else { marca }

// Contraste WCAG (de contrast.typ): para elegir tinta sobre un fondo.
#let _chan(v) = {
  let x = v / 100%
  if x <= 0.04045 { x / 12.92 } else { calc.pow((x + 0.055) / 1.055, 2.4) }
}
#let luminance(c) = {
  let comps = c.rgb().components()
  let r = comps.at(0)
  let g = comps.at(1, default: r)
  let b = comps.at(2, default: r)
  0.2126 * _chan(r) + 0.7152 * _chan(g) + 0.0722 * _chan(b)
}
#let contrast(a, b) = {
  let l1 = luminance(a)
  let l2 = luminance(b)
  (calc.max(l1, l2) + 0.05) / (calc.min(l1, l2) + 0.05)
}
#let readable-on(bg, ..candidates) = {
  let best = none
  let best-r = -1.0
  for c in candidates.pos() {
    let r = contrast(c, bg)
    if r > best-r { best-r = r; best = c }
  }
  best
}

// Color de base de un fondo (de carteles.typ): el color mismo, o el
// de la primera capa `papel`/`plano`. `none` si no se puede saber.
#let _color-base(fondo) = {
  if type(fondo) == color { return fondo }
  let capas = if type(fondo) == str { () } else if type(fondo) == array { fondo }
    else if type(fondo) == dictionary { fondo.at("capas", default: (fondo,)) } else { () }
  for c in capas {
    if type(c) != dictionary { continue }
    let t = c.at("tipo", default: none)
    if t == "papel" { return c.at("color", default: rgb("#efe4c8")) }
    if t == "plano" and type(c.at("color", default: none)) == color { return c.color }
    if type(c.at("fondo", default: none)) == color { return c.fondo }
  }
  none
}
