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
//  (parcial: lo que falte sale del tema por defecto del preset, salvo los
//  roles extra de `derivados-lamina`, que se derivan si el tema cambió los
//  roles de los que dependen) o el resultado de `tema-desde-theme(theme.base)`.
//
//  No importa ningún preset: los presets lo importan a él.
// ─────────────────────────────────────────────────────────────

#import "../contrast.typ": readable-on

#let temas-lamina = (
  // Lámina 01: papel hueso, tinta casi negra, rojo suizo.
  suizo: (
    fondo: rgb("#f3f0e9"),
    tinta: rgb("#141414"),
    suave: rgb("#5c5850"),
    acento: rgb("#c8102e"),
    linea: rgb("#d9d3c7"),
  ),
  // Bauhaus: papel crudo, negro, y los tres primarios. `acento` es el rojo;
  // `amarillo` y `azul` son roles propios de este tema.
  bauhaus: (
    fondo: rgb("#ece3cf"),
    tinta: rgb("#141414"),
    suave: rgb("#5b564c"),
    acento: rgb("#d3261b"),
    amarillo: rgb("#f2b705"),
    azul: rgb("#1d4e9c"),
  ),
  // Mosaico (arcos y círculos): menta, naranja y azul marino rotan de papel.
  // `tinta` son las líneas; `suave`, las líneas sobre el fondo hondo; `hondo`
  // el azul marino, rol propio de este tema.
  mosaico: (
    fondo: rgb("#b3dcd4"),
    tinta: rgb("#000000"),
    suave: rgb("#a1a1a1"),
    acento: rgb("#ff832a"),
    hondo: rgb("#002b38"),
  ),
  // Teselas: papel blanco, tinta casi negra, y carmesí, azul marino y crema
  // que rotan de fondo y de figura en el bloque.
  teselas: (
    fondo: rgb("#ffffff"),
    tinta: rgb("#100f0d"),
    suave: rgb("#656263"),
    acento: rgb("#d8225a"),
    hondo: rgb("#19253c"),
    claro: rgb("#f8f1cd"),
  ),
  // Hojas: papel blanco, negro, y el amarillo y el azul de las hojas (`acento`
  // y `hondo`, como en teselas). Medidos sobre la captura: #f7c912 y #2a3ed1,
  // a un paso de los del HTML (#f9c90f, #2a3ed3), que son los que quedan.
  hojas: (
    fondo: rgb("#ffffff"),
    tinta: rgb("#000000"),
    suave: rgb("#111111"),
    acento: rgb("#f9c90f"),
    hondo: rgb("#2a3ed3"),
  ),
  esquela: (
    fondo: rgb("#f3eee3"),
    tinta: rgb("#141210"),
    suave: rgb("#4a443c"),
  ),
  folio: (
    fondo: rgb("#eee0bf"),
    tinta: rgb("#1f1610"),
    acento: rgb("#9e2219"),
  ),
  gozne: (
    fondo: rgb("#ece8df"),
    tinta: rgb("#1f262d"),
    suave: rgb("#525a61"), // ≈ 6:1 sobre el fondo
    acento: rgb("#a8361f"), // ≈ 5.6:1 sobre el fondo
    claro: rgb("#f7f1e6"),
  ),
  escalera: (
    fondo: rgb("#10302a"),
    tinta: rgb("#efe8da"),
    suave: rgb("#b9cfc3"),
    acento: rgb("#f3c28e"),
  ),
  linea-tiempo: (
    fondo: rgb("#f1e9dc"),
    tinta: rgb("#2a2420"),
    acento: rgb("#9a3a1c"),
    suave: rgb("#6b5e52"),
  ),
  // Magnalia Dei: cubierta (vino) e interior (papel). Además de los cuatro
  // roles base traen los de la orla: malla, franja, orn, fil y hondo.
  vino: (
    fondo: rgb("#5a1220"), malla: rgb("#661a28"), franja: rgb("#732232"), orn: rgb("#86303d"),
    fil: rgb("#a24c57"), hondo: rgb("#3e0a15"),
    tinta: rgb("#f0d8d2"), suave: rgb("#d4a9a2"), acento: rgb("#e2bdb5"),
  ),
  papel: (
    fondo: rgb("#f6efe4"), malla: rgb("#eee2d1"), franja: rgb("#e6d3bd"), orn: rgb("#8e3b3b"),
    fil: rgb("#8e3b3b"), hondo: rgb("#6b1d1d"),
    tinta: rgb("#2b1916"), suave: rgb("#6b4a44"), acento: rgb("#6b1d1d"),
  ),
  demostracion: (
    fondo: rgb("#0d1014"),
    claro: rgb("#f4f1ea"),
    tinta: rgb("#c3c9d1"),
    suave: rgb("#8b95a1"),
    acento: rgb("#f2b33d"),
  ),
)

