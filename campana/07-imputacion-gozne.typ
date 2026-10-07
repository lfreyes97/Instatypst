// Campaña Warfield — cita 07 · ACTO II «La obra de la gracia»
// Fuente: La imputación
// Tono: papel-noche · Tipografía: editorial-clasico · Formato: instagram (1080×1080)
// Plantilla: blockquote-card — la tarjeta con barra superior sostiene bien una cita de tres cláusulas.
// Nota tipográfica: «[La imputación]» es interpolación editorial, no palabra de Warfield;
// va en redonda (#text(style: "normal")) contra el resto del cuerpo en itálica.
// Compilar: typst compile --root . --font-path Fonts campana/07-imputacion-gozne.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("papel-noche", "editorial-clasico")

#lienzo(
  [
    #blockquote-card(
      [#text(style: "normal")[\[La imputación\]] es el gozne sobre el cual giran estas tres grandes doctrinas —la pecaminosidad de la raza, la satisfacción de Cristo, la justificación por la fe— y la guardiana de su pureza.],
      size: 64pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "La imputación", size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
