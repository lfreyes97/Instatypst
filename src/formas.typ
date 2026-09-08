// ─────────────────────────────────────────────────────────────
//  formas.typ — formas dibujadas con SVG embebido, no con el
//  path()/curve() nativo de Typst.
//
//  Arquitectura: este módulo es un NAMESPACE (mismo patrón que
//  color-tokens/font-tokens — se importa con `as formas`, nunca con
//  `import: *`), no una función. "bocadillo" es una geometría entre
//  varias (cinta, y a futuro círculo con muesca, estrella, blob…), no el
//  nombre del sistema — por eso las funciones se llaman `formas.bocadillo`/
//  `formas.cinta`, nunca `forma-*` sueltas en el top-level de lib.typ.
//  Cada geometría nueva es una función más aquí, todas bajo el mismo
//  namespace; ninguna es "la" forma.
//
//  Por qué SVG: un contorno COMPUESTO (rect redondeado + cola de
//  bocadillo en un solo trazo, sin costura) es trivial en SVG (<path
//  d="..."> con arcos `A` para las esquinas y líneas `L` para la cola) y
//  bastante más trabajoso con curve() nativo de Typst — el primer
//  intento fue box(fondo) + curve(cola) superpuestos a mano, con un
//  margen de error (`altura - 1.5pt`) para tapar la costura entre las
//  dos piezas. Con SVG nunca hay dos piezas: un solo `<path>` es el
//  contorno entero, sin importar cuán compuesta sea la geometría.
//
//  Typst decodifica SVG sin que exista un archivo en disco — el string
//  se arma en este mismo archivo interpolando los números:
//
//    #image(bytes(svg-string), format: "svg", width: .., height: ..)
//
//  Gotcha encontrado armando el primer path: un `+` de continuación de
//  string AL INICIO de una línea de código NO continúa la expresión de
//  la línea de arriba — Typst lo lee como un `+` unario suelto sobre el
//  string siguiente, y falla con "cannot apply unary '+' to string". Por
//  eso el `d=` se arma como un array de piezas + `.join(" ")`, nunca
//  concatenando con saltos de línea de por medio. Aplica a cualquier
//  geometría nueva que se agregue aquí.
//
//  Blurs: ya implementado — ver `aura()` al final del archivo, que usa
//  `<feGaussianBlur>` sobre un `<g>` de círculos superpuestos. Pendiente
//  todavía (a propósito no implementado): <linearGradient>/
//  <radialGradient> en el `fill` de un `<path>` (para bocadillo/cinta/
//  blob con degradado en vez de color plano) y `opacity`/gradientes de
//  opacidad para fades — nada de eso es fácil de lograr con Typst nativo
//  sobre un contorno compuesto. Cuando se retome, van como parámetros
//  nuevos en cada `formas.*` (p. ej. `formas.bocadillo(...,
//  gradiente: (color, color))`), no como un sistema aparte.
// ─────────────────────────────────────────────────────────────

// Path SVG de un bocadillo (speech bubble): rect redondeado con una cola
// triangular integrada en el MISMO contorno. Todos los tamaños son
// números sin unidad (coordenadas del viewBox) — el llamador los pasa ya
// convertidos desde pt. Privada: el nombre expuesto es `formas.bocadillo`.
#let _svg-bocadillo(w, h, r, tail-x, tail-w, tail-h, hex) = {
  let d = (
    "M", str(r), "0",
    "H", str(w - r),
    "A", str(r), str(r), "0 0 1", str(w), str(r),
    "V", str(h - r),
    "A", str(r), str(r), "0 0 1", str(w - r), str(h),
    "H", str(tail-x + tail-w),
    "L", str(tail-x), str(h + tail-h),
    "L", str(tail-x), str(h),
    "H", str(r),
    "A", str(r), str(r), "0 0 1", "0", str(h - r),
    "V", str(r),
    "A", str(r), str(r), "0 0 1", str(r), "0",
    "Z",
  ).join(" ")
  "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h + tail-h) + "'><path d='" + d + "' fill='" + hex + "'/></svg>"
}

