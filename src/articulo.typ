// ─────────────────────────────────────────────────────────────
//  ARTICULO — plantilla editorial que junta las tres piezas del proyecto:
//    color        -> palettes.typ   (paleta -> tema)
//    tipografía   -> font-pairings.typ (pareja -> tema)
//    letra capital -> Dropcaps/dropcaps.typ (capitular)
//
//  Uso:
//    #import "articulo.typ": articulo, primer-parrafo
//    #show: articulo.with(
//      titulo: "...", categoria: "...", autor: "...", fecha: "...",
//      paleta: "terracota", tipografia: "editorial-clasico",
//    )
//    #primer-parrafo[Cuerpo del primer párrafo...]
//    Resto del cuerpo normal, con encabezados == y == si hace falta.
//  ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "palettes.typ": palettes
#import "font-pairings.typ": pairings
#import "dropcaps.typ": capitular

// Combina una paleta de color (palettes.typ) y/o una pareja tipográfica
// (font-pairings.typ) en un solo tema. Cualquiera de las dos es opcional —
// lo que no se pase, queda en el tema base (theme.base).
#let make-theme(paleta: none, tipografia: none, nombre: none) = {
  let t = theme.base
  if paleta != none { t = (theme.with)(t, colors: (palettes.as-theme)(paleta).colors) }
  if tipografia != none { t = (theme.with)(t, fonts: (pairings.resolve)(tipografia)) }
  let nombre = if nombre != none {
    nombre
  } else {
    (paleta, tipografia).filter(x => x != none).join("+")
  }
  if nombre != "" { t = (theme.named)(t, nombre) }
  t
}

// Fondo "claro" seguro para texto en `primary`/`dark`. Usa `light` del tema
// si tiene buen contraste (AA) contra ambos; si no, cae a `white`.
//
// Hace falta porque `light` no siempre es un color realmente claro: en una
// paleta monocromática como "granates" (un degradado de rojos, sin ningún
// tono cercano al blanco), `auto-roles()` igual tiene que asignar algo a
// `light` — y termina siendo un rojo parecido a `primary`, con texto
// prácticamente ilegible encima. `white` en cambio es siempre blanco puro
// sin importar la paleta (auto-roles lo fija así), así que es la opción
// segura cuando `light` no contrasta lo suficiente.
#let fondo-editorial(t) = {
  let ok = (theme.is-aa)(t.colors.primary, t.colors.light) and (theme.is-aa)(t.colors.dark, t.colors.light)
  if ok { t.colors.light } else { t.colors.white }
}

// El tema activo se guarda en estado de documento (no en una variable #let)
// para que `primer-parrafo` — llamado por el usuario DENTRO del cuerpo,
// fuera del scope léxico de `articulo()` — pueda leerlo igual. Un #let
// normal no serviría: quedaría fijo al valor de cuando se definió esta
// función, no al tema que `articulo()` resuelva en cada uso (mismo
// problema de fondo que encontramos con el sombreado de palette/fonts en
// social.typ).
#let _tema-activo = state("articulo-tema", theme.base)

#let articulo(
  titulo: none,
  categoria: none,
  autor: none,
  fecha: none,
  paleta: none,
  tipografia: none,
  paper: "a5",
  doc,
) = {
  let t = make-theme(paleta: paleta, tipografia: tipografia)
  _tema-activo.update(t)

  set page(paper: paper, margin: 2.2cm, fill: fondo-editorial(t), numbering: "1", number-align: center)
  set text(font: t.fonts.body, fill: t.colors.dark, size: 11pt, lang: "es")
  set par(justify: true, leading: 0.8em, first-line-indent: 1em, spacing: 1.1em)

  show heading.where(level: 1): it => block(above: 1.8em, below: 1em)[
    #set text(font: t.fonts.display, weight: 800, size: 17pt, fill: t.colors.primary)
    #set par(first-line-indent: 0pt)
    #it.body
  ]
  show heading.where(level: 2): it => block(above: 1.4em, below: 0.7em)[
    #set text(font: t.fonts.display, weight: 700, size: 13pt, fill: t.colors.primary)
    #set par(first-line-indent: 0pt)
    #it.body
  ]
  show link: it => text(fill: t.colors.secondary, it)

  if titulo != none {
    align(center)[
      #if categoria != none [
        #box(fill: t.colors.primary.transparentize(85%), inset: (x: 8pt, y: 3pt), radius: 8pt)[
          #text(font: t.fonts.body, size: 7.5pt, weight: 700, tracking: 0.12em, fill: t.colors.primary, upper(categoria))
        ]
        #v(0.6em)
      ]
      #text(font: t.fonts.display, weight: 900, size: 22pt, fill: t.colors.primary, titulo)
      #if autor != none or fecha != none [
        #v(0.5em)
        #text(font: t.fonts.body, size: 8.5pt, fill: t.colors.dark.transparentize(35%))[
          #if autor != none [#autor]
          #if autor != none and fecha != none [ · ]
          #if fecha != none [#fecha]
        ]
      ]
    ]
    v(1.6em)
  }

  doc
}

// Primer párrafo con letra capital automática (capitular, de Dropcaps/),
// en la fuente display y el color primario del tema activo — el que se le
// pasó a `articulo()` más arriba en el documento. `..args` reenvía
// cualquier parámetro extra de capitular() (alto, hueco, sangria, etc.).
#let primer-parrafo(body, alto: 3, ..args) = context {
  let t = _tema-activo.get()
  (capitular)(body, font: t.fonts.display, fill: t.colors.primary, alto: alto, ..args)
}
