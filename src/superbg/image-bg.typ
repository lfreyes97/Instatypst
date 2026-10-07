// ─────────────────────────────────────────────────────────────
//  superbg / image-bg.typ — NIVEL 2: imagen con overlay/tinte
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes

// Foto a sangre completa + velo de color encima para legibilidad.
// `ruta:` BYTES leídos por el llamador (recomendado) o string.
//   Recomendado (el path se resuelve donde lo escribes, no dentro del
//   paquete): #bg-imagen(read("Assets/foto.jpg", encoding: none))
//   Un string crudo ("Assets/foto.jpg") se resolvería relativo a ESTE
//   archivo dentro del paquete — no hace lo que esperas. Se acepta igual
//   por compatibilidad, pero documenta bytes como forma correcta.
// `overlay:` color del velo; `opacidad:` cuánto cubre (0% = foto pura).
// `tinte:` alternativa rápida: tiñe la foto mezclando overlay + foto.
// `fit:` pasa directo a image() ("cover" | "contain" | "stretch").
#let bg-imagen(ruta, overlay: black, opacidad: 45%, tinte: none, fit: "cover") = {
  let velo = if tinte != none { tinte } else { overlay }
  place(block(width: 100%, height: 100%, clip: true)[
    #image(ruta, width: 100%, height: 100%, fit: fit)
    #place(rect(width: 100%, height: 100%, fill: velo.transparentize(100% - opacidad)))
  ])
}
