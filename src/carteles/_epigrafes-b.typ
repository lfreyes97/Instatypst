// ─────────────────────────────────────────────────────────────
//  carteles/_epigrafes-b.typ — cinco estilos geométricos de epígrafe
//
//  Cartel de una cita breve con su autor y su obra. En los cinco el arte de
//  los presets geométricos del paquete queda al margen y la cita manda:
//
//    hojas    la flor de cuatro hojas (_hojas-piezas.typ) como firma pequeña
//             junto al autor; la cita, un bloque pesado de sans (Poppins 800)
//             que llena la caja de arriba.
//    bauhaus  cuadrado, círculo, cuña y barra apoyados en una línea de tierra
//             (la construcción de carteles.bauhaus); bajo la tierra, la cita
//             en columna (Jost) y el autor en la columna estrecha de al lado.
//    arcos    los arcos paralelos de mosaico (_arcos.typ) como un sol naciente
//             en una banda del 40 % de arriba; la cita, centrada en serif
//             (Fraunces), en el resto.
//    malla    retícula suiza de módulos casi cuadrados con una sola celda de
//             color que lleva el autor; la cita grande en bandera izquierda
//             (Hanken Grotesk) sobre las filas de arriba.
//    lineas   fondo liso, un solo filete grueso que sangra por la izquierda y
//             la cita en un cuerpo enorme de Bodoni, apoyada abajo.
//
//  Contrato común (para el despachador `carteles.epigrafe`):
//    estilos-b.<nombre>(cita, autor: none, obra: none, formato: (1080, 1350),
//                       tema: auto, marca: none, guias: false) -> página
//  `cita` es contenido (admite `\`), `tema` es un nombre de `temas-lamina`
//  o de los temas propios de este archivo, un diccionario de roles (fondo,
//  tinta, suave, acento, más los extras de cada estilo) o `auto` (el tema
//  propio del estilo). La cita se achica hasta caber en su caja; si ni con
//  el cuerpo mínimo legible (34 px en un lado menor de 1080) cabe, error.
//
//  Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────

#import "../pliego.typ": pliego
#import "_base.typ": medida, escala, ajustar-alto
#import "_temas.typ": resolver-tema, temas-lamina
#import "_hojas-piezas.typ": flor
#import "_arcos.typ": arcos

// ── temas propios ───────────────────────────────────────────
// Los que no salen tal cual de `temas-lamina`. `hojas` y `bauhaus` usan los
// del registro.
#let _temas-b = (
  // arcos: el azul hondo de mosaico como papel, los arcos en su menta y el
  // disco en su naranja; la cita en crema.
  epi-arcos: (
    fondo: rgb("#002b38"),
    tinta: rgb("#f1ede4"),
    suave: rgb("#b3dcd4"),
    acento: rgb("#ff832a"),
  ),
  // malla: gris suizo frío, negro, rojo señal; `linea` la retícula y
  // `claro` el texto sobre la celda.
  epi-malla: (
    fondo: rgb("#e9e9e5"),
    tinta: rgb("#111111"),
    suave: rgb("#4f4f4b"),
    acento: rgb("#d62a1e"),
    linea: rgb("#bdbdb5"),
    claro: rgb("#ffffff"),
  ),
  // lineas: rojo sangre muy hondo y crema.
  epi-lineas: (
    fondo: rgb("#2e0f10"),
    tinta: rgb("#f3eadf"),
    suave: rgb("#cdb3a4"),
    acento: rgb("#f3eadf"),
  ),
)
#let _registro = temas-lamina + _temas-b

// Roles de un estilo: `auto` = su tema; si no, lo dado sobre su tema.
#let _tema(tema, defecto) = {
  if tema == auto { resolver-tema(defecto, defecto: defecto, registro: _registro) }
  else { resolver-tema(tema, defecto: defecto, registro: _registro) }
}

