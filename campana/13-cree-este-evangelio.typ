// Campaña Warfield — cita 13 · ACTO III «El Espíritu»
// Fuente: La persona y la obra del Espíritu Santo (El Espíritu de fe)
// Tono: tinta-salvia (ancla oscura del acto) · Tipografía: revival-vintage · Formato: story (1080×1920)
// Plantilla: blockquote-pull — la cita más larga y más dramática de la campaña; el vertical
// de historia deja que el imperativo repetido caiga en cascada.
// Nota: IM FELL English no es variable (igual que Bebas en la 09), así que el `weight: 800`
// interno de blockquote-pull no cambia nada; el énfasis lo lleva el resaltado.
// Compilar: typst compile --root . --font-path Fonts campana/13-cree-este-evangelio.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("tinta-salvia", "revival-vintage")
#let marca = realce(tema, oscuro: true)

#lienzo(
  [
    #blockquote-pull(
      [#highlight(fill: marca)[Cree este Evangelio], y podrás y lo predicarás. Digan los hombres lo que quieran —déjalos herir, ridiculizar, perseguir, matar— #highlight(fill: marca)[cree este Evangelio] y lo predicarás.],
      size: 92pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #pad(x: 28pt)[#firma(tema, fuente: "El Espíritu de fe", size: 28pt)]
  ],
  tema,
  size: sizes.story,
)
