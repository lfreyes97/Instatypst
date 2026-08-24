// ─────────────────────────────────────────────────────────────
//  TOKENS — registro único de colores individuales y nombrados
//
//  Módulo hoja (sin imports): tanto theme.typ (colores de marca base)
//  como palettes.typ (biblioteca de paletas decorativas) importan de
//  aquí, así que cada color existe en un solo lugar y se puede
//  reutilizar libremente entre ambos sin duplicar hex.
//
//  Convención de nombres: familia-intensidad, estilo Tailwind
//  (50 = más claro, 950 = más oscuro).
//
//  #import "tokens.typ": tokens, token
//  #token("sky-400")
//  ─────────────────────────────────────────────────────────────

#let tokens = (
  "stone-25": rgb("#ffffff"),
  "stone-700": rgb("#50514f"),
  "stone-850": rgb("#202020"),
  "stone-975": rgb("#000000"),
  "blue-650": rgb("#3c3d6c"),
  "blue-700": rgb("#3d405b"),
  "blue-800": rgb("#2b2d42"),
  "blue-900": rgb("#0a1128"),
  "sky-100": rgb("#d6e2e9"),
  "sky-200": rgb("#a3c4f3"),
  "sky-225": rgb("#bcd4e6"),
  "sky-250": rgb("#99c1de"),
  "sky-400": rgb("#6b9ac4"),
  "sky-425": rgb("#8d99ae"),
  "sky-600": rgb("#0066cc"),
  "sky-850": rgb("#003049"),
  "yellow-100": rgb("#fbf8cc"),
  "yellow-300": rgb("#c2c1a5"),
  "lime-50": rgb("#f5f9e9"),
  "lime-75": rgb("#f6f7f0"),
  "lime-450": rgb("#a8c256"),
  "violet-100": rgb("#e7dcf9"),
  "violet-150": rgb("#cfbaf0"),
  "violet-700": rgb("#390099"),
  "pink-100": rgb("#f9d7e9"),
  "pink-125": rgb("#fad2e1"),
  "pink-400": rgb("#ec4899"), // marca base (secondary)
  "pink-500": rgb("#ff0054"),
  "pink-700": rgb("#9e0059"),
  "orange-50": rgb("#fff1e6"),
  "orange-100": rgb("#fde4cf"),
  "orange-125": rgb("#eddcd2"),
  "orange-200": rgb("#f3d9b1"),
  "orange-250": rgb("#f2cc8f"),
  "orange-350": rgb("#e4b363"),
  "orange-375": rgb("#fcbf49"),
  "orange-400": rgb("#c29979"),
  "orange-475": rgb("#f77f00"),
  "orange-500": rgb("#ff5400"),
  "orange-525": rgb("#ffbd00"),
  "red-50": rgb("#fde2e4"),
  "red-100": rgb("#ffcfd2"),
  "red-200": rgb("#e8aeb7"),
  "red-325": rgb("#ef6461"),
  "red-350": rgb("#f25f5c"),
  "red-375": rgb("#e07a5f"),
  "red-400": rgb("#c33149"),
  "red-425": rgb("#d62828"),
  "red-450": rgb("#ef233c"),
  "red-475": rgb("#d90429"),
  "red-500": rgb("#da1e37"),
  "red-525": rgb("#e01e37"),
  "red-550": rgb("#bd1f36"),
  "red-575": rgb("#c71f37"),
  "red-600": rgb("#a71e34"),
  "red-625": rgb("#b21e35"),
  "red-650": rgb("#a11d33"),
  "red-675": rgb("#a22522"),
  "red-700": rgb("#85182a"),
  "red-750": rgb("#641220"),
  "red-775": rgb("#6e1423"),
  "red-800": rgb("#51291e"),
  "red-850": rgb("#301014"),
  "amber-50": rgb("#f0efeb"),
  "amber-100": rgb("#f4f1de"),
  "amber-150": rgb("#e0dfd5"),
  "amber-200": rgb("#eae2b7"),
  "amber-300": rgb("#ffe066"),
  "amber-500": rgb("#ffc800"),
  "amber-550": rgb("#f59e0b"), // marca base (accent)
  "cyan-50": rgb("#edf2f4"),
  "cyan-150": rgb("#b6f7ff"),
  "cyan-250": rgb("#90dbf4"),
  "cyan-275": rgb("#8eecf5"),
  "cyan-500": rgb("#5c9ead"),
  "cyan-600": rgb("#247ba0"),
  "teal-100": rgb("#dbe7e4"),
  "teal-200": rgb("#98f5e1"),
  "teal-225": rgb("#c5dedd"),
  "teal-400": rgb("#70c1b3"),
  "green-25": rgb("#fbfefb"),
  "green-50": rgb("#edf4ed"),
  "green-150": rgb("#b9fbc0"),
  "green-250": rgb("#abd1b5"),
  "green-400": rgb("#79b791"),
  "emerald-400": rgb("#81b29a"),
  "slate-25": rgb("#f9fafb"), // marca base (light)
  "slate-50": rgb("#f4f4f6"),
  "slate-100": rgb("#e8e9eb"),
  "slate-125": rgb("#e6e6e9"),
  "slate-400": rgb("#9999a1"),
  "slate-600": rgb("#66666e"),
  "slate-800": rgb("#313638"),
  "slate-900": rgb("#111827"), // marca base (dark)
  "fuchsia-150": rgb("#f1c0e8"),
  "indigo-400": rgb("#4f46e5"), // marca base (primary)
)

#let token(key) = {
  if not (key in tokens) { panic("token de color desconocido: " + key + " — ver tokens.keys()") }
  tokens.at(key)
}
