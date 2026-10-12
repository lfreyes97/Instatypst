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
//  publicación que las use lleva la nota de `credito` y se le avisa al
//  diseñador dónde se usaron. El paquete NO la estampa en las piezas:
//  dónde va depende del medio (página de créditos de un libro, pie de
//  foto en redes, última diapositiva de un deck…).
// ─────────────────────────────────────────────────────────────

// La nota que pide la licencia, tal cual.
#let credito = "The Fell Types are digitally reproduced by Igino Marini. www.iginomarini.com"

#let f1 = "IM FELL FLOWERS 1"
#let f2 = "IM FELL FLOWERS 2"

#let medidas = json("assets/fleurones.json")
#let _met(f, c) = medidas.at(f).at(c)

// Avance total y alto de tinta (ymin, ymax) de una secuencia de glifos.
#let _medir(f, cs) = {
  let ms = cs.clusters().map(c => _met(f, c))
  (
    ms.map(m => m.at(0)).sum(),
    ms.map(m => m.at(1)).fold(ms.first().at(1), calc.min),
    ms.map(m => m.at(2)).fold(ms.first().at(2), calc.max),
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
#let marco(ancho, alto, grosor, f, cs, fe, ce, color, hueco: 0pt) = box(width: ancho, height: alto, {
  let lh = ancho - 2 * grosor
  let lv = alto - 2 * grosor
  let b(largo) = banda(f, cs, largo, grosor, color, hueco: hueco)
  place(top + left, dx: grosor, b(lh))
  place(bottom + left, dx: grosor, rotate(180deg, b(lh)))
  place(top + left, dy: grosor, box(width: grosor, height: lv, place(center + horizon,
    rotate(-90deg, reflow: true, b(lv)))))
  place(top + right, dy: grosor, box(width: grosor, height: lv, place(center + horizon,
    rotate(90deg, reflow: true, b(lv)))))
  for (al, g) in ((top + left, 0deg), (top + right, 90deg), (bottom + right, 180deg), (bottom + left, 270deg)) {
    place(al, rotate(g, caja(fe, ce, grosor, grosor, color)))
  }
})

// Rectángulo de filete doble (hierro en seco): `oscuro` afuera, `claro` adentro.
#let filetes(w, h, oscuro, claro, sep: 2.2pt) = box(width: w, height: h, {
  place(rect(width: w, height: h, stroke: 0.9pt + oscuro))
  place(dx: sep, dy: sep, rect(width: w - 2 * sep, height: h - 2 * sep, stroke: 0.45pt + claro))
})

// Ancho natural de `cs` a un alto de tinta `h` (sin estirar la caja).
#let ancho-natural(f, cs, h) = {
  let (adv, lo, hi) = _medir(f, cs)
  h * adv / (hi - lo)
}

// Banda que alterna el motivo derecho y girado 180°: con un glifo
// asimétrico arma la guarda de ida y vuelta de las orlas de imprenta.
// (En FLOWERS 2 cada minúscula ya es su mayúscula girada: "Aa" en una
// banda común da lo mismo.)
#let alternar(f, c, largo, alto, color, hueco: 0pt) = {
  let u = ancho-natural(f, c, alto)
  let n = calc.max(1, int(calc.round((largo + hueco) / (u + hueco))))
  let w = (largo - (n - 1) * hueco) / n
  box(width: largo, height: alto, stack(dir: ltr, spacing: hueco, ..range(n).map(i => {
    let g = caja(f, c, w, alto, color)
    if calc.odd(i) { rotate(180deg, g) } else { g }
  })))
}

// Roseta en espejo: el glifo en un cuadrante, reflejado en los otros
// tres (los ejes de reflexión se cruzan en el centro).
#let espejo4(f, c, lado, color) = {
  let q = caja(f, c, lado / 2, lado / 2, color)
  let fx(b) = scale(x: -100%, b)
  let fy(b) = scale(y: -100%, b)
  box(width: lado, height: lado, grid(columns: 2, rows: 2, fy(q), fy(fx(q)), q, fx(q)))
}

// Roseta por giro: el glifo cuatro veces, girando 90° alrededor del
// centro (molinete).
#let giro4(f, c, lado, color) = {
  let q = caja(f, c, lado / 2, lado / 2, color)
  box(width: lado, height: lado, grid(
    columns: 2, rows: 2,
    q, rotate(90deg, q),
    rotate(270deg, q), rotate(180deg, q),
  ))
}

// ═════════════════════════════════════════════════════════════
//  PRESETS — cada glifo en el uso que le sienta
//
//  No todo fleurón sirve para todo: un motivo con «arriba» (crestería,
//  lises, copas) se ve mal de costado en un marco; uno denso y sin
//  dirección (celosía, trenza) sí aguanta los cuatro lados. Las tablas
//  que siguen fijan glifo, esquina, grosor y aire de cada uso, elegidos
//  a ojo sobre la hoja de pruebas (ornamentos/fleurones.pdf). Las
//  medidas están pensadas para lienzos de ~1080 px de lado.
// ═════════════════════════════════════════════════════════════

