// lib/palettes/derive.typ — derivadores EXPLÍCITOS de rampas de n pasos (migrado de
// WIP-color/derivadores.typ; se importan como `palettes.op-ramp`, `palettes.shape-ramp`…).
//
// Cada derivador es una función con nombre: el diseñador elige
// el derivador, la semilla y los parámetros, y nombra la rampa que sale (`marca-600`).
// Ninguno calcula colores en silencio ni se usa por defecto en ningún sitio.
//
//   op-ramp          Open Props v2 beta, 16 pasos "1".."16" (port fiel)
//   op1-ramp         Open Props v1 (1.7.23), 16 pasos "0".."15" + "bright" (port fiel)
//   op1-gray-ramp    Open Props v1, grises "0".."15" con matiz y croma (port fiel)
//   anchored-ramp    propio: la semilla queda tal cual en un paso; croma relativo al gamut
//   gamut-ramp       propio: croma = fracción fija del máximo sRGB a cada claridad
//   contrast-ramp    propio: la claridad de cada paso se resuelve para un contraste pedido
//   shape-ramp       propio: la forma (L, croma relativo, giro de matiz) de una rampa vendor
//                    aplicada a otra semilla, anclada
//
// Todas devuelven un diccionario paso → color (como palettes.tw4.family).

#import "color-math.typ": oklch-linear, in-gamut, max-chroma, lch, de-ok, wcag, apca

// ───────────────────────── Open Props ─────────────────────────
// Fuente (MIT, Adam Argyle): open-props 2.0.0-beta.5 de npm, css/color/palette.oklch.css,
// idéntico a la rama 2.0.0beta (commit 986dbc376a164e2e68c44a1799826f847d858c52):
//   --color-N: oklch(L_N  calc(C_N * var(--palette-chroma, 1))
//                    calc(var(--palette-hue) + ((N-1) * var(--palette-hue-rotate-by))))
// L_N y C_N son constantes escritas a mano en el archivo: Open Props no publica cómo se
// eligieron (no hay fórmula; ver INFORME). Matices con nombre: css/color/hues.oklch.css.

#let op-table = (
  (98, 0.03), (97, 0.06), (93, 0.1), (84, 0.12), (80, 0.16), (71, 0.19), (66, 0.2), (58, 0.21),
  (53, 0.2), (49, 0.19), (42, 0.17), (35, 0.15), (27, 0.12), (20, 0.09), (16, 0.07), (10, 0.05),
)
#let op-hues = (red: 25, pink: 350, purple: 310, violet: 290, indigo: 270, blue: 240,
  cyan: 210, teal: 185, green: 145, lime: 125, yellow: 100, orange: 75)

#let _hue(h, fn) = {
  if type(h) == str {
    assert(h in op-hues, message: fn + ": matiz con nombre desconocido " + repr(h) + " (" + op-hues.keys().join(", ") + ")")
    op-hues.at(h)
  } else {
    assert(type(h) in (int, float), message: fn + ": `hue` es obligatorio (grados o un nombre de op-hues)")
    h
  }
}

// En CSS el ángulo no se normaliza ni se recorta; aquí se lleva a 0..360 (mismo color).
#let _deg(h) = calc.rem-euclid(h, 360) * 1deg

/// Regla: paso N (1..16) = oklch(L_N, C_N × chroma, hue + (N−1) × rotate), L_N y C_N de la tabla.
/// `chroma` es un multiplicador (el `, 1` de respaldo del CSS; el archivo publicado pone
/// --palette-chroma: 0.15 en :root y el configurador de la documentación arranca en 0.9).
/// `gamut: "clip"` deja el OKLCH tal cual (Typst recorta canal a canal al exportar, como hace
/// el CSS si el navegador recorta); `"chroma"` baja el croma al máximo sRGB (no es de Open Props).
#let op-ramp(hue: none, chroma: 1, rotate: 0, gamut: "clip") = {
  let h0 = _hue(hue, "op-ramp")
  let out = (:)
  for (i, (l, c)) in op-table.enumerate() {
    let (L, C, H) = (l / 100, c * chroma, h0 + i * rotate)
    if gamut == "chroma" { C = calc.min(C, max-chroma(L, H)) }
    out.insert(str(i + 1), oklch(l * 1%, C, _deg(H)))
  }
  out
}

