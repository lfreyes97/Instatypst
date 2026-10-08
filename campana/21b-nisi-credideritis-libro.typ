// Lámina 21 v2 · Nisi credideritis non intelligetis · twitter 1600×900
// Concepto: un libro abierto. El verso es el pasado («hemos estado aquí por
// milenios»), el recto el futuro («y estaremos aquí por milenios de
// milenios»). Los une el reclamo: la sílaba que la imprenta antigua ponía al
// pie de una página para anunciar la siguiente. Mientras haya reclamo, el
// libro sigue. Titulillos: «crede, ut intelligas» (Agustín, Sermón 43).
// Letra: EB Garamond 12 con dlig + hlig; la fuente no trae `hist`, la ſ va a
// mano (inicial y medial, s final redonda).
// Compilar: typst compile --root . --font-path Fonts campana/21b-nisi-credideritis-libro.typ campana/21b-nisi-credideritis-libro.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.twitter
#let mesa = rgb("#1f1b17")
#let papel = rgb("#f2ead8")
#let tinta = rgb("#231d18")
#let rubrica = rgb("#a3241b")
#let suave = rgb("#6e6155")
#let claro = rgb("#cdbfa6")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: mesa)
#set text(
  font: "EB Garamond 12", fill: tinta, lang: "es", hyphenate: false,
  features: ("dlig", "hlig", "hist"), number-type: "old-style",
)
#set par(leading: 0.32em, spacing: 0pt)

// ── El libro
#let lomo = ancho * 1pt / 2
#let arriba = 46pt
#let alto-pag = 760pt
#let ancho-pag = 724pt

// Canto de las hojas: filetes escalonados bajo cada página (el grosor del
// libro: muchas páginas atrás, muchas por delante).
#for i in range(7, 0, step: -1) {
  let d = i * 2.2pt
  let c = if calc.odd(i) { papel.darken(14% + i * 2%) } else { papel.darken(6% + i * 2%) }
  place(dx: lomo - ancho-pag - d, dy: arriba, rect(width: ancho-pag + d, height: alto-pag + d * 0.9, fill: c))
  place(dx: lomo, dy: arriba, rect(width: ancho-pag + d, height: alto-pag + d * 0.9, fill: c))
}

// Las dos páginas, con la sombra del lomo
#place(dx: lomo - ancho-pag, dy: arriba, rect(width: ancho-pag, height: alto-pag,
  fill: gradient.linear((papel, 0%), (papel, 82%), (papel.darken(16%), 100%))))
#place(dx: lomo, dy: arriba, rect(width: ancho-pag, height: alto-pag,
  fill: gradient.linear((papel.darken(16%), 0%), (papel, 18%), (papel, 100%))))

// ── Mancha de texto de cada página
#let margen-int = 74pt
#let margen-ext = 92pt
#let caja-w = ancho-pag - margen-int - margen-ext
#let titulillo-y = arriba + 58pt
#let texto-y = arriba + 150pt
#let pie-y = arriba + alto-pag - 92pt

#let titulillo(cuerpo, folio, lado) = {
  let t = text(size: 25pt, fill: suave, tracking: 0.14em, features: ("smcp",), cuerpo)
  let f = text(size: 27pt, fill: suave, folio)
  block(width: caja-w, grid(
    columns: (auto, 1fr, auto),
    ..if lado == "verso" { (f, align(center, t), []) } else { ([], align(center, t), f) },
  ))
  v(12pt)
  line(length: caja-w, stroke: 1pt + suave.transparentize(40%))
}

// Verso — el pasado
#let x-verso = lomo - ancho-pag + margen-ext
#place(dx: x-verso, dy: titulillo-y, titulillo([crede,], [2], "verso"))
#place(dx: x-verso, dy: texto-y, block(width: caja-w)[
  #text(size: 80pt)[Los criſtianos \ hemos eſtado \ aquí por #text(style: "italic")[milenios]]
  #v(52pt)
  #text(size: 50pt, fill: rubrica, style: "italic")[«niſi credideritis \ non intelligetis»]
])
// Reclamo: al pie, a la derecha, la sílaba que abre la página siguiente
#place(dx: x-verso, dy: pie-y, block(width: caja-w,
  align(right, text(size: 36pt)[y eſta-])))
// Apostilla en el margen exterior: de dónde viene el latín
#place(dx: lomo - ancho-pag + 18pt, dy: texto-y + 290pt, block(width: 60pt,
  align(right, text(size: 22pt, fill: rubrica, style: "italic", features: (hlig: 0))[Is. \ 7, 9])))

// Recto — el futuro
#let x-recto = lomo + margen-int
#place(dx: x-recto, dy: titulillo-y, titulillo([ut intelligas.], [3], "recto"))
#place(dx: x-recto, dy: texto-y, block(width: caja-w)[
  #text(size: 80pt)[y eſtaremos aquí \ por milenios]
  #v(30pt)
  #text(size: 104pt, style: "italic")[de milenios,]
  #v(40pt)
  #text(size: 50pt, fill: rubrica, style: "italic")[«ſi no creéis, \ no comprenderéis»]
])
// Signatura de pliego, al pie del recto
#place(dx: x-recto, dy: pie-y, block(width: caja-w,
  align(center, text(size: 30pt, fill: suave)[A ij])))

// ── Sobre la mesa: fuente y marca
#place(bottom + left, dx: 70pt, dy: -26pt,
  text(size: 22pt, fill: claro, features: (hlig: 0, dlig: 0))[Isaías 7, 9 según la Vetus Latina, como lo citaba san Agustín])
#place(bottom + right, dx: -70pt, dy: -22pt, logo(claro, (ancho, alto)))
