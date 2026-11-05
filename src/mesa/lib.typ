// ─────────────────────────────────────────────────────────────
//  mesa — hoja suelta fotografiada sobre una mesa de madera
//  (viene del paquete DeskBook; en Instatypst: `mesa`)
//
//  Cada página es el lienzo de una foto: madera a sangre, una hoja de papel
//  con grano, el corte irregular, un poco de trapecio y de curvatura, luz
//  de ventana y viñeteo. La hoja sigue una convención de papel (a5 por
//  defecto); el lienzo sale de ella y de la cámara (camara.typ), de modo
//  que 10 cm no encuadra lo mismo que 25 o 60.
//
//  DOS MODOS, según si el texto fluye o no:
//
//    #show: mesa.vertical.with(...)      el texto FLUYE por varias hojas;
//    #show: mesa.apaisada.with(...)      el papel gira, el texto queda recto
//    #show: mesa.cuadrada.with(...)      (el margen crece lo justo para que
//                                        nunca se salga del papel torcido)
//
//    #mesa.hoja-vertical[…]              UNA página, y el texto gira con la
//    #mesa.hoja-apaisada[…]              hoja, como en una foto de verdad
//    #mesa.hoja-cuadrada[…]              (no fluye: lo que no cabe se sale)
//    #mesa.portada-vertical(title: […])[…]   una hoja con título, subtítulo, autor
//    #mesa.portada-apaisada(…)[…]
//
//  PIEZAS SUELTAS (dentro de una hoja):
//    mesa.nota[…]                        una notita torcida sobre la hoja
//    mesa.lamina(image("cartel.png"))    una lámina impresa sobre la hoja:
//                                        mesa.lamina(contenido, ancho:, angle:, borde:)
//
//  COLOR Y TIPO:
//    tema:     nombre del registro (`mesa.temas`), diccionario parcial con los
//              roles de un tema de lámina (fondo, tinta, suave, acento, linea,
//              + borde, titulo, codigo…) o `mesa.tema-desde-theme(theme.base)`
//    fuentes:  auto (IM Fell), o (cuerpo:, titulo:, versalitas:, mono:), o las
//              de un theme: `fuentes: theme.base.fonts` (body → cuerpo,
//              display → título)
//
//  `wood:` acepta bytes (`read("mi-mesa.jpg", encoding: none)`) o none (la de
//  fábrica, que vive en el repositorio y no en el paquete publicado: ahí hay
//  que pasar `wood:`). Una ruta en texto se leería respecto a ESTE archivo.
// ─────────────────────────────────────────────────────────────

#import "camara.typ": compute-camera, medida-papel, margen-mesa
#import "_papel.typ": dibujar-papel
#import "_estilo.typ": estilo-libro, resolver-tema-mesa, resolver-fuentes, temas-mesa
#import "../carteles/_temas.typ": tema-desde-theme

// Las maderas de fábrica: rutas (no `read`), para que importar `mesa` no falle
// en el paquete publicado, que no las trae (typst.toml las excluye: viven en
// el repositorio). Sin ellas hay que pasar `wood:` con bytes. Cada una trae su
// versión suave, para cuando la cámara está lejos.
#let _maderas = (
  vertical: (nitida: "assets/table1.jpg", suave: "assets/table1-suave.jpg"),
  horizontal: (nitida: "assets/table-h.jpg", suave: "assets/table-h-suave.jpg"),
)

// ── los parámetros de las hojas (uno solo; las seis funciones lo comparten) ──
#let _defecto = (
  wood: none,                      // none = la de fábrica; o bytes
  desenfoque: auto,                // auto = suave si la cámara está a más de 50 cm; true / false
  paper-size: "a5",                // la hoja interna: a3 · a4 · a5 · a6 · letter · (ancho, alto)
  margin: (x: 14mm, y: 14mm),      // mesa que sobra alrededor de la hoja base
  inset: (x: 16mm, y: 13mm),       // aire entre el borde de la hoja y el texto
  angle: 0.55deg,                  // inclinación de la hoja
  tema: "mesa",
  fuentes: auto,
  paper: auto,                     // color del papel; auto = el del tema
  paper-stroke: auto,              // borde del papel; auto = el del tema
  text-size: 11pt,
  leading: 0.68em,
  escalar-texto: true,             // el texto se achica con la hoja cuando la cámara se aleja
  vignette: true,
  luz: 45deg,                      // hacia dónde viaja la luz (0deg →, 90deg ↓)
  curvatura: 0.5,                  // 0–1: la banda de sombra del alabeo
  grano: 0.6,                      // 0–1: grano y manchas del papel
  borde: 0.3,                      // 0–1: irregularidad del corte
  semilla: 3,                      // cambia el dibujo del grano y del corte
  focal-length: 50mm,              // 24 mm gran angular · 50 mm normal · 85 mm retrato
  distance: 250mm,                 // Z: 100 mm = 10 cm (hoja grande) … 600 mm = 60 cm (pequeña)
  sensor-size: 36mm,
)

