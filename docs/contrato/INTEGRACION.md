> Origen: derivado por un agente en `suizo-agentes/sistema-opus/` (nov 2026). Las rutas `lib.typ`, `pruebas/` y `ejemplos/` se refieren a ese directorio; `core/` y `src/` al proyecto.

# Integración con core (primitivas, v2, recetas, Nix)

Leído entero: `core/primitivas.typ`, `v2/` (frame, parts, primitives, swiss, series y PENDIENTE.md), `recetas/suizo.typ`, `scaffold.typ`, `nombres.toml`, `nix-exp/` y el texto de `informe-nombres.html`.

Todo lo que afirmo sobre el comportamiento de vuestro código lo he **compilado**:
- `integracion/swiss-original*.png`: vuestro `swiss` en cuatro formatos.
- `integracion/prueba-contrato.sh`: el contrato generado.
- Las pruebas de nombres y de lectura de hijos que cito en § 5.

Signos de la tabla: **=** coincidencia exacta (mismo nombre, mismo significado) · **≈** equivalente con distinto nombre · **≠** choque (misma palabra, otra cosa) · **—** hueco (no existe en ese lado).

---

## 1. Correspondencia de nombres

### Lienzo y formato

| sistema-opus | core | Signo | Comentario |
|---|---|---|---|
| `canvas(format, width, height, medium, bleed)` | `artboard` (str \| dictionary: size, medium) | ≈ | El mismo concepto. **`medium` coincide exactamente**, también en sus valores: print \| screen \| wallpaper. Adopto `artboard` como nombre público (es vuestra decisión y es mejor que `canvas`, que en Typst evoca dibujo). |
| `formats` (feed-portrait, feed-square, story, slide, wallpaper-uhd, wallpaper-phone, print-a3, print-a2) | `formats` (retrato, cuadrado, **instagram = 1080×1080**, story, twitter, linkedin) | ≈ | Mismo papel, otras claves. Vuestra tabla está **tres veces**: `primitivas.formatos`, `v2/primitives.formats` y `superbg.sizes`. Las tres llaman `instagram` al cuadrado. |
| `canvas.width/height` (length) | `format` (array de px), `dimensions()` / `medida()` | ≈ | Vosotros pasáis números en px y convertís; yo paso longitudes. |
| `unit` (lado corto / 1080) | `escala(formato)` = min(w/1080, h/1080) | **=** en valor | Es literalmente la misma cantidad. `rejilla` usa otra: u = lado corto / 1000. |
| `bleed` (sangrado de imprenta, más allá del corte) | `bleed` en `celda` (estirar la celda hasta el borde) | **≠** | Misma palabra, dos conceptos. El vuestro es mi `extend`. En imprenta «bleed» es lo mío; propongo `extend` (o `to-edge`) para lo vuestro. |
| `reference-side`, `media`, `orientation` | `bp.aspecto` (vertical, apaisado, ultra) | ≈ / — | Vosotros distinguís también «ultra» (más de 2:1); yo no. |

### Preset, variante y capas

| sistema-opus | core | Signo | Comentario |
|---|---|---|---|
| `poster(…)` | `frame(…)` | ≈ | Los dos abren una lámina. `frame` despacha a un preset; `poster` es el lienzo con capas, sin preset. |
| — | `preset` (auto = `blank`, "swiss", "series", función) | — en mí | No tengo presets. Lo que tengo es lo que un preset *compone*. `swiss-compuesto.typ` demuestra que encaja (§ 3). |
| `raster-guides(style: "rules" \| "cells" \| "rows" \| "baselines" …)` | `type` / `variant` de swiss: lines, cells, shifted, baseline | ≈ | Vuestras cuatro variantes son mis estilos de guía: lines → `rules`, cells → `rules` + `rows`, baseline → `baselines`, shifted → `raster-with(offset:)` por franja. |
| `style` (parámetro de `raster-guides`) | `style` (cajón de ajustes, abierto) | **≠** | Además Typst usa `text(style:)` para la cursiva. Tercer significado. Ver § 5. |
| `backdrop`, `overlay`, `layer-context` | «capas» (biblioteca de recursos), `brand` como función (color, lienzo) | ≈ | Mismo modelo: lienzo más capas opcionales. Vuestra `resolve-brand(brand, color, format)` es mi patrón de capa-función, en pequeño. |
| `use-raster`, parámetro `raster:` | — | — en core | — |

