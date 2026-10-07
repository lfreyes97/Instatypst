// ─────────────────────────────────────────────────────────────
//  _comun.typ — sistema de diseño de la campaña Warfield
//
//  La versión anterior de este archivo era un wrapper mínimo (solo
//  evitaba repetir el handle). El rediseño lo convierte en el lugar
//  donde vive la DIRECCIÓN DE ARTE de la campaña, porque hay tres
//  decisiones que deben ser idénticas en las 20 tarjetas o la campaña
//  deja de leerse como una campaña:
//
//    1. La SUPERFICIE (`tonos`): cada tarjeta se imprime sobre un papel
//       o sobre una tinta, nunca sobre blanco puro. 4 familias
//       cromáticas × 2 superficies = 8 tonos.
//    2. La FIRMA (`firma`): autor + ensayo siempre con la misma
//       anatomía (filete corto · versalitas espaciadas · ensayo en
//       itálica). Antes cada plantilla blockquote-* ponía la atribución
//       a su manera (versalitas, "— Autor · fuente", rotada…), así que
//       20 tarjetas tenían ~6 firmas distintas.
//    3. El LIENZO (`lienzo`): handle, fondo, blob y pie derivados del
//       tono, no elegidos a mano tarjeta por tarjeta.
//
//  Lo que sigue siendo decisión de cada tarjeta (y por eso NO está
//  acá): qué tono, qué pareja tipográfica, qué plantilla blockquote-*,
//  qué tamaño de cuerpo y qué formato de lienzo.
//
//  POR QUÉ LAS 20 PASAN `autor: none, fuente: none` A LA PLANTILLA:
//  las blockquote-* pintan su atribución con `gray.darken(10..20%)`
//  fijo — ilegible sobre cualquier superficie oscura. Al apagarla y
//  componer `firma()` abajo, (a) la campaña gana una sola firma y (b)
//  las superficies de tinta se vuelven posibles. Única excepción
//  documentada: la 19, que usa la atribución rotada de
//  `blockquote-lateral` porque esa barra vertical ES la plantilla.
// ─────────────────────────────────────────────────────────────

#import "../src/lib.typ": theme, pairings, color-tokens, cita-canvas, sizes

#let tk = color-tokens.token

// ===== 1. TONOS — 4 familias cromáticas × 2 superficies =====
//
//  bg      fondo del lienzo y relleno interno de las plantillas que
//          traen caja propia (editorial/card/poetry) — se mapea a
//          `colors.white` para que esas cajas no abran un rectángulo
//          blanco encima del papel/tinta.
//  tinta   color del cuerpo de la cita → `colors.dark`.
//  acento  filete, comilla, barra lateral, resaltado → `colors.primary`
//          / `colors.accent`. Siempre de croma medio: tiene que leerse
//          contra `bg` en los dos sentidos.
//  brillo  manchas de fondo del lienzo → `colors.secondary`. Puede ser
//          claro: va al 14-18 % de opacidad.
//
//  `acento`/`brillo` se eligen a propósito de un matiz DISTINTO al de
//  `bg`/`tinta` (no un tono más oscuro/claro de la misma familia): la
//  primera versión de estos 8 tonos sacaba los 4 colores de la misma
//  familia cromática y el resultado leía a dúo-tono plano. Las parejas
//  de acá están verificadas con contraste WCAG ≥ 4.1:1 contra `bg`.
#let tonos = (
  // familia VINO — identidad del calvinismo (Acto I) + el barro (08)
  "papel-vino": (
    bg: tk("marfil"), tinta: tk("caoba"), acento: tk("petróleo"), brillo: tk("caramelo"),
  ),
  "tinta-vino": (
    bg: tk("wine"), tinta: tk("marfil"), acento: tk("turquesa"), brillo: tk("azafrán"),
  ),
  // familia NOCHE — la obra de la gracia (Acto II)
  "papel-noche": (
    bg: tk("cyan-50"), tinta: tk("navy"), acento: tk("escarlata"), brillo: tk("dorado"),
  ),
  "tinta-noche": (
    bg: tk("navy"), tinta: tk("sky-100"), acento: tk("mostaza"), brillo: tk("coral"),
  ),
  // familia SALVIA — el Espíritu Santo (Acto III)
  "papel-salvia": (
    bg: tk("green-50"), tinta: tk("esmeralda").darken(72%), acento: tk("granate"), brillo: tk("azafrán"),
  ),
  "tinta-salvia": (
    bg: tk("esmeralda").darken(78%), tinta: tk("pergamino"), acento: tk("dorado"), brillo: tk("rosa-mexicano"),
  ),
  // familia GRAFITO — polémica, historia, distancia crítica (Acto IV)
  "papel-grafito": (
    bg: tk("slate-50"), tinta: tk("stone-850"), acento: tk("teja"), brillo: tk("petróleo"),
  ),
  "tinta-grafito": (
    bg: tk("stone-850"), tinta: tk("slate-50"), acento: tk("tomate"), brillo: tk("turquesa"),
  ),
)

