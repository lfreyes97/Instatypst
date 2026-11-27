// ─────────────────────────────────────────────────────────────
//  lib/color.typ — roles de color y temas (`theme` = solo colores)
//
//  Origen: core/v2/primitives.typ (`themes`, `resolve-theme`, derivación del
//  filete) con el vocabulario acordado: paper, ink, quiet, accent, guide
//  (antes background, ink, muted, accent, rule). Los valores hex de `suizo` y
//  `lamina` son los de v2 (no están en el registro); `noche` usa claves de
//  color-tokens.typ, como propone COMENTARIOS.md § a.2.
//
//  Un color se da como color de Typst, como nombre de rol ("accent") o como
//  clave del registro ("amapola") o referencia al catálogo de paletas
//  ("tw4-blue-500", "rx-tomato-9-dark": prefijo-familia-paso[-variante],
//  ver lib/palettes.typ). Derivados (si no se dan y cambia paper o
//  ink, o el tema base no los trae): guide = 12 % de tinta sobre el papel,
//  quiet = 62 %.
// ─────────────────────────────────────────────────────────────

#import "/src/modules/validate/validate.typ": expect, check-keys, suggest
#import "color-tokens.typ": tokens as color-tokens
#import "palettes/core.typ": providers, families, steps, palette-get

/// Referencia al catálogo de paletas: prefijo-familia-paso[-variante] ("tw4-red-200",
/// "rx-tomato-9-dark", "oc-grape-5"). El prefijo es el primer segmento; el paso (y la
/// variante de rx) son los últimos; la familia es lo del medio (puede llevar guiones).
/// Los nombres sueltos ("red-200") no son del catálogo: quedan para las rampas del usuario.
#let catalog-sep = "-"
/// Prefijos reservados que el catálogo aún no publica.
#let catalog-reserved = (op: "Open Props (en estudio en WIP-color; aún no se publica)")
/// Proveedores del separador `/` anterior → prefijo actual (para el mensaje de error).
#let catalog-legacy = (tailwind: "tw4", unocss: "tw4", radix: "rx", opencolor: "oc")

/// Divide una referencia en (prefix, family, step, variant); none si no tiene la forma
/// prefijo-familia-paso. Un último segmento no numérico (con 4 o más) es la variante.
#let split-catalog-ref(c) = {
  let p = c.split(catalog-sep)
  if p.len() < 3 or p.any(x => x == "") { return none }
  let numeric(x) = x.codepoints().all(d => d in "0123456789")
  let (variant, rest) = if p.len() >= 4 and not numeric(p.last()) { (p.last(), p.slice(0, -1)) } else { (none, p) }
  (prefix: rest.first(), family: rest.slice(1, -1).join(catalog-sep), step: rest.last(), variant: variant)
}

/// Qué parece un texto que no es rol ni clave del registro, para dar el error justo:
/// "legacy" (usa `/`), "catalog" (prefijo conocido), "incomplete" (prefijo conocido sin
/// familia o paso), "reserved" (op), "unknown-prefix"
/// (tres o más segmentos con paso numérico), "loose" (familia-paso sin prefijo) o none.
#let catalog-kind(c, prefixes) = {
  if c.contains("/") { return "legacy" }
  let r = split-catalog-ref(c)
  let p = c.split(catalog-sep)
  if r != none and r.prefix in prefixes { return "catalog" }
  if r == none and p.first() in prefixes { return "incomplete" }
  if r != none and r.prefix in catalog-reserved { return "reserved" }
  let numeric(x) = x.len() > 0 and x.codepoints().all(d => d in "0123456789")
  if r != none and numeric(r.step) { return "unknown-prefix" }
  if p.len() == 2 and numeric(p.last()) and p.first() != "" { return "loose" }
  none
}

