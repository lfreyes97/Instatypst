// Lámina 08 · «La predestinación» · retrato 1080×1350
// Barro: fondo de terracota con grano, terrones de arcilla (blobs de
// formas.typ) y una vasija recién torneada sobre el torno, con sus estrías.
// La frase, en Fraunces blanda, ocupa el cielo; la vasija, el suelo.
// Compilar: typst compile --root . --font-path Fonts campana/08-alfarero-y-barro.typ campana/08-alfarero-y-barro.png
#import "../src/lib.typ": *
#import "_comun.typ": logo, formatos, ajustar

#let (ancho, alto) = formatos.retrato
#let terracota = rgb("#9c4426")
#let horno = rgb("#7a321b")
#let crema = rgb("#f8ead8") // ≈ 5.6:1 sobre la terracota
#let arena = rgb("#f0cfae")

#set page(width: ancho * 1pt, height: alto * 1pt, margin: 0pt, fill: terracota)
#set text(font: "Fraunces 72pt Soft", fill: crema, lang: "es", hyphenate: false)

// ── Fondo: la terracota se oscurece hacia el suelo, como barro húmedo ──
#place(rect(width: 100%, height: 100%, fill: gradient.linear(
  rgb("#a84b2a"), terracota, horno, angle: 90deg,
)))

// Terrones de arcilla: siluetas orgánicas un tono por debajo del fondo.
#place(top + left, dx: 640pt, dy: -170pt, rotate(24deg, formas.blob("nube", w: 620pt, fill: rgb("#93401f"))))
#place(top + left, dx: -210pt, dy: 930pt, rotate(-12deg, formas.blob("hoja", w: 520pt, fill: rgb("#6f2d18"))))

// ── La vasija sobre el torno (SVG): degradado de volumen + estrías ──
#let barro-claro = "#d98a5d"
#let barro-medio = "#b65a30"
#let barro-oscuro = "#5e2512"
#let silueta = "M 130 30 C 140 44 158 60 158 82 C 158 150 35 180 35 300 C 35 410 100 470 135 498 L 365 498 C 400 470 465 410 465 300 C 465 180 342 150 342 82 C 342 60 360 44 370 30 Z"
#let estrias = range(110, 490, step: 22).map(y => {
  "<path d='M 0 " + str(y) + " Q 250 " + str(y + 56) + " 500 " + str(y) + "' fill='none' stroke='#3d160a' stroke-opacity='0.22' stroke-width='2.2'/>"
}).join("")
#let vasija = (
  "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 500 560'>",
  "<defs>",
  "<linearGradient id='vol' x1='0' x2='1' y1='0' y2='0'>",
  "<stop offset='0' stop-color='" + barro-medio + "'/>",
  "<stop offset='0.28' stop-color='" + barro-claro + "'/>",
  "<stop offset='0.62' stop-color='" + barro-medio + "'/>",
  "<stop offset='1' stop-color='" + barro-oscuro + "'/>",
  "</linearGradient>",
  "<clipPath id='c'><path d='" + silueta + "'/></clipPath>",
  "</defs>",
  // torno: plato con canto y sombra de la pieza
  "<ellipse cx='250' cy='520' rx='245' ry='34' fill='#3f170a'/>",
  "<ellipse cx='250' cy='508' rx='245' ry='34' fill='#5a2312'/>",
  "<ellipse cx='250' cy='504' rx='150' ry='14' fill='#2c0f06' fill-opacity='0.55'/>",
  // cuerpo
  "<path d='" + silueta + "' fill='url(#vol)'/>",
  "<g clip-path='url(#c)'>", estrias, "</g>",
  // boca: el hueco de la vasija
  "<ellipse cx='250' cy='30' rx='120' ry='17' fill='" + barro-medio + "'/>",
  "<ellipse cx='250' cy='32' rx='104' ry='12' fill='#3d160a'/>",
  "</svg>",
).join("")

#place(top + left, dx: 530pt, dy: 690pt, image(bytes(vasija), format: "svg", width: 590pt))

// Un terrón suelto junto al torno, a medio amasar.
#place(top + left, dx: 446pt, dy: 1196pt, rotate(-14deg, formas.blob("nube", w: 150pt, fill: rgb("#b45f35"))))

// Grano de barro sobre todo.
#superbg.superbg((capas: (
  (tipo: "ruido", color: rgb("#2a0f05"), opacidad: 9%),
)), size: formatos.retrato)

// ── La frase ──
#let cita = [Él era como el #emph[alfarero], e Israel como el #emph[barro] que el alfarero moldea a su voluntad.]
#place(top + left, dx: 84pt, dy: 112pt, block(width: 912pt, height: 560pt, context ajustar(
  s => text(size: s, weight: 400, par(leading: 0.42em, cita)),
  912pt, 560pt, texto: cita, max: 110pt, min: 48pt,
)))

// ── Atribución y marca: al pie, sobre el barro oscuro ──
#place(top + left, dx: 84pt, dy: 1090pt, block(width: 420pt, {
  set par(leading: 0.4em, spacing: 0pt)
  text(size: 32pt, weight: 600)[B. B. Warfield]
  v(14pt)
  text(size: 28pt, style: "italic", fill: arena)[La predestinación]
  v(36pt)
  logo(crema, (ancho, alto))
}))
