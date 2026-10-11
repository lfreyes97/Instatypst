// Demo de escalera() — la frase baja en peldaños sobre color sólido y
// remata en un clímax grande (preset cosechado de la lámina 04). El mismo
// texto se reparte solo en story, retrato, cuadrado y en diapositivas
// apaisadas: los cuerpos se escalan al ancho, se achican si no entran en
// el alto y el aire entre peldaños se estira. Ver src/escalera.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/escalera.typ
#import "../../src/escalera.typ": escalera

#let marca = text(size: 18pt, weight: 600, tracking: 0.12em, fill: rgb("#b9cfc3"))[TU MARCA]
#let caso(formato, peldanos, climax, ..args) = escalera(
  peldanos, climax, formato: formato,
  autor: [B. B. WARFIELD], obra: [La teología de Calvino], marca: marca, ..args,
)

// En grupos: cada grupo vuelve a empezar su escalón desde el margen.
#let calvino = (
  (
    (texto: [El calvinista es el hombre], cuerpo: 64pt),
    (texto: [que ve a Dios], cuerpo: 104pt, peso: 600, tracking: -0.01em),
  ),
  (
    (texto: [detrás de todos], estilo: "italic"),
    (texto: [los fenómenos,], estilo: "italic"),
  ),
  (
    (texto: [y en todo lo que ocurre], cuerpo: 56pt, color: "suave"),
    (texto: [reconoce], cuerpo: 56pt, color: "suave"),
  ),
)

// Plano: una sola escalera que baja en diagonal.
#let fe = (
  [No es la fe],
  (texto: [la que salva,], estilo: "italic"),
  (texto: [sino Cristo], cuerpo: 96pt, peso: 600),
  (texto: [por medio de ella;], color: "suave"),
  (texto: [la fe es solo la mano], color: "suave"),
)
#let noche = (fondo: rgb("#1b1530"), acento: rgb("#ffb4a2"))

// story
#caso((1080, 1920), calvino, [la mano \ de Dios,], coda: [obrando su voluntad.])
// retrato
#caso((1080, 1350), calvino, [la mano \ de Dios,], coda: [obrando su voluntad.])
// cuadrado, clímax a la izquierda
#caso((1080, 1080), fe, [que la recibe.], alinear: left, ..noche)
// diapositiva 16:9 chica
#caso((1600, 900), calvino, [la mano de Dios,], coda: [obrando su voluntad.])
// diapositiva 16:9 Full HD, clímax a la derecha
#caso((1920, 1080), fe, [que la recibe.], alinear: right, ..noche)
