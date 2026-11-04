// ─────────────────────────────────────────────────────────────
//  orlas.typ — presets con orla de fleurones e IM FELL
//
//  La plantilla de redes de Magnalia Dei (~/Proyectos/Magnalia/typst/
//  redes.typ) hecha preset: un lienzo con orla (fleurones.typ) y tres
//  composiciones encima — cita, capítulo y pregunta —, sin Bavinck
//  fijo: encabezado, autor y obra son parámetros. Se usan desde el
//  namespace `carteles` (carteles.cita-orlada…; el lienzo solo,
//  carteles.lienzo-orlado, para armar composiciones propias).
//
//  Cada llamada produce UNA página = UNA imagen.
//    formato   (ancho, alto) en px, como `sizes`. Se clasifica en
//              "cuadrado", "vertical" o "historia" (alto ≥ 1,6 × ancho)
//              y la composición se ajusta a eso.
//    tema      "vino" (cubierta de Magnalia) · "papel" (su interior) ·
//              o un diccionario de roles (fondo, tinta, suave, acento y los
//              de la orla: malla, franja, orn, fil, hondo); lo que falte
//              sale de "vino". Un diccionario viejo con `texto` en vez de
//              `tinta` se sigue entendiendo. Ver carteles/_temas.typ.
//    orla      "completa" · "arriba" · "abajo" · "arriba-abajo" ·
//              "izquierda" · "derecha" · "lateral" · "columna" · "ninguna"
//    cadena    cualquier marco de `fleurones.cadenas`: las cinco de
//              Magnalia ("ojivas" · "cartuchos" · "follaje" · "flores" ·
//              "eslabones") o las nuevas ("celosia", "trenza", "lises"…)
//
//  Licencia de IM FELL FLOWERS: la publicación lleva la nota de
//  `fleurones.credito` donde el medio lo pida (créditos, pie de foto…);
//  estas piezas no la estampan (ver Fonts/IM_Fell_Flowers/LICENCIA.txt).
// ─────────────────────────────────────────────────────────────

#import "fleurones.typ" as fl
#import "carteles/_temas.typ": temas-lamina, resolver-tema

#let fell = "IM FELL English"
#let fellsc = "IM FELL English SC"

// Los dos temas de la orla viven en el registro común (`temas-lamina`);
// aquí, la vista de siempre (`carteles.temas-orla`), con `texto` como
// alias de `tinta` por compatibilidad.
#let temas = (
  vino: temas-lamina.vino + (texto: temas-lamina.vino.tinta),
  papel: temas-lamina.papel + (texto: temas-lamina.papel.tinta),
)

#let _tipo(formato) = {
  let (w, h) = formato
  if h >= 1.6 * w { "historia" } else if h > w { "vertical" } else { "cuadrado" }
}

// Largo aproximado (en caracteres) de un contenido, para ajustar el cuerpo.
#let _largo(x) = {
  if type(x) == str { x.len() }
  else if x.has("text") { _largo(x.text) }
  else if x.has("children") { x.children.map(_largo).sum(default: 0) }
  else if x.has("body") { _largo(x.body) }
  else if x.func() == [ ].func() { 1 }
  else { 0 }
}

