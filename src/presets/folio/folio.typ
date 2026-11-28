// ─────────────────────────────────────────────────────────────
//  folio.typ — el preset `folio` (en v1, `carteles.folio`)
//
//  folio = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): prose, gloss, work, author, brand;
//  cada uno también como argumento (`author: […]`).
//  Opciones del preset: header, fill; el resto viaja en las propiedades de los
//  elementos (prose.size, gloss.y), en el tema y en `fonts`.
//
//  Un folio de salterio: pergamino tostado en los bordes, pautado del copista
//  en rojo, una banda de florones arriba, el texto justificado con capitular
//  iluminada a dos tintas y la última línea rellenada con florones, y al margen
//  una glosa: manecilla más la fuente en rojo. Pie con autor y marca.
//
//  El contenido (v1: `texto`, `glosa`, `referencia`):
//    · `prose` (o el contenido suelto) es el pasaje; su primera letra va en
//      capitular.
//    · `gloss` es la nota al margen, de DOS líneas: la de arriba (chica) y la de
//      abajo (grande). v1 la daba como el par `(arriba, abajo)`; aquí es el
//      cuerpo del elemento, partido por un salto de párrafo o de línea:
//        #gloss[Salmo #parbreak() 51]      #gloss[Salmo \ 51]
//      Un solo bloque de texto sin salto es la línea de arriba, y no hay la de
//      abajo. No se inventa un elemento: es el mismo `gloss`.
//    · `work` (v1 `referencia`) es el atajo de `gloss` para un pasaje: «Salmo 51»
//      se parte por el último espacio («Salmo» / «51»; «1 Juan 3:2» da
//      «1 Juan» / «3:2»). Si se dan los dos, manda `gloss`.
//    · `gloss(y:)` (v1 `glosa-y`) es la altura de la glosa; número = u, longitud
//      = absoluta; sin darla, a la altura de la lámina (≈ 44 % de la caja).
//    · `prose(size:)` (v1 `cuerpo`) fija el cuerpo del pasaje; sin darlo es 66 pt,
//      achicándose de a 2 pt hasta que quepa. (La tabla manda `cuerpo` a
//      `main.size`, pero folio no tiene `main`: el pasaje es `prose`.)
//
//  Opciones del preset: `header` (v1 `cabecera`): auto (la banda de molinetes,
//  recortada a una franja), un nombre de `fleurones.guardas` ("lises",
//  "cresteria"…) o none. `fill` (v1 `relleno`): el glifo de FLOWERS 2 que
//  completa la última línea, o none.
//
//  Escala: las medidas son pt absolutos, pensados sobre el cuadrado 1080×1080,
//  como en v1 (no usa `k`; solo el pergamino se reparte por fracción del lienzo).
//  Pensado para el cuadrado: en otros formatos la caja de texto crece con el
//  lienzo y los márgenes quedan fijos.
//
//  Fuentes: IM FELL English y su versalita (v1 `fuente`, `fuente-sc`). Ninguna
//  pareja de typography trae la versalita; se toman los tokens por `ctx.font` y
//  `fonts:` los sobreescribe (roles body y smallcaps).
//
//  Roles del tema: los tres de v1 (paper, ink, accent); `quiet` y `guide` los
//  deriva modules/color y folio no los usa. La rúbrica (v1 `rubrica`) es el
//  acento.
//
//  Pendientes (ver el informe): los recursos `parchment` (v1 `pergamino`; la
//  ambientación del pergamino y su malla se dibujan siempre), `texture` (v1
//  `textura`; el grano y las manchas se dibujan siempre), `rubric` (v1
//  `rubrica`; el acento del tema la cubre) y `dropcap` (v1 `capitular`; siempre
//  alto 3, hueco 0.28em, estilo "rubricada", desgaste 0.35).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ" as superbg
#import "/src/modules/fleurones/fleurones.typ" as fl
#import "/src/resources/dropcaps/dropcaps.typ": capitular-ornamentada

