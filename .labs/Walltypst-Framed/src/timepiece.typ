// ─────────────────────────────────────────────────────────────
//  timepiece.typ — el preset `timepiece`: calendarios y relojes de WallTypst
//
//  timepiece = plain (scaffold) + estas reglas. Una variante por preset de WallTypst:
//
//    variant           WallTypst           qué es
//    "month" (auto)    calendario          calendario a la derecha, papel claro
//    "month-verse"     verso-calendario    calendario arriba y verso abajo, verde noche con curvas
//    "digital"         reloj               hora tipográfica enorme y fecha, negro grafito
//    "analog"          reloj-analogico     esfera de filetes, índices de imprenta
//    "daylight"        hora-del-dia        cielo por franjas según la hora, astro, verso y hora al centro
//    "lords-day"       dia-del-senor       el nombre del día cruza lo alto; el domingo, «Día del Señor» sobre vino
//    "hour"            cartel-hora         la hora en condensada gigante, tono sobre tono; fecha y verso arriba
//                                          (se ignora el prefijo `cartel`)
//
//  Elementos que reconoce (elements.typ): calendar (year, month, today, marks, week, cell),
//  clock (time, date, style, show-time), verse + work (la referencia), brand. Opciones: margin.
//
//    #timepiece(artboard: (1920, 1080))[
//      #calendar(year: 2026, month: 12, today: 3,
//        marks: ((day: 6, label: "Santa Cena"), (day: 13, label: "Reunión de oración"), 24, 25))
//    ]
//    #timepiece(variant: "month-verse", artboard: (1920, 1080))[
//      #calendar(year: 2026, month: 11, today: 19, marks: ((day: 29, label: "Santa Cena"),))
//      #verse[Es por la misericordia de Jehová que no somos consumidos…]
//      #work[Lamentaciones 3:22–23  ·  RV1909]
//    ]
//    #timepiece(variant: "digital", artboard: (1920, 1080))[#clock(time: "21:07", date: "2026-11-22")]
//    #timepiece(variant: "analog",  artboard: (1920, 1080))[#clock(time: "21:07", date: "2026-11-22")]
//    #timepiece(variant: "daylight", artboard: (1920, 1080))[
//      #clock(time: "09:48", date: "2026-11-19")
//      #verse[…]  #work[Lamentaciones 3:22–23  ·  RV1909]
//    ]
//
//  La franja (daylight) y el día de la semana (lords-day) se derivan de `clock(time:, date:)`:
//  el preset los calcula, no hay entradas ocultas. La retícula (columnas × filas, zona segura,
//  sangrado) es `vendor/reticula.typ`, extraída de WallTypst; temporal (ver vendor/README.md).
//
//  WallTypst → V2 (una línea por clave de los TOML):
//    [[layers]] plano color=paper|bg  → el papel del tema (`paper`)
//    [[layers]] ruido                 → recurso `grain`: aún no existe; se dibuja siempre
//    [[layers]] gradiente (digital)   → motor: superbg `gradiente`
//    [[layers]] curvas topo (month-verse) → vendor/curvas.typ, copia de v1 (candidato a un
//                                       módulo `topography`); cumbres = rango [2,4] se
//                                       resolvió con semilla 1 → 3
//    [[layers]] vignette (month-verse)→ motor: superbg `vignette`
//    [colors] paper/ink/accent/muted  → tema: paper, ink, accent; `muted` es `quiet`
//    [fonts]                          → display, body (cada variante, las suyas)
//    [[blocks]] kind=calendar         → `#calendar(...)`
//    [[blocks]] kind=clock            → `#clock(time:, date:, style:)`; `time = false` → show-time: false
//    [[blocks]] kind=verse            → `#verse[…]` y `#work[…]` (la referencia con la versión;
//                                       WallTypst la armaba «ref  ·  versión»)
//    position / at / dy / margin      → la colocación es del variant
//    cell, month-size, size, gap…     → valores de la variante (en k de WallTypst)
//    *-color (sunday, head, tick, hand…) → el tema, no opciones
//    rule=below | rule=between        → el filete bajo el mes / entre verso y referencia
//    muestras                         → harness: las llamadas de arriba
//
//  Sin `time` el reloj no dibuja la hora (como WallTypst sin `now`); `date` sin dar es hoy.
//  `year`/`month` por defecto son los de hoy; `today` solo se marca si el mes es el actual.
//  V2 no tiene capa de datos: nada se lee de un JSON.
//
//  Escala: k = lado corto / 1000, la de WallTypst (no la u de V2, que es /1080), para
//  poder medir la paridad.
// ─────────────────────────────────────────────────────────────

