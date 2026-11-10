// El epígrafe de Bilderdijk como esquela (carteles.esquela): el «nombre»
// es el remate de la propia frase, así nada se repite.
// Compilar: typst compile --root . --font-path Fonts examples/epigrafe-esquela.typ
#import "../src/lib.typ": carteles

#let bilderdijk = (autor: [Willem Bilderdijk], obra: [_Oprakeling_])
#let antes = [Cuando un pueblo ha de perecer \ en sus pecados, \ en la Iglesia comienza]

// A · Banda de luto y filete.
#carteles.esquela([La lepra del alma], anuncio: antes, ..bilderdijk)

// B · Orla de celosía.
#carteles.esquela([La lepra del alma], anuncio: antes, ..bilderdijk,
  orla: "celosia", interior: "crucetas")

// C · Sin cruz, orla de ojivas: más sobria.
#carteles.esquela([La lepra del alma], anuncio: antes, ..bilderdijk,
  orla: "ojivas", interior: none, simbolo: none)
