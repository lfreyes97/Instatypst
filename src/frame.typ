// ─────────────────────────────────────────────────────────────
//  frame.typ — el frame genérico: no conoce ningún preset
//
//    frame(preset:, variant:, artboard:, theme:, accent:, brand:, ..options, body)
//
//  preset    un descriptor (make:, variants:) o una FUNCIÓN propia
//            make(body, artboard:, theme:, brand:, ..opciones) -> page
//            Los nombres ("plain", "swiss"…) los resuelve lib, que tiene la tabla.
//  variant   auto = no pasarla. Con un descriptor, se valida contra sus
//            `variants`; con una función, la valida la función.
//  artboard  un nombre de `formats`, un (ancho, alto) en px o auto (= el que
//            declara el preset en su descriptor, `artboard:`; si no, "retrato")
//  theme, accent, brand   solo se entregan al preset si se dan: un preset que no
//            tiene acento no ve nunca `accent:` salvo que alguien lo pase
//  ..options se pasan tal cual al preset
//
//  Cada preset del paquete exporta su frame, y es una sola línea:
//    #let swiss = frame.with(preset: preset)
//  Así el azúcar es la forma explícita por construcción (Spec, caso 2). Que
//  ningún preset del paquete se desvíe lo vigila el harness; lo que haga quien
//  usa el paquete en su propio espacio es cosa suya.
//  `repeat` no está (Spec, Anexo B).
// ─────────────────────────────────────────────────────────────

#import "/src/core/artboard.typ": resolve-artboard

#let frame(
  preset: auto,
  variant: auto,
  artboard: auto,
  theme: auto,
  accent: auto,
  brand: none,
  ..options,
  body,
) = {
  let entry = if type(preset) == function { (make: preset, variants: auto) } else if type(preset) == dictionary and "make" in preset {
    (make: preset.make, variants: preset.at("variants", default: ()))
  } else {
    panic("frame: `preset` es un descriptor (make:, variants:) o una función, no " + repr(preset))
  }
  let name = if type(preset) == dictionary { preset.at("name", default: "?") } else { "?" }
  if variant != auto and entry.variants != auto {
    assert(variant in entry.variants, message: "frame: el preset `" + name + "` " + (
      if entry.variants.len() == 0 { "no tiene variantes" } else { "no tiene la variante " + repr(variant) + " (hay: " + entry.variants.join(", ") + ")" }
    ))
  }
  // `artboard: auto` es el formato que declara el preset (su descriptor), o retrato
  let artboard = if artboard == auto and type(preset) == dictionary { preset.at("artboard", default: auto) } else { artboard }
  let common = (artboard: resolve-artboard(artboard))
  if theme != auto { common.insert("theme", theme) }
  if accent != auto { common.insert("accent", accent) }
  if brand != none { common.insert("brand", brand) }
  if variant != auto { common.insert("variant", variant) }
  (entry.make)(body, ..common, ..options.named())
}
