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
//  Si cambia la firma de un preset, cambia AQUÍ en el mismo commit. Hay
//  un test en tests/firmas.typ que comprueba la coherencia interna.
// ─────────────────────────────────────────────────────────────

#let firmas = (
  liso: (
    pos: ("texto",),
    formato: (1080, 1350),
    tema: none,
    archivo: "carteles.typ",
    uso: "Un párrafo o frase sobre fondo liso",
    campo: (texto: "texto", autor: "autor", marca: "marca"),
    compuesto: false,
  ),
  suizo: (
    pos: ("frase", "remate"),
    formato: (1080, 1350),
    tema: "suizo",
    archivo: "carteles.typ",
    uso: "Frase + remate, estilo editorial sobre retícula",
    campo: (texto: "frase", remate: "remate", autor: "autor", fondo: "papel"),
    compuesto: false,
  ),
  demostracion: (
    pos: ("grupos",),
    formato: (1080, 1080),
    tema: "demostracion",
    archivo: "carteles.typ",
    uso: "La cita como demostración numerada, en pizarra",
    campo: (texto: "grupos", autor: "autor", obra: "obra"),
    compuesto: true,
  ),
  bauhaus: (
    pos: ("frase", "remate"),
    formato: (1080, 1350),
    tema: "bauhaus",
    archivo: "carteles/bauhaus.typ",
    uso: "Portada geométrica",
    campo: (texto: "frase", remate: "remate", autor: "autor", etiqueta: "etiqueta"),
    compuesto: false,
  ),
  mosaico: (
    pos: (),
    formato: (1080, 1350),
    tema: "mosaico",
    archivo: "carteles/mosaico.typ",
    uso: "Portada geométrica de teselas (todo por nombre)",
    campo: (texto: "frase", remate: "remate", autor: "autor", obra: "obra"),
    compuesto: false,
  ),
  teselas: (
    pos: ("frase",),
    formato: (1080, 1350),
    tema: "teselas",
    archivo: "carteles/teselas.typ",
    uso: "Portada geométrica de mosaico regular",
    campo: (texto: "frase", remate: "remate", autor: "autor"),
    compuesto: false,
  ),
  hojas: (
    pos: ("titulo",),
    formato: (1080, 1350),
    tema: "hojas",
    archivo: "carteles/hojas.typ",
    uso: "Portada geométrica de hojas",
    campo: (titulo: "titulo", texto: "frase", pie: "pie"),
    compuesto: false,
  ),
  franjas: (
    pos: ("cita",),
    formato: (1080, 1080), // el único que no es 1080×1350: ver CHANGELOG
    tema: "franjas",
    archivo: "carteles/franjas.typ",
    uso: "Cita con cabecera de marca, título e ilustración bajo un velo",
    campo: (texto: "cita", titulo: "titulo", imagen: "imagen", pie: "pie"),
    compuesto: false,
  ),
  epigrafe: (
    pos: ("cita",),
    formato: (1080, 1350),
    tema: "auto",
    archivo: "carteles/epigrafe.typ",
    uso: "Epígrafe con quince estilos",
    campo: (texto: "cita", autor: "autor", obra: "obra"),
    compuesto: false,
  ),
  "cita-social": (
    pos: ("cita", "nombre"),
    formato: (1080, 1350),
    tema: "cita-social",
    archivo: "carteles/cita-social.typ",
    uso: "Cita con aspecto de publicación, mensaje o editorial",
    campo: (texto: "cita", autor: "nombre"),
    compuesto: false,
  ),
  escalera: (
    pos: ("peldanos", "climax"),
    formato: (1080, 1920),
    tema: "escalera",
    archivo: "escalera.typ",
    uso: "La frase baja en peldaños hasta un clímax",
    campo: (texto: "peldanos", remate: "climax", autor: "autor", obra: "obra"),
    compuesto: true,
  ),
  gozne: (
    pos: ("cita", "centro", "hojas"),
    formato: (1600, 900),
    tema: "gozne",
    archivo: "gozne.typ",
    uso: "Cita con llamadas y diagrama radial",
    campo: (texto: "cita", autor: "autor", obra: "obra"),
    compuesto: true,
  ),
  "linea-tiempo": (
    pos: ("estaciones",),
    formato: (1080, 1350),
    tema: "linea-tiempo",
    archivo: "linea-tiempo.typ",
    uso: "Estaciones sobre una línea vertical",
    campo: (texto: "estaciones", remate: "remate", autor: "autor"),
    compuesto: true,
  ),
  esquela: (
    pos: ("nombre",),
    formato: (1080, 1350),
    tema: "esquela",
    archivo: "esquela.typ",
    uso: "Aviso fúnebre de imprenta",
    campo: (titulo: "nombre", texto: "anuncio", autor: "autor", obra: "obra"),
    compuesto: false,
  ),
  folio: (
    pos: ("texto",),
    formato: (1080, 1080),
    tema: "folio",
    archivo: "folio.typ",
    uso: "Folio con capitular rubricada y glosa",
    campo: (texto: "texto", glosa: "glosa", autor: "autor"),
    compuesto: false,
  ),
  plano: (
    pos: ("texto",),
    formato: (1080, 1350),
    tema: none,
    archivo: "plano.typ",
    uso: "Grid blueprint con cota y cajetín",
    campo: (texto: "texto", autor: "autor", obra: "obra", fondo: "fondo"),
    compuesto: false,
  ),
  "cita-orlada": (
    pos: ("texto",),
    formato: (1080, 1080),
    tema: "vino",
    archivo: "orlas.typ",
    uso: "Cita dentro de una orla tipográfica",
    campo: (texto: "texto", autor: "autor", obra: "obra"),
    compuesto: false,
  ),
  "capitulo-orlado": (
    pos: ("numero", "titulo"),
    formato: (1080, 1080),
    tema: "vino",
    archivo: "orlas.typ",
    uso: "Cabecera de capítulo dentro de una orla",
    campo: (titulo: "titulo", autor: "autor", obra: "obra"),
    compuesto: false,
  ),
  "pregunta-orlada": (
    pos: ("texto",),
    formato: (1080, 1080),
    tema: "papel",
    archivo: "orlas.typ",
    uso: "Pregunta para la reflexión dentro de una orla",
    campo: (texto: "texto", pista: "pista", obra: "obra"),
    compuesto: false,
  ),
)
