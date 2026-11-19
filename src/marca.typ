// ─────────────────────────────────────────────────────────────
//  marca.typ — la marca (logo, handle) como función (color, lienzo) → contenido
//
//  Los presets no conocen a nadie: reciben `marca:` y la colocan. Pero el
//  color de la marca depende del fondo, y el fondo lo resuelve el preset por
//  dentro; por eso `marca:` puede ser, además de un contenido ya hecho, una
//  FUNCIÓN `(color, lienzo) -> contenido` que el preset llama con su propia
//  tinta y con el formato en px. Este módulo construye esas funciones.
//
//    #import "@local/instatypst:0.1.0": *
//    carteles.suizo(…, marca: marca.texto("@iglesiaraah"))
//    carteles.suizo(…, marca: marca.svg(read("/assets/Logo.svg")))
//    carteles.suizo(…, marca: marca.imagen(read("/assets/logo.png", encoding: none)))
//    carteles.suizo(…, marca: mi-logo)        // tu propia función (color, lienzo)
//
//  Tamaño: el alto de la marca es una fracción de √(ancho × alto) del lienzo
//  (por omisión 1/30: 36 pt en 1080×1080), así pesa lo mismo en un cuadrado,
//  un retrato, una story o un apaisado.
//
//  Las rutas las lee quien llama (`read` se resuelve relativo al archivo que
//  lo escribe, no a este módulo): aquí llegan ya los datos.
// ─────────────────────────────────────────────────────────────

#let proporcion = 1 / 30

// Alto de la marca para un lienzo (ancho, alto) en px.
#let alto(lienzo, proporcion: proporcion) = calc.sqrt(lienzo.at(0) * lienzo.at(1)) * proporcion * 1pt

// Una marca de texto (el handle): el cuerpo es una parte del alto de la marca.
#let texto(contenido, proporcion: proporcion, fuente: "Jost", peso: 700, tracking: 0.1em) = (color, lienzo) => {
  text(font: fuente, weight: peso, size: alto(lienzo, proporcion: proporcion) * 0.62, tracking: tracking, fill: color, contenido)
}

// Un SVG: `datos` es su texto (`read("/assets/Logo.svg")`). Se recolorea con el
// color de la marca sustituyendo `currentColor`, que es lo que usan los logos
// pensados para heredar el color del texto.
#let svg(datos, proporcion: proporcion) = (color, lienzo) => {
  assert(
    datos.contains("currentColor"),
    message: "marca.svg: el SVG no usa `currentColor`, así que no se puede recolorear; usa marca.imagen",
  )
  image(
    bytes(datos.replace("currentColor", color.to-hex())),
    format: "svg",
    height: alto(lienzo, proporcion: proporcion),
  )
}

// Una imagen de mapa de bits (o un SVG que no se recolorea): `datos` son sus
// bytes (`read("/assets/logo.png", encoding: none)`).
#let imagen(datos, proporcion: proporcion) = (color, lienzo) => {
  image(datos, height: alto(lienzo, proporcion: proporcion))
}
