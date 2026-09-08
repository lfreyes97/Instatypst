// ─────────────────────────────────────────────────────────────
// ornamentos.typ — Catálogo de ornamentos tipográficos
//
// Muestra todos los glifos ornamentales (fleurons, giraldillas,
// asterismos, estrellas, asteriscos, copos, destellos, corazones,
// comillas/paréntesis ornamentados, cruces, manos, flechas y hojas)
// presentes en las tipografías de Fonts/.
//
// Los datos viven en ornamentos.json (misma carpeta), generados por:
//   python3 ornamentos/catalogar-ornamentos.py
// (escaneo con fc-scan + verificación de caras contra
// `typst fonts --variants --font-path Fonts`).
//
// Compilar (desde la raíz del repo):
//   typst compile --root . --font-path Fonts ornamentos/ornamentos.typ ornamentos/ornamentos.pdf
// ─────────────────────────────────────────────────────────────

#import "../src/lib.typ": *

#set page(paper: "a4", margin: 1.3cm, fill: rgb("#fafafa"))
#set text(font: theme.base.fonts.body, size: 9pt, fill: theme.base.colors.dark, lang: "es")
#set par(justify: false, leading: 0.9em)
#set heading(numbering: none)

#let datos = json("ornamentos.json")

#let prim = theme.base.colors.primary
#let acso = theme.base.colors.accent

// ── Presentación de categorías ──
#let cat-color = (
  "asterismo": luma(30%),
  "fleuron": rgb("#a855f7"),
  "hoja": rgb("#16a34a"),
  "estrella": rgb("#6366f1"),
  "mano": luma(55%),
  "cruz": rgb("#b45309"),
  "copo": rgb("#0284c7"),
  "destello": rgb("#f59e0b"),
  "flor": rgb("#ec4899"),
  "sello": luma(45%),
  "cita": rgb("#8b5cf6"),
  "puntuacion": luma(45%),
  "corazon": rgb("#ef4444"),
  "paren": rgb("#0ea5e9"),
  "flecha": luma(50%),
  "alfabeto": rgb("#059669"),
)

#let cat-nombre = (
  "asterismo": "asterismo",
  "fleuron": "fleurón",
  "hoja": "hoja",
  "estrella": "estrella",
  "mano": "mano",
  "cruz": "cruz",
  "copo": "copo",
  "destello": "destello",
  "flor": "flor",
  "sello": "sello",
  "cita": "comilla ornamentada",
  "puntuacion": "puntuación ornamentada",
  "corazon": "corazón",
  "paren": "paréntesis ornamentado",
  "flecha": "flecha",
  "alfabeto": "floritura alfabética",
)

// familias "lógicas" útiles primero, nerd fonts al final
#let prioridad = (
  "Cormorant", "Cormorant_Garamond", "EB_Garamond", "Libertinus_Serif",
  "Bodoni_Moda", "Ysabeau", "Ysabeau_Infant", "Ysabeau_Office", "Ysabeau_SC",
  "Inter", "Literata", "Noto_Serif", "Zen_Old_Mincho",
  "IM_Fell_English", "IM_Fell_English_SC", "IM_Fell_Double_Pica",
  "IM_Fell_Double_Pica_SC", "IM_Fell_Great_Primer", "IM_Fell_Great_Primer_SC",
  "IM_Fell_French_Canon_SC", "IM_Fell_DW_Pica_SC", "LigaSF",
  "GoogleSansCode_Nerd_Font", "ZedMono_Nerd_Font",
  "AdwaitaMono_Nerd_Font", "Iosevka_Nerd_Font",
)

