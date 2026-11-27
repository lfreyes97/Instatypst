// ─────────────────────────────────────────────────────────────
//  lib/palettes/verify.typ — verificadores de color con una interfaz común
//
//  Un verificador es un diccionario con:
//    name     nombre corto                 kind     "pair" (dos colores) o "single" (uno)
//    media    medios donde vale: "screen", "wallpaper", "print"
//    measure  función (a, b) => número (o (c) => número si kind es "single")
//    unit     unidad del número            better   "higher" (más es mejor) o "lower"
//    levels   umbral por nivel: body, large, line (o all en los de un solo color); none = sin umbral
//    note     qué mide y qué no
//
//    #verify.check(verify.wcag, ink, paper, level: "body")   → (name, value, min, pass, unit, note)
//    #verify.for-medium("print")                              → los verificadores que valen en ese medio
//    #verify.theme(colors, medium: "screen")                  → filas para los pares de un tema
//    #verify.failures(rows)    #verify.assert-ok(rows, "suizo")    #verify.format(row)
//
//  Informan, no deciden: `pass` es none si el verificador no tiene umbral para ese nivel.
//  Los umbrales por defecto vienen de fuentes concretas (ver cada `note`); cámbialos con
//  `min:` en `check` o con `levels:` en `theme`. `metric:` de `contrast-ramp` acepta cualquiera
//  de estos verificadores.
// ─────────────────────────────────────────────────────────────

#import "color-math.typ": wcag as wcag-ratio, apca as apca-lc, lstar, lrv, in-gamut, max-chroma, lch, de-ok

#let all-media = ("screen", "wallpaper", "print")

/// Ratio de contraste de WCAG 2.x (luminancia relativa). Norma vigente; subestima oscuro sobre oscuro.
#let wcag = (
  name: "wcag", kind: "pair", media: all-media, unit: "ratio", better: "higher",
  measure: (a, b) => wcag-ratio(a, b),
  levels: (body: 4.5, large: 3.0, line: none),
  note: "WCAG 2.x AA: 4,5:1 texto, 3:1 texto grande. Pensado para pantalla; en impreso es una aproximación.",
)

/// Diferencia de claridad L* de CIELAB. Sin polaridad ni tamaño de texto.
#let delta-l-star = (
  name: "ΔL*", kind: "pair", media: all-media, unit: "L*", better: "higher",
  measure: (a, b) => calc.abs(lstar(a) - lstar(b)),
  levels: (body: 50, large: 40, line: none),
  note: "ΔL* de CIELAB. 50 ≈ 4,5:1 y 40 ≈ 3:1 de WCAG contra blanco o negro (cuenta propia; entre dos tonos medios se separan).",
)

/// Diferencia de claridad en OKLab (×100). Sin umbral calibrado: úsalo con `min:`.
#let delta-l-oklab = (
  name: "ΔL OKLab", kind: "pair", media: all-media, unit: "L×100", better: "higher",
  measure: (a, b) => {
    let p = a.oklab().components()
    let q = b.oklab().components()
    calc.abs((p.at(0) - q.at(0)) / 100%) * 100
  },
  levels: (body: none, large: none, line: none),
  note: "Diferencia de L en OKLab × 100. Sin umbral calibrado: da `min:` tú.",
)

/// Diferencia de LRV (impresos). Aproximación sin perfil de impresión.
#let lrv-diff = (
  name: "ΔLRV", kind: "pair", media: ("print",), unit: "puntos", better: "higher",
  measure: (a, b) => calc.abs(lrv(a) - lrv(b)),
  levels: (body: 30, large: 30, line: none),
  note: "Diferencia de LRV entre superficies: 30 puntos (guía BS 8300; 20 con más de 200 lux). Aproximación: el CMYK de Typst no lleva perfil.",
)

/// Lc de APCA (valor absoluto). Solo pantallas autoiluminadas. TEMPORAL: ver LICENSE-apca.
#let apca = (
  name: "Lc", kind: "pair", media: ("screen", "wallpaper"), unit: "|Lc|", better: "higher",
  measure: (a, b) => calc.abs(apca-lc(a, b)),
  levels: (body: 75, large: 45, line: 15),
  note: "|Lc| (temporal, uso personal; ver LICENSE-apca). 75 texto de cuerpo mínimo, 45 texto grande mínimo, 15 punto de invisibilidad. Solo pantalla.",
)