// ── Lienzo: orla + campo. `cuerpo` recibe (c, ancho, alto, tipo). ──
#let lienzo-orlado(formato, tema, cuerpo, orla: "completa", cadena: "ojivas") = {
  let (W, H) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let tipo = _tipo(formato)
  // Un diccionario viejo con `texto` (sin `tinta`) se lee como `tinta`.
  let tema = if type(tema) == dictionary and "texto" in tema and not "tinta" in tema { tema + (tinta: tema.texto) } else { tema }
  let c = resolver-tema(tema, defecto: "vino")
  let M = 34pt
  let T = fl.cadenas.at(cadena).grosor
  let G = fl.grosor-tira(cadena)
  let libre = 70pt // margen de los lados sin orla
  let tira(largo) = fl.tira(largo, cadena, c.orn, c.hondo, c.fil)
  page(width: W, height: H, margin: 0pt, fill: c.fondo, {
    set text(font: fell, fill: c.tinta, lang: "es", hyphenate: false)
    set par(justify: false, first-line-indent: 0pt, spacing: 0pt)
    if orla == "completa" {
      place(top + left, dx: M, dy: M, fl.orla(cadena, W - 2 * M, H - 2 * M, c.orn))
      place(top + left, dx: M - 6pt, dy: M - 6pt,
        rect(width: W - 2 * M + 12pt, height: H - 2 * M + 12pt, stroke: 1.2pt + c.hondo))
      place(top + left, dx: M + T + 7pt, dy: M + T + 7pt,
        rect(width: W - 2 * (M + T + 7pt), height: H - 2 * (M + T + 7pt), stroke: 2pt + c.hondo))
      place(top + left, dx: M + T + 13pt, dy: M + T + 13pt,
        rect(width: W - 2 * (M + T + 13pt), height: H - 2 * (M + T + 13pt), stroke: 0.9pt + c.fil))
      let X = M + T + 13pt
      if tipo == "historia" {
        // franjas de malla arriba y abajo: la zona que tapa la interfaz
        let zona = 150pt
        let wc = W - 2 * X
        for (dy, al) in ((X, top), (H - X - zona, bottom)) {
          place(top + left, dx: X, dy: dy, fl.diaper(fl.f1, "AD", wc, zona, 75pt, c.franja))
          let yl = if al == top { dy + zona } else { dy }
          place(top + left, dx: X, dy: yl - 5pt, line(length: wc, stroke: 2pt + c.hondo))
          place(top + left, dx: X, dy: yl + 1pt, line(length: wc, stroke: 0.9pt + c.fil))
        }
      }
      place(top + left, dx: X, dy: X, box(width: W - 2 * X, height: H - 2 * X, cuerpo(c, W - 2 * X, H - 2 * X, tipo)))
    } else {
      let lados = (
        arriba: ("t",), abajo: ("b",), "arriba-abajo": ("t", "b"),
        izquierda: ("l",), derecha: ("r",), lateral: ("l", "r"),
        columna: ("col",), ninguna: (),
      ).at(orla)
      let col = if tipo == "cuadrado" { 210pt } else { 240pt }
      // márgenes del campo
      let mt = if "t" in lados { M + G + 30pt } else { libre }
      let mb = if "b" in lados { M + G + 30pt } else { libre }
      let ml = if "l" in lados { M + G + 30pt } else if "col" in lados { col + G + 40pt } else { libre }
      let mr = if "r" in lados { M + G + 30pt } else { libre }
      if "t" in lados { place(top + left, dx: M, dy: M, tira(W - 2 * M)) }
      if "b" in lados { place(top + left, dx: M, dy: H - M - G, rotate(180deg, tira(W - 2 * M))) }
      if "l" in lados {
        place(top + left, dx: M, dy: M, box(width: G, height: H - 2 * M,
          place(center + horizon, rotate(-90deg, reflow: true, tira(H - 2 * M)))))
      }
      if "r" in lados {
        place(top + left, dx: W - M - G, dy: M, box(width: G, height: H - 2 * M,
          place(center + horizon, rotate(90deg, reflow: true, tira(H - 2 * M)))))
      }
      if "col" in lados {
        // columna de malla a sangre, cerrada por la tira a su derecha
        place(top + left, fl.diaper(fl.f1, "AD", col, H, 80pt, c.franja))
        place(top + left, dx: col, dy: 0pt, box(width: G, height: H,
          place(center + horizon, rotate(90deg, reflow: true, tira(H)))))
      }
      place(top + left, dx: ml, dy: mt,
        box(width: W - ml - mr, height: H - mt - mb, cuerpo(c, W - ml - mr, H - mt - mb, tipo)))
    }
  })
}

// Cabecera y pie comunes dentro del campo
#let _cabecera(c, ancho, texto-sup) = align(center)[
  #text(font: fellsc, size: 30pt, tracking: 0.3em, fill: c.acento)[#texto-sup]
  #v(18pt)
  #fl.divisor(ancho * 0.42, 22pt, c.orn, c.fil)
]
#let _pie(c, firma) = align(center)[
  #fl.roseta(46pt, c.orn)
  #if firma != none {
    v(16pt)
    text(font: fellsc, size: 24pt, tracking: 0.18em, fill: c.suave)[#firma]
  }
]

#let _tam-cita(texto, tipo) = {
  let n = _largo(texto)
  let base = if n > 260 { 42pt } else if n > 170 { 50pt } else if n > 100 { 60pt } else { 76pt }
  if tipo == "historia" { base * 1.12 } else if tipo == "vertical" { base * 1.05 } else { base }
}

// ── Cita: comillas de fleurón, texto en cursiva, autor y fuente ──
#let cita-orlada(
  texto,
  encabezado: none,
  autor: none,
  fuente: none,
  formato: (1080, 1080),
  tema: "vino",
  firma: none,
  tamano: auto,
  orla: "completa",
  cadena: "ojivas",
) = lienzo-orlado(formato, tema, orla: orla, cadena: cadena, (c, w, alto-campo, tipo) => {
  let s = if tamano == auto { _tam-cita(texto, tipo) } else { tamano }
  let segura = if tipo == "historia" { 200pt } else { 46pt }
  box(width: w, height: alto-campo, inset: (x: 64pt, top: segura, bottom: segura), {
    stack(
      dir: ttb,
      if encabezado != none { _cabecera(c, w, encabezado) } else { [] },
      v(1fr),
      align(center, text(font: fell, size: s * 2.4, fill: c.orn)[“]),
      v(s * 0.1),
      align(center, block(width: 100%, text(font: fell, style: "italic", size: s)[
        #set par(leading: 0.42em)
        #texto
      ])),
      v(s * 0.9),
      if autor != none { align(center, text(font: fellsc, size: 30pt, tracking: 0.14em, fill: c.acento, autor)) } else { [] },
      v(8pt),
      if fuente != none { align(center, text(font: fell, style: "italic", size: 26pt, fill: c.suave, fuente)) } else { [] },
      v(1fr),
      _pie(c, firma),
    )
  })
})

