// Spec §1.2, criterio 5 — ningún elemento choca con la librería estándar de Typst.
// (El criterio vale para todos; esta prueba fija los nueve del 26 nov 2026 y los
// que ya estaban, más `calendar`, `clock`, `glyph` y `ruler` del 27 nov 2026.)
#import "../src/elements.typ"

#let nombres = dictionary(elements).keys().filter(n => not n.starts-with("_"))
#let choques = nombres.filter(n => n in dictionary(std))
#assert(choques == (), message: "elementos que tapan a la librería estándar: " + repr(choques))
#assert(nombres.len() == 30, message: "se esperaban 30 elementos definidos, hay " + str(nombres.len()) + ": " + repr(nombres))
ok
