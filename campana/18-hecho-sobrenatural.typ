// Campaña Warfield — cita 18
// Fuente: El sobrenaturalismo cristiano
// Plantilla: cita-canvas + blockquote-editorial — paleta "granates" + tipografía "lectura-editorial"
// Compilar: typst compile --root . --font-path Fonts campana/18-hecho-sobrenatural.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "granates", tipografia: "lectura-editorial")
#let cita = blockquote-editorial.with(theme: tema, color: tema.colors.primary)
#let marca-h = tema.colors.accent.transparentize(65%)

// "Hecho Sobrenatural" es el remate de toda la frase (ya viene capitalizado
// en el ensayo) — el #text(weight: 800) on-the-fly, encima del highlight,
// le da el peso de remate que el resto del cuerpo (itálica regular) no tiene.
#warfield-canvas(
  cita(
    [El Dios del cristiano es, sin duda, el Dios de la naturaleza y el Dios en la naturaleza: pero antes y sobre todo esto, es el Dios sobre la naturaleza —el #highlight(fill: marca-h)[#text(weight: 800)[Hecho Sobrenatural]].],
    autor: "B.B. Warfield",
    fuente: "El sobrenaturalismo cristiano",
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.dark,
  blob-color: white,
  footer-color: white,
)
