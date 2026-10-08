// Lámina 05 · «La incapacidad y la exigencia de la fe» · retrato 1080×1350
// Concepto: mandato contra promesa. Arriba, un bloque negro con la orden
// (actúa, en el nombre de Cristo, como si tuvieras fuerza); abajo, un
// bloque amarillo pleno con lo que se halla al obedecer. El corte entre
// ambos sube en diagonal: el paso dado. Bricolage Grotesque en todo.
// Compilar: typst compile --root . --font-path Fonts campana/05-actua-contra-el-pecado.typ campana/05-actua-contra-el-pecado.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos, ajustar

#let (ancho, alto) = formatos.retrato
#let negro = rgb("#151413")
#let amarillo = rgb("#f6cf3a")
#let hueso = rgb("#f2eee6")
#let gris = rgb("#a9a49b")

#let W = ancho * 1pt
#let H = alto * 1pt
#let mx = 64pt
// el corte: más bajo a la izquierda, más alto a la derecha
#let corte-izq = 790pt
#let corte-der = 690pt

#set page(width: W, height: H, margin: 0pt, fill: amarillo)
#set text(font: "Bricolage Grotesque", fill: hueso, lang: "es")

// ── bloque del mandato ──
#place(top + left, polygon(fill: negro, (0pt, 0pt), (W, 0pt), (W, corte-der), (0pt, corte-izq)))

#place(top + left, dx: mx, dy: 62pt, text(size: 22pt, weight: 600, tracking: 0.14em, fill: gris)[B. B. WARFIELD])
#place(top + right, dx: -mx, dy: 62pt, text(size: 22pt, weight: 400, fill: gris)[La incapacidad y la exigencia de la fe])
#place(top + left, dx: mx, dy: 104pt, line(length: W - 2 * mx, stroke: 1pt + gris.transparentize(50%)))

#let mandato(s) = {
  set par(leading: 0.22em, spacing: 0.5em)
  text(size: s, weight: 800, tracking: -0.02em)[Actúa contra el pecado,]
  parbreak()
  text(size: s * 0.62, weight: 500, fill: amarillo)[en el nombre de Cristo,]
  parbreak()
  text(size: s * 0.62, weight: 300)[como si tuvieras fuerza,]
}
#place(top + left, dx: mx, dy: 150pt, block(width: W - 2 * mx, context ajustar(mandato, W - 2 * mx, 470pt, texto: [Actúa contra el pecado,], max: 150pt)))

// ── bloque de la promesa ──
// Dos renglones fijos; el tamaño sale de que «que la tienes.» llene el ancho.
#let renglon(s, cuerpo) = text(size: s, weight: 800, fill: negro, tracking: -0.03em, cuerpo)
#place(top + left, dx: mx - 4pt, dy: corte-izq + 84pt, context {
  let s = 100pt * ((W - 2 * mx) / measure(renglon(100pt)[que la tienes.]).width)
  set par(leading: 0.16em)
  block(width: W - 2 * mx, renglon(s)[y hallarás \ que la tienes.])
})

// ── pie ──
#place(bottom + left, dx: mx, dy: -54pt, logo(negro, (ancho, alto)))
