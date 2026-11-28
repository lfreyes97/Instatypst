// ─────────────────────────────────────────────────────────────
//  stairs.typ — el preset `stairs` (en v1, `carteles.escalera`)
//
//  stairs = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): main, conclusion, coda, author, work,
//  brand; cada uno también como argumento (`author: […]`). Además lee de su cuerpo
//  el `list` de la librería estándar (los peldaños) y, dentro de cada ítem, `main`
//  (ver abajo).
//  Opciones del preset: margin, step, summit; el resto viaja en el tema (paper,
//  ink, quiet, accent), en `fonts` y en las propiedades de los elementos
//  (main.size, main.align, conclusion.size, conclusion.y, coda.size).
//
//  La frase baja por el lienzo en escalones, cada peldaño con su cuerpo, sangría,
//  estilo, peso y color, y termina en un clímax grande (la conclusion) con una
//  coda opcional. Sobre un color sólido, con las curvas de nivel de la lámina 04
//  convergiendo bajo el clímax. Sirve para láminas y diapositivas: el mismo
//  texto se reparte solo en vertical, cuadrado o apaisado.
//
//  El contenido (v1: `peldanos`, un array de peldaños o de grupos):
//    · un GRUPO es un `list` (la llamada `#list(…)`, o una tanda de `- …`
//      seguidos; dos tandas seguidas, aunque las separe una línea en blanco, son
//      una sola lista: para varios grupos, una llamada `list` por grupo); cada
//      ítem es un peldaño. Entre grupo y grupo queda más aire, y
//      cada grupo vuelve a empezar su escalón desde el margen. Un solo `list` es
//      una sola escalera (v1: un array plano).
//    · un ítem de texto es un peldaño con el estilo base; un ítem que contiene
//      `#main[…]` toma sus propiedades de ese `main` (v1: el diccionario del
//      peldaño): `size` (cuerpo), `indent` (sangría: auto = escalón automático,
//      largo = fijo desde el margen), `style` ("normal" | "italic"), `weight`,
//      `fill` ("ink", "quiet", "accent" o un color), `tracking`, `y` (auto =
//      reparto automático, largo = fijo desde arriba).
//    · `main` suelto (fuera de un ítem) no lleva texto: lleva los valores base de
//      todos los peldaños. `main(size:)` (v1 `cuerpo`, 60) y `main(align:)` (v1
//      `alinear`: center | left | right, la alineación del CLÍMAX, no de los
//      peldaños; la tabla la manda a `main.align`). Su cuerpo se ignora.
//    · `conclusion` (v1 `climax`) es el remate, grande y en cursiva, en `accent`;
//      `conclusion(size:)` (v1 `cuerpo-climax`, 150) y `conclusion(y:)` (v1
//      `climax-y`: auto, o un largo para fijarlo a mano).
//    · `coda` es una línea más chica bajo el clímax; `coda(size:)` (v1
//      `cuerpo-coda`, 76).
//    · `author` y `work` son la cabecera arriba a la izquierda, en `quiet`;
//      `brand` (v1 `marca`), arriba a la derecha.
//
//  Opciones del preset: `step` (v1 `paso`, 0,163): cuánto avanza cada escalón,
//  como fracción del ancho útil. `margin` (v1 `margen`): número = u, largo =
//  absoluto; auto = 80 u. `summit` (v1 `cumbre`, decidido como opción del preset):
//  auto = bajo el centro del clímax, donde convergen las curvas; (x, y) en largos
//  = fija.
//
//  Automático (como v1): los cuerpos se escalan al ancho del formato (base 1080),
//  se achican si una línea no cabe o si el conjunto no entra en el alto, y el aire
//  entre peldaños se estira (hasta 2,2×) para llenar el alto; lo que sobra se
//  reparte 1:2 arriba/abajo. Cada sangría automática se recorta para que la línea
//  nunca pase del margen derecho.
//
//  Escala: la de v1. La letra escala con el ANCHO (kw = ancho/1080) y la cabecera
//  y los márgenes con el lado corto (kh = u). Por eso un NÚMERO en un cuerpo
//  (`main(size: 64)`) son píxeles de un lienzo de 1080 de ancho (se multiplican
//  por kw, no por u: en apaisado difieren), y un largo es absoluto (se divide por
//  kw antes de escalar, igual que v1 con sus `pt`). Pasar a `u` es ajuste fino
//  posterior.
//
//  Fuente: Literata (v1 `fuente`); sale del token `literata` y `fonts:` la
//  sobreescribe.
//
//  Roles del tema: los cuatro de v1 (paper, ink, quiet, accent; v1 fondo, tinta,
//  suave, acento); `guide` lo deriva modules/color y stairs no lo usa.
//
//  Pendientes (ver el informe): los recursos `curves` (v1 `curvas`: apagarlas,
//  darles otro color o un campo continuo con `indice`), `rings` (v1 `anillos`) y
//  `decoration` (v1 `decorado`) no existen: las curvas de nivel se dibujan siempre,
//  en `quiet`, con los anillos que hagan falta, y no hay decorado. Y `header.y`
//  (v1 `cabecera-y`): la cabecera usa siempre su altura automática, porque
//  `header` no es un elemento del vocabulario.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/resources/motifs/_curvas-de-nivel.typ": curvas-de-nivel

