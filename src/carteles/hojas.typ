// ─────────────────────────────────────────────────────────────
//  carteles/hojas.typ — preset «hojas»
//
//  Portada geométrica en dos colores (amarillo y azul sobre blanco, con
//  negro para el texto) hecha con una sola pieza, la «hoja» de
//  _hojas-piezas.typ: un cuadrado con tres esquinas redondeadas y una aguda,
//  con un anillo del otro color y un hueco del color del papel. Tres
//  composiciones, de la referencia `tarjetas.html` y su captura:
//
//    "flor"      cuatro hojas en 2 × 2 con la punta al centro. Título arriba
//                a la izquierda y párrafo arriba a la derecha; abajo, un
//                segundo título (`pie`), una etiqueta con nota y una barra
//                negra que sangra por la derecha; el rótulo en vertical, a la
//                izquierda de la flor.
//    "diagonal"  dos hojas que se tocan por la punta, un punto negro y el
//                título apilado abajo; párrafo arriba a la izquierda; a la
//                derecha, el rótulo en vertical sobre un filete que baja
//                hasta la base del título.
//    "patron"    una cinta de pares de hojas a 45° que el borde recorta; el
//                título y el párrafo abajo a la izquierda, el rótulo arriba a
//                la derecha. La cinta se corre sola (perpendicular a sí misma)
//                hasta dejar libres los dos rincones del texto.
//
//  Las medidas salen de la captura de la referencia (una lámina de 380 de
//  ancho; las cotas de abajo están en esas unidades) y se escalan con
//  `escala(formato, base: (380, 475))`: en 4:5 o más alto manda el ancho. Lo
//  que se apoya en un borde se mide desde ese borde y el arte toma el sitio
//  que dejan los textos, así que la lámina no se centra con bandas: cubre la
//  página en cualquier formato.
//
//  Se usa desde el namespace `carteles` (carteles.hojas). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "_base.typ": medida, escala
#import "_temas.typ": resolver-tema
#import "_hojas-piezas.typ": hoja, flor, pareja
#import "../theme.typ": base as _theme-base

#let COMPOSICIONES = ("flor", "diagonal", "patron")

// Texto plano de un contenido (para partir el título en palabras).
#let _plano(c) = {
  if c == none { "" }
  else if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_plano).join("") }
  else if c.has("body") { _plano(c.body) }
  else if c.func() == linebreak { "\n" }
  else if c == [ ] { " " }
  else { " " }
}