#let tono(nombre) = {
  if not (nombre in tonos) {
    panic("tono desconocido: " + nombre + " — disponibles: " + tonos.keys().join(", "))
  }
  tonos.at(nombre)
}

// ¿La superficie es oscura? (decide el sentido de los derivados: un
// panel sobre papel se oscurece, sobre tinta se aclara)
#let es-tinta(nombre) = nombre.starts-with("tinta-")

// ===== 2. TEMA — tono + pareja tipográfica =====
#let tema-campana(nombre-tono, tipografia) = {
  let t = tono(nombre-tono)
  let oscuro = es-tinta(nombre-tono)
  let base = (theme.define)(
    nombre-tono + "+" + tipografia,
    colors: (
      primary: t.acento,
      secondary: t.brillo,
      accent: t.acento,
      dark: t.tinta,
      light: if oscuro { t.bg.lighten(10%) } else { t.bg.darken(5%) },
      white: t.bg, // ← la clave: las cajas internas heredan el papel/tinta
    ),
    fonts: (pairings.resolve)(tipografia),
  )
  // Se guarda el nombre de la pareja tipográfica tal cual (sin pasar por
  // `theme.define`, que no reserva campos para esto) porque `lienzo()`
  // la necesita para decidir si corresponde el logo serif — ver más abajo.
  base + (tipografia: tipografia)
}

// ===== LOGO — solo para parejas de cuerpo serif =====
//
//  eb-garamond/libre-baskerville/cormorant-garamond/literata son las
//  únicas fuentes de cuerpo serif de la biblioteca (ver font-tokens.typ);
//  el logotipo de Assets/Logo.svg es en sí un remate serif, así que solo
//  combina con esas 4 parejas — con un cuerpo de palo seco se deja el
//  pie en puro texto.
#let tipografias-serif = ("editorial-clasico", "manuscrito-calido", "revival-vintage", "lectura-editorial")

// El SVG trae `fill/stroke="currentColor"` (pensado para CSS, donde
// hereda el color del texto circundante). Typst no lo resuelve solo —
// cae a negro sin avisar — así que se recolorea a mano reemplazando el
// literal por la tinta del tema, para que el logo lea igual de bien
// sobre papel que sobre tinta.
//
// Devuelve una FUNCIÓN (altura => imagen), no la imagen ya armada: la
// consume `footer()` (social.typ), que mide el alto real del handle (ya
// escalado por `pie-scale`) y se lo pasa, para que logo y texto guarden
// siempre la misma altura — ver el comentario de `footer()`.
#let logo-presuposicionalismo(tinta) = {
  let svg = read("../Assets/Logo.svg").replace("currentColor", tinta.to-hex())
  (height) => image(bytes(svg), format: "svg", height: height)
}

