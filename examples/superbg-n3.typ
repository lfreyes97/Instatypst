#import "../src/lib.typ": *

#let marca = (theme.define)("marca-superbg", colors: (primary: rgb("#0ea5e9"), secondary: rgb("#8b5cf6"), accent: rgb("#f59e0b"), dark: rgb("#111827")))

#canvas(sizes.instagram, theme: marca)[
  #superbg.superbg((capas: (
    (tipo: "gradiente", from: marca.colors.dark, to: marca.colors.primary),
    (tipo: "aura", colores: (marca.colors.secondary, marca.colors.accent)),
    (tipo: "patron", patron: "dots", color: white, paso: 44, opacidad: 12%),
    (tipo: "vignette", intensidad: 28%),
  )), size: sizes.instagram, theme: marca)
  #pad(page-pad)[
    #headline([Fondo de marca], color: white, theme: marca)
    #v(20pt)
    #subhead([Instatypst × superbg · motor de capas], color: white.transparentize(15%), theme: marca)
  ]
  #place(bottom + right, dx: -page-pad, dy: -page-pad)[
    #footer("@instatypst", theme: marca)
  ]
]
