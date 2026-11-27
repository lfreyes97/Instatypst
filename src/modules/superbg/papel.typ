// ─────────────────────────────────────────────────────────────
//  superbg / papel.typ — NIVEL 2: papel viejo / escaneado + desgaste
//
//  bg-papel     el papel: manchas de humedad (ruido de baja
//               frecuencia), fibras, grano, puntos de óxido (foxing) y
//               bordes tostados. `escaneo: true` agrega lo que deja el
//               escáner: sombra del lomo en un borde y un velo gris.
//               `cafe: n` le apoya n tazas encima.
//  bg-cafe      manchas de café generadas (aros de taza + gotas), como
//               capa sobre cualquier fondo, o encima del texto.
//  mancha-cafe, bg-mancha-cafe   las cuatro manchas reales del paquete
//               LaTeX coffeestains (dominio público), recoloreables.
//  tinta-gastada  relleno para TEXTO (text(fill: …)): la tinta con
//               huecos transparentes donde "no cubrió", como el
//               `desgaste:` de capitular-ornamentada (dropcaps.typ). Por
//               los huecos se ve el papel de verdad, manchas incluidas.
//
//  Con filtros SVG: Typst rasteriza estas capas (dejan de ser
//  vectoriales). Misma semilla = mismo papel. Ojo: str() de Typst
//  escribe los negativos con «−» (U+2212), que SVG no entiende: se
//  reemplaza antes de armar la imagen.
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _check-size
#import "azar.typ": _secuencia

// Componentes 0–1 de un color, para las matrices de feColorMatrix.
#let _rgb01(c) = c.rgb().components().slice(0, 3).map(v => str(v / 100%))

// Matriz que pinta todo de `c` y saca el alfa del canal R del ruido:
// alfa = ganancia·R + corrimiento.
#let _matriz-alfa(c, ganancia, corrimiento) = {
  let (r, g, b) = _rgb01(c)
  ("0 0 0 0 " + r + "  0 0 0 0 " + g + "  0 0 0 0 " + b + "  " +
   str(ganancia) + " 0 0 0 " + str(corrimiento))
}