// formas.bocadillo(...) — la FORMA sola (sin texto encima), lista para
// usar como fondo de cualquier bloque — mismo espíritu que bq-frame() en
// blockquotes.typ. Devuelve contenido ya dimensionado a (w, h + tail-h);
// quien la use pone su propio texto encima con place(top + left) sobre
// ese mismo ancho, dentro de un box() que envuelva a ambos (dos place()
// sueltos, uno tras otro sin un contenedor en común, NO comparten
// origen — cada uno abre su propio marco de coordenadas en el punto de
// flujo donde aparece).
//
// `lado:` "izq" | "der" | "centro" — posición de la cola.
#let bocadillo(w: 210pt, h: 140pt, r: 18pt, lado: "izq", tail-w: 28pt, tail-h: 22pt, fill: black) = {
  let w-n = w / 1pt
  let h-n = h / 1pt
  let r-n = r / 1pt
  let tw-n = tail-w / 1pt
  let th-n = tail-h / 1pt
  let tail-x = if lado == "izq" {
    r-n + 8
  } else if lado == "der" {
    w-n - r-n - 8 - tw-n
  } else {
    w-n / 2 - tw-n / 2
  }
  image(
    bytes(_svg-bocadillo(w-n, h-n, r-n, tail-x, tw-n, th-n, fill.to-hex())),
    format: "svg",
    width: w,
    height: h + tail-h,
  )
}

// Path SVG de una cinta (ribbon/banner): rectángulo con los dos extremos
// cortados en V hacia adentro — el hexágono clásico de "banner". Privada:
// el nombre expuesto es `formas.cinta`.
#let _svg-cinta(w, h, muesca, hex) = {
  let d = (
    "M", "0", "0",
    "L", str(w), "0",
    "L", str(w - muesca), str(h / 2),
    "L", str(w), str(h),
    "L", "0", str(h),
    "L", str(muesca), str(h / 2),
    "Z",
  ).join(" ")
  "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'><path d='" + d + "' fill='" + hex + "'/></svg>"
}

// formas.cinta(...) — la FORMA sola (sin texto encima), mismo espíritu
// que formas.bocadillo(). `muesca:` controla cuánto se hunde la V de cada
// extremo (más grande = punta más afilada).
#let cinta(w: 260pt, h: 60pt, muesca: 16pt, fill: black) = {
  let w-n = w / 1pt
  let h-n = h / 1pt
  let m-n = muesca / 1pt
  image(
    bytes(_svg-cinta(w-n, h-n, m-n, fill.to-hex())),
    format: "svg",
    width: w,
    height: h,
  )
}

