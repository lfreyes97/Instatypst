// ─────────────────────────────────────────────────────────────
//  artboard.typ — el lienzo: nombres de formato, tamaño y unidad
//
//  Un artboard es un nombre de `formats`, un (ancho, alto) en px, o `auto`
//  (= "retrato"). La unidad `u` es el lado corto entre 1080: en la API un
//  NÚMERO es una cantidad en u (`margin: 96`) y una LONGITUD es absoluta
//  (`margin: 96pt`). Typst no permite unidades propias, así que `66u` de la
//  spec se escribe `66`.
// ─────────────────────────────────────────────────────────────

#let formats = (
  retrato: (1080, 1350),
  cuadrado: (1080, 1080),
  instagram: (1080, 1080),
  story: (1080, 1920),
  twitter: (1600, 900),
  linkedin: (1200, 1200),
)

#let resolve-artboard(artboard) = {
  if artboard == auto { formats.retrato } else if type(artboard) == str {
    if not artboard in formats {
      panic("frame: artboard desconocido " + repr(artboard) + " (hay: " + formats.keys().join(", ") + "; o pasa (ancho, alto))")
    }
    formats.at(artboard)
  } else if type(artboard) == array and artboard.len() == 2 { artboard } else {
    panic("frame: `artboard` es un nombre, un (ancho, alto) o auto, no " + repr(artboard))
  }
}

// Tamaño del lienzo en pt, desde px.
#let dimensions(size) = (size.at(0) * 1pt, size.at(1) * 1pt)

// La unidad u como longitud: lado corto / 1080.
#let unit(size) = calc.min(size.at(0), size.at(1)) / 1080 * 1pt

// Número = u; longitud = absoluta.
#let len(v, u) = if type(v) == length { v } else { v * u }
