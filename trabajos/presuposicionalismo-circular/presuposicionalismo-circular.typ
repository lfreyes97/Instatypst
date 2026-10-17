// Carrusel de Instagram: ¿Es circular el presuposicionalismo? (12 diapositivas, 1080×1080).
// Portada, diez láminas de texto completo (una por sección) y cierre. Piezas de
// carteles: suizo en la portada (y su marco en el cierre, con el logo de la
// campaña y los enlaces), demostracion en el argumento trascendental y liso en el resto. La
// firma va solo en portada y cierre; las interiores llevan el contador.
//
// Dentro de una lámina (`lamina`) el texto se escribe con encabezados:
//   = Título        antetítulo chico, en mono y en el acento de la lámina
//   == Frase        la frase que guía o remata, al cuerpo del cartel
//   párrafo normal  el desarrollo, a `k` de ese cuerpo y más ligero
// Compilar: typst compile --root . --font-path Fonts trabajos/presuposicionalismo-circular/presuposicionalismo-circular.typ "salida/presuposicionalismo-circular-{p}.png" --ppi 144
#import "../../src/lib.typ": *
#import "../campana/_comun.typ": logo, marca

#let f = sizes.instagram
#let autor = [Luis F. Reyes]
#let total = 12
#let cuenta(n, color) = text(font: "DM Mono", size: 20pt, fill: color, tracking: 0.1em)[#if n < 10 [0]#n / #total]
#let crema = rgb("#efe9db")
#let vino = rgb("#6b1e2b")
#let oscuro = rgb("#141414")
#let azul = rgb("#14357a")
#let gris = rgb("#8b95a1")
#let ambar = rgb("#f2b33d")

// Acento según el fondo: vino sobre crema, crema sobre vino, ámbar en el resto.
#let acento-de(fondo) = if fondo == crema { vino } else if fondo == vino { crema } else { ambar }
#let mono(cuerpo, color, size: 22pt) = text(font: "DM Mono", size: size, weight: 500, tracking: 0.12em, fill: color, cuerpo)

// Proporción del desarrollo respecto de la frase grande.
#let k = 0.58
#let grande = (1 / k) * 1em

#let estilo(acento, cuerpo) = {
  set text(size: k * 1em, weight: 400, tracking: 0em)
  set par(leading: 0.5em, spacing: 1.1em)
  show heading.where(level: 1): it => block(below: 36pt, mono(upper(it.body), acento))
  show heading.where(level: 2): it => block(above: 1.4em, below: 1.2em, {
    set text(size: grande, weight: 600, tracking: -0.02em)
    set par(leading: 0.28em)
    it.body
  })
  cuerpo
}

#let lamina(n, fondo: oscuro, cuerpo) = carteles.liso(
  estilo(acento-de(fondo), cuerpo),
  formato: f, fondo: fondo, cuerpo-max: 96pt, margen: 88pt,
  marca: cuenta(n, if fondo == crema { oscuro.lighten(40%) } else { white.darken(25%) }))

// Cierre: sitio, tres artículos (título tal como aparece en el sitio), recuadro
// reservado para el artículo propio y referencias de las láminas 8, 9 y 11.
#let sitio = [presuposicionalismo.com/blog]
#let enlaces = (
  [Las contradicciones inherentes al agnosticismo],
  [Qué es el método transcendental],
  [Qué es la apologética presuposicional],
)
// Cambiar por el título y el enlace cuando el artículo esté publicado.
#let articulo = [Artículo completo: próximamente.]
#let referencias = (
  [J. N. Anderson, «No Dilemma for the Proponent of the Transcendental Argument», _Philosophia Christi_ 13:1 (2011).],
  [I. Cabrera, _Argumentos trascendentales_.],
  [W. L. Craig, respuesta a J. Frame, en _5 puntos de vista sobre la apologética_.],
  [G. Bahnsen, _La apologética de Van Til_.],
  [Aristóteles, _Metafísica_ IV 4.],
)

// Paleta suiza de la lámina 01 de la campaña, con el vino del carrusel de acento.
#let suizo = (papel: crema, tinta: oscuro, acento: vino, linea: rgb("#d9d3c7"), gris: rgb("#5c5850"))
#let rotulo(cuerpo, ..args) = text(font: "Inter", size: 22pt, ..args, cuerpo)

// 1 · Portada: cartel suizo, «CIRCULAR?» a todo el ancho.
#carteles.suizo(
  [¿Es el presuposicionalismo],
  [CIRCULAR?],
  formato: f,
  autor: [LUIS F. REYES],
  etiqueta: [APOLOGÉTICA],

  ..suizo,
  marca: logo(oscuro, f),
)

// 2 · Advertencia de pedantería
#lamina(2)[
  = ¿Es circular el presuposicionalismo?
  == #text(fill: ambar)[¡Evidentemente no!] «Circular» no es algo que se diga de una escuela de pensamiento.

  La circularidad se predica de los argumentos, no de una doctrina ni de un «ismo»: atribuírsela al presuposicionalismo es un error de categoría. 
  
  Y, en mi opinión, todo argumento válido es formalmente circular, en el sentido de que su conclusión se sigue de sus premisas o está contenida en ellas.

  == Si la conclusión no está contenida en las premisas, no se sigue de ellas: #text(fill: ambar)[es un #box[_non sequitur_].]
]

