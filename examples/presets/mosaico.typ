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

// las tres variantes, en el retrato 1080×1350
#caso("c")
#caso("u")
#caso("u-inversa")

// el mismo motivo en story, con otra paleta por tema
#caso("u", formato: sizes.story,
  tema: (fondo: rgb("#f4f1de"), tinta: rgb("#1b1b1b"), suave: rgb("#8d99ae"),
         acento: rgb("#e9c46a"), hondo: rgb("#264653")))