/// Traducción de una referencia con `/` ("tailwind/blue/500") a la sintaxis actual.
#let catalog-legacy-hint(c) = {
  let p = c.split("/")
  if p.len() in (3, 4) and p.first() in catalog-legacy {
    let pre = catalog-legacy.at(p.first())
    (" Escribe " + repr(pre + catalog-sep + p.slice(1).join(catalog-sep))
      + (if p.first() in ("tailwind", "unocss") { " (ojo: tw4 es Tailwind v4, en OKLCH; la v3 se retiró)" } else { "" }) + ".")
  } else { "" }
}

/// Mensaje común para las formas que no son una referencia válida (todas menos "catalog").
#let catalog-kind-message(c, kind, prefixes, fits: none) = {
  let form = "prefijo" + catalog-sep + "familia" + catalog-sep + "paso (rx admite además " + catalog-sep + "light o " + catalog-sep + "dark; prefijos: " + prefixes.join(", ") + ")"
  if kind == "legacy" {
    "usa el separador `/`, que ya no vale: una referencia al catálogo es " + form + "." + catalog-legacy-hint(c)
  } else if kind == "incomplete" {
    "no es una referencia al catálogo completa: usa " + form + "."
  } else if kind == "reserved" {
    let pre = c.split(catalog-sep).first()
    "usa el prefijo reservado " + repr(pre) + ": " + catalog-reserved.at(pre) + "."
  } else if kind == "unknown-prefix" {
    let pre = c.split(catalog-sep).first()
    let hint = if pre in catalog-legacy { " ¿Quisiste decir " + repr(catalog-legacy.at(pre)) + "?" } else { suggest(pre, prefixes) }
    "tiene un prefijo desconocido " + repr(pre) + " (prefijos: " + prefixes.join(", ") + ")." + hint
  } else if kind == "loose" {
    // `fits(prefijo, familia, paso)`: el catálogo tiene esa familia y ese paso con ese prefijo
    let (fam, st) = c.split(catalog-sep)
    let ok = if fits == none { () } else { prefixes.filter(x => fits(x, fam, st)) }
    ("es un nombre suelto: los nombres familia" + catalog-sep + "paso quedan para tus rampas; el catálogo pide prefijo"
      + if ok.len() > 0 { " (existe " + ok.map(x => repr(x + catalog-sep + c)).join(", ") + ")." }
        else { " (" + prefixes.join(", ") + "), p. ej. \"tw4-red-200\"." })
  } else { "" }
}

#let color-roles = ("paper", "ink", "quiet", "accent", "guide")

#let themes = (
  suizo: (
    paper: rgb("#f3f0e9"),
    ink: rgb("#141414"),
    quiet: rgb("#5c5850"),
    accent: rgb("#c8102e"),
    guide: rgb("#d9d3c7"),
  ),
  lamina: (
    paper: rgb("#f7f7f3"),
    ink: rgb("#14213d"),
    quiet: rgb("#454f63"),
    accent: rgb("#0f766e"),
  ),
  noche: (
    paper: color-tokens.at("stone-850"),
    ink: color-tokens.at("amber-50"),
    accent: color-tokens.at("mandarina"),
  ),
)

#let mix(a, b, p) = color.mix((a, 100% - p), (b, p), space: oklab)

/// Color de una referencia al catálogo de paletas ("tw4-blue-500", "rx-tomato-9-dark").
/// Nombres estrictos con sugerencia: prefijo, familia, paso y variante (solo rx).
#let resolve-catalog(c, fn: "swiss", name: "fill") = {
  let at = fn + ": `" + name + "` = " + repr(c) + " "
  let kind = catalog-kind(c, providers())
  assert(kind == "catalog", message: at + if kind in (none, "loose") {
    "no es una referencia al catálogo: usa prefijo" + catalog-sep + "familia" + catalog-sep + "paso (rx admite además "
      + catalog-sep + "light o " + catalog-sep + "dark; prefijos: " + providers().join(", ") + ")."
  } else { catalog-kind-message(c, kind, providers()) })
  let r = split-catalog-ref(c)
  let (provider, family, step) = (r.prefix, r.family, r.step)
  assert(family in families(provider), message: at + "familia desconocida " + repr(family) + " en " + provider
    + " (" + str(families(provider).len()) + " familias: " + families(provider).join(", ") + ")." + suggest(family, families(provider)))
  assert(step in steps(provider), message: at + "paso desconocido " + repr(step) + " en " + provider
    + " (pasos: " + steps(provider).join(", ") + ").")
  if r.variant != none {
    assert(provider == "rx", message: at + "solo rx tiene variantes (light, dark)")
    assert(r.variant in ("light", "dark"), message: at + "variante desconocida " + repr(r.variant)
      + " (variantes: light, dark)." + suggest(r.variant, ("light", "dark")))
    palette-get(provider, family, step, variant: r.variant)
  } else { palette-get(provider, family, step) }
}