// ── Fusión de variantes con glifos IDÉNTICOS ──
// El escáner agrupa por carpeta de Fonts/, así que una familia con 8 cortes
// (IM FELL) o 4 ópticos (Ysabeau) salía repetida 8/4 veces mostrando
// exactamente los mismos glifos. Verificado *renderizando* cada par lado a
// lado (no solo comparando codepoints — dos familias distintas pueden
// cubrir el mismo codepoint con un dibujo distinto): estos grupos SÍ son
// pixel-idénticos en todo lo que este catálogo muestra. Ysabeau Infant
// queda fuera a propósito: comparte los mismos 4 codepoints que
// Ysabeau/Office/SC, pero su fleurón (U+2766) es un dibujo distinto
// (una silueta de ave, no el corazón-hoja de las otras tres) — fusionarla
// habría escondido esa diferencia real.
#let grupos = (
  ("Cormorant", "Cormorant_Garamond"),
  ("Ysabeau", "Ysabeau_Office", "Ysabeau_SC"),
  (
    "IM_Fell_English", "IM_Fell_English_SC", "IM_Fell_Double_Pica",
    "IM_Fell_Double_Pica_SC", "IM_Fell_Great_Primer", "IM_Fell_Great_Primer_SC",
    "IM_Fell_French_Canon_SC", "IM_Fell_DW_Pica_SC",
  ),
  ("AdwaitaMono_Nerd_Font", "Iosevka_Nerd_Font"),
)

#let pos(carpeta) = {
  let p = prioridad.position(x => x == carpeta)
  if p == none { prioridad.len() } else { p }
}

// datos.familias, con cada grupo colapsado en una sola entrada (misma
// posición de prioridad que su primer miembro; glifos del primer miembro,
// ya que el grupo entero comparte el mismo set).
#let vistas = {
  let ya = ()
  let out = ()
  for f in datos.familias {
    if f.carpeta not in ya {
      let g = grupos.find(gr => f.carpeta in gr)
      if g == none {
        out.push((carpeta: f.carpeta.replace("_", " "), familia: f.familia, glifos: f.glifos, pos: pos(f.carpeta)))
      } else {
        let etiqueta = g.map(c => c.replace("_", " ")).join(" + ")
        out.push((carpeta: etiqueta, familia: f.familia, glifos: f.glifos, pos: pos(g.first()), variantes: g.len()))
        ya += g
      }
    }
  }
  out
}
#let ordenadas = vistas.sorted(by: (a, b) => a.pos < b.pos)
#let total = datos.familias.map(f => f.glifos.len()).sum()
#let total-archivos = datos.familias.len()

// ── Carta de glifo ──
// La altura fija (74pt) de la versión anterior asumía que toda tipografía
// tiene una caja de línea de más o menos el mismo alto a 25pt — falso: el
// leading real de cada fuente varía muchísimo (Zen Old Mincho, por
// ejemplo, deja un hueco enorme entre el glifo y la placa de categoría,
// y en algunas fuentes el contenido se salía por debajo del borde de la
// tarjeta). Fix: el glifo vive en una caja de alto FIJO (34pt) centrada
// con `align(center + horizon)` — así el glifo queda anclado al centro de
// un área pequeña y constante sin importar cuánto leading traiga la
// fuente, y `clip: true` evita que un glifo inusualmente alto se salga y
// choque con la placa de categoría. El resto de la tarjeta ya no necesita
// una altura forzada: con el glifo domado, todas las tarjetas terminan
// del mismo alto de forma natural.
#let carta(g) = block(
  width: 100%,
  fill: white,
  stroke: 0.5pt + luma(88%),
  radius: 6pt,
  inset: (x: 3pt, y: 6pt),
)[
  #align(center)[
    #box(height: 34pt, width: 100%, clip: true)[
      #align(center + horizon)[
        #text(font: g.cara, style: g.estilo, size: 27pt, fill: luma(15%))[#(str.from-unicode(g.cp))]
      ]
    ]
    #v(4pt)
    #box(
      fill: cat-color.at(g.categoria).transparentize(75%),
      radius: 3pt,
      inset: (x: 3pt, y: 1pt),
    )[
      #text(size: 5.5pt, weight: 700, fill: cat-color.at(g.categoria), upper(cat-nombre.at(g.categoria)))
    ]
    #v(3pt)
    #text(size: 5.5pt, font: "DM Mono", fill: luma(55%))[U+#g.hex]
  ]
]

