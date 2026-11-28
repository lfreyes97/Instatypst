// ─────────────────────────────────────────────────────────────
//  vendor/reticula.typ — la retícula de WallTypst (columnas × filas + zona segura)
//
//  EXTRACCIÓN de `templates/wall.typ` (WallTypst, líneas 331–393: `safe-nombrados`,
//  `lay`, `contenedor`, `celda`), no copia literal: en wall.typ viven dentro del
//  monolito y leen `p`, `W`, `H` y `u` globales; aquí son parámetros. La lógica
//  no cambia. TEMPORAL: al final se sustituye por la mecánica de retícula de
//  `swiss` (hoy `_columns` privado, sin filas ni sangrado) o por `put` (Spec, caso 7).
//
//    reticula(width, height, u, layout) → celda(g) → (x:, y:, w:, h:)
//
//  width, height   el artboard en px, números (sin `pt`)
//  u               la unidad de WallTypst: lado corto / 1000 (número)
//  layout          el `[layout]` del TOML ya resuelto por aspecto:
//                  columns, rows, gutter, row-gutter, margin (número o (mx, my)),
//                  safe (nombre o diccionario), container, max-width
//  g               la celda: col, span, row, rows, offset, row-offset, bleed
//                  (true | "x" | "y" | lado), safe
//  Todo en números (px); quien dibuja multiplica por 1pt.
// ─────────────────────────────────────────────────────────────

#let safe-nombrados = (
  ninguna: (:),
  escritorio: (left: 150, top: 56, bottom: 80),
  gnome: (top: 48),
  windows: (left: 150, bottom: 76),
  macos: (left: 0, top: 40, bottom: 90),
)

#let reticula(W, H, u, layout) = {
  let l = layout
  let sf = l.at("safe", default: "ninguna")
  let sf = if type(sf) == str { safe-nombrados.at(sf) } else { sf }
  let mg = l.at("margin", default: 80)
  let (mx, my) = if type(mg) == array { mg } else { (mg, mg) }
  let mw = l.at("max-width", default: 1)
  let lay = (
    container: l.at("container", default: "fluid"),
    columns: l.at("columns", default: 12),
    rows: l.at("rows", default: 12),
    gutter: l.at("gutter", default: 24) * u,
    row-gutter: l.at("row-gutter", default: l.at("gutter", default: 24)) * u,
    mx: mx * u,
    my: my * u,
    max-width: if mw <= 1 { mw * W } else { mw * u },
    safe: ("left", "top", "right", "bottom").map(k => (k, sf.at(k, default: 0) * u)).to-dict(),
  )

  let contenedor(seguro: true) = {
    let s = if seguro { lay.safe } else { (left: 0, top: 0, right: 0, bottom: 0) }
    let (ax, ay) = (s.left, s.top)
    let (aw, ah) = (W - s.left - s.right, H - s.top - s.bottom)
    let w = aw - 2 * lay.mx
    let w = if lay.container == "fixed" { calc.min(lay.max-width, w) } else { w }
    (x: ax + (aw - w) / 2, y: ay + lay.my, w: w, h: ah - 2 * lay.my)
  }

  let celda(g) = {
    let k = contenedor(seguro: g.at("safe", default: true))
    let (n, nr) = (lay.columns, lay.rows)
    let cw = (k.w - (n - 1) * lay.gutter) / n
    let rh = (k.h - (nr - 1) * lay.row-gutter) / nr
    let col = g.at("col", default: 1) + g.at("offset", default: 0)
    let span = g.at("span", default: n - col + 1)
    let span = if span == "full" { n - col + 1 } else { span }
    let row = g.at("row", default: 1) + g.at("row-offset", default: 0)
    let rows = g.at("rows", default: nr - row + 1)
    let rows = if rows == "full" { nr - row + 1 } else { rows }
    let x = k.x + (col - 1) * (cw + lay.gutter)
    let y = k.y + (row - 1) * (rh + lay.row-gutter)
    let w = span * cw + (span - 1) * lay.gutter
    let h = rows * rh + (rows - 1) * lay.row-gutter
    let b = g.at("bleed", default: false)
    let lados = if b == true { ("left", "right", "top", "bottom") } else if b == "x" { ("left", "right") } else if b == "y" { ("top", "bottom") } else if b == false { () } else { (b,) }
    let (x, w) = if "left" in lados and col == 1 { (0, w + x) } else { (x, w) }
    let w = if "right" in lados and col + span - 1 == n { W - x } else { w }
    let (y, h) = if "top" in lados and row == 1 { (0, h + y) } else { (y, h) }
    let h = if "bottom" in lados and row + rows - 1 == nr { H - y } else { h }
    (x: x, y: y, w: w, h: h)
  }
  celda
}
