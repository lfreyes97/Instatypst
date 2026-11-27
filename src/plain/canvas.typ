// ─────────────────────────────────────────────────────────────
//  plain/canvas.typ — el lienzo: la base de plain y de todo preset
//
//    canvas(artboard, tm, margin:, content)   la página del artboard con el
//        papel del tema; los elementos que nadie consumió se dibujan como su
//        cuerpo (core/parts, `show-parts`)
//    resolve-brand(b, tm, artboard)           `brand:` es contenido o una
//        función (tinta, artboard) -> contenido
// ─────────────────────────────────────────────────────────────

#import "/src/core/parts.typ": show-parts
#import "/src/core/artboard.typ": dimensions

// El lienzo: la página del artboard con el papel del tema. Es la base de todo
// preset; los elementos que nadie consumió se dibujan como su cuerpo.
#let canvas(artboard, tm, margin: 0pt, content) = {
  let (width, height) = dimensions(artboard)
  page(width: width, height: height, margin: margin, fill: tm.paper, {
    show metadata: show-parts
    content
  })
}

#let resolve-brand(b, tm, artboard) = if type(b) == function { b(tm.ink, artboard) } else { b }
