// Copia de superpelettes/lib/ramp.typ (21 nov 2026), sin cambios en el código: solo esta línea.
// superpelettes — rampas generativas en OKLCH.
//
// Cada rampa es un diccionario paso -> color. Los pasos por defecto son
// los de Tailwind (50..950); cualquier lista de pasos funciona mientras
// exista su claridad en `_lightness` o se pase con `lightness:` explícito.
//
// El croma se atenúa hacia los extremos con `peak * sin(pi * l)` para
// evitar el clipping silencioso que produce Typst cuando el OKLCH pedido
// cae fuera del gamut sRGB (los extremos L≈97% o L≈14% con croma
// constante se recortan a colores saturados que rompen la rampa).

#let default-steps = (50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950)

#let _lightness = (
  "50": 97, "100": 93, "200": 85, "300": 76, "400": 67,
  "500": 58, "600": 49, "700": 40, "800": 31, "900": 22, "950": 14,
  // pasos extra estilo radix/opencolor (índice 1..12 u 0..9) por si se
  // quiere regenerar una familia vendor desde su color medio:
  "1": 98, "2": 95, "3": 91, "4": 86, "5": 80, "6": 72,
  "7": 64, "8": 55, "9": 45, "10": 36, "11": 26, "12": 15,
  "0": 98,
)

#let ramp(hue: 0, chroma: 0.15, steps: default-steps) = {
  let out = (:)
  for s in steps {
    let key = str(s)
    if not (key in _lightness) {
      panic("ramp: paso sin claridad conocida: " + key)
    }
    let l = _lightness.at(key)
    let frac = l / 100
    let c = chroma * calc.sin(frac * calc.pi * 1rad)
    // Se convierte a rgb de inmediato: el resto del sistema asume
    // `.components()` en espacio rgb.
    out.insert(key, oklch(l * 1%, c, hue * 1deg).rgb())
  }
  out
}

// components() de un color convertido a oklch: (L, C, H, alpha).
#let hue-chroma-of(c) = {
  let comps = c.oklch().components()
  (hue: comps.at(2) / 1deg, chroma: comps.at(1))
}

// Admite hex con o sin "#" además de un color ya construido.
#let _as-color(c) = {
  if type(c) == str {
    rgb(if c.starts-with("#") { c } else { "#" + c })
  } else {
    c
  }
}

// Rampa completa desde CUALQUIER color (hex o color construido): el hue
// y el croma salen del propio color. Con `step:` devuelve un solo color.
//
//   #scale-from-color("#e01b35")            // dict con los 11 pasos
//   #scale-from-color("#e01b35", step: 500) // un solo color
#let scale-from-color(c, step: none, steps: default-steps) = {
  let hc = hue-chroma-of(_as-color(c))
  let full = ramp(hue: hc.hue, chroma: hc.chroma, steps: steps)
  if step == none { full } else { full.at(str(step)) }
}

#let new-ramp = scale-from-color