// ── Marcos: cadenas que aguantan los cuatro lados ──
// motivo y esquina son (fuente, glifos); `hueco` es el aire entre
// motivos para los sueltos (crucetas, margaritas).
#let cadenas = (
  // las cinco de Magnalia
  ojivas: (motivo: (f1, "RS"), esquina: (f1, "U"), grosor: 50pt),
  cartuchos: (motivo: (f1, "IJ"), esquina: (f1, "U"), grosor: 46pt),
  follaje: (motivo: (f2, "N"), esquina: (f1, "U"), grosor: 42pt),
  flores: (motivo: (f2, "D"), esquina: (f1, "b"), grosor: 32pt),
  eslabones: (motivo: (f2, "U"), esquina: (f1, "b"), grosor: 22pt),
  // densas, de imprenta (FLOWERS 1)
  celosia: (motivo: (f1, "C"), esquina: (f1, "U"), grosor: 40pt),
  trenza: (motivo: (f1, "B"), esquina: (f1, "b"), grosor: 40pt),
  damasco: (motivo: (f1, "L"), esquina: (f1, "W"), grosor: 36pt),
  bordado: (motivo: (f1, "E"), esquina: (f1, "G"), grosor: 36pt),
  anillas: (motivo: (f1, "P"), esquina: (f1, "P"), grosor: 36pt),
  // aireadas (FLOWERS 1)
  lises: (motivo: (f1, "AD"), esquina: (f1, "U"), grosor: 46pt),
  zarcillos: (motivo: (f1, "KM"), esquina: (f1, "U"), grosor: 38pt),
  encaje: (motivo: (f1, "OQ"), esquina: (f1, "U"), grosor: 36pt),
  // de trazo grueso (FLOWERS 2)
  corazones: (motivo: (f2, "S"), esquina: (f2, "C"), grosor: 30pt),
  ondas: (motivo: (f2, "V"), esquina: (f1, "b"), grosor: 28pt),
  espirales: (motivo: (f2, "B"), esquina: (f2, "O"), grosor: 30pt),
  cadeneta: (motivo: (f2, "I"), esquina: (f2, "O"), grosor: 34pt),
  // sueltas
  crucetas: (motivo: (f2, "C"), esquina: (f2, "C"), grosor: 22pt, hueco: 10pt),
  margaritas: (motivo: (f2, "O"), esquina: (f2, "O"), grosor: 26pt, hueco: 10pt),
  rosetones: (motivo: (f2, "P"), esquina: (f2, "C"), grosor: 24pt, hueco: 8pt),
)

// Marco con una cadena de la tabla. Con otro `grosor`, el aire entre
// motivos se escala en proporción.
#let orla(nombre, ancho, alto, color, grosor: auto) = {
  let c = cadenas.at(nombre)
  let g = if grosor == auto { c.grosor } else { grosor }
  let hueco = c.at("hueco", default: 0pt) * (g / c.grosor)
  let ((f, cs), (fe, ce)) = (c.motivo, c.esquina)
  marco(ancho, alto, g, f, cs, fe, ce, color, hueco: hueco)
}

// ── Guardas: bandas con arriba y abajo, solo en horizontal ──
// Para cabeceras, pies y separadores; de costado se ven caídas.
#let guardas = (
  guirnalda: (motivo: (f2, "D"), alto: 30pt),
  volutas: (motivo: (f2, "G"), alto: 30pt, hueco: 12pt),
  hojas: (motivo: (f2, "A"), alto: 30pt, hueco: 5pt),
  hojarasca: (motivo: (f2, "Aa"), alto: 46pt, hueco: 6pt),
  cresteria: (motivo: (f2, "W"), alto: 26pt),
  lises: (motivo: (f2, "Q"), alto: 26pt, hueco: 10pt),
  copas: (motivo: (f2, "R"), alto: 26pt, hueco: 8pt),
  palmetas: (motivo: (f2, "Y"), alto: 30pt),
  follaje: (motivo: (f2, "N"), alto: 34pt),
  acantos: (motivo: (f2, "E"), alto: 34pt),
  ovalos: (motivo: (f2, "Z"), alto: 20pt),
  vaiven: (motivo: (f2, "Dd"), alto: 44pt),
  zarcillos: (motivo: (f1, "KM"), alto: 24pt),
  encaje: (motivo: (f1, "OQ"), alto: 22pt),
)

#let guarda(nombre, largo, color, alto: auto) = {
  let g = guardas.at(nombre)
  let a = if alto == auto { g.alto } else { alto }
  let (f, cs) = g.motivo
  banda(f, cs, largo, a, color, hueco: g.at("hueco", default: 0pt) * (a / g.alto))
}
#let _guarda = guarda