// Relleno de `#highlight()`: el acento translúcido, calibrado distinto
// según la superficie (sobre tinta hace falta más transparencia para
// que el acento claro no tape la letra).
#let realce(tema, oscuro: false) = {
  if oscuro { tema.colors.accent.transparentize(76%) } else { tema.colors.accent.transparentize(70%) }
}

// ===== 3. FIRMA — una sola anatomía de atribución para las 20 =====
//
//  filete corto en acento · AUTOR en versalitas espaciadas · ensayo en
//  itálica · (opcional) nota editorial en cuerpo menor.
//
//  `nota:` existe por las tarjetas 19/20 (Darwin): son palabras *sobre*
//  o *citadas por* Warfield, no suyas, y la aclaración tiene que viajar
//  con la imagen si circula suelta.
#let firma(
  tema,
  autor: "B.B. Warfield",
  fuente: none,
  nota: none,
  alineacion: left,
  size: 24pt,
  filete: true,
) = {
  let tinta = tema.colors.dark
  block(width: 100%, above: 30pt, below: 0pt)[
    #align(alineacion)[
      #if filete [
        #box(fill: tema.colors.primary, width: 64pt, height: 3pt, radius: 1.5pt)
        #v(16pt)
      ]
      #if autor != none [
        #text(font: tema.fonts.body, size: size, weight: 700, tracking: 0.16em, fill: tinta)[#upper(autor)]
        #if fuente != none { linebreak() }
      ]
      #if fuente != none [
        #text(font: tema.fonts.body, size: size * 0.86, style: "italic", fill: tinta.transparentize(32%))[#fuente]
      ]
      #if nota != none [
        #v(12pt)
        #block(width: 74%)[
          #align(alineacion)[
            #text(font: tema.fonts.body, size: size * 0.70, style: "italic", fill: tinta.transparentize(42%))[#nota]
          ]
        ]
      ]
    ]
  ]
}

// Antetítulo — etiqueta de referencia bíblica / sección, en versalitas
// espaciadas sobre el cuerpo de la cita. Solo la usa la 16.
#let antetitulo(tema, texto, size: 26pt) = block(width: 100%, below: 18pt)[
  #text(font: tema.fonts.body, size: size, weight: 700, tracking: 0.2em, fill: tema.colors.primary)[#upper(texto)]
]

// ===== 4. LIENZO =====
//
//  `footer-color` bajó de 42% a 22% de transparencia: al 42% la
//  atribución "presuposicionalismo.com" quedaba casi ilegible sobre
//  cualquier tono, papel o tinta.
//
//  `pie-scale: 1.5` — el pie (logo o handle) sale al 150% del tamaño base
//  de `footer()` (30pt → 45pt): a tamaño base el logo quedaba diminuto en
//  lienzos de 900–1920pt. Como el pie vive en el flujo (ver `cita-canvas`),
//  agrandarlo le quita aire a la cita: la 01, que iba al límite, bajó su
//  cuerpo de 104pt a 102pt para seguir cabiendo en una página. Si alguna
//  tarjeta futura se desborda, ese es el primer tornillo que aflojar.
//
//  Sin blobs ni franjas de aura: el papel/tinta queda plano y el color
//  de cada tono vive solo en el filete, la comilla, el resaltado y el
//  logo — se probaron ambos adornos de fondo (blobs tenues, franjas de
//  color a los lados) y no sumaban a la campaña.
#let lienzo(contenido, tema, size: sizes.instagram, pie-scale: 1.5) = cita-canvas(
  contenido,
  "Presuposicionalismo.com",
  size: size,
  bg-color: tema.colors.white,
  blobs: false,
  footer-color: tema.colors.dark.transparentize(28%),
  footer-scale: pie-scale,
  logo: if tema.tipografia in tipografias-serif { logo-presuposicionalismo(tema.colors.dark) } else { none },
  theme: tema,
)
