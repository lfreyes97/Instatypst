// ─────────────────────────────────────────────────────────────
//  FONT-PAIRINGS — biblioteca de combinaciones tipográficas
//  (análogo a palettes.typ, pero para fuentes en vez de colores)
// ─────────────────────────────────────────────────────────────
//
//  #import "font-pairings.typ": pairings
//
//  #let clasica = pairings.as-theme("editorial-clasico")   // → tema para theme.typ
//  #pairings.resolve("editorial-clasico")                  // → dict fonts: listo para theme.define(fonts: ..)
//  #pairings.catalog()                                      // carta visual completa (specimen por pareja)
//  ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "font-tokens.typ": tokens, token, family, by-category

// ===== BIBLIOTECA — cada pareja mapea roles a claves de font-tokens =====
#let library = (
  "editorial-clasico": (display: "cormorant", body: "eb-garamond", mono: "dm-mono"),
  "editorial-expresivo": (display: "fraunces", body: "bricolage-grotesque", mono: "iosevka-nf"),
  "geometrico-moderno": (display: "outfit", body: "inter", mono: "googlesanscode-nf"),
  "brutalista": (display: "bebas-neue", body: "hanken-grotesk", mono: "zedmono-nf"),
  "manuscrito-calido": (display: "dm-serif-display", body: "libre-baskerville", hand: "caveat"),
  "revival-vintage": (display: "im-fell-english", body: "cormorant-garamond", mono: "adwaitamono-nerd"),
  "sans-versatil": (display: "syne", body: "urbanist", mono: "dm-mono"),
  "lectura-editorial": (display: "bodoni-moda", body: "literata", mono: "googlesanscode-nf"),
)

#let names() = library.keys()
#let get(name) = {
  if not (name in library) {
    panic("pareja desconocida: " + name + " — disponibles: " + names().join(", "))
  }
  library.at(name)
}

// Resuelve una pareja a un dict {rol: nombre-de-familia}, listo para
// theme.define(fonts: ..) / theme.with(fonts: ..)
#let resolve(name) = {
  let roles = get(name)
  let out = (:)
  for (role, key) in roles { out.insert(role, family(key)) }
  out
}

// Convierte una pareja en tema (compatible con theme.typ / social.typ)
#let as-theme(name, theme-name: none) = {
  let theme-name = if theme-name == none { name } else { theme-name }
  (theme.define)(theme-name, fonts: resolve(name))
}

// ===== COMPONENTES VISUALES =====

// Texto de muestra por rol, en su propia fuente
#let _sample(role, key, size) = {
  let t = token(key)
  let txt = if role == "mono" { "Aa 123 →" } else { "Aa Bb Cc" }
  stack(spacing: 2pt,
    text(font: t.family, size: size, txt),
    text(size: 6.5pt, fill: luma(45%), font: "Inter")[#role — #t.family #if t.variable [(variable)]],
  )
}

// Tarjeta de specimen para una pareja (para el catálogo)
#let card(name, width: 230pt, size: 20pt) = {
  let roles = get(name)
  block(
    width: width, fill: white, stroke: 0.75pt + luma(85%), radius: 10pt, inset: 14pt,
  )[
    #text(size: 10pt, weight: "bold", font: "Inter")[#name]
    #v(8pt)
    #stack(spacing: 10pt, ..roles.pairs().map(((role, key)) => _sample(role, key, size)))
  ]
}

// Catálogo completo de la biblioteca
#let catalog(columns: 2, gutter: 16pt) = grid(
  columns: columns,
  column-gutter: gutter,
  row-gutter: gutter,
  ..names().map(n => card(n)),
)

// Namespace
#let pairings = (
  library: library,
  names: names,
  get: get,
  resolve: resolve,
  "as-theme": as-theme,
  card: card,
  catalog: catalog,
)