### Color

| sistema-opus (`palette`) | core v2 (`theme`) | core v1 (`temas-lamina`) | Signo |
|---|---|---|---|
| `paper` | `background` | `fondo` | ≈ |
| `ink` | `ink` | `tinta` | **=** |
| `accent` | `accent` | `acento` | **=**. Ojo: `accent` en `src/theme.typ` es otra cosa (ver COMENTARIOS § a.2). |
| `quiet` | `muted` | `suave` | ≈ |
| `guide` | `rule` | `linea` | ≈ en el valor, pero **`rule` ≠**: en mí `rule` es el componente filete, no un color. |
| `tint`, `swatches` | — | `amarillo`, `azul` (bauhaus) | — / ≈ |
| `palette` (los roles) | `theme` (solo colores en v2) | `tema` | **≠** con `src/theme.typ`, donde `theme` = colores **y** fuentes. Hoy «theme» significa dos cosas en el proyecto. |
| `palettes.<nombre>` | `themes.<nombre>` (suizo, lamina) | — | ≈ |
| derivación de `guide` (mezcla del 82 %) | derivación de `rule` (mezcla del 12 % de tinta) | `derivados-lamina` | ≈. Es la misma idea con el porcentaje expresado al revés. |

### Tipografía

| sistema-opus | core | Signo | Comentario |
|---|---|---|---|
| `typeface.main` | `fonts.body` (propuesto), `fuente` (v1) | ≈ | — |
| `typeface.display` (nuevo, por swiss) | `fonts.headline` / `fuente-remate` (Bebas Neue) | ≈ | Coincide con el rol `display` de font-pairings. |
| `typeface.annotation` | `fonts.label` / `fuente-rotulos` (Inter, **no mono**) | ≈ | El rol es el mismo aunque la fuente no lo sea: en swiss los rótulos van en Inter. Por eso nombré el rol por su función (anotar) y no por «mono». |
| `step-size`, roles `kicker`… `numeral` | tamaños fijos dentro del preset (22, 44, 66 pt) | — en core | v2 lo dice explícitamente: «las fuentes y medidas son del preset, no parámetros». |
| `fitted(fit: "width")` | `fit-to-width` / `cuerpo-al-ancho` | ≈ | Lo mío envuelve lo vuestro con un rol y una caja. |
| `fitted(fit: "height")` | `fit-to-height` / `ajustar-alto` | ≈ | — |
| — | `ajustar` (además comprueba que **la palabra más larga** quepa) | — en mí | Hueco real: mi `fitted` puede dejar que una palabra larga se salga por la derecha. Lo adoptaría. |
| `fitted(side-bearing:)` | `margin - 0.035 * s` (en swiss, a mano) | ≈ | Lo he convertido en parámetro. |

### Hijos de contenido y roles de texto

Aquí está el choque más importante. **Vuestros nombres son *partes* (qué contenido hay) y los míos son *roles* (cómo se compone un texto).** Varios coinciden en la palabra:

