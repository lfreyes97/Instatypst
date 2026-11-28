// ─────────────────────────────────────────────────────────────
//  bauhaus.typ — el preset `bauhaus` (en v1, `carteles.bauhaus`)
//
//  bauhaus = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): tag, subhead, main, conclusion,
//  author, dates, brand; cada uno también como argumento (`author: […]`).
//  Opción del preset: lowercase; el resto viaja en las propiedades de los
//  elementos (main.size), en el tema y en `fonts`.
//
//  Cartel de formas primarias sobre papel crudo: cuadrado rojo, círculo
//  amarillo, triángulo azul y una barra negra en diagonal. El remate
//  (conclusion), en minúsculas de sans geométrica y negrita, ocupa todo el
//  ancho útil; la composición es asimétrica y diagonal, sin retícula.
//
//  Las formas se construyen unas desde otras:
//    · una línea de tierra corre justo por encima del texto; todo apoya en ella
//    · el cuadrado rojo apoya en la tierra; el círculo amarillo tiene el centro
//      en la esquina superior derecha del cuadrado y radio igual al lado
//    · la barra negra nace en el margen izquierdo, sobre la tierra, y pasa por
//      esa esquina-centro: es el eje del cartel
//    · el triángulo azul es la cuña entre la tierra y la barra
//  El texto se apoya abajo, contra el remate, y las formas se dimensionan con
//  el alto que queda encima.
//
//  Escala: las medidas son las de v1, pensadas sobre 1080×1350 y escaladas con
//  k = mín(ancho/1080, alto/1350) (no con `u`, que es lado corto / 1080: en
//  cuadrado y apaisado difieren). Se mantiene k para conservar la paridad.
//
//  Fuente: Jost (v1). Ninguna pareja de typography la trae; se toma el token
//  `jost` por `ctx.font` y `fonts:` la sobreescribe como en cualquier preset.
//
//  Roles del tema: los cinco más dos propios, `yellow` (el círculo) y `blue` (el
//  triángulo y la barra del pie), que pasan por modules/color como los demás:
//  `theme: (yellow: "tw4-amber-400")` funciona. La textura de papel (v1
//  `textura`) es un recurso que aún no existe: se dibuja siempre, con superbg.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/superbg/lib.typ" as superbg

#let _default-theme = (
  paper: rgb("#ece3cf"),
  ink: rgb("#141414"),
  quiet: rgb("#5b564c"),
  accent: rgb("#d3261b"),
  // sin `guide`: v1 no lo tenía y bauhaus no lo usa; modules/color lo deriva
  yellow: rgb("#f2b705"),
  blue: rgb("#1d4e9c"),
)

