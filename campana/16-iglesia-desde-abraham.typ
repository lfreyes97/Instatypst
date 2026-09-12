// Campaña Warfield — cita 16
// Fuente: La polémica del pedobautismo
// Plantilla: cita-canvas + blockquote-timeline — paleta "otono" + tipografía "revival-vintage"
// Compilar: typst compile --root . --font-path Fonts campana/16-iglesia-desde-abraham.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "otono", tipografia: "revival-vintage")

#let contenido = blockquote-timeline(
  "GÉNESIS 17",
  [
    Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos. Deben permanecer allí hasta que Él los saque. Él en ninguna parte los ha sacado.
    #v(16pt)
    #text(size: 14pt, fill: gray.darken(10%), style: "italic")[— B.B. Warfield, La polémica del pedobautismo]
  ],
  color: tema.colors.primary,
  theme: tema,
)

#cita-canvas(
  contenido,
  "presuposicionalismo.com",
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
  theme: tema,
)