// ── comprobaciones ──────────────────────────────────────────
#let _validar(cita, formato, quien) = {
  if cita == none or cita == [] or cita == "" {
    panic(quien + ": falta la cita")
  }
  if type(cita) not in (str, content) {
    panic(quien + ": la cita es contenido o texto, no " + repr(type(cita)))
  }
  if type(formato) != array or formato.len() != 2 or formato.any(x => type(x) not in (int, float) or x <= 0) {
    panic(quien + ": `formato` es un par (ancho, alto) en px, no " + repr(formato))
  }
}

// Texto plano de un contenido (para medir sus palabras).
#let _plano(c) = {
  if c == none { "" }
  else if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_plano).join("") }
  else if c.has("body") { _plano(c.body) }
  else if c.has("child") { _plano(c.child) }
  else { " " }
}

// La cita en un bloque de ancho `w` a cuerpo `s`.
//   estilo   argumentos de `text` (font, weight, style, tracking, fill)
//   inter    interlínea en em
//   al       alineación de las líneas
#let _bloque(cita, estilo, inter, w, s, al: left) = block(width: w, {
  set text(size: s, hyphenate: false, lang: "es", ..estilo)
  set par(leading: inter * 1em, justify: false, spacing: inter * 1em)
  align(al, cita)
})

// El mayor cuerpo, de `desde` a `minimo`, con el que la cita cabe en w × h y
// ninguna palabra pasa de `w`. `none` si no cabe ni con el mínimo. Dentro de
// `context`.
#let _cuerpo(cita, estilo, inter, w, h, desde, minimo, al: left) = {
  let hacer(s) = _bloque(cita, estilo, inter, w, s, al: al)
  let palabras = _plano(cita).split(regex("\s+")).filter(x => x != "")
  let ancha = calc.max(1pt, ..palabras.map(p => measure(text(size: 100pt, hyphenate: false, ..estilo, p)).width))
  let tope = calc.min(desde, 100pt * (w / ancha) * 0.98)
  if tope < minimo { return none }
  let s = ajustar-alto(hacer, tope, h, minimo: minimo, paso: 1pt)
  let s = calc.max(s, minimo)
  if measure(hacer(s)).height > h { none } else { s }
}

#let _no-cabe(quien, minimo) = panic(quien + ": la cita no cabe ni con el cuerpo mínimo legible ("
  + str(calc.round(minimo / 1pt, digits: 1)) + " px). Acórtala o usa un formato más alto.")

// Guía de depuración: el contorno de una caja.
#let _guia(x, y, w, h, color: red) = place(top + left, dx: x, dy: y,
  rect(width: w, height: h, stroke: 1.5pt + color, fill: color.transparentize(88%)))

// Medidas comunes de un formato: (ancho, alto, k = escala sobre el retrato,
// km = factor del cuerpo mínimo, minimo = el cuerpo mínimo de la cita).
#let _medidas(formato) = {
  let (ancho, alto) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let km = calc.min(ancho, alto) / 1080pt
  (ancho: ancho, alto: alto, k: k, km: km, minimo: 34pt * km)
}

