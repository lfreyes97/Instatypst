// Campaña Warfield — cita 15 · ACTO III «El Espíritu»
// Fuente: La persona y la obra del Espíritu Santo (El amor del Espíritu Santo)
// Tono: papel-salvia · Tipografía: revival-vintage · Formato: instagram (1080×1080)
// Plantilla: blockquote-hand — única tarjeta manuscrita de la campaña (Caveat, que la
// plantilla fija y no depende de la pareja tipográfica). Es la frase más exclamativa y
// menos argumentativa de las 20: una nota al margen, no una tesis.
// Compilar: typst compile --root . --font-path Fonts campana/15-amor-anhelante-del-espiritu.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("papel-salvia", "revival-vintage")

#lienzo(
  [
    #blockquote-hand(
      [¡El amor del Espíritu! ¡El amor anhelante, celoso, del Espíritu Santo por nuestras almas!],
      size: 104pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "El amor del Espíritu Santo", alineacion: center, size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
