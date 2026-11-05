// Demo de los estilos de epígrafe de la tanda C (src/carteles/_epigrafes-c.typ):
// aura, pizarra, vitral, luto y amanecer — los atmosféricos, cada uno con su
// fondo. Por estilo: el texto de prueba en vertical, una cita corta en
// cuadrado, una larga en story y la de prueba en cuadrado.
// Compilar: typst compile --root . --font-path Fonts examples/presets/epigrafes-c.typ
#import "../../src/carteles/_epigrafes-c.typ": estilos-c

#let prueba = (
  [«Cuando un pueblo ha de perecer en sus pecados, \ en la Iglesia comienza la lepra del alma.»],
  (autor: [Willem Bilderdijk], obra: [_Oprakeling_]),
)
#let corta = ([«Soli Deo gloria.»], (autor: [Lema de la Reforma], obra: none))
#let larga = (
  [«La Iglesia no es una sociedad de hombres piadosos que se reúnen por gusto, sino la congregación que Dios mismo llama, reúne, guarda y sostiene por su Palabra y su Espíritu hasta el fin.»],
  (autor: [Texto de prueba], obra: [_Cita larga, de unos doscientos caracteres_]),
)

#for nombre in ("aura", "pizarra", "vitral", "luto", "amanecer") {
  let estilo = estilos-c.at(nombre)
  estilo(prueba.at(0), ..prueba.at(1))
  estilo(corta.at(0), ..corta.at(1), formato: (1080, 1080))
  estilo(larga.at(0), ..larga.at(1), formato: (1080, 1920))
  estilo(prueba.at(0), ..prueba.at(1), formato: (1080, 1080))
}