| core (parte) | v1 | sistema-opus | Signo | Comentario |
|---|---|---|---|---|
| `statement` | title | `prose` / `lede` | ≈ | En swiss, el statement se compone como prosa ajustada. |
| `headline` | **conclusion** | `headline` (rol) | **≠ moderado** | En swiss, `headline` es el **remate** que se lee al final («…en su / PUREZA.»). En mí, `headline` es el titular que se lee primero. Las dos son la letra dominante, pero el orden de lectura es opuesto. El nombre v1 (`conclusion`) era más exacto. |
| `display` (alias de headline) | — | `display` (rol interno del titular dominante) y `typeface.display` (rol de fuente) | **≠** | Tres sentidos. Recomiendo retirar vuestro alias (lo dejáis abierto) y que `display` sea solo rol de fuente, como en font-pairings. Mi rol interno no es API pública (se usa como `headline(dominant: true)`). |
| `eyebrow` | label | `kicker` | ≈ | Mismo concepto, otra metáfora. `eyebrow` está en uso y es tan bueno como `kicker`; me quedaría con el vuestro. |
| `question` | subtitle | `lede` | ≈ | `question` es más estrecho (presupone una pregunta). |
| `author`, `dates` | attribution | `facts` / `note` | ≈ | Yo no tengo partes; en swiss los dibujo con `kicker` y `note`. |
| `brand` | signature | — | — en mí | Ver § 3: mi brand no escala. |
| `title`, `detail` (series) | — | `headline`, `prose` | ≈ | **`title` choca con un elemento de Typst** (lo he comprobado). |
| — | — | `index`, `colophon`, `subhead`, `numeral`, `note` | — en core | Son roles que salen de los carteles. En core aparecerán como `mono-footer`, `number-block`… |

### Primitivas y recursos

| sistema-opus | core | Signo |
|---|---|---|
| `raster`, `resolve-raster`, `column-x`, `span-width`, `row-y`, `span-height`, `line-y`, `region` | `columns()` (v2), `reticula()` (primitivas), `rejilla()` con `contenedor`/`celda`/`en-celda` (WallTypst) | ≈. Vosotros tenéis **tres** retículas; con la mía son cuatro. |
| `put(col, span, row, rows, line, extend, anchor, align)` | `en-celda(col, span, row, rows, offset, bleed, align, inset)` | ≈. Vosotros numeráis desde 1 y tenéis `inset`; yo numero desde 0 y tengo `line`, `until`, `from: bottom` y `anchor`. |
| `raster-guides`, `column-indices`, `row-indices` | `depuracion()`, col-rules, cell-grid, baseline-grid (inventario) | ≈ |
| `flow(top, fill, bottom)` | — (swiss y series lo hacen a mano dentro de `context`) | — en core |
| `fields` + `mark-fill` / `mark-dot` / `mark-quarter` | step-matrix, halftone, quarter-tiles, density-bands | ≈ (yo: un componente y marcas; vosotros: un recurso por caso) |
| `bars(accent-at)` | growing-bars (`break-at`) | ≈ |
| `accent-at` (parámetro de cualquier serie) | odd-one-out (recurso) | ≈. Lo defiendo como **parámetro**: no es un recurso aparte, es una propiedad de cualquier serie. |
| `timeline`, `crop-marks`, `misregister`, `dot` | timeline, crop-marks, misregister, dot | **=** |
| `hero-glyph`, `listing`, `month-calendar`, `color-bar`, `callout`, `registration-marks`, `text-columns` | giant-glyph, rule-table, calendar, color-strip, number-block, registration-mark, multi-column | ≈ |
| `colophon`, `kicker` (roles) | mono-footer, mono-eyebrow (recursos) | ≈ |
| — | text-stairs, target | — en mí: se componen con `put` y `shape` (r2-haiku-5 y r2-haiku-4) y no merecen función propia. |
| `section`, `facts`, `legend`, `margin-frame`, `arrow`, `fitted` | — | — en el inventario de core |
| — | `area-trabajo`, `encajar`, `pliego`, `plano`, `marca`, `atribucion`, obstáculos (`ob-*`, `choca`, `libre`, `mayor-caja-libre`), breakpoints, zonas seguras, `container: fixed` / `max-width` | — en mí |
| — | `part`, `read-parts` | — en mí |
| — | `repeat`, `index`, `total`, `next` | — en mí |

**Resumen del recuento:**
- **Coincidencias exactas** (5): `ink`, `accent`, `timeline`, `crop-marks`, `misregister`, más `dot`, el valor de `unit`/`escala` y los valores de `medium`.
- **Choques** (7): `bleed`, `style`, `rule`, `headline` (orden de lectura), `display` (triple), `theme` (colores frente a colores+fuentes) y `title` (elemento de Typst).
- **Equivalencias:** casi todo lo demás.

