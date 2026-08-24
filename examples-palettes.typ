#import "palettes.typ": palettes
#import "theme.typ": theme

#set page(width: 830pt, height: auto, margin: 18pt, fill: rgb("#fafafa"))
#set text(font: theme.base.fonts.body, size: 9pt)

= Biblioteca de paletas

#(palettes.catalog)(columns: 3)

#pagebreak()

== Uso con el sistema de diseño

#let neon = (palettes.as-theme)("neon")
#let terracota = (palettes.as-theme)("terracota")

#let role-table(t) = table(
  columns: (auto, auto, auto),
  stroke: none,
  inset: (y: 3pt, x: 2pt),
  ..("primary", "secondary", "accent", "dark", "light").map(k => (
    text(size: 8pt)[#k],
    box(circle(radius: 7pt, fill: t.colors.at(k)), outset: (right: 6pt)),
    text(size: 6.5pt, fill: luma(40%), t.colors.at(k).to-hex()),
  )).flatten(),
)

#grid(columns: 2, gutter: 10pt,
  block(inset: 10pt, radius: 8pt, fill: neon.colors.light)[
    #set text(size: 8pt)
    *neon* — roles automáticos
    #v(4pt)
    #role-table(neon)
  ],
  block(inset: 10pt, radius: 8pt, fill: terracota.colors.light)[
    #set text(size: 8pt)
    *terracota* — roles automáticos
    #v(4pt)
    #role-table(terracota)
  ],
)
