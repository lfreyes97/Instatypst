// Carrusel de Instagram: Jacques Ellul — ¿Qué es la Técnica? (10 diapositivas, 1080×1080).
// Serie previa a ellul-estado-tecnico.typ. Mismo tema plano para continuidad.
// Compilar: typst compile --root . --font-path Fonts trabajos/ellul-tecnica/ellul-tecnica.typ "salida/ellul-tecnica-{p}.png" --ppi 144
#import "../../src/lib.typ": *

#let azul = rgb("#14357a")
#let tema = (theme.define)("plano", colors: (
  primary: azul,
  secondary: azul,
  accent: rgb("#b4532a"),
  dark: rgb("#1b2433"),
  light: rgb("#eef2f7"),
))
#let total = 10
#let plano-fondo(n) = {
  place(top + left, rect(width: 100%, height: 100%, fill: rgb("#eef2f7")))
  superbg.bg-patron(patron: "grid", color: azul, paso: 54, grosor: 1, opacidad: 9%, size: sizes.instagram)
}
#let comun = arguments("Luis F. Reyes", label: "Jacques Ellul", total: total, fondo: plano-fondo, theme: tema)

#carrusel-slide(
  ..comun,
  n: 1,
  title: [¿Qué es la Técnica?],
  body: [En 1954, mucho antes del computador personal, Jacques Ellul publicó _La Technique ou l'enjeu du siècle_: Moloch tiene hoy la forma de la Técnica. No habla de aparatos sueltos, sino del riesgo existencial que hoy nombramos IA.],
  body-italic: true,
  title-size: 72pt,
)
#carrusel-slide(
  ..comun,
  n: 2,
  title: [Las técnicas, no],
  body: [Ellul distingue _las técnicas_, herramientas particulares e históricamente acotadas, de _la Técnica_ con mayúscula: un fenómeno sociológico nuevo, propio de la modernidad. Es la búsqueda sistemática, en todos los ámbitos de la vida, del método absolutamente más eficiente.],
)
#carrusel-slide(
  ..comun,
  n: 3,
  numeral: "1",
  title: [El one best way],
  body: [La fórmula viene de Frederick Taylor (_Scientific Management_, 1911) y su _one best way_ fabril. Ellul la retoma a propósito: el taylorismo industrial era solo el caso particular. Esa lógica de optimización total termina por colonizarlo todo: el trabajo, la escuela, el amor, la guerra.],
)
#carrusel-slide(
  ..comun,
  n: 4,
  numeral: "2",
  title: [Tesis central],
  body: [Una vez que la eficiencia se vuelve el único criterio de validación de un medio, ese medio ya no necesita justificación externa —moral, política o religiosa— para seguir expandiéndose. Lo eficiente se autoriza a sí mismo. Cualquier valor que no quepa en un parámetro optimizable simplemente desaparece de la ecuación.],
)
#carrusel-slide(
  ..comun,
  n: 5,
  numeral: "3",
  title: [Su base doble],
  body: [Antes de los seis rasgos, dos condiciones: _racionalidad_, aplicar el pensamiento lógico y sistemático a cada actividad hasta eliminar lo espontáneo y lo irracional; y _artificialidad_, construir un entorno propio que desplaza y subordina al medio natural. Sobre esa base corre todo lo demás.],
)
#carrusel-slide(
  ..comun,
  n: 6,
  numeral: "4",
  title: [Autonomía y automatismo],
  body: [El rasgo más radical, el que gobierna a los demás: la Técnica deja de responder a fines humanos y genera sus propios criterios internos. Frente a varios medios no delibera, calcula y elige mecánicamente el óptimo. Ya no pregunta “¿para qué?”, solo “¿es más eficiente?”. En IA: el “¿deberíamos hacerlo?” queda subordinado al “¿podemos hacerlo más capaz?”.],
  referencia: [Autonomía],
)
#carrusel-slide(
  ..comun,
  n: 7,
  numeral: "5",
  title: [Autoaumento],
  body: [Dos leyes: en una civilización dada el progreso técnico es irreversible y crece en progresión geométrica, no aritmética. Cada avance engendra otros sin depender del genio individual. Hoy es literal: el desalineamiento, la opacidad y el mal uso de la IA se intentan curar con más cómputo y con IA que vigila a otra IA. La técnica solo se corrige con más técnica.],
)
#carrusel-slide(
  ..comun,
  n: 8,
  numeral: "6",
  title: [Todo ligado, todo invadido],
  body: [Ninguna técnica opera aislada: exige y provoca otras —económicas, administrativas, psicológicas— que la sostienen. Entrenar un modelo de frontera no es solo cómputo: pide energía, semiconductores y leyes nuevas. Y ese bloque se expande sin freno geográfico ni cualitativo: el mismo método escribe poesía, diagnostica y planea la logística militar.],
  referencia: [Vinculación · Universalismo],
)
#carrusel-slide(
  ..comun,
  n: 9,
  numeral: "7",
  title: [Monismo],
  body: [El fenómeno técnico es un bloque indivisible: no se separa el instrumento de su uso ni el efecto buscado del daño colateral. Lo posible se usa. La bomba salió antes que la central porque era técnicamente más simple: hubo que “pasar por ese estadio transitorio pero necesario”. Soustelle, 1960: “Puesto que era posible, era necesario”. La vía fácil —mejora sin control— siempre está más a la mano que la difícil —potencia alineada—.],
  referencia: [Soustelle, 1960],
)
#carrusel-slide(
  ..comun,
  n: 10,
  swipe: false,
  title: [Eso también es técnica],
  body: [Ante cualquier salida por ley, mecanismo o institución, la respuesta de Ellul era: “eso también es técnica”. No hay receta. Solo un acto de libertad que empieza por la _prise de conscience_, reconocer la propia no-libertad, y se sostiene poniendo distancia crítica en comunidad. Vigilar, no solo regular.],
  body-italic: true,
)