// Open Props v1 (npm open-props 1.7.23 = main, src/props.colors-oklch.css y props.gray-oklch.css).
#let op1-table = (
  (99, 0.03), (95, 0.06), (88, 0.12), (80, 0.14), (74, 0.16), (68, 0.19), (63, 0.20), (58, 0.21),
  (53, 0.20), (49, 0.19), (42, 0.17), (35, 0.15), (27, 0.12), (20, 0.09), (14, 0.07), (11, 0.05),
)
#let op1-bright = (65, 0.3)
#let op1-gray-l = (99, 95, 88, 80, 74, 68, 63, 58, 53, 49, 43, 37, 31, 25, 18, 10)

/// Regla: paso N (0..15) = oklch(L_N, C_N, hue); "bright" = oklch(65 %, 0.3, hue). Sin croma ni giro.
#let op1-ramp(hue: none) = {
  let h0 = _hue(hue, "op1-ramp")
  let out = (:)
  for (i, (l, c)) in op1-table.enumerate() { out.insert(str(i), oklch(l * 1%, c, _deg(h0))) }
  out.insert("bright", oklch(op1-bright.at(0) * 1%, op1-bright.at(1), _deg(h0)))
  out
}

/// Regla: paso N (0..15) = oklch(L_N, chroma, hue). En CSS, sin --gray-chroma el croma es `none` (0).
#let op1-gray-ramp(hue: 0, chroma: 0) = {
  let out = (:)
  for (i, l) in op1-gray-l.enumerate() { out.insert(str(i), oklch(l * 1%, chroma, _deg(hue))) }
  out
}

// ─────────────────────── derivadores propios ───────────────────────
// Superan los límites medidos de superpelettes `new-ramp` (ver INFORME):
//  1. la semilla puede quedar tal cual en un paso (anchored-ramp, shape-ramp);
//  2. el croma sigue el gamut sRGB de cada matiz (croma relativo = C / Cmax(L, H)), no una
//     única curva sin(π·L);
//  4. contrast-ramp garantiza un contraste por paso por construcción.

#let _names(names, n) = {
  if names != none { names.map(str) }
  else if n == 11 { ("50", "100", "200", "300", "400", "500", "600", "700", "800", "900", "950") }
  else { range(1, n + 1).map(str) }
}

#let _as-color(c) = if type(c) == str { rgb(c) } else { c }

// croma relativo: fracción del máximo sRGB que tiene la semilla a su claridad
#let _rel(L, C, H) = { let m = max-chroma(L, H); if m <= 0.0001 { 0.0 } else { calc.min(1.0, C / m) } }

/// Regla: el paso `anchor` es la semilla tal cual; el resto reparte L en línea recta (por tramos)
/// de `light` a la L de la semilla y de ahí a `dark`; C = (croma relativo de la semilla) × Cmax(L, H);
/// H = H de la semilla + `rotate` grados por paso de distancia al ancla.
/// `anchor: auto` elige el paso cuya L de la recta light→dark queda más cerca de la de la semilla.
#let anchored-ramp(seed, n: 11, names: none, anchor: auto, light: 0.975, dark: 0.16, rotate: 0) = {
  let s = _as-color(seed)
  let keys = _names(names, n)
  let n = keys.len()
  let (Ls, Cs, Hs) = lch(s)
  let base = range(n).map(i => light + (dark - light) * i / (n - 1))
  let a = if anchor == auto {
    let d = base.map(l => calc.abs(l - Ls))
    d.position(x => x == calc.min(..d))
  } else if type(anchor) == str { keys.position(k => k == anchor) } else { anchor }
  assert(a != none and a >= 0 and a < n, message: "anchored-ramp: ancla desconocida " + repr(anchor) + " (pasos: " + keys.join(", ") + ")")
  let rel = _rel(Ls, Cs, Hs)
  let out = (:)
  for i in range(n) {
    if i == a { out.insert(keys.at(i), s); continue }
    let L = if i < a { light + (Ls - light) * i / a } else { Ls + (dark - Ls) * (i - a) / (n - 1 - a) }
    let H = Hs + (i - a) * rotate
    out.insert(keys.at(i), oklch(L * 100%, rel * max-chroma(L, H), _deg(H)))
  }
  out
}

/// Regla: L en línea recta de `light` a `dark`; C = `fraction` × Cmax(L, H); H fijo.
#let gamut-ramp(hue: none, fraction: 0.9, n: 11, names: none, light: 0.975, dark: 0.16) = {
  assert(type(hue) in (int, float), message: "gamut-ramp: `hue` es obligatorio (grados OKLCH)")
  let keys = _names(names, n)
  let n = keys.len()
  let out = (:)
  for i in range(n) {
    let L = light + (dark - light) * i / (n - 1)
    out.insert(keys.at(i), oklch(L * 100%, fraction * max-chroma(L, hue), _deg(hue)))
  }
  out
}

