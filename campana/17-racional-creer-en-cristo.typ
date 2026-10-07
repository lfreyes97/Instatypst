// Campaña Warfield — cita 17 · ACTO IV «Polémica y mundo»
// Fuente: Apologética
// Tono: tinta-grafito (ancla oscura del acto) · Tipografía: geometrico-moderno · Formato: twitter (1600×900)
// Plantilla: blockquote-bar variante "acento" — la cita es una antítesis exacta
// (racional / irracional); los dos resaltados son el contenido, no decoración.
// Compilar: typst compile --root . --font-path Fonts campana/17-racional-creer-en-cristo.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("tinta-grafito", "geometrico-moderno")
#let marca = realce(tema, oscuro: true)
#let clave(it) = text(weight: 700)[#highlight(fill: marca)[#it]]

#lienzo(
  [
    #blockquote-bar(
      [Creemos en Cristo porque es #clave[racional] creer en él, no aunque sea #clave[irracional].],
      variante: "acento",
      size: 104pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #pad(left: 32pt)[#firma(tema, fuente: "Apologética", size: 26pt)]
  ],
  tema,
  size: sizes.twitter,
)
