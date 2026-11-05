// ─────────────────────────────────────────────────────────────
//  mesa/_papel.typ — la hoja de papel, dibujada como SVG
//
//  Una sola imagen vectorial por hoja, con los filtros de SVG (que Typst
//  resuelve al exportar) en vez de capas de rectángulos:
//    · trapecio      la perspectiva: el borde superior más corto que el inferior
//    · borde         un desplazamiento fino por turbulencia: el corte no es una regla
//    · grano y manchas  dos turbulencias (fina y lenta) en tinta parda, muy suaves
//    · luz y curvatura  un degradado a lo largo de la dirección de la luz: brillo
//                    en el lado que da a la ventana y una banda de sombra en el
//                    opuesto, como si la hoja se alabeara un poco
//
//  Sin ninguna imagen embebida: no pesa nada y la semilla fija el aspecto.
// ─────────────────────────────────────────────────────────────

#let _hex(c) = c.rgb().to-hex()
#let _n(x) = str(calc.round(x, digits: 3))

// Dibuja la hoja.
//   ancho, alto   la hoja visible (ancho medio, en longitud)
//   perspectiva   fracción en que el borde superior es más corto (0 = rectángulo)
//   luz           ángulo (en el marco de la hoja) hacia el que viaja la luz;
//                 0deg = de izquierda a derecha, 90deg = de arriba abajo
//   curvatura     0–1: fuerza de la banda de sombra
//   grano         0–1: fuerza del grano y las manchas
//   borde         0–1: irregularidad del corte (0 = recto)
#let dibujar-papel(
  ancho, alto,
  papel: rgb("#fff9ec"), trazo: rgb("#e6dcc0"),
  perspectiva: 0, luz: 45deg, curvatura: 0.5, grano: 0.6, borde: 0.5,
  semilla: 3,
) = {
  // unidades del SVG: décimas de milímetro
  let k = perspectiva
  let w = ancho / 1mm * 10 * (1 + k)
  let h = alto / 1mm * 10
  let top = ancho / 1mm * 10 * (1 - k)
  let bot = ancho / 1mm * 10 * (1 + k)
  let (x0t, x1t) = (w / 2 - top / 2, w / 2 + top / 2)
  let (x0b, x1b) = (w / 2 - bot / 2, w / 2 + bot / 2)
  let puntos = _n(x0t) + "," + "0 " + _n(x1t) + ",0 " + _n(x1b) + "," + _n(h) + " " + _n(x0b) + "," + _n(h)

  // la luz: eje del degradado, de lado a lado de la hoja
  let (cx, cy) = (w / 2, h / 2)
  let largo = calc.abs(w * calc.cos(luz)) + calc.abs(h * calc.sin(luz))
  let (dx, dy) = (calc.cos(luz) * largo / 2, calc.sin(luz) * largo / 2)

  let g = calc.max(0, calc.min(grano, 1))
  let cv = calc.max(0, calc.min(curvatura, 1))
  let b = calc.max(0, calc.min(borde, 1))

  let svg = (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + _n(w) + " " + _n(h) + "'>"
    + "<defs>"
    + "<clipPath id='p'><polygon points='" + puntos + "'/></clipPath>"
    // corte irregular
    + "<filter id='corte' x='-3%' y='-3%' width='106%' height='106%'>"
    + "<feTurbulence type='fractalNoise' baseFrequency='0.07' numOctaves='2' seed='" + str(semilla) + "' result='r'/>"
    + "<feDisplacementMap in='SourceGraphic' in2='r' scale='" + _n(b * 5) + "' xChannelSelector='R' yChannelSelector='G'/>"
    + "</filter>"
    // grano fino (alfa = ruido)
    + "<filter id='grano' x='0' y='0' width='100%' height='100%'>"
    + "<feTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2' seed='" + str(semilla + 1) + "'/>"
    + "<feColorMatrix type='matrix' values='0 0 0 0 0.36  0 0 0 0 0.27  0 0 0 0 0.15  1.1 0 0 0 -0.42'/>"
    + "</filter>"
    // manchas lentas, la fibra desigual del papel
    + "<filter id='mancha' x='0' y='0' width='100%' height='100%'>"
    + "<feTurbulence type='fractalNoise' baseFrequency='0.006 0.004' numOctaves='3' seed='" + str(semilla + 2) + "'/>"
    + "<feColorMatrix type='matrix' values='0 0 0 0 0.55  0 0 0 0 0.42  0 0 0 0 0.22  0.9 0 0 0 -0.38'/>"
    + "</filter>"
    // luz + curvatura: brillo por donde entra, sombra por donde sale
    + "<linearGradient id='luz' gradientUnits='userSpaceOnUse' x1='" + _n(cx - dx) + "' y1='" + _n(cy - dy) + "' x2='" + _n(cx + dx) + "' y2='" + _n(cy + dy) + "'>"
    + "<stop offset='0' stop-color='#fff' stop-opacity='0.14'/>"
    + "<stop offset='0.4' stop-color='#fff' stop-opacity='0'/>"
    + "<stop offset='0.78' stop-color='#2a1a05' stop-opacity='" + _n(0.03 * cv) + "'/>"
    + "<stop offset='0.93' stop-color='#2a1a05' stop-opacity='" + _n(0.13 * cv) + "'/>"
    + "<stop offset='1' stop-color='#2a1a05' stop-opacity='" + _n(0.05 * cv) + "'/>"
    + "</linearGradient>"
    + "</defs>"
    + "<g filter='url(#corte)'>"
    + "<polygon points='" + puntos + "' fill='" + _hex(papel) + "' stroke='" + _hex(trazo) + "' stroke-width='5'/>"
    + "<g clip-path='url(#p)'>"
    + "<rect width='" + _n(w) + "' height='" + _n(h) + "' filter='url(#mancha)' opacity='" + _n(0.32 * g) + "'/>"
    + "<rect width='" + _n(w) + "' height='" + _n(h) + "' filter='url(#grano)' opacity='" + _n(0.7 * g) + "'/>"
    + "<rect width='" + _n(w) + "' height='" + _n(h) + "' fill='url(#luz)'/>"
    + "</g></g></svg>"
  )
  image(bytes(svg), format: "svg", width: ancho * (1 + k), height: alto)
}
