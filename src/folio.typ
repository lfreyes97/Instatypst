// ─────────────────────────────────────────────────────────────
//  folio.typ — preset «folio de salterio» (lámina 11)
//
//  Un folio manuscrito: pergamino tostado en los bordes, pautado del
//  copista en rojo, una banda de florones arriba, el texto justificado
//  con capitular iluminada a dos tintas (capitular-ornamentada) y la
//  última línea rellenada con florones, y al margen una glosa: manecilla
//  más la fuente en rojo. Pie con autor y marca.
//
//  Se usa desde el namespace `carteles` (carteles.folio). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "carteles/_temas.typ": resolver-tema
#import "superbg/lib.typ" as superbg
#import "fleurones.typ" as fl
#import "dropcaps.typ": capitular-ornamentada
#import "carteles/_base.typ": medida, ajustar-alto

// ── carteles.folio ──────────────────────────────────────────
//   texto       el pasaje (contenido); su primera letra va en capitular
//   glosa       (arriba, abajo): las dos líneas de la glosa al margen,
//               la segunda más grande (p. ej. ([Salmo], [51])) · none
//   autor       pie, en versalitas
//   marca       contenido al pie, a la derecha (p. ej. el logo)
//   cabecera    auto (la banda de molinetes de la lámina, recortada a
//               una franja) · un nombre de `fleurones.guardas`
//               ("lises", "cresteria"…) · none
//   relleno     glifo de FLOWERS 2 que completa la última línea · none
//   cuerpo      auto = 66pt, achicándose de a 2pt si el texto no cabe
//   glosa-y     auto = a la altura de la lámina (≈ 44 % de la caja)
//   capitular   argumentos de capitular-ornamentada (alto, estilo…)
//
// Pensado para el cuadrado 1080×1080; en otros formatos la caja de
// texto crece con el lienzo y los márgenes quedan fijos.
// tema: nombre de `temas-lamina` (por defecto "folio"), diccionario de roles
// (fondo, tinta, suave, acento…) o `carteles.tema-desde-theme(theme.base)`.
// Los parámetros de color (`pergamino` (fondo), `tinta`, `rubrica` (acento)) pisan al tema; auto = el del tema.
#let folio(
  texto,
  glosa: none,
  formato: (1080, 1080),
  autor: none,
  marca: none,
  tinta: auto,
  rubrica: auto,
  tema: "folio",
  pergamino: auto,
  fuente: "IM FELL English",
  fuente-sc: "IM FELL English SC",
  cabecera: auto,
  relleno: "k",
  cuerpo: auto,
  glosa-y: auto,
  capitular: (alto: 3, hueco: 0.28em, estilo: "rubricada", desgaste: 0.35),
  textura: true,
) = {
  let tm = resolver-tema(tema, defecto: "folio")
  let pergamino = if pergamino == auto { tm.fondo } else { pergamino }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let rubrica = if rubrica == auto { tm.acento } else { rubrica }
  let (ancho, alto) = medida(formato)
  let (fx, fy) = (formato.at(0) / 1080, formato.at(1) / 1080)
  let pauta = rubrica.transparentize(72%)

  // Caja de texto del folio y pautado (márgenes de la lámina)
  let x0 = 118pt
  let x1 = ancho - 242pt
  let y0 = 130pt
  let y1 = alto - 212pt
  let gy = if glosa-y == auto { y0 + (y1 - y0) * 328 / 738 } else { glosa-y }

  page(width: ancho, height: alto, margin: 0pt, fill: pergamino, {
    set text(font: fuente, fill: tinta, lang: "es", hyphenate: true)

    // ── Pergamino: centro más claro, bordes tostados, grano ──
    place(rect(width: 100%, height: 100%, fill: gradient.radial(
      (rgb("#f6ecd4"), 0%), (rgb("#ecdcb6"), 58%), (rgb("#d6bd8a"), 100%),
      center: (46%, 44%), radius: 82%,
    )))
    if textura {
      superbg.bg-malla(
        (rgb("#c9a86a"), rgb("#e9d6ac"), rgb("#c4a167")),
        puntos: ((60 * fx, 1010 * fy), (900 * fx, 120 * fy), (1040 * fx, 900 * fy)),
        radios: (180, 260, 150),
        semilla: 3,
        size: formato,
      )
      place(rect(width: 100%, height: 100%, fill: pergamino.transparentize(45%)))
      superbg.bg-patron(patron: "ruido", opacidad: 16%, size: formato)
    }

    // ── Pautado del copista ──
    for x in (x0, x1, x1 + 30pt, ancho - 68pt) {
      place(dx: x, line(start: (0pt, 0pt), end: (0pt, alto), stroke: 1.2pt + pauta))
    }
    for y in (y0, y1) {
      place(dy: y, line(start: (0pt, 0pt), end: (ancho, 0pt), stroke: 1.2pt + pauta))
    }

    // ── Cabecera ──
    if cabecera == auto {
      place(top + left, dx: x0, dy: 70pt, box(width: x1 - x0, height: 50pt, clip: true,
        text(font: fl.f2, size: 40pt, fill: rubrica, repeat(gap: 6pt)[m])))
    } else if cabecera != none {
      place(top + left, dx: x0, dy: 78pt, fl.guarda(cabecera, x1 - x0, rubrica, alto: 38pt))
    }

    // ── Texto con capitular; los florones rellenan la última línea ──
    let fin = if relleno == none { [] } else {
      [#h(0.3em)#box(width: 1fr, text(font: fl.f2, size: 34pt, fill: rubrica, repeat(gap: 4pt, relleno)))]
    }
    let componer(s) = block(width: x1 - x0, {
      set text(size: s, hyphenate: false)
      set par(justify: true, leading: 0.62em, spacing: 0pt)
      capitular-ornamentada([#texto#fin], ..capitular)
    })
    place(top + left, dx: x0, dy: y0, box(width: x1 - x0, height: y1 - y0, align(horizon, if cuerpo != auto {
      componer(cuerpo)
    } else {
      context {
        componer(ajustar-alto(componer, 66pt, y1 - y0))
      }
    })))

    // ── Glosa al margen: manecilla + fuente ──
    if glosa != none {
      let (g1, g2) = glosa
      place(top + left, dx: x1 + 44pt, dy: gy, block(width: 140pt, {
        set par(leading: 0.32em)
        text(font: fl.f2, size: 58pt, fill: tinta)[2]
        v(10pt)
        text(size: 34pt, fill: rubrica, style: "italic", g1)
        linebreak()
        text(size: 52pt, fill: rubrica, style: "italic", g2)
      }))
    }

    // ── Pie ──
    place(top + left, dx: x0, dy: alto - 136pt, block(width: x1 - x0, grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      if autor != none { text(font: fuente-sc, size: 32pt, tracking: 1pt, autor) },
      if marca != none { marca },
    )))
  })
}
