// Lámina 15 · «El amor del Espíritu Santo» · cuadrado 1080×1080
// Concepto: la frase más exclamativa de la campaña, puesta a gritar. Malla
// de color cálida (rosas, coral, damasco) como un rubor; Fraunces Soft
// itálica negra, con «anhelante» y «celoso» enormes y ladeados, y un par
// de ¡ ! gigantes en blanco que abrazan todo el cuadro.
// Compilar: typst compile --root . --font-path Fonts campana/15-amor-anhelante-del-espiritu.typ campana/15-amor-anhelante-del-espiritu.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.instagram
#let vino = rgb("#3d0a22")
#let blanco = rgb("#fff6f0")
#let rubor = rgb("#7d0b30")
#let blanda = "Fraunces 72pt Soft"
#let fraunces = "Fraunces 72pt"

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: rgb("#ffd9c6"))
#set text(font: blanda, style: "italic", weight: 900, fill: vino, lang: "es",
  top-edge: "cap-height", bottom-edge: "baseline")
#set par(spacing: 0pt, leading: 0pt)

// ── Rubor: malla de color cálida ──
#superbg.bg-malla(
  (rgb("#ff9a6b"), rgb("#ff6f91"), rgb("#ffc977"), rgb("#ffb0c0"), rgb("#ff7d5c")),
  puntos: ((120, 160), (980, 220), (860, 900), (300, 980), (560, 520)),
  radios: (360, 380, 380, 340, 300),
  fondo: rgb("#ffd3c1"),
  size: formatos.instagram,
)
// Velo claro al centro, para que el vino lea con holgura sobre la malla.
#place(rect(width: 100%, height: 100%, fill: gradient.radial(
  (rgb("#fff1ea").transparentize(30%), 0%), (rgb("#fff1ea").transparentize(100%), 70%), (rgb("#fff1ea").transparentize(100%), 100%),
  center: (42%, 50%), radius: 70%,
)))
#superbg.bg-patron(patron: "ruido", opacidad: 9%, size: formatos.instagram)

// ── ¡ ! gigantes que abrazan el cuadro ──
#place(top + left, dx: -36pt, dy: 40pt, text(size: 1080pt, weight: 900, fill: blanco.transparentize(45%), top-edge: "ascender", bottom-edge: "descender")[¡])
#place(top + left, dx: 836pt, dy: -120pt, text(size: 1080pt, weight: 900, fill: blanco.transparentize(45%), top-edge: "ascender", bottom-edge: "descender")[!])

// ── El grito ──
#let menor(t) = text(font: fraunces, weight: 600, size: 58pt, t)

#place(top + left, dx: 92pt, dy: 92pt, block(width: 900pt, {
  text(size: 112pt)[¡El amor]
  v(28pt)
  text(size: 112pt)[del Espíritu!]
  v(64pt)
  menor[¡El amor]
  v(-6pt)
  pad(left: 34pt, rotate(-6deg, reflow: true, text(size: 150pt, fill: rubor)[anhelante,]))
  v(10pt)
  pad(left: 250pt, rotate(4deg, reflow: true, text(size: 150pt, fill: rubor)[celoso,]))
  v(18pt)
  menor[del Espíritu Santo]
  v(20pt)
  menor[por nuestras almas!]
}))

// ── Firma ──
#place(bottom + left, dx: 92pt, dy: -64pt, block(width: 896pt, grid(
  columns: (1fr, auto),
  align: (left + horizon, right + horizon),
  text(font: fraunces, style: "normal", weight: 600, size: 26pt)[B. B. Warfield #text(weight: 400)[· El amor del Espíritu Santo]],
  logo(vino, (ancho, alto)),
)))
