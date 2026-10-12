// Demo del preset carteles.esquela (src/esquela.typ), nacido de la
// lámina 10: el aviso fúnebre de imprenta, con orla de luto o de
// fleurones, en varios formatos. Con los valores por omisión reproduce
// la lámina píxel a píxel.
// Compilar: typst compile --root . --font-path Fonts examples/presets/esquela.typ
#import "../../src/lib.typ": carteles, sizes

#let warfield = (autor: [B. B. Warfield], obra: [«Redentor» y «redención»])
#let frases = (
  anuncio: [Estamos asistiendo al lecho \ de muerte de una palabra.],
  duelo: [Y es triste presenciar la muerte \ de cualquier cosa valiosa.],
)

// La lámina: banda de luto y filete.
#carteles.esquela([Redención], ..frases, ..warfield)

// Banda de luto con crucetas por dentro.
#carteles.esquela([Redención], ..frases, ..warfield, interior: "crucetas")

// Orla de celosía, cuadrado; viñetas por nombre.
#carteles.esquela([Expiación], ..frases, ..warfield, formato: sizes.instagram,
  orla: "celosia", vineta: "trebol", vineta-pie: "cruz")

// Historia, orla de ojivas sin filete; nombre largo (se ajusta al ancho).
#carteles.esquela([Propiciación], ..frases, ..warfield, formato: sizes.story,
  orla: "ojivas", interior: none, papel: rgb("#ece6da"))