#let _default-theme = (
  paper: rgb("#eee0bf"),
  ink: rgb("#1f1610"),
  accent: rgb("#9e2219"),
  // sin `quiet` ni `guide`: v1 no los tenía y folio no los usa
)

// Ambientación del pergamino (degradado radial y malla de manchas), a partir
// del papel del tema. Con el papel por defecto, los tonos de la lámina tal cual;
// con otro, el centro aclarado y los bordes oscurecidos de ese papel, para que
// un tema oscuro dé un folio oscuro y no tinta clara sobre pergamino.
#let _ambient(paper) = if paper == _default-theme.paper {(
  centro: rgb("#f6ecd4"), medio: rgb("#ecdcb6"), borde: rgb("#d6bd8a"),
  malla: (rgb("#c9a86a"), rgb("#e9d6ac"), rgb("#c4a167")),
)} else {(
  centro: paper.lighten(30%), medio: paper, borde: paper.darken(14%),
  malla: (paper.darken(20%), paper.lighten(10%), paper.darken(22%)),
)}

// Las líneas de la glosa: el cuerpo partido por un salto de párrafo o de línea.
#let _split-lines(body) = {
  let kids = if body.has("children") { body.children } else { (body,) }
  let out = ((),)
  for c in kids {
    if repr(c.func()) in ("parbreak", "linebreak") { out.push(()) } else { out.last().push(c) }
  }
  out.map(l => l.join()).filter(l => l != none)
}

// `work` como glosa: se parte por el último espacio.
#let _split-work(body) = {
  let kids = if body.has("children") { body.children } else { (body,) }
  // el último espacio: un elemento `space`, o un blanco dentro del último texto
  let at = kids.rev().position(c => repr(c.func()) == "space" or (c.func() == text and c.text.contains(" ")))
  assert(at != none, message: "folio: `work` necesita al menos dos palabras (p. ej. «Salmo 51»), no " + repr(body))
  let i = kids.len() - 1 - at
  let c = kids.at(i)
  if c.func() == text {
    let words = c.text.split(" ")
    let before = words.slice(0, -1).join(" ")
    let after = words.last()
    (kids.slice(0, i).join() + text(before), text(after) + kids.slice(i + 1).join())
  } else {
    (kids.slice(0, i).join(), kids.slice(i + 1).join())
  }
}

