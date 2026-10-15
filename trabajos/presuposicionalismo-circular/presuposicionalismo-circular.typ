// Carrusel de Instagram: ¿Es circular el presuposicionalismo? (12 diapositivas, 1080×1080).
// Portada, diez láminas de texto completo (una por sección) y cierre. Piezas de
// carteles: suizo en la portada (y su marco en el cierre, con el logo de la
// campaña y los enlaces), demostracion en la retorsión y liso en el resto. La
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

// Enlaces del cierre: uno por renglón.
#let enlaces = ([enlace-1.org], [enlace-2.org], [enlace-3.org])

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

  La mortalidad de Sócrates es una instancia particular de la proposición universal «todos los hombres son mortales». La conclusión se sigue de las premisas: no introduce una verdad independiente de ellas, sino que explicita una consecuencia lógica de las mismas.
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
  == Dos razones para negar que pida el principio.

  #razon(1)[*La circularidad formal no es un vicio.* Entonces la objeción no puede limitarse a decir que el argumento presuposicionalista es circular: tiene que mostrar que lo es en el único sentido vicioso, que alguna de sus premisas solo resulta aceptable para quien ya acepta la conclusión.]

  #razon(2)[*La circularidad en juego ni siquiera es la de un argumento.* Es la que aparece cuando se pregunta qué tiene que ser verdad para que la experiencia humana sea inteligible: para que podamos conocer, para que la historia tenga sentido, para que razonar no sea arbitrario. Cualquier respuesta a esa pregunta, también la del objetor, tiene que servirse de aquello que intenta explicar: esa circularidad no es exclusiva del presuposicionalismo ni es, por sí misma, una petición de principio. #text(fill: vino)[→]]

  == No basta con señalar que un argumento es circular. #text(fill: vino)[Hay que demostrar que su circularidad es viciosa.]
]

// 8 · La circularidad trascendental
#lamina(8, fondo: azul)[
  = Segunda razón: la circularidad trascendental
  == Aquí viene el punto decisivo: la circularidad presuposicionalista es circularidad #text(fill: ambar)[trascendental].

  ¡Ni siquiera estamos hablando del tipo de circularidad que se puede formalizar en un argumento! La pretensión presuposicionalista no consiste simplemente en inferir la existencia de Dios a partir de premisas que ya la presuponen. Consiste en sostener que Dios es la #text(fill: ambar)[condición de posibilidad] de la inteligibilidad, la racionalidad y el conocimiento. La cuestión es trascendental: ¿cuáles son las condiciones de posibilidad de la argumentación misma?
]

// 9 · La retorsión: cada premisa con su fórmula al lado; la conclusión, enorme.
#let paso(t, formula, nota: none) = block(inset: (y: 0.35em), grid(columns: (1fr, auto), column-gutter: 28pt, align: (left + horizon, right + horizon),
  [#t#if nota != none [ #text(font: "DM Mono", size: 0.55em, fill: gris)[#nota]]],
  text(fill: rgb("#f4f1ea"), formula)))
#carteles.demostracion((
  (
    paso([Argumentar es posible.], $diamond.stroked A$),
    paso([Argumentar es necesariamente posible.], $square.stroked diamond.stroked A$, nota: [De 1 y S5.]),
    paso([Necesariamente, si Dios existe, es posible argumentar.], $square.stroked (G -> diamond.stroked A)$),
  ),
  (
    (afirma: [$square.stroked G -> square.stroked diamond.stroked A$
      #block(above: 0.25em, text(size: 0.24em, weight: 400, fill: rgb("#c3c9d1"), tracking: 0em)[Necesariamente, si Dios existe necesariamente, es necesariamente posible argumentar.])], cuerpo: 140pt),
  ),
), formato: f, marca: cuenta(9, gris),
  encabezado: {
    block(below: 36pt, mono(upper[La retorsión], ambar))
    text(size: 0.85em)[Supongamos que mi afirmación de que todos los argumentos válidos son circulares no es convincente. Dije que sería pedantería. Veamos, entonces, el argumento:]
    block(above: 0.7em, text(size: 0.68em, fill: gris)[En notación modal, sean $G$: «Dios existe», y $A$: «Es posible argumentar».])
  })

// 10 · ¿Dónde está la petición de principio?
#lamina(10, fondo: crema)[ale, dije que era pedantería...
  = ¿Dónde está la petición de principio?
  == ¿En dónde está la petición de principio?

  Si la acusación es que el argumento presupone su conclusión, hay que identificar la premisa que lo hace y explicar por qué esa presuposición es ilegítima.

  La mera presencia de una conclusión teísta no demuestra que el argumento sea falaz. Tampoco basta con señalar que el argumento es modal o que parte de condiciones necesarias de la argumentación.

  == #text(fill: vino)[La objeción necesita algo más que la palabra «circular».]
]

// 11 · La cuestión decisiva
#lamina(11)[
  = La cuestión decisiva

  La retorsión no consiste en demostrar cualquier conclusión a partir de la posibilidad de argumentar. Consiste en mostrar que una posición no puede sostenerse coherentemente sin presuponer aquello que pretende negar.

  Por eso, la cuestión decisiva no es simplemente si el presuposicionalismo es circular, sino si sus presupuestos son las condiciones de posibilidad de la inteligibilidad y si las alternativas pueden dar cuenta de esas mismas condiciones.

  == La circularidad no es todavía una refutación. #text(fill: ambar)[La pregunta es qué clase de circularidad está en juego.]
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

    place(center + horizon, dy: -24pt, block(width: r.util, align(center, {
      marca.logo(width: 620pt, color: suizo.tinta)
      v(72pt)
      rotulo(weight: 700, tracking: 0.12em, fill: suizo.acento)[PARA MÁS RECURSOS VISITA:]
      v(28pt)
      stack(spacing: 20pt, ..enlaces.map(e => text(size: 44pt, weight: 500, tracking: -0.01em, e)))
    })))
  })
}