// ════════════════════════════════════════════════════════════
//  1 · hojas
// ════════════════════════════════════════════════════════════
// Papel blanco; la cita en Poppins 800, apretada, llena la caja de arriba.
// Abajo a la izquierda, la flor de cuatro hojas (amarillo y azul, el hueco
// del color del papel) y, a su lado, el autor en versalitas y la obra.
#let _hojas(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «hojas»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "hojas")
  let m = 88pt * k
  let lado = 56pt * k // la flor mide 2 lados
  let estilo = (font: "Poppins", weight: 800, tracking: -0.025em, fill: c.tinta)

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    // ── la firma ──
    let firma-texto = {
      set text(font: "Poppins", fill: c.tinta, lang: "es")
      if autor != none { text(size: 36pt * km, weight: 700, tracking: 0.08em, upper(autor)) }
      if autor != none and obra != none { linebreak() }
      if obra != none { text(size: 36pt * km, weight: 400, fill: c.suave, obra) }
    }
    let tw = ancho - 2 * m - 2 * lado - 32pt * k - (if marca != none { 200pt * k } else { 0pt })
    let ft = block(width: tw, par(leading: 0.45em, justify: false, firma-texto))
    let fh = calc.max(2 * lado, measure(ft).height)
    let fy = alto - m - fh
    place(top + left, dx: m, dy: fy + fh - 2 * lado, flor(lado, c.acento, c.hondo, c.fondo))
    if autor != none or obra != none {
      place(top + left, dx: m + 2 * lado + 32pt * k, dy: fy + fh - measure(ft).height, ft)
    }
    if marca != none { place(bottom + right, dx: -m, dy: -m, marca) }

    // ── la cita ──
    let (x, y, w) = (m, m, ancho - 2 * m)
    let h = fy - 72pt * k - y
    let s = _cuerpo(cita, estilo, 0.24, w, h, 170pt * km, minimo)
    if s == none { _no-cabe(quien, minimo) }
    place(top + left, dx: x, dy: y, _bloque(cita, estilo, 0.24, w, s))
    if guias { _guia(x, y, w, h); _guia(m, fy, ancho - 2 * m, fh, color: blue) }
  })
}

// ════════════════════════════════════════════════════════════
//  2 · bauhaus
// ════════════════════════════════════════════════════════════
// La construcción de carteles.bauhaus, en pequeño: un cuadrado rojo apoyado
// en la tierra, el círculo amarillo con centro en su esquina de arriba a la
// derecha (tangente a la misma tierra), una barra negra que nace en el
// margen y pasa por ese centro, y la cuña azul entre la tierra y la barra.
// La tierra es un filete a todo el ancho útil. Debajo, dos columnas: la
// cita (Jost 500) en la ancha y el autor en la estrecha, tras un cuadradito
// rojo. La tierra baja lo que la cita deje (entre el 50 y el 28 % del alto).
#let _formas-bauhaus(c, ancho, gt, m, u, k) = {
  let min-incl = 22deg
  let L = calc.min(0.34 * u, (gt - 0.7 * m) / 2)
  let sx-incl = m + L / calc.tan(min-incl) - L
  let sx-sangra = ancho - 1.8 * L
  let sx = if sx-incl >= sx-sangra { sx-sangra } else { calc.min(sx-incl, ancho - m - 2 * L) }
  let sx = calc.max(ancho * 0.30, sx)
  let (cx, cy) = (sx + L, gt - L)
  let g = 0.042 * u
  let gv = g / calc.cos(calc.atan2((cx - m) / 1pt, L / 1pt))
  let tg = (L - gv / 2) / (cx - m)
  let y-en(x) = gt - (x - m) * tg
  let xf = ancho + 2 * g
  place(top + left, dx: cx - L, dy: cy - L, circle(radius: L, fill: c.amarillo))
  place(top + left, dx: sx, dy: cy, rect(width: L, height: L, fill: c.acento))
  let x1 = sx - 0.14 * L
  place(top + left, polygon(fill: c.azul, (m, gt), (x1, gt), (x1, y-en(x1))))
  place(top + left, polygon(fill: c.tinta, (m, gt), (xf, y-en(xf)), (xf, y-en(xf) - gv), (m, gt - gv)))
  // la tierra
  place(top + left, dx: m, dy: gt, rect(width: ancho - 2 * m, height: 5pt * k, fill: c.tinta))
}

