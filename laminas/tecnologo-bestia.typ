// Lámina — "El tecnólogo y la bestia"
// Ilustración: invertir el punto de Apocalipsis 13:18 imaginando que el
// problema que señala el texto es de CAPACIDAD DE CÓMPUTO, cuando en
// realidad el texto pide ENTENDIMIENTO (marco interpretativo/sabiduría).
// Compilar: typst compile --root . --font-path Fonts laminas/tecnologo-bestia.typ
#import "../src/lib.typ": *

#let tema = make-theme(paleta: "noche-azul", tipografia: "sans-versatil")

#let biblia = blockquote-bar(
  [El que tiene entendimiento, calcule el número de la bestia.],
  autor: "Apocalipsis 13:18",
  color: tema.colors.primary,
  size: 30pt,
  theme: tema,
)

#let respuesta = blockquote-bar(
  [¡Perfecto! Necesitamos una superinteligencia artificial que pueda calcularlo.],
  autor: "el tecnólogo",
  variante: "acento",
  color: tema.colors.accent,
  size: 30pt,
  theme: tema,
)

#let contenido = [
  #biblia
  #v(10pt)
  #align(center)[
    #text(font: tema.fonts.body, size: 19pt, weight: 700, tracking: 0.08em, fill: gray.darken(20%))[Y RESPONDIENDO:]
  ]
  #v(10pt)
  #respuesta
  #v(32pt)
  #bq-rule-full(color: tema.colors.dark, theme: tema)
  #v(28pt)
  #text(font: tema.fonts.body, size: 28pt, fill: tema.colors.dark)[
    Cuando el texto está haciendo prácticamente lo contrario: #text(weight: 700)[el problema no es tener suficiente capacidad de cómputo], sino tener #text(weight: 700, fill: tema.colors.primary)[entendimiento] para reconocer qué significa el número.
  ]
]

#cita-canvas(
  contenido,
  "presuposicionalismo.com",
  size: sizes.instagram,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
  theme: tema,
)
