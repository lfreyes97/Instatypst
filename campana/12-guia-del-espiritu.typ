// Campaña Warfield — cita 12 · ACTO III «El Espíritu»
// Fuente: La persona y la obra del Espíritu Santo (La guía del Espíritu)
// Tono: papel-salvia · Tipografía: revival-vintage · Formato: instagram (1080×1080)
// Plantilla: blockquote-editorial — la cita es una corrección precisa; el marco la vuelve definición.
// Nota: el `#v(-0.6em)` al inicio del cuerpo compensa el hueco que deja la comilla
// de blockquote-editorial (vive en lo alto de una caja de línea de 60pt*k); en `em`
// para que escale sola con el `size:` de cada tarjeta.
// Compilar: typst compile --root . --font-path Fonts campana/12-guia-del-espiritu.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-salvia", "revival-vintage")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-editorial(
      [#v(-0.6em)La guía espiritual misma no es una guía de nosotros mismos por nosotros mismos, sino una guía de nosotros #highlight(fill: marca)[por el Espíritu Santo].],
      size: 68pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "La guía del Espíritu", size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
