// ─────────────────────────────────────────────────────────────
//  TOKENS — registro único de colores individuales y nombrados
//
//  Módulo hoja (sin imports): tanto theme.typ (colores de marca base)
//  como palettes.typ (biblioteca de paletas decorativas) importan de
//  aquí, así que cada color existe en un solo lugar y se puede
//  reutilizar libremente entre ambos sin duplicar hex.
//
//  #import "tokens.typ": tokens, token
//  #token("índigo")
//
//  Convención de nombres -- dos tipos de entradas:
//
//  - Neutros (stone-*, slate-*, y unos pocos sueltos de otras
//    familias): el nombre-NNN original se mantiene porque el número sí
//    es una escala real de claridad (NNN más alto = más oscuro) y el
//    croma es tan bajo (< 0.02 en OKLCH, gris a ojo) que no hay un
//    matiz real que nombrar.
//  - Todo lo demás: nombre semántico de una palabra, no "familia-NNN".
//    El sufijo numérico original no representaba nada estandarizado, y
//    varios "family-NNN" distintos resultaban ser, medidos en OKLCH, el
//    mismo color real -- blue-700 y blue-800 diferían en hue menos de
//    1° y en croma menos de 0.01. Cada nombre de acá es un color
//    realmente distinto (agrupados por cercanía en hue+croma); el color
//    es el promedio de L/C/H de los tokens viejos que colapsaron en él,
//    no uno elegido arbitrariamente del grupo. Resultado: 81 colores
//    reales, no 96 nombres.
//
//  Mapeo viejo -> nuevo (para actualizar código externo que quedó sin
//  migrar -- fuera de este repo, por ejemplo):
//    red-200->malva  red-50->rosa-ceniza  red-100/red-850->rosa-antiguo
//    pink-500->rosa-mexicano  red-400->carmesí  red-750/red-775->wine
//    red-700->teja  red-650/600/625/550/575->escarlata
//    red-500/525/450/475->coral  red-325/350->tomate  red-425->amapola
//    red-675->arcilla  red-375->salmón  red-800->caoba
//    orange-500->mandarina  orange-125->arena  orange-475->calabaza
//    orange-400->tostado  orange-50->crema  orange-100->durazno
//    amber-550->ámbar  orange-350->miel  orange-200->avellana
//    orange-250->caramelo  orange-375->azafrán  orange-525/amber-500->dorado
//    amber-300->mostaza  amber-200->champán  amber-100->marfil
//    yellow-100->vainilla  yellow-300->heno  lime-50->pergamino
//    lime-450->lima  green-150->menta  green-250->salvia
//    green-400->esmeralda  emerald-400->jade  teal-200/teal-400->turquesa
//    teal-225->niebla  cyan-275->cristal  cyan-150->aguamarina
//    cyan-500->lago  cyan-250->celeste  cyan-600->petróleo
//    sky-850/sky-250->acero  sky-225->bruma  sky-400->denim
//    sky-600->cielo  sky-200->nomeolvides  sky-425/slate-900->grafito
//    blue-900->navy  indigo-400->índigo  blue-700/blue-800->vino-frío
//    blue-650->aciano  violet-700->violeta  violet-150->orquídea
//    violet-100->glicina  fuchsia-150->malvavisco  pink-100->rosa-polvo
//    pink-125->rosa-viejo  pink-400->frambuesa  pink-700->granate
//  ─────────────────────────────────────────────────────────────

