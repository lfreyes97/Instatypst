// ─────────────────────────────────────────────────────────────
//  curvas.typ — fondos de curvas CONTINUOS entre diapositivas
//
//  Un carrusel (o un deck) se lee como una sola tira: la curva que sale
//  por el borde derecho de una diapositiva tiene que entrar por el
//  izquierdo de la siguiente. Para eso cada fondo es un CAMPO que vive
//  en un espacio de N diapositivas de ancho (el panorama) y cada
//  diapositiva dibuja solo su ventana de ese espacio:
//
//    #let c = curvas.campo("topo", diapositivas: 5, formato: (1080, 1080))
//    #curvas.ventana(c, 2)    // fondo de la 3.ª, continuo con la 2.ª y la 4.ª
//    #curvas.panorama(c)      // el campo entero, de una (banner, verificación)
//
//  Cada curva es una función determinista de las coordenadas globales
//  (con `semilla`), y cada ventana genera los MISMOS puntos que el
//  panorama en su franja (muestreo sobre una grilla global, no relativa
//  a la ventana): por eso los bordes coinciden exactamente.
//
//  Dibujo nativo (curve/polygon), no SVG: el SVG armado con str()
//  escribe los negativos con «−» (U+2212) y el visor descarta esas
//  curvas (ver 7c548a8).
//
//  Familias (tipo):
//    "topo"       curvas de nivel de un terreno con varias cumbres
//    "ondas"      ondas horizontales que recorren el panorama
//    "flujo"      líneas de corriente sobre un campo suave
//    "paralelas"  haz de paralelas que se deforma a lo largo del recorrido
//    "cinta"      una sola cinta gruesa que atraviesa todo
//    "orbitas"    órbitas elípticas alrededor de centros repartidos
//
//  Opciones comunes de campo(): color, grosor, opacidad, semilla. Las
//  propias de cada familia van por nombre (ver cada `_tipo` abajo).
// ─────────────────────────────────────────────────────────────

// ── azar determinista ──
// Número en [0, 1) que solo depende de (semilla, n).
#let _r(s, n) = calc.fract(calc.abs(calc.sin(s * 127.1 + n * 311.7) * 43758.5453))

// ── trazos ──
// Una polilínea (lista de (x, y) en pt, sin unidad) corrida en -x0.
// suave: true = curva de Catmull-Rom por los mismos puntos (cada tramo
// depende solo de sus 4 puntos vecinos, así que dos cortes distintos de
// la misma lista dan tramos idénticos lejos de sus extremos).
#let _polilinea(pts, x0, trazo, cerrar: false, relleno: none, suave: false) = {
  let n = pts.len()
  if n < 2 { return none }
  let P(p) = ((p.at(0) - x0) * 1pt, p.at(1) * 1pt)
  let segs = (curve.move(P(pts.at(0))),)
  if suave and n > 2 {
    let q(i) = if cerrar { pts.at(calc.rem-euclid(i, n)) } else { pts.at(calc.clamp(i, 0, n - 1)) }
    let ultimo = if cerrar { n } else { n - 1 }
    for i in range(ultimo) {
      let (a, b, c, d) = (q(i - 1), q(i), q(i + 1), q(i + 2))
      segs.push(curve.cubic(
        P((b.at(0) + (c.at(0) - a.at(0)) / 6, b.at(1) + (c.at(1) - a.at(1)) / 6)),
        P((c.at(0) - (d.at(0) - b.at(0)) / 6, c.at(1) - (d.at(1) - b.at(1)) / 6)),
        P(c),
      ))
    }
  } else {
    segs += pts.slice(1).map(p => curve.line(P(p)))
  }
  if cerrar { segs.push(curve.close(mode: "straight")) }
  place(top + left, curve(stroke: trazo, fill: relleno, ..segs))
}

