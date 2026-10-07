// Campaña Warfield — cita 09 · La elección
// Formato: twitter (1600×900). Papel claro y tipografía editorial del Acto II.
// Compilar: typst compile --root . --font-path Fonts campana/09-elegidos-para-ser-buenos.typ
#import "../src/lib.typ": *
#import "_comun.typ": tema-campana, firma

#let tema = tema-campana("papel-noche", "editorial-clasico")
#let cuerpo = tema.fonts.body

#canvas(sizes.twitter, theme: tema)[
  #superbg.superbg((capas: (
    (tipo: "plano", color: tema.colors.white),
    (tipo: "ruido", color: tema.colors.dark, opacidad: 2.5%),
  )), size: sizes.twitter, theme: tema)

  #place(top + left, dx: 120pt, dy: 300pt)[
    #block(width: 1360pt)[
      #align(center)[
        #text(font: cuerpo, size: 82pt, style: "italic", fill: tema.colors.dark)[
          No somos escogidos porque seamos \
          buenos; somos escogidos para que \
          podamos ser buenos.
        ]
      ]
    ]
  ]

  #place(top + left, dx: 80pt, dy: 790pt)[
    #block(width: 1440pt)[
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        column-gutter: 1fr,
        [#firma(tema, fuente: "La elección", alineacion: left, size: 17pt)],
        [#footer("Presuposicionalismo.com", color: tema.colors.dark.transparentize(24%), scale: 1.0, theme: tema)],
      )
    ]
  ]
]