#let _rules(ctx, lowercase) = {
  let author = ctx.parts.at("author", default: none)
  let author = if author == none { none } else { author.body }
  let dates = ctx.parts.at("dates", default: none)
  let dates = if dates == none { none } else { dates.body }
  let (width, height, tm) = (ctx.width, ctx.height, ctx.tm)
  let (ink, quiet, accent) = (tm.ink, tm.quiet, tm.accent)
  let (yellow, blue) = (tm.yellow, tm.blue)
  let brand = ctx.brand
  let formato = (width / 1pt, height / 1pt)
  let k = calc.min(formato.at(0) / 1080, formato.at(1) / 1350)
  let m = 72pt * k // margen
  let u = calc.min(width, height)
  let text-width = width * 0.54
  let gap-ground = 44pt * k // aire entre la tierra y el texto
  let label(body, size: 26pt, ..args) = text(size: size * k, ..args, body)

  let p = ctx.parts
  let mp = p.at("main", default: none)
  let sentence-body = if mp == none { ctx.loose } else if ctx.has-loose { mp.body + parbreak() + ctx.loose } else { mp.body }
  let props = if mp == none { (:) } else { mp.props }
  let size-sentence = if "size" in props { (ctx.len)(props.size) } else { 62pt * k }

  let tp = p.at("tag", default: none)
  let sp = p.at("subhead", default: none)
  let cp = p.at("conclusion", default: none)
  let conclusion-body = if cp == none { [] } else { cp.body }

  let family = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("jost") }

  {
    set text(font: family, fill: ink, lang: "es")
    set par(leading: 0.34em)

    // textura de papel (v1: `textura: true`, ruido muy tenue en la tinta)
    place(superbg.bg-patron(patron: "ruido", color: ink, opacidad: 14%, size: formato))

    // barra azul al pie, con su remate rojo
    let bar = 20pt * k
    place(bottom + left, dx: m, dy: -160pt * k, rect(width: width - 2 * m, height: bar, fill: blue))
    place(bottom + right, dx: -m, dy: -160pt * k, rect(width: bar * 3, height: bar, fill: accent))
    if brand != none { place(bottom + left, dx: m, dy: -m + 4pt, brand) }

    context {
      // cabecera: autor en versalitas espaciadas, fechas debajo
      let header = if author == none and dates == none { none } else {
        block({
          if author != none { label(size: 32pt, weight: 700, tracking: 0.12em, author) }
          if author != none and dates != none { v(10pt * k) }
          if dates != none { label(size: 28pt, weight: 400, fill: quiet, dates) }
        })
      }
      let (hw, hh) = if header == none { (0pt, 0pt) } else {
        let t = measure(header)
        (t.width, t.height)
      }

      // remate: todo el ancho útil, limitado por el alto en apaisado
      let base = height - 200pt * k // el remate se apoya acá
      let y-min = height * 0.40 // el texto no sube de acá
      let shown = if lowercase { lower(conclusion-body) } else { conclusion-body }
      let word(s) = text(font: family, size: s, weight: 800, tracking: -0.03em, fill: ink, top-edge: "bounds", bottom-edge: "bounds", shown)
      let s = calc.min(
        (ctx.fit-width)(word, width - 2 * m),
        100pt * (0.5 * (base - y-min) / measure(word(100pt)).height),
      )
      let box = word(s)
      let conclusion-y = base - measure(box).height

      // etiqueta, planteo y frase: un bloque apoyado sobre el remate
      let stack(c) = block(width: text-width, {
        if tp != none { label(weight: 700, tracking: 0.1em, fill: accent, tp.body); v(8pt * k) }
        if sp != none { text(size: 40pt * k, weight: 400, fill: quiet, tracking: -0.01em, sp.body); v(18pt * k) }
        text(size: c, weight: 600, tracking: -0.015em, sentence-body)
      })
      let air = 36pt * k // entre la frase y el remate
      let c = (ctx.fit-down)(stack, size-sentence, conclusion-y - air - y-min)
      let measured = measure(stack(c))
      let text-y = conclusion-y - air - measured.height

      // composición: todo apoya en la tierra, justo sobre el texto
      let gt = text-y - gap-ground
      let cap = if height > 1.5 * width { 0.40 * u } else { 0.36 * u }
      let g = 0.046 * u // grosor de la barra
      let min-incl = 22deg
      let air-header = 40pt * k
      let (header-right, header-bottom) = (m + hw, m + hh)
      // Para un lado L: dónde va el borde izquierdo del cuadrado (sx) y si cabe
      // (ver v1: círculo que sangra por la derecha, barra con inclinación
      // mínima, nada a menos de `air-header` de la cabecera).
      let place-for(L) = {
        let cy = gt - L
        let x-min = width * 0.30
        if header != none {
          let dy = calc.max(0pt, cy - header-bottom)
          let r = L + air-header
          if dy < r { x-min = calc.max(x-min, header-right + calc.sqrt(calc.pow(r / 1pt, 2) - calc.pow(dy / 1pt, 2)) * 1pt - L) }
          if cy < header-bottom + air-header { x-min = calc.max(x-min, header-right + air-header) }
        }
        let sx-incl = m + L / calc.tan(min-incl) - L
        let sx-bleed = width - 1.8 * L
        let sx = if sx-incl >= sx-bleed { sx-bleed } else { calc.min(sx-incl, width - m - 2 * L) }
        let sx = calc.max(x-min, sx)
        let cx = sx + L
        let gv = g / calc.cos(calc.atan2((cx - m) / 1pt, L / 1pt))
        let tg = (L - gv / 2) / (cx - m)
        let ok = sx + 1.8 * L <= width + 0.01pt and gt - 2 * L >= -0.5 * L
        if header != none {
          ok = ok and gt - (header-right + air-header - m) * tg - gv >= header-bottom + air-header
        }
        (ok: ok, sx: sx, tg: tg, gv: gv)
      }
      let L = calc.min(cap, gt / 1.5)
      while L > 0.12 * u and not place-for(L).ok { L -= 0.01 * u }
      let (fits, sx, tg, gv) = { let l = place-for(L); (l.ok, l.sx, l.tg, l.gv) }
      let (cx, cy) = (sx + L, gt - L) // esquina = centro del círculo
      let y-at(x) = gt - (x - m) * tg // canto inferior de la barra
      let xf = width + 2 * g

      // Si ni el cuadrado más chico cabe, no hay formas: antes un cartel sin
      // composición que una forma pisando texto.
      if fits {
        place(top + left, dx: cx - L, dy: cy - L, circle(radius: L, fill: yellow))
        place(top + left, dx: sx, dy: cy, rect(width: L, height: L, fill: accent))
        let x1 = sx - 0.14 * L
        place(top + left, polygon(fill: blue, (m, gt), (x1, gt), (x1, y-at(x1))))
        place(top + left, polygon(fill: ink, (m, gt), (xf, y-at(xf)), (xf, y-at(xf) - gv), (m, gt - gv)))
      }

      // textos, encima de todo
      if header != none { place(top + left, dx: m, dy: m, header) }
      place(top + left, dx: m - 0.03 * s, dy: conclusion-y, box)
      place(top + left, dx: m, dy: text-y, stack(c))
    }
  }
}

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  lowercase: true,
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
  extra-roles: ("yellow", "blue"),
  known: ("tag", "subhead", "main", "conclusion", "author", "dates", "brand"),
  fn: "bauhaus",
  elements: elements,
  rules: ctx => _rules(ctx, lowercase),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "bauhaus", make: make, variants: ())
#let bauhaus = frame.with(preset: preset)
