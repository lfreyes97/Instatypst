// ─────────────────────────────────────────────────────────────
//  carteles/_epigrafes-b.typ — cinco estilos geométricos de epígrafe
//
//  Cartel de una cita breve con su autor y su obra. En los cinco el arte de
//  los presets geométricos del paquete queda al margen y la cita manda:
//
//    hojas    la flor de cuatro hojas (_hojas-piezas.typ) como firma pequeña
//             junto al autor; la cita, un bloque pesado de sans (Poppins 800)
//             que llena la caja de arriba.
//    bauhaus  cuadrado, círculo, cuña y barra apoyados en una línea de tierra
//             (la construcción de carteles.bauhaus); bajo la tierra, la cita
//             en columna (Jost) y el autor en la columna estrecha de al lado.
//    arcos    los arcos paralelos de mosaico (_arcos.typ) como un sol naciente
//             en una banda del 40 % de arriba; la cita, centrada en serif
//             (Fraunces), en el resto.
//    malla    retícula suiza de módulos casi cuadrados con una sola celda de
//             color que lleva el autor; la cita grande en bandera izquierda
//             (Hanken Grotesk) sobre las filas de arriba.
//    lineas   fondo liso, un solo filete grueso que sangra por la izquierda y
//             la cita en un cuerpo enorme de Bodoni, apoyada abajo.
//
//  Contrato común (para el despachador `carteles.epigrafe`):
//    estilos-b.<nombre>(cita, autor: none, obra: none, formato: (1080, 1350),
//                       tema: auto, marca: none, guias: false) -> página
//  `cita` es contenido (admite `\`), `tema` es un nombre de `temas-lamina`
//  o de los temas propios de este archivo, un diccionario de roles (fondo,
//  tinta, suave, acento, más los extras de cada estilo) o `auto` (el tema
//  propio del estilo). La cita se achica hasta caber en su caja; si ni con
//  el cuerpo mínimo legible (34 px en un lado menor de 1080) cabe, error.
//
//  Privado de `carteles/`.
// ─────────────────────────────────────────────────────────────

//  Este archivo guarda lo común de la tanda; cada estilo está en su archivo
//  (variants/<estilo>.typ), que importa este con `*`.

#import "/src/core/pliego.typ": pliego
#import "/src/presets/inscription/_legado/_base.typ": medida, escala, ajustar-alto
#import "/src/presets/inscription/_legado/_temas.typ": resolver-tema, temas-lamina
#import "/src/resources/motifs/_hojas-piezas.typ": flor
#import "/src/resources/motifs/_arcos.typ": arcos

// ── temas propios ───────────────────────────────────────────
// Los que no salen tal cual de `temas-lamina`. `hojas` y `bauhaus` usan los
// del registro.
#let _temas-b = (
  // arcos: el azul hondo de mosaico como papel, los arcos en su menta y el
  // disco en su naranja; la cita en crema.
  epi-arcos: (
    fondo: rgb("#002b38"),
    tinta: rgb("#f1ede4"),
    suave: rgb("#b3dcd4"),
    acento: rgb("#ff832a"),
  ),
  // malla: gris suizo frío, negro, rojo señal; `linea` la retícula y
  // `claro` el texto sobre la celda.
  epi-malla: (
    fondo: rgb("#e9e9e5"),
    tinta: rgb("#111111"),
    suave: rgb("#4f4f4b"),
    acento: rgb("#d62a1e"),
    linea: rgb("#bdbdb5"),
    claro: rgb("#ffffff"),
  ),
  // lineas: rojo sangre muy hondo y crema.
  epi-lineas: (
    fondo: rgb("#2e0f10"),
    tinta: rgb("#f3eadf"),
    suave: rgb("#cdb3a4"),
    acento: rgb("#f3eadf"),
  ),
)
#let _registro = temas-lamina + _temas-b

// Roles de un estilo: `auto` = su tema; si no, lo dado sobre su tema.
#let _tema(tema, defecto) = {
  if tema == auto { resolver-tema(defecto, defecto: defecto, registro: _registro) }
  else { resolver-tema(tema, defecto: defecto, registro: _registro) }
}

// ── comprobaciones ──────────────────────────────────────────
#let _validar(cita, formato, quien) = {
  if cita == none or cita == [] or cita == "" {
    panic(quien + ": falta la cita")
  }
  if type(cita) not in (str, content) {
    panic(quien + ": la cita es contenido o texto, no " + repr(type(cita)))
  }
  if type(formato) != array or formato.len() != 2 or formato.any(x => type(x) not in (int, float) or x <= 0) {
    panic(quien + ": `formato` es un par (ancho, alto) en px, no " + repr(formato))
  }
}

// Texto plano de un contenido (para medir sus palabras).
#let _plano(c) = {
  if c == none { "" }
  else if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_plano).join("") }
  else if c.has("body") { _plano(c.body) }
  else if c.has("child") { _plano(c.child) }
  else { " " }
}

// La cita en un bloque de ancho `w` a cuerpo `s`.
//   estilo   argumentos de `text` (font, weight, style, tracking, fill)
//   inter    interlínea en em
//   al       alineación de las líneas
#let _bloque(cita, estilo, inter, w, s, al: left) = block(width: w, {
  set text(size: s, hyphenate: false, lang: "es", ..estilo)
  set par(leading: inter * 1em, justify: false, spacing: inter * 1em)
  align(al, cita)
})

// El mayor cuerpo, de `desde` a `minimo`, con el que la cita cabe en w × h y
// ninguna palabra pasa de `w`. `none` si no cabe ni con el mínimo. Dentro de
// `context`.
#let _cuerpo(cita, estilo, inter, w, h, desde, minimo, al: left) = {
  let hacer(s) = _bloque(cita, estilo, inter, w, s, al: al)
  let palabras = _plano(cita).split(regex("\s+")).filter(x => x != "")
  let ancha = calc.max(1pt, ..palabras.map(p => measure(text(size: 100pt, hyphenate: false, ..estilo, p)).width))
  let tope = calc.min(desde, 100pt * (w / ancha) * 0.98)
  if tope < minimo { return none }
  let s = ajustar-alto(hacer, tope, h, minimo: minimo, paso: 1pt)
  let s = calc.max(s, minimo)
  if measure(hacer(s)).height > h { none } else { s }
}

#let _no-cabe(quien, minimo) = panic(quien + ": la cita no cabe ni con el cuerpo mínimo legible ("
  + str(calc.round(minimo / 1pt, digits: 1)) + " px). Acórtala o usa un formato más alto.")

// Guía de depuración: el contorno de una caja.
#let _guia(x, y, w, h, color: red) = place(top + left, dx: x, dy: y,
  rect(width: w, height: h, stroke: 1.5pt + color, fill: color.transparentize(88%)))

// Medidas comunes de un formato: (ancho, alto, k = escala sobre el retrato,
// km = factor del cuerpo mínimo, minimo = el cuerpo mínimo de la cita).
#let _medidas(formato) = {
  let (ancho, alto) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let km = calc.min(ancho, alto) / 1080pt
  (ancho: ancho, alto: alto, k: k, km: km, minimo: 34pt * km)
}
