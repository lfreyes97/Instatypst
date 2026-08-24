// ─────────────────────────────────────────────────────────────
//  FONT-TOKENS — registro único de tipografías, verificado
//
//  Análogo a tokens.typ pero para fuentes: cada entrada es una fuente
//  individual de Fonts/, con el nombre de familia REAL que Typst resuelve
//  (no siempre coincide con el nombre de la carpeta — ver `note` cuando
//  aplica), si es variable, y sus ejes con rango verificado compilando
//  (`typst fonts --variants --font-path Fonts`), no adivinado.
//
//  Módulo hoja (sin imports) — lo importan font-pairings.typ y,
//  potencialmente, theme.typ, igual que tokens.typ (colores).
//
//  #import "font-tokens.typ": tokens, token, family
//  #family("fraunces")          // -> "Fraunces"
//  #token("fraunces").axes.wght // -> (100, 900)
//  ─────────────────────────────────────────────────────────────

#let tokens = (
  "abel": (family: "Abel", category: "display", variable: false),
  "adwaitamono-nerd": (family: "AdwaitaMono Nerd Font", category: "mono", variable: false),
  "baskervville": (family: "Baskervville", category: "body", variable: true, axes: (wght: (400, 700))),
  "bebas-neue": (family: "Bebas Neue", category: "display", variable: false),
  "bodoni-moda": (family: "Bodoni Moda", category: "display", variable: true, axes: (wght: (400, 900), opsz: (6, 96))),
  "bricolage-grotesque": (
    family: "Bricolage Grotesque 96pt", category: "body", variable: true,
    axes: (wght: (200, 800), opsz: (12, 96), wdth: (75, 100)),
    note: "el nombre \"Bricolage Grotesque\" a secas NO es variable — ver hallazgo en examples-variable-fonts.typ",
  ),
  "caveat": (family: "Caveat", category: "hand", variable: true, axes: (wght: (400, 700))),
  "cormorant": (family: "Cormorant", category: "display", variable: true, axes: (wght: (300, 700))),
  "cormorant-garamond": (family: "Cormorant Garamond", category: "body", variable: true, axes: (wght: (300, 700))),
  "dm-mono": (family: "DM Mono", category: "mono", variable: false),
  "dm-sans": (
    family: "DM Sans 9pt", category: "body", variable: true,
    axes: (wght: (100, 900), opsz: (9, 40)),
    note: "el variable real vive en \"DM Sans 9pt\", no en \"DM Sans\" (que es estático) — mismo patrón que Bricolage Grotesque",
  ),
  "dm-serif-display": (family: "DM Serif Display", category: "display", variable: false),
  "eb-garamond": (
    family: "EB Garamond 12", category: "body", variable: false,
    note: "el bundle de Fonts/ solo trae los cortes numerados (08/12/SC); \"EB Garamond\" a secas solo resuelve si el sistema ya la tiene instalada aparte",
  ),
  "fraunces": (family: "Fraunces", category: "display", variable: true, axes: (wght: (100, 900), opsz: (9, 144), SOFT: (0, 100), WONK: (0, 1))),
  "gfs-didot": (family: "GFS Didot", category: "display", variable: false),
  "google-sans-flex": (family: "Google Sans Flex", category: "body", variable: true, axes: (wght: (100, 900), opsz: (6, 144), wdth: (50, 151), GRAD: (0, 100), ROND: (0, 100))),
  "googlesanscode-nf": (family: "GoogleSansCode NF", category: "mono", variable: false),
  "hanken-grotesk": (family: "Hanken Grotesk", category: "body", variable: true, axes: (wght: (100, 900))),
  "im-fell-double-pica": (family: "IM FELL Double Pica", category: "display", variable: false),
  "im-fell-double-pica-sc": (family: "IM FELL Double Pica SC", category: "display", variable: false),
  "im-fell-dw-pica-sc": (family: "IM FELL DW Pica SC", category: "display", variable: false),
  "im-fell-english": (family: "IM FELL English", category: "display", variable: false),
  "im-fell-english-sc": (family: "IM FELL English SC", category: "display", variable: false),
  "im-fell-french-canon-sc": (family: "IM FELL French Canon SC", category: "display", variable: false),
  "im-fell-great-primer": (family: "IM FELL Great Primer", category: "display", variable: false),
  "im-fell-great-primer-sc": (family: "IM FELL Great Primer SC", category: "display", variable: false),
  "instrument-sans": (family: "Instrument Sans", category: "body", variable: true, axes: (wght: (400, 700), wdth: (75, 100))),
  "inter": (family: "Inter", category: "body", variable: true, axes: (wght: (100, 900), opsz: (14, 32))),
  "iosevka-nf": (family: "Iosevka NF", category: "mono", variable: false),
  "jost": (family: "Jost", category: "display", variable: true, axes: (wght: (100, 900))),
  "liga-sfmono-nerd": (family: "Liga SFMono Nerd Font", category: "mono", variable: false),
  "libertinus-serif": (family: "Libertinus Serif", category: "body", variable: false),
  "libre-baskerville": (family: "Libre Baskerville", category: "body", variable: true, axes: (wght: (400, 700))),
  "literata": (family: "Literata", category: "body", variable: true, axes: (wght: (200, 900), opsz: (7, 72))),
  "marcellus": (family: "Marcellus", category: "display", variable: false),
  "noto-serif": (family: "Noto Serif", category: "body", variable: true, axes: (wght: (100, 900), wdth: (62.5, 100))),
  "orments": (
    family: "Orments", category: "ornament", variable: false,
    note: "fuente de dingbats — cada letra del alfabeto mapea a una floritura ornamental distinta, no a texto legible",
  ),
  "outfit": (family: "Outfit", category: "display", variable: true, axes: (wght: (100, 900))),
  "poppins": (family: "Poppins", category: "display", variable: false),
  "prata": (family: "Prata", category: "display", variable: false),
  "pt-sans": (family: "PT Sans", category: "body", variable: false),
  "public-sans": (family: "Public Sans", category: "body", variable: false),
  "readex-pro": (family: "Readex Pro", category: "body", variable: true, axes: (wght: (160, 700))),
  "syne": (family: "Syne", category: "display", variable: true, axes: (wght: (400, 800))),
  "urbanist": (family: "Urbanist", category: "body", variable: true, axes: (wght: (100, 900))),
  "ysabeau": (family: "Ysabeau", category: "body", variable: true, axes: (wght: (100, 900))),
  "ysabeau-infant": (family: "Ysabeau Infant", category: "body", variable: true, axes: (wght: (100, 900))),
  "ysabeau-office": (family: "Ysabeau Office", category: "body", variable: true, axes: (wght: (100, 900))),
  "ysabeau-sc": (family: "Ysabeau SC", category: "display", variable: true, axes: (wght: (100, 900))),
  "zedmono-nf": (family: "ZedMono NF", category: "mono", variable: false),
  "zen-old-mincho": (family: "Zen Old Mincho", category: "display", variable: false),
)

#let token(key) = {
  if not (key in tokens) { panic("token de fuente desconocido: " + key + " — ver font-tokens.tokens.keys()") }
  tokens.at(key)
}

// Nombre de familia listo para pasar a text(font: ...)
#let family(key) = token(key).family

// Todas las claves de una categoría ("display" | "body" | "mono" | "hand")
#let by-category(cat) = tokens.keys().filter(k => tokens.at(k).category == cat)

// Namespace
#let font-tokens = (
  tokens: tokens,
  token: token,
  family: family,
  "by-category": by-category,
)
