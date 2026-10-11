// Lámina 01 · «¿Qué es el calvinismo?» · retrato 1080×1350
// Concepto: cartel suizo. «PUREZA» ocupa todo el ancho en un solo rojo
// sobre papel casi blanco; el resto de la frase, pequeño y en sans, cuelga
// de una retícula de seis columnas visible. Nada más: la pureza es quitar.
// La composición es el preset carteles.suizo (src/carteles.typ), que
// nació de esta lámina.
// Compilar: typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ campana/01-calvinismo-pureza.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#carteles.suizo(
  [El calvinismo es simplemente la religión en su],
  [PUREZA.],
  formato: formatos.retrato,
  autor: [B. B. WARFIELD],
  fechas: [1851 – 1921],
  etiqueta: [DEL ENSAYO],
  planteo: [¿Qué es el calvinismo?],
  marca: logo(rgb("#141414"), formatos.retrato),
)