// ── Blobs orgánicos — porteados de Assets/shapes.2svg ──
// Illustrator exportó 6 siluetas orgánicas (curvas bezier `c`/`C` de
// verdad, no arcos ni líneas rectas como bocadillo/cinta) dentro de un
// lienzo de 750×500 con las 6 mezcladas y texto de muestra encima. Cada
// `d=` de acá es EXACTAMENTE el original sin tocar (ni una coma movida) —
// lo único que se ajustó fue el `viewBox`, recortado al bounding box real
// de cada silueta por separado. Ese bbox NO se calculó a mano (los
// comandos `c` usan coordenadas relativas — sumarlas a mano es la forma
// perfecta de introducir un error invisible): se renderizó cada trazo
// aislado a 4x con rsvg-convert y se midió con PIL.Image.getbbox() sobre
// el canal alfa. Como el viewBox de SVG admite un origen (min-x, min-y)
// distinto de (0,0), recortar es solo cambiar 4 números — el `d=` no
// necesita traducirse ni un poco.
//
// `fill:`/tamaño son lo único parametrizable — la silueta es arte fijo,
// no una fórmula (a diferencia de bocadillo/cinta, que si reciben radio,
// ancho de cola, etc.).
#let _blobs = (
  nube: (vb: (508.50, 272.75, 192.25, 153.25), d: "M634.707,273.047c-16.034-0.682-30.895,4.786-42.847,14.455 c-13.299,10.76-28.977,17.262-45.395,17.988c-0.3,0.013-0.6,0.03-0.901,0.051c-19.554,1.349-35.464,18.958-36.802,40.754 c-1.575,25.661,16.627,47.023,39.303,47.023c0.544,0,1.086-0.012,1.625-0.037c13.706-0.621,27.244,3.989,37.631,13.981 c11.996,11.541,27.618,18.521,44.706,18.521c38.176,0,69.06-34.818,68.505-77.529 C700.008,307.909,670.866,274.585,634.707,273.047z"),
  nota: (vb: (293.25, 277.75, 154.50, 153.25), d: "M293.329,292.405v99.928c0,7.962,6.596,14.416,14.733,14.416h87.131 c8.137,0,14.733,6.454,14.733,14.416v9.35c0,0,37.552,5.636,37.552-34.839c0-0.129,0.005-0.26,0.008-0.389h0.029v-1.506v-47.301 v-54.074c0-7.962-6.596-14.416-14.733-14.416H308.062C299.925,277.99,293.329,284.444,293.329,292.405z"),
  hoja: (vb: (59.25, 263.75, 163.25, 163.25), d: "M222.39,345.386c0,45.02-36.496,81.516-81.516,81.516s-81.516-36.496-81.516-81.516 s36.496-81.516,81.516-81.516c22.189,0,15.552,34.744,30.251,49.126C186.248,327.794,222.39,322.555,222.39,345.386z"),
  burbuja: (vb: (526.00, 70.00, 163.75, 173.75), d: "M689.324,169.042l-9.527-68.152c-2.13-15.238-14.862-26.767-30.236-27.378l-84.124-3.344 c-17.053-0.678-31.601,12.223-32.967,29.235l-6.325,78.752c-1.56,19.43,14.565,35.68,34.006,34.269l54.321-3.943v35.216 l24.631-14.263c9.69-5.611,17.013-14.224,21.092-24.274C678.509,203.792,691.868,187.239,689.324,169.042z"),
  mancha: (vb: (292.00, 69.00, 162.75, 175.75), d: "M446.638,185.902c0.607-1.253,1.185-2.522,1.729-3.81c0.18-0.427,0.338-0.863,0.51-1.294 c0.442-1.099,0.863-2.207,1.258-3.329c0.156-0.446,0.306-0.893,0.454-1.342c0.408-1.229,0.787-2.47,1.137-3.725 c0.084-0.301,0.175-0.598,0.256-0.9c0.432-1.62,0.823-3.256,1.156-4.914c0.002-0.008,0.003-0.016,0.004-0.025 c0.315-1.572,0.573-3.164,0.796-4.767c0.057-0.41,0.105-0.821,0.157-1.232c0.155-1.251,0.28-2.51,0.377-3.778 c0.034-0.446,0.074-0.889,0.102-1.336c0.099-1.642,0.165-3.292,0.165-4.959c0,0,0,0,0,0v0c0-44.909-36.406-81.316-81.316-81.316 c-44.909,0-81.316,36.406-81.316,81.316c0,44.91,36.406,81.316,81.316,81.316v12.859l40.567-23.491 c13.169-7.626,23.662-18.633,30.715-31.542c0.198-0.36,0.388-0.725,0.581-1.088C445.746,187.668,446.209,186.794,446.638,185.902z"),
  tarjeta: (vb: (62.25, 78.50, 163.25, 156.75), d: "M190.767,234.998l-100.013-9.931c-16.117-1.6-28.396-15.159-28.396-31.355v-73.583 c0-16.196,12.279-29.755,28.396-31.355l100.013-9.931c18.542-1.841,34.623,12.722,34.623,31.355v93.446 C225.39,222.276,209.308,236.839,190.767,234.998z"),
)
// formas.blob(nombre, ...) — nombre: "nube" | "nota" | "hoja" | "burbuja"
// | "mancha" | "tarjeta" (ver arriba). `h: auto` mantiene la proporción
// original de esa silueta; pásalo explícito para forzar otra.
#let blob(nombre, w: 180pt, h: auto, fill: black) = {
  let b = _blobs.at(nombre, default: none)
  if b == none {
    panic("formas.blob: nombre desconocido \"" + nombre + "\" — disponibles: " + _blobs.keys().join(", "))
  }
  let (x0, y0, bw, bh) = b.vb
  let h = if h == auto { w * bh / bw } else { h }
  let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='" + str(x0) + " " + str(y0) + " " + str(bw) + " " + str(bh) + "'><path d='" + b.d + "' fill='" + fill.to-hex() + "'/></svg>"
  image(bytes(svg), format: "svg", width: w, height: h)
}

