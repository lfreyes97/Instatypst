// Viñetas en línea (tinta sobre papel) para acompañar el texto: el Memorial de Lincoln y la
// bandera («Old Glory»), las dos imágenes del párrafo. Contrastan a propósito con la lámina
// a color: la lámina da la escena; las viñetas, el detalle.
#let trazo(color) = 1.1pt + color

// Memorial de Lincoln: escalinata, ocho columnas, arquitrabe y frontón.
#let memorial(color: black, papel: white) = box(width: 150pt, height: 112pt, {
  let w = 150pt
  // escalinata (de abajo arriba, cada peldaño más estrecho)
  for (i, ancho) in ((150pt, 6pt), (136pt, 6pt), (122pt, 6pt)).enumerate() {
    let (aw, ah) = ancho
    place(top + left, dx: (w - aw) / 2, dy: 112pt - (i + 1) * ah, rect(width: aw, height: ah, fill: papel, stroke: trazo(color)))
  }
  // columnas
  for i in range(0, 8) {
    place(top + left, dx: 20pt + i * 15pt, dy: 38pt, rect(width: 8pt, height: 50pt, fill: papel, stroke: trazo(color)))
  }
  // arquitrabe y frontón
  place(top + left, dx: 14pt, dy: 28pt, rect(width: 122pt, height: 10pt, fill: papel, stroke: trazo(color)))
  place(top + left, curve(fill: papel, stroke: trazo(color),
    curve.move((10pt, 28pt)), curve.line((75pt, 4pt)), curve.line((140pt, 28pt)), curve.close()))
  // tímpano: tres rayitas
  for dx in (-14pt, 0pt, 14pt) {
    place(top + left, dx: 75pt + dx, dy: 18pt, line(start: (0pt, 0pt), end: (0pt, 6pt), stroke: 0.7pt + color))
  }
  // la base del bloque
  place(top + left, dx: 22pt, dy: 88pt, rect(width: 106pt, height: 6pt, fill: papel, stroke: trazo(color)))
})

// Bandera en su asta: trece franjas (las rojas, rayadas) y el cantón lleno.
#let bandera(color: black, papel: white) = box(width: 150pt, height: 112pt, {
  // asta y remate
  place(top + left, dx: 40pt, dy: 6pt, line(start: (0pt, 0pt), end: (0pt, 104pt), stroke: 2.2pt + color))
  place(top + left, dx: 36.5pt, dy: 0pt, circle(radius: 3.5pt, fill: papel, stroke: trazo(color)))
  // paño con un ligero ondeo
  let fw = 92pt
  let fh = 60pt
  place(top + left, dx: 42pt, dy: 10pt, {
    let ondas = 6
    for i in range(0, 13) {
      let y = i * fh / 13
      let h = fh / 13
      let pts = range(0, ondas + 1).map(j => {
        let x = j * fw / ondas
        (x, y + 2.2pt * calc.sin(j * 1.05 + 0.3))
      })
      let pts2 = pts.rev().map(p => (p.at(0), p.at(1) + h))
      place(top + left, curve(fill: if calc.even(i) { color } else { papel }, stroke: 0.4pt + color,
        curve.move(pts.first()), ..pts.slice(1).map(p => curve.line(p)),
        ..pts2.map(p => curve.line(p)), curve.close()))
    }
    place(top + left, curve(fill: color, stroke: none,
      curve.move((0pt, 0pt + 2.2pt * calc.sin(0.3))), curve.line((36pt, 2.2pt * calc.sin(2.4))),
      curve.line((36pt, 31pt + 2.2pt * calc.sin(2.4))), curve.line((0pt, 31pt + 2.2pt * calc.sin(0.3))), curve.close()))
    // estrellas del cantón (puntos)
    for r in range(0, 4) {
      for c in range(0, 5) {
        place(top + left, dx: 4pt + c * 6.6pt, dy: 4pt + r * 6.6pt + 2.2pt * calc.sin(0.3), circle(radius: 0.9pt, fill: papel))
      }
    }
  })
})
