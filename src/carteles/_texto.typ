// ─────────────────────────────────────────────────────────────
//  carteles/_texto.typ — la capa de texto de teselas y mosaico
//
//  Título en negrita, párrafo en gris, una palabra pesada apilada (dos letras
//  por línea) y una línea de autor. Cada preset decide DÓNDE van, con una
//  `zona`, y a qué escala, con `k`; aquí está lo que no cambia: las alturas de
//  letra se ajustan midiendo la tipografía (la misma altura de mayúscula sea
//  cual sea la fuente) y cada pieza se achica si no cabe en su caja.
//  `capa-texto` usa cajas fijas (teselas); `bloque-texto` busca el sitio a
//  partir de los obstáculos del arte (mosaico).
//
//  Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────
#import "_base.typ": ajustar-alto
#import "_huecos.typ": libre, ob-caja, dibujar-obstaculos

// Un texto cuya altura de mayúscula mide `cap` unidades (con `L`, la medida
// del preset), sea cual sea la tipografía; `f` (por defecto 1) lo achica
// proporcionalmente. Usar dentro de `context`.
#let _cap-h(L, cap, f: 1, ..args, texto) = {
  let ref = measure(text(size: 100pt, top-edge: "cap-height", bottom-edge: "baseline", ..args, [H])).height
  text(size: f * L(cap) / (ref / 100pt), top-edge: "cap-height", bottom-edge: "baseline", ..args, texto)
}

// La palabra de la pila, en líneas de dos letras.
#let _lineas-pila(remate) = {
  let plano = if type(remate) == str { remate } else if remate.has("text") { remate.text } else {
    panic("`remate` es una palabra (str o texto sin formato), no " + repr(remate))
  }
  let letras = upper(plano).clusters()
  range(0, letras.len(), step: 2).map(i => letras.slice(i, calc.min(i + 2, letras.len())).join())
}

// ── capa-texto ──────────────────────────────────────────────
//   L, X, Y   las funciones del preset: una medida de su lámina de
//             referencia a pt, y una posición (x o y) a pt de la página
//   tinta, suave   colores del título y la pila / del párrafo
//   zona      dónde va cada pieza, en unidades de la lámina del preset:
//               titulo   (x, y, ancho)   y = arriba de las mayúsculas; el
//                        título se achica si pasa de `ancho`
//               parrafo  (x, y, ancho, alto, alto-autor)   la caja del
//                        párrafo; con `autor` se usa `alto-autor`
//               pila     (derecha, y, alto)   borde derecho y arriba de la
//                        pila; si no cabe en `alto`, se escala entera
//               autor    (x, y)
//   k         escala de los tamaños: 1 = los de la lámina de `teselas`
//             (300 de ancho); una lámina de 802 de ancho usa k = 2,675
//   cuerpo    tamaño máximo del párrafo, en unidades de la lámina del preset
//   fuente    tipografía de la capa (auto = la del contenedor)
#let capa-texto(
  L, X, Y,
  tinta, suave,
  zona,
  k: 1,
  etiqueta: none,
  frase: none,
  remate: none,
  autor: none,
  cuerpo: 7.4,
  fuente: auto,
) = context {
  // La capa fija su propio espaciado y tipografía: no hereda los del preset
  // (mosaico pone `tracking: 0.65em` a sus rótulos, y aquí no debe llegar).
  set text(tracking: 0em, weight: 400)
  set text(font: fuente) if fuente != auto
  let cap-h(cap, f: 1, ..args, texto) = _cap-h(L, cap, f: f, ..args, texto)

  // título (se achica si no cabe en su ancho: no llega a la pila)
  if etiqueta != none {
    let z = zona.titulo
    let ta = (weight: 800, tracking: 0em, fill: tinta)
    let cap = 13.7 * k
    let w = measure(cap-h(cap, ..ta, upper(etiqueta))).width
    let f = if w > L(z.ancho) { L(z.ancho) / w } else { 1 }
    place(top + left, dx: X(z.x), dy: Y(z.y + cap * (1 - f)), cap-h(cap, f: f, ..ta, upper(etiqueta)))
  }

  // palabra pesada, apilada a la derecha: dos letras por línea. (La
  // referencia parte «DE / SI / G / N» según el ancho de sus letras, que
  // cambia con la tipografía; dos por línea no depende de ella.) Con la
  // caja de línea = altura de mayúscula, `leading` es el hueco exacto.
  if remate != none {
    let z = zona.pila
    let lineas = _lineas-pila(remate)
    let (cap, paso) = (18.4 * k, 23.5 * k)
    // si la pila no cabe en `alto`, todo se escala junto
    let f = calc.min(1, z.alto / ((lineas.len() - 1) * paso + cap))
    place(top + left, dx: X(z.derecha) - L(60 * k), dy: Y(z.y),
      block(width: L(60 * k), align(right, par(leading: L((paso - cap) * f), justify: false,
        cap-h(cap, f: f, weight: 800, fill: tinta, lineas.join(linebreak()))))))
  }

  // párrafo: se achica para caber; con `autor`, deja sitio a su línea
  if frase != none {
    let z = zona.parrafo
    let hueco = L(if autor == none { z.alto } else { z.alto-autor })
    let parrafo(c) = block(width: L(z.ancho), text(size: c, weight: 400, fill: suave, par(leading: 0.5em, justify: false, frase)))
    let c = ajustar-alto(parrafo, L(cuerpo), hueco, minimo: L(5 * k), paso: L(0.2 * k))
    place(top + left, dx: X(z.x), dy: Y(z.y), parrafo(c))
  }

  if autor != none {
    let z = zona.autor
    place(top + left, dx: X(z.x), dy: Y(z.y),
      text(size: L(7 * k), weight: 700, tracking: 0.12em, fill: tinta, upper(autor)))
  }
}