#let _rules(ctx, header, fill) = {
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, accent, paper) = (tm.ink, tm.accent, tm.paper)
  let p = ctx.parts
  let author = p.at("author", default: none)
  let author = if author == none { none } else { author.body }
  let brand = ctx.brand

  let pp = p.at("prose", default: none)
  let passage = if pp == none { ctx.loose } else if ctx.has-loose { pp.body + parbreak() + ctx.loose } else { pp.body }
  let pprops = if pp == none { (:) } else { pp.props }

  let gp = p.at("gloss", default: none)
  let wp = p.at("work", default: none)
  let gloss-lines = if gp != none { _split-lines(gp.body) } else if wp != none { _split-work(wp.body) } else { none }
  let gprops = if gp == none { (:) } else { gp.props }

  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("im-fell-english") }
  let family-sc = if "smallcaps" in ctx.fonts { ctx.fonts.smallcaps } else { (ctx.font)("im-fell-english-sc") }

  let (fx, fy) = (width / 1pt / 1080, height / 1pt / 1080)
  let formato = (width / 1pt, height / 1pt)
  let rule = accent.transparentize(72%)
  let amb = _ambient(paper)

  // Caja de texto del folio y pautado (márgenes de la lámina)
  let x0 = 118pt
  let x1 = width - 242pt
  let y0 = 130pt
  let y1 = height - 212pt
  let gy = if "y" in gprops { (ctx.len)(gprops.y) } else { y0 + (y1 - y0) * 328 / 738 }

  {
    set text(font: family, fill: ink, lang: "es", hyphenate: true)

    // ── Pergamino: centro más claro, bordes tostados, grano ──
    // (recursos `parchment` y `texture`: pendientes, se dibujan siempre)
    place(rect(width: 100%, height: 100%, fill: gradient.radial(
      (amb.centro, 0%), (amb.medio, 58%), (amb.borde, 100%),
      center: (46%, 44%), radius: 82%,
    )))
    superbg.bg-malla(
      amb.malla,
      puntos: ((60 * fx, 1010 * fy), (900 * fx, 120 * fy), (1040 * fx, 900 * fy)),
      radios: (180, 260, 150),
      semilla: 3,
      size: formato,
    )
    place(rect(width: 100%, height: 100%, fill: paper.transparentize(45%)))
    superbg.bg-patron(patron: "ruido", opacidad: 16%, size: formato)

    // ── Pautado del copista ──
    for x in (x0, x1, x1 + 30pt, width - 68pt) {
      place(dx: x, line(start: (0pt, 0pt), end: (0pt, height), stroke: 1.2pt + rule))
    }
    for y in (y0, y1) {
      place(dy: y, line(start: (0pt, 0pt), end: (width, 0pt), stroke: 1.2pt + rule))
    }

    // ── Cabecera ──
    if header == auto {
      place(top + left, dx: x0, dy: 70pt, box(width: x1 - x0, height: 50pt, clip: true,
        text(font: fl.f2, size: 40pt, fill: accent, repeat(gap: 6pt)[m])))
    } else if header != none {
      place(top + left, dx: x0, dy: 78pt, fl.guarda(header, x1 - x0, accent, alto: 38pt))
    }

    // ── Texto con capitular; los florones rellenan la última línea ──
    let tail = if fill == none { [] } else {
      [#h(0.3em)#box(width: 1fr, text(font: fl.f2, size: 34pt, fill: accent, repeat(gap: 4pt, fill)))]
    }
    let compose(s) = block(width: x1 - x0, {
      set text(size: s, hyphenate: false)
      set par(justify: true, leading: 0.62em, spacing: 0pt)
      capitular-ornamentada([#passage#tail], alto: 3, hueco: 0.28em, estilo: "rubricada", desgaste: 0.35)
    })
    place(top + left, dx: x0, dy: y0, box(width: x1 - x0, height: y1 - y0, align(horizon, if "size" in pprops {
      compose((ctx.len)(pprops.size))
    } else {
      context {
        compose((ctx.fit-down)(compose, 66pt, y1 - y0))
      }
    })))

    // ── Glosa al margen: manecilla + fuente ──
    if gloss-lines != none {
      let g1 = gloss-lines.at(0, default: none)
      let g2 = gloss-lines.at(1, default: none)
      place(top + left, dx: x1 + 44pt, dy: gy, block(width: 140pt, {
        set par(leading: 0.32em)
        text(font: fl.f2, size: 58pt, fill: ink)[2]
        v(10pt)
        if g1 != none { text(size: 34pt, fill: accent, style: "italic", g1) }
        if g2 != none {
          linebreak()
          text(size: 52pt, fill: accent, style: "italic", g2)
        }
      }))
    }

    // ── Pie ──
    place(top + left, dx: x0, dy: height - 136pt, block(width: x1 - x0, grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      if author != none { text(font: family-sc, size: 32pt, tracking: 1pt, author) },
      if brand != none { brand },
    )))
  }
}

#let make(
  body,
  artboard: (1080, 1080),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  header: auto,
  fill: "k",
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  theme: theme,
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: _default-theme,
  default-fonts: none,
  known: ("prose", "gloss", "work", "author", "brand"),
  fn: "folio",
  elements: elements,
  rules: ctx => _rules(ctx, header, fill),
)

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "folio", make: make, variants: (), artboard: "cuadrado") // folio era cuadrado en v1
#let folio = frame.with(preset: preset)
