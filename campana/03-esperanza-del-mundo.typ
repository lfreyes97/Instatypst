// Lámina 03 · «El calvinismo hoy» · cuadrado 1080×1080
// Concepto: un mundo de semitonos que asoma desde abajo, como un planeta
// en el horizonte, iluminado desde arriba: la luz le viene de las palabras.
// Dos tintas de risografía (petróleo y naranja quemado) sobre papel crema;
// «esperanza del mundo» enorme en Fraunces itálica (corte estático «72pt»:
// la variable trae la itálica «wonky», con la l y la d enroscadas).
// Compilar: typst compile --root . --font-path Fonts campana/03-esperanza-del-mundo.typ campana/03-esperanza-del-mundo.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.instagram
#let papel = rgb("#f1e9db")
#let petroleo = rgb("#1d5568")
#let naranja = rgb("#a53c17")
#let tinta = rgb("#1b2a30")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(font: "Fraunces", fill: tinta, lang: "es")

// ── el mundo: esfera en semitonos (trama hexagonal, radio según la luz) ──
// El tamaño del punto es la sombra: donde da la luz, puntos mínimos; en el
// borde y del lado opuesto, puntos llenos. La luz viene de arriba a la izquierda.
#let mundo(cx, cy, radio, paso: 19, r-max: 9.4, r-min: 2.4) = {
  let luz = (-0.42, -0.70, 0.58) // dirección (x, y, z) normalizada aprox.
  let fila = paso * 0.866
  let filas = int(2 * radio / fila) + 2
  for j in range(filas) {
    let y = cy - radio + j * fila
    let desfase = if calc.rem(j, 2) == 1 { paso / 2 } else { 0 }
    let cols = int(2 * radio / paso) + 2
    for i in range(cols) {
      let x = cx - radio + i * paso + desfase
      let dx = (x - cx) / radio
      let dy = (y - cy) / radio
      let d2 = dx * dx + dy * dy
      if d2 <= 1 and y <= alto + paso {
        let nz = calc.sqrt(1 - d2)
        let lum = calc.max(0, dx * luz.at(0) + dy * luz.at(1) + nz * luz.at(2))
        let sombra = calc.pow(calc.max(0, 1 - lum), 1.1)
        let r = r-min + (r-max - r-min) * sombra
        place(top + left, dx: (x - r) * 1pt, dy: (y - r) * 1pt, circle(radius: r * 1pt, fill: petroleo))
      }
    }
  }
}
#mundo(540, 1060, 470)

// ── cabecera: autor y ensayo ──
#place(top + left, dx: 72pt, dy: 60pt, {
  text(font: "DM Mono", size: 22pt, fill: tinta, tracking: 0.04em)[B. B. WARFIELD]
  h(12pt)
  text(font: "Fraunces 72pt", size: 27pt, style: "italic", fill: tinta)[· #h(8pt) El calvinismo hoy]
})
#place(top + right, dx: -72pt, dy: 58pt, logo(petroleo, (ancho, alto)))
#place(top + left, dx: 72pt, dy: 108pt, line(length: ancho * 1pt - 144pt, stroke: 1.2pt + tinta))

// ── la frase ──
#place(top + left, dx: 72pt, dy: 146pt, block(width: 760pt)[
  #set par(leading: 0.42em)
  #text(size: 35pt, weight: 400)[El calvinismo emerge así a nuestra vista como nada más ni nada menos que la]
])
#place(top + left, dx: 62pt, dy: 252pt, block(width: 980pt)[
  #set par(leading: 0.1em)
  #text(font: "Fraunces 72pt", size: 196pt, style: "italic", weight: 400, fill: naranja, tracking: -0.025em)[esperanza \ #h(118pt)del mundo.]
])
