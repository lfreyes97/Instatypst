// ─────────────────────────────────────────────────────────────
//  docs/catalogo.typ — Catálogo de presets
//  Cada preset de examples/presets/ con sus láminas en miniatura, el
//  nombre, la descripción de su cabecera y una llamada que lo genera.
//  Las miniaturas y el índice (docs/catalogo/) los genera el script; no
//  se versionan. Regenerar:
//      python3 scripts/catalogo.py            (añade --png para PNG)
// ─────────────────────────────────────────────────────────────

#let datos = json("catalogo/catalogo.json")
#let presets = datos.presets

// Una llamada representativa de cada preset, copiada de su demo: la que
// genera la primera lámina, o la más reconocible. Al añadir un preset,
// añade aquí su entrada (el script avisa si falta).
#let llamadas = (
  "cita-social": ```typ
#carteles.cita-social(
  [La constancia entrena al algoritmo… y a tu #highlight[audiencia].],
  [Luis Felipe Reyes de los Reyes], iniciales: "LR",
  estilo: "publicacion", usuario: "@luisreyes", verificado: true,
  fecha: "5 nov 2026", metricas: (comentarios: 48, "me-gusta": 12000),
  formato: (1080, 1350))
```,
  "bauhaus": ```typ
#carteles.bauhaus(
  [El calvinismo es simplemente la religión en su], [PUREZA.],
  formato: (1080, 1350), autor: [B. B. WARFIELD], fechas: [1851 – 1921],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?])
```,
  "carrusel-curvas": ```typ
#let ondas = curvas.campo("ondas", diapositivas: 5,
  color: rgb("#1d4ed8"), opacidad: 40%, semilla: 3)
#carrusel-slide("PRESUPOSICIONALISMO", label: [Cinco razones],
  n: 1, total: 5, fondo: ondas, theme: tema,
  title: [Por qué la fe razona],
  body: [Cinco razones para no dejar la razón en la puerta de la iglesia.])
```,
  "curvas": ```typ
#let c = curvas.campo("topo", diapositivas: 5,
  formato: (1080, 1080), color: rgb("#8fb8a4"), opacidad: 45%)
#page(width: 1080pt, height: 1080pt, margin: 0pt,
  fill: rgb("#10302a"), curvas.ventana(c, 0))  // 0 … 4: su ventana
```,
  "demostracion": ```typ
#carteles.demostracion((
  ([Creemos en Cristo porque es], (afirma: [racional]), [creer en él,]),
  ([no aunque sea], (niega: [racional.])),
), formato: sizes.instagram, autor: [B. B. Warfield], obra: [Apologética])
```,
  "escalera-deck": ```typ
#let fondo = curvas.campo("topo", diapositivas: 3, formato: (1920, 1080),
  color: rgb("#8fb8a4"), opacidad: 40%, semilla: 3)
#carteles.escalera(
  ([El calvinista es el hombre], (texto: [que ve a Dios], cuerpo: 96pt, peso: 600)),
  [detrás de todo.], formato: (1920, 1080), curvas: fondo, indice: 0,
  autor: [B. B. WARFIELD], obra: [La teología de Calvino])
```,
  "escalera": ```typ
#escalera((
  [No es la fe], (texto: [la que salva,], estilo: "italic"),
  (texto: [sino Cristo], cuerpo: 96pt, peso: 600),
  (texto: [por medio de ella;], color: "suave"),
), [que la recibe.], formato: (1080, 1080), alinear: left,
  autor: [B. B. WARFIELD], obra: [La teología de Calvino])
```,
  "esquela": ```typ
#carteles.esquela([Redención],
  anuncio: [Estamos asistiendo al lecho \ de muerte de una palabra.],
  duelo: [Y es triste presenciar la muerte \ de cualquier cosa valiosa.],
  autor: [B. B. Warfield], obra: [«Redentor» y «redención»])
```,
  "fleurones": ```typ
#fleurones.orla("celosia", ancho, alto, tinta)       // marco de 4 lados
#fleurones.cabecera(560pt, rojo, guarda: "cresteria")  // guarda horizontal
#fleurones.asterismo(70pt, crema, vineta: "flor")      // viñeta suelta
#fleurones.remate(110pt, rojo)
```,
  "folio": ```typ
#carteles.folio(
  [Solo el santo sabe qué es el pecado; solo el gozo que se pierde y
   luego se vuelve a encontrar se comprende plenamente.],
  glosa: ([Salmo], [51]), autor: [B. B. Warfield])
```,
  "gozne": ```typ
#gozne(
  [… la pecaminosidad de la raza#llamada(1), la satisfacción de
   Cristo#llamada(2), la justificación por la fe#llamada(3) …],
  [La \ imputación],
  ([La pecaminosidad \ de la raza], [La satisfacción \ de Cristo],
   [La justificación \ por la fe]),
  formato: (1600, 900), autor: [B. B. Warfield], obra: [La imputación])
```,
  "linea-tiempo": ```typ
#linea-tiempo((
  [Dios estableció su Iglesia en los días de Abraham y puso en ella a los hijos.],
  [Deben permanecer allí hasta que Él los saque.],
), formato: (1080, 1350), remate: [Él en ninguna parte los ha sacado.],
  origen: [Abraham · Génesis 17], fin: [Hoy],
  autor: [B. B. Warfield], obra: [La polémica del pedobautismo])
```,
  "mosaico": ```typ
#carteles.mosaico(variante: "c",   // "c", "u" o "u-inversa"
  autor: [B. B. Warfield], obra: [La imputación])
```,
  "orlas": ```typ
#carteles.cita-orlada(encabezado: [Magnalia Dei], autor: [Herman Bavinck],
  fuente: [Magnalia Dei, cap. I · El sumo bien], tema: "vino", tamano: 70pt,
)[El hombre es un enigma que solo halla su solución en Dios.]
// y carteles.pregunta-orlada, carteles.capitulo-orlado
```,
  "suizo-temas": ```typ
#carteles.suizo([El calvinismo es simplemente la religión en su], [PUREZA.],
  formato: sizes.instagram, autor: [B. B. WARFIELD], fechas: [1851 – 1921],
  etiqueta: [DEL ENSAYO], planteo: [¿Qué es el calvinismo?],
  tema: carteles.tema-desde-theme(theme.base))   // o un diccionario de roles
```,
  "suizo": ```typ
#carteles.suizo(
  [El que tiene entendimiento, calcule el número de la bestia. No pide cómputo, pide],
  [SABIDURÍA.], formato: sizes.instagram,
  autor: [B. B. WARFIELD], fechas: [1851 – 1921],
  etiqueta: [APOCALIPSIS 13:18], planteo: [¿Capacidad o entendimiento?])
```,
  "teselas": ```typ
#carteles.teselas(
  [El que tiene entendimiento, calcule el número de la bestia. …],
  etiqueta: [Apocalipsis 13:18], remate: [Sabiduría],
  autor: [B. B. Warfield])
```,
)