/// Un color concreto: color/gradiente, rol de `colors`, clave del registro o referencia
/// al catálogo de paletas (prefijo-familia-paso[-variante]).
#let resolve-fill(c, colors, fn: "swiss", name: "fill") = {
  if c == none { return none }
  if type(c) in (color, gradient, tiling) { return c }
  expect(c, (str, color, gradient), name, fn: fn)
  if colors != none and c in colors { return colors.at(c) }
  if c in color-tokens { return color-tokens.at(c) }
  let kind = catalog-kind(c, providers())
  if kind == "catalog" { return resolve-catalog(c, fn: fn, name: name) }
  let at = fn + ": `" + name + "` = " + repr(c) + " "
  let fits(x, f, st) = f in families(x) and st in steps(x)
  assert(kind == none, message: at + catalog-kind-message(c, kind, providers(), fits: fits)
    + (if kind == "loose" { suggest(c, color-tokens.keys()) } else { "" }))
  assert(false, message: at + "no es un rol de color (" + color-roles.join(", ") + "), ni una clave del registro de colores, ni una referencia al catálogo (prefijo" + catalog-sep + "familia" + catalog-sep + "paso)."
    + suggest(c, color-roles + color-tokens.keys()))
}

/// Resuelve el tema: `default` (nombre de un tema, o un diccionario de roles: `accent: none` = sin acento) < `theme` (auto, nombre o
/// diccionario parcial de roles) < `accent` (atajo).
///
/// `extra`: los roles propios de un preset, además de los cinco (bauhaus: `yellow`,
/// `blue`). El preset los declara y les da valor en `default`; `theme` puede
/// cambiarlos y aceptan lo mismo que los cinco (color, clave del registro o
/// referencia al catálogo). No se derivan de nada: el resultado los trae tal cual.
#let resolve-theme(theme, default, accent: auto, extra: (), fn: "swiss") = {
  let find(n) = {
    assert(n in themes, message: fn + ": tema desconocido " + repr(n) + " (temas: "
      + themes.keys().join(", ") + ")." + suggest(n, themes.keys()))
    themes.at(n)
  }
  let base = if type(default) == dictionary { default } else { find(default) }
  let given = if theme == auto { (:) } else if type(theme) == str { find(theme) } else {
    expect(theme, (auto, str, dictionary), "theme", fn: fn)
    check-keys(theme, color-roles + extra, "theme", fn: fn)
    theme.pairs().map(((k, v)) => (k, resolve-fill(v, none, fn: fn, name: "theme." + k))).to-dict()
  }
  if accent != auto { given.insert("accent", resolve-fill(accent, none, fn: fn, name: "accent")) }
  let out = base + given
  for r in ("paper", "ink", "accent") + extra {
    assert(r in out, message: fn + ": el tema no define `" + r + "`")
  }
  // `quiet` y `guide` se derivan de paper e ink solo si nadie los da: ni el tema
  // del usuario ni el del preset (como en v1; decidido el 26 nov 2026). Un tema
  // que cambia solo `paper` conserva el `quiet` y el `guide` del preset.
  let derive = (guide: 12%, quiet: 62%)
  for (r, p) in derive {
    if r not in given and r not in base { out.insert(r, mix(out.paper, out.ink, p)) }
  }
  (color-roles + extra).map(r => (r, out.at(r))).to-dict()
}
