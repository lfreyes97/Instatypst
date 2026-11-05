// Demo de los estilos de epígrafe B (src/carteles/_epigrafes-b.typ): hojas,
// bauhaus, arcos, malla y lineas. Por estilo: la cita de prueba en vertical,
// cuadrado y story; una cita corta y una larga en vertical; y una con otro tema.
// Compilar: typst compile --root . --font-path Fonts examples/presets/epigrafes-b.typ
#import "../../src/carteles/_epigrafes-b.typ": estilos-b

#let cita = [«Cuando un pueblo ha de perecer en sus pecados, \ en la Iglesia comienza la lepra del alma.»]
#let autor = [Willem Bilderdijk]
#let obra = [_Oprakeling_]
#let corta = [«Soli Deo gloria.»]
#let larga = [«No hay un solo centímetro cuadrado en todo el dominio de la existencia humana sobre el cual Cristo, que es soberano sobre todo, no clame: ¡Mío! Y nada queda fuera de su mano.»]

#for (nombre, estilo) in estilos-b {
  estilo(cita, autor: autor, obra: obra)
  estilo(cita, autor: autor, obra: obra, formato: (1080, 1080))
  estilo(cita, autor: autor, obra: obra, formato: (1080, 1920))
  estilo(corta, autor: autor, obra: obra)
  estilo(larga, autor: [Abraham Kuyper], obra: [_Soberanía de las esferas_])
}

// otros temas: un nombre del registro y un diccionario parcial
#(estilos-b.hojas)(cita, autor: autor, obra: obra, tema: (fondo: rgb("#f4efe4"), tinta: rgb("#1b1b1b")))
#(estilos-b.lineas)(cita, autor: autor, obra: obra, tema: "escalera")
#(estilos-b.malla)(cita, autor: autor, obra: obra, formato: (1600, 900))