// Lee los parámetros nombrados y avisa de los que no existen.
#let _parametros(quien, nombrados) = {
  for k in nombrados.keys() {
    if k not in _defecto {
      panic(quien + ": parámetro desconocido `" + k + "` — válidos: " + _defecto.keys().join(", "))
    }
  }
  _defecto + nombrados
}

// La hoja base según la orientación, en (ancho, alto).
#let _dims(orientacion, paper-size) = {
  let (w, h) = medida-papel(paper-size)
  let (corto, largo) = (calc.min(w, h), calc.max(w, h))
  if orientacion == "vertical" { (corto, largo) }
  else if orientacion == "apaisada" { (largo, corto) }
  else { (corto, corto) }
}

// Toda la geometría de una hoja, calculada una sola vez.
#let _geometria(orientacion, a) = {
  let base = _dims(orientacion, a.paper-size)
  let cam = compute-camera(
    focal-length: a.focal-length, distance: a.distance, sensor-size: a.sensor-size,
    paper: base, angle: a.angle, margin: a.margin,
  )
  let s = cam.scale
  let k = cam.perspective
  let (vw, vh) = (base.at(0) * s, base.at(1) * s)   // la hoja visible; vw es el ancho medio
  let ins = margen-mesa(a.inset)
  let (ix, iy) = (ins.x * s, ins.y * s)
  // medio ancho útil, por el borde superior (el más corto) y medio alto útil
  let (hx, hy) = (vw * (1 - k) / 2 - ix, vh / 2 - iy)
  // Con la hoja rotada, el texto recto cabe en un rectángulo (tx, ty) tal que
  // sus esquinas queden a `inset` del borde torcido:
  //   tx·cos + ty·sin = hx ,  tx·sin + ty·cos = hy
  let c = calc.abs(calc.cos(a.angle))
  let sn = calc.abs(calc.sin(a.angle))
  let det = c * c - sn * sn
  let (tx, ty) = ((hx * c - hy * sn) / det, (hy * c - hx * sn) / det)
  (
    cam: cam, vw: vw, vh: vh, k: k, s: s,
    crop: (cam.crop-width, cam.crop-height),
    // el recto de texto en una página que fluye
    margen: (x: cam.crop-width / 2 - tx, y: cam.crop-height / 2 - ty),
    // el recto de texto cuando gira con la hoja
    caja: (2 * hx, 2 * hy),
    tam: if a.escalar-texto { a.text-size * s } else { a.text-size },
  )
}

// El fondo de la foto: madera, viñeteo y la hoja.
#let _fondo(orientacion, a, g, c) = {
  let m = _maderas.at(if orientacion == "apaisada" { "horizontal" } else { "vertical" })
  let suave = if a.desenfoque == auto { g.cam.blur > 0mm } else { a.desenfoque }
  let foto = if a.wood != none { a.wood } else if suave { m.suave } else { m.nitida }
  {
    place(top + left, image(foto, width: 100%, height: 100%, fit: "cover"))
    if a.vignette {
      place(top + left, rect(width: 100%, height: 100%, fill: gradient.radial(
        center: (50%, 50%), radius: 85%, focal-center: (50%, 50%), focal-radius: 12%,
        rgb("#00000000"), rgb("#00000000"), rgb("#1a120800"), rgb("#0f0a00aa"),
      )))
      // la luz de la ventana, en la dirección `luz`
      place(top + left, rect(width: 100%, height: 100%, fill: gradient.linear(
        rgb("#ffffff12"), rgb("#00000000"), rgb("#00000026"), angle: a.luz,
      )))
    }
    place(center + horizon, rotate(a.angle, dibujar-papel(
      g.vw, g.vh,
      papel: if a.paper == auto { c.fondo } else { a.paper },
      trazo: if a.paper-stroke == auto { c.borde } else { a.paper-stroke },
      perspectiva: g.k,
      // la luz se da respecto de la foto: en el marco de la hoja gira con ella
      luz: a.luz - a.angle,
      curvatura: a.curvatura, grano: a.grano, borde: a.borde, semilla: a.semilla,
    )))
  }
}

