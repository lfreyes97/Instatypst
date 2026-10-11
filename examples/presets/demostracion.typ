// Demo de carteles.demostracion() y carteles.rayar() — la cita como
// demostración numerada: (afirma: …) va enorme con ⊢, (niega: …) con ⊬,
// y una raya de deducción separa los grupos. Ver src/carteles.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/demostracion.typ
#import "../../src/lib.typ": *

#let marca = text(font: "DM Mono", size: 18pt, fill: rgb("#f4f1ea"))[TU MARCA]
#let ir = carteles.rayar(color: rgb("#f2b33d"), vaciar: (fondo: rgb("#0d1014"), contorno: 3.5pt + rgb("#8b95a1")))[ir]
#let caso(formato, grupos, ..args) = carteles.demostracion(
  grupos, formato: formato, autor: [B. B. Warfield], obra: [Apologética], marca: marca, ..args,
)
#let racional = (
  ([Creemos en Cristo porque es], (afirma: [racional]), [creer en él,]),
  ([no aunque sea], (niega: [#ir#text(fill: rgb("#8b95a1"))[racional.]])),
)

// dos grupos, prefijo vaciado y tachado recto
#caso(sizes.instagram, racional)
#caso(sizes.story, racional)
#caso(sizes.twitter, racional)

// un solo grupo, tachado a lápiz
#caso(sizes.instagram, (
  [Si Dios es soberano,], [y el hombre es responsable,], [entonces la gracia es],
  (afirma: [eficaz]),
  [y no un mero],
  (niega: [#carteles.rayar(trazo: "lapiz")[intento.]]),
))
