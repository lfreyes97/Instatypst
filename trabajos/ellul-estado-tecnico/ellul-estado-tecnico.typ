// Carrusel de Instagram: Jacques Ellul y el Estado técnico (10 diapositivas, 1080×1080).
// Fondo de plano (retícula azul sobre papel claro) con el motor de src/carrusel.typ.
// Compilar: typst compile --root . --font-path Fonts trabajos/ellul-estado-tecnico/ellul-estado-tecnico.typ "salida/ellul-estado-tecnico-{p}.png" --ppi 144
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
#let comun = arguments("Luis F. Reyes", label: "El estado como tecnica", total: total, fondo: plano-fondo, theme: tema)

#carrusel-slide(
  ..comun,
  n: 1,
  title: [El Estado técnico],
  body: [El Estado moderno no nació siendo una Técnica, pero hoy es su caso mayor: un gigantesco organismo técnico. Lo que Ellul describió en 1954 como búsqueda del _one best way_ en todo —lo más eficiente sin pedir permiso— aquí se vuelve gobierno: administrar masas con cálculo, no con fines.],
  body-italic: true,
  title-size: 72pt,
)
#carrusel-slide(
  ..comun,
  n: 2,
  title: [¿Qué es la Técnica?],
  body: [No los aparatos sueltos (_las técnicas_), sino _la Técnica_ con mayúscula: el fenómeno moderno descrito en 1954 que busca en todo ámbito el método absolutamente más eficiente, el _one best way_ de Taylor. Cuando la eficiencia es el único criterio, el medio se autoautoriza y ya no pide permiso a la moral, la política o la religión.],
)
#carrusel-slide(
  ..comun,
  n: 3,
  title: [Características],
  body: [Base doble: _racionalidad_ que elimina lo espontáneo y _artificialidad_ que subordina la naturaleza. Y seis rasgos: _autonomía_ (sus propias leyes), _automatismo_ (elige el óptimo sin deliberar), _autoaumento_ (irreversible, geométrico), _vinculación_ (todo pide todo), _universalismo_ (todo invadido) y _monismo_ (lo posible se usa).],
)
#carrusel-slide(
  ..comun,
  n: 4,
  title: [No nació técnico],
  body: [En las sociedades premodernas el Estado usaba _técnicas_ sueltas y empíricas —la estrategia militar, el impuesto— sin medios para un control continuo de la población. Faltaban la _racionalidad_ sistemática y el entorno _artificial_ (registros, estadística, burocracia) que hoy lo hacen posible todo el tiempo y en todas partes.],
)
#carrusel-slide(
  ..comun,
  n: 5,
  numeral: "1",
  title: [Una fusión],
  body: [La sociedad industrial y de masas desbordó al individuo: economía, infraestructura y gestión exigieron coordinación central. El Estado se apoderó de las técnicas y, a la vez, la lógica de la máxima eficiencia se apoderó de él. Es la _autonomía_ de la Técnica aplicada al poder: el Estado ya no usa medios, obedece a sus leyes internas.],
)
#carrusel-slide(
  ..comun,
  n: 6,
  numeral: "2",
  title: [La política como técnica],
  body: [La política deja de ser debate de ideas y valores sobre el buen gobierno y se vuelve _técnica política_ —de cuño leninista—: manipulación eficiente de las masas para resultados calculados. Es el _automatismo de la elección_: no se delibera el para qué, se calcula el cómo más eficaz y se ejecuta.],
)
#carrusel-slide(
  ..comun,
  n: 7,
  numeral: "3",
  title: [Decidir ya no decide],
  body: [Ante la masa de expedientes y la complejidad del sistema, el gobernante pierde la elección real. Queda como figura que refrenda lo ya preparado por tecnócratas, burocracias y expertos. Ellul lo llama _desposesión de la decisión_: el humano ya no es el agente, solo firma el óptimo que la máquina administrativa calculó.],
  referencia: [Desposesión de la decisión],
)
#carrusel-slide(
  ..comun,
  n: 8,
  numeral: "4",
  title: [Totalitarismo de los medios],
  body: [La eficacia exige centralizar. Sea dictadura o democracia formal, el Estado técnico tiende al totalitarismo funcional: propaganda masiva, planificación central y vigilancia continua. Es _vinculación_ y _universalismo_: ninguna técnica va sola y todas reclaman al ciudadano entero, reducido a unidad gestionable, medible y predecible.],
)
#carrusel-slide(
  ..comun,
  n: 9,
  numeral: "5",
  title: [La ley como gestión],
  body: [El derecho pierde su raíz en la justicia y la trascendencia y se hace _técnica jurídica_: puro instrumento administrativo. Una norma ya no vale por justa, sino por efectiva para mantener el orden y la productividad. Lo que no se traduce en parámetro optimizable —el bien, lo sagrado— desaparece de la ecuación.],
  referencia: [Técnica jurídica],
)
#carrusel-slide(
  ..comun,
  n: 10,
  swipe: false,
  title: [Ejecutor supremo],
  body: [El Estado contemporáneo es garante supremo de la Técnica: más empresa automatizada de servicios y control que institución guiada por fines éticos. Y como todo _monismo_, lo posible se usará. Frente a eso no basta otra técnica de contención: solo la _prise de conscience_, reconocer la no-libertad, abre distancia crítica.],
  body-italic: true,
)
