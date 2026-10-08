// Lámina 12 · «La guía del Espíritu» · story 1080×1920
// Concepto: el viento del Espíritu. «nosotros mismos por nosotros mismos»
// se compone en anillo, un bucle cerrado sobre sí; la línea que lo rodea
// no se cierra: pasa bajo su propio comienzo y escapa hacia las olas en
// salvia, donde «por el Espíritu Santo» rompe afuera. Cormorant Garamond + Ysabeau.
// Compilar: typst compile --root . --font-path Fonts campana/12-guia-del-espiritu.typ campana/12-guia-del-espiritu.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.story
#let papel = rgb("#edf1e7")
#let tinta = rgb("#1b3326")
#let musgo = rgb("#3d5c46")
#let crema = rgb("#f4f1e4")
#let serif = "Cormorant Garamond"
#let sans = "Ysabeau"

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: serif, fill: tinta, lang: "es", hyphenate: false)

// ── Fondo: papel salvia apenas granulado + viento en olas abajo ──
#superbg.bg-gradiente(parar: ((rgb("#f3f5ee"), 0%), (papel, 55%), (rgb("#dfe7d8"), 100%)), angulo: 90deg)
#superbg.bg-olas(
  (rgb("#cfdcc8"), rgb("#a8bfa3"), rgb("#6f8f74"), rgb("#3e5f49"), rgb("#1f3a2b")),
  fondo: none,
  size: formatos.story,
  amplitud: 46,
  vueltas: 1.25,
  fase: 0.6,
  base: 0.765,
  separacion: 0.05,
  desfase: 0.75,
)
#superbg.bg-patron(patron: "ruido", opacidad: 7%, size: formatos.story)

// ── El anillo: texto sobre circunferencia ──
// Arco superior en sentido horario y arco inferior leído de izquierda a
// derecha (como en un sello), ambos con la letra derecha para el lector.
// `r` es el radio de la línea media de las mayúsculas.
#let cx = 540pt
#let cy = 800pt
#let r = 244pt

#let arco(cadena, centro, abajo: false, size: 82pt, track: 1pt, fill: musgo) = context {
  let letras = cadena.clusters()
  let est(c) = text(font: serif, size: size, weight: 600, style: "italic", fill: fill, c)
  let anchos = letras.map(c => measure(est(c)).width + track)
  let total = anchos.sum()
  // Ángulo (rad) recorrido por todo el arco.
  let barrido = total / r
  let acum = 0pt
  for (i, c) in letras.enumerate() {
    let medio = acum + anchos.at(i) / 2
    acum += anchos.at(i)
    let t = (medio / r - barrido / 2) * 1rad
    let a = if abajo { centro - t } else { centro + t }
    let px = cx + r * calc.cos(a)
    let py = cy + r * calc.sin(a)
    let giro = if abajo { a - 90deg } else { a + 90deg }
    let caja = box(width: 2 * size, height: size, align(center + horizon, est(c)))
    place(top + left, dx: px - size, dy: py - size / 2, rotate(giro, caja))
  }
}

// El bucle (SVG): una sola línea que da la vuelta completa al anillo en
// sentido antihorario y, en vez de cerrarse, pasa por debajo de su propio
// comienzo y escapa: se vuelve viento y baja hacia las olas.
#let svg-bucle = {
  let ox = cx / 1pt
  let oy = cy / 1pt
  let R = 316
  let f(x) = str(calc.round(x, digits: 1))
  let pt(ang) = (ox + R * calc.cos(ang * 1deg), oy + R * calc.sin(ang * 1deg))
  let (ax, ay) = pt(60)
  let (bx, by) = pt(120)
  // Tangente antihoraria en 120°: (sen, −cos).
  let (tx, ty) = (calc.sin(120deg), -calc.cos(120deg))
  let s = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1080 1920'>"
  let trazo(d, w, op) = "<path d='" + d + "' fill='none' stroke='#1f3a2b' stroke-opacity='" + str(op) + "' stroke-width='" + str(w) + "' stroke-linecap='round'/>"
  let escape(dy, k) = (
    " C " + f(bx + 260 * tx) + " " + f(by + 260 * ty + dy) + ", " + f(860) + " " + f(oy + 300 + dy * 1.6) +
    ", " + f(1120) + " " + f(oy + 420 + dy * 2.2)
  )
  s += trazo("M " + f(ax) + " " + f(ay) + " A " + str(R) + " " + str(R) + " 0 1 0 " + f(bx) + " " + f(by) + escape(0, 0), 4, 0.9)
  s + "</svg>"
}
#place(image(bytes(svg-bucle), format: "svg", width: 100%, height: 100%))

#arco("nosotros mismos", -90deg)
#arco("por nosotros mismos,", 90deg, abajo: true)


// ── Arriba: el planteo ──
#place(top + left, dx: 96pt, dy: 170pt, block(width: 888pt, {
  set par(leading: 0.3em, justify: false)
  text(size: 104pt, weight: 500)[La guía espiritual\ misma no es una\ guía de]
}))

// ── Debajo del anillo: la corrección ──
#place(top + left, dx: 96pt, dy: 1236pt, block(width: 888pt, {
  set par(leading: 0.3em)
  text(size: 76pt, weight: 500)[sino una guía de nosotros]
}))

// ── Sobre las olas: la frase que rompe el bucle ──
#place(top + left, dx: 96pt, dy: 1520pt, block(width: 940pt, {
  set par(leading: 0.16em)
  text(size: 150pt, weight: 700, style: "italic", fill: crema)[por el Espíritu Santo.]
}))

// ── Pie ──
#place(top + left, dx: 96pt, dy: 1834pt, block(width: 888pt, grid(
  columns: (1fr, auto),
  align: (left + horizon, right + horizon),
  text(font: sans, size: 26pt, fill: crema, tracking: 0.5pt)[*B. B. Warfield* · La guía del Espíritu],
  logo(crema, (ancho, alto)),
)))