// ── Carta ancha, para "alfabeto" (florituras de Orments) ──
// Estos glifos son florituras HORIZONTALES (divisores anchos, no íconos
// cuadrados) — la carta() de 6 columnas los aplastaría ilegibles. Usan su
// propia carta (más ancha, texto más chico) y su propio grid de menos
// columnas. El pie de cada carta muestra el uso real (#orn[x]), no un
// código U+, porque para este alfabeto lo único que importa es la letra
// que hay que teclear en orn() — ver idiomas.typ.
#let carta-alfabeto(g) = block(
  width: 100%, fill: white, stroke: 0.5pt + luma(88%), radius: 6pt, inset: (x: 6pt, y: 6pt),
)[
  #align(center)[
    #box(height: 26pt, width: 100%, clip: true)[
      #align(center + horizon)[
        #text(font: g.cara, style: g.estilo, size: 15pt, fill: luma(15%))[#(str.from-unicode(g.cp))]
      ]
    ]
    #v(3pt)
    #text(size: 6pt, font: "DM Mono", fill: cat-color.at("alfabeto"), weight: 700, "#orn[" + str.from-unicode(g.cp) + "]")
  ]
]

// ── Sección por familia ──
#let adorno(f) = {
  let fleuron = f.glifos.find(x => x.categoria == "fleuron")
  if fleuron != none {
    text(font: fleuron.cara, style: fleuron.estilo, size: 13pt, fill: acso)[#(str.from-unicode(fleuron.cp))]
  } else {
    text(size: 13pt, fill: acso)[❧]
  }
}

#let seccion(f) = {
  let pequena = f.glifos.len() <= 24
  let variantes = f.at("variantes", default: none)
  // Nota: #grid(...)[celda1],[celda2] con TODO dentro de un solo par de
  // corchetes es UN solo argumento de contenido (la coma queda como texto
  // literal) — grid nunca ve 3 celdas. Hay que pasar cada celda como
  // argumento posicional separado, dentro del paréntesis de la llamada.
  let encabezado = grid(
    columns: (auto, 1fr, auto), align: (start, end, start), column-gutter: 8pt,
    box(fill: prim.transparentize(85%), radius: 4pt, inset: (x: 6pt, y: 3pt))[
      #text(font: theme.base.fonts.display, size: 9pt, weight: 800, fill: prim, upper(f.carpeta))
    ],
    text(size: 6.5pt, fill: luma(45%), f.glifos.map(g => cat-nombre.at(g.categoria)).dedup().join(" · ")),
    adorno(f),
  )
  let pie = if variantes != none {
    [#(f.glifos.len()) glifos · idénticos en las #variantes variantes fusionadas · cara verificada: #(f.glifos.map(g => g.cara).dedup().join(" · "))]
  } else {
    [#(f.glifos.len()) glifos · cara: #(f.glifos.map(g => g.cara).dedup().join(" · "))]
  }
  let normales = f.glifos.filter(g => g.categoria != "alfabeto")
  let alfabeto = f.glifos.filter(g => g.categoria == "alfabeto")
  let contenido = [
    #v(12pt)
    #encabezado
    #v(6pt)
    #line(length: 100%, stroke: 0.5pt + luma(85%))
    #v(6pt)
    #if normales.len() > 0 [
      #grid(
        columns: (1fr,) * 6,
        column-gutter: 6pt,
        row-gutter: 6pt,
        ..normales.map(c => carta(c)),
      )
    ]
    #if alfabeto.len() > 0 [
      #if normales.len() > 0 [#v(10pt)]
      #box(fill: cat-color.at("alfabeto").transparentize(90%), radius: 4pt, inset: (x: 8pt, y: 5pt), width: 100%)[
        #text(size: 7pt, weight: 700, fill: cat-color.at("alfabeto"))[FLORITURA ALFABÉTICA — #alfabeto.len() motivos, uno por letra/dígito, sin relación entre el dibujo y el carácter. Escribe la letra que quieras: #text(font: "DM Mono")[\#orn[x]] (ver `idiomas.typ`).]
      ]
      #v(6pt)
      #grid(
        columns: (1fr,) * 4,
        column-gutter: 6pt,
        row-gutter: 6pt,
        ..alfabeto.map(c => carta-alfabeto(c)),
      )
    ]
    #v(6pt)
    #text(size: 6pt, font: "DM Mono", fill: luma(55%))[#pie]
  ]
  if pequena {
    block(breakable: false, contenido)
  } else {
    contenido
  }
}

