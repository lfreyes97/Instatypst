// tests/verificadores.typ — pruebas de lib/palettes/verify.typ y de lstar/lrv. Compila sin error
// si todo se cumple; lo ejecuta tests/run.sh.
#import "/src/modules/color/palettes.typ": palettes
#import "/src/modules/color/color.typ": resolve-theme
#let v = palettes.verify
#let near(a, b, eps) = calc.abs(a - b) <= eps

// ── lstar y lrv ──
#assert(near(palettes.lstar(white), 100, 1e-6) and near(palettes.lstar(black), 0, 1e-6), message: "L* de blanco y negro")
#assert(near(palettes.lstar(rgb("#777777")), 50, 0.2), message: "L* de #777777 ≈ 50")
#assert(near(palettes.lrv(white), 100, 1e-6) and near(palettes.lrv(black), 0, 1e-6), message: "LRV de blanco y negro")

// ── cada verificador, con valores conocidos ──
#assert(near((v.wcag.measure)(black, white), 21, 1e-9), message: "wcag negro/blanco = 21")
#assert(near((v.delta-l-star.measure)(black, white), 100, 1e-6), message: "ΔL* negro/blanco = 100")
#assert(near((v.delta-l-oklab.measure)(black, white), 100, 0.01), message: "ΔL OKLab negro/blanco ≈ 100")
#assert(near((v.lrv-diff.measure)(black, white), 100, 1e-6), message: "ΔLRV negro/blanco = 100")
#assert(near((v.apca.measure)(black, white), 106, 1.5), message: "|Lc| negro/blanco ≈ 106")
#assert((v.delta-e.measure)(white, white) == 0, message: "ΔE de un color consigo mismo = 0")
#assert((v.gamut.measure)(rgb("#c8102e")) <= 1.001, message: "un color sRGB cabe")
#assert((v.gamut.measure)(oklch(70%, 0.35, 150deg)) > 1.2, message: "un OKLCH muy saturado se sale")

// ── simetría: el orden de los colores no cambia el valor (salvo APCA, que tiene polaridad) ──
#for k in (v.wcag, v.delta-l-star, v.delta-l-oklab, v.lrv-diff, v.delta-e) {
  assert(near((k.measure)(rgb("#c8102e"), rgb("#f3f0e9")), (k.measure)(rgb("#f3f0e9"), rgb("#c8102e")), 1e-9), message: k.name + " es simétrico")
}
#assert((v.apca.measure)(black, white) != 0, message: "apca distingue")

// ── medios ──
#let names(m) = v.for-medium(m).map(k => k.name)
#assert("Lc" in names("screen") and "Lc" in names("wallpaper") and "Lc" not in names("print"), message: "APCA solo en pantalla")
#assert("ΔLRV" in names("print") and "ΔLRV" not in names("screen"), message: "ΔLRV solo en impreso")
#assert(("wcag", "ΔL*", "ΔE", "gamut").all(n => n in names("print") and n in names("screen")), message: "wcag, ΔL*, ΔE y gamut valen en todos")

// ── check: umbrales y banderas ──
#assert(v.check(v.wcag, black, white, level: "body").pass == true, message: "negro/blanco pasa")
#assert(v.check(v.wcag, rgb("#777777"), white, level: "body").pass == false, message: "#777 sobre blanco (4,48) no pasa AA")
#assert(v.check(v.wcag, rgb("#777777"), white, level: "large").pass == true, message: "#777 sobre blanco pasa texto grande")
#assert(v.check(v.delta-l-oklab, black, white, level: "body").pass == none, message: "sin umbral → pass none")
#assert(v.check(v.delta-l-oklab, black, white, min: 40).pass == true, message: "min explícito")
#assert(v.check(v.gamut, oklch(70%, 0.35, 150deg), level: "all").pass == false, message: "gamut: fuera no pasa")

// ── theme, failures, assert-ok ──
#let suizo = resolve-theme("suizo", "suizo")
#let rows = v.theme(suizo, medium: "screen")
#assert(rows.len() > 0 and rows.all(r => "pair" in r and "name" in r and "value" in r), message: "theme da filas")
#assert(rows.filter(r => r.pair == "ink/paper" and r.name == "wcag").first().pass == true, message: "suizo: tinta/papel pasa AA")
#assert(rows.filter(r => r.name == "ΔLRV").len() == 0, message: "en pantalla no sale ΔLRV")
#assert(v.theme(suizo, medium: "print").filter(r => r.name == "Lc").len() == 0, message: "en impreso no sale APCA")
#assert(v.theme(suizo, medium: "print").filter(r => r.name == "ΔLRV").len() > 0, message: "en impreso sale ΔLRV")
#let malo = (paper: white, ink: rgb("#cccccc"), quiet: rgb("#dddddd"), accent: none, guide: white)
#assert(v.failures(v.theme(malo, medium: "screen")).len() > 0, message: "un tema ilegible tiene fallos")
#assert(v.theme(malo, medium: "screen").all(r => r.pair != "accent/paper"), message: "accent none se omite")
#assert(type(v.format(rows.first())) == str, message: "format da texto")

// ── medio desconocido ──
// (falla con mensaje; se comprueba en tests/run.sh)

// ── contrast-ramp con metric como función o verificador ──
#let tg = (1.5, 3.0, 4.5, 7.0)
#let por-texto = palettes.contrast-ramp("#0f766e", targets: tg, metric: "wcag")
#let por-funcion = palettes.contrast-ramp("#0f766e", targets: tg, metric: (a, b) => (palettes.verify.wcag.measure)(a, b))
#let por-verificador = palettes.contrast-ramp("#0f766e", targets: tg, metric: v.wcag)
#assert(por-texto.ramp == por-funcion.ramp and por-texto.ramp == por-verificador.ramp, message: "metric: texto = función = verificador")
#let por-l = palettes.contrast-ramp("#0f766e", targets: (20, 40, 60), metric: v.delta-l-star)
#assert(por-l.misses == (), message: "contrast-ramp con ΔL*: sin fallos")
#for (c, t) in por-l.ramp.values().zip((20, 40, 60)) { assert((v.delta-l-star.measure)(c, white) >= t * 0.99, message: "ΔL* ≥ " + str(t)) }
