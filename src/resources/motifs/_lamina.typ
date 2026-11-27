// ─────────────────────────────────────────────────────────────
//  resources/motifs/_lamina.typ — el área de trabajo y la lámina encajada
//
//  Copia, sin cambios de código, de dos piezas de v1 (carteles/_base.typ) que el
//  scaffold no tiene: `area-trabajo` (el rectángulo de la página que usa el
//  preset) y `encajar` (una lámina de referencia escalada y apoyada dentro de un
//  rectángulo). Lo único distinto: `medida(formato)` está en línea.
//  Las usa mosaic; el resto de `_base.typ` (medida, escala, ajustar-alto,
//  cuerpo-al-ancho) lo cubre el scaffold.
// ─────────────────────────────────────────────────────────────

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
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
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
