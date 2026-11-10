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
//    area-trabajo(formato, area, ancla)
//                               -> (x, y, ancho, alto): el rectángulo del
//                                  formato que usa el preset (por defecto,
//                                  la página entera)
//    encajar(rect, base, ancla) -> (ox, oy, s): una lámina de `base` px
//                                  escalada y apoyada dentro de `rect`
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

// ── el área de trabajo ──
// Un preset de lámina no tiene por qué usar la página entera: `area` acota el
// rectángulo dentro del que van el arte y el texto, y el resto queda libre
// (solo el color de fondo).
//   area   fracción de la página: 1 (o 100 %) = toda; un número o un ratio
//          (0,7 · 70 %) para los dos lados; un par (ancho, alto) para cada uno
//   ancla  dónde va el área en la página, y la lámina dentro del área: una
//          alineación (center + horizon, top, bottom + left…); el eje que no
//          se da queda centrado
#let _fraccion(f, quien) = {
  let v = if type(f) == ratio { f / 100% } else { f }
  if type(v) not in (int, float) or v <= 0 or v > 1 {
    panic(quien + ": `area` es una fracción mayor que 0 y hasta 1 (o hasta 100 %), no " + repr(f))
  }
  v
}
// (fx, fy): 0 = a la izquierda / arriba, 0,5 = centrado, 1 = a la derecha / abajo
#let _ancla(ancla) = {
  let fx = (left: 0, center: 0.5, right: 1)
  let fy = (top: 0, horizon: 0.5, bottom: 1)
  let x = if ancla.x == none { 0.5 } else { fx.at(repr(ancla.x), default: 0.5) }
  let y = if ancla.y == none { 0.5 } else { fy.at(repr(ancla.y), default: 0.5) }
  (x, y)
}

// El rectángulo de trabajo (x, y, ancho, alto), en pt, de un formato en px.
#let area-trabajo(formato, area: 1, ancla: center + horizon, quien: "area") = {
  if type(ancla) != alignment {
    panic(quien + ": `ancla` es una alineación (center, top, bottom + left…), no " + repr(ancla))
  }
  if type(area) == array and area.len() != 2 {
    panic(quien + ": `area` como par es (ancho, alto), no " + repr(area))
  }
  let (ancho, alto) = medida(formato)
  let (fw, fh) = if type(area) == array { area.map(f => _fraccion(f, quien)) } else {
    let f = _fraccion(area, quien)
    (f, f)
  }
  let (w, h) = (ancho * fw, alto * fh)
  let (ax, ay) = _ancla(ancla)
  ((ancho - w) * ax, (alto - h) * ay, w, h)
}

// Una lámina de `base` (px) encajada en un rectángulo (x, y, ancho, alto) en
// pt: escala con el lado menor y se apoya según `ancla` en el lado que sobra.
// `escala` (≤ 1) la achica dentro del rectángulo. Devuelve (ox, oy, s): la
// esquina de la lámina en la página y su escala (una medida u de la lámina
// mide u · s pt).
#let encajar(rect, base, ancla: center + horizon, escala: 1) = {
  let (x, y, w, h) = rect
  let s = calc.min(w / 1pt / base.at(0), h / 1pt / base.at(1)) * escala
  let (ax, ay) = _ancla(ancla)
  (x + (w - base.at(0) * s * 1pt) * ax, y + (h - base.at(1) * s * 1pt) * ay, s)
}

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