---

## 2. Duplicados, huecos y qué hacer con ellos

### Lo que ya está en las dos librerías (duplicado)

| Concepto | core | sistema-opus | Qué haría |
|---|---|---|---|
| Unidad relativa al lienzo | `escala` (y u = 1/1000 en `rejilla`) | `unit` | **Fundir** en una sola convención. Que `escala` y `unit` coincidan en valor sin haberse coordinado es un buen indicio de que la convención es la correcta. Descartaría el 1/1000 de `rejilla` (o lo dejaría como detalle interno de WallTypst). |
| Retícula | `columns`, `reticula`, `rejilla` | `raster` | **Fundir** en una. La base: `rejilla` por sus breakpoints y zonas seguras, con mi semántica de posición (`line`, `until`, `from: bottom`, `anchor`) y mi validación de claves. Nombre: `raster` (ver § 5 sobre `grid`). |
| Ajuste de texto | `fit-to-width`, `fit-to-height`, `ajustar` | `fitted` | **Conservar** vuestras primitivas por debajo (medida pura, sin estilo) y **mi `fitted` encima** (rol + caja). Añadir a `fitted` la comprobación de la palabra larga de `ajustar`. |
| Temas o paletas | `themes` y `resolve-theme` (más `temas-lamina` y `resolver-tema`) | `palettes` y `resolve-palette` | **Fundir**. Roles con mis nombres o los vuestros (ver § 5), colores desde `src/tokens.typ`. |
| Formatos | tres tablas | `formats` | **Una sola**: la de `artboard`, con `medium` y `bleed`. Descartar `instagram = 1080×1080`. |
| Contraste | `luminance`, `contrast`, `readable-on` **copiados** en `primitivas.typ` | (uso `texto-sobre` vía superbg) | Es la tercera copia en el proyecto (con `contrast.typ` y `superbg/color.typ`). El modelo shadcn está bien para el usuario final, pero dentro del núcleo multiplica la deriva que ya os mordió una vez. |

### Lo que falta en mi librería (y lo adoptaría)

1. **`part` / `read-parts`, el modelo de contenido.** Mi sistema compone; no sabe qué es cada texto. Un preset necesita las dos cosas: las partes dicen *qué* hay y mi API dice *dónde y cómo*. Es la pieza que convierte mis composiciones en presets reutilizables.
2. **`repeat`, `index` y `total`, las series.** Mi colofón «02 / 05» se escribe a mano.
3. **Zonas seguras y breakpoints** (de WallTypst). Para `medium: wallpaper` son imprescindibles: la barra de tareas y los iconos del escritorio. Mi sistema escala, pero no esquiva nada.
4. **Obstáculos y `mayor-caja-libre`**: colocar texto donde una figura deja hueco. Ninguno de los 20 carteles lo necesitó, porque todos componen sobre retícula, pero un preset con imagen sí lo necesitará.
5. **`ajustar` con la palabra más larga**, comentado arriba.
6. **`marca` proporcional a √(ancho × alto)**: una marca que ocupa la misma fracción del lienzo en cualquier formato. Es una ley de escala distinta de la mía (lado corto) y mejor para marcas. Hoy, en mi composición de swiss, la marca **no escala** (§ 3).
7. **`pliego`** (una página que también cabe en una caja): serviría para hacer un catálogo de mis 20 ejemplos en un solo PDF.
8. `encajar` y `area-trabajo` (meter una lámina de base fija en otro rectángulo). Mi sistema no lo necesita porque compone de forma nativa en cada tamaño; solo lo usaría para catálogos.

### Lo que falta en la vuestra