// Manchas de café, como fragmento SVG (defs, cuerpo) para meter dentro
// de otro SVG. Cada mancha es lo que deja una taza: un aro de borde
// irregular, más oscuro en el filo que adentro (el café se seca hacia
// afuera), con un lado más cargado que el otro; a veces un segundo aro
// parcial corrido (la taza se apoyó dos veces) y unas gotas cerca.
//   n        cuántas tazas
//   gotas    gotas por taza
//   radio    auto = de taza (≈ 9–15 % del lado menor) · número en px
#let _cafe(w, h, n, gotas, color, intensidad, semilla, radio: auto) = {
  let k = calc.clamp(intensidad, 0, 1.5)
  let oscuro = color.darken(35%).to-hex()
  let claro = color.to-hex()
  let defs = (
    "<radialGradient id='cafe-g'>",
    "<stop offset='0' stop-color='" + claro + "' stop-opacity='" + str(0.07 * k) + "'/>",
    "<stop offset='0.72' stop-color='" + claro + "' stop-opacity='" + str(0.1 * k) + "'/>",
    "<stop offset='0.9' stop-color='" + claro + "' stop-opacity='" + str(0.22 * k) + "'/>",
    "<stop offset='0.975' stop-color='" + oscuro + "' stop-opacity='" + str(0.6 * k) + "'/>",
    "<stop offset='1' stop-color='" + oscuro + "' stop-opacity='" + str(0.75 * k) + "'/></radialGradient>",
  )
  let cuerpo = ()
  let lado = calc.min(w, h)
  let r = _secuencia(n * 10 + n * gotas * 3, semilla * 13 + 5)
  let at(i) = r.at(i)
  for i in range(n) {
    let b = i * 10
    let cx = (0.08 + 0.84 * at(b)) * w
    let cy = (0.08 + 0.84 * at(b + 1)) * h
    let R = if radio == auto { lado * (0.09 + 0.06 * at(b + 2)) } else { radio * (0.85 + 0.3 * at(b + 2)) }
    let ang = 360 * at(b + 3)
    let id = str(i)
    let caja(m) = "x='" + str(cx - m) + "' y='" + str(cy - m) + "' width='" + str(2 * m) + "' height='" + str(2 * m) + "'"
    // borde irregular: el aro se deforma con ruido
    defs.push("<filter id='cafe-d" + id + "' filterUnits='userSpaceOnUse' " + caja(R * 1.9) + ">")
    defs.push("<feTurbulence type='fractalNoise' baseFrequency='" + str(1.1 / R) + "' numOctaves='4' seed='" + str(semilla + 31 * i) + "'/>")
    defs.push("<feDisplacementMap in='SourceGraphic' scale='" + str(R * 0.07) + "' xChannelSelector='R' yChannelSelector='G'/>")
    defs.push("<feGaussianBlur stdDeviation='0.7'/></filter>")
    // un lado más cargado: máscara con degradé en un ángulo al azar
    defs.push("<linearGradient id='cafe-l" + id + "' gradientTransform='rotate(" + str(ang) + " 0.5 0.5)'>")
    defs.push("<stop offset='0' stop-color='#fff' stop-opacity='1'/><stop offset='1' stop-color='#fff' stop-opacity='" + str(0.3 + 0.3 * at(b + 4)) + "'/></linearGradient>")
    defs.push("<mask id='cafe-m" + id + "' maskUnits='userSpaceOnUse' " + caja(R * 1.4) + "><rect " + caja(R * 1.4) + " fill='url(#cafe-l" + id + ")'/></mask>")
    // (el <rect> invisible agranda la caja del grupo: sin él, el
    //  desplazamiento corta la mancha en cuadrado a derecha y abajo)
    cuerpo.push("<g mask='url(#cafe-m" + id + ")'><g filter='url(#cafe-d" + id + ")'><rect " + caja(R * 1.4) + " fill='none'/><circle cx='" + str(cx) + "' cy='" + str(cy) + "' r='" + str(R) + "' fill='url(#cafe-g)'/></g></g>")

    // segundo aro, parcial y corrido (en la mitad de las tazas)
    if at(b + 5) < 0.6 {
      let a2 = 2 * calc.pi * at(b + 6)
      let (x2, y2) = (cx + R * 0.32 * calc.cos(a2 * 1rad), cy + R * 0.32 * calc.sin(a2 * 1rad))
      let caja2(m) = "x='" + str(x2 - m) + "' y='" + str(y2 - m) + "' width='" + str(2 * m) + "' height='" + str(2 * m) + "'"
      defs.push("<linearGradient id='cafe-p" + id + "' gradientTransform='rotate(" + str(360 * at(b + 7)) + " 0.5 0.5)'>")
      defs.push("<stop offset='0' stop-color='#fff' stop-opacity='1'/><stop offset='0.4' stop-color='#fff' stop-opacity='0.7'/><stop offset='0.62' stop-color='#fff' stop-opacity='0'/></linearGradient>")
      defs.push("<mask id='cafe-pm" + id + "' maskUnits='userSpaceOnUse' " + caja2(R * 1.4) + "><rect " + caja2(R * 1.4) + " fill='url(#cafe-p" + id + ")'/></mask>")
      cuerpo.push("<g mask='url(#cafe-pm" + id + ")'><g filter='url(#cafe-d" + id + ")'><rect " + caja2(R * 1.4) + " fill='none'/><circle cx='" + str(x2) + "' cy='" + str(y2) + "' r='" + str(R * 0.98) + "' fill='none' stroke='" + oscuro + "' stroke-opacity='" + str(0.45 * k) + "' stroke-width='" + str(calc.max(1.5, R * 0.018)) + "'/></g></g>")
    }

    // gotas: chicas, cerca del aro, del mismo café
    for j in range(gotas) {
      let g = n * 10 + (i * gotas + j) * 3
      let a = 2 * calc.pi * at(g)
      let d = R * (1.08 + 0.7 * at(g + 1))
      let rg = calc.max(4, R * (0.04 + 0.1 * calc.pow(at(g + 2), 2)))
      let (gx, gy) = (cx + d * calc.cos(a * 1rad), cy + d * calc.sin(a * 1rad))
      defs.push("<filter id='cafe-gd" + id + "-" + str(j) + "' x='-50%' y='-50%' width='200%' height='200%'><feTurbulence type='fractalNoise' baseFrequency='" + str(1.2 / rg) + "' numOctaves='2' seed='" + str(semilla + 7 * j + 101 * i) + "'/><feDisplacementMap in='SourceGraphic' scale='" + str(rg * 0.5) + "' xChannelSelector='R' yChannelSelector='G'/></filter>")
      cuerpo.push("<g filter='url(#cafe-gd" + id + "-" + str(j) + ")'><rect x='" + str(gx - 2 * rg) + "' y='" + str(gy - 2 * rg) + "' width='" + str(4 * rg) + "' height='" + str(4 * rg) + "' fill='none'/><circle cx='" + str(gx) + "' cy='" + str(gy) + "' r='" + str(rg) + "' fill='url(#cafe-g)'/></g>")
    }
  }
  (defs.join(""), cuerpo.join(""))
}

