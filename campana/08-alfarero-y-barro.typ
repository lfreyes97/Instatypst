// Campaña Warfield — cita 08 · ACTO II «La obra de la gracia»
// Fuente: La predestinación
// Tono: tinta-vino · Tipografía: editorial-clasico · Formato: instagram (1080×1080)
// ÚNICA EXCEPCIÓN CROMÁTICA de la campaña: la tarjeta pertenece al Acto II (familia
// noche) pero se imprime en la familia vino porque la imagen es barro cocido —
// el tono del horno manda sobre el tono del acto. También es el ancla oscura del acto.
// Plantilla: blockquote-hero — imagen bíblica breve, centrada.
// Compilar: typst compile --root . --font-path Fonts campana/08-alfarero-y-barro.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("tinta-vino", "editorial-clasico")

#lienzo(
  [
    #blockquote-hero(
      [Él era como el alfarero, e Israel como el barro que el alfarero moldea a su voluntad.],
      size: 92pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "La predestinación", alineacion: center, size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
