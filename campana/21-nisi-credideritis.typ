// Lámina 21 · Nisi credideritis non intelligetis · story 1080×1920
// Concepto: un reloj de arena hecho solo de texto, como los colofones en
// «cul-de-lampe» de la imprenta antigua. Arriba, el pasado («hemos estado aquí
// por milenios») se estrecha hasta la cintura; por la cintura pasa la fe
// (el latín, en rojo); abajo se abre el futuro, que es más ancho que el
// pasado: «milenios de milenios». La base es la traducción.
// Letra: EB Garamond 12 con dlig + hlig. La fuente no trae `hist`: la ſ se
// escribe a mano (inicial y medial; la s final queda redonda) y hlig la liga.
// Compilar: typst compile --root . --font-path Fonts campana/21-nisi-credideritis.typ campana/21-nisi-credideritis.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.story
#let papel = rgb("#f3ecdd")
#let tinta = rgb("#231d18")
#let rubrica = rgb("#a3241b")
#let suave = rgb("#6e6155")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: papel)
#set text(
  font: "EB Garamond 12", fill: tinta, lang: "es", hyphenate: false,
  features: ("dlig", "hlig", "hist"), number-type: "old-style",
)
#set par(leading: 0.3em, spacing: 0pt)

// Grano leve de papel
#place(superbg.bg-patron(patron: "dots", color: tinta, paso: 18, opacidad: 4%, size: formatos.story))

// ── Geometría del reloj: dos conos que se tocan en la cintura
#let cx = ancho * 1pt / 2
#let tapa-sup = 176pt
#let cintura = 884pt
#let tapa-inf = 1592pt
#let ancho-tapa = 900pt
#let ancho-cuello = 360pt
// Ancho interior del vidrio a la altura y
#let vidrio(y) = {
  let d = calc.abs((y - cintura) / (tapa-inf - cintura))
  ancho-cuello + (ancho-tapa - ancho-cuello) * d
}

// El vidrio
#let lado(x0, x1) = {
  place(curve(stroke: 2pt + rubrica.transparentize(35%),
    curve.move((x0, tapa-sup)), curve.line((x1, cintura)), curve.line((x0, tapa-inf))))
}
#lado(cx - ancho-tapa / 2 - 24pt, cx - ancho-cuello / 2 - 24pt)
#lado(cx + ancho-tapa / 2 + 24pt, cx + ancho-cuello / 2 + 24pt)

// Las tapas de madera: filete grueso + fino
#let tapa(y, abajo: false) = {
  let w = ancho-tapa + 120pt
  let (g, f) = if abajo { (y, y - 14pt) } else { (y - 10pt, y + 6pt) }
  place(dx: cx - w / 2, dy: g, rect(width: w, height: 10pt, fill: tinta))
  place(dx: cx - w / 2 + 20pt, dy: f, rect(width: w - 40pt, height: 2.5pt, fill: tinta))
}
#tapa(tapa-sup)
#tapa(tapa-inf, abajo: true)

// Un renglón que llena el vidrio a su altura: el tamaño sale del ancho.
// `y` es el centro del ojo medio (la x) del renglón.
#let renglon(y, cuerpo, fill: tinta, style: "normal", holgura: 0.9, w: auto) = context {
  let muestra = text(size: 100pt, style: style, cuerpo)
  let w = if w == auto { vidrio(y) * holgura } else { w }
  let s = 100pt * (w / measure(muestra).width)
  let caja = box(text(size: s, fill: fill, style: style,
    top-edge: "x-height", bottom-edge: "baseline", cuerpo))
  let m = measure(caja)
  place(dx: cx - m.width / 2, dy: y - m.height / 2, caja)
}

// ── El pasado: se estrecha hacia la cintura
#renglon(296pt)[Los criſtianos hemos]
#renglon(468pt)[eſtado aquí por]
#renglon(660pt, style: "italic")[milenios]

// ── La cintura: por aquí pasa la fe
#renglon(838pt, fill: rubrica, style: "italic", holgura: 0.9)[«niſi credideritis]
#renglon(930pt, fill: rubrica, style: "italic", holgura: 0.9)[non intelligetis»]

// ── El futuro: se abre
#renglon(1100pt)[y eſtaremos aquí]
#renglon(1270pt)[por milenios]
#renglon(1470pt, style: "italic")[de milenios,]

// ── La base: la traducción, bajo el reloj
#renglon(1690pt, fill: rubrica, style: "italic", w: 880pt)[«ſi no creéis, no comprenderéis»]

// ── Pie: fuente del latín + marca
#place(bottom + center, dy: -64pt, block(width: 900pt)[
  #set text(size: 26pt, fill: suave, features: (hlig: 0, dlig: 0))
  #grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    [#text(features: ("smcp",), tracking: 0.06em)[isaías 7, 9] · Vetus Latina, \ como lo citaba san Agustín],
    logo(tinta, (ancho, alto)),
  )
])
