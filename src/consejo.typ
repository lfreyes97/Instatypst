// ─────────────────────────────────────────────────────────────
//  consejo.typ — preset «consejo»: un número, una idea
//
//  Reescribe el `tip-card` del primer prototipo (social.typ). Un color
//  sólido y tipografía: el número es una letra gigante, en tono sobre tono,
//  que sangra por el borde inferior derecho; encima, la etiqueta, el título
//  en sans pesada y la explicación. Sirve para consejos, pasos, razones,
//  puntos de una serie: cualquier cosa que lleve numeral.
//
//  Se usa desde el namespace `carteles` (carteles.consejo). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "pliego.typ": pliego
#import "carteles/_temas.typ": resolver-tema
#import "carteles/_base.typ": ajustar-alto, resolver-marca, cuerpo-al-ancho

// ── carteles.consejo ────────────────────────────────────────
//   numero      el numeral (número o texto): la letra gigante del fondo
//   titulo      contenido: la idea, en pocas palabras
//   texto       contenido: la explicación, bajo el título
//   etiqueta    contenido corto en una píldora sobre el título («Consejo 3»)
//   marca       contenido abajo a la izquierda (p. ej. el logo o el @usuario)
//   cuerpo-titulo, cuerpo-texto  tamaños máximos (el título crece más en
//               formatos altos); el título se achica solo hasta caber en la
//               mitad superior
// tema: nombre de `temas-lamina` (por defecto "consejo"), diccionario de roles
// (fondo, tinta, suave, sombra…) o `carteles.tema-desde-theme(theme.base)`.
// `sombra` es el tono del numeral (la tinta, muy rebajada en el fondo).
// Los parámetros de color pisan al tema; auto = el del tema.
#let consejo(
  numero,
  titulo,
  texto: none,
  etiqueta: none,
  marca: none,
  formato: (1080, 1350),
  tema: "consejo",
  fondo: auto,
  tinta: auto,
  suave: auto,
  sombra: auto,
  fuente: "Jost",
  cuerpo-titulo: 112pt,
  cuerpo-texto: 44pt,
  margen: 88pt,
) = {
  let tm = resolver-tema(tema, defecto: "consejo")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let marca = resolver-marca(marca, tinta, formato)
  let suave = if suave == auto { tm.suave } else { suave }
  let sombra = if sombra == auto { tm.sombra } else { sombra }
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let util = ancho - 2 * margen
  let lado = calc.min(ancho, alto)
  // en formatos más altos que 4:5 (story) el numeral y el título crecen con la proporción
  let alta = if alto / ancho > 1.5 { alto / ancho / 1.25 } else { 1 }

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: false)
    set par(leading: 0.28em)

    context {
      // ── El numeral: abajo a la derecha, sangrando por el borde
      let hacer-num(s) = text(size: s, weight: 900, fill: sombra, top-edge: "cap-height", bottom-edge: "baseline", [#numero])
      let s-num = calc.min(lado * 1.0 * alta, cuerpo-al-ancho(hacer-num, ancho * 0.98))
      let num = hacer-num(s-num)
      let (nw, nh) = (measure(num).width, measure(num).height)
      place(dx: ancho - nw + 0.04 * ancho, dy: alto - nh + 0.07 * alto, num)

      // ── La etiqueta, arriba
      let y = margen
      if etiqueta != none {
        let pildora = box(
          fill: tinta, radius: 100pt, inset: (x: 30pt, y: 14pt),
          text(size: 26pt, weight: 700, tracking: 0.16em, fill: fondo, upper(etiqueta)),
        )
        place(dx: margen, dy: y, pildora)
        y += measure(pildora).height + 0.045 * alto
      }

      // ── La marca, abajo a la izquierda
      let h-marca = if marca != none { measure(marca).height } else { 0pt }
      if marca != none { place(dx: margen, dy: alto - margen - h-marca, marca) }

      // ── Título y texto: el título se achica hasta caber en el alto que le toca
      let bloque-texto = if texto != none {
        block(width: util, text(size: cuerpo-texto, weight: 500, fill: tinta, texto))
      }
      let aire = 0.5 * cuerpo-texto
      let h-texto = if bloque-texto != none { measure(bloque-texto).height + aire } else { 0pt }
      let tope = calc.min(alto * 0.5, alto - y - margen - h-marca - 0.04 * alto - h-texto)
      let hacer(s) = block(width: util, text(size: s, weight: 800, tracking: -0.02em, titulo))
      let s = ajustar-alto(hacer, cuerpo-titulo * alta, tope, minimo: 48pt, paso: 2pt)
      let bloque = {
        hacer(s)
        if bloque-texto != none {
          v(aire + 0.05 * s)
          bloque-texto
        }
      }
      place(dx: margen, dy: y, block(width: util, bloque))
    }
  })
}
