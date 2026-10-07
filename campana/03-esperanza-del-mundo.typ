// Campaña Warfield — cita 03 · ACTO I «¿Qué es el calvinismo?»
// Fuente: El calvinismo hoy
// Tono: papel-vino · Tipografía: lectura-editorial · Formato: instagram (1080×1080)
// Plantilla: blockquote-editorial — el doble filete enmarca la declaración como un aviso impreso.
// Nota: el `#v(-0.6em)` al inicio del cuerpo compensa el hueco que deja la comilla
// de blockquote-editorial (vive en lo alto de una caja de línea de 60pt*k); en `em`
// para que escale sola con el `size:` de cada tarjeta.
// Compilar: typst compile --root . --font-path Fonts campana/03-esperanza-del-mundo.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-vino", "lectura-editorial")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-editorial(
      [#v(-0.6em)El calvinismo emerge así a nuestra vista como nada más ni nada menos que la #highlight(fill: marca)[esperanza del mundo].],
      size: 64pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "El calvinismo hoy", size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
