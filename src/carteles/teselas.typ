// ─────────────────────────────────────────────────────────────
//  carteles/teselas.typ — preset «teselas»
//
//  Cartel con un bloque cuadrado de teselas — una cuadrícula de 4×4 celdas
//  con algún bloque de 2×2 — en tres colores que rotan de fondo y de
//  figura: discos y «dianas» (un aro con un punto). Encima, un título en
//  negrita, un párrafo y una palabra pesada que se parte en una columna
//  estrecha a la derecha («DE / SI / G / N»).
//
//  Las medidas salen de una lámina de referencia de 300 × 425 y se
//  escalan con el lado menor; en otro formato la lámina queda centrada y el
//  color del papel llena el resto.
//
//  Se usa desde el namespace `carteles` (carteles.teselas). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "_base.typ": medida, escala, ajustar-alto
#import "_temas.typ": resolver-tema

// Lámina de referencia (unidades) y su bloque de teselas.
#let _ref = (300, 425)
#let _margen = 25.1 // a los lados y bajo el bloque
#let _bloque = 250 // lado del bloque (4 celdas)
#let _celda = 62.5

// El bloque de la referencia: una tesela es
//   (col, fila, span, fondo, motivo, color)
// con `span` 1 o 2 (celdas por lado), `fondo` y `color` ROLES del tema
// (acento = carmesí, hondo = azul marino, claro = crema) y `motivo`
// "disco", "diana" o none.
#let bloque-referencia = (
  (0, 0, 2, "acento", "disco", "hondo"),
  (2, 0, 1, "acento", "diana", "claro"),
  (3, 0, 1, "claro", "diana", "hondo"),
  (2, 1, 1, "hondo", "disco", "acento"),
  (3, 1, 1, "acento", "disco", "claro"),
  (2, 2, 2, "claro", "disco", "acento"),
  (0, 2, 1, "acento", "diana", "claro"),
  (1, 2, 1, "hondo", "diana", "claro"),
  (0, 3, 1, "hondo", "diana", "acento"),
  (1, 3, 1, "claro", "disco", "hondo"),
)