#import "/src/plain/scaffold.typ": scaffold
#import "/src/frame.typ": frame
#import "/src/core/parts.typ": read-parts
#import "/src/modules/color/palettes/contrast.typ": contrast
#import "/src/modules/superbg/lib.typ": superbg
#import "vendor/curvas.typ" as curvas
#import "vendor/reticula.typ": reticula
#import "engines/glitcher.typ" as glitcher
#import "common.typ": legible, verse-block, aspect, pick, in-cell

#let _themes = (
  default: (
    paper: rgb("#f3efe7"),
    ink: rgb("#24211d"),
    quiet: rgb("#857c70"),
    accent: rgb("#9c3a24"),
  ),
  month-verse: (
    paper: rgb("#15201c"),
    ink: rgb("#e7e2d4"),
    quiet: rgb("#8f9a8a"),
    accent: rgb("#d2a85a"),
  ),
  digital: (
    paper: rgb("#121417"),
    ink: rgb("#c9c4ba"),
    quiet: rgb("#c9c4ba"),
    accent: rgb("#d98b5f"),
  ),
  hour: (
    paper: rgb("#10201f"),
    ink: rgb("#ece5d6"),
    accent: rgb("#e2a65b"),
    tone: rgb("#183130"),
  ),
  analog: (
    paper: rgb("#e7e4dd"),
    ink: rgb("#1d1c1a"),
    quiet: rgb("#77736b"),
    accent: rgb("#d04a2a"),
  ),
)

#let _dias = ("lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo")
#let _meses = ("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")

#let _dias-mes(y, mo) = int((
  if mo == 12 { datetime(year: y + 1, month: 1, day: 1) } else { datetime(year: y, month: mo + 1, day: 1) }
  - datetime(year: y, month: mo, day: 1)
).days())

