// Capitulares iluminadas de EB Garamond Initials, con estilos de grabado
// de imprenta clásica (ss. XVI–XVII).
// Página 1: el set completo (una tinta) para revisar letra por letra.
// Página 2: los cuatro estilos, limpios y con desgaste.
// Página 3: en párrafo, incluida la puntuación colgada y una acentuada
// que cae a capitular() normal.
// Compilar: typst compile --root . --font-path Fonts examples/capitulares-ornamentadas.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "terracota")

#set page(paper: "a4", margin: 2cm, fill: rgb("#f3ecdc"))
#set text(font: "EB Garamond", size: 11pt, lang: "es", fill: rgb("#2a231c"))
#set par(justify: true)

= Set completo

#let letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ".clusters()
#grid(
  columns: 6, gutter: 10pt,
  ..letras.map(c => align(center)[
    #inicial-ornamentada(c, size: 70pt)
    #text(size: 8pt, fill: gray, c)
  ]),
)

#pagebreak()
= Estilos

#let estilos = ("una-tinta", "invertida", "rubricada", "tema")
#grid(
  columns: 4, gutter: 14pt, align: center,
  ..estilos.map(e => inicial-ornamentada("E", size: 100pt, estilo: e, theme: tema)),
  ..estilos.map(e => inicial-ornamentada("G", size: 100pt, estilo: e, theme: tema, desgaste: 1)),
  ..estilos.map(e => raw(e)),
)

#v(1em)
Fila de arriba limpia; fila de abajo con `desgaste: 1`. Sin marco:

#grid(
  columns: 4, gutter: 14pt, align: center,
  ..estilos.map(e => inicial-ornamentada("R", size: 100pt, estilo: e, theme: tema, marco: false, desgaste: 0.5)),
)

#pagebreak()
= En párrafo

#let relleno = lorem(60)

#capitular-ornamentada[En el principio era el Verbo, y el Verbo era con Dios, y el Verbo era Dios. #relleno]

#capitular-ornamentada(estilo: "rubricada", desgaste: 0.6)[Señor, tú nos has sido refugio de generación en generación. #relleno]

#capitular-ornamentada(estilo: "invertida", alto: 4)[Gracia y paz a vosotros, de Dios nuestro Padre. #relleno]

#capitular-ornamentada(estilo: "rubricada")[«Todo lo puedo en Cristo que me fortalece.» #relleno]

Las acentuadas (Á, É, Ñ…) caen a `capitular()` con el color de la letra del estilo:

#capitular-ornamentada(estilo: "rubricada")[Él es antes de todas las cosas, y todas las cosas en él subsisten. #relleno]
