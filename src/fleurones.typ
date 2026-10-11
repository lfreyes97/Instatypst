// ─────────────────────────────────────────────────────────────
//  fleurones.typ — orlas, bandas y mallas con IM FELL FLOWERS 1 y 2
//
//  Motor de ornamentos de la maqueta de Magnalia Dei
//  (~/Proyectos/Magnalia/typst/ornamentos.typ), traído al paquete: cada
//  glifo de flores se mete en una caja EXACTA (su tinta, no su línea de
//  texto) y las cajas se encadenan en bandas, marcos y mallas sin
//  costuras. Nada de glifos sueltos ni `repeat` con clip.
//
//  Namespace (`fleurones.banda`, `fleurones.marco`…), como `formas`. No
//  se llama `ornamentos` porque así se llama el catálogo de la raíz.
//
//  Las medidas de cada glifo (avance, ymin, ymax en 1/1000 em) salen de
//  assets/fleurones.json, que genera scripts/medir-fleurones.py desde
//  Fonts/IM_Fell_Flowers/. Sin color fijo: todo recibe el suyo.
//
//  Licencia de las fuentes (Fonts/IM_Fell_Flowers/LICENCIA.txt): toda
//  pieza publicada con ellas debe llevar la nota «The Fell Types are
//  digitally reproduced by Igino Marini. www.iginomarini.com».
// ─────────────────────────────────────────────────────────────

#let f1 = "IM FELL FLOWERS 1"
#let f2 = "IM FELL FLOWERS 2"

#let medidas = json("assets/fleurones.json")
#let _met(f, c) = medidas.at(f).at(c)

// Avance total y alto de tinta (ymin, ymax) de una secuencia de glifos.
#let _medir(f, cs) = {
  let ms = cs.clusters().map(c => _met(f, c))
  (
    ms.map(m => m.at(0)).sum(),
    ms.fold(0, (acc, m) => calc.min(acc, m.at(1))),
    ms.fold(0, (acc, m) => calc.max(acc, m.at(2))),
  )
}

// Glifo ajustado a su caja de tinta.
#let gl(f, c, s, color) = text(font: f, size: s, fill: color, top-edge: "bounds", bottom-edge: "bounds")[#c]

// Glifo (o secuencia) forzado a una caja exacta w × h.
#let caja(f, cs, w, h, color) = {
  let (adv, lo, hi) = _medir(f, cs)
  let s = h / ((hi - lo) / 1000)
  let wnat = s * adv / 1000
  box(width: w, height: h, clip: false, place(top + left, scale(
    x: (w / wnat) * 100%, origin: top + left, reflow: false,
    gl(f, cs, s, color),
  )))
}

// Banda continua: repite `cs` hasta cubrir exactamente `largo`. Con
// `hueco`, deja ese aire entre motivo y motivo (y el largo sigue exacto).
#let banda(f, cs, largo, alto, color, hueco: 0pt) = {
  let (adv, lo, hi) = _medir(f, cs)
  let u = alto * adv / (hi - lo)
  let n = calc.max(1, int(calc.round((largo + hueco) / (u + hueco))))
  let w = (largo - (n - 1) * hueco) / n
  box(width: largo, height: alto, stack(dir: ltr, spacing: hueco, ..range(n).map(_ => caja(f, cs, w, alto, color))))
}

// Malla a toda superficie (rejilla de módulos).
#let diaper(f, cs, ancho, alto, modulo, color) = {
  let filas = calc.max(1, int(calc.round(alto / modulo)))
  let h = alto / filas
  box(width: ancho, height: alto, clip: true, stack(dir: ttb, ..range(filas).map(_ => banda(f, cs, ancho, h, color))))
}

