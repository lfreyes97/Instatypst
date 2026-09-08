// Campaña Warfield — cita 16
// Fuente: La polémica del pedobautismo
// Plantilla: cita-canvas + blockquote-timeline — paleta "otono" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/16-iglesia-desde-abraham.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "otono", tipografia: "revival-vintage")
#let cita = blockquote-timeline.with(theme: tema, color: tema.colors.primary)

// blockquote-timeline no tiene autor:/fuente: (solo fecha + body) — la
// atribución vive dentro del body como un #text() aparte. Esto YA es el
// patrón on-the-fly (un estilo local, distinto del cuerpo, dentro del
// mismo bloque de contenido) — no hacía falta cambiar nada más que
// envolverlo con .with() como el resto de la campaña.
#warfield-canvas(
  cita(
    "GÉNESIS 17",
    [
      Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos. Deben permanecer allí hasta que Él los saque. Él en ninguna parte los ha sacado.
      #v(16pt)
      #text(size: 14pt, fill: gray.darken(10%), style: "italic")[— B.B. Warfield, La polémica del pedobautismo]
    ],
  ),
  tema,
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
