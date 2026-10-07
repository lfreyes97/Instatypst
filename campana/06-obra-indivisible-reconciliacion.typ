// Campaña Warfield — cita 06 · ACTO II «La obra de la gracia»
// Fuente: La expiación
// Tono: papel-noche · Tipografía: editorial-clasico · Formato: instagram (1080×1080)
// Plantilla: blockquote-editorial — cita de doctrina: el marco la presenta como artículo de fe.
// Nota: el `#v(-0.6em)` al inicio del cuerpo compensa el hueco que deja la comilla
// de blockquote-editorial (vive en lo alto de una caja de línea de 60pt*k); en `em`
// para que escale sola con el `size:` de cada tarjeta.
// Compilar: typst compile --root . --font-path Fonts campana/06-obra-indivisible-reconciliacion.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-noche", "editorial-clasico")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-editorial(
      [#v(-0.6em)Por esta #highlight(fill: marca)[única e indivisible obra], tanto Dios es reconciliado con nosotros, como nosotros somos reconciliados con Dios.],
      size: 72pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "La expiación", size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
