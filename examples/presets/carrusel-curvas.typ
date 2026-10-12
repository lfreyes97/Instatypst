// Demo de `fondo:` en el carrusel (src/carrusel.typ) con un campo de
// curvas (src/curvas.typ): cada diapositiva dibuja su ventana del campo
// según su `n:`, así que las curvas pasan de una a otra sin corte y el
// carrusel se lee como una sola tira. Al final, el campo entero.
// Compilar: typst compile --root . --font-path Fonts examples/presets/carrusel-curvas.typ
#import "../../src/lib.typ": *

#let tema = (theme.define)("ondas", colors: (
  primary: rgb("#1d2b36"),
  secondary: rgb("#1d4ed8"),
  accent: rgb("#b4532a"),
  dark: rgb("#1d2b36"),
  light: rgb("#f3efe6"),
))
#let total = 5
#let ondas = curvas.campo("ondas", diapositivas: total, color: rgb("#1d4ed8"), opacidad: 40%, semilla: 3)
#let comun = arguments("PRESUPOSICIONALISMO", label: "Cinco razones", total: total, fondo: ondas, theme: tema)

#carrusel-slide(..comun, n: 1,
  title: [Por qué la fe razona],
  body: [Cinco razones para no dejar la razón en la puerta de la iglesia.],
  body-italic: true)
#carrusel-slide-definicion(..comun, n: 2,
  termino: [Presuposición], pronunciacion: [pre·su·po·si·ˈθjon], origen: [lat. _praesupponere_],
  body: [Lo que se da por cierto antes de razonar, y desde donde se razona.])
#carrusel-slide(..comun, n: 3, numeral: "1",
  title: [Nadie razona desde cero],
  body: [Todo argumento descansa en algo que no demuestra.],
  referencia: [Proverbios 1:7])
#carrusel-slide(..comun, n: 4, numeral: "2",
  title: [La pregunta es cuál],
  body: [No si hay presuposiciones, sino cuáles sostienen la razón.],
  referencia: [Colosenses 2:3])
#carrusel-slide(..comun, n: 5, swipe: false,
  title: [En tu luz veremos la luz],
  body: [La fe no apaga la razón: le da dónde pararse.],
  referencia: [Salmo 36:9])

// El campo entero: las cinco ventanas, una al lado de la otra.
#page(width: 5400pt, height: 1080pt, margin: 0pt, fill: rgb("#f3efe6"), curvas.panorama(ondas))
