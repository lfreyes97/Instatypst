// Exporta cada figura a lápiz como una página del tamaño exacto de la figura, sin fondo, para
// usarlas desde otros programas (LaTeX, Word…).
//   typst compile --root . --font-path Fonts trabajos/libro-ilustrado/figuras-export.typ "salida/figuras-lapiz/fig-{p}.svg"
//   typst compile --root . --font-path Fonts trabajos/libro-ilustrado/figuras-export.typ "salida/figuras-lapiz/fig-{p}.png" --ppi 400
// El orden es: 1 finca, 2 memorial, 3 bandera (ver export-figuras.sh para renombrar y pasar a PDF).
#import "figuras-lapiz.typ": finca-lapiz, memorial-lapiz, bandera-lapiz
#set page(width: auto, height: auto, margin: 3pt, fill: none)
#finca-lapiz()
#pagebreak()
#memorial-lapiz()
#pagebreak()
#bandera-lapiz()