/// ΔE OK × 100: ¿se distinguen dos colores? (≈2 es lo mínimo que se nota).
#let delta-e = (
  name: "ΔE", kind: "pair", media: all-media, unit: "ΔE×100", better: "higher",
  measure: (a, b) => de-ok(a, b) * 100,
  levels: (body: none, large: none, line: 2.0),
  note: "Distancia OKLab × 100; ≈2 = apenas visible. Sirve para filetes y guías, no para texto.",
)

/// ¿Cabe en sRGB? Croma / croma máximo para su claridad y matiz (≤ 1 cabe).
#let gamut = (
  name: "gamut", kind: "single", media: all-media, unit: "C/Cmax", better: "lower",
  measure: c => {
    let (L, C, H) = lch(c)
    let m = max-chroma(L, H)
    if m <= 0.0001 { 0.0 } else { C / m }
  },
  levels: (all: 1.001),
  note: "Croma relativo al máximo de sRGB; más de 1 se sale de la pantalla y Typst lo recorta.",
)

#let verifiers = (wcag, delta-l-star, delta-l-oklab, lrv-diff, apca, delta-e, gamut)

/// Los verificadores que valen en un medio ("screen", "wallpaper" o "print").
#let for-medium(medium) = {
  assert(medium in all-media, message: "verify: medio desconocido " + repr(medium) + " (medios: " + all-media.join(", ") + ")")
  verifiers.filter(v => medium in v.media)
}

/// Mide con un verificador. Nivel: "body", "large", "line" (o "all" en los de un solo color).
#let check(v, ..colors, level: none, min: auto) = {
  assert(type(v) == dictionary and "measure" in v, message: "verify.check: `v` debe ser un verificador (p. ej. verify.wcag)")
  let value = (v.measure)(..colors.pos())
  let m = if min != auto { min } else if level != none { v.levels.at(level, default: none) } else { none }
  let ok = if m == none { none } else if v.better == "higher" { value >= m } else { value <= m }
  (name: v.name, value: value, min: m, pass: ok, unit: v.unit, note: v.note)
}

/// Pares que se miran en un tema y el nivel que se les exige. Cámbialo con `pairs:`.
#let default-pairs = (
  ("ink", "paper", "body"),
  ("quiet", "paper", "body"),
  ("accent", "paper", "large"),
  ("guide", "paper", "line"),
)

/// Filas de verificación de un tema (`colors`: rol → color, como devuelve resolve-theme).
/// `only`: lista de verificadores (por defecto, los que valen en `medium`).
#let theme(colors, medium: "screen", pairs: default-pairs, only: auto) = {
  let vs = if only == auto { for-medium(medium) } else { only }
  let rows = ()
  for (a, b, level) in pairs {
    if colors.at(a, default: none) == none or colors.at(b, default: none) == none { continue }
    for v in vs.filter(v => v.kind == "pair") {
      rows.push((pair: a + "/" + b, level: level) + check(v, colors.at(a), colors.at(b), level: level))
    }
  }
  for (role, c) in colors {
    if c == none { continue }
    for v in vs.filter(v => v.kind == "single") { rows.push((pair: role, level: "all") + check(v, c, level: "all")) }
  }
  rows
}

/// Las filas que NO pasan (las que tienen umbral y no lo cumplen).
#let failures(rows) = rows.filter(r => r.pass == false)

/// Una fila como texto: `ink/paper (body) · wcag 16,19 ratio (mín. 4,5): pasa`.
#let format(r) = {
  let n(x) = str(calc.round(x, digits: 2))
  let umbral = if r.min != none { " (mín. " + n(r.min) + "): " + (if r.pass { "pasa" } else { "NO PASA" }) } else { " (sin umbral)" }
  r.pair + " (" + r.level + ") · " + r.name + " " + n(r.value) + " " + r.unit + umbral
}

/// Falla con la lista de lo que no pasa (para pruebas). Informa, no decide.
#let assert-ok(rows, what) = {
  let f = failures(rows)
  assert(f.len() == 0, message: "verify: " + what + " no pasa " + str(f.len()) + " comprobación(es): " + f.map(format).join("; "))
}