#let _default-theme = (
  paper: rgb("#10302a"),
  ink: rgb("#efe8da"),
  quiet: rgb("#b9cfc3"),
  accent: rgb("#f3c28e"),
  // sin `guide`: v1 no lo tenía y stairs no lo usa; modules/color lo deriva
)

// (`list` tiene `children` pero es un grupo, no una secuencia: no se aplana)
#let _flatten(c) = if c.func() != list and c.has("children") { c.children.map(_flatten).flatten() } else { (c,) }

// El cuerpo de un ítem → (body:, props:): el de su `main` si lo tiene, o el ítem tal cual.
#let _item(item) = {
  let found = _flatten(item.body).find(c => c.func() == metadata and type(c.value) == dictionary
    and c.value.at("kind", default: none) == "main")
  if found == none { (body: item.body, props: (:)) } else { (body: found.value.body, props: found.value.props) }
}

// Los grupos del contenido: cada `list` es un grupo; los `list.item` sueltos y
// seguidos forman otro.
#let _groups(body) = {
  let groups = ()
  let run = ()
  for c in _flatten(body) {
    if c.func() == list.item {
      run.push(_item(c))
    } else if c.func() == list {
      if run.len() > 0 { groups.push(run); run = () }
      groups.push(c.children.map(_item))
    }
  }
  if run.len() > 0 { groups.push(run) }
  groups
}

