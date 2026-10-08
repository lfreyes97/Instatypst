// Lámina 19 · La vida religiosa de Charles Darwin · story 1080×1920 · par Darwin (1 de 2)
// Concepto: el árbol de la cita, dibujado. Un gran árbol de ramas extendidas que
// muere por la copa: abajo, follaje vivo; arriba, ramas desnudas y grises. El
// fondo hace la misma gradación (ceniza arriba, tierra abajo). Literata.
// Compilar: typst compile --root . --font-path Fonts campana/19-darwin-hombre-muerto-por-arriba.typ campana/19-darwin-hombre-muerto-por-arriba.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.story
#let ceniza = rgb("#d9d7d2")
#let papel = rgb("#eeeae0")
#let tierra = rgb("#2b2820")
#let tinta = rgb("#24221e")
#let crema = rgb("#ece6d6")
#let crema-suave = rgb("#c9c1ad")
#let madera = rgb("#3f3326")
#let hueso = rgb("#a19c93")

#let suelo-y = 1548          // línea de tierra (en pt, sin unidad)
#let muerte-y = 1000         // por encima de esta altura el árbol está seco

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: "Literata", fill: tinta, lang: "es", hyphenate: false)

// ── Fondo: ceniza arriba → papel cálido abajo; tierra oscura al pie
#place(rect(width: 100%, height: suelo-y * 1pt, fill: gradient.linear(ceniza, papel, angle: 90deg)))
#place(dy: suelo-y * 1pt, rect(width: 100%, height: (alto - suelo-y) * 1pt, fill: tierra))

// ── El árbol (recursivo, determinista)
// azar(k): pseudoaleatorio en [0, 1) a partir de un entero.
#let azar(k) = calc.fract(calc.abs(calc.sin(k * 12.9898 + 78.233) * 43758.5453))
#let lim(x, a, b) = calc.max(a, calc.min(b, x))

// Devuelve la lista de ramas: (x1, y1, x2, y2, grosor, prof, id).
#let crecer(x, y, ang, largo, grosor, prof, id) = {
  let x2 = x + calc.sin(ang) * largo
  let y2 = y - calc.cos(ang) * largo
  let ramas = ((x, y, x2, y2, grosor, prof, id),)
  if prof > 0 {
    let hijos = if azar(id * 7 + 1) < 0.3 and prof > 1 and prof < 7 { 3 } else { 2 }
    for i in range(hijos) {
      let abre = 0.30rad + azar(id * 13 + i) * 0.42rad
      let desvio = if hijos == 2 { (if i == 0 { -abre } else { abre }) } else { (i - 1) * abre }
      // copa ancha: cada generación se tiende un poco más hacia el costado
      let a = ang + desvio + ang * 0.22
      let a = lim(a / 1rad, -1.5, 1.5) * 1rad
      let factor = 0.64 + azar(id * 31 + i * 5) * 0.14
      ramas += crecer(x2, y2, a, largo * factor, grosor * 0.64, prof - 1, id * 3 + i + 1)
    }
  }
  ramas
}

#let ramas = crecer(540, suelo-y, 0rad, 226, 58, 9, 1)

// color de una rama según su altura: madera viva abajo, hueso seco arriba
#let tono(y) = {
  let t = lim((y - muerte-y + 60) / 220, 0, 1)
  color.mix((hueso, 100% - t * 100%), (madera, t * 100%))
}

// raíces visibles: dos lomos cortos en el suelo
#place(dx: 470pt, dy: (suelo-y - 14) * 1pt, ellipse(width: 140pt, height: 30pt, fill: madera))

#for (x1, y1, x2, y2, g, prof, id) in ramas {
  place(line(
    start: (x1 * 1pt, y1 * 1pt), end: (x2 * 1pt, y2 * 1pt),
    stroke: (paint: tono((y1 + y2) / 2), thickness: calc.max(g, 1.6) * 1pt, cap: "round"),
  ))
}

// follaje: en las ramitas (prof ≤ 4) que quedan bajo la línea de muerte;
// cuanto más abajo, más denso y más verde. Cerca del límite, mustio y ralo.
#let verdes = (rgb("#3e6b35"), rgb("#4f7d3c"), rgb("#62904a"), rgb("#2f5a2c"))
#let mustio = rgb("#9a9058")
#for (x1, y1, x, y, g, prof, id) in ramas {
  let vida = lim((y - muerte-y) / 240, 0, 1)
  if prof <= 4 and vida > 0 and azar(id * 3 + 2) < 0.25 + vida {
    for j in range(3) {
      let rx = (azar(id * 11 + j) - 0.5) * 40
      let ry = (azar(id * 17 + j) - 0.5) * 30
      let r = 10 + azar(id * 23 + j) * 12 * (0.6 + vida * 0.7)
      let verde = verdes.at(calc.rem(id + j, 4))
      let c = color.mix((mustio, 100% - vida * 100%), (verde, vida * 100%))
      place(dx: (x + rx - r) * 1pt, dy: (y + ry - r) * 1pt, circle(radius: r * 1pt, fill: c.transparentize(10%)))
    }
  }
}

// ── La cita (arriba, sobre la ceniza)
#place(dx: 84pt, dy: 150pt, block(width: 912pt)[
  #set par(leading: 0.5em)
  #text(size: 44pt)[\[Darwin\] quedó como algún gran árbol del bosque de ramas extendidas, bajo el cual los hombres pueden descansar y refrescarse, pero ya marcado por la decadencia como suya propia.]
  #v(28pt)
  #set par(leading: 0.32em)
  #text(size: 78pt, style: "italic", weight: 600)[Era un hombre muerto por arriba.]
])

// ── Pie, en la tierra: atribución, nota y marca
#place(dx: 84pt, dy: (suelo-y + 56) * 1pt, block(width: 912pt)[
  #set text(fill: crema)
  #text(size: 30pt, weight: 600)[B. B. Warfield] #text(size: 30pt, fill: crema-suave)[· La vida religiosa de Charles Darwin]
  #v(14pt)
  #set par(leading: 0.5em)
  #text(size: 23pt, fill: crema-suave)[Juicio de Warfield sobre Darwin, en su ensayo sobre la vida religiosa del naturalista. 1 de 2 — ver el contraste con la muerte de Charles Hodge.]
  #v(22pt)
  #logo(crema, (ancho, alto))
])