#let tokens = (
  // -- neutros: el número es una escala real de claridad --
  "stone-25": rgb("#ffffff"),
  "stone-700": rgb("#50514f"),
  "stone-850": rgb("#202020"),
  "stone-975": rgb("#000000"),
  "slate-25": rgb("#f9fafb"),
  "slate-50": rgb("#f4f4f6"),
  "slate-100": rgb("#e8e9eb"),
  "slate-125": rgb("#e6e6e9"),
  "slate-400": rgb("#9999a1"),
  "slate-600": rgb("#66666e"),
  "slate-800": rgb("#313638"),
  "green-25": rgb("#fbfefb"),
  "green-50": rgb("#edf4ed"),
  "amber-50": rgb("#f0efeb"),
  "cyan-50": rgb("#edf2f4"),
  "lime-75": rgb("#f6f7f0"),
  "teal-100": rgb("#dbe7e4"),
  "amber-150": rgb("#e0dfd5"),
  "sky-100": rgb("#d6e2e9"),

  // -- rojos --
  "malva": rgb("#e8aeb7"),
  "rosa-ceniza": rgb("#fde2e4"),
  "rosa-antiguo": rgb("#91686b"),
  "rosa-mexicano": rgb("#ff0054"),
  "carmesí": rgb("#c33149"),
  "wine": rgb("#691322"),
  "teja": rgb("#85182a"),
  "escarlata": rgb("#b31e35"),
  "coral": rgb("#e01b35"),
  "tomate": rgb("#f1625f"),
  "amapola": rgb("#d62828"),
  "arcilla": rgb("#a22522"),
  "salmón": rgb("#e07a5f"),
  "caoba": rgb("#51291e"),

  // -- naranjas / ámbar --
  "mandarina": rgb("#ff5400"),
  "arena": rgb("#eddcd2"),
  "calabaza": rgb("#f77f00"),
  "tostado": rgb("#c29979"),
  "crema": rgb("#fff1e6"),
  "durazno": rgb("#fde4cf"),
  "ámbar": rgb("#f59e0b"),
  "miel": rgb("#e4b363"),
  "avellana": rgb("#f3d9b1"),
  "caramelo": rgb("#f2cc8f"),
  "azafrán": rgb("#fcbf49"),
  "dorado": rgb("#ffc200"),
  "mostaza": rgb("#ffe066"),
  "champán": rgb("#eae2b7"),
  "marfil": rgb("#f4f1de"),

  // -- amarillos / verdes --
  "vainilla": rgb("#fbf8cc"),
  "heno": rgb("#c2c1a5"),
  "pergamino": rgb("#f5f9e9"),
  "lima": rgb("#a8c256"),
  "menta": rgb("#b9fbc0"),
  "salvia": rgb("#abd1b5"),
  "esmeralda": rgb("#79b791"),
  "jade": rgb("#81b29a"),

  // -- teal / cyan / sky --
  "turquesa": rgb("#84dbca"),
  "niebla": rgb("#c5dedd"),
  "cristal": rgb("#8eecf5"),
  "aguamarina": rgb("#b6f7ff"),
  "lago": rgb("#5c9ead"),
  "celeste": rgb("#90dbf4"),
  "petróleo": rgb("#247ba0"),
  "acero": rgb("#4c7590"),
  "bruma": rgb("#bcd4e6"),
  "denim": rgb("#6b9ac4"),
  "cielo": rgb("#0066cc"),
  "nomeolvides": rgb("#a3c4f3"),
  "grafito": rgb("#4a5467"),

  // -- azules / índigo / violeta --
  "navy": rgb("#0a1128"),
  "índigo": rgb("#4f46e5"),
  "vino-frío": rgb("#34364e"),
  "aciano": rgb("#3c3d6c"),
  "violeta": rgb("#390099"),
  "orquídea": rgb("#cfbaf0"),
  "glicina": rgb("#e7dcf9"),

  // -- rosas / fucsia --
  "malvavisco": rgb("#f1c0e8"),
  "rosa-polvo": rgb("#f9d7e9"),
  "rosa-viejo": rgb("#fad2e1"),
  "frambuesa": rgb("#ec4899"),
  "granate": rgb("#9e0059"),
)

#let token(key) = {
  if not (key in tokens) { panic("token de color desconocido: " + key + " — ver tokens.keys()") }
  tokens.at(key)
}