// el calendario: devuelve el bloque. `cell` y `month-size` en k; `rule` pinta el filete bajo el mes
#let _calendar(ctx, props, k, cell: 64, month-size: 72, gap: 26, rule: true, legend: true, today-fill: auto, year-scale: 0.42) = {
  let L(v) = v * k
  let (paper, ink, accent, muted) = (ctx.tm.paper, ctx.tm.ink, ctx.tm.accent, ctx.tm.quiet)
  let on(c, size) = legible(c, paper, ink, size)

  let today = datetime.today()
  let year = props.at("year", default: today.year())
  let month = props.at("month", default: today.month())
  let hoy = props.at("today", default: if year == today.year() and month == today.month() { today.day() } else { none })
  let marks = props.at("marks", default: ()).map(x => if type(x) == dictionary { x } else { (day: x) })
  let monday-first = props.at("week", default: "domingo") == "lunes"

  let cell = L(props.at("cell", default: cell))
  let fs = cell * 0.4
  let initials = if monday-first { ("L", "M", "X", "J", "V", "S", "D") } else { ("D", "L", "M", "X", "J", "V", "S") }
  let first = datetime(year: year, month: month, day: 1).weekday()
  let gap-days = if monday-first { first - 1 } else { calc.rem(first, 7) }
  let is-sunday(i) = if monday-first { calc.rem(i, 7) == 6 } else { calc.rem(i, 7) == 0 }

  let family-display = (ctx.font)("Fraunces")
  let family-body = (ctx.font)("Instrument Sans")
  let size-month = L(month-size)
  let fill-today = if today-fill == auto { ink } else { today-fill }

  let head = {
    let name = _meses.at(month - 1)
    let m = text(font: family-display, size: size-month, weight: 400, fill: on(ink, size-month), upper(name.slice(0, 1)) + name.slice(1))
    let y = text(font: family-body, size: size-month * year-scale, fill: on(muted, size-month * year-scale), str(year))
    box(width: 7 * cell, align(left, stack(dir: ltr, spacing: cell * 0.25, m, y)))
  }

  let weekdays = range(7).map(i => box(width: cell, height: cell * 0.7, align(center + horizon,
    text(font: family-body, size: fs * 0.78, tracking: 0.08em,
      fill: on(if is-sunday(i) { accent } else { muted }, fs * 0.78), initials.at(i)))))

  let on-disc = legible(paper, fill-today, ink, 0pt)
  let cells = range(gap-days).map(_ => box(width: cell, height: cell)) + range(1, _dias-mes(year, month) + 1).map(d => {
    let i = gap-days + d - 1
    let marked = marks.any(x => x.day == d)
    let is-today = d == hoy
    let dot-color = if is-today { on-disc } else { accent }
    let num = text(font: family-body, number-width: "tabular", size: fs, weight: 500,
      fill: if is-today { on-disc } else if is-sunday(i) { on(accent, fs) } else { on(ink, fs) }, str(d))
    box(width: cell, height: cell, {
      if is-today { place(center + horizon, circle(radius: cell * 0.38, fill: fill-today)) }
      place(center + horizon, num)
      if marked { place(center + horizon, dy: cell * 0.3, circle(radius: cell * 0.045, fill: dot-color)) }
    })
  })
  let grid-days = grid(columns: (cell,) * 7, ..weekdays, ..cells)

  let line-rule = if rule { line(length: 7 * cell, stroke: L(1.2) + on(muted, 0pt)) }
  let notes = marks.filter(x => "label" in x).map(x => box(width: 7 * cell, align(left,
    text(font: family-body, size: fs * 0.82, fill: on(muted, fs * 0.82),
      [#text(number-width: "tabular", str(x.day))#h(0.8em)#x.label]))))
  let notes = if notes.len() > 0 and legend { stack(dir: ttb, spacing: fs * 0.5, ..notes) }

  stack(dir: ttb, spacing: L(gap), ..(head, line-rule, grid-days, notes).filter(x => x != none).map(x => align(left, x)))
}

// la fecha de `clock`: un datetime, "AAAA-MM-DD" o (sin dar) hoy
#let _date(props) = {
  let d = props.at("date", default: none)
  if d == none { datetime.today() } else if type(d) == str {
    let (y, mo, dd) = d.split("-").map(int)
    datetime(year: y, month: mo, day: dd)
  } else { d }
}
#let _long-date(d) = _dias.at(d.weekday() - 1) + " " + str(d.day()) + " de " + _meses.at(d.month() - 1)

// la esfera: índices de imprenta y dos agujas, con filetes
#let _dial(ctx, hour, minute, d, minutes: true) = {
  let (ink, accent, muted) = (ctx.tm.ink, ctx.tm.accent, ctx.tm.quiet)
  let r = d / 2
  let pt(a, rr) = (r + rr * calc.cos(a), r + rr * calc.sin(a))
  let ticks = range(60).map(i => {
    let major = calc.rem(i, 5) == 0
    if not major and not minutes { return none }
    let a = i * 6deg - 90deg
    let l = if major { d * 0.075 } else { d * 0.03 }
    let r0 = r * 0.94
    place(top + left, line(start: pt(a, r0 - l), end: pt(a, r0),
      stroke: (paint: if major { ink } else { muted }, thickness: if major { d * 0.012 } else { d * 0.004 }, cap: "butt")))
  })
  let hand(a, len, w, c) = place(top + left, line(start: pt(a + 180deg, d * 0.07), end: pt(a, len), stroke: (paint: c, thickness: w, cap: "butt")))
  let ah = (calc.rem(hour, 12) + minute / 60) * 30deg - 90deg
  let am = minute * 6deg - 90deg
  box(width: d, height: d, {
    ticks.filter(x => x != none).join()
    hand(ah, r * 0.52, d * 0.034, ink)
    hand(am, r * 0.8, d * 0.022, ink)
    place(top + left, dx: r - d * 0.025, dy: r - d * 0.025, circle(radius: d * 0.025, fill: accent))
  })
}

// el reloj: hora (cifras o esfera) + fecha debajo. `size` y `gap` en k
#let _clock(ctx, props, k, style, size: 300, weight: 100, tracking: -0.02, date-step: 4.6, date-min: 22,
    date-weight: 400, date-tracking: 0.24, date-color: auto, gap: 26, font: "Outfit", date-font: "Outfit", align-to: right,
    show-time: auto) = {
  let L(v) = v * k
  let (paper, ink, accent) = (ctx.tm.paper, ctx.tm.ink, ctx.tm.accent)
  let on(c, s) = legible(c, paper, ink, s)
  let s = L(size)
  let ds = calc.max(L(date-min), s / calc.pow(1.618, date-step))
  let dc = if date-color == auto { accent } else { date-color }
  let show-time = if show-time == auto { props.at("show-time", default: true) } else { show-time }
  let time = props.at("time", default: none)
  let date-line = text(font: (ctx.font)(date-font), size: ds, weight: date-weight, tracking: date-tracking * 1em,
    fill: on(dc, ds), upper(_long-date(_date(props))))
  let face = if time == none or not show-time { none } else if style == "analog" {
    let (h, mi) = time.split(":").map(int)
    _dial(ctx, h, mi, s)
  } else {
    text(font: (ctx.font)(font), size: s, weight: weight, tracking: tracking * 1em, fill: on(ink, s),
      number-width: "tabular", top-edge: "cap-height", bottom-edge: "baseline", time)
  }
  stack(dir: ttb, spacing: L(gap), ..(face, date-line).filter(x => x != none).map(x => align(align-to, x)))
}

// el cielo de `daylight`: las cuatro franjas de WallTypst (`vars.cielo`) según la hora de `clock`.
// Cada franja: (cielo alto, cielo bajo, tinta, astro, altura del astro). Rige la última que ya empezó.
// Durante `mezcla` minutos WallTypst «interpola», pero sobre arreglos su `mezclar` no mezcla: elige
// la anterior o la nueva según pasen o no de la mitad. Aquí se replica ese comportamiento.
#let _bands = (
  ("05:30", ("#f3d6c1", "#fbeee2", "#3a2a2a", "#e8754a", 0.66)),
  ("10:00", ("#cfe2ee", "#f4f1ea", "#1d2a33", "#f4c44e", 0.3)),
  ("17:30", ("#3a2f55", "#e48a5a", "#fbf1e6", "#ffb35c", 0.7)),
  ("20:30", ("#0d1220", "#1c2438", "#e8e2d4", "#e8e2d4", 0.24)),
)
#let _minutes(t) = { let (a, b) = t.split(":").map(int); a * 60 + b }
#let _sky(props) = {
  let time = props.at("time", default: "12:00")
  let now = _minutes(time)
  let i = range(_bands.len()).filter(j => _minutes(_bands.at(j).first()) <= now)
  let i = if i.len() == 0 { _bands.len() - 1 } else { i.last() }
  let (start, val) = (_bands.at(i).first(), _bands.at(i).last())
  let prev = _bands.at(calc.rem(i - 1 + _bands.len(), _bands.len())).last()
  let elapsed = calc.rem(now - _minutes(start) + 1440, 1440)
  let v = if elapsed < 60 and elapsed / 60 < 0.5 { prev } else { val }
  (high: rgb(v.at(0)), low: rgb(v.at(1)), ink: rgb(v.at(2)), sun: rgb(v.at(3)), height: v.at(4))
}