#set pagebreak()
// ═══════════════════════════════════════════════════════════════
//  PORTADA
// ═══════════════════════════════════════════════════════════════
#align(center + horizon)[
  #text(font: theme.base.fonts.display, size: 34pt, weight: 900, fill: prim)[Catálogo de ornamentos]
  #v(6pt)
  #text(size: 11.5pt, fill: luma(35%))[Fleurons, giraldillas y florituras en las tipografías de `Fonts/`]
  #v(18pt)
  #box(fill: prim, radius: 8pt, inset: (x: 16pt, y: 8pt))[
    #text(fill: white, size: 10pt, weight: 700)[#total-archivos fuentes · #total glifos verificados · #ordenadas.len() secciones]
  ]
  #v(16pt)
  #block(fill: white, stroke: 0.6pt + luma(85%), radius: 10pt, inset: 14pt)[
    #set align(center)
    #text(size: 8pt, fill: luma(40%))[Muestra rápida (varias categorías):
    #v(6pt)
    #grid(columns: (auto, auto, auto, auto, auto, auto, auto, auto), column-gutter: 10pt, align: center+horizon,
      text(font: "Cormorant", size: 22pt)[❦],
      text(font: "Libertinus Serif", size: 22pt)[❧],
      text(font: "Libertinus Serif", size: 20pt)[☙],
      text(font: "EB Garamond 12", size: 22pt)[❦],
      text(font: "EB Garamond 12", size: 20pt)[❝],
      text(font: "Bodoni Moda", size: 20pt)[❡],
      text(font: "Inter", size: 20pt)[⁂],
      text(font: "Inter", size: 20pt)[❤],
    )]
  ]
  #v(14pt)
  #text(size: 7.5pt, fill: luma(50%))[
    Dato generado por `ornamentos/catalogar-ornamentos.py`: `fc-scan --format %{charset}` sobre los
    #total-archivos directorios de `Fonts/`, cruzado con `typst fonts --variants --font-path Fonts` para saber qué
    cara (nombre + estilo) contiene cada glifo. Cada ficha solo muestra glifos que la fuente de verdad
    mapea (#[kbd("cmap")]) y que Typst puede resolver con `--font-path Fonts`. Variantes ópticas con
    glifos idénticos (confirmado renderizando, no solo por coincidencia de codepoint) se fusionan en
    una sola sección — ver nota junto a cada una.
  ]
]

#pagebreak()

// ═══════════════════════════════════════════════════════════════
//  ÍNDICE
// ═══════════════════════════════════════════════════════════════
#text(font: theme.base.fonts.display, size: 17pt, weight: 900, fill: prim)[Índice]
#v(3pt)
#text(size: 8pt, fill: luma(45%))[#total-archivos archivos de fuente en #ordenadas.len() secciones (variantes idénticas fusionadas) · ordenadas de más a menos útiles para florituras editoriales]
#v(8pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 8pt,
  row-gutter: 6pt,
  ..ordenadas.map(f => block(
    fill: white, stroke: 0.5pt + luma(88%), radius: 6pt, inset: 8pt, width: 100%,
  )[
    #grid(
      columns: (1fr, auto), align: (start, center), column-gutter: 6pt,
      text(font: theme.base.fonts.display, size: 7.5pt, weight: 800, fill: luma(20%), f.carpeta),
      text(size: 8pt, weight: 800, fill: prim)[#(f.glifos.len())],
    )
    #v(2pt)
    #text(size: 6pt, fill: luma(50%), f.glifos.map(g => cat-nombre.at(g.categoria)).dedup().join(" · "))
  ]),
)

#pagebreak()

// ═══════════════════════════════════════════════════════════════
//  FAMILIAS
// ═══════════════════════════════════════════════════════════════
#for fam in ordenadas {
  seccion(fam)
}

#set page(paper: "a4", margin: 1.3cm)
#align(center + horizon)[
  #text(font: theme.base.fonts.display, size: 14pt, weight: 800, fill: prim)[Fin del catálogo]
  #v(6pt)
  #text(size: 7.5pt, fill: luma(50%))[USO: `#text(font: "Cormorant")[❦]` — texto con la cara que verificó el glifo]
  #v(8pt)
  #text(size: 7.5pt, fill: luma(40%))[Regenerar: `python3 ornamentos/catalogar-ornamentos.py` y recompilar este archivo]
]