// Como _tramos, para un lazo cerrado (sin repetir el primer punto al
// final): si todo vale, devuelve (( pts ), true); si no, empieza a
// cortar desde un punto que no vale, así ningún tramo se parte en el
// índice 0 sin motivo.
#let _tramos-lazo(pts, vale) = {
  let marcas = pts.map(vale)
  if marcas.all(v => v) { return ((pts,), true) }
  let i0 = marcas.position(v => not v)
  let rot = pts.slice(i0) + pts.slice(0, i0)
  let out = ()
  let actual = ()
  for p in rot {
    if vale(p) { actual.push(p) } else {
      if actual.len() > 1 { out.push(actual) }
      actual = ()
    }
  }
  if actual.len() > 1 { out.push(actual) }
  (out, false)
}

// Corta una lista de puntos en tramos donde `vale(p)` es verdadero.
#let _tramos(pts, vale) = {
  let out = ()
  let actual = ()
  for p in pts {
    if vale(p) { actual.push(p) } else {
      if actual.len() > 1 { out.push(actual) }
      actual = ()
    }
  }
  if actual.len() > 1 { out.push(actual) }
  out
}

// Muestras de una grilla GLOBAL de paso `h` que cubren [a, b]: la misma
// x cae en la misma muestra en cualquier ventana.
#let _grilla(a, b, h) = range(int(calc.floor(a / h)), int(calc.ceil(b / h)) + 1).map(k => k * h)

#let _tau = 2 * calc.pi

// ═════════════════════════════════════════════════════════════
//  1. TOPO — curvas de nivel de un terreno de varias cumbres
// ═════════════════════════════════════════════════════════════
// El terreno es el máximo de unos conos ondulados, uno por cumbre
// (la forma de src/escalera.typ: elipse alargada 1,18 en vertical, con
// una ondulación que crece hacia afuera). La curva de nivel L de una
// cumbre es su anillo de radio (altura − L), y se dibuja solo donde esa
// cumbre manda; en la frontera, el anillo del mismo nivel de la vecina
// tiene el mismo alto, así que las dos se juntan en una sola curva, como
// en un mapa de verdad (sin anillos montados).
//   cumbres   auto = una por diapositiva, más una
//   sep       distancia entre curvas (pt)
//   maestra   cada cuántas curvas una más gruesa
#let _topo-cumbres(c) = {
  let s = c.semilla
  let o = c.op
  let n = o.at("cumbres", default: auto)
  let n = if n == auto { c.n + 1 } else { n }
  let sep = o.at("sep", default: 38)
  range(n).map(j => (
    x: (j + 0.5 + (_r(s, j) - 0.5) * 0.7) * c.P / n,
    y: c.H * (0.22 + 0.56 * _r(s, j + 100)),
    alto: sep * (22 + 14 * _r(s, j + 200)),
    e: 1.05 + 0.25 * _r(s, j + 300),
    f: (_r(s, j + 400) * _tau, _r(s, j + 500) * _tau, _r(s, j + 600) * _tau),
  ))
}