// dia-del-senor: el domingo, vino; los demás días, papel. Colores de `vars.tema`.
#let _is-sunday(props) = _date(props).weekday() == 7
#let _lords-theme(props) = if _is-sunday(props) {
  (paper: rgb("#5b1726"), ink: rgb("#f6ede0"), accent: rgb("#e2b45c"), tone: rgb("#7a2435"))
} else {
  (paper: rgb("#f1ede5"), ink: rgb("#22201d"), accent: rgb("#6f6a62"), tone: rgb("#d9d1c2"))
}

#let _rules(ctx, margin, variant) = {
  let part(k) = ctx.parts.at(k, default: none)
  let (width, height) = (ctx.width, ctx.height)
  let k = calc.min(width, height) / 1000
  let L(v) = v * k
  let props-of(name) = { let p = part(name); if p == none { (:) } else { p.props } }
  let landscape = width > height
  let ultra = width / height > 2
  let size = (width / 1pt, height / 1pt)

  if variant == "month" {
    // el grano de papel: recurso que aún no existe, se dibuja siempre
    place(top + left, superbg(((tipo: "ruido", color: rgb("#5a4a30"), opacidad: 5%),), size: size))
    let block = _calendar(ctx, props-of("calendar"), k, year-scale: 0.4)
    place(if landscape { right + horizon } else { center + horizon }, dx: if landscape { -L(margin) } else { 0pt }, block)
  } else if variant == "month-verse" {
    // curvas de nivel y viñeta; semilla de WallTypst: seed·7 + índice de capa (1) = 8
    let field = (curvas.campo)("topo", diapositivas: 1, formato: size, semilla: 8, color: rgb("#a7b89c"),
      grosor: L(1), opacidad: 12%, sep: 26 * k / 1pt, cumbres: 3)
    place(top + left, (curvas.ventana)(field, 0))
    place(top + left, superbg(((tipo: "vignette", color: black, intensidad: 45%),), size: size))

    let col = if ultra { 0.74 } else if landscape { 0.69 } else { 0.14 }
    let dy = if landscape { 100 } else { 160 }
    let cal = _calendar(ctx, props-of("calendar"), k, cell: if landscape { 48 } else { 66 }, month-size: if landscape { 50 } else { 70 },
      gap: 16, rule: false, legend: false, today-fill: ctx.tm.accent)
    place(top + left, dx: col * width, dy: L(dy), cal)

    let v = part("verse")
    if v != none {
      let work = part("work")
      let ref = if work == none { none } else { work.body }
      let verse = verse-block(ctx, v.body, ref, k, width: if landscape { 520 } else { 760 }, height: if landscape { 300 } else { 560 },
        size: 40, min-size: 24, ratio: 1.5, leading: 0.36, ref-weight: 500, ref-tracking: 0.16, ref-step: 3, ref-min: 18,
        ref-color: ctx.tm.accent, gap: 20, rule: true)
      context {
        let hh = measure(verse).height
        place(top + left, dx: col * width, dy: height - hh - L(dy), verse)
      }
    }
  } else if variant == "digital" {
    place(top + left, superbg((
      (tipo: "gradiente", estilo: "linear", from: rgb("#1a1d22"), to: rgb("#0d0e10"), angulo: 90deg),
      (tipo: "ruido", color: white, opacidad: 5%),
    ), size: size))
    let block = _clock(ctx, props-of("clock"), k, "digital")
    place(bottom + right, dx: -L(100), dy: -L(110), block)
  } else if variant == "analog" {
    place(top + left, superbg(((tipo: "ruido", color: black, opacidad: 4%),), size: size))
    let block = _clock(ctx, props-of("clock"), k, "analog", size: 540, date-step: 5, date-min: 20, date-weight: 500,
      date-tracking: 0.2, date-color: ctx.tm.quiet, gap: 40, font: "Instrument Sans", date-font: "Instrument Sans", align-to: center)
    let fx = if ultra { 0.76 } else if landscape { 0.72 } else { 0.5 }
    let fy = if landscape { 0.48 } else { 0.42 }
    context {
      let m = measure(block)
      place(top + left, dx: fx * width - m.width / 2, dy: fy * height - m.height / 2, block)
    }
  } else if variant == "daylight" {
    let ku = k / 1pt
    let asp = aspect(width, height)
    let sky = _sky(props-of("clock"))
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 10, vertical: 14), asp),
      gutter: 24, margin: pick((apaisado: 90, vertical: 60), asp), safe: "escritorio"))
    // cielo: gradiente alto → bajo, astro, el suelo (velo del 35 %) y el horizonte (filete al 40 %)
    place(top + left, superbg(((tipo: "gradiente", from: ctx.tm.paper, to: ctx.tm.low, angulo: 90deg),), size: size))
    let r = L(70)
    place(top + left, dx: pick((apaisado: 0.9, ultra: 0.88, vertical: 0.8), asp) * width - r, dy: sky.height * height - r,
      circle(radius: r, fill: ctx.tm.sun))
    place(top + left, dy: 0.78 * height, rect(width: L(9999), height: L(9999), fill: ctx.tm.paper.transparentize(65%)))
    place(top + left, line(start: (0pt, 0.78 * height), end: (width, 0.78 * height),
      stroke: (paint: ctx.tm.ink.transparentize(60%), thickness: L(1.2), cap: "butt")))

    let v = part("verse")
    if v != none {
      let work = part("work")
      let c = cell(pick((apaisado: (col: 3, span: 7, row: 1, rows: 5), ultra: (col: 5, span: 8, row: 1, rows: 5),
        vertical: (col: 1, span: 6, row: 3, rows: 6)), asp))
      in-cell(c, "center", verse-block(ctx, v.body, if work == none { none } else { work.body }, k, width: c.w / ku, height: c.h / ku,
        margin-x: 0, margin-y: 0, size: 62, min-size: 32, weight: 500, style: "italic", leading: 0.3, font: "Cormorant Garamond",
        ref-font: "Hanken Grotesk", ref-tracking: 0.16, ref-step: 3.6, ref-min: 18, ref-color: ctx.tm.ink, gap: 34, align-to: center))
    }
    let c = cell(pick((apaisado: (col: 5, span: 4, row: 9, rows: 1), ultra: (col: 7, span: 4, row: 9, rows: 1),
      vertical: (col: 2, span: 4, row: 12, rows: 1)), asp))
    in-cell(c, "top", _clock(ctx, props-of("clock"), k, "digital", size: 40, weight: 300, tracking: 0.1, date-step: 1.6, date-min: 16,
      date-weight: 400, date-tracking: 0.2, date-color: ctx.tm.ink, gap: 8, font: "Hanken Grotesk", date-font: "Hanken Grotesk", align-to: center))
  } else if variant == "lords-day" {
    let ku = k / 1pt
    let asp = aspect(width, height)
    let cell = reticula(width / 1pt, height / 1pt, ku, (
      columns: pick((apaisado: 12, ultra: 16, vertical: 6), asp), rows: pick((apaisado: 10, vertical: 14), asp),
      gutter: 24, margin: pick((apaisado: 80, vertical: 56), asp), safe: "escritorio"))
    let props = props-of("clock")
    let sunday = _is-sunday(props)

    // el nombre del día (o «Día del Señor») a todo el ancho, sangrando a los lados
    let c = cell((row: 1, rows: 4, bleed: "x"))
    let title = upper(if sunday { "Día del Señor" } else { _dias.at(_date(props).weekday() - 1) })
    place(top + left, dx: c.x * 1pt, dy: c.y * 1pt, box(width: c.w * 1pt, height: c.h * 1pt, context {
      let t = glitcher.line(title, c.w * 1pt, c.h * 1pt, ((color: if sunday { ctx.tm.ink } else { ctx.tm.tone }),), k, font: (ctx.font)("Bebas Neue"))
      place(top + left, dx: L(24), dy: c.h * 1pt / 2 - measure(t).height / 2, t)
    }))

    let c = cell(pick((apaisado: (col: 3, span: 10, row: 5, rows: 1), ultra: (col: 5, span: 12, row: 5, rows: 1),
      vertical: (col: 1, span: 6, row: 5, rows: 1)), asp))
    in-cell(c, "top-left", _clock(ctx, props, k, "digital", show-time: false, size: 200, date-font: "Hanken Grotesk", date-weight: 600,
      date-step: 4.2, date-min: 20, date-tracking: 0.22, date-color: ctx.tm.accent, gap: 24, align-to: left))

    let v = part("verse")
    if v != none {
      let work = part("work")
      let c = cell(pick((apaisado: (col: 3, span: 8, row: 6, rows: 5), ultra: (col: 5, span: 9, row: 6, rows: 5),
        vertical: (col: 1, span: 6, row: 6, rows: 8)), asp))
      in-cell(c, "top-left", verse-block(ctx, v.body, if work == none { none } else { work.body }, k, width: c.w / ku, height: c.h / ku,
        margin-x: 0, margin-y: 0, size: 58, min-size: 30, leading: 0.28, font: "DM Serif Display", ref-font: "Hanken Grotesk",
        ref-weight: 600, ref-tracking: 0.18, ref-step: 3.4, ref-min: 18, ref-color: ctx.tm.accent, gap: 32, align-to: left))
    }
  } else if variant == "hour" {
    let asp = aspect(width, height)
    let props = props-of("clock")
    let time = props.at("time", default: none)
    // la hora en condensada gigante, tono sobre tono, sangrando por abajo a todo el ancho
    if time != none {
      let g(sz) = text(font: (ctx.font)("Bebas Neue"), size: sz, weight: "regular", fill: ctx.tm.tone,
        top-edge: "bounds", bottom-edge: "bounds", time)
      context {
        let s0 = L(900)
        let target = pick((apaisado: 1.0, ultra: 0.8, vertical: 1.04), asp) * width
        let sz = calc.min(s0 * (target / measure(g(s0)).width), L(1500))
        let b = g(sz)
        let m = measure(b)
        place(top + left, dx: 0.5 * width - m.width / 2, dy: height - m.height + L(110), b)
      }
    }
    place(top + left, superbg(((tipo: "ruido", color: white, opacidad: 4%),), size: size))
    place(top + right, dx: -L(90), dy: L(90), _clock(ctx, props, k, "digital", show-time: false, size: 200, date-font: "Hanken Grotesk",
      date-weight: 600, date-step: 4.4, date-min: 20, date-tracking: 0.2, date-color: ctx.tm.accent, gap: 24, align-to: right))
    let v = part("verse")
    if v != none {
      let work = part("work")
      place(top + right, dx: -L(90), dy: L(150), verse-block(ctx, v.body, if work == none { none } else { work.body }, k,
        width: pick((apaisado: 760, vertical: 880), asp), height: pick((apaisado: 300, vertical: 560), asp), margin-x: 90, margin-y: 150,
        size: 52, min-size: 28, leading: 0.26, font: "DM Serif Display", ref-font: "Hanken Grotesk", ref-weight: 600,
        ref-tracking: 0.16, ref-step: 3, ref-min: 18, ref-color: ctx.tm.accent, gap: 18, align-to: right))
    }
  }
  if ctx.brand != none { place(bottom + left, dx: L(margin), dy: -L(margin), ctx.brand) }
}

