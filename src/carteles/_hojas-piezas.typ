// ─────────────────────────────────────────────────────────────
//  carteles/_hojas-piezas.typ — la «hoja» y sus agrupaciones
//
//  La hoja es un cuadrado con tres esquinas redondeadas (radio = medio lado:
//  tres cuartos de círculo) y una esquina aguda, con un anillo de otro color
//  y un hueco concéntricos al círculo. Girándola y alternando colores salen
//  las composiciones de `carteles.hojas`: la flor (cuatro hojas con la punta
//  hacia el centro), el par en diagonal (dos hojas que se tocan por la punta)
//  y la cinta de pares a 45°. Vive aparte para que otros presets la usen.
//
//    hoja(lado, aguda, relleno, anillo, hueco, …)   una hoja en una caja de
//                                                   `lado` × `lado`
//    flor(lado, a, b, hueco, …)       cuatro hojas en 2 × 2 (caja de 2 lados)
//    pareja(lado, arriba, abajo, hueco, diagonal, …)   dos hojas que se tocan
//                                     por la punta (caja de 2 lados)
//    ESQUINAS                         los nombres válidos de `aguda`
//
//  Proporciones (medidas sobre la captura de la referencia, no sobre su
//  HTML, que las dibuja algo menores): anillo de radio 0,30 del lado y hueco
//  de 0,185. Con lado 120, r = 36 y 22 (el HTML dice 32 y 19).
//
//  No importa ningún preset: los presets lo importan a él.
// ─────────────────────────────────────────────────────────────

// Esquina aguda: noroeste, noreste, sureste, suroeste. (dx, dy) del cuarto
// cuadrado que queda sin redondear, en medios lados.
#let ESQUINAS = (no: (0, 0), ne: (1, 0), se: (1, 1), so: (0, 1))

#let _esquina(aguda, quien) = {
  if not aguda in ESQUINAS {
    panic(quien + ": `aguda` debe ser " + ESQUINAS.keys().map(repr).join(", ") + " (noroeste, noreste, sureste, suroeste), no " + repr(aguda))
  }
  ESQUINAS.at(aguda)
}

// La esquina opuesta (la punta que mira a la de `aguda`).
#let opuesta(aguda) = (no: "se", se: "no", ne: "so", so: "ne").at(aguda)

// ── hoja ────────────────────────────────────────────────────
//   lado      lado de la caja
//   aguda     la esquina sin redondear: "no", "ne", "se" o "so"
//   relleno   color de la hoja
//   anillo    color del anillo (none = sin anillo)
//   hueco     color del hueco del anillo, normalmente el del papel (none =
//             sin hueco: el anillo queda como un disco)
//   r-anillo, r-hueco   radios, en fracciones del lado
// Se dibuja como un círculo más el cuarto de cuadrado de la punta, del mismo
// color: el borde interior del cuadrado cae dentro del círculo y no deja
// costura al rasterizar.
#let hoja(lado, aguda: "se", relleno: black, anillo: none, hueco: none, r-anillo: 0.30, r-hueco: 0.185) = {
  let (ex, ey) = _esquina(aguda, "hoja")
  let m = lado / 2
  let disco(r, c) = place(top + left, dx: m - r, dy: m - r, circle(radius: r, fill: c))
  box(width: lado, height: lado, {
    disco(m, relleno)
    place(top + left, dx: ex * m, dy: ey * m, rect(width: m, height: m, fill: relleno))
    if anillo != none { disco(r-anillo * lado, anillo) }
    if anillo != none and hueco != none { disco(r-hueco * lado, hueco) }
  })
}

// ── flor ────────────────────────────────────────────────────
// Cuatro hojas en 2 × 2 con la punta hacia el centro. Los colores se cruzan:
// `a` en la de arriba a la izquierda y en la de abajo a la derecha (con
// anillo `b`), `b` en las otras dos (con anillo `a`). Caja de 2 × lado.
#let flor(lado, a, b, hueco, r-anillo: 0.30, r-hueco: 0.185) = {
  let h(aguda, c, r) = hoja(lado, aguda: aguda, relleno: c, anillo: r, hueco: hueco, r-anillo: r-anillo, r-hueco: r-hueco)
  box(width: 2 * lado, height: 2 * lado, {
    place(top + left, h("se", a, b))
    place(top + left, dx: lado, h("so", b, a))
    place(top + left, dy: lado, h("ne", b, a))
    place(top + left, dx: lado, dy: lado, h("no", a, b))
  })
}

// ── pareja ──────────────────────────────────────────────────
// Dos hojas que se tocan por la punta, en una caja de 2 × lado.
//   diagonal  "bajada" (arriba a la izquierda y abajo a la derecha, como la
//             portada 2) o "subida" (arriba a la derecha y abajo a la
//             izquierda, como los pares de la cinta)
//   arriba, abajo   color de la hoja de arriba y de la de abajo; el anillo de
//             cada una es el color de la otra
#let pareja(lado, arriba, abajo, hueco, diagonal: "bajada", r-anillo: 0.30, r-hueco: 0.185) = {
  let h(aguda, c, r) = hoja(lado, aguda: aguda, relleno: c, anillo: r, hueco: hueco, r-anillo: r-anillo, r-hueco: r-hueco)
  box(width: 2 * lado, height: 2 * lado, if diagonal == "bajada" {
    place(top + left, h("se", arriba, abajo))
    place(top + left, dx: lado, dy: lado, h("no", abajo, arriba))
  } else if diagonal == "subida" {
    place(top + left, dx: lado, h("so", arriba, abajo))
    place(top + left, dy: lado, h("ne", abajo, arriba))
  } else {
    panic("pareja: `diagonal` debe ser \"bajada\" o \"subida\", no " + repr(diagonal))
  })
}
