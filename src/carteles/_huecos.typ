// ─────────────────────────────────────────────────────────────
//  carteles/_huecos.typ — dónde NO puede ir el texto
//
//  Geometría plana en números (las unidades de la lámina de un preset), para
//  que el texto busque su sitio a partir del arte en vez de a ojo. Un
//  obstáculo es un polígono convexo, un círculo o una caja, cada uno con su
//  `aire`: la distancia mínima que hay que dejarle. Una caja es
//  (x0, y0, x1, y1), con y hacia abajo.
//
//  Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────

#let _xs(pts) = pts.map(p => p.at(0))
#let _ys(pts) = pts.map(p => p.at(1))

// ── constructores ──
#let ob-poligono(pts, aire: 0) = (
  tipo: "poligono", pts: pts, aire: aire,
  bb: (calc.min(.._xs(pts)), calc.min(.._ys(pts)), calc.max(.._xs(pts)), calc.max(.._ys(pts))),
)
#let ob-circulo(c, r, aire: 0) = (tipo: "circulo", c: c, r: r, aire: aire,
  bb: (c.at(0) - r, c.at(1) - r, c.at(0) + r, c.at(1) + r))
#let ob-caja(caja, aire: 0) = (tipo: "caja", caja: caja, aire: aire, bb: caja)
// rombo: un cuadrado girado 45° de diagonal `diag`
#let ob-rombo(c, diag, aire: 0) = {
  let h = diag / 2
  ob-poligono(((c.at(0) - h, c.at(1)), (c.at(0), c.at(1) - h), (c.at(0) + h, c.at(1)), (c.at(0), c.at(1) + h)), aire: aire)
}

#let _solapa(a0, a1, b0, b1) = a0 < b1 and b0 < a1

// ¿la caja `r` se acerca a `ob` a menos de su aire?
#let choca(r, ob) = {
  let m = ob.aire
  let (x0, y0, x1, y1) = (r.at(0) - m, r.at(1) - m, r.at(2) + m, r.at(3) + m)
  let bb = ob.bb
  if not (_solapa(x0, x1, bb.at(0), bb.at(2)) and _solapa(y0, y1, bb.at(1), bb.at(3))) { return false }
  if ob.tipo == "caja" { return true }
  if ob.tipo == "circulo" {
    // distancia exacta del centro a la caja sin agrandar
    let (cx, cy) = ob.c
    let dx = calc.max(r.at(0) - cx, 0, cx - r.at(2))
    let dy = calc.max(r.at(1) - cy, 0, cy - r.at(3))
    return dx * dx + dy * dy < calc.pow(ob.r + m, 2)
  }
  // polígono convexo: ejes separadores (los de la caja ya se vieron arriba)
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

// ¿la caja está dentro de `limites` (otra caja) y lejos de todos los obstáculos?
#let libre(r, obstaculos, limites) = (
  r.at(0) >= limites.at(0) and r.at(1) >= limites.at(1)
    and r.at(2) <= limites.at(2) and r.at(3) <= limites.at(3)
    and obstaculos.all(o => not choca(r, o))
)

// Dibuja los obstáculos (contorno) con `pt(x, y)` -> (pt, pt) y `L`, para depurar.
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
