> Origen: derivado por un agente en `suizo-agentes/sistema-opus/` (nov 2026). Las rutas `lib.typ`, `pruebas/` y `ejemplos/` se refieren a ese directorio; `core/` y `src/` al proyecto.

# Comentarios: segunda fase

Leído, además de los carteles: **superbg completo** (los 18 módulos y `assets/cafe/`), `tokens.typ`, `palettes.typ`, `theme.typ`, `contrast.typ`, `font-tokens.typ` y `font-pairings.typ`. Las copias de solo lectura están en `src/`.

> **Revisión (tercera pasada).** La primera versión de este documento se escribió habiendo leído solo 9 de los 18 módulos de superbg. Las afirmaciones sobre superbg llevan ahora una marca: **[confirmado]** si la lectura completa o una prueba compilada la sostiene, **[corregido]** si cambia. Las pruebas están en `pruebas/superbg/` y `pruebas/fondo-*.png`. Lo nuevo de los siete módulos que no había leído está en la sección **(e)**, y la tabla de verificación al final.

**Resumen:** concedo la objeción 1 en parte y he cambiado la librería (`backdrop`). Concedo la 2 en lo que importa: mis paletas duplican hex y deben apoyarse en tokens.typ. Defiendo mis roles, que no duplican los de theme.typ porque responden a otra pregunta. En la 3 integro mi `typeface` en font-pairings sin perder nada. A los ordinales respondo con una tabla que muestra que cinco no bastan, y propongo tres capas.

---

## (a) Las tres objeciones

### 1. `paper` y un fondo dibujado. **Concedo en parte; cambio la librería.**

Mi argumento («aquí no hay capas») era cierto para los 20 carteles: todos tienen un fondo plano. Pero era un argumento de cobertura, no de diseño. En un sistema que incluye superbg, el fondo puede ser un dibujo (aura, malla, papel viejo, trama), y `paper`, que es un color, no lo representa. Hace falta otro concepto.

Lo que **no** concedo es que ese concepto sustituya a `paper` ni que deba llamarse `background`. Son dos cosas distintas y el sistema necesita las dos:

| | `paper` | `backdrop` (nuevo) |
|---|---|---|
| Qué es | Un color | Una capa de contenido |
| Obligatorio | Sí, en toda paleta | No (none por defecto) |
| Para qué lo usa el sistema | Es el **color de vaciado**: cifras en `callout`, la Í en papel de RO2, los nodos huecos de `timeline`, el texto de las celdas de `month-calendar`, el `index` sobre el amarillo en RO4. También es la referencia para el contraste. | Nada estructural: decora |
| Qué pasa si falta | No hay cartel | Nada |

Por eso **`paper` sigue siendo obligatorio aunque haya fondo**: es el tono dominante del fondo. **[confirmado, y más grave de lo que creía; ver e.2]** Si el fondo es un degradado de negro a marrón, alguien tiene que decidir de qué color va la cifra «en papel» del bloque de llamada (`pruebas/fondo.png` lo muestra). Un fondo elaborado sin un color dominante declarado deja sin respuesta a la mitad de los componentes. superbg tiene ya esa noción a medias: su capa base casi siempre es `(tipo: "plano", color: …)`, y ese color es precisamente el `paper`.

**`background` se descarta** porque nombra a la vez las dos cosas que hay que separar: en Typst, `page(background:)` es una capa y `page(fill:)` un color, y en CSS `background` es ambas. `backdrop` es una capa que está detrás, sin ambigüedad (y no choca con nada de Typst; lo he comprobado).

**Cambio hecho** (revisado en la tercera pasada, ver e.1 y e.2):

```typ
poster(backdrop: none | content | (layer) => content,   // debajo del contenido
       overlay:  none | content | (layer) => content)   // encima del contenido
// layer = layer-context(canvas, palette):
//   (canvas, palette, extent: (w, h) en números con sangrado, theme: (colors: light, dark, primary, …))
```

```typ
#show: poster.with(palette: "cream-red",
  backdrop: l => superbg((tipo: "topo", fondo: none), size: l.extent, theme: l.theme),
  overlay:  l => superbg((tipo: "cafe", tazas: 1), size: l.extent))
```

Las dos capas cubren el lienzo **con su sangrado**. `extent` da a superbg el tamaño real; esto corrige el problema medido en e.1. `theme` hace que los colores por defecto de superbg salgan de la paleta del cartel y no de su marca implícita. `fondo: none` deja ver el `paper`.

