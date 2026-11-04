// ─────────────────────────────────────────────────────────────
//  carteles/_texto.typ — la capa de texto de teselas y mosaico
//
//  Título en negrita, párrafo en gris, una palabra pesada apilada (dos letras
//  por línea) y una línea de autor. Cada preset decide DÓNDE van, con una
//  `zona`, y a qué escala, con `k`; aquí está lo que no cambia: las alturas de
//  letra se ajustan midiendo la tipografía (la misma altura de mayúscula sea
//  cual sea la fuente) y cada pieza se achica si no cabe en su caja.
//
//  Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────
#import "_base.typ": ajustar-alto

// ── capa-texto ──────────────────────────────────────────────
//   L, X, Y   las funciones del preset: una medida de su lámina de
//             referencia a pt, y una posición (x o y) a pt de la página
//   tinta, suave   colores del título y la pila / del párrafo
//   zona      dónde va cada pieza, en unidades de la lámina del preset:
//               titulo   (x, y, ancho)   y = arriba de las mayúsculas; el
//                        título se achica si pasa de `ancho`
//               parrafo  (x, y, ancho, alto, alto-autor)   la caja del
//                        párrafo; con `autor` se usa `alto-autor`
//               pila     (derecha, y, alto)   borde derecho y arriba de la
//                        pila; si no cabe en `alto`, se escala entera
//               autor    (x, y)
//   k         escala de los tamaños: 1 = los de la lámina de `teselas`
//             (300 de ancho); una lámina de 802 de ancho usa k = 2,675
//   cuerpo    tamaño máximo del párrafo, en unidades de la lámina del preset
//   fuente    tipografía de la capa (auto = la del contenedor)
#let capa-texto(
  L, X, Y,
  tinta, suave,
  zona,
  k: 1,
  etiqueta: none,
  frase: none,
  remate: none,
  autor: none,
  cuerpo: 7.4,
  fuente: auto,
) = context {
  // La capa fija su propio espaciado y tipografía: no hereda los del preset
  // (mosaico pone `tracking: 0.65em` a sus rótulos, y aquí no debe llegar).
  set text(tracking: 0em, weight: 400)
  set text(font: fuente) if fuente != auto
  // Un texto cuya altura de mayúscula mide `cap` unidades, sea cual sea la
  // tipografía; `f` (por defecto 1) lo achica proporcionalmente.
  let cap-h(cap, f: 1, ..args, texto) = {
    let ref = measure(text(size: 100pt, top-edge: "cap-height", bottom-edge: "baseline", ..args, [H])).height
    text(size: f * L(cap) / (ref / 100pt), top-edge: "cap-height", bottom-edge: "baseline", ..args, texto)
  }

  // título (se achica si no cabe en su ancho: no llega a la pila)
  if etiqueta != none {
    let z = zona.titulo
    let ta = (weight: 800, tracking: 0em, fill: tinta)
    let cap = 13.7 * k
    let w = measure(cap-h(cap, ..ta, upper(etiqueta))).width
    let f = if w > L(z.ancho) { L(z.ancho) / w } else { 1 }
    place(top + left, dx: X(z.x), dy: Y(z.y + cap * (1 - f)), cap-h(cap, f: f, ..ta, upper(etiqueta)))
  }

  // palabra pesada, apilada a la derecha: dos letras por línea. (La
  // referencia parte «DE / SI / G / N» según el ancho de sus letras, que
  // cambia con la tipografía; dos por línea no depende de ella.) Con la
  // caja de línea = altura de mayúscula, `leading` es el hueco exacto.
  if remate != none {
    let z = zona.pila
    let plano = if type(remate) == str { remate } else if remate.has("text") { remate.text } else {
      panic("`remate` es una palabra (str o texto sin formato), no " + repr(remate))
    }
    let letras = upper(plano).clusters()
    let lineas = range(0, letras.len(), step: 2).map(i => letras.slice(i, calc.min(i + 2, letras.len())).join())
    let (cap, paso) = (18.4 * k, 23.5 * k)
    // si la pila no cabe en `alto`, todo se escala junto
    let f = calc.min(1, z.alto / ((lineas.len() - 1) * paso + cap))
    place(top + left, dx: X(z.derecha) - L(60 * k), dy: Y(z.y),
      block(width: L(60 * k), align(right, par(leading: L((paso - cap) * f), justify: false,
        cap-h(cap, f: f, weight: 800, fill: tinta, lineas.join(linebreak()))))))
  }

  // párrafo: se achica para caber; con `autor`, deja sitio a su línea
  if frase != none {
    let z = zona.parrafo
    let hueco = L(if autor == none { z.alto } else { z.alto-autor })
    let parrafo(c) = block(width: L(z.ancho), text(size: c, weight: 400, fill: suave, par(leading: 0.5em, justify: false, frase)))
    let c = ajustar-alto(parrafo, L(cuerpo), hueco, minimo: L(5 * k), paso: L(0.2 * k))
    place(top + left, dx: X(z.x), dy: Y(z.y), parrafo(c))
  }

  if autor != none {
    let z = zona.autor
    place(top + left, dx: X(z.x), dy: Y(z.y),
      text(size: L(7 * k), weight: 700, tracking: 0.12em, fill: tinta, upper(autor)))
  }
}
