// Campaña Warfield — cita 13
// Fuente: La persona y la obra del Espíritu Santo (El Espíritu de fe)
// Plantilla: cita-canvas + blockquote-hero — paleta "mediterraneo" + tipografía "editorial-expresivo"
// Compilar: typst compile --root . --font-path Fonts campana/13-cree-este-evangelio.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "mediterraneo", tipografia: "editorial-expresivo")
#let cita = blockquote-hero.with(theme: tema, color: tema.colors.primary)
#let marca-h = tema.colors.accent.transparentize(60%)

// Mismo tratamiento que la 09: el highlight ya marca la repetición
// ("cree este Evangelio") en color; el #text(weight: 900) on-the-fly la
// marca también en peso, para que la frase que se repite se sienta como
// remate, no solo como resaltado de fondo.
#warfield-canvas(
  cita(
    [Cree este Evangelio, y podrás y lo predicarás. Digan los hombres lo que quieran —déjalos herir, ridiculizar, perseguir, matar— #highlight(fill: marca-h)[#text(weight: 900)[cree este Evangelio]] y lo predicarás.],
    autor: "B.B. Warfield",
    fuente: "El Espíritu de fe",
  ),
  tema,
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
