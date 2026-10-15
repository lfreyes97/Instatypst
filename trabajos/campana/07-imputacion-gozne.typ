// Lámina 07 · «La imputación» · twitter 1600×900
// Lámina de dibujo técnico: a la izquierda la cita entera; a la derecha un
// gozne visto desde arriba —el perno rojo es la imputación— con las tres
// doctrinas como hojas que giran sobre él, numeradas igual que en la cita.
// La composición es el preset carteles.gozne (src/gozne.typ), que nació
// de esta lámina; diagrama y rótulos se ubican solos.
// Compilar: typst compile --root . --font-path Fonts trabajos/campana/07-imputacion-gozne.typ trabajos/campana/07-imputacion-gozne.png
#import "../../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let bermellon = rgb("#a8361f")
#let llamada = carteles.llamada

#carteles.gozne(
  [#text(fill: bermellon)[\[La imputación\]] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza#llamada(1), la satisfacción de Cristo#llamada(2), la justificación por la fe#llamada(3)— y la guardiana de su pureza.],
  [La \ imputación],
  ([La pecaminosidad \ de la raza], [La satisfacción \ de Cristo], [La justificación \ por la fe]),
  formato: formatos.twitter,
  autor: [B. B. Warfield],
  obra: [La imputación],
  marca: logo(rgb("#1f262d"), formatos.twitter),
)
