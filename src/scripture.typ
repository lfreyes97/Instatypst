// scripture.typ — bloque de texto bíblico con número de capítulo grande y
// versículos en superíndice. Puerto del snippet original, con las 3 fuentes
// que no existían en el proyecto sustituidas por font-tokens.typ:
//   "TeX Gyre Heros"        -> family("inter")        (sans neutro, cuerpo general)
//   "Atkinson Hyperlegible" -> family("public-sans")   (sans de alta legibilidad — mismo propósito)
//   "TeX Gyre Pagella"      -> family("eb-garamond")   (serif oldstyle, para el número de versículo)
// También corregido: los versículos ahora sí pasan por #vs[..] (en el
// snippet original solo el 1 usaba ch[], los versículos 2-6 quedaban como
// texto plano sin el superíndice).

#import "font-tokens.typ": family
#import "articulo.typ": make-theme, fondo-editorial
#import "dropcaps.typ": capitular

// ── Tema de las piezas ────────────────────────────────────────
// `scripture`, `vs` y `ch` tienen dos aspectos:
//   · neutro (por defecto): Public Sans, EB Garamond para el versículo y un
//     fondo gris tenue — el de siempre;
//   · con tema: la tipografía y los colores de un `theme` (theme.typ).
// El tema sale de, por orden: el `theme:` que se pase a la pieza, el del
// `pasaje` o `scripture` que la contiene, o ninguno (aspecto neutro).
//
// El tema del contenedor viaja en un `state`, no en una variable: `#vs[2]`
// se escribe dentro del cuerpo, fuera del scope léxico de `pasaje()`, así
// que un #let no llegaría (mismo problema que `_tema-activo` en articulo.typ).
// El contenedor lo fija para su cuerpo y lo restituye al terminar.
#let _tema-pasaje = state("scripture-tema", none)
#let _tema(theme) = if theme != auto { theme } else { _tema-pasaje.get() }

// Cuerpo de un contenedor con su tema publicado para las piezas de dentro.
#let _con-tema(t, prev, cuerpo) = if t == none { cuerpo } else {
  [#_tema-pasaje.update(t)#cuerpo#_tema-pasaje.update(prev)]
}

#let scripture(body, theme: auto) = context {
  let t = _tema(theme)
  let prev = _tema-pasaje.get()
  let (fuente, relleno) = if t == none {
    (family("public-sans"), luma(248))
  } else {
    (t.fonts.body, fondo-editorial(t))
  }
  set text(font: fuente)
  set par(leading: 1em, hanging-indent: 1em)
  block(
    fill: relleno,
    inset: 8pt,
    radius: 8pt,
    pad(x: 2em, y: 2em)[#_con-tema(if theme == auto { none } else { t }, prev, body)],
  )
}

// Número de versículo en superíndice. Con tema, en la tipografía del cuerpo.
#let vs(body, theme: auto) = context {
  let t = _tema(theme)
  set text(font: if t == none { family("eb-garamond") } else { t.fonts.body })
  super(typographic: true, baseline: -0.4em, size: 8pt)[*#body*]
}

// Número de capítulo grande. Con tema, en la tipografía de títulos.
#let ch(body, theme: auto) = context {
  let t = _tema(theme)
  set text(font: if t == none { family("public-sans") } else { t.fonts.display }, size: 26pt, weight: "bold")
  box(inset: (x: 3pt, y: -50%))[#body]
}

// ─────────────────────────────────────────────────────────────
//  PASAJE — junta las tres piezas del proyecto para una cita bíblica:
//    color      -> palettes.typ        (vía make-theme, de articulo.typ)
//    tipografía -> font-pairings.typ   (idem)
//    letra capital -> Dropcaps/dropcaps.typ (capitular, para el versículo 1)
//
//  El versículo 1 arranca con letra capital en vez de número — el número
//  sobra ahí porque la capital ya marca visualmente el inicio del pasaje
//  (igual que en una Biblia iluminada). Los versículos 2+ siguen llevando
//  su número en superíndice vía #vs[..], igual que antes.
//
//  Uso:
//    #import "scripture.typ": pasaje, vs
//    #pasaje("Salmo 1", version: "RVR1960", paleta: "granates", tipografia: "revival-vintage")[
//      Bienaventurado el varón que no anduvo... #vs[2] Sino que en la ley...
//    ]
//  ─────────────────────────────────────────────────────────────
#let pasaje(
  referencia,
  version: none,
  paleta: none,
  tipografia: none,
  capitular-alto: 2,
  theme: none,
  doc,
) = context {
  let t = if theme != none { theme } else { make-theme(paleta: paleta, tipografia: tipografia) }
  let prev = _tema-pasaje.get()
  block(
    fill: fondo-editorial(t),
    stroke: (left: 3pt + t.colors.primary),
    inset: (x: 24pt, y: 20pt),
    radius: 4pt,
    width: 100%,
  )[
    #text(font: t.fonts.display, weight: 700, size: 13pt, fill: t.colors.primary, referencia)
    #if version != none [#text(font: t.fonts.body, size: 9pt, fill: t.colors.dark.transparentize(40%))[ (#version)]]
    #v(10pt)
    #set text(font: t.fonts.body, fill: t.colors.dark, size: 11pt)
    #set par(justify: true, leading: 0.85em, hanging-indent: 1em)
    #_tema-pasaje.update(t)
    #(capitular)(doc, font: t.fonts.display, fill: t.colors.primary, alto: capitular-alto)
    #_tema-pasaje.update(prev)
  ]
}
