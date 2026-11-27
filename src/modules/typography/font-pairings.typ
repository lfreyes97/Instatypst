// ─────────────────────────────────────────────────────────────
//  lib/font-pairings.typ — parejas tipográficas (rol de fuente → clave de font-tokens)
//
//  Origen: Instatypst-rework/src/font-pairings.typ (21 nov 2026), solo la
//  biblioteca: sin el import de theme.typ ni los componentes de catálogo.
//  Añadido: la pareja `suizo` (la del preset swiss de core/v2) y el rol
//  `annotation` (etiquetas, índices, pies), que en swiss es Inter y no mono.
//  Una pareja sin `annotation` usa su `mono` (o su `body` si no tiene mono).
//
//  nix/catalog.nix lee de aquí la lista de parejas permitidas para un writer:
//  mantener una pareja por línea.
// ─────────────────────────────────────────────────────────────

#let library = (
  "suizo": (display: "bebas-neue", body: "hanken-grotesk", mono: "dm-mono", annotation: "inter"),
  "editorial-clasico": (display: "cormorant", body: "eb-garamond", mono: "dm-mono"),
  "editorial-expresivo": (display: "fraunces", body: "bricolage-grotesque", mono: "iosevka-nf"),
  "geometrico-moderno": (display: "outfit", body: "inter", mono: "googlesanscode-nf"),
  "brutalista": (display: "bebas-neue", body: "hanken-grotesk", mono: "zedmono-nf"),
  "manuscrito-calido": (display: "dm-serif-display", body: "libre-baskerville", hand: "caveat"),
  "revival-vintage": (display: "im-fell-english", body: "cormorant-garamond", mono: "adwaitamono-nerd"),
  "sans-versatil": (display: "syne", body: "urbanist", mono: "dm-mono"),
  "lectura-editorial": (display: "bodoni-moda", body: "literata", mono: "googlesanscode-nf"),
)
