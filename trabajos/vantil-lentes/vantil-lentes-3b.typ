// Variante de la lámina 3 del carrusel «Los lentes de colores»: la cura, con cristal claro.
// Misma montura y misma posición que la lámina 1, pero ahora el cristal es transparente: fuera
// de él la palabra HECHOS queda desvaída y, dentro, nítida y en tinta. «Ver los hechos como
// son». Al pasar de la 1 a esta, lo único que cambia es el color: del tinte verde a la claridad.
// Reemplaza a la lámina 3 (la de los lentes quitados); las citas y el pie son los mismos.
// Compilar: typst compile --root . --font-path Fonts trabajos/vantil-lentes/vantil-lentes-3b.typ salida/vantil-lentes-3b.png --ppi 144
#import "vantil-lentes.typ": f, ancho, alto, crema, tinta, verde, cristal, apagado, mono, palabra, lentes, pie, contador

#let desvaido = rgb("#cdc5b1") // HECHOS fuera del cristal: sin foco

#page(width: ancho, height: alto, margin: 0pt, fill: crema, {
  let esc = 0.95 // misma escala que la lámina 1
  let d = 390pt * esc
  let sep = 60pt * esc
  let x0 = (ancho - (2 * d + sep)) / 2
  let y0 = 60pt
  let tam = 232pt * esc
  let py = y0 + 114pt * esc
  place(top + left, dy: py, box(width: ancho, align(center, palabra(tam, desvaido))))
  lentes(x0, y0, d, sep, 9pt * esc, tinte: white.transparentize(45%), palabra-tenida: (0pt, py, tam, tinta))

  place(top + left, dx: 88pt, dy: 560pt, mono([LA CURA], verde, size: 22pt))
  place(top + left, dx: 88pt, dy: 610pt, box(width: ancho - 176pt, {
    set text(font: "Hanken Grotesk", fill: tinta, size: 36pt, weight: 400)
    set par(leading: 0.46em)
    text(style: "italic")[«#text(weight: 700, style: "normal")[Solo el gran Médico], mediante su expiación en la cruz y por el don de su Espíritu, puede quitar esos lentes de colores y hacerle ver los hechos como son, los hechos como evidencia, como evidencia inherentemente vinculante, de la existencia de Dios.»]
  }))
  pie(mono([CORNELIUS VAN TIL · WHY I BELIEVE IN GOD (1976), P. 15], apagado, size: 18pt), tinta)
  contador(3, tinta, cristal)
})
