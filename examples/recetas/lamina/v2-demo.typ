// lamina / ENGINE_V2 — las mismas seis láminas con el contrato: `repeat` para la serie
// (index y total salen solos) y un frame suelto para cada página aislada.
#import "../../../core/v2/frame.typ": frame
#import "../../../core/v2/series.typ": title, detail

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

// la serie: cuatro láminas, una por elemento
#frame(type: "series", repeat: serie, brand: marca, ((t, x)) => { title(t); detail(x) })

// story (9:16), una página intermedia de una serie larga: «03 / 12»
#frame(type: "series", format: (1080, 1920), index: 3, total: 12, brand: marca)[
  #title[Porque nos enseña a vivir]
  #detail[Toda la Escritura es útil para enseñar, redargüir, corregir e instruir en justicia.]
]

// cuadrado, título muy largo: se achica para caber
#frame(type: "series", format: (1080, 1080), index: 2, total: 5, brand: marca)[
  #title[Porque en ella Dios nos muestra quién es, qué ha hecho y qué espera de nosotros]
]
