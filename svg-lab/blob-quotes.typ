// Blob como contenedor de cita — svg-lab, rama feature/fondos-svg.
// Compilar: typst compile --root . svg-lab/blob-quotes.typ
#import "../src/lib.typ": *

// Inset relativo por silueta (fracción del ancho/alto del blob).
// Las formas son irregulares: nube/mancha/hoja tienen aire central,
// nota/tarjeta/burbuja son más rectangulares y admiten bloque más ancho.
#let _insets = (
  nube: (x: 0.22, y: 0.30),
  nota: (x: 0.14, y: 0.22),
  hoja: (x: 0.24, y: 0.30),
  burbuja: (x: 0.16, y: 0.24),
  mancha: (x: 0.22, y: 0.28),
  tarjeta: (x: 0.14, y: 0.22),
)

#let blob-quote(nombre, cita, autor, w: 700pt, fill: rgb("#0F172A"), theme: theme.base) = {
  let ins = _insets.at(nombre)
  // alto proporcional a la silueta (igual que formas.blob con h:auto)
  align(center + horizon)[
    #box(width: w)[
      #place(top + left)[#formas.blob(nombre, w: w, fill: fill)]
      #place(top + left, dx: w * ins.x, dy: 0pt)[
        #block(width: w * (1 - 2 * ins.x), height: 100%)[
          #align(center + horizon)[
            #text(font: theme.fonts.display, size: 34pt, weight: 700, fill: white, cita)
            #v(12pt)
            #text(font: theme.fonts.body, size: 22pt, fill: white.transparentize(25%), "— " + autor)
          ]
        ]
      ]
    ]
  ]
}

// Altura del box = ancho * (bh/bw) de cada silueta para que el texto
// se centre verticalmente contra la forma real, no contra un alto fijo.
// (proporciones vb de formas.typ: nube 192x153, nota 154x153, hoja 163x163,
//  burbuja 163x173, mancha 162x175, tarjeta 163x156)
#let _ratio = (
  nube: 153.25 / 192.25,
  nota: 153.25 / 154.50,
  hoja: 163.25 / 163.25,
  burbuja: 173.75 / 163.75,
  mancha: 175.75 / 162.75,
  tarjeta: 156.75 / 163.25,
)

#let blob-page(nombre, cita, autor, fill) = {
  let w = 700pt
  let h = w * _ratio.at(nombre)
  let ins = _insets.at(nombre)
  canvas(sizes.instagram, [
    #bg(white)
    #align(center + horizon)[
      #box(width: w, height: h)[
        #place(top + left)[#formas.blob(nombre, w: w, fill: fill)]
        #place(top + left, dx: w * ins.x)[
          #block(width: w * (1 - 2 * ins.x), height: h)[
            #align(center + horizon)[
              #text(font: theme.base.fonts.display, size: 32pt, weight: 700, fill: white, cita)
              #v(10pt)
              #text(font: theme.base.fonts.body, size: 21pt, fill: white.transparentize(25%), "— " + autor)
            ]
          ]
        ]
      ]
    ]
  ])
}

#blob-page("nube", [La paciencia todo lo alcanza.], "Teresa de Ávila", rgb("#0EA5E9"))
#blob-page("nota", [El que no vive para servir, no sirve para vivir.], "Proverbio", rgb("#16A34A"))
#blob-page("hoja", [Natura non facit saltus.], "Linneo", rgb("#D97706"))
#blob-page("burbuja", [Hablar es plata, callar es oro.], "Refrán", rgb("#7C3AED"))
#blob-page("mancha", [El corazón tiene razones que la razón no entiende.], "Pascal", rgb("#DC2626"))
#blob-page("tarjeta", [Menos, pero mejor.], "Dieter Rams", rgb("#0F172A"))
