// Campaña Warfield — cita 14 · ACTO III «El Espíritu»
// Fuente: La persona y la obra del Espíritu Santo (Fortalecimiento espiritual)
// Tono: papel-salvia · Tipografía: revival-vintage · Formato: twitter (1600×900)
// Plantilla: blockquote-hero — aforismo de dos frases; el horizontal lo vuelve cita citable.
// Compilar: typst compile --root . --font-path Fonts campana/14-amor-el-gran-ensanchador.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo

#let tema = tema-campana("papel-salvia", "revival-vintage")

#lienzo(
  [
    #blockquote-hero(
      [El amor es el gran ensanchador. Es el amor lo que estira el intelecto.],
      size: 104pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "Fortalecimiento espiritual", alineacion: center, size: 26pt)
  ],
  tema,
  size: sizes.twitter,
)