// Manchas de café sueltas, como capa: van sobre cualquier fondo (o encima
// del texto, si la taza se apoyó después de imprimir).
#let bg-cafe(tazas: 2, gotas: 3, color: rgb("#8a5a2b"), intensidad: 1, radio: auto, semilla: 3, size: sizes.instagram) = {
  let size = _check-size(size)
  let (w, h) = (size.at(0), size.at(1))
  let (defs, cuerpo) = _cafe(w, h, tazas, gotas, color, intensidad, semilla, radio: radio)
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'><defs>" + defs + "</defs>" + cuerpo + "</svg>"
  place(image(bytes(svg.replace("−", "-")), format: "svg", width: 100%, height: 100%))
}

// ── Manchas de café reales (coffeestains, CTAN, dominio público) ──
// Cuatro manchas trazadas a mano, en capas de color (ver
// assets/cafe/LEEME.md):
//   "A" aro de 270° con dos salpicaduras · "B" arco de 60°
//   "C" dos salpicaduras claras          · "D" salpicadura doble
// Cada capa lleva su opacidad, como en el paquete LaTeX: donde se
// enciman, el café se oscurece.
#let manchas-cafe = ("A", "B", "C", "D")

// Recolorea por luminancia: lo claro de la mancha va hacia
// tinte.lighten, lo oscuro hacia tinte.darken. Así D (naranja y rojo en
// el original) queda en la misma familia que las demás.
#let _tenir(hexa, tinte) = {
  let (r, g, b) = rgb(hexa).components().slice(0, 3).map(v => v / 100%)
  let x = (0.2126 * r + 0.7152 * g + 0.0722 * b - 0.45) * 2
  (if x > 0 { tinte.lighten(calc.min(x, 1) * 50%) } else { tinte.darken(calc.min(-x, 1) * 75%) }).to-hex()
}

// La mancha como contenido, para ponerla donde sea (place, box…).
//   cual      "A" · "B" · "C" · "D"
//   ancho     largo
//   tinte     auto = café (#8a5a2b) · un color · none = colores originales
//   opacidad  de cada capa (el paquete LaTeX usa 50 %)
//   giro      ángulo; espejar: true la da vuelta (otra mancha "nueva")
#let mancha-cafe(cual: "A", ancho: 400pt, tinte: auto, opacidad: 50%, giro: 0deg, espejar: false) = {
  assert(cual in manchas-cafe, message: "mancha-cafe: `cual` debe ser uno de " + manchas-cafe.join(", ") + ", no " + repr(cual))
  let svg = read("assets/cafe/" + cual + ".svg")
  if tinte != none {
    let t = if tinte == auto { rgb("#8a5a2b") } else { tinte }
    svg = svg.replace(regex("fill='(#[0-9a-f]{6})'"), m => "fill='" + _tenir(m.captures.at(0), t) + "'")
  }
  svg = svg.replace("<path ", "<path fill-opacity='" + str(opacidad / 100%) + "' ")
  let img = image(bytes(svg), format: "svg", width: ancho)
  let img = if espejar { scale(x: -100%, img) } else { img }
  if giro == 0deg { img } else { rotate(giro, reflow: false, img) }
}