#let _topo(c, x0, x1, m) = {
  let o = c.op
  let sep = o.at("sep", default: 38)
  let maestra = o.at("maestra", default: 5)
  let cs = _topo-cumbres(c)
  // ondulación (factor de radio) de la cumbre q a ángulo a y radio r
  let ond(q, a, r) = {
    let k = r / sep
    let amp = calc.min(0.24, 0.10 + k * 0.006)
    1 + amp * (0.5 * calc.sin(2 * a + q.f.at(0) + k * 0.06) + 0.32 * calc.sin(3 * a + q.f.at(1) - k * 0.05) + 0.18 * calc.sin(5 * a + q.f.at(2) + k * 0.09))
  }
  // altura del terreno de la cumbre q en (x, y)
  let altura(q, x, y) = {
    let dx = x - q.x
    let dy = (y - q.y) / q.e
    let r0 = calc.sqrt(dx * dx + dy * dy)
    let a = calc.atan2(dx, dy) / 1rad
    let d = r0 / ond(q, a, r0)
    let d = r0 / ond(q, a, d) // un paso de punto fijo
    q.alto - d
  }
  let cima = calc.max(..cs.map(q => q.alto))
  // niveles hasta bien por debajo de 0: lejos de toda cumbre el terreno
  // sigue bajando y también lleva curvas (si no, quedan franjas vacías)
  let n-niveles = int(calc.ceil((cima + 1.2 * calc.max(c.W, c.H)) / sep))

  // ── Quién puede mandar dónde: se acota UNA vez por diapositiva ──
  // Tabla de celdas de G pt sobre la ventana y su margen. La ondulación
  // está entre 0,76 y 1,24, así que en una celda la cumbre n vale como
  // mucho alto − (distancia mínima)/1,24 y como poco alto − (distancia
  // máxima)/0,76. Candidatas de la celda: las que pueden alcanzar el
  // mejor «como poco». Un punto de anillo solo se compara contra las
  // candidatas de su celda; si su cumbre es la única, vale sin cuentas.
  let G = 40
  let (xa, ya) = (x0 - m, -m)
  let (gx, gy) = (int(calc.ceil((x1 - x0 + 2 * m) / G)), int(calc.ceil((c.H + 2 * m) / G)))
  let celdas = range(gy).map(cj => range(gx).map(ci => {
    let (cx0, cy0) = (xa + ci * G, ya + cj * G)
    let (cx1, cy1) = (cx0 + G, cy0 + G)
    let techos = ()
    let piso = none
    for q in cs {
      let dxmin = calc.max(0, cx0 - q.x, q.x - cx1)
      let dymin = calc.max(0, cy0 - q.y, q.y - cy1) / q.e
      let dxmax = calc.max(calc.abs(cx0 - q.x), calc.abs(cx1 - q.x))
      let dymax = calc.max(calc.abs(cy0 - q.y), calc.abs(cy1 - q.y)) / q.e
      techos.push(q.alto - calc.sqrt(dxmin * dxmin + dymin * dymin) / 1.24)
      let peor = q.alto - calc.sqrt(dxmax * dxmax + dymax * dymax) / 0.76
      if piso == none or peor > piso { piso = peor }
    }
    range(cs.len()).filter(n => techos.at(n) > piso - 0.5)
  }))

  // ── Qué arco de cada anillo puede caer en la ventana ──
  // La ondulación solo estira el radio: el punto de parámetro a cae en
  // la dirección a desde la cumbre (con y dividido por e). Así que la
  // ventana, vista desde la cumbre, ocupa un arco fijo —el de sus cuatro
  // esquinas— y una banda de distancias; se calcula una vez por cumbre y
  // cada anillo genera solo los puntos de ese arco (los mismos ángulos
  // de siempre: el resultado no cambia).
  let (rxa, rxb, rya, ryb) = (x0 - m, x1 + m, -m, c.H + m)
  let vistas = cs.map(q => {
    let esq = ((rxa, rya), (rxb, rya), (rxb, ryb), (rxa, ryb)).map(((x, y)) => (x - q.x, (y - q.y) / q.e))
    let dmax = calc.max(..esq.map(((u, v)) => calc.sqrt(u * u + v * v)))
    let du = calc.max(0, rxa - q.x, q.x - rxb)
    let dv = calc.max(0, rya - q.y, q.y - ryb) / q.e
    let adentro = du == 0 and dv == 0
    // arco mínimo que cubre las cuatro esquinas: el complemento del
    // mayor hueco entre sus ángulos
    let arco = if adentro { none } else {
      let ang = esq.map(((u, v)) => calc.rem-euclid(calc.atan2(u, v) / 1rad, _tau)).sorted()
      let huecos = range(4).map(n => calc.rem-euclid(ang.at(calc.rem(n + 1, 4)) - ang.at(n), _tau))
      let g = huecos.position(h => h == calc.max(..huecos))
      (ang.at(calc.rem(g + 1, 4)), _tau - huecos.at(g)) // (inicio, largo)
    }
    (dmin: calc.sqrt(du * du + dv * dv), dmax: dmax, arco: arco)
  })

  let out = ()
  for (j, q) in cs.enumerate() {
    let vista = vistas.at(j)
    for k in range(1, n-niveles + 1) {
      let L = cima - k * sep
      let r = q.alto - L
      if r <= sep * 0.5 { continue }
      // el anillo (entre 0,76 r y 1,24 r) pasa entero por fuera o por
      // dentro de la ventana: ni se recorre
      if r * 1.24 < vista.dmin or r * 0.76 > vista.dmax { continue }
      let pasos = calc.min(360, calc.max(28, int(r / 6)))
      // índices del arco visible (con uno de holgura a cada lado)
      let indices = if vista.arco == none { range(pasos) } else {
        let (a0, largo) = vista.arco
        let i0 = int(calc.floor(a0 / _tau * pasos)) - 1
        let i1 = int(calc.ceil((a0 + largo) / _tau * pasos)) + 1
        if i1 - i0 + 1 >= pasos { range(pasos) } else { range(i0, i1 + 1).map(i => calc.rem-euclid(i, pasos)) }
      }
      let completo = indices.len() == pasos
      // descarte barato: si ni el radio mínimo ni el máximo caen en la
      // franja, el punto tampoco (queda `none`, que corta el tramo)
      let pts = indices.map(i => {
        let a = _tau * i / pasos
        let (ca, sa) = (calc.cos(a), calc.sin(a))
        let xs = (q.x + r * 0.76 * ca, q.x + r * 1.24 * ca)
        let ys = (q.y + r * 0.76 * q.e * sa, q.y + r * 1.24 * q.e * sa)
        if calc.max(..xs) < x0 - m or calc.min(..xs) > x1 + m or calc.max(..ys) < -m or calc.min(..ys) > c.H + m { return none }
        let f = ond(q, a, r)
        (q.x + r * f * ca, q.y + r * f * q.e * sa)
      })
      let vale(p) = {
        if p == none { return false }
        if p.at(0) < x0 - m or p.at(0) > x1 + m { return false }
        if p.at(1) < -m or p.at(1) > c.H + m { return false }
        let ci = calc.clamp(int((p.at(0) - xa) / G), 0, gx - 1)
        let cj = calc.clamp(int((p.at(1) - ya) / G), 0, gy - 1)
        let cand = celdas.at(cj).at(ci)
        if cand == (j,) { return true } // solo ella puede mandar acá
        if j not in cand { return false } // otra la tapa en toda la celda
        let mio = altura(q, p.at(0), p.at(1))
        cand.all(i => {
          if i == j { return true }
          let otra = cs.at(i)
          // cota sin senos antes de la cuenta completa
          let dx = p.at(0) - otra.x
          let dy = (p.at(1) - otra.y) / otra.e
          if otra.alto - calc.sqrt(dx * dx + dy * dy) / 1.24 <= mio + 0.5 { return true }
          altura(otra, p.at(0), p.at(1)) <= mio + 0.5
        })
      }
      let gruesa = calc.rem(k, maestra) == 0
      let trazo = (
        paint: c.color.transparentize(100% - c.opacidad * (if gruesa { 1.6 } else { 1 })),
        thickness: c.grosor * (if gruesa { 2 } else { 1 }),
        join: "round",
      )
      let (ts, cerrado) = if completo { _tramos-lazo(pts, vale) } else { (_tramos(pts, vale), false) }
      for t in ts { out.push(_polilinea(t, x0, trazo, cerrar: cerrado, suave: true)) }
    }
  }
  out.join()
}