Pruebas repetidas tras el cambio: `nombres-libres.sh` (66 nombres, 0 choques; se añade `layer-context`), `validacion.sh` (24 casos: nuevos `backdrop` y `overlay` mal tipados; los 24 fallan con mensaje útil) y los 20 ejemplos recompilados. `pruebas/fondo-{feed-portrait,wallpaper-uhd,print-a3}.png` muestran superbg real como fondo y como pátina. NOMBRES.md está actualizado.

Una tercera categoría que conviene no mezclar con `backdrop`: **la retícula visible**, mi `raster-guides`. superbg tiene un preset `rejilla-sutil` (rejilla de paso 56) y patrones `grid`/`dots` de paso 48. En un cartel suizo una rejilla de fondo que no coincide con la retícula es una contradicción: dibuja una estructura falsa. La retícula visible es estructura y se dibuja desde `raster`; un patrón de superbg es decoración.

### 2. Paletas, tokens y theme. **Concedo la duplicación; defiendo los roles.**

**Qué duplico (y no debería).** Mis 12 paletas escriben hex a mano. Medido en OKLab contra los 81 tokens:

| Color de los carteles | Token más cercano | ΔE (OKLab) | Veredicto |
|---|---|---|---|
| papel crema F2EFE8 | `amber-50` | 0,005 | es el mismo |
| rojo D52B1E | `amapola` | 0,009 | es el mismo |
| amarillo FFC20E | `dorado` | 0,002 | es el mismo |
| naranja FF4A1C | `mandarina` | 0,020 | es el mismo |
| papel F7F5F0 | `lime-75` | 0,005 | es el mismo |
| amarillo F4C20D | `dorado` | 0,017 | es el mismo |
| rojo suizo E30613 | `coral` | 0,024 | cercano |
| amarillo señal FFD400 | `dorado` | 0,044 | cercano |
| tinta 111111 | — (entre `stone-975` #000 y `stone-850` #202020) | 0,05 | **falta un neutro** |
| azules 1B3FA0, 1F3FD6 | `aciano`, `índigo` | 0,09 / 0,065 | **faltan** |
| verde 00875A | `acero` (!) | 0,125 | **falta** |
| cian, magenta, amarillo de proceso | `denim`, `frambuesa`, `mostaza` | 0,05–0,07 | **faltan** |
| noche 0E0E0E, navy 13213F | `navy` #0a1128 | 0,05–0,06 | **faltan** |

Seis de mis colores ya existen en el registro con otro nombre. Eso es duplicación y está mal: **concedo**. Mis paletas deben referirse a claves de tokens, no a hex.

**Qué no duplico.** Los roles de theme.typ (`primary`, `secondary`, `accent`, `dark`, `light`, `white`) y los míos (`paper`, `ink`, `accent`, `quiet`, `guide`, `tint`, `swatches`) responden a preguntas distintas:

- theme responde **qué colores tiene la marca**, ordenados por saturación y luminosidad (`auto-roles` lo hace literalmente así). Es un inventario.
- Los míos responden **qué hace cada color en esta página**: el fondo, la tinta, lo que destaca, lo que habla bajo, la estructura. Es una asignación.

La misma marca da carteles distintos según la asignación. S1 (fondo rojo, tinta blanca) y H1 (fondo crema, acento rojo) usan el mismo inventario de dos colores con asignaciones opuestas. `auto-roles` nunca produciría S1, porque siempre pone el color claro como `light` y el oscuro como `dark`. Fundir los dos sistemas perdería esa distinción.

**Un choque real de nombres:** `accent`. En theme, `accent` es el tercer color más saturado de la paleta: un color secundario. En mi sistema es *el único* color que destaca, y en los carteles suizos ese papel lo juega lo que theme llama `primary`. Si se integran sin decidirlo, `accent` significará dos cosas. Propuesta: el puente asigna por defecto `accent ← primary` y lo documenta. No renombraría ninguno de los dos, porque los dos son correctos en su sistema.

**Qué se queda, qué se funde:**

- **Se queda tokens.typ** como única fuente de hex: es la mejor pieza de las tres (ver § b). Hay que añadirle los 8 colores que faltan, comprobando antes en OKLab que no colapsan con ninguno existente.
- **Se queda theme.typ** como inventario de marca.
- **Se queda palettes.typ** como biblioteca de inventarios (5–10 colores).
- **Mis roles se quedan** como una capa *derivada*: `swiss-roles(theme, inverse: false, accent: "primary")` → `(paper: light, ink: dark, accent: primary, quiet: mezcla, guide: mezcla, tint: mezcla, swatches: (secondary, accent))`. `quiet`, `guide` y `tint` son mezclas de `ink` sobre `paper` (ya los derivo así) y por eso no van al registro.
- **Mis paletas con nombre se funden**: pasan a ser asignaciones sobre claves, `(paper: "amber-50", ink: "stone-850", accent: "amapola")`. Su nombre se deriva de las claves: `amber-50/amapola` en vez de `cream-red`. Así la objeción a los nombres de aspecto desaparece sola: el nombre no se inventa, se lee.

En los nombres defiendo una cosa: una paleta suiza es fondo más un acento, y nombrarla por esos dos colores *es* nombrarla por su contenido. Los nombres de ambiente de palettes.typ («neon», «retro», «oceano») funcionan para inventarios de 5–10 colores, pero «oceano» no diría nada de un cartel crema con un acento rojo.

### 3. Tipografía. **Integro sin perder lo verificado; los ordinales no bastan.**

**Integración.** Mis dos roles (`main`, `annotation`) son un caso particular de font-pairings: el caso en que `display` y `body` son la misma grotesca. Los 20 carteles lo hacen así, sin excepción: Jost, Hanken o Inter componen a la vez el titular de 150 y la prosa de 20. Por tanto:

- Mis roles de texto se asignan a los roles de font-pairings, así: `index`, `kicker` y `colophon` → `mono`; `note`, `prose` y `lede` → `body`; `subhead`, `headline`, `display` y `numeral` → `display`. Con una pareja suiza (display = body) el resultado es idéntico al actual. Con una pareja editorial (Fraunces + Bricolage) el sistema la usaría bien sin cambiar nada.
- `typeface` aceptaría una **clave de pareja** o claves de font-tokens, y resolvería la familia con `family()`. Así hereda lo verificado: `"DM Sans 9pt"` y no `"DM Sans"`, `"Bricolage Grotesque 96pt"`, los ejes. Hoy mi `resolve-typeface` acepta cualquier nombre de fuente. Eso queda como escape, no como camino principal.
- Hay que añadir a font-pairings las parejas que salen de los datos: `suizo-heros` (heros/heros/dm-mono), `suizo-inter`, `suizo-hanken`, `suizo-jost`, `suizo-public-sans`.
- **Faltan fuentes en font-tokens** que los carteles usan: TeX Gyre Heros (el clon de Helvetica, la fuente *más* suiza de todas), Liberation Sans, FreeSans e «Inter 28pt». Son fuentes del sistema, no del directorio Fonts/, y por eso no están. Hay que añadirlas verificadas y con una nota de procedencia, porque un registro que se llama «verificado» no debería tener que salir de sí mismo para el estilo más canónico.
- **No uso `hand` ni `ornament`**, ni lo fingiré: no salen de los datos. El puente simplemente no los asigna a ningún rol de texto suizo.

**Tamaños: tabla de pasos, roles y ordinales.**

| Paso | Tamaño a 1080 | Rol mío | Observado en | Ordinal propuesto | ¿Lo sostienen los datos? |
|---|---|---|---|---|---|
| −1 | 12,8 | `index` | índices de RO1–RO5 y RH2 (12–13) | tiny | sí |
| 0 | 16 | `kicker`, `colophon` | RH1–RH4 (14–16) | tiny / small | **no distingue**: 13 frente a 16 es un matiz de mono |
| 1 | 20 | `note` | S1–S5 y pies de H (20–22) | small | sí, es el tamaño **más frecuente** de todo el corpus |
| 2 | 25 | `prose` | H1, H5, RH5 (24–26) | base | **dudoso**: los carteles casi no tienen prosa; el «base» de un cartel es el 20 |
| 3 | 31 | `lede` | H1, RH1, RO1 (26–34) | — | **sin ordinal** |
| 4 | 39 | — | años de H4, días de RH1 (40–44) | — | sin ordinal |
| 5 | 49 | `subhead` | H2 (54), lede de H1 (46) | large | sí, pero se usa poco |
| 6 | 61 | — | titulares pequeños de S3 y RH4 (64–66) | — | sin ordinal |
| 7–8 | 76–95 | `headline` | RO1, RO4, H4, S1, S5 (90–100) | huge | **choca**: «huge» se agota aquí |
| 9 | 119 | — | RH3, RH5, H3 (112–124) | — | sin ordinal |
| 10 | 149 | `display` | H1, H2, RH1, RH2, RO5, S4 (150–160) | — | **sin ordinal**: la distinción más importante del corpus |
| 11 | 186 | `numeral` | H1 (190), RO5 (178) | — | sin ordinal |
| 12–13 | 233–291 | — | letras de RO2 (275) | — | sin ordinal |
| fuera de escala | ~110–126 % del alto | `hero-glyph` | H5, S1 | — | no es un paso: se mide contra el lienzo |

**Dónde no se sostiene.** Cinco ordinales reparten nombres al revés de como reparten los datos:

- Dedican dos nombres (tiny, small) a una diferencia de 13 a 20 que casi no se ve.
- Dejan un solo nombre (huge) para el tramo de 95 a 291. Ahí los carteles hacen sus tres distinciones más importantes: titular con figura (95), titular que es la figura (150) y cifra protagonista (186–275).
- «Base» supone un texto de lectura que el cartel apenas tiene.

Si se fuerza, `huge = 95` deja sin nombre al titular dominante, y `huge = 150` deja sin nombre al titular normal. Los datos piden al menos siete grupos: anotación (13–16), servicio (20), lectura (25–31), énfasis (39–61), titular (76–120), cartel tipográfico (149–186) y monumental (233+).

**Qué expondría: tres capas, con una pública.**

1. **Roles** (`kicker`, `headline`, `prose`…): la API pública. Dicen *para qué*, que es lo que el usuario sabe cuando escribe.
2. **Pasos numéricos** (`step: 6.6`): la capa de ajuste. Admiten fracciones, son ordenables y no se agotan. Los uso para reproducir y para corregir un rol (`headline(step: 9)`).
3. **Ordinales**: solo si el usuario los quiere de verdad, y como **alias de pasos con nombres que no prometan un orden cerrado**. Los ordinales tienen un problema estructural: cuando hace falta uno nuevo entre `large` y `huge` no hay nombre (los equipos de diseño acaban con `xl`, `2xl`, `3xl`, que son números disfrazados). Si se adoptan, que sean siete y que se apoyen en la tabla de arriba, no cinco.

---

## (b) Lectura crítica

### superbg

**Bien resuelto:**
- **Los tres niveles con una sola puerta** (preset → constructor → motor de capas) son una buena arquitectura. Coincide con mi separación entre `palettes` con nombre, `palette(…)` y dict parcial.
- **Independencia por duck-typing** del theme: cualquier dict con `.colors`. Es correcto para una biblioteca reutilizable.
- **El ruido como tesela SVG repetida con `tiling`**, con el tamaño del PDF medido (de 26 MB a 1,5 MB). Es el tipo de decisión respaldada por medida que hay que conservar.
- **El arreglo del signo menos U+2212** en los SVG y el de `.rgb()` antes de `.components()`: bugs reales, bien documentados.
- `texto-sobre` (blanco o negro según contraste) es exactamente lo que necesito para validar `ink` sobre `paper`.

**Lo que choca con mi sistema:**
1. **Medidas absolutas. [corregido: superbg es mixto, no absoluto]** Con la lectura completa:
   - **Relativas al lienzo:** las capas de color (`aura` con r = 38 % del lado menor, `malla`, `gradiente`, la posición y la base de `olas`), las manchas de café (9–15 % del lado menor) y `mancha-cafe` (posición y ancho en fracciones).
   - **Absolutas:** las de trazo y trama (`patron`: `paso` 48, `radio` 3, `grosor` 1,5; `halftone`: `paso` 36, `r-max` 11; `topo`: `separacion` 46, `wobble` 18; `memphis`: tamaño 14–40, `grosor` 5 y **`densidad` 26 figuras con independencia del área**; la `amplitud` 90 de `olas`; `blob`; `frame` con margen de 80 pt; `vidrio` y el panel del preset `vidrio-aura`), además de la frecuencia del grano de `papel`.

   Comprobado en `pruebas/superbg/escala.png`: en 3840×2160 las figuras memphis y la trama de puntos quedan diminutas y dispersas. La conclusión se mantiene para las capas que más se parecen a una retícula; las de color ya escalan bien.
2. **Ignora la retícula. [confirmado]** Las tramas parten de (0, 0) con pasos que no son el módulo (48, 56, 44 frente a 60/80 de la retícula). Un fondo de puntos de paso 48 bajo una retícula de 80 produce interferencia visual: es lo contrario del estilo suizo. `memphis` reparte además las figuras al azar por todo el lienzo, también bajo el texto.
3. **`sizes.instagram = (1080, 1080)`. [confirmado, con el efecto medido]** Los 20 carteles miden 1080×1350, que es el formato vertical de Instagram (4:5), y «instagram» y «cuadrado» son el mismo tamaño con dos nombres. El efecto real (`pruebas/superbg/tamano.png`): superbg dibuja en un viewBox de 1080×1080 y lo coloca con `width: 100%, height: 100%`, cuyo ajuste por defecto es *cover*. En una página de 1080×1350 todo se escala ×1,25 y se recorta por los lados: una rejilla de paso 80 sale de **100** y deja de coincidir con una retícula de 80. Nada falla; simplemente queda mal.
4. **Claves sin validar. [confirmado por prueba]** `_capa` lee con `c.at("opacidad", default: …)`. `pruebas/superbg/claves.typ` pasa `opcidad: 90%` y `step: 10`: compila sin aviso y dibuja la trama por defecto (18 %, paso 48). Mi librería rechaza las claves desconocidas con un mensaje.
5. **Colores por defecto escritos a mano. [confirmado y ampliado]** #4f46e5 (= `índigo`), #db2777 (no está en tokens), #f59e0b (= `ámbar`), #8b5cf6 (en `olas`), #1c1917, #f5f5f4, #fafaf9 (fondo por defecto de `topo` y `memphis`), #efe4c8 y #8a6a3a (`papel`), #8a5a2b (café). Es una segunda marca implícita que no pasa por el registro. `layer-context(...).theme` la neutraliza desde mi lado, pasando la paleta del cartel como tema.

**Qué cambiaría:**
- Que superbg acepte un **lienzo** (o al menos una unidad) además de `(w, h)`, y exprese `paso`, `radio`, `grosor` y `margen` en unidades de referencia, como hace mi sistema.
- Que las capas de patrón acepten **origen y paso desde una retícula**: `bg-patron(paso: raster.column-module, origen: margen)`. Así una trama de fondo cae sobre la retícula.
- Que `_capa` valide las claves contra la lista de parámetros de cada tipo.

**Qué NO cambiaría:** la independencia de superbg (que no importe Instatypst ni mi sistema), los presets como arrays de capas, el motor de composición ni el español de su API (es coherente dentro de sí misma; ver d).

**Solapamiento con mi sistema [confirmado]:** `bg-halftone` y mi `fields` + `mark-dot` (S4) son el mismo algoritmo, el radio que crece con una función. No los fundiría: el de superbg es un fondo a sangre y el mío una figura sobre la retícula, con márgenes. Sí compartiría la función de tamaño (lineal, diagonal, radial, potencia).

### Tokens de color (tokens.typ, palettes.typ, theme.typ)

**Muy bien resuelto, y no lo cambiaría:**
- **Consolidar por medida en OKLCH** (96 nombres → 81 colores reales, porque blue-700 y blue-800 eran el mismo color). Es exactamente el método de mi fase 1: deducir de los datos, no de la nomenclatura heredada.
- **Los neutros conservan el número porque es una escala real** de claridad, y los demás llevan nombre porque el número no significaba nada. Es la regla correcta y está bien justificada.
- **El módulo hoja sin imports**, compartido por theme y palettes.
- **El contraste WCAG en un solo módulo** (`contrast.typ`) tras encontrar el bug duplicado.
- **Los temas inmutables** con validación de claves requeridas.

**Lo que cambiaría:**
1. **El rol `white` en theme.** Está en `required-colors` y vale siempre `white`: es un rol con el nombre de su valor, contra la regla semántica del propio proyecto. Si es «el color sobre el que se garantiza legibilidad», debería llamarse por esa función. Si es siempre blanco, no es un rol.
2. **`auto-roles` decide por luminancia y saturación.** Funciona para inventarios, pero no puede producir un fondo de color ni un tema invertido (S1, S5, RO1, RO4). Debería admitir `inverse`.
3. **Mezcla de idiomas y acentos en las claves.** «wine» y «navy» están en inglés y el resto en español. «carmesí», «ámbar», «petróleo» y «salmón» llevan tilde (ver d: hay un riesgo técnico real, no solo de estilo).
4. **Huecos en el registro para el estilo suizo** (tabla del § a.2): falta un negro de tinta (#111), faltan los azules y el verde saturados, y faltan las tintas de proceso CMY. El registro está sesgado hacia pasteles y tonos decorativos (marfil, glicina, malvavisco) y le faltan colores de señal.

### Tipografía (font-tokens.typ, font-pairings.typ)

**Muy bien resuelto, y no lo cambiaría:**
- **Familias reales verificadas compilando**, con notas sobre las trampas («DM Sans» a secas es estática; la variable es «DM Sans 9pt»). Esto vale más que cualquier vocabulario, y mi sistema debe *consumirlo*, no reimplementarlo.
- **Los ejes con rango comprobado**, `scripts` declarado solo donde se verificó y la advertencia de que su ausencia no implica falta de cobertura. Es una epistemología impecable.
- **Las parejas como mapa de rol a clave**, análogo a las paletas.

**Lo que cambiaría:**
1. **`category` mezcla dos ejes.** `mono`, `hand` y `ornament` son **géneros** (qué es la fuente). `display` y `body` son **usos** (para qué se usa). Una fuente tiene un género y varios usos posibles. Los carteles lo demuestran: Jost está como `display` y Hanken Grotesk como `body`, y en los carteles las dos hacen *ambas cosas*. Propuesta: `genre: "grotesque" | "serif" | "slab" | "mono" | "hand" | "ornament"` y `uses: ("display", "body")`. `by-category("display")` seguiría funcionando como filtro por uso.
2. **Faltan las fuentes del sistema** que usan los carteles (Heros, Liberation, FreeSans).
3. **theme.base.fonts usa listas de familias sin pasar por font-tokens** (`("Poppins", "Urbanist", "Outfit")`), así que no hereda la verificación. Es la misma desconexión que superbg con los colores.

---

## (c) Propuesta de integración

**Capas de un cartel**, de abajo arriba, con un nombre por capa:

```
canvas    tamaño, destino, sangrado         (mi canvas; superbg.sizes se sustituye por esto)
paper     color obligatorio                 (rol derivado de theme vía swiss-roles)
backdrop  fondo dibujado opcional           (superbg, recibe el lienzo)
raster    estructura (+ raster-guides)      (mi retícula)
content   roles y componentes               (mi API)
```

**Color:**

```typ
// tokens.typ   única fuente de hex (+ 8 colores nuevos verificados en OKLCH)
// theme.typ    inventario de marca (sin cambios, salvo el rol `white`)
// puente nuevo en mi sistema:
#let swiss-roles(theme, inverse: false, accent: "primary") = {
  let c = theme.colors
  palette(
    paper: if inverse { c.dark } else { c.light },
    ink: if inverse { c.light } else { c.dark },
    accent: c.at(accent),
    swatches: (c.secondary, c.accent),
  ) // quiet, guide y tint se derivan como ahora
}
// y las paletas con nombre de mi sistema pasan a claves:
//   "amber-50/amapola": (paper: "amber-50", ink: "stone-850", accent: "amapola")
```

**Tipografía:**

```typ
// font-tokens.typ  + tex-gyre-heros, liberation-sans, free-sans (verificadas); category → genre + uses
// font-pairings.typ + suizo-heros, suizo-inter, suizo-hanken, suizo-jost, suizo-public-sans
// mi typeface: acepta una clave de pareja; asigna mis roles a display/body/mono y resuelve con family()
#show: poster.with(typeface: "suizo-heros")
```

**Tamaños:** roles públicos, pasos para ajustar y, si se quieren, ordinales como alias de siete pasos.

**Formatos:** un solo registro, el mío (`formats`, con `medium` y `bleed`). superbg recibe el lienzo en vez de `(w, h)`, y su `sizes` queda como compatibilidad.

**Orden de trabajo recomendado:** primero los tokens que faltan (no rompe nada), luego `swiss-roles` y las paletas por clave, luego las parejas suizas, y por último las medidas relativas de superbg (lo único que cambia comportamiento).

---

## (d) Cosas que creo que no se están considerando

1. **Claves con tilde y normalización Unicode.** «carmesí» puede escribirse como `í` precompuesta (NFC) o como `i` + acento combinado (NFD). macOS y algunos editores producen NFD al copiar desde nombres de archivo. Un diccionario de Typst compara bytes, así que `token("carmesí")` puede fallar con dos cadenas que se ven idénticas. Sugiero claves ASCII (`carmesi`, `ambar`) con alias acentuados, o normalizar antes de buscar.

2. **«instagram» como nombre de formato.** Instagram usa 1:1, 4:5 y 1.91:1, y superbg llama `instagram` al 1:1 mientras todos los carteles del proyecto son 4:5. Nombrar por plataforma garantiza que el nombre mienta cuando la plataforma cambie. Mi `feed-portrait`/`feed-square` evita eso, y la discrepancia de superbg ya produce fondos del tamaño equivocado para estos carteles.

3. **El contraste está implementado dos veces, y las dos ya divergen. [corregido: dije «tres»]** theme y palettes importan de `contrast.typ`, como dice su cabecera; la tercera copia ya se eliminó. Quedan `contrast.typ` y `superbg/color.typ` (duplicado a propósito, por independencia), y ya no son iguales:
   - el umbral de linealización es 0,04045 en `contrast.typ` y 0,03928 en superbg (el valor antiguo de WCAG 2.0);
   - superbg tiene `es-aa(nivel: "grande")` (3:1) y `contrast.typ` no.

   La diferencia numérica es despreciable, pero es justo la deriva que un test de equivalencia detectaría.

4. **La API está en tres idiomas.** superbg en español (`bg-plano`, `colores`, `opacidad`), theme en inglés (`define`, `primary`), tokens en español con dos excepciones inglesas, y mi sistema en inglés (como pedía la tarea). Una llamada como `superbg("aurora", theme: t, colores: (…))` ya mezcla idiomas. Es una decisión que el usuario debería tomar explícitamente, una vez y para todo el proyecto, antes de integrar.

5. **`accent` significa dos cosas** en theme y en mi sistema (§ a.2). Si nadie lo decide, el primer cartel integrado pondrá el acento en el color equivocado sin que falle nada.

6. **Un fondo dibujado necesita igualmente un color de papel. [confirmado]** Ningún preset de superbg declara su color dominante como tal. Para los vaciados y el contraste (§ a.1) haría falta que cada preset exponga su `paper`: el color de su capa plana base o, si no la tiene, el tono medio.

7. **Una medida absoluta es una decisión de formato escondida.** Esto vale para superbg (`paso: 48`) y también para `theme.base.fonts`, que no fija tamaños. El proyecto tiene formatos de 1080 a 3840 y nada en superbg escala con ellos. Mi `unit` (lado corto / 1080) es una solución barata que superbg podría adoptar sin perder su independencia: basta con un parámetro `unidad`.

---

## (e) Lo que añaden los siete módulos que no había leído

**e.1 El tamaño es un contrato implícito.** Todas las capas SVG reciben `size` como viewBox y se colocan a 100 %×100 % con el ajuste *cover*. Si `size` no coincide con el lienzo, la capa **se escala y se recorta en silencio** (medido: ×1,25 con `sizes.instagram` en 1080×1350). Por eso `layer-context` entrega `extent`, el tamaño real con sangrado, para que nadie tenga que acordarse de copiarlo.

**e.2 Varias capas pintan su propio fondo por defecto, y eso tapa el `paper`.** `topo` (`fondo: #fafaf9`), `halftone` y `olas` (`fondo: white`), `memphis` (`fondo: theme.light`), `rayos` (`white`) y `papel` (#efe4c8) dibujan un rectángulo sólido debajo de su trazo. Como `backdrop`, ese rectángulo **sustituye al papel visible** mientras mis componentes siguen usando `paper` para los vaciados: la cifra «en papel» saldría crema sobre un fondo blanco. Hay dos salidas:
- pasar `fondo: none` (lo que hace la prueba);
- pasar `theme: l.theme`, con lo que `memphis` toma `light = paper`.

Lo correcto en superbg sería que el fondo por defecto fuera `none`, o el `light` del tema, en todas las capas.

**e.3 superbg no es solo «fondos»: tiene capas que van encima.**
- `bg-cafe` se documenta «encima del texto, si la taza se apoyó después de imprimir».
- `tinta-gastada` ni siquiera es una capa: es un **relleno de texto** (`text(fill: tinta-gastada(...))`).
- `bg-frame` dibuja una tarjeta central con margen de 80, es decir, **define el área de contenido**.
- `bg-vidrio` es un panel de primer plano.

Esto es lo que me llevó a añadir `overlay`. También dice algo del nombre del paquete: «superbg» agrupa por técnica (SVG generativo), no por posición en la pila. Yo lo ordenaría así:

| Capa | Piezas de superbg |
|---|---|
| fondo (backdrop) | plano, gradiente, aura, malla, olas, topo, patrón, halftone, rayos, memphis, papel, imagen |
| pátina (overlay) | café, manchas, viñeta, ruido |
| contenedor | frame, vidrio |
| tratamiento de texto | tinta-gastada |

`frame` choca de frente con mi retícula: su margen (80) debería ser el de `raster`.

**e.4 `azar.typ` hace los dibujos reproducibles.** Es un LCG (generador congruencial lineal) determinista con semilla, sin estado: la misma semilla da el mismo papel, la misma malla y el mismo confeti. Es la propiedad correcta para un sistema que se compila. Mi librería no tiene azar, porque ningún cartel suizo lo usa. Si algún día lo necesita, debería usar este módulo y no otro.

**e.5 `papel` está muy trabajado y es honesto con su coste.** Combina manchas de humedad (ruido de baja frecuencia), fibras, grano, óxido concentrado hacia los bordes, bordes tostados y sombra del lomo al escanear. Las manchas de café tienen el borde más oscuro porque el café se seca hacia afuera. El módulo avisa de que Typst rasteriza los filtros (la capa deja de ser vectorial) y corrige el U+2212. Las cuatro manchas reales (`assets/cafe/A–D.svg`, de dominio público) están presentes. Como siempre en superbg, las frecuencias del ruido van en px absolutos: el grano no escala con el lienzo.

**e.6 Unidades mezcladas dentro de una misma función.** `bg-blob(x, y, radio, …)` pide `x`/`y` como longitudes y `radio` como número que multiplica por 1 pt. `bg-mancha-cafe` usa fracciones del formato. Las demás capas usan números en unidades del viewBox. Un usuario no puede saber qué espera cada parámetro sin leer el código. Mi propuesta de una sola convención (unidades de referencia relativas al lado corto) resolvería eso también.

**e.7 `image-bg` documenta bien su trampa:** una ruta en texto se resuelve relativa al paquete, así que hay que pasar bytes leídos por el llamador.

### Tabla de verificación

| Afirmación de la versión anterior | Estado | Evidencia |
|---|---|---|
| Medidas absolutas en superbg | **corregido**: mixto (las capas de color son relativas; las de trazo y trama, absolutas) | lectura de spots, mesh, waves, topo, memphis y papel; `pruebas/superbg/escala.png` |
| `sizes.instagram` = 1080×1080 frente a carteles de 1080×1350 | **confirmado**, y con efecto visible (×1,25 y recorte) | `pruebas/superbg/tamano.png` |
| Las claves de capa no se validan | **confirmado** | `pruebas/superbg/claves.typ` compila con `opcidad` y `step` |
| Colores por defecto escritos a mano | **confirmado y ampliado** (9 hex) | todos los módulos |
| Las tramas ignoran la retícula | **confirmado** | `tamano.png`; memphis al azar |
| El halftone es el mismo algoritmo que mi `mark-dot` | **confirmado** | `tramas.typ` |
| Ningún preset declara su `paper` | **confirmado, y además 6 capas pintan su propio fondo** | e.2 |
| Contraste implementado «tres veces» | **corregido**: dos, que ya divergen | `contrast.typ` frente a `superbg/color.typ` |
| El panel de vidrio tiene coordenadas fijas | **confirmado** | `presets.typ` (`vidrio-aura`), `compose.typ` |
| El ruido en tesela con el peso medido | **confirmado** | `pattern.typ` |
| superbg es independiente de Instatypst | **confirmado** (ningún import; los assets se leen relativos al paquete) | todos los módulos |

### Qué cambió en la librería en esta pasada

1. **`backdrop` recibe el contexto** `(canvas, palette, extent, theme)` en vez del lienzo solo (por e.1 y e.2), y **cubre el sangrado**.
2. **Nuevo `overlay`**, simétrico a `backdrop` y encima del contenido (por e.3).
3. **Nueva función exportada `layer-context`**, para quien quiera construir el contexto fuera de `poster`.

Las paletas no cambian por esta lectura: la propuesta del § a.2 se mantiene. Lo único que se añade es que `layer-context.theme` es ya, en pequeño, el puente `swiss-roles` en sentido inverso: de mis roles a la forma de tema que entienden superbg y theme.
