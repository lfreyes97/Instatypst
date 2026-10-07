// Capitulares iluminadas de EB Garamond Initials (dos capas SVG).
// Página 1: el set completo para revisar letra por letra (el repo de
// origen avisa que la calidad varía). Página 2: en párrafo, incluidos
// los casos que caen a capitular() normal (G, T, puntuación inicial).
// Compilar: typst compile --root . --font-path Fonts examples/capitulares-ornamentadas.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "terracota")

#set page(paper: "a4", margin: 2cm)
#set text(font: "EB Garamond", size: 11pt, lang: "es")
#set par(justify: true)

= Set completo

#let letras = "ABCDEFHIJKLMNOPQRSUVWXYZÄÖÜ".clusters()
#grid(
  columns: 6, gutter: 10pt,
  ..letras.map(c => align(center)[
    #inicial-ornamentada(c, size: 70pt, theme: tema)
    #text(size: 8pt, fill: gray, c)
  ]),
)

#pagebreak()
= En párrafo

#let relleno = lorem(70)

#capitular-ornamentada(theme: tema)[En el principio era el Verbo, y el Verbo era con Dios, y el Verbo era Dios. #relleno]

#capitular-ornamentada(alto: 4, theme: tema, ornamento: tema.colors.secondary)[Señor, tú nos has sido refugio de generación en generación. #relleno]

Sin ilustración (G, T y puntuación inicial caen a `capitular()`):

#capitular-ornamentada(theme: tema)[Gracia y paz a vosotros, de Dios nuestro Padre. #relleno]

#capitular-ornamentada(theme: tema)[«Todo lo puedo en Cristo que me fortalece.» #relleno]
