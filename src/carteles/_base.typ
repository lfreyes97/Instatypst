// ─────────────────────────────────────────────────────────────
//  carteles/_base.typ — piezas comunes de los presets de lámina
//
//  Lo que `suizo`, `esquela`, `folio` y compañía repetían cada uno por
//  su cuenta: medir el formato, escalar las medidas al lienzo y achicar
//  un texto hasta que quepa. Vive por debajo de los presets (no importa
//  a ninguno), así que cualquiera puede usarlo sin ciclos de import;
//  `carteles.typ` lo re-exporta.
//
//    medida(formato)            -> (ancho, alto) en pt, desde px
//    escala(formato, base)      -> factor para llevar medidas pensadas
//                                  sobre `base` al lienzo (el lado menor
//                                  manda: nada se sale de la página)
//    cuerpo-al-ancho(hacer, a)  -> tamaño con el que hacer(t) mide `a`
//    ajustar-alto(hacer, desde, alto, …)
//                               -> el mayor tamaño ≤ desde con el que
//                                  hacer(t) cabe en `alto`
//
//  `cuerpo-al-ancho` y `ajustar-alto` miden: se usan dentro de `context`.
// ─────────────────────────────────────────────────────────────

// (ancho, alto) en pt de un formato en px (como `sizes`).
#let medida(formato) = (formato.at(0) * 1pt, formato.at(1) * 1pt)

// Factor de escala del lienzo respecto de las medidas de origen de la
// lámina (`base`, en px). El lado menor manda.
#let escala(formato, base: (1080, 1080)) = calc.min(formato.at(0) / base.at(0), formato.at(1) / base.at(1))

// Tamaño de letra con el que `hacer(tamaño)` ocupa exactamente `ancho`.
// El ancho del texto es lineal en el tamaño: se mide una vez a 100pt y
// se escala. Usar dentro de `context`.
#let cuerpo-al-ancho(hacer, ancho) = 100pt * (ancho / measure(hacer(100pt)).width)

// Mayor tamaño, de `desde` hacia abajo en pasos de `paso`, con el que
// `hacer(tamaño)` (un bloque) mide como mucho `alto` de alto. Se detiene
// en `minimo` aunque no quepa. Usar dentro de `context`.
#let ajustar-alto(hacer, desde, alto, minimo: 24pt, paso: 2pt) = {
  let s = desde
  while s > minimo and measure(hacer(s)).height > alto { s -= paso }
  s
}
