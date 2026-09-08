// ─────────────────────────────────────────────────────────────
//  _comun.typ — receta compartida de las 20 tarjetas de la campaña Warfield
//
//  Lo único IDÉNTICO en las 20 tarjetas era: el handle
//  "presuposicionalismo.com" y pasar `theme: tema` una segunda vez a
//  cita-canvas (ya se le había pasado a blockquote-*() antes). Este
//  wrapper existe solo para no repetir esas dos cosas 20 veces — el resto
//  (paleta, tipografía, plantilla de blockquote, tamaño de canvas, colores
//  de fondo/blob/pie) sigue siendo decisión de cada tarjeta, no hay nada
//  que "adivinar" aquí.
//
//  El otro lado de la reducción de boilerplate (el `.with()` que fija
//  `theme:`/`color:` sobre blockquote-hero/editorial/etc.) NO vive acá:
//  ese es Typst nativo, cada tarjeta lo escribe con su propio blockquote-*
//  — no hace falta ninguna ayuda de este archivo para eso.
// ─────────────────────────────────────────────────────────────

#import "../src/lib.typ": cita-canvas, sizes

#let warfield-canvas(
  contenido, tema,
  size: sizes.instagram, bg-color: none, blob-color: white, footer-color: none,
) = cita-canvas(
  contenido,
  "presuposicionalismo.com",
  size: size,
  bg-color: bg-color,
  blob-color: blob-color,
  footer-color: footer-color,
  theme: tema,
)
