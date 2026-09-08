// Recreación del ejemplo de referencia del usuario (callout gris con
// #orn[...] y tipografía cambiada a mano dentro del body), pero con la API
// real de este paquete:
//   - `quote` = blockquote-callout.with(...) -> tu patrón #let quote =
//     callout.with(...) YA funciona hoy, es .with() nativo de Typst.
//   - orn() en vez de la fuente "Orments" (registrada en font-tokens.typ
//     pero sin archivo en Fonts/ — dingbat de una sola letra por floritura,
//     no hay como sustituirla sin esa fuente exacta). orn() usa fleurons
//     Unicode reales ya cubiertos por tipografía que SÍ está en el proyecto.
//   - Lexend/League Spartan del original -> Hanken Grotesk / Jost (ya en
//     el proyecto, mismo espíritu: humanista redondeada / geométrica).
//   - El cambio de tipografía a mitad del body es un #set text() normal,
//     escrito DENTRO del contenido que le pasas a `quote` — nada en
//     blockquote-callout tuvo que cambiar para permitirlo.
// Compilar: typst compile --root . --font-path Fonts examples/cita-onfly.typ
#import "../src/lib.typ": *

#set page(paper: "iso-b6", margin: 5mm, fill: luma(250))

#let quote = blockquote-callout.with(titulo: "Quote", icono: "❞", color: luma(80))

#quote[
  #set text(font: font-tokens.family("hanken-grotesk"), size: 13pt)
  #set par(justify: false, leading: 0.6em)
  #v(4%)
  Este optimismo, que caracteriza precisamente a la filosofía de las Luces y
  al cientificismo del siglo XIX, carece ya de actualidad. Después de las
  catástrofes de que ha sido testigo el siglo XX, la razón ha perdido su
  dimensión positiva y se ataca en tanto que instrumento de dominio
  responsable y burocrático, y nuestra relación con los tiempos, y
  concretamente con el futuro, está ya marcada por esta crítica, aun cuando
  perduren, en el fondo, restos del pasado optimismo, sobre todo en el
  plano tecnocientífico. Desacreditados el pasado y el futuro, se tiende a
  pensar que el presente es la referencia esencial de los individuos
  democráticos, puesto que éstos han roto definitivamente con las
  tradiciones que barrió la modernidad y están de vuelta de esos mañanas
  que apenas se han ensalzado.

  #v(6pt)
  #set text(font: font-tokens.family("jost"))
  #orn[flor] Sébastien Charles \
  #orn[cierre] _*Los tiempos hipermodernos*_
  #v(2%)
]
