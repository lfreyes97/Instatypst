// Lámina 04 · «La teología de Calvino» · story 1080×1920
// Concepto: un mapa topográfico nocturno. Las curvas de nivel son los
// fenómenos del mundo, y todas se ordenan alrededor de una sola cumbre:
// ahí, donde se juntan, cae el clímax «la mano de Dios, obrando su
// voluntad». La frase baja por el vertical en escalones, en Literata.
// Compilar: typst compile --root . --font-path Fonts campana/04-calvinista-ve-a-dios.typ campana/04-calvinista-ve-a-dios.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.story
#let fondo = rgb("#10302a")
#let curva = rgb("#8fb8a4")
#let crema = rgb("#efe8da")
#let salvia = rgb("#b9cfc3")
#let albaricoque = rgb("#f3c28e")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: fondo)
#set text(font: "Literata", fill: crema, lang: "es")

// ── curvas de nivel propias ──
// bg-topo de superbg arma el SVG con str(), que escribe los negativos con
// «−» (U+2212) y el SVG descarta esas curvas; además acá la cumbre tiene
// que caer en un punto preciso. Anillos alrededor de `cumbre`, cada uno un
// poco corrido (la ladera no es simétrica) y con ondulación que crece hacia
// afuera; cada quinto anillo, más grueso, como las curvas maestras.
#let cumbre = (560, 1370)
#let curvas-de-nivel(n: 34, sep: 40, pasos: 140) = for k in range(1, n + 1) {
  let r = k * sep
  let cx = cumbre.at(0) - k * 6.5
  let cy = cumbre.at(1) - k * 11
  let amp = calc.min(0.24, 0.10 + k * 0.006)
  let pts = range(pasos).map(i => {
    let a = 2 * calc.pi * i / pasos
    let f = 1 + amp * (0.5 * calc.sin(2 * a + 0.9 + k * 0.06) + 0.32 * calc.sin(3 * a + 2.1 - k * 0.05) + 0.18 * calc.sin(5 * a + 0.4 + k * 0.09))
    ((cx + r * f * calc.cos(a)) * 1pt, (cy + r * f * 1.18 * calc.sin(a)) * 1pt)
  })
  let maestra = calc.rem(k, 5) == 0
  place(top + left, polygon(
    stroke: (if maestra { 2.2pt } else { 1.1pt }) + curva.transparentize(if maestra { 55% } else { 72% }),
    ..pts,
  ))
}
#curvas-de-nivel()


// ── cabecera ──
#let x0 = 80pt
#place(top + left, dx: x0, dy: 110pt, text(size: 24pt, weight: 600, tracking: 0.16em, fill: salvia)[B. B. WARFIELD])
#place(top + left, dx: x0, dy: 148pt, text(size: 26pt, style: "italic", fill: salvia)[La teología de Calvino])
#place(top + right, dx: -x0, dy: 112pt, logo(salvia, (ancho, alto)))

// ── la frase, bajando en escalones ──
#let paso(dy, dx: 0pt, cuerpo) = place(top + left, dx: x0 + dx, dy: dy, cuerpo)

#paso(370pt, text(size: 64pt, weight: 400)[El calvinista es el hombre])
#paso(460pt, dx: 150pt, text(size: 104pt, weight: 600, tracking: -0.01em)[que ve a Dios])
#paso(618pt, dx: 40pt, text(size: 60pt, weight: 400, style: "italic")[detrás de todos])
#paso(698pt, dx: 260pt, text(size: 60pt, weight: 400, style: "italic")[los fenómenos,])
#paso(870pt, text(size: 56pt, weight: 400, fill: salvia)[y en todo lo que ocurre])
#paso(952pt, dx: 330pt, text(size: 56pt, weight: 400, fill: salvia)[reconoce])

// clímax, sobre la cumbre
#place(top + center, dy: 1200pt, block(width: 960pt)[
  #set align(center)
  #set par(leading: 0.12em, spacing: 0pt)
  #text(size: 150pt, weight: 600, style: "italic", fill: albaricoque, tracking: -0.02em)[la mano \ de Dios,]
  #v(56pt)
  #text(size: 76pt, weight: 400, style: "italic", fill: albaricoque)[obrando su voluntad.]
])

// ── pie ──