1. **`flow` (reparto vertical con un tramo elástico).** `swiss` y `series` repiten a mano la misma danza (medir, restar, colocar, encoger) dentro de `context`. Es la primitiva que os falta, y es la que hizo posible `swiss-compuesto` con 30 líneas de composición.
2. **Unidad aplicada a todo.** v2/swiss usa medidas absolutas en pt (`margin = 64pt`, `196pt`, `150pt`, `22pt`, `44pt`). En 3840×2160 la cabecera queda microscópica y el remate enorme, porque el remate es lo único que se ajusta (`swiss-original-wallpaper-uhd.png`). `escala` existe en `primitivas.typ` pero v2 no la usa.
3. **Roles tipográficos y escala.** Los tamaños son números sueltos por preset. Sin roles, el modelo Beamer (re-vestir el contenido) no tiene sobre qué apoyarse.
4. **Validación de claves.** `rejilla` y `celda` leen con `g.at("col", default: 1)`: una errata como `colum` se ignora sin aviso, el mismo problema que superbg.
5. **Retícula visible como una función con modos.** Vuestras cuatro variantes son un parámetro, no cuatro recursos.
6. **Marcas de imprenta y sangrado de impresión**, para `medium: print`.
7. **`accent-at`** como parámetro de serie.

### Qué conservaría, fundiría o descartaría

- **Conservaría:** `frame` + `parts` + `repeat` (el modelo de contenido); `rejilla` (breakpoints y zonas seguras); los obstáculos; `marca` proporcional; la verificación byte a byte con `just cmp`; la batería de casos fuera del demo. De lo mío: la unidad, los roles y la escala, `flow`, `fitted`, `raster-guides`, las capas y la validación.
- **Fundiría:** las cuatro retículas; las tres tablas de formatos; temas y paletas; las primitivas de ajuste bajo `fitted`.
- **Descartaría:** el alias `display` de headline; `style` como cajón; las medidas absolutas en pt dentro de los presets; las copias de contraste dentro del núcleo; y `instagram` como nombre de un formato.

---

## 3. Prueba: `swiss` compuesto con mi librería

`integracion/swiss-compuesto.typ` dibuja vuestro preset solo con la API de sistema-opus: `poster`, `raster`, `raster-guides`, `put`, `rule`, `kicker`, `note`, `lede`, `flow`, `fitted` y `arrow`. El contenido está en `contenido.typ` y es el del comentario de `v2/frame.typ`, completado. `swiss-original.typ` compila vuestro `frame(type: "swiss")` desde la copia con el mismo contenido.

**Resultado a 1080×1350:** 0,31 % de píxeles distintos (antialias y posiciones subpíxel). La cabecera coincide al píxel, medida por franjas de tinta.

| Formato | Original | Compuesto | Comportamiento |
|---|---|---|---|
| 1080×1350 | `swiss-original.png` | `swiss-compuesto.png` | igual (0,31 %) |
| 1080×1080 | `…-feed-square.png` | `…-feed-square.png` | igual |
| 1080×1920 | `…-story.png` | `…-story.png` | igual: el aire crece y la frase mantiene su cuerpo |
| 1920×1080 | `…-slide.png` | `…-slide.png` | igual: el remate se limita al 55 % del hueco |
| 3840×2160 | `…-wallpaper-uhd.png` | `…-wallpaper-uhd.png` | **distinto, a favor del compuesto:** el original deja la cabecera microscópica; el compuesto escala entero, salvo la marca |

**Variantes:** `--input variant=cells|baseline` cambia solo la capa de retícula (`swiss-compuesto-cells.png`, `-baseline.png`). `shifted` no tiene sentido en un preset de una sola franja, y lo rechazo con un mensaje.

**Qué tuve que añadir a mi librería para igualarlo** (ninguna de estas cosas salía de los 20 carteles):
1. `typeface.display`: un tercer rol de fuente para Bebas Neue (por defecto = `main`, así que los 20 ejemplos no cambian).
2. `fitted`: texto ajustado al ancho o al alto de su caja, con tope de alto y `side-bearing` (la corrección óptica de 0,035 × cuerpo que swiss hace a mano).
3. `flow`: arriba fijo, medio elástico, abajo fijo. Es el «apilador vertical» que LIMITES.md señalaba como el límite real de mi sistema. swiss lo confirma.
4. `arrow`.

