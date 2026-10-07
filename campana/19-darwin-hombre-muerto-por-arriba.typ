// Campaña Warfield — cita 19 · ACTO IV «Polémica y mundo» — PAR DARWIN/HODGE (1 de 2)
// Fuente: La vida religiosa de Charles Darwin
// Tono: papel-grafito · Tipografía: geometrico-moderno · Formato: story (1080×1920)
// Plantilla: blockquote-lateral — ÚNICA tarjeta que conserva la atribución propia de la
// plantilla (la barra vertical rotada): esa barra ES la plantilla, apagarla la dejaría en
// un párrafo justificado sin carácter. La `firma()` aparece igual, sin filete y solo con la
// nota, para que la aclaración editorial viaje con la imagen si circula suelta.
// Compilar: typst compile --root . --font-path Fonts campana/19-darwin-hombre-muerto-por-arriba.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-grafito", "geometrico-moderno")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-lateral(
      // `blockquote-lateral` justifica por dentro (`set par(justify: true)`); a este
      // tamaño de lienzo, con una columna angosta, eso parte palabras cada dos líneas
      // ("ra-mas", "des-cansar"). El `set` local gana por ser posterior.
      [#set par(justify: false)
       \[Darwin\] quedó como algún gran árbol del bosque de ramas extendidas, bajo el cual los hombres pueden descansar y refrescarse, pero ya marcado por la decadencia como suya propia. #text(weight: 700)[#highlight(fill: marca)[Era un hombre muerto por arriba].]],
      autor: "B.B. Warfield",
      fuente: "La vida religiosa de Charles Darwin",
      size: 72pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(
      tema,
      autor: none,
      filete: false,
      nota: [Juicio de Warfield sobre Darwin, en su ensayo sobre la vida religiosa del naturalista. 1 de 2 — ver el contraste con la muerte de Charles Hodge.],
      size: 26pt,
    )
  ],
  tema,
  size: sizes.story,
)