// Capa: la mancha puesta en la página. x, y = dónde cae su centro, como
// fracción del formato (0–1; fuera de ese rango se sale por el borde);
// ancho, fracción del ancho del formato.
#let bg-mancha-cafe(cual: "A", x: 0.7, y: 0.25, ancho: 0.45, tinte: auto, opacidad: 50%, giro: 0deg, espejar: false, size: sizes.instagram) = {
  let size = _check-size(size)
  let (w, h) = (size.at(0) * 1pt, size.at(1) * 1pt)
  place(center + horizon, dx: (x - 0.5) * w, dy: (y - 0.5) * h,
    mancha-cafe(cual: cual, ancho: ancho * w, tinte: tinte, opacidad: opacidad, giro: giro, espejar: espejar))
}

#let bg-papel(
  color: rgb("#efe4c8"),
  mancha: rgb("#8a6a3a"),
  manchas: 55%,
  fibras: 30%,
  grano: 35%,
  oxido: 9,
  bordes: 40%,
  escaneo: false,
  lomo: "izquierda",
  cafe: 0,
  color-cafe: rgb("#8a5a2b"),
  semilla: 11,
  size: sizes.instagram,
) = {
  let size = _check-size(size)
  let (w, h) = (size.at(0), size.at(1))
  let s = str(semilla)
  let (cafe-defs, cafe-cuerpo) = if cafe > 0 { _cafe(w, h, cafe, 3, color-cafe, 1, semilla) } else { ("", "") }
  let rect-todo(extra) = "<rect x='0' y='0' width='" + str(w) + "' height='" + str(h) + "' " + extra + "/>"
  let caja-filtro = "x='0' y='0' width='" + str(w) + "' height='" + str(h) + "' filterUnits='userSpaceOnUse'"

  let partes = (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'><defs>",
    // manchas de humedad: nubes grandes y lavadas
    "<filter id='manchas' " + caja-filtro + "><feTurbulence type='fractalNoise' baseFrequency='0.0035' numOctaves='4' seed='" + s + "'/>",
    "<feColorMatrix type='matrix' values='" + _matriz-alfa(mancha, 2.6, -1.05) + "'/></filter>",
    // fibras: ruido estirado en horizontal
    // (cortas y apenas inclinadas: con baseFrequency muy dispar salen
    //  rayas parejas de metal cepillado)
    "<filter id='fibras' " + caja-filtro + "><feTurbulence type='fractalNoise' baseFrequency='0.035 0.16' numOctaves='3' seed='" + str(semilla + 3) + "'/>",
    "<feColorMatrix type='matrix' values='" + _matriz-alfa(mancha, 3.4, -1.75) + "'/></filter>",
    // grano fino
    "<filter id='grano' " + caja-filtro + "><feTurbulence type='fractalNoise' baseFrequency='0.7' numOctaves='2' seed='" + str(semilla + 5) + "'/>",
    "<feColorMatrix type='matrix' values='" + _matriz-alfa(mancha.darken(25%), 5, -2.2) + "'/></filter>",
    "<filter id='difuso'><feGaussianBlur stdDeviation='3'/></filter>",
    // bordes tostados
    "<radialGradient id='borde' cx='50%' cy='48%' r='72%'>",
    "<stop offset='60%' stop-color='" + mancha.to-hex() + "' stop-opacity='0'/>",
    "<stop offset='100%' stop-color='" + mancha.to-hex() + "' stop-opacity='1'/></radialGradient>",
  )
  if escaneo {
    let (x1, y1, x2, y2) = if lomo == "izquierda" { (0, 0, 1, 0) } else if lomo == "derecha" { (1, 0, 0, 0) } else if lomo == "arriba" { (0, 0, 0, 1) } else { (0, 1, 0, 0) }
    partes.push("<linearGradient id='lomo' x1='" + str(x1) + "' y1='" + str(y1) + "' x2='" + str(x2) + "' y2='" + str(y2) + "'>")
    partes.push("<stop offset='0' stop-color='#000' stop-opacity='0.55'/><stop offset='0.035' stop-color='#000' stop-opacity='0.22'/>")
    partes.push("<stop offset='0.11' stop-color='#000' stop-opacity='0.05'/><stop offset='0.2' stop-color='#000' stop-opacity='0'/></linearGradient>")
  }
  partes.push(cafe-defs)
  partes.push("</defs>")

  partes.push(rect-todo("fill='" + color.to-hex() + "'"))
  partes.push(rect-todo("filter='url(#manchas)' opacity='" + str(manchas / 100%) + "'"))
  partes.push(rect-todo("filter='url(#fibras)' opacity='" + str(fibras / 100%) + "'"))
  partes.push(rect-todo("filter='url(#grano)' opacity='" + str(grano / 100%) + "'"))

  // óxido: puntos chicos de color tabaco, más densos hacia los bordes
  let r = _secuencia(oxido * 3, semilla * 7 + 1)
  for i in range(oxido) {
    let (u, v, t) = (r.at(3 * i), r.at(3 * i + 1), r.at(3 * i + 2))
    // empuja los puntos hacia afuera: u -> u³ simétrico
    let afuera(x) = 0.5 + calc.pow(2 * x - 1, 3) / 2 * 0.9 + (2 * x - 1) * 0.05
    let (cx, cy) = (afuera(u) * w, afuera(v) * h)
    let rr = 2.5 + 9 * t
    partes.push("<circle cx='" + str(cx) + "' cy='" + str(cy) + "' r='" + str(rr) + "' fill='" + mancha.to-hex() + "' opacity='" + str(0.18 + 0.25 * t) + "' filter='url(#difuso)'/>")
    partes.push("<ellipse cx='" + str(cx + rr * 0.3) + "' cy='" + str(cy - rr * 0.15) + "' rx='" + str(rr * 0.45) + "' ry='" + str(rr * 0.3) + "' fill='" + mancha.darken(20%).to-hex() + "' opacity='" + str(0.2 + 0.2 * t) + "'/>")
  }

  partes.push(cafe-cuerpo)
  partes.push(rect-todo("fill='url(#borde)' opacity='" + str(bordes / 100%) + "'"))
  if escaneo {
    // el escáner aplana y agrisa un poco; la sombra del lomo, en un borde
    partes.push(rect-todo("fill='#6b6b6b' opacity='0.06'"))
    partes.push(rect-todo("fill='url(#lomo)'"))
  }
  partes.push("</svg>")
  place(image(bytes(partes.join("").replace("−", "-")), format: "svg", width: 100%, height: 100%))
}

