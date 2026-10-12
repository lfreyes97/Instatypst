// Demo de curvas.campo() / curvas.ventana() — fondos de curvas CONTINUOS
// entre diapositivas: cada familia como un carrusel de 5 cuadradas (el
// número grande marca la diapositiva; al deslizar, la curva que sale por
// el borde derecho entra por el izquierdo de la siguiente), y un deck
// apaisado de 3. Ver src/curvas.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/curvas.typ
#import "../../src/curvas.typ" as curvas

#let carrusel(tipo, fondo, tinta, color, ..opciones) = {
  let n = 5
  let c = curvas.campo(tipo, diapositivas: n, formato: (1080, 1080), color: color, ..opciones)
  for i in range(n) {
    page(width: 1080pt, height: 1080pt, margin: 0pt, fill: fondo, {
      curvas.ventana(c, i)
      place(top + left, dx: 80pt, dy: 70pt,
        text(font: "Inter", size: 26pt, weight: 700, tracking: 0.16em, fill: tinta, upper(tipo)))
      place(bottom + right, dx: -80pt, dy: -40pt,
        text(font: "Bebas Neue", size: 320pt, fill: tinta, str(i + 1)))
    })
  }
}

#carrusel("topo", rgb("#10302a"), rgb("#efe8da"), rgb("#8fb8a4"), opacidad: 45%)
#carrusel("ondas", rgb("#f3efe6"), rgb("#1d2b36"), rgb("#1d4ed8"), relleno: true)
#carrusel("flujo", rgb("#0d1014"), rgb("#f4f1ea"), rgb("#c3c9d1"))
#carrusel("paralelas", rgb("#f1e9dc"), rgb("#2a2420"), rgb("#9a3a1c"), opacidad: 40%)
#carrusel("cinta", rgb("#f3f0e9"), rgb("#141414"), rgb("#c8102e"), hueco: rgb("#f3f0e9"), bucles: true)
#carrusel("orbitas", rgb("#1a1a2e"), rgb("#f4f0e8"), rgb("#e2bdb5"), opacidad: 40%)

// ── deck apaisado de 3: el fondo corre bajo las tres diapositivas ──
#let deck = curvas.campo("flujo", diapositivas: 3, formato: (1920, 1080), color: rgb("#6b4a44"), semilla: 7)
#for (i, titulo) in ([Planteo], [Desarrollo], [Remate]).enumerate() {
  page(width: 1920pt, height: 1080pt, margin: 0pt, fill: rgb("#f6efe4"), {
    curvas.ventana(deck, i)
    place(horizon + left, dx: 140pt, block(width: 1100pt, {
      text(font: "Inter", size: 30pt, weight: 700, tracking: 0.16em, fill: rgb("#8e3b3b"), [#(i + 1) / 3])
      v(12pt)
      text(font: "Literata", size: 120pt, weight: 600, fill: rgb("#2b1916"), titulo)
    }))
  })
}