// Marco de orla: bandas en los 4 lados + esquinas cuadradas.
#let marco(ancho, alto, grosor, f, cs, fe, ce, color) = box(width: ancho, height: alto, {
  let lh = ancho - 2 * grosor
  let lv = alto - 2 * grosor
  place(top + left, dx: grosor, banda(f, cs, lh, grosor, color))
  place(bottom + left, dx: grosor, rotate(180deg, banda(f, cs, lh, grosor, color)))
  place(top + left, dy: grosor, box(width: grosor, height: lv, place(center + horizon,
    rotate(-90deg, reflow: true, banda(f, cs, lv, grosor, color)))))
  place(top + right, dy: grosor, box(width: grosor, height: lv, place(center + horizon,
    rotate(90deg, reflow: true, banda(f, cs, lv, grosor, color)))))
  for (al, g) in ((top + left, 0deg), (top + right, 90deg), (bottom + right, 180deg), (bottom + left, 270deg)) {
    place(al, rotate(g, caja(fe, ce, grosor, grosor, color)))
  }
})

// Rectángulo de filete doble (hierro en seco): `oscuro` afuera, `claro` adentro.
#let filetes(w, h, oscuro, claro, sep: 2.2pt) = box(width: w, height: h, {
  place(rect(width: w, height: h, stroke: 0.9pt + oscuro))
  place(dx: sep, dy: sep, rect(width: w - 2 * sep, height: h - 2 * sep, stroke: 0.45pt + claro))
})

// Medallón: F1 «Q» espejado en cuatro cuadrantes.
#let medallon(lado, color) = {
  let q = caja(f1, "Q", lado / 2, lado / 2, color)
  let fx(b) = scale(x: -100%, b)
  let fy(b) = scale(y: -100%, b)
  box(width: lado, height: lado, grid(columns: 2, rows: 2, fy(q), fy(fx(q)), q, fx(q)))
}

// Roseta: los cuatro molinetes de F2 en cruz.
#let roseta(lado, color) = box(width: lado, height: lado, grid(
  columns: 2,
  caja(f2, "J", lado / 2, lado / 2, color), caja(f2, "K", lado / 2, lado / 2, color),
  caja(f2, "L", lado / 2, lado / 2, color), caja(f2, "M", lado / 2, lado / 2, color),
))

// ── Cadenas: motivos probados para orlas ──
// (fuente, glifos, fuente-esquina, glifo-esquina, grosor)
#let cadenas = (
  ojivas: (f1, "RS", f1, "U", 50pt),
  cartuchos: (f1, "IJ", f1, "U", 46pt),
  follaje: (f2, "N", f1, "U", 42pt),
  flores: (f2, "D", f1, "b", 32pt),
  eslabones: (f2, "U", f1, "b", 22pt),
)

// Tira: una cadena entre filetes, pensada para UN borde. El lado
// «exterior» (hacia el borde de la imagen) es el de arriba.
#let tira(largo, cadena, color, oscuro, claro) = {
  let (fa, ga, _, _, T) = cadenas.at(cadena)
  stack(
    dir: ttb,
    line(length: largo, stroke: 1.2pt + oscuro),
    v(7pt),
    banda(fa, ga, largo, T, color),
    v(7pt),
    line(length: largo, stroke: 2pt + oscuro),
    v(4pt),
    line(length: largo, stroke: 0.9pt + claro),
  )
}
#let grosor-tira(cadena) = cadenas.at(cadena).at(4) + 7pt + 7pt + 4pt + 4.1pt

// Divisor: filete — florón — filete.
#let divisor(ancho, alto, color, linea) = box(width: ancho, grid(
  columns: (1fr, auto, 1fr), align: horizon, column-gutter: 10pt,
  line(length: 100%, stroke: 1.4pt + linea),
  caja(f2, "B", alto * 962 / 490, alto, color),
  line(length: 100%, stroke: 1.4pt + linea),
))

// Friso: banda de cartuchos entre dos filetes.
#let friso(ancho, color, linea, alto: 40pt) = stack(
  dir: ttb, spacing: 5pt,
  line(length: ancho, stroke: 1.3pt + linea),
  banda(f1, "IJ", ancho, alto, color),
  line(length: ancho, stroke: 1.3pt + linea),
)
