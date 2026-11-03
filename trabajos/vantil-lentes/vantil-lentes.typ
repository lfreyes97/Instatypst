// Carrusel de Instagram: Los lentes de colores, de Cornelius Van Til (3 diapositivas, 1080×1080).
//   1  El diagnóstico   la cita inicial («Todos llevan lentes de colores»), con los lentes puestos
//   2  Lo que implica   implicaciones filosóficas generales (texto propio, no cita)
//   3  La cura          la cita del Médico, con los lentes ya quitados
// El hilo común es la palabra HECHOS y los lentes: puestos en la 1, numerales-lente en la 2,
// quitados en la 3. Firma (logo) en portada y cierre; contador en la interior.
// Citas: C. Van Til, Why I Believe in God (Great Commission Publications, 1976): la 1 de la
// sección «Early Schooling» (traducción propia del inglés), la 3 de la p. 15 (traducción
// dada por el usuario).
// Compilar: typst compile --root . --font-path Fonts trabajos/vantil-lentes/vantil-lentes.typ "salida/vantil-lentes-{p}.png" --ppi 144
#import "../../src/lib.typ": *
#import "../campana/_comun.typ": logo, formatos

#let f = formatos.instagram
#let ancho = f.at(0) * 1pt
#let alto = f.at(1) * 1pt
#let total = 3

#let crema = rgb("#efe9db")
#let tinta = rgb("#141414")
#let verde = rgb("#2f7d4f")
#let cristal = rgb("#cfe3c4")
#let apagado = rgb("#6d675b")
#let selva = rgb("#12301f")

#let mono(cuerpo, color, size: 20pt) = text(font: "DM Mono", size: size, weight: 500, tracking: 0.1em, fill: color, cuerpo)
// Contador: una columna de lentes en el margen derecho, centrada a lo alto, igual en las
// tres láminas (no choca con el pie ni con el texto: el margen es de 88 pt; es pequeño a propósito). El lente de la
// lámina actual lleva cristal; los otros, solo la montura, más tenue.
#let contador(n, color, cristal) = place(right + horizon, dx: -40pt,
  stack(dir: ttb, spacing: 11pt,
    ..range(1, total + 1).map(i => circle(radius: 6.5pt,
      fill: if i == n { cristal } else { none },
      stroke: 2.5pt + if i == n { color } else { color.transparentize(60%) }))))
#let pie(izq, marca-color) = {
  place(bottom + left, dx: 88pt, dy: -64pt, izq)
  place(bottom + right, dx: -88pt, dy: -56pt, logo(marca-color, f))
}

// HECHOS: la palabra se centra en la lámina y mide ~4,1 veces el tamaño de letra.
#let palabra(tam, color) = text(font: "Fraunces 72pt", weight: 900, size: tam, fill: color, tracking: -0.04em)[HECHOS]

// Un par de lentes de diámetro `d` con su puente. `x`/`y` es la esquina superior izquierda
// de la montura. Con `tam` dado, dibuja dentro de cada cristal la palabra HECHOS teñida,
// desplazada para que coincida con la de fuera (`palabra-x`, `palabra-y` son la posición
// de esa palabra en la lámina).
#let lentes(x, y, d, sep, grueso, tinte: cristal, palabra-tenida: none) = {
  let lente(lx) = {
    place(top + left, dx: lx, dy: y,
      box(width: d, height: d, radius: 50%, clip: true, fill: tinte, {
        if palabra-tenida != none {
          let (px, py, tam, color) = palabra-tenida
          place(top + left, dx: px - lx, dy: py - y, box(width: ancho, align(center, palabra(tam, color))))
        }
      }))
    place(top + left, dx: lx, dy: y, circle(radius: d / 2, fill: none, stroke: grueso + tinta))
  }
  lente(x)
  lente(x + d + sep)
  place(top + left, dx: x + d - grueso / 2, dy: y + d / 2 - 0.18 * d,
    curve(stroke: grueso + tinta,
      curve.move((0pt, 0.1 * d)),
      curve.cubic((0.05 * d, -0.03 * d), (sep + grueso - 0.05 * d, -0.03 * d), (sep + grueso, 0.1 * d))))
}

