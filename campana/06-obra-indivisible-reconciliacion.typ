// Lámina 06 · «La expiación» · cuadrado 1080×1080
// Quiasmo en espejo: «Dios … con nosotros» / «nosotros … con Dios» a cada
// lado de un único eje —la cruz— que es la obra indivisible. Dos filetes de
// oro cruzan el eje uniendo cada palabra con su reflejo: la χ del quiasmo.
// Compilar: typst compile --root . --font-path Fonts campana/06-obra-indivisible-reconciliacion.typ campana/06-obra-indivisible-reconciliacion.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos

#let (ancho, alto) = formatos.instagram
#let noche = rgb("#10172a")
#let crema = rgb("#efe6d2")
#let oro = rgb("#c9a24a")
#let tenue = rgb("#b9b09e") // texto secundario (≈ 8:1 sobre la noche)

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: noche)
#set text(font: "Cormorant Garamond", fill: crema, lang: "es", hyphenate: false)

// Fondo: noche con un resplandor cálido sobre el eje (degradado nativo:
// el aura en SVG dejaba anillos de banda) + grano y viñeta.
#place(rect(width: 100%, height: 100%, fill: gradient.radial(
  rgb("#2b2a35"), rgb("#171d31"), noche, center: (50%, 48%), radius: 72%,
)))
#superbg.superbg((capas: (
  (tipo: "ruido", color: white, opacidad: 5%),
  (tipo: "vignette", intensidad: 40%),
)), size: formatos.instagram)

#let eje = 540pt   // el eje de simetría
#let luz = 54pt    // separación de cada media del eje

// ── Encabezado: la obra, sobre el eje ──
#place(top + center, dy: 88pt, text(size: 38pt, weight: 500, tracking: 0.14em, fill: oro)[
  #smallcaps[Por esta única e indivisible obra,]
])

// ── La cruz: un solo trazo vertical que atraviesa toda la frase ──
#let trazo = 4pt
#place(top + left, dx: eje - trazo / 2, dy: 168pt, rect(width: trazo, height: 700pt, fill: oro))
#place(top + left, dx: eje - 62pt, dy: 238pt, rect(width: 124pt, height: trazo, fill: oro))

// ── Las dos mitades del quiasmo, renglón por renglón ──
// Cada renglón se ubica por su altura de mayúscula (top-edge por defecto),
// así la χ puede apuntar a coordenadas fijas.
#let grande(c) = text(size: 132pt, weight: 500, style: "italic", c)
#let menor(c) = text(size: 54pt, weight: 400, c)
#let enlace(c) = text(size: 42pt, style: "italic", fill: tenue, c)

#let renglon(lado, y, c) = {
  if lado == "izq" {
    place(top + right, dx: -(ancho * 1pt - eje + luz), dy: y, c)
  } else {
    place(top + left, dx: eje + luz, dy: y, c)
  }
}
#let mitad(lado, a, b, c, d, e) = {
  renglon(lado, 322pt, enlace(a))
  renglon(lado, 384pt, grande(b))
  renglon(lado, 540pt, menor(c))
  renglon(lado, 628pt, enlace(d))
  renglon(lado, 690pt, grande(e))
}

#mitad("izq", [tanto], [Dios], [es reconciliado], [con], [nosotros,])
#mitad("der", [como], [nosotros], [somos reconciliados], [con], [Dios.])

// ── La χ: cada palabra unida con su reflejo, cruzando el eje ──
#let filete = (paint: oro.transparentize(30%), thickness: 1.6pt)
#place(top + left, line(start: (eje - 40pt, 440pt), end: (eje + 40pt, 742pt), stroke: filete))
#place(top + left, line(start: (eje - 40pt, 742pt), end: (eje + 40pt, 440pt), stroke: filete))

// ── Atribución y marca ──
#place(bottom + center, dy: -96pt, text(size: 28pt, fill: tenue)[
  #text(fill: crema, weight: 600)[B. B. Warfield] #h(10pt)·#h(10pt) #text(style: "italic")[La expiación]
])
#place(bottom + center, dy: -40pt, logo(oro, (ancho, alto)))
