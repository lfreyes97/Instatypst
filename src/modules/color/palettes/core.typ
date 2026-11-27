// Derivado de superpelettes/lib/core.typ (21 nov 2026). Cambios (Fase 1 de WIP-color, 21 nov
// 2026): proveedores con prefijo (tw4 = Tailwind v4, rx = Radix, oc = Open Color); se retiran
// tailwind (v3) y unocss (alias de v3). El resto del código, igual.
// superpelettes — API unificada + creación de paletas propias.
//
// Dos usos:
//
// 1. Administrar paletas vendor (lectura):
//      #palette-get("tw4", "blue", 500)
//      #palette-get("oc", "blue", 5)
//      #palette-get("rx", "tomato", 9)
//      #palette-get("rx", "tomato", 9, variant: "dark")
//      #palette-family("tw4", "blue") // rampa completa
//
//    Pasos por proveedor: tw4 50..950, oc 0..9, rx 1..12 (+ `variant:` "light"/"dark").
//    En un campo de color se piden como texto: "tw4-blue-500", "rx-tomato-9-dark" (lib/color.typ).
//
// 2. Crear paletas propias:
//      #new-mix("#e01b35", "#f59e0b", "#0066cc") // lista explícita
//      #new-ramp("#e01b35")                     // rampa OKLCH 50..950
//      #new-ramp("#e01b35", steps: ("1",..,"12")) // rampa estilo radix
//      #auto-roles(colores) // roles (dark/light/primary/...) desde lista

#import "ramp.typ": ramp, scale-from-color, new-ramp, _as-color
#import "contrast.typ": luminance
#import "vendors/tw4.typ" as _tw
#import "vendors/oc.typ" as _oc
#import "vendors/rx.typ" as _rx

#let providers() = ("tw4", "rx", "oc")

#let families(provider) = {
  if provider == "tw4" { _tw.families() }
  else if provider == "oc" { _oc.families() }
  else if provider == "rx" { _rx.families() }
  else { panic("proveedor desconocido: " + provider + " -- disponibles: " + providers().join(", ")) }
}

#let steps(provider) = {
  if provider == "tw4" { _tw.steps() }
  else if provider == "oc" { _oc.steps() }
  else if provider == "rx" { _rx.steps() }
  else { panic("proveedor desconocido: " + provider + " -- disponibles: " + providers().join(", ")) }
}

#let palette-family(provider, fam, variant: "light") = {
  if provider == "tw4" { _tw.family(fam) }
  else if provider == "oc" { _oc.family(fam) }
  else if provider == "rx" { _rx.family(fam, variant: variant) }
  else { panic("proveedor desconocido: " + provider + " -- disponibles: " + providers().join(", ")) }
}

#let palette-get(provider, fam, step, variant: "light") = {
  if provider == "tw4" { _tw.get(fam, step) }
  else if provider == "oc" { _oc.get(fam, step) }
  else if provider == "rx" { _rx.get(fam, step, variant: variant) }
  else { panic("proveedor desconocido: " + provider + " -- disponibles: " + providers().join(", ")) }
}

// Lista explícita de colores (hex con/sin "#" o colores construidos).
#let new-mix(..items) = items.pos().map(_as-color)

#let _saturation(c) = {
  let x = c.rgb().components()
  let r = x.at(0) / 100%
  let g = x.at(1, default: x.at(0)) / 100%
  let b = x.at(2, default: x.at(0)) / 100%
  calc.max(r, g, b) - calc.min(r, g, b)
}

// Roles automáticos desde cualquier lista de colores (vendor o propia):
// el más oscuro -> dark, el más claro -> light, y los tres del medio
// más saturados -> primary/secondary/accent.
#let auto-roles(cols) = {
  let sorted-l = cols.sorted(key: c => luminance(c))
  let dark = sorted-l.first()
  let light = sorted-l.last()
  let mids = cols.filter(c => c != dark and c != light)
  if mids.len() == 0 { mids = (dark,) }
  let ranked = mids.sorted(key: c => -_saturation(c))
  let pick(i) = if i < ranked.len() { ranked.at(i) } else { ranked.at(calc.rem(i, ranked.len())) }
  (
    dark: dark,
    light: light,
    primary: pick(0),
    secondary: pick(1),
    accent: pick(2),
    white: white,
  )
}