// 3 · ¿Qué significa que un argumento sea circular?
#let premisa(n, t) = grid(columns: (1.8em, 1fr), align: (left + horizon, left),
  text(font: "DM Mono", size: 0.7em, fill: vino)[(#n)], t)
#lamina(3, fondo: crema)[
  = ¿Qué significa que un argumento sea circular?
  == Consideremos el siguiente silogismo:

  #block(spacing: 1.4em, text(size: 0.8 * grande, weight: 500, stack(spacing: 0.45em,
    premisa(1)[Todos los hombres son mortales.],
    premisa(2)[Sócrates es hombre.],
    line(length: 100%, stroke: 2pt + oscuro),
    premisa(3)[#text(weight: 700, fill: vino)[Por tanto, Sócrates es mortal.]],
  )))

  La mortalidad de Sócrates es una instancia particular de la proposición universal «todos los hombres son mortales». La conclusión se sigue de las premisas: no introduce una verdad independiente de ellas, sino que hace explícito lo que ya contienen.
]

// 4 · ¿Y la petitio principii?
#lamina(4, fondo: vino)[
  = ¿Y la _petitio principii_?
  == Ohh, me dirá alguien, ¿acaso estás diciendo que la falacia de _petitio principii_ no es un argumento falaz porque los argumentos circulares son válidos?
]

// 5 · Falacias formales e informales
#lamina(5, fondo: azul)[
  = Falacias formales e informales
  == En efecto, debe distinguirse entre falacias #text(fill: ambar)[formales] y falacias #text(fill: ambar)[informales].

  La petición de principio, sin embargo, no constituye un error en virtud de la forma lógica del razonamiento: su conclusión puede seguirse válidamente de sus premisas. En estricto rigor, una petición de principio consiste en tomar como premisa, explícitamente o de forma encubierta, la misma proposición que el argumento pretende probar, de modo que las premisas solo resultan aceptables para quien ya acepta la conclusión.

  == #text(fill: ambar)[Es una falacia informal.]
]

// 6 · El problema de la justificación
#lamina(6)[
  = El problema de la justificación

  En el sentido amplio de Aristóteles, toda falacia es una _ignoratio elenchi_: un desconocimiento de lo que es una refutación. Y una refutación exige no contar entre las premisas lo que estaba en cuestión. Por eso la petición de principio falla, no en la forma, sino en la relevancia de sus razones: no aporta ninguna razón independiente para aceptar la conclusión.

  == La cuestión no es si la conclusión se sigue de las premisas, sino si estas #text(fill: ambar)[ofrecen razones] para aceptar aquello que se pretende justificar.
]

// 7 · ¿Pero y el presuposicionalismo? La bisagra: las dos razones, numeradas;
// la primera traslada la carga al objetor, la segunda anuncia la lámina 8.
#let razon(n, cuerpo) = grid(columns: (auto, 1fr), column-gutter: 0.7em, align: (left + top, left + top),
  text(font: "Bebas Neue", size: 2.6 * grande, fill: vino, top-edge: "cap-height", bottom-edge: "baseline")[#n],
  cuerpo)
#lamina(7, fondo: crema)[
  = ¿Pero y el presuposicionalismo?
  == Dos razones para negar la petición de principio.

  #razon(1)[*La circularidad formal no es un vicio.* Entonces la objeción no puede limitarse a decir que el argumento presuposicionalista es circular: tiene que mostrar que lo es en un sentido vicioso, que alguna de sus premisas solo resulta aceptable para quien ya acepta la conclusión.]

  #razon(2)[*La circularidad en juego es la del método trascendental, no la de una petición de principio.* Aparece cuando se pregunta qué tiene que ser verdad para que la experiencia humana sea inteligible, y no es, por sí misma, un vicio. #text(fill: vino)[→]]

  == No basta con señalar que un argumento es circular. #text(fill: vino)[Hay que demostrar que su circularidad es viciosa.]
]

// 8 · La circularidad trascendental
#lamina(8, fondo: azul)[
  = la circularidad trascendental
  == La circularidad presuposicionalista es circularidad #text(fill: ambar)[trascendental].

  No hay una única formulación del argumento trascendental, pero todas comparten un rasgo: preguntan qué tiene que ser verdad para que podamos conocer, para que la historia tenga sentido y para que razonar no sea arbitrario. Cualquier respuesta, también la del objetor, tiene que servirse de aquello que intenta explicar. El presuposicionalista sostiene que Dios es la #text(fill: ambar)[condición trascendental] de esa inteligibilidad. Hasta Craig, crítico del presuposicionalismo, lo admite: «no se trata de una circularidad viciosa, sino más bien de la naturaleza inherente a un argumento trascendental».
]

// 9 · El argumento trascendental: cada premisa con su fórmula al lado; la conclusión, enorme.
#let paso(t, formula, nota: none) = block(inset: (y: 0.35em), grid(columns: (1fr, auto), column-gutter: 28pt, align: (left + horizon, right + horizon),
  [#t#if nota != none [ #box(text(font: "DM Mono", size: 0.55em, fill: gris)[#nota])]],
  text(fill: rgb("#f4f1ea"), formula)))