// ── bloque-texto ────────────────────────────────────────────
// La misma capa (título, párrafo, pila), pero para un preset cuyo arte no
// deja una franja fija: en vez de cajas a ojo recibe el arte como
// `obstaculos` (ver _huecos.typ) y una lista de `planes`, y cada pieza toma
// la mayor caja libre a partir de su ancla. Gana el primer plan en el que
// todo cabe con el párrafo a `minimo` o más; si ninguno, error (no se pisa
// el arte ni se baja del mínimo legible).
//   planes      lista de (pila: …, columna: …), en unidades de la lámina:
//                 pila     (x, y, ancla)  x = borde derecho; ancla "arriba"
//                          (y = arriba) o "centro" (y = el centro); none =
//                          este plan no lleva pila
//                 columna  (x, y, alinear, ancla, hasta)  título encima del
//                          párrafo. x = el borde fijo ("izquierda": el de la
//                          izquierda), y = arriba ("arriba") o abajo ("abajo")
//                          del bloque; el ancho crece desde x hasta `hasta`
//                          mientras haya sitio
//   obstaculos  lo que el texto no puede tocar (cada uno con su aire)
//   limites     (x0, y0, x1, y1): la caja dentro de la que va todo
//   cuerpo, minimo   tamaño máximo y mínimo del párrafo (unidades)
//   junta       aire entre la pila y la columna
//   guias       true: dibuja los obstáculos y las cajas (para depurar)
//   quien       nombre del preset, para el mensaje de error
//   pila-min    lo más que puede achicarse la pila (fracción de su tamaño)
//   probar      true: no dibuja ni da error; devuelve si el texto cabe (para
//               que el preset pruebe varias escalas del arte). Así, sin el
//               `context` de `bloque-texto`: se llama dentro de uno.
#let resolver-bloque(
  L, X, Y,
  tinta, suave,
  planes, obstaculos, limites,
  k: 1,
  etiqueta: none,
  frase: none,
  remate: none,
  cuerpo: 7.4,
  minimo: 5,
  junta: 24,
  fuente: auto,
  guias: false,
  quien: "bloque-texto",
  pila-min: 0.45,
  probar: false,
) = {
  // (`measure` no ve los `set` de este mismo bloque: cada texto lleva su
  // tipografía y su espaciado explícitos, para medir lo mismo que se dibuja)
  let fu = if fuente != auto { (font: fuente) } else { (:) }
  let u = L(1)
  let cap-h(cap, f: 1, ..args, texto) = _cap-h(L, cap, f: f, tracking: 0em, ..fu, ..args, texto)

  // medidas naturales (f = 1), en unidades de la lámina. Si el mínimo legible
  // sube el párrafo por encima de `cuerpo` (un formato en el que la lámina
  // queda chica), el título sube con él para no perder la jerarquía (la
  // pila no: ya es mucho más grande que el párrafo, y quitaría el ancho).
  let cmax = calc.max(cuerpo, minimo)
  let g = calc.sqrt(cmax / cuerpo)
  let ta = (weight: 800, fill: tinta)
  let tcap = 13.7 * k * g
  let tw = if etiqueta == none { 0 } else { measure(cap-h(tcap, ..ta, upper(etiqueta))).width / u }
  // la palabra más ancha del título: hasta ahí puede partirse en líneas
  let tplano = if etiqueta == none { none } else if type(etiqueta) == str { etiqueta } else if etiqueta.has("text") { etiqueta.text } else { none }
  let tpal = if tplano == none { tw } else {
    calc.max(..tplano.split(" ").filter(x => x != "").map(x => measure(cap-h(tcap, ..ta, upper(x))).width / u))
  }
  let tlead = 0.3 // interlínea del título partido, en alturas de mayúscula
  let titulo-c(w, ft, al) = block(width: L(w), align(al,
    par(leading: L(tlead * tcap * ft), justify: false, cap-h(tcap, f: ft, ..ta, upper(etiqueta)))))
  let lineas = if remate == none { () } else { _lineas-pila(remate) }
  let (pcap, ppaso) = (18.4 * k, 23.5 * k)
  let pila-c(f) = cap-h(pcap, f: f, weight: 800, fill: tinta, lineas.join(linebreak()))
  let pw = if remate == none { 0 } else { measure(pila-c(1)).width / u }
  let ph = if remate == none { 0 } else { (lineas.len() - 1) * ppaso + pcap }
  let parrafo(c, w, al) = block(width: L(w), text(size: L(c), weight: 400, tracking: 0em, ..fu, fill: suave,
    align(al, par(leading: 0.5em, justify: false, frase))))
  let alto-par(c, w) = measure(parrafo(c, w, left)).height / u
  let sep = 0.6 // hueco título-párrafo, en alturas de mayúscula del título

  // ── la pila: la mayor escala (≤ fmax) con la que su caja está libre ──
  let poner-pila(p, obs, fmax) = {
    let caja(f) = {
      let (w, h) = (f * pw, f * ph)
      let y0 = if p.at("ancla", default: "arriba") == "centro" { p.y - h / 2 } else { p.y }
      (p.x - w, y0, p.x, y0 + h)
    }
    let fmin = pila-min
    if libre(caja(fmax), obs, limites) { return (f: fmax, caja: caja(fmax)) }
    if not libre(caja(fmin), obs, limites) { return none }
    let (a, b) = (fmin, fmax)
    for _ in range(10) {
      let m = (a + b) / 2
      if libre(caja(m), obs, limites) { a = m } else { b = m }
    }
    (f: a, caja: caja(a))
  }

  // ── el título en un ancho w: en una línea si cabe; si no, en dos (sin
  // partir palabras); si ni así, se achica (hasta un 40 %) ──
  let titulo(w, ft0) = {
    if tw * ft0 <= w { return (ft: ft0, h: tcap * ft0, w: tw * ft0, partido: false) }
    let ft = ft0
    while ft >= 0.4 {
      if tpal * ft <= w {
        let h = measure(titulo-c(w, ft, left)).height / u
        if h <= (2 + tlead) * tcap * ft + 0.5 { return (ft: ft, h: h, w: w, partido: true) }
      }
      ft = ft * 0.92
    }
    none
  }

  // ── la columna: título y párrafo con el párrafo a cuerpo `c` ──
  let poner-columna(col, obs, c, ft0) = {
    let izq = col.at("alinear", default: "izquierda") == "izquierda"
    let arriba = col.at("ancla", default: "arriba") == "arriba"
    let wlim = calc.abs(col.hasta - col.x)
    let xr(w) = if izq { (col.x, col.x + w) } else { (col.x - w, col.x) }
    // las alturas para un ancho w
    let medir(w) = {
      let t = if etiqueta == none { none } else { titulo(w, ft0) }
      if etiqueta != none and t == none { return none }
      let ht = if t == none { 0 } else { t.h }
      let hp = if frase == none { 0 } else { alto-par(c, w) }
      let gap = if t != none and frase != none { sep * tcap * t.ft } else { 0 }
      (t: t, ht: ht, hp: hp, gap: gap)
    }
    // cajas para un ancho w y unas alturas dadas
    let cajas(w, m) = {
      let h = m.ht + m.gap + m.hp
      let y0 = if arriba { col.y } else { col.y - h }
      let t = if m.t == none { none } else { let (a, b) = xr(calc.min(w, m.t.w)); (a, y0, b, y0 + m.ht) }
      let q = if frase == none { none } else { let (a, b) = xr(w); (a, y0 + m.ht + m.gap, b, y0 + h) }
      (t, q)
    }
    let vale(cs) = cs.all(x => x == none or libre(x, obs, limites))
    let wmin = if frase == none { 0 } else { 10 * c }
    let w = wlim
    for _ in range(10) {
      let m = medir(w)
      if m == none { return none }
      let cs = cajas(w, m)
      if vale(cs) {
        return (c: c, w: w, t: m.t, titulo: cs.at(0), parrafo: cs.at(1), izq: izq)
      }
      // el mayor ancho libre con estas alturas
      if not vale(cajas(wmin, m)) { return none }
      let (a, b) = (wmin, w)
      for _ in range(11) {
        let x = (a + b) / 2
        if vale(cajas(x, m)) { a = x } else { b = x }
      }
      if a >= w - 0.01 { return none }
      w = a
    }
    none
  }

  // tamaños del párrafo a probar: de `cmax` a `minimo`; luego, ya en el
  // mínimo, el título cede (hasta un 60 %) antes de rendirse
  let pruebas = ()
  let n = calc.max(1, calc.ceil((cmax - minimo) / (0.5 * k)))
  for i in range(n + 1) { pruebas.push((cmax - (cmax - minimo) * i / n, 1)) }
  if etiqueta != none and frase != none { for ft in (0.85, 0.7, 0.6) { pruebas.push((minimo, ft)) } }

  // en cada plan, la pila primero (toma su sitio) y luego la columna; si la
  // columna no cabe, la pila cede (se achica) y se vuelve a probar
  let resolver(plan) = {
    for fmax in (1, 0.8, 0.65, 0.5).filter(f => f >= pila-min) {
      let obs = obstaculos
      let pila = none
      if remate != none {
        if plan.at("pila", default: none) == none { return none }
        pila = poner-pila(plan.pila, obs, fmax)
        if pila == none { return none }
        obs = obs + (ob-caja(pila.caja, aire: junta),)
      }
      if etiqueta == none and frase == none { return (pila: pila, col: none) }
      for (c, ft0) in pruebas {
        let r = poner-columna(plan.columna, obs, c, ft0)
        if r != none { return (pila: pila, col: r) }
      }
      if remate == none or pila.f < fmax { return none }
    }
    none
  }

  let hecho = none
  for plan in planes {
    hecho = resolver(plan)
    if hecho != none { break }
  }
  if probar { return hecho != none }
  if hecho == none {
    panic(quien + ": el texto no cabe sin pisar el arte con el párrafo a " + str(calc.round(minimo * u / 1pt, digits: 1))
      + " px o más. Acorta la frase o el título, quita `remate`, usa otro formato o variante, o baja `minimo`.")
  }

  // ── dibujo ──
  if hecho.pila != none {
    let (f, caja) = (hecho.pila.f, hecho.pila.caja)
    place(top + left, dx: X(caja.at(0) - 2), dy: Y(caja.at(1)),
      block(width: L(caja.at(2) - caja.at(0) + 2), align(right,
        par(leading: L((ppaso - pcap) * f), justify: false, pila-c(f)))))
  }
  let col = hecho.col
  if col != none {
    if col.titulo != none {
      let t = col.titulo
      place(top + left, dx: X(if col.izq { t.at(0) } else { t.at(0) - 2 }), dy: Y(t.at(1)),
        titulo-c(t.at(2) - t.at(0) + 2, col.t.ft, if col.izq { left } else { right }))
    }
    if col.parrafo != none {
      let q = col.parrafo
      place(top + left, dx: X(q.at(0)), dy: Y(q.at(1)), parrafo(col.c, col.w, if col.izq { left } else { right }))
    }
  }
  if guias {
    dibujar-obstaculos(obstaculos, X, Y, L)
    let cajas = (if hecho.pila != none { hecho.pila.caja },) + if col != none { (col.titulo, col.parrafo) } else { () }
    dibujar-obstaculos(cajas.filter(x => x != none).map(x => ob-caja(x)), X, Y, L, color: blue)
  }
}

// La capa, dibujada (con su propio `context`): ver `resolver-bloque`.
#let bloque-texto(..args) = context resolver-bloque(..args)
