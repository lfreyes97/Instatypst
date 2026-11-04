// Demo de carteles.teselas() — un bloque de teselas (discos y «dianas») en
// tres colores que rotan de fondo y de figura, con título, párrafo y una palabra
// pesada apilada a la derecha (dos letras por línea). Pensado para vertical; en
// otros formatos la lámina queda centrada y el color del papel llena el resto.
// Compilar: typst compile --root . --font-path Fonts examples/presets/teselas.typ
#import "../../src/lib.typ": *

#let marca = text(font: "Outfit", size: 14pt, weight: 700, tracking: 0.12em)[TU MARCA]
#let frase = [El que tiene entendimiento, calcule el número de la bestia. No pide cómputo, pide sabiduría: ver con claridad lo que el mundo llama prudencia.]

// el retrato 1080×1350, con autor
#carteles.teselas(frase, etiqueta: [Apocalipsis 13:18], remate: [Sabiduría], autor: [B. B. Warfield], marca: marca)

// cuadrado
#carteles.teselas(frase, etiqueta: [Sabiduría], remate: [Pureza], formato: sizes.instagram)

// story, paleta propia por tema (verde azulado, naranja y arena)
#carteles.teselas(frase, etiqueta: [Gracia], remate: [Gracia], formato: sizes.story,
  tema: (fondo: rgb("#fbfaf5"), tinta: rgb("#14213d"), suave: rgb("#5b6478"),
         acento: rgb("#e76f51"), hondo: rgb("#264653"), claro: rgb("#f4e3b1")))

// sin párrafo corto: la frase larga se achica para caber
#carteles.teselas([#frase #frase], etiqueta: [Una frase muy larga], remate: [Fe], autor: [Autor])

// palabra larga: la pila se escala para no pasar sobre el bloque; `cuerpo` agranda el párrafo
#carteles.teselas(frase, etiqueta: [Tres palabras], remate: [Entendimiento], cuerpo: 9)
