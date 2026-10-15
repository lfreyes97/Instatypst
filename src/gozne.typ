// ─────────────────────────────────────────────────────────────
//  gozne.typ — preset «gozne»: cita + diagrama radial de dibujo técnico
//
//  Cosechado de la lámina 07 (trabajos/campana/07-imputacion-gozne.typ): de un
//  lado la cita entera, con llamadas numeradas voladas; del otro, un
//  gozne visto desde arriba —el perno es la idea central— con N hojas
//  que giran sobre él, cada una con su disco numerado y su rótulo, igual
//  que las llamadas de la cita. Flechas de giro entre hojas y la órbita
//  punteada del giro completo.
//
//    #import "gozne.typ": gozne, llamada
//    #gozne(
//      [[La imputación] es el gozne … la raza#llamada(1), …],
//      [La \ imputación],
//      ([La pecaminosidad \ de la raza], [La satisfacción \ de Cristo], …),
//      formato: (1600, 900), autor: [B. B. Warfield], obra: [La imputación],
//    )
//
//  Arma la página entera (page()). Sin marca propia: el logo entra por
//  `marca:` como contenido ya hecho.
// ─────────────────────────────────────────────────────────────

#import "superbg/lib.typ" as superbg

// Texto plano de un contenido (para medir palabra por palabra).
#let _plano(c) = {
  if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_plano).join() }
  else if c.has("body") { _plano(c.body) }
  else if c == [ ] { " " }
  else { "" }
}

// El tamaño más grande (de `max` hacia abajo, de a `paso`) con el que
// `hacer(tamaño)` cabe en `ancho` × `alto`, sin que su palabra más larga
// se salga del ancho. Copia de `ajustar` de campana/_comun.typ. Usar
// dentro de `context`.
#let _ajustar(hacer, ancho, alto, texto: none, max: 140pt, min: 24pt, paso: 2pt) = {
  let palabras = if texto == none { () } else {
    _plano(texto).split(regex("\\s+")).filter(p => p != "")
  }
  let cabe(s) = {
    let larga = if palabras.len() == 0 { 0pt } else {
      calc.max(..palabras.map(p => measure(text(size: s, p)).width))
    }
    larga <= ancho and measure(block(width: ancho, hacer(s))).height <= alto
  }
  let s = max
  while s > min and not cabe(s) { s -= paso }
  hacer(s)
}

// Llamada numerada volada, para marcar en la cita la hoja n del
// diagrama: [la satisfacción de Cristo#llamada(2)]. Toma el color y la
// letra de acento del gozne() que la contiene (show rule sobre la
// etiqueta), así que no hay que repetirlos.
#let llamada(n) = [#super(typographic: false, size: 0.62em, str(n))<gozne-llamada>]

