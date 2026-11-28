// ─────────────────────────────────────────────────────────────
//  bordered-question.typ — el preset `bordered-question` (en v1, `carteles.pregunta-orlada`)
//
//  bordered-question = plain (scaffold) + estas reglas.
//  Elementos que reconoce (elements.typ): main, headline, work, hint, brand;
//  cada uno también como argumento (`hint: […]`). La pregunta es `main`;
//  `headline` vale [Para la reflexión] si nadie lo da (como en v1). La obra (v1
//  `obra` y su alias `fuente`) es `work`.
//  Opciones del preset: border, chain.
//
//  Pregunta de estudio sobre una orla de fleurones (IM FELL): friso arriba,
//  encabezado, obra, la pregunta, una pista y una banda abajo. Orla y temas
//  («papel» por defecto, «vino») son del recurso resources/borders.
//
//    border  qué lados llevan orla (v1 `orla`), con los valores de v1.
//            PENDIENTE: el recurso `border` no existe; opción del preset.
//    chain   el marco de la orla (v1 `cadena`; por defecto "cartuchos"): una
//            clave de `fleurones.cadenas`. Opción del preset mientras el recurso
//            no exista (decisiones).
//
//  Escala: las medidas son las de v1, en px del lienzo. Fuentes: IM FELL
//  English e IM FELL English SC, por token (`fonts:` las sobreescribe).
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/modules/fleurones/fleurones.typ" as fl
#import "/src/resources/borders/borders.typ" as borders

#let _rules(ctx, theme-name, border, chain) = {
  let p = ctx.parts
  let mp = p.at("main", default: none)
  let question = if mp == none { ctx.loose } else if ctx.has-loose { mp.body + parbreak() + ctx.loose } else { mp.body }
  let part(kind) = { let e = p.at(kind, default: none); if e == none { none } else { e.body } }
  let headline = if part("headline") == none { [Para la reflexión] } else { part("headline") }
  let (work, hint) = (part("work"), part("hint"))
  let brand = ctx.brand
  let fell = if "body" in ctx.fonts { ctx.fonts.body } else { (ctx.font)("im-fell-english") }
  let fellsc = if "annotation" in ctx.fonts { ctx.fonts.annotation } else { (ctx.font)("im-fell-english-sc") }
  let inner = borders.inner-colors(ctx.tm, theme-name)

  borders.bordered-canvas(fl, ctx, inner, fell, border, chain, (c, w, field-height, kind) => {
    let safe = if kind == "historia" { 200pt } else { 46pt }
    let s = { let n = borders.text-length(question); if n > 160 { 46pt } else if n > 100 { 54pt } else { 62pt } }
    let s = if kind == "historia" { s * 1.12 } else { s }
    box(width: w, height: field-height, inset: (x: 60pt, top: safe, bottom: safe), {
      stack(
        dir: ttb,
        align(center, fl.friso(w - 120pt, c.orn, c.fil)),
        v(34pt),
        align(center, text(font: fellsc, size: 32pt, tracking: 0.22em, fill: c.accent, headline)),
        v(10pt),
        if work != none { align(center, text(font: fell, style: "italic", size: 26pt, fill: c.quiet, work)) } else { [] },
        v(1fr),
        align(center, block(width: 100%, text(font: fell, size: s)[
          #set par(leading: 0.42em)
          #question
        ])),
        if hint != none { v(30pt) } else { v(0pt) },
        if hint != none {
          align(center, block(width: 88%, text(font: fell, style: "italic", size: s * 0.6, fill: c.quiet)[
            #set par(leading: 0.5em)
            #hint
          ]))
        } else { [] },
        v(1fr),
        align(center, fl.banda(fl.f2, "U", w - 120pt, 16pt, c.orn)),
        v(30pt),
        borders.footer-block(fl, c, fellsc, brand),
      )
    })
  })
}

#let make(
  body,
  artboard: (1080, 1080),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  border: "completa",
  chain: "cartuchos",
  ..elements,
) = scaffold(
  body,
  artboard: artboard,
  theme: borders.theme-arg(theme),
  accent: accent,
  brand: brand,
  fonts: fonts,
  default-theme: borders.themes.papel,
  default-fonts: none,
  extra-roles: ("deep",),
  known: ("main", "headline", "work", "hint", "brand"),
  fn: "bordered-question",
  elements: elements,
  rules: ctx => _rules(ctx, borders.base-of(theme, "papel"), border, chain),
)

// El preset y su frame (Spec, caso 2): una línea, sin firma propia. El formato
// por defecto de v1 era el cuadrado.
#let preset = (name: "bordered-question", make: make, variants: (), artboard: "cuadrado")
#let bordered-question = frame.with(preset: preset)
