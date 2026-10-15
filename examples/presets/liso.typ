// Demo de carteles.liso() — fondo sólido + texto, nada más. El texto
// toma el mayor cuerpo que cabe; la tinta sale sola (blanco o negro)
// según el fondo. Ver src/carteles.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/liso.typ
#import "../../src/lib.typ": carteles, sizes

#let marca = text(font: "Inter", size: 18pt, weight: 700, tracking: 0.12em)[TU MARCA]

// retrato, frase corta: grita
#carteles.liso([Todo es gracia.], marca: marca)

// cuadrado, fondo claro (tinta negra sola), con autor
#carteles.liso(
  [El calvinismo es simplemente la religión en su pureza.],
  formato: sizes.instagram, autor: [B. B. Warfield],
  fondo: rgb("#f2b33d"), marca: marca,
)

// story, frase larga, centrada, serif
#carteles.liso(
  [Estamos asistiendo al lecho de muerte de una palabra. Y es triste presenciar la muerte de cualquier cosa valiosa.],
  formato: sizes.story, autor: [B. B. Warfield], alinear: center,
  fondo: rgb("#1d4ed8"), fuente: "Baskervville", peso: 400, marca: marca,
)

// apaisado
#carteles.liso([Solo el santo sabe qué es el pecado.], formato: sizes.twitter,
  fondo: rgb("#c8102e"))

// ── con superbg: el mismo preset sobre cualquier fondo ──

// papel viejo, IM FELL, tinta gastada
#carteles.liso(
  [Estamos asistiendo al lecho de muerte de una palabra.],
  fondo: "papel-viejo", fuente: "IM FELL English", peso: 400,
  autor: [B. B. Warfield], desgaste: 0.5, marca: marca,
)

// papel escaneado (sombra del lomo), centrado, más gastado
#carteles.liso(
  [Nisi credideritis, non intelligetis.],
  formato: sizes.instagram, fondo: "papel-escaneado", alinear: center,
  fuente: "IM FELL English", peso: 400, autor: [Isaías 7:9 (Vulgata)], desgaste: 0.85,
)

// capa de papel a mano: más amarillo, sin óxido, lomo arriba; sans
#carteles.liso(
  [Todo es gracia.],
  fondo: (tipo: "papel", color: rgb("#e8d9b0"), oxido: 0, escaneo: true, lomo: "derecha"),
  desgaste: 0.3,
)

// cualquier otro preset de superbg (la tinta sale del color de base)
#carteles.liso([Solo el santo sabe qué es el pecado.], formato: sizes.instagram, fondo: "noche")