// ── Blur — fondo de manchas de color desenfocadas ──
// Técnica vista en un generador de fondos tipo "blurry blob" (SVG con
// <feGaussianBlur> sobre un <g> de círculos superpuestos) — la clase de
// cosa que motivó este archivo ("ya entrados podemos hacer gradientes,
// blurs, fades"). Los blob-de-fondo que ya existían en social.typ
// (bg()+blob(), ver cita-canvas) son círculos de opacidad baja SIN
// desenfoque — esto es un efecto distinto (colores sólidos que se
// funden entre sí por el blur, no transparencia).
//
// `colores:` se reparten en diagonal automáticamente (arriba-derecha a
// abajo-izquierda); pasa `posiciones:` si quieres control manual. Nota
// de diseño, no bug: colores muy próximos en tono (p. ej. verde entre
// rojo y oro) se funden en un tono neutro/muddy donde se superponen —
// es mezcla óptica real, esperable con cualquier técnica de blur. Para
// que las zonas se distingan, usa colores con más separación de tono.
#let _svg-aura(w, h, blur, circulos) = {
  let elipses = circulos.map(c => "<circle cx='" + str(c.at(0)) + "' cy='" + str(c.at(1)) + "' r='" + str(c.at(2)) + "' fill='" + c.at(3) + "'/>").join("")
  (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " " + str(h) + "'>",
    "<defs><filter id='b' x='-100%' y='-100%' width='400%' height='400%'><feGaussianBlur stdDeviation='" + str(blur) + "'/></filter></defs>",
    "<g filter='url(#b)'>" + elipses + "</g></svg>",
  ).join("")
}

// formas.aura(colores, ...) — `r`/`blur` en `auto` escalan con (w, h);
// `posiciones:` (array de (dx, dy) en pt, mismo largo que `colores`)
// pisa el reparto diagonal automático.
#let aura(colores, w: 400pt, h: 400pt, r: auto, blur: auto, posiciones: auto) = {
  let w-n = w / 1pt
  let h-n = h / 1pt
  let n = colores.len()
  let r-n = if r == auto { calc.min(w-n, h-n) * 0.38 } else { r / 1pt }
  let blur-n = if blur == auto { r-n * 0.55 } else { blur / 1pt }
  let centros = if posiciones == auto {
    range(n).map(i => {
      let t = if n == 1 { 0.5 } else { i / (n - 1) }
      (w-n * (0.3 + 0.4 * t), h-n * (0.3 + 0.4 * (1 - t)))
    })
  } else {
    posiciones.map(p => (p.at(0) / 1pt, p.at(1) / 1pt))
  }
  let circulos = range(n).map(i => (centros.at(i).at(0), centros.at(i).at(1), r-n, colores.at(i).to-hex()))
  image(bytes(_svg-aura(w-n, h-n, blur-n, circulos)), format: "svg", width: w, height: h)
}
