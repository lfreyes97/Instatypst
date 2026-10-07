// ─────────────────────────────────────────────────────────────
//  superbg — sistema componible de fondos para Typst
//
//  TRES NIVELES, una sola puerta:
//
//  NIVEL 1 — preconstruidos (simple):
//    #superbg("neon-aura")
//    #superbg("papel-crema", theme: mi-tema)
//    #superbg-preset("amanecer", colores: (blue, orange))
//
//  NIVEL 2 — constructores por tipo (explícito):
//    #bg-plano(rgb("#fdfbf7"))
//    #bg-gradiente(from: blue, to: purple, angulo: 135deg)
//    #bg-aura((pink, orange, gold), size: sizes.story)
//    #bg-malla((orange, pink, purple))          // malla orgánica (jitter+semilla)
//    #bg-olas((blue, purple), fondo: white)    // bandas sinusoidales
//    #bg-topo(color: navy)                     // curvas de nivel
//    #bg-patron(patron: "dots", color: navy, paso: 44)
//    #bg-halftone(color: navy, direccion: "radial") // radio variable
//    #bg-rayos(color: orange, n: 24)           // sunburst
//    #bg-memphis(semilla: 3, densidad: 26)     // confetti Memphis
//    #bg-vignette(intensidad: 35%)
//    #bg-imagen(read("foto.jpg", encoding: none), opacidad: 45%)
//    #bg-frame(blue, orange) · #bg-vidrio(x:.., y:.., w:.., h:..)
//    #texto-sobre(rgb("#1c1917"))              // color inteligente: white/black
//
//  NIVEL 3 — motor componible (capas):
//    #superbg((capas: (
//      (tipo: "plano", color: rgb("#1c1917")),
//      (tipo: "aura", colores: (pink, orange)),
//      (tipo: "patron", patron: "dots", opacidad: 12%),
//      (tipo: "vignette", intensidad: 30%),
//    )), size: sizes.instagram)
//
//  INDEPENDIENTE: no importa Instatypst. `theme:` es opcional y
//  duck-typing — cualquier dict con `.colors` (p. ej. el theme de
//  Instatypst) sirve para defaults; sin theme todo se pasa explícito.
//
//  DENTRO DE INSTASTYPST (puente):
//    #import "@local/superbg:0.1.0": superbg, sizes as bg-sizes
//    #canvas(sizes.instagram, [#superbg("neon-aura", theme: theme.base) ...contenido...])
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _normalizar, _check-size
#import "solid.typ": bg-plano
#import "gradient.typ": bg-gradiente
#import "spots.typ": bg-blob, bg-aura
#import "pattern.typ": bg-patron, bg-vignette
#import "image-bg.typ": bg-imagen
#import "compose.typ": bg-frame, bg-vidrio, combinar
#import "mesh.typ": bg-malla
#import "waves.typ": bg-olas
#import "topo.typ": bg-topo
#import "tramas.typ": bg-halftone, bg-rayos
#import "memphis.typ": bg-memphis
#import "color.typ": contraste, es-aa, texto-sobre
#import "core.typ": _motor, _capa
#import "presets.typ": preset-capas, lista-presets, superbg-preset

// Expande capas tipo preset dentro de un array de capas.
#let _expandir(capas, theme, ruta, colores, centro) = {
  let fuera = ()
  for c in capas {
    if type(c) == dictionary and c.at("tipo", default: "") == "preset" {
      let n = c.at("nombre", default: none)
      if n == none { panic("superbg: capa preset necesita `nombre` — p. ej. (tipo: \"preset\", nombre: \"noche\")") }
      for pc in preset-capas(n, theme: theme, ruta: c.at("ruta", default: ruta), colores: c.at("colores", default: colores), centro: c.at("centro", default: centro)) {
        fuera.push(pc)
      }
    } else {
      fuera.push(c)
    }
  }
  fuera
}

// MOTOR PÚBLICO — acepta string | content (N2 ya armado) | capa-dict | array-capas | dict-motor.
#let superbg(spec, size: sizes.instagram, theme: none, ruta: none, colores: auto, centro: auto) = {
  if type(spec) == content {
    // N2 ya compuesto con `+` (p. ej. bg-plano(..) + bg-patron(..)) — passthrough.
    spec
  } else if type(spec) == str {
    _motor(preset-capas(spec, theme: theme, ruta: ruta, colores: colores, centro: centro), size, theme)
  } else {
    let norm = _normalizar(spec, size)
    let capas = _expandir(norm.capas, theme, ruta, colores, centro)
    // Si alguna capa sigue siendo preset-nombre suelto (string), resolver:
    let capas2 = capas.map(c => if type(c) == str { preset-capas(c, theme: theme, ruta: ruta, colores: colores, centro: centro) } else { c })
    // Aplanar por si un preset devolvió array anidado:
    let plano = ()
    for c in capas2 { if type(c) == array { for x in c { plano.push(x) } } else { plano.push(c) } }
    _motor(plano, norm.size, theme)
  }
}

// Alias en español.
#let fondo = superbg

// Lienzo autónomo (sin Instatypst): página al tamaño dado con el fondo
// y el cuerpo encima. Para usar DENTRO de Instatypst, en cambio, llama
// a superbg() como primer hijo de canvas() — no uses esto.
#let superbg-page(spec, body, size: sizes.instagram, theme: none, ruta: none, colores: auto, centro: auto) = {
  let size = _check-size(size)
  page(width: size.at(0) * 1pt, height: size.at(1) * 1pt, margin: 0pt, fill: white, [
    #superbg(spec, size: size, theme: theme, ruta: ruta, colores: colores, centro: centro)
    #body
  ])
}