// ═════════════════════════════════════════════════════════════
//  2. ONDAS — ondas horizontales a lo largo del panorama
// ═════════════════════════════════════════════════════════════
//   lineas     cuántas ondas en el alto
//   amplitud   fracción del alto
//   largo      largo de onda, en diapositivas
//   relleno    true = bandas rellenas alternadas entre ondas
#let _ondas(c, x0, x1, m) = {
  let o = c.op
  let s = c.semilla
  let n = o.at("lineas", default: 13)
  let A = c.H * o.at("amplitud", default: 0.11)
  let lam = c.W * o.at("largo", default: 1.5)
  let rell = o.at("relleno", default: false)
  let f1 = _r(s, 1) * _tau
  let f2 = _r(s, 2) * _tau
  let xs = _grilla(x0 - m, x1 + m, 8)
  let onda(k) = {
    let base = c.H * (k + 0.5) / n
    xs.map(x => (x, base
      + A * 0.8 * calc.sin(_tau * x / lam + f1 + k * 0.3)
      + A * 0.3 * calc.sin(_tau * x / (lam * 0.37) + f2 - k * 0.45)
      + A * 0.6 * calc.sin(_tau * x / (lam * 3.1) + k * 0.2)))
  }
  let ondas = range(-1, n + 1).map(onda)
  let trazo = (paint: c.color.transparentize(100% - c.opacidad), thickness: c.grosor, join: "round")
  let out = ()
  if rell {
    for k in range(0, ondas.len() - 1, step: 2) {
      let banda = ondas.at(k) + ondas.at(k + 1).rev()
      out.push(_polilinea(banda, x0, none, cerrar: true, relleno: c.color.transparentize(100% - c.opacidad * 0.35)))
    }
  }
  for w in ondas { out.push(_polilinea(w, x0, trazo)) }
  out.join()
}

