// ─────────────────────────────────────────────────────────────
//  carteles/firmas.typ — tabla de firmas de los presets
//
//  FUENTE ÚNICA DE VERDAD para cómo se llama cada preset. La consumen
//  `carteles.hacer()` (fachada), el MCP (`firmas` / `firmas_json`) y la
//  CLI de typst-rrss en lugar de su tabla `POSICIONALES` hardcodeada.
//
//  Contrato de cada entrada:
//    pos       array   nombres de los argumentos posicionales, EN ORDEN
//                      (los que van antes del primer parámetro con default)
//    formato   array   formato por defecto, como (ancho, alto) en px
//    tema      cadena  nombre del tema por defecto; none = el preset no
//                      expone `tema:`; "auto" = lo resuelve él solo
//    archivo   cadena  archivo de src/ donde está definida la función
//    uso       cadena  una línea: para qué sirve el preset
//    campo     dict    nombres canónicos -> nombre real del parámetro.
//                      Solo los mappings inequívocos; lo demás se decide
//                      en la fachada según `compuesto`.
//    compuesto bool    true cuando los posicionales son datos estructurados
//                      (arrays de grupos, peldaños, estaciones…) y no texto
//                      directo: la fachada no debe coaccionarlos a markup.
//
//    bloques   dict    qué bloques de contenido acepta (ver `bloques-catalogo`):
//                      requeridos  deben estar; un elemento-array es «uno de»
//                                  (p. ej. ("quote", "body"): cualquiera de los dos)
//                      opcionales  pueden estar; el resto, no los acepta
//    entradas  dict    cómo se reparte una pieza en los parámetros del preset:
//                      bloque -> nombre del parámetro (un texto), o
//                      bloque -> (campo: parámetro) para los que tienen campos
//                      (attribution: author/work/date, date: day/month,
//                      number: value/total, contrast: left/right,
//                      epigraph: text/source).
//                      Un bloque con entrada PROPIA no cae en el de su
//                      cadena: `liso` tiene `epigraph`, así que su epígrafe
//                      va aparte del texto; en un preset sin ella, un
//                      epígrafe se dibuja como el `body`.
//                      Va en el bloque más general de la cadena de parentesco:
//                      `body` recoge también quote, epigraph y verse.
//                      `variante` nombra el parámetro de la variante del estilo.
//                      Un preset sin `entradas` aún no se puede construir
//                      desde una pieza (sí a mano).
//
//    marca-funcion  bool  (opcional) true si `marca:` acepta, además de un contenido,
//                      una función (color, lienzo) -> contenido, que el preset
//                      llama con su propia tinta (ver marca.typ). Sin esto, el
//                      preset solo sabe colocar un contenido ya hecho.
//
//  Las opciones propias de cada preset (margen, cuerpo, orla…) NO se escriben
//  aquí: `scripts/exportar-firmas.py` las deriva de los parámetros con nombre
//  de su función y las publica como `options` en schema/firmas.json.
//
//  Si cambia la firma de un preset, cambia AQUÍ en el mismo commit. Hay
//  un test en tests/firmas.typ que comprueba la coherencia interna.
// ─────────────────────────────────────────────────────────────

// Catálogo de bloques de contenido del contrato (instatypst-piece/v1).
#let bloques-catalogo = (
  "title", "subtitle",
  "label",   // rótulo corto: marca un quiebre, el inicio de un arco interno o enfatiza una idea;
             // puede aparecer varias veces (los demás bloques de texto son únicos)
  "body", "quote", "epigraph", "verse",
  "conclusion", "attribution", "list", "contrast", "signature",
  "footer",  // línea de cierre bajo el contenido (pie, coda, pista)
  "number",  // numeral propio (p. ej. el capítulo); `total` opcional para «3 / 8»
  "date",    // fecha de evento: día y mes
)

