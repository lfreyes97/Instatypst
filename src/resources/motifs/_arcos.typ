// ─────────────────────────────────────────────────────────────
//  carteles/_arcos.typ — líneas concéntricas: arcos y rieles
//
//  El motivo de `carteles.mosaico`: N líneas paralelas, separadas un
//  `paso`, que recorren un arco. Con un arco de menos de 360° y sin colas
//  sale una «C»; con medio círculo y dos colas rectas, una «U» (un riel).
//  Cada línea es un trazo nativo (`curve`) de extremos planos, no un
//  contorno: el grosor es un parámetro y se escala sin deformarse.
//
//  Ángulos en pantalla: se miden desde la derecha, en sentido horario
//  (0° = derecha, 90° = abajo, 180° = izquierda, 270° = arriba).
//
//  Privado de `carteles/`: lo usan los presets, no es API pública. Si otro
//  módulo lo necesita, se promueve entonces.
// ─────────────────────────────────────────────────────────────

// Punto del círculo de centro `c` y radio `r` en el ángulo `a`.
#let _punto(c, r, a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))

// Tramos de Bézier cúbica (de a lo sumo 90° cada uno) para el arco de
// `a0` a `a1` (horario si a1 > a0). Devuelve una lista de `curve.cubic`.
#let _arco(c, r, a0, a1) = {
  let total = a1 - a0
  let n = calc.max(1, calc.ceil(calc.abs(total / 90deg)))
  let d = total / n
  let k = 4 / 3 * calc.tan(d / 4) * r
  let tramos = ()
  for i in range(n) {
    let t0 = a0 + i * d
    let t1 = t0 + d
    let p0 = _punto(c, r, t0)
    let p3 = _punto(c, r, t1)
    // tangente en sentido horario: (-sin, cos)
    let p1 = (p0.at(0) - k * calc.sin(t0), p0.at(1) + k * calc.cos(t0))
    let p2 = (p3.at(0) + k * calc.sin(t1), p3.at(1) - k * calc.cos(t1))
    tramos.push(curve.cubic(p1, p2, p3))
  }
  tramos
}

// ── arcos ───────────────────────────────────────────────────
//   centro   (x, y) del centro de los arcos, en pt desde la esquina de
//            arriba a la izquierda del contenedor
//   radio    radio de la línea INTERIOR (eje del trazo)
//   lineas   cuántas líneas; la i-ésima tiene radio `radio + i * paso`
//   paso     separación entre líneas (de eje a eje)
//   grosor   grosor del trazo
//   desde, hasta   ángulos del arco (horario, de `desde` a `hasta`)
//   eje      atajo para una «U»: ángulo hacia el que apuntan los dos
//            brazos. Fija `desde = eje + 90°` y `hasta = eje + 270°`
//            (medio círculo del lado contrario al eje) y gana sobre
//            `desde`/`hasta`.
//   cola     largo de la parte recta al final de cada brazo, medido desde
//            el diámetro donde termina el arco: un largo para los dos, o
//            (al inicio, al final). Todas las líneas terminan en el mismo
//            corte, perpendicular al brazo. Un largo enorme sale por el
//            borde de la página, que lo recorta.
//   color    color del trazo
//
// Dibuja con `place(top + left, …)`: úsalo dentro de una página o de un
// contenedor cuya esquina de arriba a la izquierda sea el origen de `centro`.
#let arcos(
  centro,
  radio,
  lineas: 10,
  paso: 20pt,
  grosor: 7pt,
  desde: 0deg,
  hasta: 360deg,
  eje: none,
  cola: (0pt, 0pt),
  color: black,
) = {
  let (a0, a1) = if eje == none { (desde, hasta) } else { (eje + 90deg, eje + 270deg) }
  let (c0, c1) = if type(cola) == array { cola } else { (cola, cola) }
  let trazo = (paint: color, thickness: grosor, cap: "butt")
  for i in range(lineas) {
    let r = radio + i * paso
    let p0 = _punto(centro, r, a0)
    let p1 = _punto(centro, r, a1)
    // el brazo del inicio sigue la tangente al revés; el del final, al derecho
    let ini = (p0.at(0) + c0 * calc.sin(a0), p0.at(1) - c0 * calc.cos(a0))
    let fin = (p1.at(0) - c1 * calc.sin(a1), p1.at(1) + c1 * calc.cos(a1))
    let tramos = ()
    if c0 > 0pt { tramos += (curve.move(ini), curve.line(p0)) } else { tramos += (curve.move(p0),) }
    tramos += _arco(centro, r, a0, a1)
    if c1 > 0pt { tramos.push(curve.line(fin)) }
    place(top + left, curve(stroke: trazo, ..tramos))
  }
}

// ── contorno-arcos ──────────────────────────────────────────
// La zona que ocupan unos `arcos` (con los mismos parámetros, pero en
// números, no en pt), como una lista de cuadriláteros convexos que la
// cubren entera: el anillo de las líneas en tramos de a lo sumo `tramo`
// grados (con el lado de fuera tangente al arco exterior, así que no queda
// nada fuera) y un rectángulo por cada cola. Sirve para saber dónde NO
// puede ir el texto; no dibuja nada.
#let contorno-arcos(
  centro, radio,
  lineas: 10, paso: 20, grosor: 7,
  desde: 0deg, hasta: 360deg, eje: none, cola: (0, 0),
  tramo: 10deg,
) = {
  let (a0, a1) = if eje == none { (desde, hasta) } else { (eje + 90deg, eje + 270deg) }
  let (c0, c1) = if type(cola) == array { cola } else { (cola, cola) }
  let r0 = radio - grosor / 2
  let r1 = radio + (lineas - 1) * paso + grosor / 2
  let n = calc.max(1, calc.ceil(calc.abs((a1 - a0) / tramo)))
  let d = (a1 - a0) / n
  let fuera = r1 / calc.cos(d / 2)
  let piezas = ()
  for i in range(n) {
    let t0 = a0 + i * d
    let t1 = t0 + d
    piezas.push((_punto(centro, r0, t0), _punto(centro, fuera, t0), _punto(centro, fuera, t1), _punto(centro, r0, t1)))
  }
  // las colas: del diámetro donde acaba el arco, a lo largo del brazo
  let brazo(a, largo, signo) = {
    let t = (signo * calc.sin(a), -signo * calc.cos(a))
    let (p, q) = (_punto(centro, r0, a), _punto(centro, r1, a))
    let mas(v) = (v.at(0) + largo * t.at(0), v.at(1) + largo * t.at(1))
    (p, q, mas(q), mas(p))
  }
  if c0 > 0 { piezas.push(brazo(a0, c0, 1)) }
  if c1 > 0 { piezas.push(brazo(a1, c1, -1)) }
  piezas
}
