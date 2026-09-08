// Campaña Warfield — cita 09
// Fuente: La elección
// Plantilla: cita-canvas + blockquote-hero — paleta "noche-azul" + tipografía "brutalista"
// Compilar: typst compile --root . --font-path Fonts campana/09-elegidos-para-ser-buenos.typ
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "noche-azul", tipografia: "brutalista")
#let cita = blockquote-hero.with(theme: tema, color: tema.colors.primary)
#let marca-h = tema.colors.primary.transparentize(65%)

// El contraste "no somos X porque... sino para que" es el nervio de la
// cita — el highlight ya lo marca en color. "brutalista" resuelve a Bebas
// Neue, una fuente ESTÁTICA de un solo peso (no variable) — #text(weight:)
// ahí no hace nada, Typst ignora el peso pedido si no hay una cara para
// darlo (verificado: diff de píxeles 0 contra la versión sin el override).
// #text(tracking:) sí es on-the-fly real en cualquier fuente, variable o
// no, así que la palabra que sostiene el contraste se separa un poco de
// sus letras — el mismo peso pero más presente.
//
// Bug de Typst encontrado al armar esto: un `;` pegado justo después de
// cerrar un `#función(..)[..]` (sin espacio de por medio) NO se muestra —
// Typst lo interpreta como el terminador opcional de esa expresión de
// código embebida en markup, no como texto literal (`.`/`,` no tienen ese
// problema, verificado aparte). `#[;]` fuerza al `;` a ser contenido
// literal en vez de sintaxis.
#warfield-canvas(
  cita(
    [No somos escogidos porque seamos #highlight(fill: marca-h)[#text(tracking: 0.05em)[buenos]]#[;] somos escogidos para que podamos ser #highlight(fill: marca-h)[#text(tracking: 0.05em)[buenos]].],
    autor: "B.B. Warfield",
    fuente: "La elección",
  ),
  tema,
  size: sizes.twitter,
  bg-color: tema.colors.white,
  blob-color: tema.colors.primary,
  footer-color: gray.darken(45%),
)
