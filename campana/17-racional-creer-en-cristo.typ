// Lámina 17 · Apologética · cuadrado 1080×1080
// Concepto: la cita como una demostración numerada, en pizarra oscura. «racional»
// es la línea que se sostiene (⊢, sólida, enorme); «irracional» es la que no se
// sigue (⊬): su prefijo «ir» queda en contorno y tachado.
// La composición es el preset carteles.demostracion (src/carteles.typ), que
// nació de esta lámina.
// Compilar: typst compile --root . --font-path Fonts campana/17-racional-creer-en-cristo.typ campana/17-racional-creer-en-cristo.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let pizarra = rgb("#0d1014")
#let tiza = rgb("#f4f1ea")
#let apagado = rgb("#8b95a1")
#let ambar = rgb("#f2b33d")

// «ir» en contorno y tachado
#let ir = carteles.rayar(color: ambar, vaciar: (fondo: pizarra, contorno: 3.5pt + apagado))[ir]

#carteles.demostracion(
  (
    ([Creemos en Cristo porque es], (afirma: [racional]), [creer en él,]),
    ([no aunque sea], (niega: [#ir#h(0.03em)#text(fill: apagado)[racional.]])),
  ),
  formato: formatos.instagram,
  autor: [B. B. Warfield],
  obra: [Apologética],
  marca: logo(tiza, formatos.instagram),
)
