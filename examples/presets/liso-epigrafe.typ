// Demo de liso() con epígrafe: una cita breve que abre la pieza, arriba, más
// chica y en cursiva, con su fuente; el texto principal se centra en lo que
// queda. Vale para cualquier fondo, formato y alineación.
// Compilar: typst compile --root . --font-path Fonts examples/presets/liso-epigrafe.typ
#import "../../src/lib.typ": *

// retrato, a la izquierda
#carteles.liso(
  [Estamos asistiendo al lecho de muerte de una palabra.],
  fondo: rgb("#1d4ed8"), autor: [B. B. Warfield],
  epigrafe: [«Un solo Señor, una sola fe, un solo bautismo.»], epigrafe-fuente: [Efesios 4:5],
)

// centrado, sobre papel
#carteles.liso(
  [Todo es gracia.],
  fondo: rgb("#f3ece2"), alinear: center,
  epigrafe: [«Por gracia sois salvos por medio de la fe.»], epigrafe-fuente: [Efesios 2:8],
)

// story, sin fuente
#carteles.liso(
  [Soli Deo gloria.],
  fondo: rgb("#14213d"), formato: (1080, 1920),
  epigrafe: [Para que en todo Dios sea glorificado.],
)

// apaisado, con la marca abajo
#carteles.liso(
  [La política no tiene nada que ver con la realidad.],
  fondo: rgb("#14110f"), formato: (1600, 900), marca: marca.texto("@iglesiaraah"),
  epigrafe: [«Lo que el hombre piensa carece de todo efecto.»], epigrafe-fuente: [Jacques Ellul],
)