Con eso, todas las reglas de swiss se expresan como composición:
- techo = bloque + 40;
- remate a todo lo ancho, con la mayúscula como máximo al 55 % del hueco;
- frase en 4 columnas que se achica de 2 en 2 hasta caber en el hueco − 48;
- el aire (≤ 150) cede antes que la letra;
- la flecha va de la frase a la mitad del aire.

**Qué no logra, o logra con trampa:**
- **El espacio entre eyebrow y question.** El original lo hereda de la separación de párrafo por defecto de Typst (`tag; v(4pt); text` son párrafos distintos). Lo imito con `v(8.5u + 1.2em)`. Es el mismo accidente que en S3 (sonnet/cartel-3): el PNG depende de un valor por defecto que nadie eligió.
- **Las medidas de swiss no caen en ninguna línea base** (18, 196, 150, 112, 40, 48, 14). Las expreso en líneas fraccionarias de 24 (0,75; 5,5; 3,58; 2), lo que indica que el preset no tiene retícula vertical, solo horizontal.
- **La marca no escala** en 4K, porque llega como contenido con un `26pt` fijo. Falta que `brand` reciba el contexto de capa (unidad y color), como hace vuestro `marca(…)`.
- **La composición de la frase ocupa unas 15 líneas de geometría** dentro de `fill: geo => …`. Es razonable: son las reglas del preset. Pero sugiere una primitiva más, «bloque apoyado abajo con aire elástico», si otro preset la repite.

**¿Se sostiene «lienzo + capas + preset»?** Sí, con una matización: el preset no es una lista de capas independientes. La capa de composición (el `flow`) tiene reglas que relacionan unas partes con otras: la frase depende del remate. Las capas decorativas (retícula, cabecera, pie) sí son independientes, y la variante solo toca una de ellas. La estructura que funciona es:

- **preset** = contrato de partes + capas fijas + **una** capa de composición con sus reglas;
- **variante** = cambiar una capa fija.

---

## 4. Contrato en Nix

`integracion/contract.nix` → `gen.nix` → `swiss-contrato.typ` (Typst) y `swiss-contrato.json`. **Generado con Nix de verdad**: este entorno tiene Nix 2.34; vuestro PENDIENTE dice que en la máquina Arch no está.

```sh
nix eval --raw  --extra-experimental-features nix-command -f integracion/gen.nix swiss > integracion/swiss-contrato.typ
nix eval --json --extra-experimental-features nix-command -f integracion/contract.nix presets.swiss
integracion/prueba-contrato.sh   # 1 válido, 7 inválidos rechazados con su mensaje
```

**Qué declara** (tipos exactos de Typst):

| Parámetro | Tipos | Default | Validación además del tipo |
|---|---|---|---|
| `artboard` | str \| dictionary | "feed-portrait" | enumeración si es str; claves `size: array`, `medium: str`; `medium` ∈ print \| screen \| wallpaper; `size` = (ancho, alto) positivos |
| `variant` | str | "lines" | ∈ lines \| cells \| shifted \| baseline |
| `theme` | auto \| str \| dictionary | auto | ∈ suizo \| lamina; claves background/ink/muted/accent/rule, todas `color` |
| `accent` | auto \| color | auto | — |
| `brand` | none \| content \| str \| function | none | — |
| `author`, `dates` | none \| content \| str | none | — |
| `repeat` | none \| int \| array | none | int ≥ 1 |
| partes | `statement` (requerido, o contenido suelto), `headline` (requerido), `eyebrow` y `question` (opcionales) | — | `swiss-check-parts` |

**Qué genera:**
- un `_chk-<param>` por parámetro;
- `swiss-contract` (el contrato como datos: para documentación, MCP o el índice de recursos);
- `swiss-defaults`;
- `swiss-args(..)`, que **rechaza argumentos desconocidos**, rellena los que faltan y valida;
- `swiss-check-parts`;
- el JSON.

