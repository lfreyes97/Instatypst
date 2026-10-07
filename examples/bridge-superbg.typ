// Puente superbg × Instatypst (vive en Instatypst/examples, usa paquete local).
// Compilar: typst compile --root . --font-path Fonts examples/bridge-superbg.typ
#import "@local/superbg:0.1.0": superbg, bg-patron
#import "../src/lib.typ": canvas, sizes, page-pad, headline, subhead, footer, theme

#let marca = (theme.define)("marca-puente", colors: (primary: rgb("#0ea5e9"), secondary: rgb("#8b5cf6")))

#canvas(sizes.instagram, theme: marca, [
  #superbg("neon-aura", theme: marca, size: sizes.instagram)
  #pad(page-pad)[
    #headline([Puente superbg × Instatypst], color: white, theme: marca)
    #v(20pt)
    #subhead([Preset "neon-aura" con theme.define real.], color: white.transparentize(20%), theme: marca)
    #footer("@mi_marca", theme: marca)
  ]
])

#canvas(sizes.instagram, theme: marca, [
  #superbg((capas: (
    (tipo: "gradiente", from: marca.colors.primary, to: marca.colors.secondary),
    (tipo: "patron", patron: "dots", color: white, opacidad: 14%),
    (tipo: "vignette", intensidad: 30%),
  )), size: sizes.instagram)
  #pad(page-pad)[
    #headline([N3 dentro de canvas()], color: white, theme: marca)
    #v(20pt)
    #subhead([Capas dict sobre theme.define.], color: white.transparentize(20%), theme: marca)
    #footer("@mi_marca", theme: marca)
  ]
])

#canvas(sizes.instagram, theme: marca, [
  #superbg(bg-patron(patron: "grid", color: marca.colors.primary, fondo: white, opacidad: 12%, size: sizes.instagram))
  #pad(page-pad)[
    #headline([N2 + componentes], theme: marca)
    #v(20pt)
    #subhead([bg-patron() directo, sin dict.], theme: marca)
    #footer("@mi_marca", color: gray.darken(40%), theme: marca)
  ]
])