// ── carteles.teselas ────────────────────────────────────────
//   frase     el párrafo, en gris y chico
//   remate    la palabra pesada de la derecha: se parte sola en una columna
//             estrecha, justificada a la derecha
//   etiqueta  título en negrita, arriba a la izquierda
//   autor     línea chica bajo el párrafo
//   marca     contenido abajo, centrado en el margen (p. ej. el logo)
//   bloque    las teselas: una lista como `bloque-referencia`
//   tema      nombre de `temas-lamina` (por defecto "teselas"), diccionario
//             de roles o `tema-desde-theme(theme.base)`. Roles: fondo (el
//             papel), tinta, suave (el párrafo), acento, hondo, claro.
//             `fondo`, `tinta`, `suave`, `acento`, `hondo` y `claro`, si se
//             pasan, pisan al tema.
//   fuente    tipografía (por defecto Outfit)
//   cuerpo    tamaño máximo del párrafo, en unidades de la lámina de
//             referencia (300 de ancho); se achica si no cabe
#let teselas(
  frase,
  remate: none,
  etiqueta: none,
  autor: none,
  marca: none,
  formato: (1080, 1350),
  bloque: bloque-referencia,
  tema: "teselas",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  hondo: auto,
  claro: auto,
  fuente: "Outfit",
  cuerpo: 7.4,
) = {
  let (ancho, alto) = medida(formato)
  let s = escala(formato, base: _ref)
  let tm = resolver-tema(tema, defecto: "teselas")
  let rol = (
    fondo: if fondo == auto { tm.fondo } else { fondo },
    tinta: if tinta == auto { tm.tinta } else { tinta },
    suave: if suave == auto { tm.suave } else { suave },
    acento: if acento == auto { tm.acento } else { acento },
    hondo: if hondo == auto { tm.hondo } else { hondo },
    claro: if claro == auto { tm.claro } else { claro },
  )

  // La lámina de referencia, centrada en la página.
  let ox = (ancho - _ref.at(0) * s * 1pt) / 2
  let oy = (alto - _ref.at(1) * s * 1pt) / 2
  let X(u) = ox + u * s * 1pt
  let Y(u) = oy + u * s * 1pt
  let L(u) = u * s * 1pt

  page(width: ancho, height: alto, margin: 0pt, fill: rol.fondo, {
    // ── el bloque de teselas ──
    let bx = _margen
    let by = _ref.at(1) - _margen - _bloque
    for t in bloque {
      let (col, fila, span, rf, motivo, rc) = t
      let lado = _celda * span
      let x = bx + col * _celda
      let y = by + fila * _celda
      place(top + left, dx: X(x), dy: Y(y), box(width: L(lado), height: L(lado), fill: rol.at(rf), {
        let d = L(lado * 0.84)
        let c = (L(lado) - d) / 2
        if motivo == "disco" {
          place(top + left, dx: c, dy: c, circle(radius: d / 2, fill: rol.at(rc)))
        } else if motivo == "diana" {
          place(top + left, dx: c, dy: c, circle(radius: d / 2, fill: rol.at(rc)))
          let h = L(lado * 0.496) // el hueco del aro
          place(top + left, dx: (L(lado) - h) / 2, dy: (L(lado) - h) / 2, circle(radius: h / 2, fill: rol.at(rf)))
          let p = L(lado * 0.198) // el punto central
          place(top + left, dx: (L(lado) - p) / 2, dy: (L(lado) - p) / 2, circle(radius: p / 2, fill: rol.at(rc)))
        }
      }))
    }

    set text(font: fuente, lang: "es", hyphenate: false)
    context {
      // Un texto cuya altura de mayúscula mide `cap` unidades de la lámina,
      // sea cual sea la tipografía.
      // `f` (por defecto 1) lo achica proporcionalmente.
      let cap-h(cap, f: 1, ..args, cuerpo) = {
        let ref = measure(text(size: 100pt, top-edge: "cap-height", bottom-edge: "baseline", ..args, [H])).height
        text(size: f * L(cap) / (ref / 100pt), top-edge: "cap-height", bottom-edge: "baseline", ..args, cuerpo)
      }
      // título
      // (se achica si no cabe en el ancho del párrafo: no llega a la palabra)
      if etiqueta != none {
        let ta = (weight: 800, tracking: 0em, fill: rol.tinta)
        let w = measure(cap-h(13.7, ..ta, upper(etiqueta))).width
        let f = if w > L(190) { L(190) / w } else { 1 }
        place(top + left, dx: X(bx), dy: Y(35.5 + 13.7 * (1 - f)), cap-h(13.7, f: f, ..ta, upper(etiqueta)))
      }
      // palabra pesada, apilada a la derecha: dos letras por línea (la
      // referencia parte «DE / SI / G / N» según el ancho de sus letras, que
      // cambia con la tipografía; dos por línea no depende de ella). Con la
      // caja de línea = altura de mayúscula, `leading` es el hueco exacto.
      if remate != none {
        let plano = if type(remate) == str { remate } else if remate.has("text") { remate.text } else {
          panic("teselas: `remate` es una palabra (str o texto sin formato), no " + repr(remate))
        }
        let letras = upper(plano).clusters()
        let lineas = range(0, letras.len(), step: 2).map(i => letras.slice(i, calc.min(i + 2, letras.len())).join())
        // alto de la pila: no pasa de 112 (hasta 12 unidades sobre el bloque);
        // si no cabe, todo se escala junto
        let alto-pila = (lineas.len() - 1) * 23.5 + 18.4
        let f = calc.min(1, 112 / alto-pila)
        place(top + left, dx: X(bx + _bloque) - L(60), dy: Y(29.1),
          block(width: L(60), align(right, par(leading: L((23.5 - 18.4) * f), justify: false,
            cap-h(18.4, f: f, weight: 800, fill: rol.tinta, lineas.join(linebreak()))))))
      }
      // párrafo
      let ancho-p = L(190.1)
      // el párrafo se achica para caber; con `autor`, deja sitio a su línea
      let hueco = L(if autor == none { 82 } else { 66 })
      let parrafo(c) = block(width: ancho-p, text(size: c, weight: 400, fill: rol.suave, par(leading: 0.5em, justify: false, frase)))
      let c = ajustar-alto(parrafo, L(cuerpo), hueco, minimo: L(5), paso: L(0.2))
      place(top + left, dx: X(bx), dy: Y(62.0), parrafo(c))
      if autor != none {
        place(top + left, dx: X(bx), dy: Y(131),
          text(size: L(7), weight: 700, tracking: 0.12em, fill: rol.tinta, upper(autor)))
      }
    }
    if marca != none {
      place(bottom + center, dy: -(oy + L(5)), marca)
    }
  })
}
