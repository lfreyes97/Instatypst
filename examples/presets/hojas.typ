// Demo de carteles.hojas() — una sola pieza, la «hoja» (un cuadrado con tres
// esquinas redondeadas y un anillo), en tres composiciones: la flor de cuatro
// hojas, el par en diagonal y la cinta a 45° que el borde recorta. Amarillo y
// azul sobre blanco, títulos pesados en la «display» del paquete (Poppins) y
// el párrafo en la «body» (Inter). Primero las tres portadas de la
// referencia, después otros formatos, una paleta propia y casos límite.
// Compilar: typst compile --root . --font-path Fonts examples/presets/hojas.typ
#import "../../src/lib.typ": *

#let rotulo = [Company geometric design]
#let frase = [*Lorem ipsum* dolor sit amet, the consectetuer adipiscing elit, sed diam nonummy nibh]
#let flor = (
  composicion: "flor",
  frase: [*Lorem ipsum is a adipiscing business elit.* \ Lorem ipsum dolor sitare amet, consectetuer the adipiscing elit, sed diam],
  rotulo: rotulo, pie: [Abstract \ Design], etiqueta: [Business],
  nota: [Lorem ipsum dolor sitare amet, consectetuer the adipiscing elit, sed.],
)

// ── las tres portadas de la referencia (380 × 528, la proporción de la captura) ──
#let ref = (1080, 1500)
#carteles.hojas([Yellow \ &Blue], formato: ref, ..flor)
#carteles.hojas([Cover \ Gradient \ Shapes], formato: ref, composicion: "diagonal", frase: frase, rotulo: rotulo)
#carteles.hojas([Geo- \ Metric], formato: ref, composicion: "patron", frase: frase, rotulo: [Geometric design])

// ── el retrato 1080×1350 (por defecto), el cuadrado y la story ──
#carteles.hojas([Yellow \ &Blue], ..flor)
#carteles.hojas([Cover \ Gradient \ Shapes], formato: sizes.instagram, composicion: "diagonal", frase: frase, rotulo: rotulo)
#carteles.hojas([Geo- \ Metric], formato: sizes.story, composicion: "patron", frase: frase, rotulo: [Geometric design])

// ── apaisado (twitter, 1600×900) ──
#carteles.hojas([Yellow \ &Blue], formato: sizes.twitter, ..flor)
#carteles.hojas([Cover \ Gradient \ Shapes], formato: sizes.twitter, composicion: "diagonal", frase: frase, rotulo: rotulo)
#carteles.hojas([Geo- \ Metric], formato: sizes.twitter, composicion: "patron", frase: frase, rotulo: [Geometric design])

// ── paleta propia por tema (naranja y verde azulado sobre crema) ──
#carteles.hojas([Gracia \ sobre gracia], composicion: "patron",
  frase: [*Juan 1:16* — Porque de su plenitud tomamos todos, y gracia sobre gracia.],
  rotulo: [Evangelio de Juan],
  tema: (fondo: rgb("#fbf6ea"), tinta: rgb("#1b1b1b"), suave: rgb("#33302a"),
         acento: rgb("#e76f51"), hondo: rgb("#1f6f78")))

// ── casos límite: título largo (se parte y se achica), frase larga, sin
// rótulo ni párrafo ──
#carteles.hojas([El que tiene entendimiento], composicion: "diagonal",
  frase: [*Apocalipsis 13:18.* Aquí hay sabiduría. El que tiene entendimiento, cuente el número de la bestia, pues es número de hombre. Y su número es seiscientos sesenta y seis.],
  rotulo: [Sabiduría y entendimiento])
#carteles.hojas([Sola fide], composicion: "flor", formato: sizes.instagram)
#carteles.hojas([Soli Deo gloria], composicion: "patron", formato: sizes.instagram,
  frase: [Lo que se hace, para la gloria de Dios. Lo que se hace, para la gloria de Dios. Lo que se hace, para la gloria de Dios.])