// ═════════════════════════════════════════════════════════════
//  3. FLUJO — líneas de corriente sobre un campo suave
// ═════════════════════════════════════════════════════════════
// La dirección en cada punto sale de una suma de senos (con semilla),
// alrededor de una deriva horizontal: el flujo corre a lo largo del
// carrusel. Cada línea nace en una semilla de una grilla global con
// jitter y se integra hacia adelante y hacia atrás.
//   separacion   distancia entre semillas (pt)
//   pasos        pasos de integración por lado
//   escala       tamaño de los remolinos (pt)
#let _flujo(c, x0, x1, m) = {
  let o = c.op
  let s = c.semilla
  let sepa = o.at("separacion", default: 92)
  let pasos = o.at("pasos", default: 34)
  let esc = o.at("escala", default: 520)
  let h = 7
  let L = pasos * h
  let fr = range(4).map(i => (
    fx: (0.6 + _r(s, 10 + i)) / esc * _tau / 2,
    fy: (0.6 + _r(s, 20 + i)) / esc * _tau / 2 * (if calc.rem(i, 2) == 0 { 1 } else { -1 }),
    fase: _r(s, 30 + i) * _tau,
    peso: 1 / (i + 1),
  ))
  let angulo(x, y) = 0.95 * fr.map(q => q.peso * calc.sin(x * q.fx + y * q.fy + q.fase)).sum()
  let integrar(x, y, dir) = {
    let pts = ()
    let (px, py) = (x, y)
    for _ in range(pasos) {
      let a = angulo(px, py)
      px += dir * h * calc.cos(a)
      py += dir * h * calc.sin(a)
      pts.push((px, py))
    }
    pts
  }
  let out = ()
  let ix0 = int(calc.floor((x0 - m - L) / sepa))
  let ix1 = int(calc.ceil((x1 + m + L) / sepa))
  let iy1 = int(calc.ceil(c.H / sepa))
  for ix in range(ix0, ix1 + 1) {
    for iy in range(-1, iy1 + 1) {
      let id = ix * 1009 + iy
      let x = (ix + _r(s, id) * 0.9) * sepa
      let y = (iy + _r(s, id + 7) * 0.9) * sepa
      let pts = integrar(x, y, -1).rev() + ((x, y),) + integrar(x, y, 1)
      let xs = pts.map(p => p.at(0))
      if calc.max(..xs) < x0 - m or calc.min(..xs) > x1 + m { continue }
      let op = c.opacidad * (0.45 + 0.55 * _r(s, id + 13))
      let trazo = (paint: c.color.transparentize(100% - op), thickness: c.grosor, cap: "round", join: "round")
      out.push(_polilinea(pts, x0, trazo))
    }
  }
  out.join()
}

