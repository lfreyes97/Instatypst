#import "../src/lib.typ": *

#set page(width: 830pt, height: auto, margin: 18pt, fill: rgb("#fafafa"))
#set text(font: "Inter", size: 9pt)

= Biblioteca de parejas tipográficas

#(pairings.catalog)(columns: 3)

#pagebreak()

== Uso con el sistema de diseño

#let expresivo = (pairings.as-theme)("editorial-expresivo")

#announce-post(
  "TIPOGRAFÍA",
  [Una pareja completa en un post real],
  [Fraunces de display, Bricolage Grotesque de cuerpo — resueltas desde font-tokens.typ, con sus nombres reales verificados.],
  "@mi_marca",
  theme: expresivo,
)
