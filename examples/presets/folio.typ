// Demo del preset carteles.folio (src/folio.typ), nacido de la lámina
// 11: el folio de salterio, con capitular iluminada y glosa al margen.
// Con los valores por omisión reproduce la lámina píxel a píxel.
// Compilar: typst compile --root . --font-path Fonts examples/presets/folio.typ
#import "../../src/lib.typ": carteles, sizes

#let rojo = rgb("#9e2219")

// La lámina.
#carteles.folio(
  [Solo el santo sabe qué es el pecado; #text(fill: rojo)[solo] el gozo que se pierde y luego se vuelve a encontrar se comprende plenamente.],
  glosa: ([Salmo], [51]),
  autor: [B. B. Warfield],
)

// Cabecera de lises; texto más largo (el cuerpo se ajusta solo).
#carteles.folio(
  [Crea en mí, oh Dios, un corazón limpio, y renueva un espíritu recto dentro de mí. No me eches de delante de ti, y no quites de mí tu santo Espíritu. Vuélveme el gozo de tu salvación.],
  glosa: ([Salmo], [51]),
  cabecera: "lises",
  autor: [Reina-Valera],
)

// Retrato, cabecera de crestería.
#carteles.folio(
  [Lávame más y más de mi maldad, y límpiame de mi pecado. Porque yo reconozco mis rebeliones, y mi pecado está siempre delante de mí.],
  glosa: ([Salmo], [51]),
  formato: (1080, 1350),
  cabecera: "cresteria",
  relleno: "c",
  autor: [Reina-Valera],
)