// ═════════════════════════════════════════════════════════════
//  4. PARALELAS — un haz que se deforma a lo largo del recorrido
// ═════════════════════════════════════════════════════════════
// Las líneas no se cruzan: el desplazamiento de cada una es el de su
// vecina más una fracción, así el haz se abre y se cierra como una tela.
//   lineas     cuántas
//   amplitud   fracción del alto
//   largo      largo de onda, en diapositivas
#let _paralelas(c, x0, x1, m) = {
  let o = c.op
  let s = c.semilla
  let n = o.at("lineas", default: 24)
  let A = c.H * o.at("amplitud", default: 0.2)
  let lam = c.W * o.at("largo", default: 1.8)
  let (f1, f2, f3) = (_r(s, 1) * _tau, _r(s, 2) * _tau, _r(s, 3) * _tau)
  let xs = _grilla(x0 - m, x1 + m, 8)
  let trazo = (paint: c.color.transparentize(100% - c.opacidad), thickness: c.grosor, join: "round")
  let out = ()
  for k in range(n) {
    let t = k / (n - 1) // 0 arriba, 1 abajo
    let base = c.H * (-0.15 + 1.3 * t)
    let pts = xs.map(x => {
      // la deformación cambia de forma de arriba a abajo (abre y cierra)
      let d = A * (calc.sin(_tau * x / lam + f1) * (0.35 + 0.9 * calc.cos(_tau * t * 0.9 + f2 + 0.6 * calc.sin(_tau * x / (lam * 1.7))))
        + 0.45 * calc.sin(_tau * x / (lam * 0.53) + f3 + 2.2 * t)
        + 0.6 * calc.sin(_tau * x / (lam * 2.9) + t))
      (x, base + d)
    })
    out.push(_polilinea(pts, x0, trazo))
  }
  out.join()
}

// ═════════════════════════════════════════════════════════════
//  5. CINTA — una sola cinta que atraviesa todas las diapositivas
// ═════════════════════════════════════════════════════════════
// Curva paramétrica: avanza en x y ondula en y; con `bucles` traza
// rizos (x retrocede un rato). El trazo es OPACO a propósito: un mismo
// recorrido cortado en tramos por la ventana, con transparencia, se
// sumaría dos veces donde se cruza consigo mismo.
//   ancho     grosor de la cinta (fracción del alto)
//   bucles    true = con rizos
//   hueco     un color = la cinta queda hueca (dos bordes) con ese
//             color adentro (el del fondo)
//   largo     largo de onda, en diapositivas
#let _cinta(c, x0, x1, m) = {
  let o = c.op
  let s = c.semilla
  let ancho = c.H * o.at("ancho", default: 0.035)
  let bucles = o.at("bucles", default: false)
  let hueco = o.at("hueco", default: none)
  let lam = c.W * o.at("largo", default: 1.6)
  let (f1, f2) = (_r(s, 1) * _tau, _r(s, 2) * _tau)
  let rizo = if bucles { lam / _tau * 1.7 } else { 0 }
  let ts = _grilla(-c.W * 0.5, c.P + c.W * 0.5, 5)
  let pts = ts.map(t => (
    t + rizo * calc.sin(_tau * t / lam * 1.5 + f2),
    c.H * (0.5 + 0.27 * calc.sin(_tau * t / lam + f1) + 0.09 * calc.sin(_tau * t / (lam * 0.41) + f2)),
  ))
  let mm = m + ancho
  let vale(p) = p.at(0) >= x0 - mm and p.at(0) <= x1 + mm
  // Primero todos los bordes y después todos los huecos: así un rizo
  // partido en dos tramos por la ventana se cruza igual que el recorrido
  // entero del panorama (el hueco tapa los dos bordes en el cruce).
  let tramos = _tramos(pts, vale)
  let out = tramos.map(t => _polilinea(t, x0, (paint: c.color, thickness: ancho * 1pt, cap: "round", join: "round")))
  if hueco != none {
    out += tramos.map(t => _polilinea(t, x0, (paint: hueco, thickness: ancho * 1pt - 2 * c.grosor, cap: "round", join: "round")))
  }
  out.join()
}