// Tinta gastada: un tiling de `tinta` con huecos transparentes, para usar
// como relleno de texto: text(fill: tinta-gastada(negro))[…]. Dos
// ruidos umbralizados: manchones donde el tipo no tocó el papel y
// puntitos sueltos. `intensidad` 0–1, como `desgaste:` de las
// capitulares; `escala` agranda los huecos (1 = pensado para texto de
// 80–200pt). El mosaico es "stitch", así que no se ven las costuras.
#let tinta-gastada(tinta, intensidad: 0.5, escala: 1, semilla: 23, lado: 480) = {
  let k = calc.clamp(intensidad, 0, 1)
  let t = str(lado)
  let (r, g, b) = _rgb01(tinta)
  let umbral(ganancia, a) = "0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  " + str(-ganancia) + " 0 0 0 " + str(a)
  let svg = (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + t + " " + t + "'>",
    "<filter id='g' filterUnits='userSpaceOnUse' x='0' y='0' width='" + t + "' height='" + t + "'>",
    // manchones (umbral más alto con menos intensidad = menos huecos)
    "<feTurbulence type='fractalNoise' baseFrequency='" + str(0.09 / escala) + "' numOctaves='3' seed='" + str(semilla) + "' stitchTiles='stitch' result='n1'/>",
    "<feColorMatrix in='n1' type='matrix' values='" + umbral(14, 9.3 + (1 - k) * 4.3) + "' result='m1'/>",
    // puntitos
    "<feTurbulence type='fractalNoise' baseFrequency='" + str(0.55 / escala) + "' numOctaves='1' seed='" + str(semilla + 9) + "' stitchTiles='stitch' result='n2'/>",
    "<feColorMatrix in='n2' type='matrix' values='" + umbral(18, 12.4 + (1 - k) * 4) + "' result='m2'/>",
    "<feComposite in='m1' in2='m2' operator='in' result='m'/>",
    "<feFlood flood-color='" + tinta.to-hex() + "'/>",
    "<feComposite in2='m' operator='in'/></filter>",
    "<rect x='0' y='0' width='" + t + "' height='" + t + "' filter='url(#g)'/></svg>",
  ).join("").replace("−", "-")
  tiling(size: (lado * 1pt, lado * 1pt), image(bytes(svg), format: "svg", width: lado * 1pt, height: lado * 1pt))
}
