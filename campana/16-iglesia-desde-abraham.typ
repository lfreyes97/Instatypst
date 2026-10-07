// Campaña Warfield — cita 16 · ACTO IV «Polémica y mundo»
// Fuente: La polémica del pedobautismo
// Tono: papel-grafito · Tipografía: geometrico-moderno · Formato: story (1080×1920)
// Plantilla: blockquote-callout — el único argumento de la campaña que se apoya en un texto
// concreto, así que lleva su referencia como título del bloque en vez de perderla en el pie.
// (Reemplaza a blockquote-timeline, que traía una regla vertical de alto fijo —44pt— y por
// eso no escala: a tamaño de lienzo quedaba como una astilla junto al cuerpo.)
// Compilar: typst compile --root . --font-path Fonts campana/16-iglesia-desde-abraham.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma, lienzo, realce

#let tema = tema-campana("papel-grafito", "geometrico-moderno")
#let marca = realce(tema)

#lienzo(
  [
    #blockquote-callout(
      [Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos. Deben permanecer allí hasta que Él los saque. #highlight(fill: marca)[Él en ninguna parte los ha sacado.]],
      titulo: "Génesis 17",
      icono: "✦",
      variante: "info",
      size: 76pt,
      color: tema.colors.primary,
      theme: tema,
    )
    #firma(tema, fuente: "La polémica del pedobautismo", size: 28pt)
  ],
  tema,
  size: sizes.story,
)
