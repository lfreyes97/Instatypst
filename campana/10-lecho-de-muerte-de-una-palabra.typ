// Campaña Warfield — cita 10 · ACTO II «La obra de la gracia»
// Fuente: "Redentor" y "redención"
// Tono: papel-noche · Tipografía: editorial-clasico · Formato: instagram (1080×1080)
// Plantilla: blockquote-poetry — filete lateral fino y sin justificar: la cita es un lamento,
// no un argumento; conviene que respire como verso.
// Compilar: typst compile --root . --font-path Fonts campana/10-lecho-de-muerte-de-una-palabra.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("papel-noche", "editorial-clasico")

#lienzo(
  [
    #blockquote-poetry(
      [Estamos asistiendo al lecho de muerte de una palabra. \
       Y es triste presenciar la muerte de cualquier cosa valiosa.],
      size: 80pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "«Redentor» y «redención»", size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