#let variants = ("month", "month-verse", "digital", "analog", "daylight", "lords-day", "hour")

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  accent: auto,
  brand: none,
  fonts: auto,
  variant: "month",
  margin: 120,
  ..elements,
) = {
  let variant = if variant == auto { "month" } else { variant }
  assert(variant in variants, message: "timepiece: variante desconocida " + repr(variant) + " (hay: " + variants.join(", ") + ")")
  // el tema por defecto: fijo, o derivado de `clock` (la franja del día, el día de la semana)
  let clock = read-parts(body, known: ("clock",)).parts.at("clock", default: none)
  let clock = if clock == none { (:) } else { clock.props }
  let (default-theme, extra-roles) = if variant == "daylight" {
    let sky = _sky(clock)
    ((paper: sky.high, ink: sky.ink, accent: none, low: sky.low, sun: sky.sun), ("low", "sun"))
  } else if variant == "lords-day" {
    (_lords-theme(clock), ("tone",))
  } else if variant == "hour" {
    (_themes.hour, ("tone",))
  } else {
    (_themes.at(if variant == "month" { "default" } else { variant }), ())
  }
  scaffold(
    body,
    artboard: artboard,
    theme: theme,
    accent: accent,
    brand: brand,
    fonts: fonts,
    default-theme: default-theme,
    default-fonts: none,
    extra-roles: extra-roles,
    known: ("calendar", "clock", "verse", "work", "brand"),
    fn: "timepiece",
    elements: elements,
    rules: ctx => _rules(ctx, margin, variant),
  )
}

// El preset y su frame (Spec, caso 2): una línea, sin firma propia.
#let preset = (name: "timepiece", make: make, variants: variants, artboard: (1920, 1080))
#let timepiece = frame.with(preset: preset)
