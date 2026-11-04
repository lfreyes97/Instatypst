// Temas de lámina en carteles.suizo — el mismo cartel con cuatro paletas.
// El tema fija los roles (fondo, tinta, suave, acento); los parámetros
// viejos (`acento:`, `papel:`…) siguen mandando sobre él.
// Compilar: typst compile --root . --font-path Fonts examples/presets/suizo-temas.typ
#import "../../src/lib.typ": *

#let caso(..args) = carteles.suizo(
  [El calvinismo es simplemente la religión en su], [PUREZA.],
  formato: sizes.instagram, autor: [B. B. WARFIELD], fechas: [1851 – 1921],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?], ..args,
)

// 1. el tema por defecto ("suizo")
#caso()

// 2. un tema parcial: lo que falta sale del tema por defecto
#caso(tema: (fondo: rgb("#10302a"), tinta: rgb("#efe8da"), suave: rgb("#b9cfc3"), acento: rgb("#f3c28e"), linea: rgb("#1d4a40")))

// 3. desde un `theme` del sistema, igual que las citas y social
#caso(tema: carteles.tema-desde-theme(theme.base))

// 4. el tema por defecto, con un solo color retocado por parámetro
#caso(acento: rgb("#1d4ed8"))