**Tres cosas que salieron al hacerlo:**
1. **Vuestro `nix-exp/contract.nix` ya se ha desviado del código:** declara `theme: str` y `brand: none | content | str`, pero v2 acepta `theme` auto o diccionario y `brand` función. Es exactamente la deriva que Nix debía evitar. Pasa porque el contrato se escribió aparte de la firma de `make`. Remedio: generar también la firma del adaptador `make` (o hacer que `make` llame a `swiss-args`), para que no existan dos listas de parámetros.
2. **`str(type("a"))` es `"string"`, no `"str"`** (y `int` sale como `"integer"`). Mi primer generador comparaba nombres de tipo como texto y rechazaba `medium: "screen"`; lo detectó `prueba-contrato.sh`. El generado debe comparar **tipos reales** (`std.type(x) in (str,)`), nunca sus nombres. Vuestro `isT` lo hace bien con `std.type(v) == str`; el riesgo aparece en cuanto se generen mensajes o tablas de claves.
3. **Los hijos también son contrato:** cuáles son obligatorios y la regla de lectura (el contenido suelto cae en `statement`). Si solo se declaran los parámetros, el contrato no dice lo más importante de un preset.

---

## 5. Opinión crítica

### Errores o riesgos

1. **Nombres que chocan con Typst.** Lo he comprobado compilando:
   - `columns` lo exporta `v2/primitives.typ` y tapa la función `columns()` de Typst en quien haga `import *`;
   - `title` (hijo de `series`) tapa el elemento `title` de Typst 0.14+;
   - `grid` está «reservado para la grilla real de WallTypst» (scaffold.typ), pero `grid` es una función de Typst;
   - `repeat`, como parámetro de `frame`, tapa `repeat()` dentro de la función.

   Ya os pasó con `type`. Propongo pasar `pruebas/nombres-libres.sh` (es genérico) a vuestro árbol.
2. **`type` como argumento de variante.** Renombrar `type` → `preset` es correcto, pero reutilizar `type` para la variante mantiene la sombra sobre `std.type` en cada función que la reciba. Ya tenéis `variant` en el contrato v1: usadlo. Mi contrato lo hace.
3. **Medidas absolutas en los presets.** El modelo «artboard con varios medios» promete wallpaper 4K, pero v2/swiss no escala (ver la prueba en 3840×2160). Si un preset no se compone en unidades relativas, cada formato nuevo es un preset nuevo.
4. **La lectura de hijos pierde contenido sin avisar** (`parts.typ`, comprobado):
   - `*#eyebrow[DEL ENSAYO]*` (un hijo dentro de una negrita) **no se encuentra**, porque `_flatten` solo recorre `children`, no `body`; el `strong` entero cae en `content` y se dibuja como si fuera la frase;
   - dos `#statement` seguidos: gana el último, sin aviso;
   - el contenido suelto se detecta con `repr(c.func()) != "space"`, que depende de cómo Typst imprime un tipo.

   Para un sistema que valida cada argumento, la lectura de hijos es el punto ciego.
5. **Duplicación dentro del núcleo**: tres tablas de formatos, tres o cuatro retículas, tres copias del contraste. El modelo shadcn (copiar para ser dueño) es bueno para el usuario final y malo dentro del propio núcleo.
6. **«theme» significa dos cosas**: solo colores en v2, colores y fuentes en `src/theme.typ`. Y su rol `rule` es un color, mientras que en cualquier librería de layout `rule` es un filete. Hay que decidirlo antes de que existan más presets.

### Lo que defendería de lo vuestro

- **`artboard` + `medium`**: coincide con mi `canvas` + `medium` hasta en los valores, sin habernos coordinado.
- **`blank` como valor escrito de `preset: auto`**, y la distinción `auto` ≠ blank en `theme`.
- **Partes semánticas** (`statement`, `headline`, `eyebrow`…) separadas del dibujo, con el preset como adaptador. Es lo que mi sistema no tiene.
- **La verificación byte a byte** contra v1 y la batería de casos fuera del demo (que destapó la regla oculta de eyebrow + question). Es el mismo método que usé con los 20 PNG.
- **Nix como fuente única** de contrato, JSON, tabla de traducción e índice. Typst no puede listar directorios ni introspeccionar firmas; Nix sí.
- **El inventario de recursos con `seen-in`**. Pero los tres «recursos» que en mi sistema son parámetros (odd-one-out → `accent-at`, y col-rules / cell-grid / baseline-grid → modos de `raster-guides`) deberían serlo también en el vuestro.

