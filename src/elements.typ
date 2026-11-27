// ─────────────────────────────────────────────────────────────
//  elements.typ — los elementos comunes (spec/vocabulario.md)
//
//  Un elemento es un nombre, no tiene dueño: lo define este archivo y cada
//  preset (o variante) reconoce los que le sirven, por su clave. Lo que un preset
//  no reconoce se dibuja como su cuerpo (parts.typ, `show-parts`).
//
//  Son 28 en el vocabulario; aquí se definen 26. `quote` y `list` son los de la
//  librería estándar de Typst: no se definen, el preset los estiliza con `show`.
//  Todo elemento vive aquí, también los que hoy usa un solo preset (así ningún
//  preset tiene que exportar nombres desde lib); el vocabulario dice de cuál es.
// ─────────────────────────────────────────────────────────────

#import "/src/core/parts.typ" as _parts

#let tag(..props, body) = _parts.part("tag", body, ..props)
#let subhead(..props, body) = _parts.part("subhead", body, ..props)
#let headline(..props, body) = _parts.part("headline", body, ..props)
#let main(..props, body) = _parts.part("main", body, ..props)
#let prose(..props, body) = _parts.part("prose", body, ..props)
#let conclusion(..props, body) = _parts.part("conclusion", body, ..props)
#let epigraph(..props, body) = _parts.part("epigraph", body, ..props)
#let verse(..props, body) = _parts.part("verse", body, ..props)
#let footer(..props, body) = _parts.part("footer", body, ..props)
#let brand(..props, body) = _parts.part("brand", body, ..props)
#let numeral(..props, body) = _parts.part("numeral", body, ..props)
#let versus(..props, body) = _parts.part("versus", body, ..props)
#let date(..props, body) = _parts.part("date", body, ..props)

// grupo atribucion
#let author(..props, body) = _parts.part("author", body, ..props)
#let dates(..props, body) = _parts.part("dates", body, ..props)
#let title-role(..props, body) = _parts.part("title-role", body, ..props)
#let work(..props, body) = _parts.part("work", body, ..props)

// decididos el 26 nov 2026 para traducir los presets de v1 (spec/vocabulario.md)
#let call(..props, body) = _parts.part("call", body, ..props)
#let next(..props, body) = _parts.part("next", body, ..props)
#let hint(..props, body) = _parts.part("hint", body, ..props)
#let handle(..props, body) = _parts.part("handle", body, ..props)
#let coda(..props, body) = _parts.part("coda", body, ..props)
#let gloss(..props, body) = _parts.part("gloss", body, ..props)
#let note(..props, body) = _parts.part("note", body, ..props)
#let caption(..props, body) = _parts.part("caption", body, ..props)
#let pivot(..props, body) = _parts.part("pivot", body, ..props)

// decidido el 27 nov 2026 para portar los calendarios de WallTypst (spec/vocabulario.md).
// Sin cuerpo: sus datos son argumentos (year, month, today, marks), V2 no tiene capa de datos.
#let calendar(..props) = _parts.part("calendar", none, ..props)

// decidido el 27 nov 2026 (relojes de WallTypst). Sin cuerpo: `time` ("HH:MM"), `date`
// (datetime o "AAAA-MM-DD"), `style` ("digital" | "analog"), `show-time` (false: solo la fecha).
#let clock(..props) = _parts.part("clock", none, ..props)

// decidido el 27 nov 2026 (cartel-capas de WallTypst): un carácter protagonista. Lleva cuerpo (el carácter)
// y propiedades; la tabla de traducción lo llamaba «glifo» (elemento nuevo: carácter con cuerpo y propiedades).
#let glyph(..props, body) = _parts.part("glyph", body, ..props)

// decidido el 27 nov 2026 (escala-versiculos de WallTypst): una escala graduada con un punto marcado. Sin cuerpo:
// `total` (cuántas marcas) y `current` (cuál se destaca).
#let ruler(..props) = _parts.part("ruler", none, ..props)
