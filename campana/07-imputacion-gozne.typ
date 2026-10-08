// Lámina 07 · «La imputación» · twitter 1600×900
// Lámina de dibujo técnico: a la izquierda la cita entera; a la derecha un
// gozne visto desde arriba —el perno rojo es la imputación— con las tres
// doctrinas como hojas que giran sobre él, numeradas igual que en la cita.
// Compilar: typst compile --root . --font-path Fonts campana/07-imputacion-gozne.typ campana/07-imputacion-gozne.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos, ajustar

#let (ancho, alto) = formatos.twitter
#let papel = rgb("#ece8df")
#let tinta = rgb("#1f262d")
#let gris = rgb("#525a61")     // ≈ 6:1 sobre el papel
#let bermellon = rgb("#a8361f") // ≈ 5.6:1 sobre el papel
#let crema = rgb("#f7f1e6")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: "Instrument Sans", fill: tinta, lang: "es", hyphenate: false)

// Papel de plano: cuadrícula tenue + grano.
#superbg.superbg((capas: (
  (tipo: "plano", color: papel),
  (tipo: "patron", patron: "grid", color: tinta, paso: 40, grosor: 1, opacidad: 6%),
  (tipo: "ruido", color: tinta, opacidad: 4%),
)), size: formatos.twitter)

// Numeral que liga cada doctrina de la cita con su hoja en el diagrama:
// en la cita va volado, como llamada de nota; en el diagrama, en un disco.
#let llamada(n) = text(font: "Instrument Sans", weight: 700, fill: bermellon, super(typographic: false, size: 0.62em, str(n)))
#let disco(n) = box(baseline: 0.18em, circle(radius: 17pt, fill: bermellon, inset: 0pt,
  align(center + horizon, text(weight: 700, size: 22pt, fill: crema, str(n)))))

// ── Columna de la cita (centrada en vertical sobre el pie) ──
#let cita = [#text(fill: bermellon)[\[La imputación\]] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza#llamada(1), la satisfacción de Cristo#llamada(2), la justificación por la fe#llamada(3)— y la guardiana de su pureza.]

#place(top + left, dx: 96pt, dy: 80pt, block(width: 660pt, height: 640pt, align(horizon, context ajustar(
  s => text(font: "Libre Baskerville", size: s, par(leading: 0.66em, cita)),
  660pt, 620pt, texto: cita, max: 46pt, min: 32pt, paso: 1pt,
))))

// ── Pie: atribución y marca ──
#place(top + left, dx: 96pt, dy: 772pt, line(length: 660pt, stroke: 1.2pt + tinta))
#place(top + left, dx: 96pt, dy: 796pt, text(size: 30pt)[
  #text(weight: 700)[B. B. Warfield] #h(8pt) #text(fill: gris)[— #emph[La imputación]]
])
#place(top + right, dx: -96pt, dy: 794pt, logo(tinta, (ancho, alto)))

// ── El gozne (SVG): hojas, perno y flechas de giro ──
// Origen del dibujo: caja de 760×740 en (820, 40); perno en (380, 380).
#let cx = 380
#let cy = 380
#let polar(r, a) = (cx + r * calc.cos(a), cy + r * calc.sin(a))
#let pt(p) = str(p.at(0)) + " " + str(p.at(1))
#let angulos = (-90deg, 30deg, 150deg)

#let hoja(a) = {
  let n = a + 90deg
  let (r0, r1, mw) = (96, 292, 40)
  let esq = (
    polar(r0, a), polar(r1, a),
  )
  let off(p, s) = (p.at(0) + s * mw * calc.cos(n), p.at(1) + s * mw * calc.sin(n))
  let d = "M " + pt(off(esq.at(0), 1)) + " L " + pt(off(esq.at(1), 1)) + " L " + pt(off(esq.at(1), -1)) + " L " + pt(off(esq.at(0), -1)) + " Z"
  let agujeros = (165, 240).map(r => {
    let p = polar(r, a)
    "<circle cx='" + str(p.at(0)) + "' cy='" + str(p.at(1)) + "' r='11' fill='" + papel.to-hex() + "'/>"
  }).join("")
  "<path d='" + d + "' fill='" + tinta.to-hex() + "' stroke='" + tinta.to-hex() + "' stroke-width='10' stroke-linejoin='round'/>" + agujeros
}

// Arco de giro entre dos hojas, con punta de flecha al final.
#let arco(a) = {
  let r = 190
  let (a0, a1) = (a + 28deg, a + 92deg)
  let p0 = polar(r, a0)
  let p1 = polar(r, a1)
  // punta: triángulo tangente al final del arco
  let t = a1 + 90deg
  let n = a1
  let base = 15
  let q1 = (p1.at(0) + base * calc.cos(n), p1.at(1) + base * calc.sin(n))
  let q2 = (p1.at(0) - base * calc.cos(n), p1.at(1) - base * calc.sin(n))
  let tip = (p1.at(0) + 26 * calc.cos(t), p1.at(1) + 26 * calc.sin(t))
  "<path d='M " + pt(p0) + " A " + str(r) + " " + str(r) + " 0 0 1 " + pt(p1) + "' fill='none' stroke='" + bermellon.to-hex() + "' stroke-width='5' stroke-linecap='round'/>" + "<path d='M " + pt(q1) + " L " + pt(tip) + " L " + pt(q2) + " Z' fill='" + bermellon.to-hex() + "'/>"
}

#let svg = (
  "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 760 740'>",
  // órbita: el giro completo de las hojas
  "<circle cx='380' cy='380' r='330' fill='none' stroke='" + tinta.to-hex() + "' stroke-opacity='0.35' stroke-width='2' stroke-dasharray='4 12' stroke-linecap='round'/>",
  angulos.map(arco).join(""),
  angulos.map(hoja).join(""),
  // perno (nudillo del gozne)
  "<circle cx='380' cy='380' r='112' fill='" + bermellon.to-hex() + "'/>",
  "<circle cx='380' cy='380' r='98' fill='none' stroke='" + crema.to-hex() + "' stroke-opacity='0.55' stroke-width='2'/>",
  "</svg>",
).join("")

#place(top + left, dx: 820pt, dy: 40pt, image(bytes(svg), format: "svg", width: 760pt, height: 740pt))

// Rótulo del perno.
#place(top + left, dx: 820pt + 380pt - 100pt, dy: 40pt + 380pt - 40pt, block(width: 200pt, height: 80pt,
  align(center + horizon, text(size: 30pt, weight: 700, fill: crema, par(leading: 0.3em)[La \ imputación]))))

// Rótulos de las hojas, al extremo de cada una. Llevan fondo de papel
// para cortar la órbita punteada por detrás.
#let rotulo(n, cuerpo, x, y, lado: left) = {
  let t = text(size: 30pt, weight: 600, par(leading: 0.3em, cuerpo))
  let celdas = if lado == left { (disco(n), t) } else { (t, disco(n)) }
  place(top + left, dx: x, dy: y, block(width: 330pt, align(lado, block(fill: papel, inset: (x: 8pt, y: 6pt),
    grid(columns: 2, column-gutter: 12pt, align: (lado + top, lado + top), ..celdas)))))
}

// La hoja 1 apunta hacia arriba: su rótulo va a la izquierda, contra el perno.
#rotulo(1, [La pecaminosidad \ de la raza], 1200pt - 52pt - 330pt, 96pt, lado: right)
#rotulo(2, [La satisfacción \ de Cristo], 1250pt, 640pt)
#rotulo(3, [La justificación \ por la fe], 836pt, 640pt)
