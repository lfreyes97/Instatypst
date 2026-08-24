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

#let scripture(body) = {
  set text(font: family("public-sans"))
  set par(leading: 1em, hanging-indent: 1em)
  block(
    fill: luma(248),
    inset: 8pt,
    radius: 8pt,
    pad(x: 2em, y: 2em)[#body],
  )
}

#let vs(body) = {
  set text(font: family("eb-garamond"))
  super(typographic: true, baseline: -0.4em, size: 8pt)[*#body*]
}

#let ch(body) = {
  set text(font: family("public-sans"), size: 26pt, weight: "bold")
  box(inset: (x: 3pt, y: -50%))[#body]
}

#let set-body-font(doc) = {
  set text(font: family("inter"))
  doc
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
  doc,
) = {
  let t = make-theme(paleta: paleta, tipografia: tipografia)
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
    #(capitular)(doc, font: t.fonts.display, fill: t.colors.primary, alto: capitular-alto)
  ]
}
