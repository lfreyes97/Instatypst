// Demo de los presets de fleurones (src/fleurones.typ): cada glifo en
// el uso que le sienta. Marcos (`orla`) que aguantan los cuatro lados,
// guardas (`cabecera`) solo en horizontal, viñetas sueltas (`separador`,
// `asterismo`, `remate`, la `mano` que señala). Nada se elige glifo por
// glifo: se pide el preset por nombre. El catálogo completo, con todos
// los nombres, está en ornamentos/fleurones.pdf.
//
// IM FELL FLOWERS pide, al publicar, la nota de `fleurones.credito`
// donde el medio lo pida: aquí, como es un deck, en la última lámina.
// Compilar: typst compile --root . --font-path Fonts examples/presets/fleurones.typ
#import "../../src/lib.typ": fleurones as fl, sizes

#let fell = "IM FELL English"
#let fellsc = "IM FELL English SC"

// Lámina: fondo, marco de orla a `M` del borde y el cuerpo centrado en el campo.
#let lamina(formato, fondo, tinta, orla, cuerpo, M: 44pt, aire: 70pt) = {
  let (W, H) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  page(width: W, height: H, margin: 0pt, fill: fondo, {
    set text(font: fell, fill: tinta, lang: "es", hyphenate: false)
    set par(justify: false)
    place(top + left, dx: M, dy: M, fl.orla(orla, W - 2 * M, H - 2 * M, tinta))
    let g = fl.cadenas.at(orla).grosor
    place(center + horizon, box(width: W - 2 * (M + g + aire), height: H - 2 * (M + g + aire), cuerpo))
  })
}

// 1 · Retrato con celosía: cabecera de crestería, cita y remate.
#let (tinta, rojo, papel) = (rgb("#2b1916"), rgb("#8e3b3b"), rgb("#f6efe2"))
#lamina((1080, 1350), papel, tinta, "celosia", align(center + horizon, {
  fl.cabecera(560pt, rojo, guarda: "cresteria", linea: tinta)
  v(60pt)
  text(font: fellsc, size: 30pt, tracking: 0.14em, fill: rojo)[Magnalia Dei]
  v(36pt)
  text(size: 64pt, style: "italic")[El hombre es un enigma que solo halla su solución en Dios.]
  v(50pt)
  text(font: fellsc, size: 30pt, tracking: 0.1em)[Herman Bavinck]
  v(60pt)
  fl.remate(110pt, rojo)
}))

// 2 · Cuadrado con margaritas: asterismo entre dos frases.
#let (oscuro, crema) = (rgb("#233a33"), rgb("#efe6cf"))
#lamina(sizes.instagram, oscuro, crema, "margaritas", align(center + horizon, {
  text(size: 54pt)[Toda verdad es verdad de Dios;]
  v(40pt)
  fl.asterismo(70pt, crema, vineta: "flor")
  v(40pt)
  text(size: 54pt, style: "italic")[ninguna está fuera de su dominio.]
}))

// 3 · Diapositiva apaisada con trenza: título, separador y tres puntos
// con la mano que señala.
#let (vino, oro) = (rgb("#4a1f24"), rgb("#e6c98f"))
#lamina((1920, 1080), vino, oro, "trenza", aire: 90pt, {
  set align(left)
  text(font: fellsc, size: 74pt, tracking: 0.08em)[El sumo bien]
  v(10pt)
  fl.separador(100%, oro, vineta: "acanto", alto: 34pt, grosor: 1.4pt)
  v(36pt)
  set text(size: 44pt)
  for punto in ([No está en las criaturas, que pasan.], [No está en el hombre, que es un enigma.], [Está solo en Dios, que no cambia.]) {
    grid(columns: (80pt, 1fr), column-gutter: 24pt, align: horizon, fl.vineta("mano", 34pt, oro), punto)
    v(22pt)
  }
})

// 4 · Historia con corazones: roseta, pregunta y guarda al pie.
#lamina(sizes.story, papel, rojo, "corazones", align(center + horizon, {
  fl.roseta(150pt, rojo, tipo: "hojas")
  v(80pt)
  text(font: fellsc, size: 34pt, tracking: 0.14em)[Para la reflexión]
  v(50pt)
  text(size: 66pt, fill: tinta)[¿Dónde busca tu corazón su descanso?]
  v(80pt)
  fl.guarda("vaiven", 640pt, rojo)
}))

// 5 · Créditos: la nota de la licencia va donde corresponde, en la
// lámina final del deck (en un libro, la página de legales).
#lamina((1920, 1080), papel, tinta, "zarcillos", aire: 120pt, align(center + horizon, {
  text(font: fellsc, size: 44pt, tracking: 0.14em, fill: rojo)[Créditos]
  v(30pt)
  fl.separador(420pt, rojo, vineta: "cruz", alto: 22pt)
  v(40pt)
  set text(size: 32pt)
  [Textos: Herman Bavinck, _Magnalia Dei_.]
  v(16pt)
  text(style: "italic", fl.credito)
}))