// Función principal, para el índice: la primera llamada de la entrada que
// no sea un ayudante (el campo de curvas, la página).
#let funcion(nombre) = {
  let l = llamadas.at(nombre, default: none)
  if l == none { return none }
  let todas = l.text.matches(regex("#(?:let [^=]+= )?([a-z][a-z.-]*)\(")).map(x => x.captures.at(0))
  let propias = todas.filter(f => f not in ("page", "curvas.campo"))
  if propias.len() > 0 { propias.first() } else if todas.len() > 0 { todas.first() } else { none }
}

// ── estilo ───────────────────────────────────────────────────
#let papel = rgb("#f7f5f0")
#let tinta = rgb("#1d1f22")
#let suave = rgb("#6b6f76")
#let filete = rgb("#d9d5cc")
#let acento = rgb("#b4532a")

#let total-laminas = presets.map(p => p.paginas.len()).sum()

#set document(title: "Instatypst — Catálogo de presets")
#set page(
  paper: "a4", flipped: true, margin: (x: 14mm, top: 16mm, bottom: 14mm), fill: papel,
  header: context if counter(page).get().first() > 1 {
    set text(size: 7.5pt, fill: suave, tracking: 0.06em)
    grid(columns: (1fr, auto), upper[Instatypst · Catálogo de presets], counter(page).display())
  },
)
#set text(font: ("Inter", "DM Sans"), size: 9pt, fill: tinta, lang: "es")
#set par(leading: 0.6em, spacing: 0.9em)
#show raw: set text(font: "DM Mono", size: 7.6pt)
#show raw.where(block: true): it => block(
  width: 100%, fill: white, stroke: 0.5pt + filete, inset: 8pt, radius: 2pt, it,
)
#show raw.where(block: false): it => box(
  fill: white, stroke: 0.4pt + filete, inset: (x: 2.5pt, y: 1.5pt), outset: (y: 1pt), radius: 1.5pt, it,
)
#show link: set text(fill: acento)

