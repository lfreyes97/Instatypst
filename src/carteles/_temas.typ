// ─────────────────────────────────────────────────────────────
//  carteles/_temas.typ — temas de lámina: la paleta por roles de los
//  presets de carteles
//
//  Un tema de lámina es un diccionario con los mismos roles para todos
//  los presets, en vez de que cada uno invente sus nombres de color
//  (papel / pergamino / fondo, tinta / luto / claro, gris / sepia /
//  suave / apagado, acento / rubrica):
//
//    fondo    lo que cubre la lámina (papel, pizarra, pergamino)
//    tinta    el texto principal
//    suave    el texto secundario: rótulos, fechas, glosas
//    acento   el color que llama la atención (remate, flecha, rúbrica)
//
//  Un preset puede sumar roles propios (suizo trae `linea`, para los
//  filetes de la retícula). Los parámetros de color de cada preset
//  (`papel:`, `tinta:`, …) siguen existiendo y, si se pasan, mandan
//  sobre el tema: el tema fija el conjunto, el parámetro retoca un color.
//
//  Uso en un preset:
//    #let c = resolver-tema(tema, defecto: "suizo")
//
//  Un tema es un nombre del registro `temas-lamina`, un diccionario
//  (parcial: lo que falte sale del tema por defecto del preset) o el
//  resultado de `tema-desde-theme(theme.base)`.
//
//  No importa ningún preset: los presets lo importan a él.
// ─────────────────────────────────────────────────────────────

#let temas-lamina = (
  // Lámina 01: papel hueso, tinta casi negra, rojo suizo.
  suizo: (
    fondo: rgb("#f3f0e9"),
    tinta: rgb("#141414"),
    suave: rgb("#5c5850"),
    acento: rgb("#c8102e"),
    linea: rgb("#d9d3c7"),
  ),
)

// Resuelve `tema` a un diccionario de roles. `defecto` es el nombre (en
// `registro`) del tema que completa lo que `tema` no diga.
#let resolver-tema(tema, defecto: none, registro: temas-lamina) = {
  let buscar(nombre) = {
    if not nombre in registro {
      panic("tema de lámina desconocido: " + repr(nombre) + " — disponibles: " + registro.keys().join(", "))
    }
    registro.at(nombre)
  }
  let base = if defecto == none { (:) } else { buscar(defecto) }
  if type(tema) == str { base + buscar(tema) }
  else if type(tema) == dictionary { base + tema }
  else { panic("tema de lámina: se esperaba un nombre o un diccionario, no " + repr(type(tema))) }
}

// Tema de lámina a partir de un `theme` (theme.typ), para tematizar un
// cartel igual que las citas y las plantillas de social:
//   light -> fondo · dark -> tinta · primary -> acento ·
//   suave = la tinta, aclarada hacia el fondo.
#let tema-desde-theme(t) = (
  fondo: t.colors.light,
  tinta: t.colors.dark,
  suave: color.mix((t.colors.dark, 65%), (t.colors.light, 35%), space: oklab),
  acento: t.colors.primary,
)
