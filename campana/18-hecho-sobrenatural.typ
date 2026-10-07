// Campaña Warfield — cita 18 · ACTO IV «Polémica y mundo»
// Fuente: El sobrenaturalismo cristiano
// Tono: papel-grafito · Tipografía: geometrico-moderno · Formato: instagram (1080×1080)
// Plantilla: blockquote-editorial — la cita construye una escalera (de la naturaleza / en la
// naturaleza / sobre la naturaleza) y el marco le da el peso de conclusión que esa escalera pide.
// Nota: el `#v(-0.6em)` al inicio del cuerpo compensa el hueco que deja la comilla
// de blockquote-editorial (vive en lo alto de una caja de línea de 60pt*k); en `em`
// para que escale sola con el `size:` de cada tarjeta.
// Compilar: typst compile --root . --font-path Fonts campana/18-hecho-sobrenatural.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-grafito", "geometrico-moderno")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-editorial(
      [#v(-0.6em)El Dios del cristiano es, sin duda, el Dios de la naturaleza y el Dios en la naturaleza: pero antes y sobre todo esto, es el Dios sobre la naturaleza —el #text(weight: 700)[#highlight(fill: marca)[Hecho Sobrenatural]].],
      size: 56pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "El sobrenaturalismo cristiano", size: 24pt)
  ],
  tema,
  size: sizes.instagram,
)