#carteles.demostracion((
  (
    paso([Argumentar es posible.], $diamond.stroked A$),
    paso([Argumentar es necesariamente posible.], $square.stroked diamond.stroked A$, nota: [1, S5.]),
    paso([Necesariamente, si es posible argumentar, Dios existe.], $square.stroked (diamond.stroked A -> G)$),
    paso([Si es necesariamente posible argumentar, Dios existe necesariamente.], $square.stroked diamond.stroked A -> square.stroked G$, nota: [3, K.]),
  ),
  (
    (afirma: [$square.stroked G$
      #block(above: 0.25em, text(size: 0.24em, weight: 400, fill: rgb("#c3c9d1"), tracking: 0em)[Dios existe necesariamente. (2, 4)])], cuerpo: 140pt),
  ),
), formato: f, marca: cuenta(9, gris),
  encabezado: {
    block(below: 36pt, mono(upper[El argumento trascendental], ambar))
    text(size: 0.85em)[Esa tesis puede reconstruirse como un argumento. Veamos si en él hay alguna petición de principio:]
    block(above: 0.7em, text(size: 0.68em, fill: gris)[En notación modal, sean $G$: «Dios existe», y $A$: «Hay argumentación». Reconstrucción basada en J. N. Anderson e I. Cabrera.])
  })

// 10 · ¿Dónde está la petición de principio?
#lamina(10, fondo: crema)[
  = ¿Dónde está la petición de principio?
  == Si la hay, tiene que estar en la premisa 3.

  Pero no basta con decir «no acepto la explicación teísta». Quien rechaza (3) tiene que proponer otra explicación de las condiciones de la argumentación, la que sea.

  Y esa explicación se defenderá del mismo modo: sirviéndose, para justificarse, de lo mismo que pretende explicar. Si eso es una petición de principio, también lo es la del objetor.

  == Por tanto, #text(fill: vino)[la circularidad no es un motivo para rechazar (3).]
]

// 11 · La cuestión decisiva
#lamina(11)[
  = La cuestión decisiva
  == Todos razonan en círculo. Lo que cuenta es qué círculo se sostiene.

  Aristóteles lo vio al defender el principio de no contradicción: no puede demostrarse sin petición de principio, pero sí refutarse indirectamente a quien lo niega, con tal de que diga algo.

  Por eso el método es indirecto: no deduce a Dios desde una premisa neutral. Parte de la posición del adversario y muestra que, llevada a sus consecuencias, hace imposible lo mismo que él está haciendo: argumentar. Para Bahnsen, esos círculos son «destructivos para el pensamiento humano».

  == Queda por examinar #text(fill: ambar)[si las alternativas pueden dar cuenta de la argumentación sin Dios.]
]

// 12 · Cierre: el marco del cartel suizo (retícula, filetes de cabecera y
// pie) con el logo y los enlaces al centro.
#{
  let (ancho, alto) = (f.at(0) * 1pt, f.at(1) * 1pt)
  let r = carteles.reticula(ancho)
  page(width: ancho, height: alto, margin: 0pt, fill: suizo.papel, {
    set text(font: "Hanken Grotesk", fill: suizo.tinta, lang: "es")
    for i in range(6) {
      for x in (r.x.at(i), r.x.at(i) + r.col) {
        place(top + left, dx: x, line(start: (0pt, 0pt), end: (0pt, alto), stroke: 0.8pt + suizo.linea))
      }
    }
    place(top + left, dx: 64pt, dy: 64pt, line(length: r.util, stroke: 2.5pt + suizo.tinta))
    place(top + left, dx: r.x.at(0), dy: 64pt + 18pt, rotulo(weight: 700, tracking: 0.12em)[LUIS F. REYES])
    place(top + left, dx: r.x.at(3), dy: 64pt + 18pt, rotulo(fill: suizo.gris)[#total / #total])
    place(bottom + left, dx: 64pt, dy: -112pt, line(length: r.util, stroke: 2.5pt + suizo.tinta))

    place(top + center, dy: 150pt, block(width: r.util, align(center, {
      marca.logo(width: 440pt, color: suizo.tinta)
      v(44pt)
      rotulo(weight: 700, tracking: 0.12em, fill: suizo.acento)[PARA MÁS RECURSOS VISITA:]
      v(14pt)
      text(size: 34pt, weight: 600, sitio)
      v(14pt)
      stack(spacing: 10pt, ..enlaces.map(e => text(size: 26pt, weight: 400, e)))
      v(30pt)
      block(width: 85%, inset: 16pt, stroke: (dash: "dashed", paint: suizo.gris, thickness: 1.2pt),
        text(size: 24pt, fill: suizo.gris, articulo))
    })))
    place(bottom + left, dx: 64pt, dy: -136pt, block(width: r.util, {
      set text(size: 18pt, fill: suizo.gris)
      set par(leading: 0.4em, spacing: 0.5em)
      referencias.join(parbreak())
    }))
  })
}
