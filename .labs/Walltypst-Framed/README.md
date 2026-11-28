# Walltypst-Framed — fase 2: adaptar a V2

Las piezas de `../Walltypst/`, reescritas con la API de V2: `frame` + `artboard`
para las dimensiones, elementos de `src/elements.typ` y reglas de preset
(`scaffold` + `ctx`), sin `#set page` a mano.

`src/wall.typ` es hoy un **esqueleto compilable**, no la traducción: lee los
mismos `sys.inputs` que WallTypst, valida el TOML y muestra los tipos de capa
como cuerpo. Hoy está portada la familia de calendarios y relojes como un solo preset, `timepiece` (ver abajo). Lo que no tenga sintaxis en
V2 se marcará `?` en `spec/traduccion-walltypst.typ`; no se inventa azúcar para
que el ejemplo pase.

## Compilación

Mismo arnés y mismos parámetros que en `../Walltypst/`:

```bash
just ref                          # los 47 presets
PRESETS='cartel-capas' just ref   # uno solo
just ref w=1080 h=1080 seed=2     # parámetros explícitos
```

El `--root` se deriva de la posición del script; las rutas a los TOML y JSON
son relativas a ese root. No hay rutas absolutas escritas ni números escondidos
en el arnés. Las dimensiones las impone `frame` vía `artboard`: el SVG de
`cartel-capas` mide exactamente `1920×1080`.

Salida: `out/ref/` y `referencias.sha256` (47 líneas, hash `2db82aff…` estable
entre ejecuciones). La paridad con `../Walltypst/referencias.sha256` **no se
espera todavía**: no hay nada portado. Ese manifiesto es la línea base desde la
que medir regresiones a medida que se porten piezas.

## Portado: `timepiece`

`src/timepiece.typ` reúne 7 presets de WallTypst como variantes de uno (se ignora el prefijo `cartel`):

| variant | WallTypst | píxeles distintos (tolerancia 2 %) |
|---|---|---|
| `month` | `calendario` | 0,06 % (color del texto: negro vs `ink`) |
| `month-verse` | `verso-calendario` | 0 |
| `digital` | `reloj` | 0 |
| `analog` | `reloj-analogico` | 0 |
| `daylight` | `hora-del-dia` | 0 |
| `lords-day` | `dia-del-senor` | 0 (jueves y domingo) |
| `hour` | `cartel-hora` | 0 |

La única diferencia que queda es el color del texto del calendario `month`. La referencia con versión se escribe con
cadena literal (`#work[#"ref  ·  versión"]`), que conserva los dos espacios. Ejemplos en `ejemplos/timepiece-*.typ`; se compilan
desde la raíz del repo: `typst compile --root . .labs/Walltypst-Framed/ejemplos/timepiece-hour.typ out.svg`.

`src/vendor/` guarda lo traído de v1 (`curvas.typ`, `reticula.typ`); ver su README.

## En curso: `anaglyph` (familia tipográfica) y el motor `glitcher`

`src/anaglyph.typ` reunirá los presets de texto en capas de tinta; `src/engines/glitcher.typ` es el motor
(pasadas de tinta, ajuste de una línea a su celda, anclaje, palabras clave). El prototipo del lab
(`.labs/glitcher.typ`, `presets/capas`, `presets/stamp`) es un boceto: difiere 4–79 % de WallTypst.

| variant | WallTypst | píxeles distintos |
|---|---|---|
| `triple` | `cartel-tres-tintas` | 0 |
| `stacked` | `cartel-capas-apilado` | 0 |
| `outline` | `cartel-capas-contorno` | 0 |
| `stacked-key` | `cartel-capas-clave` | 0 |
| `swiss-bands` | `bandas-suizas` | 0 |
| `glyph` | `cartel-capas` | 0 |
| `word` | `cartel-capas-palabra` | 0 |
| `scale` | `cartel-capas-escala` | 0 |
| `edge` | `cartel-capas-canto` | 0 (con `verse` y con `epigraph`) |
| `fade` | `cartel-degrade` | 0 |
| `initial` | `cartel-inicial` | 0 |
| `circle` | `cartel-circulo` | 0 |
| `monogram` | `cartel-monograma` | 0 |
| `roman` | `epigrafe` | 0 |
| `quote` | `cartel-cita` | 0 |
| `quote-echo` | `cartel-cita-eco` | 0 |
| `quote-mark` | `cita` | 0 |
| `twin` | `cartel-inicial-gemela` | 0 (con `verse` y con `epigraph`) |
| `grotesque` | `cartel-inicial-grotesca` | 0 (con `verse` y con `epigraph`) |
| `poster` | `cartel` | 0 (con y sin kicker) |

### `tableau` (composición libre)

`src/tableau.typ`: arte con texto, donde el arte manda.

| variant | WallTypst | píxeles distintos |
|---|---|---|
| `cross` | `cartel-cruz` | 0 |
| `eclipse` | `eclipse` | 0 |
| `void` | `vacio` | 0 |
| `riso` | `riso` | 0 |
| `arch` | `cartel-arco` | 0 (apaisado, vertical y ultra ancho) |

### `inscription` (extensión de verso)

`src/inscription.typ` delega en el `inscription` de V2 y añade 5 variantes:

| variant | WallTypst | píxeles distintos |
|---|---|---|
| `night` | `verso-noche` | 0 |
| `dawn` | `verso-alba` | 0 |
| `ruler` | `escala-versiculos` | 0 |
| `psalm` | `salmo-columna` | 0 (con y sin referencias cruzadas) |
| `parchment` | `verso-pergamino` | 0 |

Pendientes: ver `DEUDA.md`, sección 4.

## Auditoría contra V2 (27 nov 2026): ¿qué está duplicado?

Lo que comparten los presets de Framed vive en `src/common.typ` y `src/engines/glitcher.typ`. Contra `src/` de V2:

| Pieza | ¿Existe en V2? | Estado |
|---|---|---|
| ajuste al ancho de una caja | **sí**: `scaffold.fit-width` | usado en `glitcher.line`; la copia se borró |
| `legible` | parcial: `contrast`, `is-aa` | envoltorio de `contrast` (umbral 3 / 4,5 según tamaño) |
| `verse-block` (fit ×0,95) | no: ningún preset consume `verse`; `fit-down` es aditivo | pieza común |
| `aspect` / `pick` (`{ apaisado, ultra, vertical }`) | no: cada preset decide su aspecto | pieza común; es el «lenguaje de valores» abierto |
| retícula | parcial: `swiss._columns` es privado y solo columnas | `vendor/reticula.typ`, superconjunto |
| `hash`/`azar`/`rango`, meses y días | no | nuevas |

Sin regresión: los 8 presets portados dan los mismos píxeles antes y después de la limpieza.

### Deuda

Todo lo pendiente (módulos, decisiones abiertas, diferencias, lo que falta portar) está en `DEUDA.md`, sección 4.
