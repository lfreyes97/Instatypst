// Demo de carteles.epigrafe: los quince estilos con el mismo epígrafe.
// Compilar: typst compile --root . --font-path Fonts examples/presets/epigrafe.typ
#import "../../src/lib.typ": carteles

#let cita = [«Cuando un pueblo ha de perecer en sus pecados, \ en la Iglesia comienza la lepra del alma.»]
#for e in carteles.estilos-epigrafe.keys() {
  carteles.epigrafe(cita, autor: [Willem Bilderdijk], obra: [_Oprakeling_], estilo: e)
}
