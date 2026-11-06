// Carrusel «La no-potencia (Jacques Ellul)»: portada, seis puntos y una
// salida con las fuentes. Fondo liso; el campo de curvas es opcional (ver
// carrusel-curvas.typ).
// Compilar: typst compile --root . --font-path Fonts --format png --ppi 72 \
//   examples/presets/carrusel-ellul.typ "examples/salidas/ellul/{n}.png"
#import "../../src/lib.typ": *

#let tema = (theme.define)("ellul", colors: (
  primary: rgb("#1c1c1c"),
  secondary: rgb("#8c2f1b"),
  accent: rgb("#8c2f1b"),
  dark: rgb("#1c1c1c"),
  light: rgb("#efe9dc"),
))
#let total = 8
#let comun = arguments("JACQUES ELLUL", label: "No-potencia", total: total, theme: tema)

// Portada
#carrusel-slide(..comun, n: 1, title-size: 78pt,
  title: [La no-potencia],
  body: [La respuesta de Ellul al imperio de la técnica: no usar el poder que se tiene.],
  body-italic: true)

#carrusel-slide(..comun, n: 2, numeral: "1",
  title: [No es impotencia],
  body: [Impotencia es no tener medios. La no-potencia es elegir de antemano no intervenir, aun pudiendo hacerlo.])

#carrusel-slide(..comun, n: 3, numeral: "2",
  title: [Cristo se despoja],
  body: [Frente a la técnica, que acumula poder y control, Dios se muestra en la kénosis: carne débil, pies lavados, cruz.],
  referencia: [Filipenses 2:5-8])

#carrusel-slide(..comun, n: 4, numeral: "3",
  title: [Más política es más técnica],
  body: [Resolver un problema técnico con política o con más tecnología produce «más técnica». Y el poder siempre pide más poder.])

#carrusel-slide(..comun, n: 5, numeral: "4",
  title: [Primero el ser, luego el hacer],
  body: [No multiplicar acciones útiles, sino vincularse al ser: silencio, reposo del sábado, oración y presencia.],
  referencia: [Éxodo 20:8-11])

#carrusel-slide(..comun, n: 6, numeral: "5",
  title: [Se rompe el ídolo de la eficiencia],
  body: [Se deja el espíritu de conquista de Caín y se recupera la vulnerabilidad del desierto: espacio para el prójimo y confianza en la Palabra.],
  referencia: [Génesis 4:17])

#carrusel-slide(..comun, n: 7, numeral: "6",
  title: [Ni la no violencia como técnica],
  body: [Si se vuelve método de eficacia, es otro poder. La no-potencia es una elección, no una estrategia.])

// Salida: fuentes
#carrusel-slide(..comun, n: 8, swipe: false, title-size: 46pt, body-size: 22pt,
  title: [Fuentes],
  body: [
    _Presence in the Modern World_ (_Présence au monde moderne_, 1948) \
    «The Power of Technique and the Ethics of Non-Power» (1980) \
    _On Freedom, Love, and Power_ (ed. W. Vanderburg), cap. 4 \
    _Violence_ · _Anarchy and Christianity_ \
    _The Subversion of Christianity_ \
    _Apocalypse: The Book of Revelation_
  ],
  referencia: [Jacques Ellul])
