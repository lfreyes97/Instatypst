// Demo de los estilos de epígrafe de la tanda A (src/carteles/_epigrafes-a.typ):
// pergamino, portada, lápida, epístola y cartela. Por estilo: la cita de prueba
// en vertical 1080×1350, una cita corta en cuadrado y una larga en story.
// Compilar: typst compile --root . --font-path Fonts examples/presets/epigrafes-a.typ
#import "../../src/lib.typ": sizes
#import "../../src/carteles/_epigrafes-a.typ": estilos-a

#let cita = [Cuando un pueblo ha de perecer en sus pecados, \ en la Iglesia comienza la lepra del alma.]
#let autor = [Willem Bilderdijk]
#let obra = [_Oprakeling_]

#let corta = [En la Iglesia comienza la lepra del alma.]
#let larga = [Casi toda la suma de nuestra sabiduría, que de veras merezca ser tenida por verdadera y sólida sabiduría, consiste en dos puntos: en el conocimiento que el hombre debe tener de Dios, y en el conocimiento que debe tener de sí mismo.]
#let autor-larga = [Juan Calvino]
#let obra-larga = [_Institución de la religión cristiana_]

#let marca = text(font: "Outfit", size: 14pt, weight: 700, tracking: 0.12em)[TU MARCA]

#for nombre in ("pergamino", "portada", "lapida", "epistola", "cartela") {
  let estilo = estilos-a.at(nombre)
  estilo(cita, autor: autor, obra: obra)
  estilo(corta, autor: autor, obra: obra, formato: sizes.instagram)
  estilo(larga, autor: autor-larga, obra: obra-larga, formato: sizes.story, marca: marca)
}
