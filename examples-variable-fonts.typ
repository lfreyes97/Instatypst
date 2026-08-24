// Demuestra el parámetro `variations:` (sección 3 de social.typ) con un
// tema de marca que usa dos fuentes variables reales del proyecto:
// Fraunces (display) y Bricolage Grotesque (body). El tema se pasa
// explícito con `theme:` a cada llamada — ver la nota al inicio de
// social.typ sobre por qué "sombrear" `palette`/`fonts` no sirve para esto.
//
// IMPORTANTE: el archivo variable de Bricolage Grotesque no se registra
// bajo "Bricolage Grotesque" — ese nombre solo resuelve a los cortes
// estáticos y `variations:` no tendría ningún efecto en ellos (Typst lo
// ignora en silencio, sin warning). El archivo variable de verdad vive bajo
// el nombre "Bricolage Grotesque 96pt" (así quedó su tabla interna de
// nombres al exportarse desde Google Fonts). Verificado compilando ambos.
//
// Compilar con: typst compile --font-path Fonts examples-variable-fonts.typ

#import "theme.typ": theme
#import "social.typ": *

#let editorial-variable = (theme.define)("editorial-variable", fonts: (
  display: "Fraunces", // wght 100-900 · opsz 9pt-144pt · SOFT 0-100 · WONK 0-1
  body: "Bricolage Grotesque 96pt", // wght 200-800 · wdth 75%-100% · opsz 12pt-96pt
))

#canvas(sizes.instagram, theme: editorial-variable, [
  #bg(editorial-variable.colors.white)
  #pad(page-pad)[
    #badge(
      "EDICIÓN LIMITADA",
      color: editorial-variable.colors.secondary,
      variations: (wdth: 75, wght: 700), // Bricolage: condensada y gruesa
      theme: editorial-variable,
    )
    #v(40pt)
    #headline(
      [Tipografía con carácter],
      variations: (wght: 900, opsz: 144, WONK: 1), // Fraunces: expresiva y grande
      theme: editorial-variable,
    )
    #v(20pt)
    #subhead(
      [El mismo peso de letra, ajustado por eje en vez de por archivo estático.],
      variations: (wdth: 100, wght: 300), // Bricolage: ancha y ligera
      theme: editorial-variable,
    )
  ]
])

#pagebreak()

// Mismo texto, mismo tamaño de punto — solo cambia el eje óptico (opsz) y
// los ejes propios de Fraunces (SOFT/WONK). El tamaño de fuente NO cambia.
#canvas(sizes.instagram, theme: editorial-variable, [
  #bg(editorial-variable.colors.light)
  #pad(page-pad)[
    #headline([Óptico chico, sobrio], size: 52pt, variations: (opsz: 9, SOFT: 100, WONK: 0), theme: editorial-variable)
    #v(50pt)
    #headline([Óptico grande, expresivo], size: 52pt, variations: (opsz: 144, SOFT: 0, WONK: 1), theme: editorial-variable)
  ]
])
