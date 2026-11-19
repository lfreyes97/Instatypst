// ─────────────────────────────────────────────────────────────
//  estilo.typ — ayudas para escribir un estilo propio
//
//  Un estilo propio es una función tuya que recibe UNA cosa: la pieza ya
//  resuelta (formato en px, paleta en sus roles, bloques separados, opciones,
//  marca, posición en la serie). Tú dibujas; esto te evita buscar en el
//  diccionario.
//
//    // layouts/mi-estilo.typ
//    #import "@local/instatypst:0.1.0": *
//    #let mi-estilo(pieza) = {
//      let (w, h) = estilo.formato(pieza)
//      let c = estilo.paleta(pieza)
//      page(width: w, height: h, fill: c.background, {
//        text(fill: c.text, estilo.texto(pieza, "title"))
//      })
//    }
//
//    # en el documento de piezas
//    style = { file = "layouts/mi-estilo.typ", fn = "mi-estilo" }
//
//  La pieza (nombres del contrato, en inglés):
//    name      nombre de la pieza
//    index     posición (1…) en el documento, y total: cuántas son
//    format    (ancho, alto) en px, o `none` si la pieza no lo declara
//    palette   (background, text, muted, accent, line) como colores, o `none` si la
//              pieza no declara paleta
//    blocks    lista de bloques en el orden escrito; cada uno es un diccionario
//              con `type` y sus campos (title: text; attribution: author, role,
//              work, date; number: value, total; date: day, month; epigraph:
//              text, source; verse: lines; list: order, items; contrast: left,
//              right). Los textos son contenido; los bloques llegan con su tipo
//              real, sin el parentesco de los presets (verse no es quote aquí).
//    options   las opciones de la pieza, tal cual
//    variant, typography, background, brand   lo que la pieza declare, o `none`;
//              `brand` es una función (color, lienzo) -> contenido (ver marca.typ)
//    Las claves siempre existen: `pieza.format` no rompe, vale `none`.
// ─────────────────────────────────────────────────────────────

// Todos los bloques de un tipo, en orden.
#let bloques(pieza, tipo) = pieza.blocks.filter(b => b.type == tipo)

// El primero de un tipo, o `none`.
#let bloque(pieza, tipo) = {
  let bs = bloques(pieza, tipo)
  if bs.len() == 0 { none } else { bs.first() }
}

// El texto del primer bloque de un tipo (`text`), o `defecto`.
#let texto(pieza, tipo, defecto: none) = {
  let b = bloque(pieza, tipo)
  if b == none or "text" not in b { defecto } else { b.text }
}

// El valor de una clave de la pieza, o `defecto` si no está o es `none`.
#let _o(pieza, clave, defecto) = {
  let v = pieza.at(clave, default: none)
  if v == none { defecto } else { v }
}

// El formato como (ancho, alto) en pt, o `defecto` (en px) si la pieza no lo declara.
#let formato(pieza, defecto: (1080, 1350)) = {
  let f = _o(pieza, "format", defecto)
  (f.at(0) * 1pt, f.at(1) * 1pt)
}

// La paleta, o `defecto` si la pieza no declara una.
#let paleta(pieza, defecto: (background: rgb("#141414"), text: rgb("#f5f5f5"), muted: rgb("#a0a0a0"), accent: rgb("#e94560"), line: rgb("#a0a0a0"))) = _o(pieza, "palette", defecto)

// La marca ya dibujada para este lienzo y este color, o `none`.
#let marca(pieza, color) = {
  let m = _o(pieza, "brand", none)
  if m == none { none } else { m(color, _o(pieza, "format", (1080, 1350))) }
}
