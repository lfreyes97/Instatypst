// ─────────────────────────────────────────────────────────────
//  lamina.typ — preset «lámina»: una página de una serie numerada
//
//  Reescribe el `carousel-slide` del primer prototipo (social.typ). Una
//  página de carrusel, sobria y legible: arriba una barra de progreso
//  segmentada (un tramo por página, llenos hasta la actual) con el
//  «03 / 08»; debajo, título y texto; al pie, la marca y la indicación de
//  seguir («Desliza →»), que no sale en la última.
//
//  Una lámina es una pieza suelta: no necesita saber de las demás más que su
//  número y el total.
//
//  Se usa desde el namespace `carteles` (carteles.lamina). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "pliego.typ": pliego
#import "carteles/_temas.typ": resolver-tema
#import "carteles/_base.typ": ajustar-alto, resolver-marca

// ── carteles.lamina ─────────────────────────────────────────
//   numero, total  la página y cuántas son («3» de «8»)
//   titulo         contenido: lo que dice esta página
//   texto          contenido: el desarrollo, bajo el título
//   marca          contenido abajo a la izquierda (p. ej. el logo o el @usuario)
//   siguiente      contenido abajo a la derecha, salvo en la última página
//                  (por defecto «Desliza →»; none = nunca)
//   cuerpo-titulo, cuerpo-texto  tamaños máximos; el título se achica solo
//                  hasta caber, y el bloque se centra en el espacio libre
// tema: nombre de `temas-lamina` (por defecto "lamina"), diccionario de roles
// (fondo, tinta, suave, acento) o `carteles.tema-desde-theme(theme.base)`.
// Los parámetros de color pisan al tema; auto = el del tema.
#let lamina(
  numero,
  total,
  titulo,
  texto: none,
  marca: none,
  siguiente: [Desliza →],
  formato: (1080, 1350),
  tema: "lamina",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  fuente: "Literata",
  fuente-rotulos: "Jost",
  cuerpo-titulo: 124pt,
  cuerpo-texto: 46pt,
  margen: 88pt,
) = {
  assert(type(numero) == int and type(total) == int and numero >= 1 and numero <= total,
    message: "lamina: `numero` va de 1 a `total` (recibí " + repr(numero) + " de " + repr(total) + ")")
  let tm = resolver-tema(tema, defecto: "lamina")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let marca = resolver-marca(marca, tinta, formato)
  let suave = if suave == auto { tm.suave } else { suave }
  let acento = if acento == auto { tm.acento } else { acento }
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let util = ancho - 2 * margen
  let lado = calc.min(ancho, alto)

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    set par(leading: 0.3em)

    // ── Barra de progreso: un tramo por página; llenos hasta la actual
    let hueco = 10pt
    let tramo = (util - hueco * (total - 1)) / total
    for i in range(total) {
      place(
        dx: margen + i * (tramo + hueco), dy: margen,
        rect(width: tramo, height: 10pt, radius: 5pt, fill: if i < numero { acento } else { tinta.transparentize(85%) }),
      )
    }

    // ── El contador: «03 / 08»
    let ceros(n) = if total >= 10 and n < 10 { "0" + str(n) } else { str(n) }
    let y = margen + 10pt + 0.04 * lado
    place(dx: margen, dy: y, text(
      font: fuente-rotulos, size: 32pt, weight: 700, tracking: 0.12em, fill: acento,
      ceros(numero) + " / " + ceros(total),
    ))
    let y-texto = y + 32pt + 0.06 * lado

    context {
      // ── Pie: marca a la izquierda, «siguiente» a la derecha (salvo en la última)
      let hay-sig = siguiente != none and numero < total
      let pie = if marca != none or hay-sig {
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          if marca != none { marca },
          if hay-sig { text(font: fuente-rotulos, size: 34pt, weight: 700, fill: acento, siguiente) },
        )
      }
      let h-pie = if pie != none { measure(block(width: util, pie)).height } else { 0pt }
      if pie != none { place(dx: margen, dy: alto - margen - h-pie, block(width: util, pie)) }

      // ── Título y texto: el título se achica hasta caber en su tramo
      let bloque-texto = if texto != none {
        block(width: util, text(font: fuente-rotulos, size: cuerpo-texto, weight: 400, fill: suave, texto))
      }
      let aire = 0.7 * cuerpo-texto
      let h-texto = if bloque-texto != none { measure(bloque-texto).height + aire } else { 0pt }
      let disponible = alto - y-texto - margen - h-pie - 0.04 * alto
      let tope = calc.min(alto * 0.5, disponible - h-texto)
      let hacer(s) = block(width: util, text(size: s, weight: 700, tracking: -0.015em, titulo))
      let s = ajustar-alto(hacer, cuerpo-titulo, tope, minimo: 44pt, paso: 2pt)
      let bloque = block(width: util, {
        hacer(s)
        if bloque-texto != none {
          v(aire + 0.05 * s)
          bloque-texto
        }
      })
      // centrado en el espacio libre, un poco por encima del centro óptico
      let y-bloque = y-texto + calc.max(0pt, disponible - measure(bloque).height) * 0.38
      place(dx: margen, dy: y-bloque, bloque)
    }
  })
}