// ═════════════════════════════════════════════════════════════
//  6. ÓRBITAS — elipses alrededor de centros repartidos
// ═════════════════════════════════════════════════════════════
//   centros   auto = uno por diapositiva
//   anillos   órbitas por centro
//   astros    true = un disco sobre algunas órbitas
#let _orbitas(c, x0, x1, m) = {
  let o = c.op
  let s = c.semilla
  let nc = o.at("centros", default: auto)
  let nc = if nc == auto { c.n } else { nc }
  let na = o.at("anillos", default: 11)
  let astros = o.at("astros", default: true)
  let trazo = (paint: c.color.transparentize(100% - c.opacidad), thickness: c.grosor, join: "round")
  let out = ()
  for j in range(nc) {
    let cx = (j + 0.5 + (_r(s, j) - 0.5) * 0.6) * c.P / nc
    let cy = c.H * (0.35 + 0.3 * _r(s, j + 50))
    let giro = (_r(s, j + 60) - 0.5) * 0.9
    let ex = 0.42 + 0.25 * _r(s, j + 70)
    for k in range(na) {
      let r = c.H * 0.05 * calc.pow(1.32, k)
      if cx + r < x0 - m or cx - r > x1 + m { continue }
      let pasos = calc.min(160, calc.max(32, int(r / 10)))
      let P(a) = {
        let (u, v) = (r * calc.cos(a), r * ex * calc.sin(a))
        (cx + u * calc.cos(giro) - v * calc.sin(giro), cy + u * calc.sin(giro) + v * calc.cos(giro))
      }
      let pts = range(pasos).map(i => P(_tau * i / pasos))
      out.push(_polilinea(pts, x0, trazo, cerrar: true, suave: true))
      if astros and _r(s, j * 31 + k) > 0.55 {
        let p = P(_r(s, j * 37 + k) * _tau)
        let rad = c.grosor * (3 + 4 * _r(s, j * 41 + k))
        out.push(place(top + left, dx: (p.at(0) - x0) * 1pt - rad, dy: p.at(1) * 1pt - rad,
          circle(radius: rad, fill: c.color.transparentize(100% - calc.min(100%, c.opacidad * 2.2)))))
      }
    }
  }
  out.join()
}

#let _familias = (
  topo: (dibujo: _topo, grosor: 1.1, opacidad: 32%),
  ondas: (dibujo: _ondas, grosor: 1.3, opacidad: 34%),
  flujo: (dibujo: _flujo, grosor: 1, opacidad: 34%),
  paralelas: (dibujo: _paralelas, grosor: 1.1, opacidad: 34%),
  cinta: (dibujo: _cinta, grosor: 2, opacidad: 100%),
  orbitas: (dibujo: _orbitas, grosor: 1.2, opacidad: 34%),
)

// ── API ─────────────────────────────────────────────────────

// Especificación de un campo (no dibuja nada). `formato` es el de UNA
// diapositiva, en px como `sizes`. Las opciones propias de cada familia
// van por nombre (cumbres:, sep:, lineas:, bucles:…).
#let campo(
  tipo,
  diapositivas: 5,
  formato: (1080, 1080),
  semilla: 1,
  color: rgb("#3d4b57"),
  grosor: auto,
  opacidad: auto,
  ..opciones,
) = {
  assert(tipo in _familias, message: "curvas.campo: tipo desconocido " + repr(tipo) + "; hay " + _familias.keys().join(", "))
  let fam = _familias.at(tipo)
  let (W, H) = (formato.at(0), formato.at(1))
  (
    tipo: tipo,
    n: diapositivas,
    W: W,
    H: H,
    P: W * diapositivas,
    semilla: semilla,
    color: color,
    grosor: if grosor == auto { fam.grosor * 1pt } else { grosor },
    opacidad: if opacidad == auto { fam.opacidad } else { opacidad },
    op: opciones.named(),
  )
}

// Margen extra alrededor de la franja: lo bastante para que los tramos
// cortados terminen fuera de lo visible (sus remates quedan recortados).
#let _margen = 120

// Fondo de la diapositiva `i` (desde 0), a lienzo completo y recortado.
#let ventana(c, i) = {
  let x0 = i * c.W
  let dibujo = _familias.at(c.tipo).dibujo
  place(top + left, box(width: c.W * 1pt, height: c.H * 1pt, clip: true,
    dibujo(c, x0, x0 + c.W, _margen)))
}

// El campo entero, de una: N diapositivas de ancho.
#let panorama(c) = {
  let dibujo = _familias.at(c.tipo).dibujo
  box(width: c.P * 1pt, height: c.H * 1pt, clip: true, dibujo(c, 0, c.P, _margen))
}

#let tipos = _familias.keys()
