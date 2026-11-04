// Demo de carteles.mosaico() — diez líneas concéntricas (una «C» o una «U» a
// 45°) con círculos y un rombo; los tres colores del tema rotan de papel en
// las tres variantes. Es una portada gráfica: lleva `autor` (vertical al
// margen) y `obra` (al pie), no una frase. Pensado para vertical; en otros
// formatos la composición queda centrada y el color de fondo llena el resto.
// Compilar: typst compile --root . --font-path Fonts examples/presets/mosaico.typ
#import "../../src/lib.typ": *

#let caso(variante, ..args) = carteles.mosaico(
  autor: [B. B. Warfield], obra: [La imputación], variante: variante, ..args,
)

// las tres variantes, en el retrato 1080×1350, sin texto de cita
#caso("c")
#caso("u")
#caso("u-inversa")

// con texto, como en teselas: título, párrafo y una palabra pesada apilada.
// Cada variante lo pone donde el arte deja sitio.
#let frase = [El que tiene entendimiento, calcule el número de la bestia. No pide cómputo, pide sabiduría: ver con claridad lo que el mundo llama prudencia.]
#for v in ("c", "u", "u-inversa") {
  caso(v, frase: frase, etiqueta: [Apocalipsis 13:18], remate: [Sabiduría])
}

// el mismo motivo en story, con otra paleta por tema
#caso("u", formato: sizes.story,
  tema: (fondo: rgb("#f4f1de"), tinta: rgb("#1b1b1b"), suave: rgb("#8d99ae"),
         acento: rgb("#e9c46a"), hondo: rgb("#264653")))

// el texto busca el hueco que deja el arte en cada formato: en story sube a
// la banda de arriba, en cuadrado se aprieta, en apaisado va al lado
#caso("u", formato: sizes.story, frase: frase, etiqueta: [Apocalipsis 13:18], remate: [Sabiduría])
#caso("c", formato: sizes.instagram, frase: frase, etiqueta: [Gracia], remate: [Fe])
#caso("u-inversa", formato: sizes.twitter, frase: frase, etiqueta: [Apocalipsis 13:18], remate: [Sabiduría])
// título largo (se parte en dos líneas) y palabra larga (la pila cede)
#caso("u", frase: [Bienaventurados los de limpio corazón.], etiqueta: [La justicia imputada de Cristo], remate: [Entendimiento])