// ── gozne ───────────────────────────────────────────────────
//   cita     contenido: la cita entera, con sus #llamada(n)
//   centro   rótulo del perno (contenido corto, 1–2 renglones)
//   hojas    array de rótulos, uno por hoja; la hoja i lleva el disco i
//   autor, obra    pie: autor en negrita, «— obra» en cursiva gris
//   marca    contenido para el pie, a la derecha (p. ej. el logo)
//
//  Disposición según el formato: apaisado (ancho > 1,2 × alto) -> cita a
//  la izquierda, diagrama a la derecha; vertical o cuadrado -> cita
//  arriba, diagrama debajo, pie a todo el ancho. Los tamaños de letra
//  escalan con √(ancho × alto) (1 en 1600×900); el diagrama, con lo que
//  quepa en su zona.
//
//  A mano (todo opcional, auto por defecto):
//   angulos   ángulos de las hojas; auto = la primera hacia arriba y el
//             resto repartido parejo en sentido horario
//   diagrama  (x:, y:, escala:) esquina superior izquierda de la caja del
//             dibujo (760 × 740 a escala 1) y su escala
//   rotulos   array de (x:, y:, lado:) por hoja: caja de 330 de ancho en
//             (x, y), con el disco a la izquierda (lado: left) o a la
//             derecha (lado: right)
//
//  En auto, cada rótulo va pegado al extremo de su hoja: si la hoja es
//  casi vertical, al costado izquierdo de la punta; si no, debajo (o
//  encima) de la punta, corrido hacia el perno si la hoja va en diagonal
//  y hacia afuera si no. Rótulos y órbita entran
//  enteros en la zona del diagrama.
//
//  Hasta 5 hojas se sostiene; con 4 o más, las hojas y las puntas de las
//  flechas se afinan para no tocarse.
#let gozne(
  cita,
  centro,
  hojas,
  formato: (1600, 900),
  autor: none,
  obra: none,
  marca: none,
  papel: rgb("#ece8df"),
  tinta: rgb("#1f262d"),
  gris: rgb("#525a61"), // ≈ 6:1 sobre el papel
  acento: rgb("#a8361f"), // ≈ 5.6:1 sobre el papel
  claro: rgb("#f7f1e6"),
  fuente: "Instrument Sans",
  fuente-cita: "Libre Baskerville",
  angulos: auto,
  diagrama: auto,
  rotulos: auto,
) = {
  let (W, H) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  // unidad tipográfica: 1 en 1600×900, crece con el área
  let u = calc.sqrt(formato.at(0) * formato.at(1)) / calc.sqrt(1600 * 900)
  let apaisado = W > H * 1.2

  let n = hojas.len()
  let angs = if angulos == auto { range(n).map(i => -90deg + i * 360deg / n) } else { angulos }
  let paso = 360deg / n
  // con 4 o más hojas se afinan hojas y flechas para que no se toquen
  let k = if n <= 3 { 1 } else { paso / 120deg }
  let esc(v) = if k == 1 { v } else { v * k }

  // ── El gozne (SVG): caja de 760×740, perno en (380, 380) ──
  let cx = 380
  let cy = 380
  let polar(r, a) = (cx + r * calc.cos(a), cy + r * calc.sin(a))
  let pt(p) = str(p.at(0)) + " " + str(p.at(1))
  let mw = esc(40) // medio ancho de la hoja

  let hoja(a) = {
    let nn = a + 90deg
    let (r0, r1) = (96, 292)
    let esq = (polar(r0, a), polar(r1, a))
    let off(p, s) = (p.at(0) + s * mw * calc.cos(nn), p.at(1) + s * mw * calc.sin(nn))
    let d = "M " + pt(off(esq.at(0), 1)) + " L " + pt(off(esq.at(1), 1)) + " L " + pt(off(esq.at(1), -1)) + " L " + pt(off(esq.at(0), -1)) + " Z"
    let agujeros = (165, 240).map(r => {
      let p = polar(r, a)
      "<circle cx='" + str(p.at(0)) + "' cy='" + str(p.at(1)) + "' r='" + str(esc(11)) + "' fill='" + papel.to-hex() + "'/>"
    }).join("")
    "<path d='" + d + "' fill='" + tinta.to-hex() + "' stroke='" + tinta.to-hex() + "' stroke-width='10' stroke-linejoin='round'/>" + agujeros
  }

  // Arco de giro entre dos hojas, con punta de flecha al final.
  let arco(a) = {
    let r = 190
    let (a0, a1) = (a + paso * 28 / 120, a + paso * 92 / 120)
    let p0 = polar(r, a0)
    let p1 = polar(r, a1)
    // punta: triángulo tangente al final del arco
    let t = a1 + 90deg
    let nn = a1
    let base = esc(15)
    let q1 = (p1.at(0) + base * calc.cos(nn), p1.at(1) + base * calc.sin(nn))
    let q2 = (p1.at(0) - base * calc.cos(nn), p1.at(1) - base * calc.sin(nn))
    let tip = (p1.at(0) + esc(26) * calc.cos(t), p1.at(1) + esc(26) * calc.sin(t))
    "<path d='M " + pt(p0) + " A " + str(r) + " " + str(r) + " 0 0 1 " + pt(p1) + "' fill='none' stroke='" + acento.to-hex() + "' stroke-width='5' stroke-linecap='round'/>" + "<path d='M " + pt(q1) + " L " + pt(tip) + " L " + pt(q2) + " Z' fill='" + acento.to-hex() + "'/>"
  }

  let svg = (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 760 740'>",
    // órbita: el giro completo de las hojas
    "<circle cx='380' cy='380' r='330' fill='none' stroke='" + tinta.to-hex() + "' stroke-opacity='0.35' stroke-width='2' stroke-dasharray='4 12' stroke-linecap='round'/>",
    angs.map(arco).join(""),
    angs.map(hoja).join(""),
    // perno (nudillo del gozne)
    "<circle cx='380' cy='380' r='112' fill='" + acento.to-hex() + "'/>",
    "<circle cx='380' cy='380' r='98' fill='none' stroke='" + claro.to-hex() + "' stroke-opacity='0.55' stroke-width='2'/>",
    "</svg>",
  ).join("")

  // ── Rótulos de las hojas ──
  // Disco numerado, como la llamada de la cita.
  let disco(i) = box(baseline: 0.18em, circle(radius: 17pt * u, fill: acento, inset: 0pt,
    align(center + horizon, text(weight: 700, size: 22pt * u, fill: claro, str(i)))))
  // Lleva fondo de papel para cortar la órbita punteada por detrás.
  let rotulo(i, cuerpo, lado) = {
    let t = text(size: 30pt * u, weight: 600, par(leading: 0.3em, cuerpo))
    let celdas = if lado == left { (disco(i), t) } else { (t, disco(i)) }
    block(fill: papel, inset: (x: 8pt * u, y: 6pt * u),
      grid(columns: 2, column-gutter: 12pt * u, align: (lado + top, lado + top), ..celdas))
  }

  // Lado y posición automáticos de cada rótulo, relativos al perno, a
  // escala s. Devuelve (x, y, lado) de la esquina superior izquierda.
  let ubicar(a, s, w, h) = {
    let (c, sn) = (calc.cos(a), calc.sin(a))
    let hw = (mw + 5) * s * 1pt // medio grosor de la hoja, con su trazo
    let (tx, ty) = (292 * s * c * 1pt, 292 * s * sn * 1pt) // punta de la hoja
    if calc.abs(c) < 0.5 {
      // casi vertical: al costado izquierdo de la punta
      let x = tx - hw - 7pt * s - w
      let y = if sn < 0 { ty - 32pt * s } else { ty + 32pt * s - h }
      (x, y, right)
    } else {
      // debajo (o encima) de la punta. Corrido hacia el perno solo si la
      // hoja va en diagonal (como en la 07); si es casi horizontal, hacia
      // el perno pisaría la flecha que llega por debajo, y si es empinada,
      // chocaría con el rótulo de la hoja vecina: ahí, hacia afuera.
      let corrida = if calc.abs(sn) >= 0.4 and calc.abs(c) >= 0.7 { -0.2 } else { 0.2 }
      let x = tx + (if c > 0 { corrida } else { -corrida }) * w - w / 2
      let y = if sn >= 0 { ty + hw * calc.abs(c) + 35pt * s } else { ty - hw * calc.abs(c) - 35pt * s - h }
      (x, y, left)
    }
  }

  page(width: W, height: H, margin: 0pt, fill: papel, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    show <gozne-llamada>: it => text(font: fuente, weight: 700, fill: acento, it)

    // Papel de plano: cuadrícula tenue + grano.
    superbg.superbg((capas: (
      (tipo: "plano", color: papel),
      (tipo: "patron", patron: "grid", color: tinta, paso: 40, grosor: 1, opacidad: 6%),
      (tipo: "ruido", color: tinta, opacidad: 4%),
    )), size: formato)

    let hacer-cita(s) = text(font: fuente-cita, size: s, par(leading: 0.66em, cita))
    let pie = text(size: 30pt * u)[
      #if autor != none { text(weight: 700, autor) } #h(8pt * u) #if obra != none { text(fill: gris)[— #emph(obra)] }
    ]

    context {
      // ── Cita, pie y zona del diagrama, según el formato ──
      let (zona, maqueta) = if apaisado {
        (
          (x: W * 820 / 1600, y: H * 40 / 900, w: W * 760 / 1600, h: H * 740 / 900),
          {
            // Columna de la cita (centrada en vertical sobre el pie)
            place(top + left, dx: W * 96 / 1600, dy: H * 80 / 900, block(width: W * 660 / 1600, height: H * 640 / 900, align(horizon,
              _ajustar(hacer-cita, W * 660 / 1600, H * 620 / 900, texto: cita, max: 46pt * u, min: 32pt * u, paso: 1pt),
            )))
            // Pie: atribución y marca, bajo la columna
            place(top + left, dx: W * 96 / 1600, dy: H * 772 / 900, line(length: W * 660 / 1600, stroke: 1.2pt * u + tinta))
            place(top + left, dx: W * 96 / 1600, dy: H * 796 / 900, pie)
            if marca != none { place(top + right, dx: -W * 96 / 1600, dy: H * 794 / 900, marca) }
          },
        )
      } else {
        let m = W * 0.08
        let base-pie = H - 128pt * u
        // cita arriba: hasta el 42 % del alto útil
        let libre = base-pie - m - 40pt * u
        let c = _ajustar(hacer-cita, W - 2 * m, libre * 0.42, texto: cita, max: 46pt * u, min: 26pt * u, paso: 1pt)
        let hc = measure(block(width: W - 2 * m, c)).height
        let y0 = m + hc + 40pt * u
        (
          (x: m, y: y0, w: W - 2 * m, h: base-pie - 30pt * u - y0),
          {
            place(top + left, dx: m, dy: m, block(width: W - 2 * m, c))
            // pie a todo el ancho
            place(top + left, dx: m, dy: base-pie, line(length: W - 2 * m, stroke: 1.2pt * u + tinta))
            place(top + left, dx: m, dy: base-pie + 24pt * u, pie)
            if marca != none { place(top + right, dx: -m, dy: base-pie + 22pt * u, marca) }
          },
        )
      }
      maqueta

      // ── Escala y posición del diagrama ──
      let medidas = hojas.enumerate().map(((i, cuerpo)) => {
        let lado = if rotulos == auto { ubicar(angs.at(i), 1, 0pt, 0pt).at(2) } else { rotulos.at(i).lado }
        measure(rotulo(i + 1, cuerpo, lado))
      })
      // caja que ocupan órbita + rótulos, relativa al perno, a escala s
      let extension(s) = {
        let r = 331pt * s
        let (x0, y0, x1, y1) = (-r, -r, r, r)
        for (i, a) in angs.enumerate() {
          let (w, h) = (medidas.at(i).width, medidas.at(i).height)
          let (x, y, _) = ubicar(a, s, w, h)
          x0 = calc.min(x0, x)
          y0 = calc.min(y0, y)
          x1 = calc.max(x1, x + w)
          y1 = calc.max(y1, y + h)
        }
        (x0, y0, x1, y1)
      }
      let (X, Y, s) = if diagrama != auto { (diagrama.x, diagrama.y, diagrama.escala) } else {
        let s = u
        let (x0, y0, x1, y1) = extension(s)
        while s > 0.2 and (x1 - x0 > zona.w or y1 - y0 > zona.h) {
          s -= 0.01
          (x0, y0, x1, y1) = extension(s)
        }
        // perno donde la caja queda centrada en la zona
        let pcx = zona.x + (zona.w - (x1 - x0)) / 2 - x0
        let pcy = zona.y + (zona.h - (y1 - y0)) / 2 - y0
        (pcx - 380pt * s, pcy - 380pt * s, s)
      }

      place(top + left, dx: X, dy: Y, image(bytes(svg), format: "svg", width: 760pt * s, height: 740pt * s))

      // Rótulo del perno.
      place(top + left, dx: X + 380pt * s - 100pt * s, dy: Y + 380pt * s - 40pt * s, block(width: 200pt * s, height: 80pt * s,
        align(center + horizon, text(size: 30pt * s, weight: 700, fill: claro, par(leading: 0.3em, centro)))))

      // Rótulos de las hojas, al extremo de cada una.
      for (i, cuerpo) in hojas.enumerate() {
        if rotulos != auto {
          let r = rotulos.at(i)
          place(top + left, dx: r.x, dy: r.y, block(width: 330pt * u, align(r.lado, rotulo(i + 1, cuerpo, r.lado))))
        } else {
          let (w, h) = (medidas.at(i).width, medidas.at(i).height)
          let (x, y, lado) = ubicar(angs.at(i), s, w, h)
          place(top + left, dx: X + 380pt * s + x, dy: Y + 380pt * s + y, rotulo(i + 1, cuerpo, lado))
        }
      }
    }
  })
}
