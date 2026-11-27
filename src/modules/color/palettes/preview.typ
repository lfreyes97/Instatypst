// Derivado de superpelettes/lib/preview.typ (21 nov 2026); Fase 1 de WIP-color: el rótulo de
// family-grid usa la referencia del catálogo (tw4-blue).
// superpelettes — ayudas visuales para previsualizar paletas.
//
//   #swatches((red, green, blue))                    // rejilla de muestras
//   #ramp-row("mi rampa", new-ramp("#e01b35"))       // fila con etiquetas
//   #family-grid("tw4", "blue")                      // rampa vendor + hex

#import "contrast.typ": auto-pair
#import "core.typ": palette-family

#let _digits = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f")

#let _hex(c) = {
  let comps = c.rgb().components()
  let byte(v) = {
    let n = int(calc.round(v / 100% * 255))
    _digits.at(int(n / 16)) + _digits.at(calc.rem(n, 16))
  }
  let r = comps.at(0)
  let g = comps.at(1, default: r)
  let b = comps.at(2, default: r)
  "#" + byte(r) + byte(g) + byte(b)
}

#let swatch(c, label: none, width: 64pt, height: 44pt) = {
  let pair = auto-pair(c)
  box(width: width, height: height, fill: c, radius: 4pt, inset: 4pt)[
    #set text(6.5pt, fill: pair.fg)
    #set align(center + horizon)
    #(if label == none { _hex(c) } else { label })
  ]
}

#let swatches(colors, columns: 6, width: 64pt, height: 44pt) = {
  grid(columns: columns, gutter: 4pt, ..colors.map(c => swatch(c, width: width, height: height)))
}

#let _as-ramp(ramp) = {
  if type(ramp) == dictionary { ramp }
  else if type(ramp) == array {
    let out = (:)
    for (i, c) in ramp.enumerate() { out.insert(str(i), c) }
    out
  } else { panic("ramp-row: se esperaba dict o array, llegó " + str(type(ramp))) }
}

#let ramp-row(title, ramp, width: 52pt, height: 40pt) = {
  let rd = _as-ramp(ramp)
  let keys = rd.keys()
  stack(dir: ttb, spacing: 4pt, strong(title), grid(
    columns: keys.len(), gutter: 2pt,
    ..keys.map(k => swatch(rd.at(k), label: k, width: width, height: height)),
  ))
}

#let family-grid(provider, fam, variant: "light") = {
  ramp-row(provider + "-" + fam + (if provider == "rx" { " (" + variant + ")" } else { "" }), palette-family(provider, fam, variant: variant))
}
