// ─────────────────────────────────────────────────────────────
//  _comun.typ — caja de herramientas de la campaña Warfield
//
//  NO es una plantilla. Cada lámina tiene su propia composición, su
//  formato, su letra y su fondo, sacados de lo que dice la cita: la
//  campaña vive de la diversidad. Acá solo hay utilidades que de otro
//  modo se copiarían 20 veces. El único hilo común obligatorio es que
//  cada lámina lleve la atribución y la marca (el logo, a tamaño fijo;
//  nunca el handle en texto).
// ─────────────────────────────────────────────────────────────

#import "../src/lib.typ": sizes

// 4:5 — el vertical del feed (no está en `sizes` de social.typ).
#let formatos = sizes + (retrato: (1080, 1350))

// Logo de Assets/Logo.svg recoloreado: el SVG trae `currentColor`, que
// Typst no resuelve (cae a negro sin avisar).
// El tamaño es relativo al lienzo, no un valor fijo: el alto del logo es
// una fracción de √(ancho × alto), así ocupa la misma parte de la lámina
// sea cuadrada, retrato, story o apaisada. Medirlo solo por el ancho
// dejaba la story (1080×1920) con el logo del cuadrado y agrandaba el de
// 1600×900. `lienzo` es el par (ancho, alto) en px de la lámina.
// No se ajusta a mano por lámina.
#let logo-proporcion = 1 / 30 // alto del logo ÷ √área (36 pt en 1080×1080)
#let logo(color, lienzo) = {
  let (w, h) = lienzo
  image(
    bytes(read("../Assets/Logo.svg").replace("currentColor", color.to-hex())),
    format: "svg",
    height: calc.sqrt(w * h) * logo-proporcion * 1pt,
  )
}

// Texto plano de un contenido (para medir palabra por palabra).
#let plano(c) = {
  if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(plano).join() }
  else if c.has("body") { plano(c.body) }
  else if c == [ ] { " " }
  else { "" }
}

// El tamaño más grande (de `max` hacia abajo, de a `paso`) con el que
// `hacer(tamaño)` cabe en `ancho` × `alto`. Usar dentro de `context` o
// de `layout`. Si se pasa `texto`, además exige que su palabra más larga
// quepa en `ancho`: Typst deja que una palabra sin cortes se salga del
// margen sin crecer en alto, así que medir solo el alto no basta.
// OJO: no llamarla en una celda de grilla con `align: horizon` — la
// grilla mide esa fila con alto infinito y el bucle no encuentra techo.
#let ajustar(hacer, ancho, alto, texto: none, max: 140pt, min: 24pt, paso: 2pt) = {
  let palabras = if texto == none { () } else {
    plano(texto).split(regex("\\s+")).filter(p => p != "")
  }
  let cabe(s) = {
    let larga = if palabras.len() == 0 { 0pt } else {
      calc.max(..palabras.map(p => measure(text(size: s, p)).width))
    }
    larga <= ancho and measure(block(width: ancho, hacer(s))).height <= alto
  }
  let s = max
  while s > min and not cabe(s) { s -= paso }
  hacer(s)
}
