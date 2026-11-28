# Spec: el MCP de Instatypst

Borrador del 27 de noviembre de 2026. Describe el servidor MCP que reemplaza al de
v1 (`mcp/server.py`). Vive en `instatypst-cli` (repositorio
[`typst-rrss`](https://github.com/lfreyes97/typst-rrss)), no en este repositorio:
aquí queda el spec porque lo que el servidor consume lo define V2 (`frame`, el
vocabulario y el catálogo de §6).

**Qué se verificó y qué no.** De `typst-rrss` se leyeron el README, los
`Cargo.toml` de sus cinco crates y los tamaños de sus archivos; no se leyó el
código fuente. Lo que aquí se afirma de `bridge` y `piece` se deduce de sus nombres y
de ese README. Cada punto que depende de esa lectura está marcado **(a verificar)**.

## 1. Alcance

El servidor deja a un agente **diseñar y renderizar piezas** con Instatypst V2: elegir
un preset, escribir sus elementos, ver la imagen, corregir. No es una herramienta de
mantenimiento del paquete.

| Dentro | Fuera |
|---|---|
| Descubrir presets, variantes, elementos y opciones | Navegar o modificar el código de `src/` |
| Comprobar y renderizar una pieza | Las funciones de Weft (`impact`, `graph`, `review`, `doctor`) |
| Paletas desde una imagen o un color; contraste | Editar archivos del repositorio |
| Ver las fuentes disponibles | Compilar un `.typ` arbitrario que el usuario escribió a mano |

Lo de mantenimiento se queda en la CLI (`weft …` por `Bash`). Si más adelante el
agente necesita consultar la API del paquete, se puede añadir una herramienta que
use la librería de Weft; no es parte de esta versión (§9).

## 2. Principios

1. **Entrada estructurada, nunca Typst.** El servidor viejo recibía
   `renderizar(codigo)`: Typst crudo en una cadena. Este recibe una **pieza**
   (§4) y el CLI genera el `.typ`. Es la propiedad que más importa: el texto lo
   escribe un modelo, y nada de lo que escribe se interpola a mano en el Typst (el
   «escapado seguro» que el README del CLI ya promete).
2. **Una sola forma.** Toda pieza es `frame(preset:, variant:, artboard:, theme:,
   accent:, brand:, ..options)[elementos]` (DEUDA §1.5). Los presets no tienen
   firma propia, así que el servidor no necesita una tabla por preset: es el fin
   del `firmas.json` de v1 **(a verificar: contenido de `instatypst-piece`)**.
3. **El catálogo es la fuente de verdad.** Qué presets, variantes, elementos y
   opciones existen sale de V2 (§6), no de una copia en el servidor.
4. **Superficie pequeña.** Cada herramienta añade su descripción al contexto de
   toda conversación. Son siete (§5), no más.
5. **Errores que ayudan.** Los problemas se devuelven como datos con ruta y
   sugerencia (§7), no como una cadena de texto del compilador.
6. **Determinista.** La misma pieza da los mismos píxeles. Es lo que permite
   probar el servidor (§10).

## 3. Arquitectura

```
agente ──MCP (stdio)──▶ instatypst mcp
                          ├─ instatypst-piece   modelo de la pieza, validación, markup
                          ├─ instatypst-bridge  genera el .typ, colores, temas
                          ├─ instatypst-engine  Typst embebido (=0.15.1): compila y evalúa
                          └─ instatypst-color   paletas, contraste
                                │
                                └─ paquete V2 (ruta explícita, no el symlink de @local)
```

- Subcomando `instatypst mcp` por **stdio**, con el SDK oficial de Rust
  [`rmcp`](https://docs.rs/crate/rmcp). La versión y el nombre del repositorio
  vigente **(a verificar en crates.io)** antes de fijar la dependencia.
- **Todo en proceso.** El `engine` ya embebe el compilador completo (`typst`,
  `typst-ide`, `typst-render`, `typst-svg`, `typst-pdf`, todos `=0.15.1`), así que ni
  compilar ni evaluar el catálogo lanzan un subproceso.
- **El paquete se carga por ruta**, no como `@local/instatypst:0.1.0`. Ese paquete
  instalado es un symlink a un directorio de trabajo y cambia según la rama
  extraída; el servidor recibe `--package <ruta>` (o `INSTATYPST_PACKAGE`) y
  falla al arrancar si no existe. Lo que cargó se reporta en `catalog` (§5) para que
  no haya dudas de qué V2 se está usando.
- **La versión de Typst** del servidor y la del paquete deben coincidir. El
  servidor las compara al arrancar y se niega a servir si difieren.

## 4. La pieza

Es el único dato que entra por el servidor. Se serializa como JSON.

```json
{
  "preset": "swiss",
  "variant": null,
  "artboard": "retrato",
  "theme": { "paper": "#f3ece2", "ink": "#14110f", "accent": "tw4-amber-600" },
  "accent": null,
  "brand": "@iglesiaraah",
  "options": {},
  "elements": {
    "tag": "Suizo / Agentes",
    "main": "Todo es gracia.",
    "conclusion": "PUREZA.",
    "author": "B. B. Warfield"
  }
}
```

| Campo | Significado | Contrato |
|---|---|---|
| `preset` | Nombre del catálogo. Omitido o `null` equivale a `plain` | DEUDA §1.5, caso 4 |
| `variant` | Variante del preset; `null` es `auto` | caso 3 |
| `artboard` | Nombre de `formats` (`retrato`, `cuadrado`, `instagram`, `story`, `twitter`, `linkedin`) o `[ancho, alto]`; `null` es el formato del preset, o `retrato` | caso 4 |
| `theme` | Roles de color; un tema parcial se completa con el del preset. Cada valor es un color (`#rrggbb`), un nombre de rol o una referencia al catálogo de paletas (`tw4-amber-400`, `rx-tomato-9-dark`, `oc-grape-5`) | §1.7 |
| `accent`, `brand` | Como en `frame` | |
| `options` | Opciones del preset, con los nombres del catálogo. Un nombre que el preset no acepta es un error, no se descarta | §1.4 |
| `elements` | Mapa nombre → contenido. Los nombres son los de `spec/vocabulario.md`. Un elemento que el preset no reconoce **no** es un error del contrato (se dibuja como contenido suelto), pero el servidor lo avisa (§7) | §1.4 |

**Contenido de un elemento.** Es **texto plano** por defecto. Para lo mínimo que un
cartel necesita, la cadena admite una forma estructurada en lugar de Typst:

```json
{ "main": [ "Todo es ", { "emph": "gracia" }, ".", { "br": true }, "Solo gracia." ] }
```

Solo existen `emph`, `strong` y `br`. Cualquier otra cosa se rechaza. **El
servidor nunca acepta ni emite `#…` que venga del cliente.** El escapado cubre al
menos `#`, `[`, `]`, `\`, `$`, `*`, `_`, `` ` ``, `@`, `<`, `>`, `~`, `-` y `//`, y las
comillas de las cadenas generadas **(a verificar: que `bridge/typst.rs` los cubra
todos; ver pruebas en §10)**.

Los elementos con propiedades (`#main(size: 66)[…]`) se expresan como objeto:

```json
{ "main": { "text": "Todo es gracia.", "size": 66, "weight": 700 } }
```

Las propiedades válidas de cada elemento salen del catálogo, como las opciones.

## 5. Herramientas

Siete. Todas devuelven JSON estructurado; `render` devuelve además la imagen.

### `catalog`

Describe qué existe. Sin argumentos devuelve un resumen compacto (nombres y una línea
cada uno); con `preset` devuelve el detalle de uno.

| Entrada | Salida |
|---|---|
| `preset?: string`, `section?: "presets" \| "elements" \| "artboards" \| "pairings"` | `package_version`, `typst_version`, y la sección pedida |

El detalle de un preset incluye: `name`, `variants`, `artboard` por defecto,
`elements` que reconoce, `options` (nombre, tipo, valor por defecto), `extra_roles` y
una pieza de ejemplo mínima. Lo evalúa V2 (§6).

### `check`

Valida una pieza **sin compilar**. Es lo que ya hace `instatypst check --json`.

| Entrada | Salida |
|---|---|
| `piece` | `ok: bool`, `issues: [Issue]` (§7) |

Es la herramienta que el agente debería llamar antes de `render`: barata y precisa.

### `render`

| Entrada | Salida |
|---|---|
| `piece`, `format?: "png" \| "webp" \| "svg"` (png), `ppi?: number` (72), `max_side?: number` | `path`, `width`, `height`, `issues`, y la imagen como contenido MCP |

- Con `--ppi 72`, 1 pt = 1 px, de modo que `artboard` en px es la salida.
- La imagen que se devuelve al agente se **reduce** a `max_side` (por defecto 1024) para
  no gastar contexto; el archivo de `path` va a tamaño completo.
- **Dónde se escribe.** Siempre dentro del directorio de salida del servidor
  (`--out`, por defecto `salida/mcp/`), con un nombre derivado de un hash del
  contenido de la pieza. La misma pieza no se re-renderiza: devuelve la imagen
  existente.
- Los errores del tipo «no cabe» de algunos presets (`leaves`, `inscription`) llegan
  como `issues` con `severity: "error"`, no como un fallo del servidor (§7).

### `typst_source`

| Entrada | Salida |
|---|---|
| `piece` | `source: string` |

Devuelve el `.typ` generado, para que el agente o la persona lo lea o lo guarde. Es
el equivalente de `instatypst generate`. Solo lectura.

### `palette`

Reúne las dos formas de obtener un tema, para no gastar dos herramientas.

| Entrada | Salida |
|---|---|
| `from: { "image": path, "mode"?: "cluster" \| "material" }` o `{ "color": "#rrggbb", "scheme"?: string }` | `theme` con los cinco roles (`paper`, `ink`, `quiet`, `accent`, `guide`), listo para pegar en una pieza; `contrast_warnings` |

Para una imagen, la ruta se resuelve **dentro de las raíces permitidas** (§8). Avisa
si el contraste texto/fondo es bajo, como hace hoy `extract --suggest-accent`.

### `contrast`

| Entrada | Salida |
|---|---|
| `a`, `b`: colores | `wcag: number`, `aa: bool`, `aaa: bool` y, si está habilitado, `apca` |

`apca` solo se devuelve si el paquete lo trae y está habilitado: APCA está dentro de
V2 de forma temporal y con una licencia restrictiva (DEUDA §3.4). Cuando esa
decisión se cierre, este campo se mantiene o se retira.

### `fonts`

| Entrada | Salida |
|---|---|
| `filter?: string` | Familias disponibles para el servidor, con sus pesos y estilos, y las parejas (`pairings`) del paquete |

Lista lo que el motor realmente resuelve con las fuentes de `--fonts` (por defecto
`Fonts/`), no un nombre de carpeta.

## 6. Lo que V2 debe proveer: el catálogo evaluable

`catalog` necesita datos que hoy no existen como datos. Se reparten entre `_presets`
en `lib.typ`, el descriptor de cada preset (`#let preset = (name:, make:, variants:,
artboard:)`), la lista de elementos que reconoce cada scaffold y `vocabulario.md`.

**Propuesta:** un archivo `src/catalog.typ` que exporte, para el motor,

```typ
#metadata((
  version: "…",
  presets: ( swiss: (variants: (), artboard: auto, elements: (…), options: (…), extra-roles: ()), … ),
  elements: ( tag: (es: "etiqueta", std: false, …), … ),
  artboards: formats,
)) <catalogo>
```

El servidor lo obtiene evaluando ese archivo con el `engine` (equivalente a
`typst query --field value "<catalogo>"`), no leyendo el código.

Hay dos cosas que decidir antes de implementarlo:

1. **Quién lo escribe.** Mantenerlo a mano repite la duplicación que V2 quiere
   evitar. Lo ideal es **derivarlo** de los descriptores (`preset`, `make`) para que
   un preset nuevo aparezca solo. Hoy el descriptor no declara `elements`, `options`
   ni `extra-roles`: salen del código de `make` y del `scaffold`. Hay que decidir si
   el descriptor los declara explícitamente (más datos, un único sitio) o se extraen.
2. **Cruce con Weft.** El esqueleto sintáctico de ese catálogo (nombres, formato por
   defecto, variantes de los presets con `variants: ()`) lo puede dar Weft sin
   compilar. Sirve como **segunda opinión** en las pruebas (§10): ambos deben coincidir.

El catálogo tiene tres consumidores: este servidor, la documentación comprobable
(DEUDA §2.4) y el módulo i18n (la columna `es` de los elementos).

## 7. Errores y diagnósticos

El contrato dice que el único error posible es el de sintaxis (DEUDA §1.4), pero en
la frontera del servidor un nombre desconocido **sí** es un problema, porque quien
escribe es un modelo y una errata no debe pasar en silencio (lo que `frame` ya hace
con los argumentos que no reconoce). Todo se devuelve como `Issue`:

```json
{
  "severity": "error",
  "code": "unknown_option",
  "path": "options.tema",
  "message": "`tema` no es un elemento ni una opción de este preset",
  "suggestion": "theme"
}
```

| `code` | Cuándo |
|---|---|
| `unknown_preset`, `unknown_variant`, `unknown_artboard` | Nombre fuera del catálogo; `suggestion` es el más cercano |
| `unknown_option` | Opción que el preset no acepta |
| `unknown_element` | Elemento que el preset no reconoce (**advertencia**: se dibuja como contenido suelto) |
| `bad_color`, `bad_theme_role` | Color o rol de tema inválido |
| `bad_markup` | Contenido estructurado fuera de `emph`/`strong`/`br` |
| `overflow` | El preset no cabe (`leaves`, `inscription` y otros que heredan de v1 errores geométricos): **error**, con el preset y el límite |
| `contrast_low` | Contraste texto/fondo por debajo de AA (**advertencia**) |
| `compile_error` | Fallo del compilador que no encaja en lo anterior; incluye mensaje y posición |

`render` no devuelve imagen si hay algún `error`; sí si solo hay advertencias.

## 8. Seguridad y límites

- **Sin Typst del cliente.** Es el principio 1; las pruebas de §10 lo comprueban.
- **Raíces permitidas.** Las rutas de entrada (`palette.image`) y de salida se
  resuelven dentro de directorios declarados al arrancar (`--allow <dir>`, repetible).
  Un `..` o un enlace simbólico que salga se rechaza.
- **Sin red.** El `Cargo.toml` del `engine` declara hoy las features
  `universe-packages` y `system-downloader` de `typst-kit`; el servidor debe
  desactivarlas. Un servidor MCP que puede descargar paquetes ejecuta código que el
  usuario no escribió.
- **Tiempo y tamaño.** Un tope de compilación (por defecto 30 s) y un tope de píxeles
  por pieza (por defecto 4000 × 4000). Se devuelve `compile_error` con el
  motivo, no se queda colgado.
- **Solo escritura en `--out`.** Ninguna herramienta modifica archivos fuera de ahí, y
  ninguna borra.
- **Registros** a `stderr`; `stdout` queda reservado al protocolo.

## 9. Lo que no entra (por ahora)

- **Lote** (`build` de un `posts.toml`). Existe en el CLI; no se expone hasta que haya
  un caso: el agente puede llamar `render` por pieza.
- **Consulta de la API del paquete** (`search`, `def`, `outline` de Weft). Si hace
  falta, será una herramienta que use la librería de Weft en proceso, no una copia.
  Requiere que Weft separe un `lib.rs`.
- **Español.** Los nombres son los de V2, en inglés. Cuando exista el módulo i18n
  (DEUDA §5.3), `catalog` puede devolver la columna `es` y la pieza aceptar alias.
- **Recursos y prompts MCP.** Dos candidatos baratos: `instatypst://vocabulary`
  (`spec/vocabulario.md`) y `instatypst://catalog`. No son necesarios para la primera
  versión.

## 10. Cómo se prueba

El servidor es determinista (principio 6), así que se prueba con dorados.

1. **Equivalencia con Typst.** Para cada preset del catálogo, `render(piece)` produce
   los mismos píxeles que `typst compile` del `.typ` que devuelve `typst_source`.
2. **Paridad con V2.** El `.typ` generado para una pieza equivale al de las pruebas de
   V2 (`tests/<preset>.typ`): las páginas coinciden píxel a píxel.
3. **Inyección.** Contenido con `]`, `#`, `\`, `$`, `*`, `_`, `` ` ``, `@`, `<`,
   `//`, `#import`, `#read(…)`, `#sys`, cadenas con comillas y saltos de línea:
   el `.typ` generado compila y **dibuja el texto literal**. Ninguna entrada ejecuta
   código ni lee un archivo.
4. **Catálogo.** `catalog` coincide con el esqueleto que da Weft para los presets de
   descriptor literal; cualquier diferencia es un fallo de uno de los dos.
5. **Errores.** Cada `code` de §7 tiene una pieza que lo provoca y una que no.
6. **Rutas.** `palette.image` con `..`, con un enlace simbólico a `/etc` y con una
   ruta absoluta fuera de las raíces: se rechaza.
7. **Idempotencia.** Dos `render` de la misma pieza devuelven el mismo `path` y el
   mismo hash.

## 11. Dependencias y orden

Lo que bloquea y quién lo hace:

| # | Tarea | Dónde | Bloquea |
|---|---|---|---|
| 1 | `src/catalog.typ` y su decisión de autoría (§6) | este repo | `catalog` |
| 2 | Reescribir el modelo de pieza de `instatypst-piece` sobre `frame` (hoy, firmas por estilo de v1) | `typst-rrss` | todo |
| 3 | Que `bridge` genere `#frame(…)[#elemento[…]]` en lugar de las llamadas posicionales de v1, con el escapado de §4 | `typst-rrss` | `render`, `typst_source` |
| 4 | Apuntar el `engine` al paquete por ruta, y desactivar red (§3, §8) | `typst-rrss` | seguridad |
| 5 | Exponer `query` en el `engine` | `typst-rrss` | `catalog` |
| 6 | Subcomando `instatypst mcp` con `rmcp` y las siete herramientas | `typst-rrss` | — |
| 7 | Pruebas de §10 | `typst-rrss` | publicar |
| 8 | Retirar `mcp/server.py` de este repo | este repo | — |

El 1 se puede hacer ya, con V2 como está. De los demás, los que dependen de lo que
hay en `bridge` y `piece` (2 y 3) son los que más cambian al leer su código: este
spec supone que la separación `piece` / `bridge` / `engine` es la que sugieren los
nombres.

## 12. Preguntas abiertas

- **Subcomando o crate aparte.** `instatypst mcp` mantiene un solo binario;
  `instatypst-mcp` evita que quien solo quiere la CLI arrastre `rmcp`. Con una
  feature de Cargo (`mcp`) se obtienen ambas cosas.
- **Contenido con formato.** ¿Bastan `emph`, `strong` y `br`? Los carteles de v1
  usaban también versalitas y color en una palabra; se decide con casos reales.
- **El catálogo, a mano o derivado** (§6, punto 1).
- **APCA en `contrast`** (§5).
- **Nombres de las herramientas:** en inglés, como el resto de la API, o en español,
  como las del servidor viejo (`compilar`, `renderizar`).
- **`brand` y `accent`** siguen sin decidir como elemento o recurso (DEUDA §3.3); la
  pieza los trata como argumentos de `frame`, que es lo que son hoy.