// Parentesco entre bloques: «X es un caso de Y». Un estilo que acepta Y acepta
// X (lo dibuja como Y, salvo que declare saber más). Cadena: verse → quote → body.
//   verse     una cita que conserva sus cortes de línea y NO se alinea ni se
//             justifica con el resto del estilo: la alineación es la suya
#let bloques-padre = (
  verse: "quote",
  epigraph: "quote",
  quote: "body",
)

#let firmas = (
  liso: (
    pos: ("texto",),
    formato: (1080, 1350),
    tema: none,
    archivo: "carteles.typ",
    uso: "Un párrafo o frase sobre fondo liso",
    campo: (texto: "texto", autor: "autor", marca: "marca"),
    compuesto: false,
    bloques: (requeridos: ("body",), opcionales: ("epigraph", "attribution", "signature")),
    entradas: (body: "texto", epigraph: (text: "epigrafe", source: "epigrafe-fuente"), attribution: (author: "autor"), signature: "marca"),
    marca-funcion: true,
  ),
  suizo: (
    pos: ("frase", "remate"),
    formato: (1080, 1350),
    tema: "suizo",
    archivo: "carteles.typ",
    uso: "Frase + remate, estilo editorial sobre retícula",
    campo: (texto: "frase", remate: "remate", autor: "autor", fondo: "papel"),
    compuesto: false,
    bloques: (requeridos: ("title", "conclusion"), opcionales: ("label", "subtitle", "attribution", "signature")),
    entradas: (title: "frase", conclusion: "remate", label: "etiqueta", subtitle: "planteo", attribution: (author: "autor", date: "fechas"), signature: "marca"),
    marca-funcion: true,
  ),
  demostracion: (
    pos: ("grupos",),
    formato: (1080, 1080),
    tema: "demostracion",
    archivo: "carteles.typ",
    uso: "La cita como demostración numerada, en pizarra",
    campo: (texto: "grupos", autor: "autor", obra: "obra"),
    compuesto: true,
    bloques: (requeridos: ("list",), opcionales: ("attribution", "signature")),
  ),
  bauhaus: (
    pos: ("frase", "remate"),
    formato: (1080, 1350),
    tema: "bauhaus",
    archivo: "carteles/bauhaus.typ",
    uso: "Portada geométrica",
    campo: (texto: "frase", remate: "remate", autor: "autor", etiqueta: "etiqueta"),
    compuesto: false,
    bloques: (requeridos: ("title", "conclusion"), opcionales: ("label", "subtitle", "attribution", "signature")),
    entradas: (title: "frase", conclusion: "remate", label: "etiqueta", subtitle: "planteo", attribution: (author: "autor", date: "fechas"), signature: "marca"),
    marca-funcion: true,
  ),
  mosaico: (
    pos: (),
    formato: (1080, 1350),
    tema: "mosaico",
    archivo: "carteles/mosaico.typ",
    uso: "Portada geométrica de teselas (todo por nombre)",
    campo: (texto: "frase", remate: "remate", autor: "autor", obra: "obra"),
    compuesto: false,
    bloques: (requeridos: (), opcionales: ("title", "conclusion", "label", "attribution", "signature")),
  ),
  teselas: (
    pos: ("frase",),
    formato: (1080, 1350),
    tema: "teselas",
    archivo: "carteles/teselas.typ",
    uso: "Portada geométrica de mosaico regular",
    campo: (texto: "frase", remate: "remate", autor: "autor"),
    compuesto: false,
    bloques: (requeridos: ("title",), opcionales: ("conclusion", "label", "attribution", "signature")),
  ),
  hojas: (
    pos: ("titulo",),
    formato: (1080, 1350),
    tema: "hojas",
    archivo: "carteles/hojas.typ",
    uso: "Portada geométrica de hojas",
    campo: (titulo: "titulo", texto: "frase", pie: "pie"),
    compuesto: false,
    bloques: (requeridos: ("title",), opcionales: ("subtitle", "label", "body", "footer", "signature")),
  ),
  franjas: (
    pos: ("cita",),
    formato: (1080, 1080), // el único que no es 1080×1350: ver CHANGELOG
    tema: "franjas",
    archivo: "carteles/franjas.typ",
    uso: "Cita con cabecera de marca, título e ilustración bajo un velo",
    campo: (texto: "cita", titulo: "titulo", imagen: "imagen", pie: "pie"),
    compuesto: false,
    bloques: (requeridos: (("quote", "body"),), opcionales: ("title", "footer", "signature")),
  ),
  epigrafe: (
    pos: ("cita",),
    formato: (1080, 1350),
    tema: "auto",
    archivo: "carteles/epigrafe.typ",
    uso: "Epígrafe con quince estilos",
    campo: (texto: "cita", autor: "autor", obra: "obra"),
    compuesto: false,
    bloques: (requeridos: (("epigraph", "quote", "body"),), opcionales: ("attribution", "signature")),
    entradas: (body: "cita", attribution: (author: "autor", work: "obra"), signature: "marca", variante: "estilo"),
  ),
  "cita-social": (
    pos: ("cita", "nombre"),
    formato: (1080, 1350),
    tema: "cita-social",
    archivo: "carteles/cita-social.typ",
    uso: "Cita con aspecto de publicación, mensaje o editorial",
    campo: (texto: "cita", autor: "nombre"),
    compuesto: false,
    bloques: (requeridos: (("quote", "body"), "attribution"), opcionales: ("signature",)),
  ),
  escalera: (
    pos: ("peldanos", "climax"),
    formato: (1080, 1920),
    tema: "escalera",
    archivo: "escalera.typ",
    uso: "La frase baja en peldaños hasta un clímax",
    campo: (texto: "peldanos", remate: "climax", autor: "autor", obra: "obra"),
    compuesto: true,
    bloques: (requeridos: ("list", "conclusion"), opcionales: ("footer", "attribution", "signature")),
  ),
  gozne: (
    pos: ("cita", "centro", "hojas"),
    formato: (1600, 900),
    tema: "gozne",
    archivo: "gozne.typ",
    uso: "Cita con llamadas y diagrama radial",
    campo: (texto: "cita", autor: "autor", obra: "obra"),
    compuesto: true,
    bloques: (requeridos: (("quote", "body"), "title", "list"), opcionales: ("attribution", "signature")),
  ),
  "linea-tiempo": (
    pos: ("estaciones",),
    formato: (1080, 1350),
    tema: "linea-tiempo",
    archivo: "linea-tiempo.typ",
    uso: "Estaciones sobre una línea vertical",
    campo: (texto: "estaciones", remate: "remate", autor: "autor"),
    compuesto: true,
    bloques: (requeridos: ("list",), opcionales: ("footer", "attribution", "signature")),
  ),
  esquela: (
    pos: ("nombre",),
    formato: (1080, 1350),
    tema: "esquela",
    archivo: "esquela.typ",
    uso: "Aviso fúnebre de imprenta",
    campo: (titulo: "nombre", texto: "anuncio", autor: "autor", obra: "obra"),
    compuesto: false,
    bloques: (requeridos: ("title",), opcionales: ("subtitle", "body", "attribution", "signature")),
    entradas: (title: "nombre", subtitle: "anuncio", body: "duelo", attribution: (author: "autor", work: "obra"), signature: "marca"),
    marca-funcion: true,
  ),
  folio: (
    pos: ("texto",),
    formato: (1080, 1080),
    tema: "folio",
    archivo: "folio.typ",
    uso: "Folio con capitular rubricada y glosa",
    campo: (texto: "texto", glosa: "glosa", autor: "autor"),
    compuesto: false,
    bloques: (requeridos: ("body",), opcionales: ("label", "attribution", "signature")),
  ),
  plano: (
    pos: ("texto",),
    formato: (1080, 1350),
    tema: none,
    archivo: "plano.typ",
    uso: "Grid blueprint con cota y cajetín",
    campo: (texto: "texto", autor: "autor", obra: "obra", fondo: "fondo"),
    compuesto: false,
    bloques: (requeridos: ("body",), opcionales: ("conclusion", "attribution", "signature")),
  ),
  "cita-orlada": (
    pos: ("texto",),
    formato: (1080, 1080),
    tema: "vino",
    archivo: "orlas.typ",
    uso: "Cita dentro de una orla tipográfica",
    campo: (texto: "texto", autor: "autor", obra: "obra"),
    compuesto: false,
    bloques: (requeridos: (("quote", "body"),), opcionales: ("label", "attribution", "signature")),
  ),
  contraste: (
    pos: ("izquierda", "derecha"),
    formato: (1080, 1350),
    tema: "contraste",
    archivo: "contraste.typ",
    uso: "Dos lados enfrentados (antes/después, ley/evangelio) en paneles tintados",
    campo: (titulo: "titulo", autor: "autor", obra: "obra"),
    compuesto: true,
    bloques: (requeridos: ("contrast",), opcionales: ("title", "attribution", "signature")),
    entradas: (contrast: (left: "izquierda", right: "derecha"), title: "titulo", attribution: (author: "autor", work: "obra"), signature: "marca"),
    marca-funcion: true,
  ),
  evento: (
    pos: ("dia", "mes", "titulo"),
    formato: (1080, 1350),
    tema: "evento",
    archivo: "evento.typ",
    uso: "La fecha como protagonista, con título, detalle y llamada a la acción",
    campo: (titulo: "titulo"),
    compuesto: false,
    bloques: (requeridos: ("date", "title"), opcionales: ("label", "body", "footer", "signature")),
    entradas: (date: (day: "dia", month: "mes"), title: "titulo", label: "etiqueta", body: "detalle", footer: "llamada", signature: "marca"),
    marca-funcion: true,
  ),
  consejo: (
    pos: ("numero", "titulo"),
    formato: (1080, 1350),
    tema: "consejo",
    archivo: "consejo.typ",
    uso: "Un color sólido y un numeral gigante: un consejo, un paso, una razón",
    campo: (titulo: "titulo", texto: "texto"),
    compuesto: false,
    bloques: (requeridos: ("number", "title"), opcionales: ("label", "body", "signature")),
    entradas: (number: (value: "numero"), title: "titulo", label: "etiqueta", body: "texto", signature: "marca"),
    marca-funcion: true,
  ),
  lamina: (
    pos: ("numero", "total", "titulo"),
    formato: (1080, 1350),
    tema: "lamina",
    archivo: "lamina.typ",
    uso: "Una página de una serie numerada: progreso segmentado, «3 / 8», título y texto",
    campo: (titulo: "titulo", texto: "texto"),
    compuesto: false,
    bloques: (requeridos: ("number", "title"), opcionales: ("body", "footer", "signature")),
    entradas: (number: (value: "numero", total: "total"), title: "titulo", body: "texto", footer: "siguiente", signature: "marca"),
    marca-funcion: true,
  ),
  "capitulo-orlado": (
    pos: ("numero", "titulo"),
    formato: (1080, 1080),
    tema: "vino",
    archivo: "orlas.typ",
    uso: "Cabecera de capítulo dentro de una orla",
    campo: (titulo: "titulo", autor: "autor", obra: "obra"),
    compuesto: false,
    bloques: (requeridos: ("number", "title"), opcionales: ("subtitle", "label", "attribution", "signature")),
  ),
  "pregunta-orlada": (
    pos: ("texto",),
    formato: (1080, 1080),
    tema: "papel",
    archivo: "orlas.typ",
    uso: "Pregunta para la reflexión dentro de una orla",
    campo: (texto: "texto", pista: "pista", obra: "obra"),
    compuesto: false,
    bloques: (requeridos: (("body", "quote"),), opcionales: ("label", "footer", "attribution", "signature")),
  ),
)