/// Regla: para cada paso k, L es la que da contraste `targets.at(k)` contra `against`
/// (WCAG 2.x si `metric: "wcag"`, |Lc| de APCA si `"apca"` (temporal, ver LICENSE-apca), o `metric:` una función (a, b) => número o un verificador de palettes.verify; más es más contraste), con el croma relativo y el matiz
/// de la semilla. Los objetivos los da el diseñador (no hay valores por defecto).
/// Si un objetivo no se alcanza dentro de sRGB, el paso queda en el extremo y se avisa en `misses`.
#let contrast-ramp(seed, targets: none, names: none, against: white, metric: "wcag", tolerance: 0.005) = {
  assert(type(targets) == array, message: "contrast-ramp: `targets` es obligatorio (un contraste por paso)")
  assert(type(metric) in (function, dictionary) or metric in ("wcag", "apca"), message: "contrast-ramp: `metric` debe ser \"wcag\", \"apca\", una función (a, b) => número o un verificador (palettes.verify.*), no " + repr(metric))
  let s = _as-color(seed)
  let keys = _names(names, targets.len())
  let (Ls, Cs, Hs) = lch(s)
  let rel = _rel(Ls, Cs, Hs)
  let mk(L) = oklch(L * 100%, rel * max-chroma(L, Hs), _deg(Hs))
  let m(c) = if type(metric) == function { metric(c, against) } else if type(metric) == dictionary { (metric.measure)(c, against) } else if metric == "apca" { calc.abs(apca(c, against)) } else { wcag(c, against) }
  // ¿el fondo es claro? entonces más contraste = más oscuro
  let bg-light = lch(_as-color(against)).at(0) > 0.5
  let out = (:)
  let misses = ()
  for (k, t) in targets.enumerate() {
    let (lo, hi) = (0.0, 1.0)   // L buscada en [lo, hi]
    for _ in range(30) {
      let mid = (lo + hi) / 2
      let enough = m(mk(mid)) >= t
      if bg-light { if enough { lo = mid } else { hi = mid } } else { if enough { hi = mid } else { lo = mid } }
    }
    let L = if bg-light { lo } else { hi }
    let c = mk(L)
    if m(c) < t * (1 - tolerance) { misses.push(keys.at(k)) }
    out.insert(keys.at(k), c)
  }
  (ramp: out, misses: misses)
}

/// Regla: toma de una rampa vendor `shape` (diccionario paso → color) su L por paso, su croma
/// relativo por paso (C / Cmax) y su giro de matiz respecto al paso ancla; los aplica a la semilla,
/// que queda tal cual en el paso `anchor` (por defecto, el de L más cercana). Mismos pasos que `shape`.
#let shape-ramp(seed, shape: none, anchor: auto) = {
  assert(type(shape) == dictionary, message: "shape-ramp: `shape` es obligatorio (una rampa: paso → color)")
  let s = _as-color(seed)
  let keys = shape.keys()
  let v = keys.map(k => lch(shape.at(k)))
  let (Ls, Cs, Hs) = lch(s)
  let a = if anchor == auto {
    let d = v.map(x => calc.abs(x.at(0) - Ls))
    d.position(x => x == calc.min(..d))
  } else { keys.position(k => k == str(anchor)) }
  assert(a != none, message: "shape-ramp: ancla desconocida " + repr(anchor))
  let (La, Ca, Ha) = v.at(a)
  let rel-a = _rel(La, Ca, Ha)
  let rel-s = _rel(Ls, Cs, Hs)
  let out = (:)
  for (i, k) in keys.enumerate() {
    if i == a { out.insert(k, s); continue }
    let (L, C, H) = v.at(i)
    // L: misma distancia relativa al ancla que en la rampa vendor, reescalada a la L de la semilla
    let L2 = if L > La { Ls + (L - La) * (1 - Ls) / calc.max(0.0001, 1 - La) } else { Ls * L / calc.max(0.0001, La) }
    // giro de matiz respecto al ancla (los grises vendor no tienen matiz fiable: sin giro)
    let dH = if C < 0.02 or Ca < 0.02 { 0 } else { calc.rem-euclid(H - Ha + 180, 360) - 180 }
    let H2 = Hs + dH
    let rel = _rel(L, C, H)
    let k2 = if rel-a <= 0.0001 { 0 } else { rel / rel-a * rel-s }
    out.insert(k, oklch(L2 * 100%, calc.min(1.0, k2) * max-chroma(L2, H2), _deg(H2)))
  }
  out
}
