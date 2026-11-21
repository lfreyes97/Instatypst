// ─────────────────────────────────────────────────────────────
//  core/v2/frame.typ — el contrato de engine_v2: una lámina
//
//    #frame(type: "swiss", format: formats.story, brand: marca)[
//      #eyebrow[DEL ENSAYO]
//      #statement[El calvinismo es simplemente la religión en su]
//      #headline[PUREZA.]
//    ]
//
//  Un documento puede tener N frames, cada uno con su `type`.
//
//  type    el diseño. Un nombre incluido ("swiss", "series") o una FUNCIÓN
//          propia: type(body, format:, theme:, accent:, brand:, ..opciones)
//          que devuelve una página (page).
//  format  (ancho, alto) en px          theme   auto = el del tipo, un nombre o roles
//  accent  auto = el del tema           brand   contenido o función (color, lienzo)
//  ..opciones  se pasan tal cual al tipo (author, dates, next, index, total...):
//          cada tipo declara las suyas y rechaza las que no conoce.
//
//  Los hijos del cuerpo (eyebrow, title...) y su lectura son del TIPO, no de frame:
//  se importan de swiss.typ o series.typ. Una función propia recibe el cuerpo sin leer.
//
//  repeat  none = una lámina. Un entero n = n láminas; un array = una por elemento.
//          Con repeat, el cuerpo es una FUNCIÓN: item => contenido (item es el
//          elemento del array, o el número de página si repeat es un entero).
//          Frame pasa `index` (desde 1) y `total` a cada lámina.
//
//  No importa nada de engine_v1 (src/) ni del toolbox de v1.
// ─────────────────────────────────────────────────────────────

#import "swiss.typ" as swiss-type
#import "series.typ" as series-type

#let types = ("swiss": swiss-type.make, "series": series-type.make)

#let frame(
  type: "swiss",
  format: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  repeat: none,
  ..options,
  body,
) = {
  // `type` es el nombre del argumento y tapa a la función `type()` de Typst: usar std.
  let make = if std.type(type) == function { type } else if std.type(type) == str and type in types { types.at(type) } else {
    panic("frame: tipo desconocido " + repr(type) + " (hay: " + types.keys().join(", ") + "; o pasa una función)")
  }
  let common = (format: format, theme: theme, accent: accent, brand: brand)

  if repeat == none {
    make(body, ..common, ..options.named())
  } else {
    let items = if std.type(repeat) == array { repeat } else if std.type(repeat) == int { range(1, repeat + 1) } else {
      panic("frame: `repeat` es un entero o un array, no " + repr(std.type(repeat)))
    }
    assert(std.type(body) == function, message: "frame: con `repeat`, el cuerpo es una función item => contenido")
    for (i, item) in items.enumerate() {
      make(body(item), ..common, index: i + 1, total: items.len(), ..options.named())
    }
  }
}
