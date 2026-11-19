// Demo de `marca`: la marca como función (color, lienzo) → contenido. El
// preset la llama con su propia tinta, así que el mismo logo sale blanco sobre
// fondo oscuro y negro sobre fondo claro, y pesa lo mismo (1/30 de √área) en
// cualquier formato. Ver src/marca.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/marca.typ
#import "../../src/lib.typ": *

#let frase = [Todo es gracia.]

// texto, sobre un tema oscuro y uno claro
#carteles.suizo(frase, [GRACIA.], formato: (1080, 1350), tema: "suizo", marca: marca.texto("@iglesiaraah"))
#carteles.liso(frase, fondo: rgb("#f3ece2"), marca: marca.texto("@iglesiaraah"))

// SVG recoloreado: el mismo archivo, con la tinta de cada preset
#let logo = marca.svg(read("/examples/assets/logo-demo.svg"))
#carteles.liso(frase, fondo: rgb("#1d4ed8"), marca: logo)
#carteles.liso(frase, fondo: rgb("#f3ece2"), marca: logo)

// la misma marca en tres formatos: pesa lo mismo respecto del lienzo
#carteles.liso(frase, fondo: rgb("#14213d"), formato: (1080, 1080), marca: logo)
#carteles.liso(frase, fondo: rgb("#14213d"), formato: (1080, 1920), marca: logo)
#carteles.liso(frase, fondo: rgb("#14213d"), formato: (1600, 900), marca: logo)

// imagen de mapa de bits: se coloca tal cual
#carteles.liso(frase, fondo: rgb("#14213d"), marca: marca.imagen(read("/examples/avatar.jpg", encoding: none)))

// tu propia función (color, lienzo): aquí, un sello dibujado con el color recibido
#carteles.liso(frase, fondo: rgb("#14213d"), marca: (color, lienzo) => circle(
  radius: marca.alto(lienzo) / 2, fill: color, align(center + horizon, text(fill: rgb("#14213d"), weight: 800)[R])))

// un contenido ya hecho sigue valiendo, como siempre
#carteles.liso(frase, fondo: rgb("#14213d"), marca: text(fill: white, weight: 700)[CONTENIDO])