#let _rules(ctx, step, margin, summit) = {
  let part(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { none } else { p.body }
  }
  let props(k) = {
    let p = ctx.parts.at(k, default: none)
    if p == none { (:) } else { p.props }
  }
  let author = part("author")
  let work = part("work")
  let conclusion = { let c = part("conclusion"); if c == none { [] } else { c } }
  let coda = part("coda")
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, quiet, accent) = (tm.ink, tm.quiet, tm.accent)
  let brand = ctx.brand
  let kw = width / 1080pt // escala de la letra: el ancho manda
  let kh = calc.min(width, height) / 1080pt // escala de cabecera y márgenes
  let margin = if margin == auto { 80pt * kh } else { (ctx.len)(margin) }
  let box-width = width - 2 * margin
  let header-y = calc.max(56pt, 110pt * (height / 1920pt))
  let tone(c) = if type(c) == str { tm.at(c) } else { c }

  // un cuerpo en la escala de v1: número = px sobre 1080 de ancho, largo = absoluto
  let design(v) = if type(v) == length { v / kw } else { v * 1pt }
  let main-props = props("main")
  let base-size = design(main-props.at("size", default: 60))
  let climax-size = design(props("conclusion").at("size", default: 150))
  let coda-size = design(props("coda").at("size", default: 76))
  let align-climax = main-props.at("align", default: center)
  let climax-y = props("conclusion").at("y", default: auto)
  let climax-y = if climax-y == auto { auto } else { (ctx.len)(climax-y) }
  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("literata") }

  let step-of(s) = {
    let p = s.props
    let at(k, d) = p.at(k, default: d)
    let indent = at("indent", auto)
    let y = at("y", auto)
    (
      text: s.body,
      size: if "size" in p { design(p.size) } else { base-size },
      indent: if indent == auto { auto } else { (ctx.len)(indent) },
      style: at("style", "normal"),
      weight: at("weight", 400),
      color: at("fill", "ink"),
      tracking: at("tracking", 0pt),
      y: if y == auto { auto } else { (ctx.len)(y) },
    )
  }
  let groups = _groups(ctx.body).map(g => g.map(step-of))
  let manual = climax-y != auto and groups.all(g => g.all(p => p.y != auto))

  let line(p, e) = text(
    size: p.size * kw * e, weight: p.weight, style: p.style,
    fill: tone(p.color), tracking: p.tracking, p.text,
  )
  let climax-block(e) = block(width: box-width, {
    set align(align-climax)
    set par(leading: 0.12em, spacing: 0pt)
    text(size: climax-size * kw * e, weight: 600, style: "italic", fill: accent, tracking: -0.02em, conclusion)
    if coda != none {
      v(56pt * kw * e)
      text(size: coda-size * kw * e, weight: 400, style: "italic", fill: accent, coda)
    }
  })

  {
    set text(font: family, fill: ink, lang: "es")

    context {
      // Aire entre peldaños: dentro del grupo, según el cuerpo del que
      // viene abajo; entre grupos y antes del clímax, según el cuerpo base.
      let gaps(e) = {
        let out = ()
        for (g, group) in groups.enumerate() {
          for (j, p) in group.enumerate() {
            out.push(if j > 0 { 0.55 * p.size * kw * e } else if g > 0 { 1.5 * base-size * kw * e } else { 0pt })
          }
        }
        out.push(2 * base-size * kw * e) // antes del clímax
        out
      }
      let flat = groups.flatten()
      let measured(e) = (
        flat.map(p => measure(line(p, e))),
        measure(climax-block(e)).height,
      )

      // espacio útil: bajo la cabecera, hasta un margen igual al de arriba
      let y-top = header-y + 64pt * kh + 100pt * kh
      // (el clímax se mide hasta la línea base: se reserva su descendente)
      let y-floor = height - header-y - 0.3 * climax-size * kw
      let e = 1.0
      if not manual {
        // ninguna línea más ancha que la caja
        let widths = measured(1.0).at(0).map(m => m.width)
        e = calc.min(1.0, ..widths.map(w => box-width / w))
        // y el conjunto, dentro del alto
        let total(e) = {
          let (ms, hc) = measured(e)
          ms.map(m => m.height).sum(default: 0pt) + gaps(e).sum() + hc
        }
        while total(e) > y-floor - y-top and e > 0.4 { e -= 0.03 }
      }
      let (ms, hc) = measured(e)
      let gap = gaps(e)
      let free = (y-floor - y-top) - ms.map(m => m.height).sum(default: 0pt) - gap.sum() - hc
      let stretch = if gap.sum() > 0pt { calc.min(2.2, 1 + free / gap.sum()) } else { 1 }
      let rest = free - gap.sum() * (stretch - 1)

      // posiciones primero: las curvas, que van detrás, dependen del clímax
      let y = y-top + rest / 3
      let k = 0
      let lines = ()
      for (g, group) in groups.enumerate() {
        for (j, p) in group.enumerate() {
          y += gap.at(k) * stretch
          let w = ms.at(k).width
          let s = if p.indent != auto { p.indent } else {
            calc.max(0pt, calc.min(box-width - w, j * step * box-width * (1 + 0.5 * g)))
          }
          let py = if p.y != auto { p.y } else { y }
          lines.push((margin + s, py, line(p, e)))
          y += ms.at(k).height
          k += 1
        }
      }
      y += gap.at(k) * stretch
      let yc = if climax-y != auto { climax-y } else { y }

      // ── curvas de nivel: convergen bajo el clímax ──
      let peak = if summit != auto { summit } else {
        let wc = measure(text(size: climax-size * kw * e, weight: 600, style: "italic", tracking: -0.02em, conclusion)).width
        let x = if align-climax == left { margin + wc / 2 } else if align-climax == right { width - margin - wc / 2 } else { width / 2 }
        (x, yc + 0.45 * hc)
      }
      let sep = 40pt * kh
      let rings = {
        let far = calc.max(..((0pt, 0pt), (width, 0pt), (0pt, height), (width, height)).map(((x, y)) => {
          calc.sqrt(calc.pow((x - peak.at(0)) / 1pt, 2) + calc.pow((y - peak.at(1)) / 1pt, 2))
        }))
        int(calc.ceil(far / (sep / 1pt))) + 2
      }
      curvas-de-nivel(peak, quiet, n: rings, sep: sep)

      // ── cabecera ──
      if author != none {
        place(top + left, dx: margin, dy: header-y, text(size: 24pt * kh, weight: 600, tracking: 0.16em, fill: quiet, author))
      }
      if work != none {
        place(top + left, dx: margin, dy: header-y + 38pt * kh, text(size: 26pt * kh, style: "italic", fill: quiet, work))
      }
      if brand != none { place(top + right, dx: -margin, dy: header-y + 2pt * kh, brand) }

      // ── peldaños y clímax ──
      for (x, py, l) in lines { place(top + left, dx: x, dy: py, l) }
      place(top + left, dx: margin, dy: yc, climax-block(e))
    }
  }
}

#let make(
  body,
  artboard: (1080, 1920),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  step: 0.163,
  margin: auto,
  summit: auto,
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
  known: ("main", "conclusion", "coda", "author", "work", "brand"),
  fn: "stairs",
  elements: elements,
  rules: ctx => _rules(ctx, step, margin, summit),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "stairs", make: make, variants: (), artboard: "story") // escalera era 1080×1920 en v1
#let stairs = frame.with(preset: preset)