// ── Viñetas: glifos sueltos ──
// Las primeras son de un golpe (marcan, separan, cierran); las
// apaisadas sirven solas como cabecera o pie de un bloque.
#let vinetas = (
  cruz: (f2, "C"),
  flor: (f2, "O"),
  rosa: (f2, "P"),
  lis: (f2, "Q"),
  copa: (f2, "R"),
  ramo: (f2, "X"),
  palmeta: (f2, "Y"),
  hoja: (f2, "A"),
  molinete: (f2, "J"),
  mano: (f2, "1"),
  mano-izq: (f2, "2"),
  // apaisadas
  acanto: (f2, "E"),
  candelabro: (f2, "H"),
  broche: (f2, "I"),
  trebol: (f2, "G"),
  guirnalda: (f2, "D"),
  follaje: (f2, "N"),
  cresta: (f2, "W"),
)

// Viñeta a su proporción natural, de alto `alto`.
#let vineta(nombre, alto, color) = {
  let (f, c) = vinetas.at(nombre)
  caja(f, c, ancho-natural(f, c, alto), alto, color)
}
#let _vineta = vineta // las composiciones reciben `vineta:` como parámetro

// ── Rosetas: un glifo multiplicado alrededor de un centro ──
#let _rosetas = (
  medallon: ("espejo", f1, "Q"),
  lises: ("espejo", f1, "A"),
  ojival: ("giro", f1, "R"),
  estrella: ("giro", f1, "K"),
  hojas: ("giro", f2, "A"),
  corazones: ("espejo", f2, "S"),
  aspas: ("giro", f2, "J"),
  lirios: ("espejo", f2, "Q"),
)
#let rosetas = ("molinete",) + _rosetas.keys()

// Roseta. «molinete» son los cuatro molinetes de F2 en cruz.
#let roseta(lado, color, tipo: "molinete") = {
  if tipo == "molinete" {
    return box(width: lado, height: lado, grid(
      columns: 2,
      caja(f2, "J", lado / 2, lado / 2, color), caja(f2, "K", lado / 2, lado / 2, color),
      caja(f2, "L", lado / 2, lado / 2, color), caja(f2, "M", lado / 2, lado / 2, color),
    ))
  }
  let (modo, f, c) = _rosetas.at(tipo)
  if modo == "espejo" { espejo4(f, c, lado, color) } else { giro4(f, c, lado, color) }
}

// Medallón: F1 «Q» espejado en cuatro cuadrantes.
#let medallon(lado, color) = roseta(lado, color, tipo: "medallon")

// ── Composiciones ──

// Separador: filete — viñeta — filete. `linea` es el color del filete.
#let separador(ancho, color, vineta: "cruz", linea: auto, alto: 18pt, grosor: 1pt) = box(width: ancho, grid(
  columns: (1fr, auto, 1fr), align: horizon, column-gutter: alto * 0.6,
  line(length: 100%, stroke: grosor + if linea == auto { color } else { linea }),
  _vineta(vineta, alto, color),
  line(length: 100%, stroke: grosor + if linea == auto { color } else { linea }),
))

// Asterismo: tres viñetas en triángulo (⁂), el corte de sección clásico.
#let asterismo(alto, color, vineta: "cruz") = {
  let v = _vineta(vineta, alto / 2, color)
  box(stack(dir: ttb, spacing: alto * 0.06, align(center, v), stack(dir: ltr, spacing: alto * 0.12, v, v)))
}

// Remate (cul-de-lampe): viñetas en triángulo invertido que cierran un
// texto. `filas` cuenta las viñetas de cada fila, de arriba abajo.
#let remate(alto, color, vineta: "cruz", filas: (3, 2, 1)) = {
  let h = alto / filas.len()
  let v = _vineta(vineta, h * 0.8, color)
  box(stack(dir: ttb, spacing: h * 0.2, ..filas.map(n => align(center, stack(dir: ltr, spacing: h * 0.25, ..(v,) * n)))))
}

// Cabecera: una guarda entre dos filetes, a todo el ancho.
#let cabecera(ancho, color, guarda: "guirnalda", linea: auto, alto: auto) = {
  let l = if linea == auto { color } else { linea }
  stack(
    dir: ttb, spacing: 5pt,
    line(length: ancho, stroke: 1.3pt + l),
    _guarda(guarda, ancho, color, alto: alto),
    line(length: ancho, stroke: 0.6pt + l),
  )
}
// Tira: una cadena entre filetes, pensada para UN borde. El lado
// «exterior» (hacia el borde de la imagen) es el de arriba.
#let tira(largo, cadena, color, oscuro, claro) = {
  let c = cadenas.at(cadena)
  let ((fa, ga), T) = (c.motivo, c.grosor)
  stack(
    dir: ttb,
    line(length: largo, stroke: 1.2pt + oscuro),
    v(7pt),
    banda(fa, ga, largo, T, color, hueco: c.at("hueco", default: 0pt)),
    v(7pt),
    line(length: largo, stroke: 2pt + oscuro),
    v(4pt),
    line(length: largo, stroke: 0.9pt + claro),
  )
}
#let grosor-tira(cadena) = cadenas.at(cadena).grosor + 7pt + 7pt + 4pt + 4.1pt

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