#let formatos(p) = {
  let vistos = ()
  for pg in p.paginas {
    let f = str(pg.ancho) + "×" + str(pg.alto)
    if f not in vistos { vistos.push(f) }
  }
  vistos
}

// ── portada e índice ─────────────────────────────────────────
#text(size: 30pt, weight: 700, tracking: -0.01em)[Catálogo de presets]
#v(-4pt)
#text(size: 11pt, fill: suave)[
  #presets.len() demos de `examples/presets/` · #total-laminas láminas ·
  miniaturas a #datos.ppi ppi
]
#v(6pt)
#block(width: 100%, inset: (y: 4pt))[
  Cada sección muestra todas las láminas que produce una demo, en su orden, con el formato en pt
  (= px de la imagen final). La llamada es una representativa, copiada de la demo; la demo completa
  está en el archivo indicado. Para regenerar el catálogo:
  #h(4pt) `python3 scripts/catalogo.py` #h(4pt) (con `--png` exporta también estas páginas a PNG;
  con nombres de preset, rehace solo esas miniaturas).
]
#v(8pt)

#table(
  columns: (auto, auto, auto, 1fr, auto),
  stroke: (x, y) => (bottom: if y == 0 { 0.8pt + tinta } else { 0.4pt + filete }),
  inset: (x: 6pt, y: 5.5pt),
  align: (x, y) => if x == 2 { right + horizon } else { left + horizon },
  table.header(
    ..([Preset], [Función], [Láminas], [Formatos], [Demo]).map(t => text(weight: 700, size: 8pt, t)),
  ),
  ..presets.map(p => (
    link(label("preset-" + p.nombre), text(weight: 600, p.nombre)),
    {
      let f = funcion(p.nombre)
      if f == none { text(fill: red)[sin llamada] } else { raw(f) }
    },
    str(p.paginas.len()),
    text(fill: suave, formatos(p).join(", ")),
    text(size: 7.5pt, fill: suave, raw(p.archivo)),
  )).flatten(),
)

// ── una sección por preset ───────────────────────────────────
#let miniatura(pg, i, alto) = box(inset: (right: 5mm, bottom: 4mm), {
  box(stroke: 0.5pt + filete, image(pg.png, height: alto))
  v(2pt, weak: true)
  text(size: 7pt, fill: suave)[#text(weight: 700, fill: tinta, str(i + 1)) · #pg.ancho×#pg.alto]
})

// Las descripciones vienen de los comentarios de cabecera: lo que va entre
// acentos graves sale como código; el resto, como texto literal.
#let comentario(s) = s.split("`").enumerate().map(((i, t)) => if calc.odd(i) { raw(t) } else { t }).join()

#let miniaturas(p, alto) = block(width: 100%, {
  set par(leading: 0pt, spacing: 0pt)
  for (i, pg) in p.paginas.enumerate() { miniatura(pg, i, alto) }
})

#for p in presets {
  pagebreak()
  let ficha = grid(
    columns: (1fr, 128mm), column-gutter: 8mm,
    {
      [#text(size: 20pt, weight: 700, p.nombre) #label("preset-" + p.nombre)]
      v(-6pt)
      text(fill: suave)[#raw(p.archivo) · #p.paginas.len() láminas]
      v(4pt)
      for par in p.descripcion { comentario(par); parbreak() }
    },
    {
      let l = llamadas.at(p.nombre, default: none)
      if l == none {
        block(width: 100%, inset: 8pt, stroke: 0.5pt + red, text(fill: red)[
          Sin llamada registrada: añádela al diccionario `llamadas` de `docs/catalogo.typ`.
        ])
      } else { l }
    },
  )
  // la ficha y el filete, en un bloque de medida exacta (sin espaciado suelto)
  let separacion = 10pt
  let cabecera = block(width: 100%, above: 0pt, below: separacion, {
    ficha
    v(8pt)
    line(length: 100%, stroke: 0.5pt + filete)
  })
  cabecera
  // La miniatura más alta con la que el preset entero cabe en su página;
  // si ni a la más baja cabe (curvas), sigue en la siguiente.
  layout(sitio => {
    let usado = measure(cabecera, width: sitio.width).height + separacion + 2pt
    let alturas = (56mm, 50mm, 44mm, 38mm, 32mm, 28mm)
    let alto = alturas.find(a => {
      usado + measure(miniaturas(p, a), width: sitio.width).height <= sitio.height
    })
    miniaturas(p, if alto == none { alturas.last() } else { alto })
  })
}