### Mis respuestas a vuestro PENDIENTE

| # | Pregunta | Mi posición |
|---|---|---|
| 1 | `display: format` | Resuelto con `artboard`. Retirar también el alias `display` de headline. |
| 2 | preset / type | `preset` = familia, `variant` = forma (no `type`). La función propia va en `preset`. |
| 3 | `presets/` | Sí, con el índice generado por Nix. Para no perder el error propio ante un preset desconocido, que `frame` consulte primero el índice generado (una lista) y solo después importe. |
| 4 | `repeat` | Aceptar las dos formas: datos (un array de diccionarios de partes: serializable, válido para JSON y MCP, y lo que hace posible Beamer) o una función (flexibilidad). `total` debería poder darse explícitamente para el caso portada + N. |
| 5 | Los 15 parámetros sin nombre | La mayoría no deberían ser parámetros. Colores → roles de tema. Fuentes → roles de `typeface`. Columnas, margen y medianil → `raster`. `cuerpo-frase` y `aire` → reglas del preset (`fitted` y `flow` ya las expresan). `frase-y` y `flecha-hasta` → no exponerlos: son coordenadas de escape. Quedan unos cuatro con nombre. |
| 6 | Beamer | Sí, y vuestras partes ya son el vocabulario común. Lo que falta es que cada contrato declare qué partes consume y qué hace con las que no conoce. Mi contrato lo declara. |
| 7 | Reglas de lectura | Recorrer también `body`, avisar de hijos repetidos y no depender de `repr` (ver riesgo 4). |
| 8 | Nix | Generar también la firma del adaptador, y comparar tipos, no nombres de tipo (§ 4). |

### Lo que me falta saber

- **El idioma definitivo de la API.** Hay cuatro mezclas: core (inglés), primitivas (español), superbg (español) y src/theme (inglés).
- **Si `medium: wallpaper` en 4K es un requisito real.** De eso depende que «medidas relativas en todos los presets» sea obligatorio o deseable.
- **Quién escribe los carteles: personas en Typst, o JSON y MCP.** Cambia cuánto pesan la lectura de hijos frente al contrato de datos, y si `repeat` debe ser datos o función.
- **Si `swiss` debe seguir siendo idéntico byte a byte a v1** cuando pase a unidades relativas. Hoy coincide en 1080, pero no puede coincidir en 4K y ser correcto a la vez.

---

## Cambios en la librería en esta fase

- **Nuevos componentes:** `fitted`, `flow` y `arrow`.
- **Nuevo rol de fuente `display`** (por defecto = `main`). `typeset` acepta `size` en unidades de referencia, como salida para `fitted`. `hero-glyph` usa la fuente `display`.
- **Pruebas tras los cambios:** `nombres-libres.sh` da 69 nombres, 0 choques; `validacion.sh` da 27 casos (3 nuevos), los 27 fallan con mensaje; los 20 ejemplos recompilan sin diferencias visibles.
- **Corrección de la fase 1:** en `ejemplos/haiku-5.typ` cambié `crop.y` de 0,08 a 0,03 y no lo comprobé. Menos recorte sube la letra, así que la corrección fue en sentido contrario y la S quedó 130 px más alta que en el original. Lo encontré al revisar los ejemplos tras el cambio de `display`. Ahora es 0,13 y coincide con el original.
- **Límite conocido de `flow`:** dentro de una caja sin alto explícito, `layout` ve el espacio hasta el final de la página y no puede distinguirlo de un alto declarado. Siempre conviene dar `lines`, `rows` o `until`.