// ── el texto fluye: un `show` por orientación ──
#let _fluye(orientacion, quien, args) = {
  let a = _parametros(quien, args.named())
  let g = _geometria(orientacion, a)
  let c = resolver-tema-mesa(a.tema)
  let f = resolver-fuentes(a.fuentes)
  set page(
    width: g.crop.at(0), height: g.crop.at(1),
    margin: (x: g.margen.x, y: g.margen.y),
    background: _fondo(orientacion, a, g, c),
    numbering: none,
  )
  show: estilo-libro.with(c, f, g.tam, a.leading)
  args.pos().first()
}

#let vertical(..args) = _fluye("vertical", "mesa.vertical", args)
#let apaisada(..args) = _fluye("apaisada", "mesa.apaisada", args)
#let cuadrada(..args) = _fluye("cuadrada", "mesa.cuadrada", args)

// ── una página: el texto gira con la hoja ──
#let _hoja(orientacion, quien, nombrados, cuerpo, centrado: false) = {
  let a = _parametros(quien, nombrados)
  let g = _geometria(orientacion, a)
  let c = resolver-tema-mesa(a.tema)
  let f = resolver-fuentes(a.fuentes)
  page(
    width: g.crop.at(0), height: g.crop.at(1), margin: 0pt, numbering: none,
    background: _fondo(orientacion, a, g, c),
    {
      show: estilo-libro.with(c, f, g.tam, a.leading)
      place(center + horizon, rotate(a.angle, box(
        width: g.caja.at(0), height: g.caja.at(1),
        if centrado { align(center + horizon, cuerpo) } else { align(start + top, cuerpo) },
      )))
    },
  )
}

#let hoja-vertical(..args) = _hoja("vertical", "mesa.hoja-vertical", args.named(), args.pos().first())
#let hoja-apaisada(..args) = _hoja("apaisada", "mesa.hoja-apaisada", args.named(), args.pos().first())
#let hoja-cuadrada(..args) = _hoja("cuadrada", "mesa.hoja-cuadrada", args.named(), args.pos().first())

// ── portada: título, subtítulo y autor centrados en una hoja ──
#let _portada(orientacion, quien, args) = {
  let n = args.named()
  let propios = ("title", "subtitle", "author")
  let resto = n.pairs().filter(p => p.first() not in propios).to-dict()
  let a = _parametros(quien, resto)
  let c = resolver-tema-mesa(a.tema)
  let f = resolver-fuentes(a.fuentes)
  let (title, subtitle, author) = (n.at("title", default: none), n.at("subtitle", default: none), n.at("author", default: none))
  let cuerpo = args.pos().at(0, default: none)
  let contenido = {
    set par(first-line-indent: 0em, justify: false)
    if title != none {
      text(size: 2.4em, font: f.titulo, fill: c.titulo, title)
      v(0.7em)
    }
    if subtitle != none {
      text(size: 1.05em, fill: c.suave, style: "italic", font: f.titulo, subtitle)
      v(1.3em)
    }
    if author != none {
      line(length: 30%, stroke: (paint: c.linea, thickness: 0.6pt))
      v(0.9em)
      text(size: 0.9em, fill: c.suave, font: f.versalitas, smallcaps(author))
    }
    if cuerpo != none {
      v(1.3em)
      text(size: 0.9em, fill: c.suave, cuerpo)
    }
  }
  _hoja(orientacion, quien, resto, contenido, centrado: true)
}

#let portada-vertical(..args) = _portada("vertical", "mesa.portada-vertical", args)
#let portada-apaisada(..args) = _portada("apaisada", "mesa.portada-apaisada", args)

// ── piezas sueltas ──

// Una notita torcida, sin sombra.
#let nota(angle: -0.7deg, inset: 0.9em, radius: 0pt, tema: "mesa", paper: auto, body) = {
  let c = resolver-tema-mesa(tema)
  rotate(angle, rect(
    width: 100%, inset: inset, radius: radius,
    fill: if paper == auto { c.fondo.lighten(40%) } else { paper },
    stroke: (paint: c.borde, thickness: 0.5pt),
    body,
  ))
}

// Una lámina impresa (una imagen, o cualquier contenido) sobre la hoja: un
// borde de papel fotográfico y una leve inclinación.
#let lamina(contenido, ancho: 100%, angle: 0.4deg, borde: 1.6mm, papel: rgb("#fcfaf4"), linea: rgb("#d9d2c0")) = {
  align(center, rotate(angle, block(
    width: ancho, fill: papel, inset: borde, stroke: (paint: linea, thickness: 0.5pt),
    { set image(width: 100%); contenido },
  )))
}

// La cámara, por si se quiere el encuadre sin la hoja.
#let camara = compute-camera
#let temas = temas-mesa
