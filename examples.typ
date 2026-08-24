#import "social.typ": *

// Post 1: Cita (Instagram cuadrado)
#quote-post(
  [El diseño no es cómo se ve algo. Es cómo funciona.],
  [Steve Jobs],
  "@mi_marca",
)

#pagebreak()

// Post 2: Anuncio (Instagram)
#announce-post(
  "NUEVO",
  [Lanzamos la versión 2.0],
  [Rediseñamos todo lo que te gustaba, y añadimos lo que pediste.],
  "@mi_marca",
)

#pagebreak()

// Post 3: Tip numerado (formato story)
#tip-card(
  3,
  [Publica a la misma hora cada día],
  [La constancia entrena al algoritmo... y a tu audiencia.],
  "@mi_marca",
  size: sizes.story,
  color: palette.secondary,
)
