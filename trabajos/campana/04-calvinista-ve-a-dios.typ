// Lámina 04 · «La teología de Calvino» · story 1080×1920
// Concepto: un mapa topográfico nocturno. Las curvas de nivel son los
// fenómenos del mundo, y todas se ordenan alrededor de una sola cumbre:
// ahí, donde se juntan, cae el clímax «la mano de Dios, obrando su
// voluntad». La frase baja por el vertical en escalones, en Literata.
// La composición es el preset carteles.escalera (src/escalera.typ), que
// nació de esta lámina (las curvas de nivel también son del preset).
// Posiciones fijas a mano, como se compuso.
// Compilar: typst compile --root . --font-path Fonts trabajos/campana/04-calvinista-ve-a-dios.typ trabajos/campana/04-calvinista-ve-a-dios.png
#import "../../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.story
#let fondo = rgb("#10302a")
#let curva = rgb("#8fb8a4")
#let crema = rgb("#efe8da")
#let salvia = rgb("#b9cfc3")
#let albaricoque = rgb("#f3c28e")

#carteles.escalera(
  (
    (texto: [El calvinista es el hombre], cuerpo: 64pt, y: 370pt, sangria: 0pt),
    (texto: [que ve a Dios], cuerpo: 104pt, peso: 600, tracking: -0.01em, y: 460pt, sangria: 150pt),
    (texto: [detrás de todos], estilo: "italic", y: 618pt, sangria: 40pt),
    (texto: [los fenómenos,], estilo: "italic", y: 698pt, sangria: 260pt),
    (texto: [y en todo lo que ocurre], cuerpo: 56pt, color: "suave", y: 870pt, sangria: 0pt),
    (texto: [reconoce], cuerpo: 56pt, color: "suave", y: 952pt, sangria: 330pt),
  ),
  [la mano \ de Dios,],
  coda: [obrando su voluntad.],
  formato: formatos.story,
  autor: [B. B. WARFIELD],
  obra: [La teología de Calvino],
  marca: logo(salvia, (ancho, alto)),
  cabecera-y: 110pt,
  climax-y: 1200pt,
  // curvas de nivel en su color, con la cumbre donde la puso la 04
  curvas: curva,
  cumbre: (560pt, 1370pt),
  anillos: 34,
)
