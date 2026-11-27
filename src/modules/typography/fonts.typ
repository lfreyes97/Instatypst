// ─────────────────────────────────────────────────────────────
//  lib/fonts.typ — roles de fuente y su resolución a familias reales
//
//  Las familias salen SIEMPRE del registro verificado (font-tokens.typ) a través
//  de una pareja (font-pairings.typ). Roles de fuente:
//    display     titulares y cifras (en swiss: el remate, Bebas Neue)
//    body        texto (frase, prosa, notas)
//    mono, hand  los de font-pairings
//    annotation  etiquetas, índices y pies (por defecto = mono, o body)
//    main        alias de body (nombres-resueltos.toml: «rol de fuente principal»)
//
//  `fonts:` es un nombre de pareja o un diccionario rol → clave de font-tokens.
//  En el camino Typst (permisivo) se admite además un nombre de familia suelto;
//  la entrada de contrato (piece) solo admite claves del registro.
// ─────────────────────────────────────────────────────────────

#import "/src/modules/validate/validate.typ": expect, check-keys, suggest
#import "font-tokens.typ": tokens as font-tokens
#import "font-pairings.typ": library as pairings

#let font-roles = ("display", "body", "mono", "hand", "annotation", "main")

#let _family(v, role, fn) = {
  expect(v, str, "fonts." + role, fn: fn)
  if v in font-tokens { font-tokens.at(v).family } else { v } // familia suelta (camino Typst)
}

/// Resuelve las fuentes: pareja del preset < `fonts` (auto, pareja o diccionario).
/// Devuelve rol → familia para todos los roles que la pareja permita.
#let resolve-fonts(fonts, default, fn: "swiss") = {
  let find(n) = {
    assert(n in pairings, message: fn + ": pareja tipográfica desconocida " + repr(n)
      + " (parejas: " + pairings.keys().join(", ") + ")." + suggest(n, pairings.keys()))
    pairings.at(n)
  }
  let keys = find(default)
  if fonts != auto {
    expect(fonts, (auto, str, dictionary), "fonts", fn: fn)
    if type(fonts) == str { keys = find(fonts) } else {
      check-keys(fonts, font-roles, "fonts", fn: fn)
      let f = fonts
      if "main" in f {
        assert("body" not in f or f.body == f.main, message: fn + ": `fonts.main` es alias de `fonts.body`; da uno solo")
        f.insert("body", f.remove("main"))
      }
      keys = keys + f
    }
  }
  let out = keys.pairs().map(((r, k)) => (r, _family(k, r, fn))).to-dict()
  if "annotation" not in out { out.insert("annotation", out.at("mono", default: out.body)) }
  out.insert("main", out.body)
  out
}

/// Familia para el campo `font` de un estilo: rol de fuente, clave del registro
/// o (camino Typst) familia suelta.
#let resolve-font(f, fonts, fn: "swiss") = {
  expect(f, str, "font", fn: fn)
  if f in font-roles {
    assert(f in fonts, message: fn + ": la pareja tipográfica no define el rol de fuente `" + f + "`")
    fonts.at(f)
  } else if f in font-tokens { font-tokens.at(f).family } else { f }
}