#let _bauhaus(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «bauhaus»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "bauhaus")
  let m = 72pt * k
  let u = calc.min(ancho, alto)
  let gut = 44pt * k
  let lateral = autor != none or obra != none
  let colw = if lateral { (ancho - 2 * m - gut) * 0.68 } else { ancho - 2 * m }
  let latw = ancho - 2 * m - gut - colw
  let gap = 64pt * k // de la tierra al texto
  let estilo = (font: "Jost", weight: 500, tracking: -0.01em, fill: c.tinta)
  let comodo = 52pt * km

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    let pie = if marca != none { measure(marca).height + 32pt * k } else { 0pt }
    let fracs = (0.50, 0.46, 0.42, 0.38, 0.34, 0.31, 0.28)
    let opcion(f) = {
      let gt = alto * f
      let (y, h) = (gt + gap, alto - m - pie - gt - gap)
      (gt: gt, y: y, h: h, s: _cuerpo(cita, estilo, 0.30, colw, h, 76pt * km, minimo))
    }
    let ops = fracs.map(opcion)
    let o = ops.find(o => o.s != none and o.s >= comodo)
    if o == none { o = ops.find(o => o.s != none) }
    if o == none { _no-cabe(quien, minimo) }

    _formas-bauhaus(c, ancho, o.gt, m, u, k)
    place(top + left, dx: m, dy: o.y, _bloque(cita, estilo, 0.30, colw, o.s))

    if lateral {
      let x = m + colw + gut
      let lat = block(width: latw, {
        set text(font: "Jost", fill: c.tinta, lang: "es", hyphenate: false)
        set par(leading: 0.4em, justify: false)
        rect(width: 22pt * k, height: 22pt * k, fill: c.acento)
        v(18pt * k)
        if autor != none { text(size: 30pt * km, weight: 700, tracking: 0.06em, upper(autor)) }
        if autor != none and obra != none { v(10pt * k) }
        if obra != none { text(size: 30pt * km, weight: 400, fill: c.suave, obra) }
      })
      // el rótulo arranca a la altura de la primera línea de la cita
      place(top + left, dx: x, dy: o.y + 0.12 * o.s, lat)
      if measure(lat).height > o.h { panic(quien + ": el autor y la obra no caben en su columna") }
      if guias { _guia(x, o.y, latw, o.h, color: blue) }
    }
    if marca != none { place(bottom + left, dx: m, dy: -m, marca) }
    if guias { _guia(m, o.y, colw, o.h) }
  })
}

// ════════════════════════════════════════════════════════════
//  3 · arcos
// ════════════════════════════════════════════════════════════
// Una banda del 40 % de arriba con diez arcos paralelos (los de mosaico) en
// medio círculo, sobre una línea de horizonte, y un disco naranja en su
// centro: un sol que asoma. La banda recorta lo que sale por los lados. En
// el resto, la cita centrada en Fraunces y, debajo, el autor en versalitas
// espaciadas (naranja) y la obra en cursiva.
#let _arcos-estilo(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «arcos»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "epi-arcos")
  let m = 84pt * k
  let H = alto * 0.40
  let n = 10
  let tope = calc.min(H - 0.8 * m, ancho * 0.62) // borde de fuera del arco mayor
  let r0 = tope * 0.30
  let paso = (tope - r0) / (n - 1 + 0.37)
  let grosor = 0.37 * paso
  let estilo = (font: "Fraunces 72pt", weight: 400, tracking: -0.005em, fill: c.tinta)

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    // ── la banda ──
    place(top + left, box(width: ancho, height: H + grosor / 2, clip: true, {
      arcos((ancho / 2, H), r0 + grosor / 2, lineas: n, paso: paso, grosor: grosor,
        desde: 180deg, hasta: 360deg, color: c.suave)
      let rd = r0 - 0.55 * paso
      place(top + left, dx: ancho / 2 - rd, dy: H - rd, circle(radius: rd, fill: c.acento))
    }))
    place(top + left, dy: H - grosor / 2, rect(width: ancho, height: grosor, fill: c.suave))

    // ── la firma ──
    let firma = if autor == none and obra == none { none } else {
      block(width: ancho - 2 * m, align(center, {
        set text(lang: "es", hyphenate: false)
        set par(leading: 0.5em, justify: false)
        if autor != none { text(font: "Jost", size: 30pt * km, weight: 600, tracking: 0.22em, fill: c.acento, upper(autor)) }
        if autor != none and obra != none { linebreak() }
        if obra != none { text(font: "Fraunces 72pt", size: 36pt * km, fill: c.suave, obra) }
      }))
    }
    let fh = if firma == none { 0pt } else { measure(firma).height }
    let sep = if firma == none { 0pt } else { 64pt * k }
    let pie = if marca != none { measure(marca).height + 32pt * k } else { 0pt }

    // ── la cita ──
    let (y0, y1) = (H + 80pt * k, alto - m - pie)
    let w = ancho - 2 * m
    let h = y1 - y0 - fh - sep
    let s = _cuerpo(cita, estilo, 0.36, w, h, 84pt * km, minimo, al: center)
    if s == none { _no-cabe(quien, minimo) }
    let b = _bloque(cita, estilo, 0.36, w, s, al: center)
    let bh = measure(b).height
    let y = y0 + (y1 - y0 - bh - sep - fh) / 2
    place(top + left, dx: m, dy: y, b)
    if firma != none { place(top + left, dx: m, dy: y + bh + sep, firma) }
    if marca != none { place(bottom + center, dy: -m, marca) }
    if guias { _guia(m, y0, w, y1 - y0); _guia(0pt, 0pt, ancho, H, color: blue) }
  })
}

