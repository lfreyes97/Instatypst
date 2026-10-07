// ─────────────────────────────────────────────────────────────
//  superbg / core.typ — NIVEL 3: motor superbg() (dispatch de capas)
// ─────────────────────────────────────────────────────────────

#import "_util.typ": sizes, _check-size, _normalizar
#import "solid.typ": bg-plano
#import "gradient.typ": bg-gradiente
#import "spots.typ": bg-blob, bg-aura
#import "pattern.typ": bg-patron, bg-vignette
#import "image-bg.typ": bg-imagen
#import "compose.typ": bg-frame, bg-vidrio
#import "mesh.typ": bg-malla
#import "waves.typ": bg-olas
#import "topo.typ": bg-topo
#import "tramas.typ": bg-halftone, bg-rayos
#import "memphis.typ": bg-memphis

// Dibuja UNA capa dict. `size` se propaga a las capas SVG que lo
// necesitan (aura/patrón/viñeta/frame). `theme` se reenvía para
// defaults (puente Instatypst sin importarlo).
#let _capa(c, size, theme) = {
  if type(c) != dictionary or "tipo" not in c {
    panic("superbg: cada capa debe ser dict con `tipo` — recibido: " + repr(c))
  }
  let t = c.tipo
  if t == "plano" {
    bg-plano(c.at("color", default: if theme != none and "colors" in theme { theme.colors.light } else { rgb("#f5f5f4") }), opacidad: c.at("opacidad", default: 100%))
  } else if t == "gradiente" {
    bg-gradiente(from: c.at("from", default: c.at("c1", default: none)), to: c.at("to", default: c.at("c2", default: none)), angulo: c.at("angulo", default: 135deg), tipo: c.at("estilo", default: c.at("grad-tipo", default: "linear")), parar: c.at("parar", default: none), theme: theme)
  } else if t == "blob" {
    bg-blob(c.at("x", default: -200pt), c.at("y", default: -150pt), c.at("radio", default: 400), c.at("color", default: white), opacidad: c.at("opacidad", default: 20%))
  } else if t == "aura" {
    bg-aura(c.at("colores", default: auto), size: size, r: c.at("r", default: auto), blur: c.at("blur", default: auto), posiciones: c.at("posiciones", default: auto), panel: c.at("panel", default: none), panel-blur: c.at("panel-blur", default: auto), tinte: c.at("tinte", default: white), theme: theme)
  } else if t == "patron" {
    bg-patron(patron: c.at("patron", default: "dots"), color: c.at("color", default: none), fondo: c.at("fondo", default: none), paso: c.at("paso", default: 48), grosor: c.at("grosor", default: 1.5), radio: c.at("radio", default: 3), opacidad: c.at("opacidad", default: 18%), size: size, theme: theme)
  } else if t == "vignette" {
    bg-vignette(color: c.at("color", default: black), intensidad: c.at("intensidad", default: 35%), size: size)
  } else if t == "ruido" {
    bg-patron(patron: "ruido", color: c.at("color", default: white), fondo: c.at("fondo", default: none), opacidad: c.at("opacidad", default: 12%), size: size, theme: theme)
  } else if t == "imagen" {
    bg-imagen(c.at("ruta", default: c.at("path", default: none)), overlay: c.at("overlay", default: black), opacidad: c.at("opacidad", default: 45%), tinte: c.at("tinte", default: none), fit: c.at("fit", default: "cover"))
  } else if t == "frame" {
    bg-frame(c.at("izq", default: auto), c.at("der", default: auto), centro: c.at("centro", default: white), margen: c.at("margen", default: 80pt), size: size, theme: theme)
  } else if t == "vidrio" {
    bg-vidrio(c.at("x", default: 80pt), c.at("y", default: 80pt), c.at("w", default: 920pt), c.at("h", default: 920pt), r: c.at("r", default: 24pt), tinte: c.at("tinte", default: white), borde: c.at("borde", default: auto), size: size)
  } else if t == "malla" {
    bg-malla(c.at("colores", default: auto), size: size, puntos: c.at("puntos", default: auto), radios: c.at("radios", default: auto), blur: c.at("blur", default: auto), fondo: c.at("fondo", default: none), semilla: c.at("semilla", default: 7), theme: theme)
  } else if t == "olas" {
    bg-olas(c.at("colores", default: auto), fondo: c.at("fondo", default: white), size: size, amplitud: c.at("amplitud", default: 90), vueltas: c.at("vueltas", default: 2), fase: c.at("fase", default: 0), base: c.at("base", default: 0.62), separacion: c.at("separacion", default: 0.13), desfase: c.at("desfase", default: 0.9), ancla: c.at("ancla", default: "abajo"), capas: c.at("capas", default: auto), theme: theme)
  } else if t == "topo" {
    bg-topo(color: c.at("color", default: none), fondo: c.at("fondo", default: rgb("#fafaf9")), size: size, centro: c.at("centro", default: auto), anillos: c.at("anillos", default: 14), separacion: c.at("separacion", default: 46), wobble: c.at("wobble", default: 18), grosor: c.at("grosor", default: 1.6), opacidad: c.at("opacidad", default: 30%), semilla: c.at("semilla", default: 5), theme: theme)
  } else if t == "halftone" {
    bg-halftone(color: c.at("color", default: none), fondo: c.at("fondo", default: white), size: size, paso: c.at("paso", default: 36), r-max: c.at("r-max", default: 11), r-min: c.at("r-min", default: 1.2), direccion: c.at("direccion", default: "diagonal"), opacidad: c.at("opacidad", default: 100%), centro: c.at("centro", default: auto), theme: theme)
  } else if t == "rayos" {
    bg-rayos(color: c.at("color", default: none), fondo: c.at("fondo", default: white), size: size, n: c.at("n", default: 24), centro: c.at("centro", default: auto), opacidad: c.at("opacidad", default: 12%), theme: theme)
  } else if t == "memphis" {
    bg-memphis(colores: c.at("colores", default: auto), fondo: c.at("fondo", default: auto), size: size, densidad: c.at("densidad", default: 26), semilla: c.at("semilla", default: 3), grosor: c.at("grosor", default: 5), opacidad: c.at("opacidad", default: 85%), theme: theme)
  } else if t == "preset" {
    // Se resuelve en presets.typ para evitar ciclo de imports —
    // core no conoce nombres, delega por hook dinámico.
    panic("superbg: capa preset sin resolver — llama a superbg() desde lib.typ, no a _capa() directo")
  } else {
    panic("superbg: tipo de capa desconocido \"" + t + "\" — usa plano | gradiente | blob | aura | malla | patron | vignette | ruido | halftone | rayos | olas | topo | memphis | imagen | frame | vidrio")
  }
}

// Motor interno (sin presets): apila capas en orden.
#let _motor(capas, size, theme) = {
  let size = _check-size(size)
  capas.map(c => _capa(c, size, theme)).join()
}
