// ─────────────────────────────────────────────────────────────
//  mesa/camara.typ — la cámara que encuadra la hoja
//
//  La hoja interna (`paper-size`) sigue una convención de papel; el lienzo
//  (la página de Typst) sale de ella y de la cámara. Lo que la cámara dicta
//  es CUÁNTO papel se ve dentro de ese lienzo: cerca, la hoja crece; lejos,
//  se achica y deja ver más mesa.
//
//    FOV          = 2·atan(sensor / 2f)
//    lienzo       = caja envolvente de la hoja base rotada + 2·margen
//    escala       = (Z_ref / Z)^0.33 · (f / 50)^0.4,  Z_ref = 250 mm
//                   (1,0 con 50 mm a 25 cm), acotada a 0,60–1,12 y, además,
//                   a lo que cabe en el lienzo con 3 mm de mesa
//    perspectiva  = (f / Z) · 0,05: cuánto más estrecho se ve el borde
//                   superior que el inferior (trapecio; mayor con gran
//                   angular y cerca)
//    desenfoque   = (Z − 500 mm) · 0,005: crece al alejar la cámara
//
//  No pinta nada: solo calcula. La geometría de la página vive en lib.typ.
// ─────────────────────────────────────────────────────────────

// Papel por convención → (ancho, alto) vertical. Una tupla pasa tal cual.
#let medida-papel(paper-size) = {
  if type(paper-size) == array and paper-size.len() == 2 { return paper-size }
  let tamanos = (
    a3: (297mm, 420mm), a4: (210mm, 297mm), a5: (148mm, 210mm), a6: (105mm, 148mm),
    letter: (216mm, 279mm),
  )
  if type(paper-size) == str and paper-size in tamanos { return tamanos.at(paper-size) }
  panic("paper-size: se esperaba a3, a4, a5, a6, letter o un par (ancho, alto), no " + repr(paper-size))
}

// Margen de mesa (length o dict x/y) → (x, y).
#let margen-mesa(margin) = {
  if type(margin) == length { (x: margin, y: margin) }
  else if type(margin) == dictionary { (x: margin.at("x", default: 14mm), y: margin.at("y", default: 14mm)) }
  else { panic("margin: se esperaba una longitud o (x:, y:), no " + repr(margin)) }
}

// Campo de visión del sensor con esa focal.
#let fov(focal-length: 50mm, sensor-size: 36mm) = 2 * calc.atan((sensor-size / focal-length) / 2)

// Cálculo principal. `paper` ya es (ancho, alto) de la hoja base, en la
// orientación elegida.
#let compute-camera(
  focal-length: 50mm,
  distance: 250mm,
  sensor-size: 36mm,
  paper: (148mm, 210mm),
  angle: 0.55deg,
  margin: (x: 14mm, y: 14mm),
) = {
  if distance <= focal-length {
    panic("distance: la cámara (" + repr(distance) + ") debe estar más lejos que la focal (" + repr(focal-length) + ")")
  }
  let m = margen-mesa(margin)
  let (bw, bh) = paper
  let c = calc.abs(calc.cos(angle))
  let s = calc.abs(calc.sin(angle))

  // lienzo: caja envolvente de la hoja base rotada, más la mesa de alrededor
  let crop-w = bw * c + bh * s + 2 * m.x
  let crop-h = bh * c + bw * s + 2 * m.y

  // perspectiva (trapecio): fracción en que el borde superior es más corto
  let perspectiva = (focal-length / distance) * 0.05

  // escala del papel: lo pide la cámara, lo limita el lienzo
  let pedida = calc.pow(250mm / distance, 0.33) * calc.pow(focal-length / 50mm, 0.4)
  let pedida = calc.max(0.60, calc.min(pedida, 1.12))
  // con la hoja de ancho máximo (1 + perspectiva) rotada, que sobren 3 mm de mesa
  let cabe-w = (crop-w - 6mm) / (bw * (1 + perspectiva) * c + bh * s)
  let cabe-h = (crop-h - 6mm) / (bh * c + bw * (1 + perspectiva) * s)
  let escala = calc.min(pedida, cabe-w, cabe-h)

  (
    crop-width: crop-w,
    crop-height: crop-h,
    scale: escala,
    perspective: perspectiva,
    blur: calc.max(0mm, (distance - 500mm) * 0.005),
    fov: fov(focal-length: focal-length, sensor-size: sensor-size),
  )
}