// ── 1 · El diagnóstico ─────────────────────────────────────────────
#page(width: ancho, height: alto, margin: 0pt, fill: crema, {
  let esc = 0.95 // escala respecto de la lámina suelta (d = 390pt)
  let d = 390pt * esc
  let sep = 60pt * esc
  let x0 = (ancho - (2 * d + sep)) / 2
  let y0 = 60pt
  let tam = 232pt * esc
  let py = y0 + 114pt * esc
  place(top + left, dy: py, box(width: ancho, align(center, palabra(tam, tinta))))
  lentes(x0, y0, d, sep, 9pt * esc, palabra-tenida: (0pt, py, tam, verde))

  place(top + left, dx: 88pt, dy: 560pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: tinta, size: 42pt, weight: 400)
    set par(leading: 0.5em)
    [#text(style: "italic")[«Si el Dios del cristianismo existe, la evidencia de él #text(weight: 700)[tiene que ser clara]. Y la razón por la que “todos” no creen en él debe ser que “todos” están cegados por el pecado.] #text(weight: 700, fill: verde)[Todos llevan lentes de colores.]#text(style: "italic")[»]]
  }))
  pie(mono([CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976)], apagado, size: 18pt), tinta)
  contador(1, tinta, cristal)
})

// ── 2 · Lo que implica ─────────────────────────────────────────────
#page(width: ancho, height: alto, margin: 0pt, fill: selva, {
  let ambar = rgb("#f2b33d")
  place(top + left, dx: 88pt, dy: 88pt, mono([LO QUE IMPLICA], ambar, size: 22pt))

  let item(n, titulo, cuerpo) = grid(columns: (130pt, 1fr), column-gutter: 28pt, align: top + left,
    {
      box(width: 110pt, height: 110pt, {
        place(circle(radius: 55pt, fill: cristal.darken(55%).transparentize(65%), stroke: 7pt + crema))
        place(center + horizon, text(font: "Fraunces 72pt", weight: 900, size: 58pt, fill: crema)[#n])
      })
    },
    {
      set par(leading: 0.4em, spacing: 24pt)
      text(font: "Hanken Grotesk", size: 50pt, weight: 700, tracking: -0.02em, fill: crema, titulo)
      parbreak()
      text(font: "Hanken Grotesk", size: 32pt, weight: 400, fill: crema.darken(18%), cuerpo)
    })

  place(top + left, dx: 88pt, dy: 175pt, box(width: ancho - 176pt, {
    item(1, [No hay hechos neutrales.],
      [Todo dato llega ya interpretado: hasta las gallinas y las vacas se ven a través de los lentes, no solo la vida venidera.])
    v(58pt)
    item(2, [No falta evidencia.],
      [Más datos pasan por el mismo cristal y salen del mismo color. Un mejor argumento no cambia los lentes.])
    v(58pt)
    item(3, [El problema es moral, no solo intelectual.],
      [Se suprime la verdad que se conoce (Ro 1:18–20): por eso hace falta regeneración, no solo información.])
  }))
  contador(2, crema, cristal.darken(25%))
})

// ── 3 · La cura ────────────────────────────────────────────────────
#page(width: ancho, height: alto, margin: 0pt, fill: crema, {
  let tam = 196pt
  place(top + left, dy: 70pt, box(width: ancho, align(center, palabra(tam, tinta))))
  // los lentes ya quitados, apoyados debajo y ladeados
  place(top + left, dx: 88pt, dy: 800pt,
    rotate(-7deg, origin: top + left, lentes(0pt, 0pt, 130pt, 24pt, 7pt, tinte: cristal.transparentize(35%))))

  place(top + left, dx: 88pt, dy: 290pt, mono([LA CURA], verde, size: 22pt))
  place(top + left, dx: 88pt, dy: 340pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: tinta, size: 44pt, weight: 400)
    set par(leading: 0.48em)
    text(style: "italic")[«#text(weight: 700, style: "normal")[Solo el gran Médico], mediante su expiación en la cruz y por el don de su Espíritu, puede quitar esos lentes de colores y hacerle ver los hechos como son, los hechos como evidencia, como evidencia inherentemente vinculante, de la existencia de Dios.»]
  }))
  pie(mono([CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976), P. 15], apagado, size: 18pt), tinta)
  contador(3, tinta, cristal)
})