// ════════════════════════════════════════════════════════════
//  4 · malla
// ════════════════════════════════════════════════════════════
// Retícula de 4 columnas (6 en apaisado) y filas casi cuadradas que llenan
// el alto, en filetes finos. La cita va en bandera izquierda desde la
// esquina de la primera celda y ocupa las filas de arriba (Hanken Grotesk
// 600); la última fila queda libre salvo una celda, la de la derecha, llena
// de rojo, con el autor y la obra.
#let _malla(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «malla»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "epi-malla")
  let m = 56pt * k
  let cols = if ancho > alto { 6 } else { 4 }
  let cw = (ancho - 2 * m) / cols
  let filas = calc.max(2, calc.floor((alto - 2 * m) / cw))
  let rh = (alto - 2 * m) / filas
  let pad = 22pt * k
  let fil = 1.5pt * k
  let estilo = (font: "Hanken Grotesk", weight: 600, tracking: -0.025em, fill: c.tinta)
  // Hanken junta tanto el punto y el cierre de comillas que se montan
  let cita = { show regex("[.,;:!?…][»”’]"): t => t.text.clusters().join(h(0.1em)); cita }

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    // ── la retícula ──
    for i in range(cols + 1) {
      place(top + left, dx: m + i * cw - fil / 2, dy: m, rect(width: fil, height: alto - 2 * m, fill: c.linea))
    }
    for j in range(filas + 1) {
      place(top + left, dx: m, dy: m + j * rh - fil / 2, rect(width: ancho - 2 * m, height: fil, fill: c.linea))
    }

    // ── la celda ──
    let (cx, cy) = (m + (cols - 1) * cw, m + (filas - 1) * rh)
    place(top + left, dx: cx - fil / 2, dy: cy - fil / 2, rect(width: cw + fil, height: rh + fil, fill: c.acento))
    if autor != none or obra != none {
      let iw = cw - 2 * pad
      let et = (font: "Hanken Grotesk", weight: 700, tracking: -0.01em, fill: c.claro)
      // el autor se achica (por palabras) hasta caber en el ancho de la celda
      let sa = if autor == none { 0pt } else {
        let pal = _plano(autor).split(regex("\s+")).filter(x => x != "")
        let ancha = calc.max(1pt, ..pal.map(p => measure(text(size: 100pt, ..et, p)).width))
        calc.min(38pt * km, 100pt * (iw / ancha))
      }
      if autor != none and sa < 20pt * km { panic(quien + ": el nombre del autor no cabe en la celda") }
      let dentro = block(width: iw, {
        set text(lang: "es", hyphenate: false)
        set par(leading: 0.3em, justify: false)
        if autor != none { text(size: sa, ..et, autor) }
        if autor != none and obra != none { v(12pt * k) }
        if obra != none { text(font: "Hanken Grotesk", size: 26pt * km, weight: 400, fill: c.claro, obra) }
      })
      if measure(dentro).height > rh - 2 * pad { panic(quien + ": el autor y la obra no caben en la celda") }
      place(top + left, dx: cx + pad, dy: cy + pad, dentro)
    }
    if marca != none { place(top + left, dx: m + pad, dy: cy + rh - pad - measure(marca).height, marca) }

    // ── la cita ──
    let (x, y, w) = (m + pad, m + pad * 0.6, ancho - 2 * m - 2 * pad)
    let h = (filas - 1) * rh - 2 * pad
    let s = _cuerpo(cita, estilo, 0.26, w, h, 112pt * km, minimo)
    if s == none { _no-cabe(quien, minimo) }
    place(top + left, dx: x, dy: y, _bloque(cita, estilo, 0.26, w, s))
    if guias { _guia(x, y, w, h) }
  })
}

