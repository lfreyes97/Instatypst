// ─────────────────────────────────────────────────────────────
//  formas.typ — formas dibujadas con SVG embebido, no con el
//  path()/curve() nativo de Typst.
//
//  Arquitectura: este módulo es un NAMESPACE (mismo patrón que
//  color-tokens/font-tokens — se importa con `as formas`, nunca con
//  `import: *`), no una función. "bocadillo" es una geometría entre
//  varias futuras (círculo con muesca, cinta, estrella, blob…), no el
//  nombre del sistema — por eso la función se llama `formas.bocadillo`,
//  no `forma-bocadillo` suelta en el top-level de lib.typ. Cada
//  geometría nueva es una función más aquí (`bocadillo`, y a futuro
//  `circulo`, `cinta`, `estrella`, ...), todas bajo el mismo namespace;
//  ninguna es "la" forma.
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
//  Pendiente (a propósito no implementado todavía — por esto se aseguró
//  este archivo como punto de partida antes de seguir): SVG soporta
//  <linearGradient>/<radialGradient> en el `fill` de un `<path>`,
//  <feGaussianBlur> como filtro, y `opacity`/gradientes de opacidad para
//  fades — nada de eso es fácil de lograr con Typst nativo sobre un
//  contorno compuesto como este. Cuando se retome, esas van como
//  parámetros nuevos en cada `formas.*` (p. ej. `formas.bocadillo(...,
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
