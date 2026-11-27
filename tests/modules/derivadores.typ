// tests/derivadores.typ — pruebas de lib/palettes/color-math.typ y derive.typ (migradas de
// WIP-color/pruebas.typ; APCA temporal). Compila sin error si todo se cumple; lo ejecuta tests/run.sh.
#import "/src/modules/color/palettes/color-math.typ": *
#import "/src/modules/color/palettes/derive.typ": *
#import "/src/modules/color/palettes.typ": palettes

#let n = state("n", 0)
#let check(ok, what) = { assert(ok, message: "prueba: " + what); n.update(x => x + 1) }
#let near(a, b, eps) = calc.abs(a - b) <= eps

// ── APCA: los valores de prueba de apca-w3 0.1.9 (test/index.js), texto sobre fondo ──
#for (t, b, lc) in (
  ("#888", "#fff", 63.056469930209424), ("#fff", "#888", -68.54146436644962),
  ("#000", "#aaa", 58.146262578561334), ("#aaa", "#000", -56.24113336839742),
  ("#123", "#def", 91.66830811481631), ("#def", "#123", -93.06770049484275),
  ("#123", "#444", 8.32326136957393), ("#444", "#123", -7.526878460278154),
) { check(near(apca(rgb(t), rgb(b)), lc, 1e-9), "APCA " + t + " sobre " + b + " = " + str(lc) + ", sale " + str(apca(rgb(t), rgb(b)))) }

// ── WCAG y gamut ──
#check(near(wcag(black, white), 21, 1e-9), "WCAG negro/blanco = 21")
#check(in-gamut(0.5, 0.0, 0), "gris en gamut")
#check(in-gamut(0.637, 0.237, 25.331), "tw4-red-500 dentro de sRGB")
#check(not in-gamut(0.577, 0.245, 27.325), "tw4-red-600 fuera de sRGB")
#for f in palettes.tw4.families() { for s in palettes.tw4.steps() {
  let (L, C, H) = lch(palettes.tw4.get(f, s))
  check(in-gamut(L, C, H) == (f + "-" + s not in palettes.tw4.out-of-gamut), "tw4-" + f + "-" + s + ": in-gamut coincide con el generador")
} }
#for (L, H) in ((0.7, 25), (0.95, 100), (0.3, 265), (0.5, 145)) {
  let m = max-chroma(L, H)
  check(in-gamut(L, m, H, tol: 0) and not in-gamut(L, m + 0.002, H, tol: 0), "Cmax(" + str(L) + ", " + str(H) + "°) es el borde de sRGB")
}

// ── op-ramp: el CSS de Open Props v2 beta, número a número ──
#let r = op-ramp(hue: 25)
#check(r.keys() == range(1, 17).map(str), "op: 16 pasos 1..16")
#check(r.at("8") == oklch(58%, 0.21, 25deg), "op: --color-8 = oklch(58% .21 25)")
#check(r.at("1") == oklch(98%, 0.03, 25deg), "op: --color-1 = oklch(98% .03 25)")
#check(r.at("16") == oklch(10%, 0.05, 25deg), "op: --color-16 = oklch(10% .05 25)")
#let r2 = op-ramp(hue: "blue", chroma: 0.5, rotate: -5)
#check(r2.at("1") == oklch(98%, 0.015, 240deg), "op: croma multiplica, paso 1 sin giro")
#check(r2.at("11") == oklch(42%, 0.085, 190deg), "op: paso 11 gira 10 × (−5)°")
#check(op-ramp(hue: 25, gamut: "chroma").values().all(c => { let (L, C, H) = lch(c); in-gamut(L, C, H) }), "op gamut: chroma deja todo en sRGB")
#check(op1-ramp(hue: 270).at("0") == oklch(99%, 0.03, 270deg) and op1-ramp(hue: 270).at("bright") == oklch(65%, 0.3, 270deg), "op1: --color-0 y bright")
#check(op1-gray-ramp(hue: 50, chroma: 0.01).at("10") == oklch(43%, 0.01, 50deg), "op1 gris: --gray-10")

// ── anchored-ramp: la semilla queda tal cual; L monótona; todo en sRGB ──
#for seed in ("#c8102e", "#fff200", "#0f766e", "#14213d", "#808080", "#00aeef") {
  let a = anchored-ramp(seed)
  check(a.values().any(c => c == rgb(seed)), "anchored: " + seed + " está en su rampa")
  let ls = a.values().map(c => lch(c).at(0))
  check(range(ls.len() - 1).all(i => ls.at(i) > ls.at(i + 1)), "anchored: L decrece (" + seed + ")")
  check(a.values().all(c => { let (L, C, H) = lch(c); in-gamut(L, C, H) }), "anchored: todo en sRGB (" + seed + ")")
}
#check(anchored-ramp("#c8102e", anchor: "600").at("600") == rgb("#c8102e"), "anchored: ancla explícita")
#check(anchored-ramp("#c8102e", n: 12).keys() == range(1, 13).map(str), "anchored: n = 12 → 1..12")

// ── gamut-ramp ──
#let g = gamut-ramp(hue: 100, fraction: 1)
#check(g.values().all(c => { let (L, C, H) = lch(c); in-gamut(L, C, H) }), "gamut: en sRGB")

// ── contrast-ramp: cumple el contraste pedido ──
#let tg = (1.1, 1.3, 1.6, 2.2, 3.0, 4.5, 6.0, 8.0, 11.0, 14.0, 17.0)
#for seed in ("#c8102e", "#fff200", "#0f766e") {
  let cr = contrast-ramp(seed, targets: tg)
  check(cr.misses == (), "contrast: sin fallos (" + seed + ")")
  for (k, c) in cr.ramp.values().zip(tg) { check(wcag(k, white) >= c * 0.995, "contrast wcag " + seed + " " + str(c)) }
}
#let ca = contrast-ramp("#0f766e", targets: (15, 30, 45, 60, 75, 90), metric: "apca")
#check(ca.ramp.values().zip((15, 30, 45, 60, 75, 90)).all(((c, t)) => calc.abs(apca(c, white)) >= t * 0.99), "contrast apca")

// ── shape-ramp: con la semilla de la propia rampa vendor, la reproduce ──
#for f in ("red", "blue", "emerald", "slate") {
  let fam = palettes.tw4.family(f)
  let s = shape-ramp(fam.at("500"), shape: fam, anchor: "500")
  for (k, c) in fam {
    let (L, C, H) = lch(c)
    if in-gamut(L, C, H) { check(de-ok(s.at(k), c) < 0.002, "shape reproduce tw4-" + f + "-" + k + " (ΔE " + str(de-ok(s.at(k), c)) + ")") }
  }
}

#context [#metadata(n.final()) <pruebas> pruebas: #n.final() bien]