// ════════════════════════════════════════════════════════════
//  5 · lineas
// ════════════════════════════════════════════════════════════
// Nada más que un filete grueso arriba, sangrando por la izquierda, y la
// cita en Bodoni de cuerpo enorme apoyada sobre el autor, abajo. Un color y
// el fondo.
#let _lineas(cita, autor: none, obra: none, formato: (1080, 1350), tema: auto, marca: none, guias: false) = {
  let quien = "epígrafe «lineas»"
  _validar(cita, formato, quien)
  let (ancho, alto, k, km, minimo) = _medidas(formato)
  let c = _tema(tema, "epi-lineas")
  // el estilo es el cuerpo enorme: no baja tanto como los otros
  let minimo = calc.max(minimo, 52pt * km)
  let m = 84pt * k
  let estilo = (font: "Bodoni Moda 72pt", weight: 400, tracking: -0.015em, fill: c.tinta)

  pliego(width: ancho, height: alto, margin: 0pt, fill: c.fondo, context {
    let grueso = 20pt * k
    place(top + left, dy: m, rect(width: m + 0.26 * ancho, height: grueso, fill: c.acento))

    let firma = if autor == none and obra == none { none } else {
      let partes = ()
      if autor != none { partes.push(autor) }
      if obra != none { partes.push(obra) }
      block(width: ancho - 2 * m - (if marca != none { 220pt * k } else { 0pt }),
        text(font: "Bodoni Moda 28pt", size: 40pt * km, fill: c.suave, lang: "es", hyphenate: false,
          par(leading: 0.45em, justify: false, partes.join([, ]))))
    }
    let fh = if firma == none { 0pt } else { measure(firma).height }
    let sep = if firma == none { 0pt } else { 64pt * k }
    let (y0, y1) = (m + grueso + 96pt * k, alto - m - fh - sep)
    let w = ancho - 2 * m
    let s = _cuerpo(cita, estilo, 0.16, w, y1 - y0, 200pt * km, minimo)
    if s == none { _no-cabe(quien, minimo) }
    let b = _bloque(cita, estilo, 0.16, w, s)
    place(top + left, dx: m, dy: y1 - measure(b).height, b)
    if firma != none { place(top + left, dx: m, dy: alto - m - fh, firma) }
    if marca != none { place(bottom + right, dx: -m, dy: -m, marca) }
    if guias { _guia(m, y0, w, y1 - y0) }
  })
}

#let estilos-b = (
  hojas: _hojas,
  bauhaus: _bauhaus,
  arcos: _arcos-estilo,
  malla: _malla,
  lineas: _lineas,
)
