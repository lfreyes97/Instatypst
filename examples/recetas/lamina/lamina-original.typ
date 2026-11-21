// lamina / ORIGINAL — el demo de src/lamina.typ (examples/presets/lamina.typ), tal cual.
#import "../../../src/lamina.typ": lamina

#let marca = text(
  font: "Jost",
  size: 26pt,
  weight: 700,
  tracking: 0.1em,
)[\@IGLESIARAAH]

#let serie = (
  (
    [Cinco razones para leer la Biblia],
    [Una serie breve para quien quiere empezar y no sabe por dónde.],
  ),
  (
    [Porque Dios habla en ella],
    [La Escritura no es un libro sobre Dios solamente: es Dios hablando a su pueblo.],
  ),
  (
    [Porque nos enseña a vivir],
    [Toda la Escritura es útil para enseñar, redargüir, corregir e instruir en justicia.],
  ),
  (
    [Porque nos lleva a Cristo],
    [Todo el Antiguo Testamento espera al Mesías y todo el Nuevo lo anuncia.],
  ),
)
#for (i, (t, x)) in serie.enumerate() {
  lamina(i + 1, serie.len(), t, texto: x, marca: marca)
}

// story (9:16), una página intermedia de una serie larga: «03 / 12»
#lamina(
  3,
  12,
  [Porque nos enseña a vivir],
  texto: [Toda la Escritura es útil para enseñar, redargüir, corregir e instruir en justicia.],
  formato: (1080, 1920),
  marca: marca,
)

// cuadrado, título muy largo: se achica para caber
#lamina(
  2,
  5,
  [Porque en ella Dios nos muestra quién es, qué ha hecho y qué espera de nosotros],
  formato: (1080, 1080),
  marca: marca,
)
