// Demo de quote-social() — cita con foto real (Assets/avatar.jpg), resaltado
// nativo con #highlight(), y las dos posiciones de atribucion: (declarativo,
// no hay que reordenar nada a mano — solo cambia el parámetro).
// Compilar: typst compile --root . examples/quote-social.typ
#import "../src/lib.typ": *

// atribucion: "abajo" (default) — foto+nombre después de la cita
#quote-social(
  [Una obra pseudónima que presenta una síntesis neoplatónica cristianizada bajo el nombre de un discípulo de los apóstoles adquiere autoridad precisamente por una identidad apostólica que no posee. Si esa obra contribuye posteriormente a consolidar determinadas estructuras metafísicas de la teología y liturgia medieval, uno puede describir teológicamente esa falsificación como una #highlight[obra diabólica]: no porque podamos demostrar la agencia personal del diablo, sino porque el mecanismo es exactamente el tipo de engaño que la teología cristiana atribuye a Satanás.],
  "Luis Felipe Reyes de los Reyes",
  iniciales: "LR",
  atribucion: "arriba",
  foto: "/Assets/avatar.jpg",
  color: rgb("#13ddab"),
  size: sizes.story,
)