// ── carteles.hojas ──────────────────────────────────────────
//   titulo       el título pesado (contenido; sale en mayúsculas). Se parte
//                donde diga `\` y, si no cabe en su ancho, entre palabras; se
//                achica si una palabra sola no cabe.
//   frase        el párrafo (contenido: `*negrita*` para la entrada en negro)
//   composicion  "flor", "diagonal" o "patron"
//   rotulo       la línea vertical en versalitas («COMPANY GEOMETRIC DESIGN»)
//   pie          solo "flor": el segundo título, abajo a la izquierda, tal
//                cual se escribe (sin pasar a mayúsculas)
//   etiqueta, nota   solo "flor": rótulo con un punto y nota chica sobre la
//                barra, abajo a la derecha
//   marca        contenido abajo, centrado en el margen (p. ej. el logo)
//   tema         nombre de `temas-lamina` (por defecto "hojas"), diccionario
//                de roles o `tema-desde-theme(theme.base)`. Roles: fondo (el
//                papel y el hueco de los anillos), tinta (títulos, punto,
//                barra, filete), suave (el párrafo), acento (el amarillo) y
//                hondo (el azul). `fondo`, `tinta`, `suave`, `acento` y
//                `hondo`, si se pasan, pisan al tema.
//   fuente       tipografía de los títulos y el rótulo (auto = la «display»
//                del paquete, `theme.base.fonts.display`: Poppins)
//   fuente-texto tipografía del párrafo y la nota (auto = la «body»: Inter)
//   peso         peso de los títulos (por defecto 800)
//   cuerpo       tamaño del párrafo, en unidades de la lámina de 380
//   lado         lado de una hoja, en unidades de la lámina (auto = el que
//                quepa; en "patron", 83)
//   r-anillo, r-hueco   radios del anillo y del hueco, en fracciones del lado
//   guias        true: dibuja las cajas del texto y la zona del arte
#let hojas(
  titulo,
  frase: none,
  composicion: "flor",
  rotulo: none,
  pie: none,
  etiqueta: none,
  nota: none,
  marca: none,
  formato: (1080, 1350),
  tema: "hojas",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  hondo: auto,
  fuente: auto,
  fuente-texto: auto,
  peso: 800,
  cuerpo: 8.3,
  lado: auto,
  r-anillo: 0.30,
  r-hueco: 0.185,
  guias: false,
) = {
  if not composicion in COMPOSICIONES {
    panic("hojas: `composicion` debe ser " + COMPOSICIONES.map(repr).join(", ") + ", no " + repr(composicion))
  }
  if composicion != "flor" {
    for (n, v) in (pie: pie, etiqueta: etiqueta, nota: nota) {
      if v != none {
        panic("hojas: `" + n + "` solo se usa con composicion: \"flor\" (aquí es " + repr(composicion) + "); quítalo o cambia de composición")
      }
    }
  }
  let (ancho, alto) = medida(formato)
  // En vertical y en cuadrado manda el ancho (hasta 4:5); en apaisado, el
  // alto, contado como 400 unidades (los textos no se quedan chicos).
  let k = if formato.at(0) > formato.at(1) { escala(formato, base: (380, 400)) } else { escala(formato, base: (380, 475)) }
  let tm = resolver-tema(tema, defecto: "hojas")
  let rol = (
    fondo: if fondo == auto { tm.fondo } else { fondo },
    tinta: if tinta == auto { tm.tinta } else { tinta },
    suave: if suave == auto { tm.suave } else { suave },
    acento: if acento == auto { tm.acento } else { acento },
    hondo: if hondo == auto { tm.hondo } else { hondo },
  )
  let fuente = if fuente == auto { _theme-base.fonts.display } else { fuente }
  let fuente-texto = if fuente-texto == auto { _theme-base.fonts.body } else { fuente-texto }

  // unidades de la lámina -> pt; la página en unidades
  let L(u) = u * k * 1pt
  let (W, H) = (ancho / L(1), alto / L(1))
  let M = 42 // margen

  page(width: ancho, height: alto, margin: 0pt, fill: rol.fondo, context {
    set text(lang: "es", hyphenate: false)
    let u = L(1)

    // ── piezas de texto (cada una mide lo que dibuja: `measure` no ve los
    // `set` de este bloque, así que todo lleva fuente y tamaño explícitos) ──

    // Texto con la caja de línea = altura de mayúscula, que mide `cap`
    // unidades sea cual sea la fuente.
    let cap-h(cap, fu, ..args, cuerpo) = {
      let ref = measure(text(font: fu, size: 100pt, top-edge: "cap-height", bottom-edge: "baseline", ..args, [H])).height
      text(font: fu, size: L(cap) / (ref / 100pt), top-edge: "cap-height", bottom-edge: "baseline", ..args, cuerpo)
    }
    // Título: cap y paso (entre bases) en unidades, ancho máximo. Devuelve
    // el bloque, su ancho y alto (unidades) y el factor con que se achicó.
    // Una palabra que no cabe achica todo; si tiene más de `lineas`
    // renglones también se achica, hasta un 45 %.
    let bloque-titulo(c, cap, paso, ancho-max, mayus: true, lineas: 3, quien: "titulo") = {
      // (las palabras, del texto antes de `upper`: el contenido que devuelve
      // `upper` ya no deja leer su texto)
      let plano = _plano(c)
      let plano = if mayus { upper(plano) } else { plano }
      let c = if mayus { upper(c) } else { c }
      let ta = (weight: peso, tracking: 0em, fill: rol.tinta)
      let hacer(f, w) = {
        let t = cap-h(cap * f, fuente, ..ta, c)
        let p = par(leading: L((paso - cap) * f), justify: false, t)
        if w == none { box(p) } else { block(width: L(w), p) }
      }
      let palabras = plano.split(regex("\\s+")).filter(x => x != "")
      let ancho-palabra(f) = calc.max(0, ..palabras.map(x => measure(cap-h(cap * f, fuente, ..ta, x)).width / u))
      let f = 1.0
      while f > 0.45 {
        let libre = measure(hacer(f, none))
        if libre.width / u <= ancho-max {
          let n = calc.round((libre.height / u - cap * f) / (paso * f)) + 1
          if n <= lineas { return (cuerpo: hacer(f, none), w: libre.width / u, h: libre.height / u, f: f) }
        } else if ancho-palabra(f) <= ancho-max {
          let b = measure(hacer(f, ancho-max))
          let n = calc.round((b.height / u - cap * f) / (paso * f)) + 1
          if n <= lineas { return (cuerpo: hacer(f, ancho-max), w: ancho-max, h: b.height / u, f: f) }
        }
        f = f * 0.94
      }
      panic("hojas: `" + quien + "` no cabe en " + str(lineas) + " renglones de " + str(calc.round(ancho-max)) + " unidades ni achicado a la mitad; acórtalo o pártelo con `\\`")
    }
    // Párrafo de `cuerpo` unidades, paso 11/8,3, en un ancho dado.
    let bloque-texto(c, size, ancho, paso: 1.325, fill: rol.suave) = {
      let s = L(size)
      let capr = measure(text(font: fuente-texto, size: 100pt, [H])).height / 100pt
      block(width: L(ancho), text(font: fuente-texto, size: s, fill: fill, weight: 400,
        par(leading: s * (paso - capr), justify: false, c)))
    }
    // El rótulo vertical (se lee de abajo arriba): caja girada.
    let bloque-rotulo(c) = rotate(-90deg, reflow: true,
      cap-h(6, fuente, weight: 800, tracking: 0.06em, fill: rol.tinta, upper(c)))
    let poner(x, y, cuerpo) = place(top + left, dx: L(x), dy: L(y), cuerpo)
    let guia(x0, y0, x1, y1, c: red) = if guias {
      poner(x0, y0, rect(width: L(x1 - x0), height: L(y1 - y0), stroke: 0.8pt + c))
    }

    if composicion == "flor" {
      // ── arriba: título a la izquierda, párrafo en la columna derecha ──
      // (la columna derecha no pasa de 124 de ancho: en apaisado se va a la
      // derecha y deja una columna central para la flor)
      let colx = calc.max(0.605 * W, W - 44 - 124)
      let der = W - 44
      let t = bloque-titulo(titulo, 22, 28, colx - M - 18)
      poner(M, M, t.cuerpo)
      guia(M, M, M + t.w, M + t.h)
      let fh = 0
      if frase != none {
        let b = bloque-texto(frase, cuerpo, der - colx)
        fh = measure(b).height / u
        poner(colx, M, b)
        guia(colx, M, der, M + fh)
      }
      let techo = M + calc.max(t.h, fh)

      // ── abajo: el pie a la izquierda; etiqueta, nota y barra a la derecha ──
      let base = H - 50
      let barra = 8.7
      // la barra acompaña a la etiqueta y la nota (sola, sin nada encima, sobra)
      if etiqueta != none or nota != none {
        place(top + left, dx: L(colx), dy: L(base - barra), rect(width: ancho - L(colx), height: L(barra), fill: rol.tinta))
      }
      let piso = base - barra - 11
      let pw = 0
      if pie != none {
        let p = bloque-titulo(pie, 18.5, 23.4, colx - M - 14, mayus: false, lineas: 2, quien: "pie")
        poner(M, base - p.h, p.cuerpo)
        guia(M, base - p.h, M + p.w, base)
        piso = calc.min(piso, base - p.h)
        pw = p.w
      }
      let y = base - barra - 11 // base de la última línea de la nota
      if nota != none {
        let b = bloque-texto(nota, 5.6, der - colx, paso: 1.28, fill: rol.tinta)
        let h = measure(b).height / u
        poner(colx, y - h, b)
        guia(colx, y - h, der, y)
        y -= h + 6.7
      }
      if etiqueta != none {
        let e = cap-h(8.7, fuente, weight: 700, fill: rol.tinta, etiqueta)
        let d = 7.4
        poner(colx, y - 8.7 / 2 - d / 2, circle(radius: L(d / 2), fill: rol.tinta))
        poner(colx + d + 4.6, y - 8.7, e)
        y -= 8.7
      }
      piso = calc.min(piso, y)

      // ── la flor, con el rótulo a su izquierda. Dos sitios posibles: el
      // hueco entre las dos bandas (a lo ancho, como la referencia) o la
      // columna entre los textos de la izquierda y la columna derecha (a lo
      // alto, en apaisado); gana el que la deja más grande ──
      let rw = if rotulo == none { 0 } else { measure(bloque-rotulo(rotulo)).width / u + 27 }
      let x0 = M + rw
      let sa = calc.min(0.84 * (der - x0), 0.645 * (piso - techo)) / 2
      let xb = M + calc.max(t.w, pw) + 30
      let sb = 0.84 * calc.min(colx - 30 - (xb + rw), base - M) / 2
      let (rx, x0, x1, y0, y1, S) = if sa >= sb { (M, x0, der, techo, piso, sa) } else { (xb, xb + rw, colx - 30, M, base, sb) }
      guia(x0, y0, x1, y1, c: blue)
      let S = if lado == auto { S } else { lado }
      if S < 30 {
        panic("hojas: la flor no cabe (queda un lado de " + str(calc.round(S)) + " unidades); acorta los textos o usa un formato más alto")
      }
      let (cx, cy) = ((x0 + x1) / 2, (y0 + y1) / 2)
      poner(cx - S, cy - S, flor(L(S), rol.hondo, rol.acento, rol.fondo, r-anillo: r-anillo, r-hueco: r-hueco))
      if rotulo != none {
        let r = bloque-rotulo(rotulo)
        let rh = measure(r).height / u
        poner(rx, cy - rh / 2, r)
      }
    } else if composicion == "diagonal" {
      // ── el rótulo arriba a la derecha y el filete que baja de él ──
      let base = H - 52
      let fx = W - M - 3 // eje del rótulo y del filete
      let rot-pie = M
      if rotulo != none {
        let r = bloque-rotulo(rotulo)
        let m = measure(r)
        poner(fx - m.width / u / 2, M, r)
        rot-pie = M + m.height / u + 16
      }
      place(top + left, dx: L(fx) - L(0.65), dy: L(rot-pie), rect(width: L(1.3), height: L(base - rot-pie), fill: rol.tinta))

      // ── arriba a la izquierda, el párrafo ──
      let techo = M
      let fw = 0
      if frase != none {
        fw = calc.min(0.355 * W, 150, fx - 24 - M)
        let b = bloque-texto(frase, cuerpo, fw)
        let h = measure(b).height / u
        poner(M, M, b)
        guia(M, M, M + fw, M + h)
        techo = M + h
      }

      // ── abajo: el título apilado, y el punto encima ──
      let t = bloque-titulo(titulo, 24.5, 32.4, fx - 24 - M)
      poner(M, base - t.h, t.cuerpo)
      guia(M, base - t.h, M + t.w, base)
      let d = 22.7
      let punto-y = base - t.h - 14 - d
      poner(M, punto-y, circle(radius: L(d / 2), fill: rol.tinta))

      // ── el par. Dos sitios posibles: entre el párrafo y el punto, apoyado
      // sobre el punto (si sobra mucho alto, centrado), como la referencia; o
      // centrado entre los textos de la izquierda y el filete (en apaisado).
      // Gana el que lo deja más grande ──
      let (x0, x1) = (M - 4, fx - 24)
      let (y0, y1) = (techo + 30, punto-y - 14)
      let sa = calc.min(0.4 * (x1 - x0), (y1 - y0) / 2)
      let xb = M + calc.max(t.w, fw) + 30
      let sb = 0.84 * calc.min(x1 - xb, base - M) / 2
      let S = if lado == auto { calc.max(sa, sb) } else { lado }
      if S < 30 {
        panic("hojas: el par no cabe (queda un lado de " + str(calc.round(S)) + " unidades); acorta los textos o usa un formato más alto")
      }
      let (px, py) = if sa >= sb {
        let sobra = (y1 - y0) - 2 * S
        (x0, if sobra <= S { y1 - 2 * S } else { (y0 + y1) / 2 - S })
      } else {
        ((xb + x1) / 2 - S, (M + base) / 2 - S)
      }
      if sa >= sb { guia(x0, y0, x1, y1, c: blue) } else { guia(xb, M, x1, base, c: blue) }
      poner(px, py, pareja(L(S), rol.hondo, rol.acento, rol.fondo, r-anillo: r-anillo, r-hueco: r-hueco))
    } else {
      // ── "patron": texto abajo a la izquierda, rótulo arriba a la derecha ──
      let base = H - 46
      let tw-max = 0.62 * W - M
      let t = bloque-titulo(titulo, 25, 32.8, tw-max, lineas: 2)
      let (fw, fh) = (0, 0)
      let b = none
      if frase != none {
        fw = calc.min(0.355 * W, 150, tw-max)
        b = bloque-texto(frase, cuerpo, fw)
        fh = measure(b).height / u
      }
      let sep = if frase == none { 0 } else { 19.4 }
      let ty = base - fh - sep - t.h
      poner(M, ty, t.cuerpo)
      guia(M, ty, M + t.w, ty + t.h)
      if b != none {
        poner(M, base - fh, b)
        guia(M, base - fh, M + fw, base)
      }
      let (rx0, ry1) = (W - M, M)
      if rotulo != none {
        let r = bloque-rotulo(rotulo)
        let m = measure(r)
        rx0 = W - M - m.width / u
        ry1 = M + m.height / u
        poner(rx0, M, r)
        guia(rx0, M, W - M, ry1)
      }

      // ── la cinta: pares de hojas cuyas puntas caen sobre la recta
      // y = x + d. Una hoja de la cinta llega como mucho a (1 + √2/2) lados
      // de la recta, medido en y − x. `d` queda en el medio de lo que dejan
      // libre el texto (abajo a la izquierda) y el rótulo (arriba a la
      // derecha); si no hay sitio, las hojas se achican. ──
      let alcance = 1 + calc.sqrt(2) / 2
      let (aire-t, aire-r) = (46, 42)
      // los rincones del texto: el de arriba a la derecha de cada pieza
      let esquinas-t = ((M + t.w, ty),) + if b != none { ((M + fw, base - fh),) } else { () }
      let lim-t = calc.min(..esquinas-t.map(((x, y)) => y - x)) - aire-t
      let lim-r = if rotulo == none { M - (W - M) } else { ry1 - rx0 } + aire-r
      let S0 = if lado == auto { 83 } else { lado }
      let S = S0
      while lim-t - lim-r < 2 * alcance * S and S > 0.5 * S0 { S = S * 0.95 }
      if lim-t - lim-r < 2 * alcance * S {
        panic("hojas: la cinta de hojas no cabe entre el texto y el rótulo; acorta el título o la frase, quita el rótulo o usa un formato más alto")
      }
      let d = (lim-t + lim-r) / 2
      let paso = 0.8 * S
      if guias {
        for dd in (d, d - alcance * S, d + alcance * S) {
          place(top + left, line(start: (0pt, L(dd)), end: (L(H - dd), alto), stroke: 0.8pt + blue))
        }
      }
      // puntas en x = M + i·paso; todas las que caen en la página
      let i0 = calc.floor((-S - M) / paso)
      let i1 = calc.ceil((W + S - M) / paso)
      place(top + left, box(width: ancho, height: alto, clip: true, {
        for i in range(i0, i1 + 1) {
          let (px, py) = (M + i * paso, M + i * paso + d)
          if px < 0 or px > W or py < 0 or py > H { continue }
          let (c1, c2) = if calc.rem(calc.abs(i), 2) == 0 { (rol.acento, rol.hondo) } else { (rol.hondo, rol.acento) }
          poner(px - S, py - S, pareja(L(S), c1, c2, rol.fondo, diagonal: "subida", r-anillo: r-anillo, r-hueco: r-hueco))
        }
      }))
    }

    if marca != none {
      place(bottom + center, dy: -L(16), marca)
    }
  })
}