// Roles extra que se derivan en vez de heredarse. Un tema que no trae un
// rol extra lo completa con el del tema por defecto del preset; pero si el
// tema cambia alguno de los roles de los que ese extra depende (`de`), el
// heredado ya no casa (el filete cálido de suizo sobre una paleta fría, el
// ornamento vino sobre un fondo verde) y se deriva de los roles ya resueltos
// con `f`. Con el tema por defecto, o con uno que solo retoca roles de los que
// el extra no depende, no se deriva nada: sale idéntico.
//
// Clave: el nombre del tema por defecto del preset (`defecto:`). Los extras
// que son colores de identidad y no salen de los cuatro base (los primarios
// de bauhaus, el `hondo` de mosaico y teselas) siguen heredándose.
#let _mezcla(a, b, p) = color.mix((a, 100% - p), (b, p))
#let derivados-lamina = (
  // los filetes de la retícula: la tinta, muy rebajada en el fondo
  suizo: (
    linea: (de: ("fondo", "tinta"), f: c => _mezcla(c.fondo, c.tinta, 12%)),
  ),
  // la orla de fleurones: la malla y la franja son el fondo apenas teñido de
  // tinta; ornamento, filete y marco, el acento rebajado en el fondo
  vino: (
    malla: (de: ("fondo", "tinta"), f: c => _mezcla(c.fondo, c.tinta, 6%)),
    franja: (de: ("fondo", "tinta"), f: c => _mezcla(c.fondo, c.tinta, 13%)),
    orn: (de: ("fondo", "acento"), f: c => _mezcla(c.fondo, c.acento, 55%)),
    fil: (de: ("fondo", "acento"), f: c => _mezcla(c.fondo, c.acento, 75%)),
    hondo: (de: ("fondo", "acento"), f: c => _mezcla(c.acento, black, 35%)),
  ),
  // la cifra y el perno van en `claro` sobre el acento: el que más contraste
  gozne: (
    claro: (de: ("fondo", "tinta", "acento"), f: c => readable-on(c.acento, c.fondo, c.tinta)),
  ),
  // la afirmación enorme: la tinta del tema, que ya contrasta con su fondo
  demostracion: (
    claro: (de: ("fondo", "tinta"), f: c => c.tinta),
  ),
)

// Resuelve `tema` a un diccionario de roles. `defecto` es el nombre (en
// `registro`) del tema que completa lo que `tema` no diga; los roles extra
// de `derivados` (por omisión, los de ese tema en `derivados-lamina`) se
// derivan cuando el tema cambió los roles de los que dependen.
#let resolver-tema(tema, defecto: none, registro: temas-lamina, derivados: auto) = {
  let buscar(nombre) = {
    if not nombre in registro {
      panic("tema de lámina desconocido: " + repr(nombre) + " — disponibles: " + registro.keys().join(", "))
    }
    registro.at(nombre)
  }
  let base = if defecto == none { (:) } else { buscar(defecto) }
  let dado = if type(tema) == str { buscar(tema) }
    else if type(tema) == dictionary { tema }
    else { panic("tema de lámina: se esperaba un nombre o un diccionario, no " + repr(type(tema))) }
  let resuelto = base + dado
  let derivados = if derivados == auto { derivados-lamina.at(str(defecto), default: (:)) } else { derivados }
  for (rol, d) in derivados {
    let cambia = d.de.any(r => r in dado and dado.at(r) != base.at(r, default: none))
    if not rol in dado and cambia { resuelto.insert(rol, (d.f)(resuelto)) }
  }
  resuelto
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