// ── Capítulo: anuncio de lectura o de serie, sobre malla ──
#let capitulo-orlado(
  numero,
  titulo,
  subtitulo: none,
  llamada: [Lectura de la semana],
  rotulo: [Capítulo],
  obra: none,
  autor: none,
  formato: (1080, 1080),
  tema: "vino",
  firma: none,
  orla: "completa",
  cadena: "ojivas",
) = lienzo-orlado(formato, tema, orla: orla, cadena: cadena, (c, w, alto-campo, tipo) => {
  let segura = 36pt
  // malla de fondo en todo el campo
  place(fl.diaper(fl.f1, "AD", w, alto-campo, 72pt, c.malla))
  let k = if tipo == "historia" { 1.25 } else if tipo == "vertical" { 1.1 } else { 1.0 }
  box(width: w, height: alto-campo, inset: (x: 44pt, top: segura, bottom: segura), {
    grid(
      columns: 1fr, rows: (1fr, auto), row-gutter: 26pt,
      // cartela principal: ocupa todo el alto disponible, contenido centrado
      block(width: 100%, height: 100%, fill: c.fondo, stroke: 1.6pt + c.hondo, inset: (x: 24pt, y: 36pt))[
        #place(top + left, dx: -18pt, dy: -30pt, rect(width: 100% + 36pt, height: 100% + 60pt, stroke: 0.9pt + c.fil))
        #align(center + horizon)[
          #text(font: fellsc, size: 30pt * k, tracking: 0.3em, fill: c.acento)[#llamada]
          #v(20pt * k)
          #fl.divisor(w * 0.42, 22pt, c.orn, c.fil)
          #v(46pt * k)
          #text(font: fellsc, size: 32pt * k, tracking: 0.32em, fill: c.suave)[#rotulo]
          #v(34pt * k)
          #text(font: fell, size: 150pt * k, fill: c.tinta)[#numbering("I", numero)]
          #v(44pt * k)
          #text(font: fell, size: calc.min(if _largo(titulo) > 28 { 66pt } else { 82pt } * k, (w - 60pt) / (0.36 * calc.max(8, _largo(titulo)))), fill: c.tinta)[
            #set par(leading: 0.35em)
            #titulo]
          #if subtitulo != none {
            v(32pt * k)
            text(font: fell, style: "italic", size: 38pt * k, fill: c.suave)[#subtitulo]
          }
        ]
      ],
      // cartela de pie: obra ✿ autor
      block(width: 100%, fill: c.fondo, stroke: 1.6pt + c.hondo, inset: (x: 20pt, y: 24pt))[
        #align(center)[
          #if obra != none { text(font: fellsc, size: 34pt, tracking: 0.14em, obra) }
          #if obra != none and autor != none [#h(16pt) #box(baseline: -4pt, fl.caja(fl.f2, "C", 18pt, 18pt, c.orn)) #h(16pt)]
          #if autor != none { text(font: fellsc, size: 28pt, tracking: 0.14em, fill: c.acento, autor) }
          #if firma != none {
            v(12pt)
            text(font: fellsc, size: 22pt, tracking: 0.18em, fill: c.suave)[#firma]
          }
        ]
      ],
    )
  })
})

// ── Pregunta de estudio: friso arriba, banda abajo ──
#let pregunta-orlada(
  texto,
  encabezado: [Para la reflexión],
  fuente: none,
  pista: none,
  formato: (1080, 1080),
  tema: "papel",
  firma: none,
  orla: "completa",
  cadena: "cartuchos",
) = lienzo-orlado(formato, tema, orla: orla, cadena: cadena, (c, w, alto-campo, tipo) => {
  let segura = if tipo == "historia" { 200pt } else { 46pt }
  let s = { let n = _largo(texto); if n > 160 { 46pt } else if n > 100 { 54pt } else { 62pt } }
  let s = if tipo == "historia" { s * 1.12 } else { s }
  box(width: w, height: alto-campo, inset: (x: 60pt, top: segura, bottom: segura), {
    stack(
      dir: ttb,
      align(center, fl.friso(w - 120pt, c.orn, c.fil)),
      v(34pt),
      align(center, text(font: fellsc, size: 32pt, tracking: 0.22em, fill: c.acento, encabezado)),
      v(10pt),
      if fuente != none { align(center, text(font: fell, style: "italic", size: 26pt, fill: c.suave, fuente)) } else { [] },
      v(1fr),
      align(center, block(width: 100%, text(font: fell, size: s)[
        #set par(leading: 0.42em)
        #texto
      ])),
      if pista != none { v(30pt) } else { v(0pt) },
      if pista != none {
        align(center, block(width: 88%, text(font: fell, style: "italic", size: s * 0.6, fill: c.suave)[
          #set par(leading: 0.5em)
          #pista
        ]))
      } else { [] },
      v(1fr),
      align(center, fl.banda(fl.f2, "U", w - 120pt, 16pt, c.orn)),
      v(30pt),
      _pie(c, firma),
    )
  })
})
