// lib/palettes/color-math.typ — matemática de color (migrado de WIP-color/color-math.typ).
//
//   oklch-linear(L, C, H)   OKLCH (L en 0..1, H en grados) → sRGB lineal SIN recortar
//   in-gamut(L, C, H)       ¿cabe en sRGB? (tolerancia por defecto: medio paso de 8 bits)
//   max-chroma(L, H)        croma máximo dentro de sRGB para esa claridad y matiz (bisección)
//   lch(c)                  (L 0..1, C, H grados) de cualquier color de Typst
//   de-ok(a, b)             ΔE OK: distancia euclídea en OKLab (×1; 0,02 ≈ diferencia apenas visible)
//   wcag(a, b)              contraste WCAG 2.x (el de lib/palettes, sobre el sRGB recortado)
//   hex(c)                  hex del sRGB que exporta Typst (recorte por canal)
//   lstar(c)                L* de CIELAB (0..100) desde la luminancia
//   lrv(c)                  LRV aproximado (luminancia × 100)
//
// Matrices OKLab de Björn Ottosson (https://bottosson.github.io/posts/oklab/), las mismas que
// usa scripts/gen-vendors.mjs.
//   apca(text, bg)          Lc de APCA (TEMPORAL: ver el bloque APCA y lib/palettes/LICENSE-apca)

#import "contrast.typ": contrast as _wcag, luminance

#let oklch-linear(L, C, H) = {
  let h = H * calc.pi / 180
  let a = C * calc.cos(h * 1rad)
  let b = C * calc.sin(h * 1rad)
  let l_ = L + 0.3963377774 * a + 0.2158037573 * b
  let m_ = L - 0.1055613458 * a - 0.0638541728 * b
  let s_ = L - 0.0894841775 * a - 1.2914855480 * b
  let (l, m, s) = (l_ * l_ * l_, m_ * m_ * m_, s_ * s_ * s_)
  (
    4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
  )
}

#let _enc(x) = if x <= 0.0031308 { 12.92 * x } else { 1.055 * calc.pow(x, 1 / 2.4) - 0.055 }

#let in-gamut(L, C, H, tol: 0.5 / 255) = {
  let e = oklch-linear(L, C, H).map(x => if x < 0 { 12.92 * x } else { _enc(x) })
  e.all(x => x >= -tol and x <= 1 + tol)
}

#let max-chroma(L, H, hi: 0.4, iters: 22) = {
  if L <= 0 or L >= 1 { return 0.0 }
  let (lo, up) = (0.0, hi)
  for _ in range(iters) {
    let mid = (lo + up) / 2
    // estricto (sin tolerancia): Typst guarda los componentes en f32 y el redondeo de L
    // puede sacar del gamut un color construido justo en el borde
    if in-gamut(L, mid, H, tol: 0) { lo = mid } else { up = mid }
  }
  lo
}

#let lch(c) = {
  let k = c.oklch().components()
  (k.at(0) / 100%, k.at(1), k.at(2) / 1deg)
}

#let de-ok(a, b) = {
  let p = a.oklab().components()
  let q = b.oklab().components()
  calc.sqrt(calc.pow((p.at(0) - q.at(0)) / 100%, 2) + calc.pow(p.at(1) - q.at(1), 2) + calc.pow(p.at(2) - q.at(2), 2))
}

#let wcag(a, b) = _wcag(a, b)

#let hex(c) = c.rgb().to-hex()

/// L* de CIELAB (CIE 1976, 0..100) desde la luminancia relativa Y.
#let lstar(c) = {
  let y = luminance(c)
  if y > 0.008856 { 116 * calc.pow(y, 1 / 3) - 16 } else { 903.3 * y }
}

/// LRV aproximado (0..100): la luminancia relativa × 100 del color tal como lo exporta Typst
/// (sRGB, sin perfil de impresión: una aproximación, no una medida del impreso).
#let lrv(c) = luminance(c) * 100

// ───────────────────────── APCA (TEMPORAL, uso personal) ─────────────────────────
// Esta obra incluye material derivado de apca-w3 0.1.9 (https://github.com/Myndex/apca-w3):
// Copyright © 2019-2023 Andrew Somers / Myndex™. All Rights Reserved. Patent(s) pending.
// Algoritmo base 0.0.98G-4g con el recorte de salida (loClip) de apca-w3 0.1.9.
// Licencia y restricciones (solo contenido web; sin uso comercial; mantener al día; nombre y
// logo protegidos): lib/palettes/LICENSE-apca. Está AQUÍ de forma TEMPORAL, mientras el
// proyecto es de uso personal; antes de redistribuir el paquete, retirar este bloque
// (ver CAMBIOS.md). Cambio respecto al original: portado a Typst; la entrada se redondea a
// los 8 bits de sRGB que exporta Typst (equivale a sRGBtoY con enteros 0..255).
#let _sa = (mainTRC: 2.4, sR: 0.2126729, sG: 0.7151522, sB: 0.0721750,
  normBG: 0.56, normTXT: 0.57, revTXT: 0.62, revBG: 0.65,
  blkThrs: 0.022, blkClmp: 1.414, scaleBoW: 1.14, scaleWoB: 1.14,
  loBoWoffset: 0.027, loWoBoffset: 0.027, deltaYmin: 0.0005, loClip: 0.1)

/// Y de APCA desde el sRGB de 8 bits que exporta Typst (como sRGBtoY con enteros 0..255).
#let apca-y(c) = {
  let k = c.rgb().components()
  let ch(v) = calc.pow(calc.round(v / 100% * 255) / 255, _sa.mainTRC)
  _sa.sR * ch(k.at(0)) + _sa.sG * ch(k.at(1)) + _sa.sB * ch(k.at(2))
}

/// Lc de APCA del texto `text` sobre el fondo `bg` (positivo: oscuro sobre claro; negativo: al revés).
#let apca(text, bg) = {
  let clamp(y) = if y > _sa.blkThrs { y } else { y + calc.pow(_sa.blkThrs - y, _sa.blkClmp) }
  let t = clamp(apca-y(text))
  let b = clamp(apca-y(bg))
  if calc.abs(b - t) < _sa.deltaYmin { return 0.0 }
  let out = if b > t {
    let s = (calc.pow(b, _sa.normBG) - calc.pow(t, _sa.normTXT)) * _sa.scaleBoW
    if s < _sa.loClip { 0.0 } else { s - _sa.loBoWoffset }
  } else {
    let s = (calc.pow(b, _sa.revBG) - calc.pow(t, _sa.revTXT)) * _sa.scaleWoB
    if s > -_sa.loClip { 0.0 } else { s + _sa.loWoBoffset }
  }
  out * 100
}

#let fmt(x, d: 2) = str(calc.round(x, digits: d))
