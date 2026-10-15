// Lámina 16 · La polémica del pedobautismo · retrato 1080×1350
// Concepto: una línea de tiempo vertical sin cortes, de «Abraham · Génesis 17»
// arriba hasta «hoy» abajo. Las tres frases son estaciones sobre la línea; las
// muescas son generaciones. La última frase es el remate: nadie cortó la línea.
// La composición es el preset carteles.linea-tiempo (src/linea-tiempo.typ),
// que nació de esta lámina; las estaciones se reparten solas.
// Compilar: typst compile --root . --font-path Fonts trabajos/campana/16-iglesia-desde-abraham.typ trabajos/campana/16-iglesia-desde-abraham.png
#import "../../src/lib.typ": *
#import "_comun.typ": logo, formatos

#carteles.linea-tiempo(
  (
    [Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos.],
    [Deben permanecer allí hasta que Él los saque.],
  ),
  remate: [Él en ninguna parte los ha sacado.],
  origen: [Abraham · Génesis 17],
  fin: [Hoy],
  formato: formatos.retrato,
  autor: [B. B. Warfield],
  obra: [La polémica del pedobautismo],
  marca: logo(rgb("#2a2420"), formatos.retrato),
)
