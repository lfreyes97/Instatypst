# core/v2 — pendiente y acuerdos por cerrar

Laboratorio hacia v2 del motor. No sustituye a `src/` ni cambia ninguna API pública.
Anotado el 21 nov 2026, tras el commit `1811568`.

## Estado

- `frame` (`frame.typ`): una lámina. Argumentos comunes `type`, `format`, `theme`, `accent`, `brand`, `repeat`; el resto (`..options`) va al tipo, que rechaza lo que no conoce.
- Tipos que existen: `"swiss"` (`swiss.typ`) y `"series"` (`series.typ`). Cada tipo trae sus hijos y su adaptador `make`. `parts.typ` es la lectura de hijos compartida.
- `type` también acepta una **función propia** `type(body, format:, theme:, accent:, brand:, ..opciones)`; se probó con `anatemas-b` de `Post/`.
- `repeat`: entero o array; con `repeat` el cuerpo es una función `item => contenido` y `frame` pone `index` y `total`.
- Verificado con `just cmp suizo` y `just cmp lamina`: PNG idéntico byte a byte al de `src/` (6 láminas cada uno). Además, fuera del repo, 5 casos nuevos de `suizo` y 6 de `lamina`, todos idénticos.

## Mañana: probar v2 con otro par de presets

Por elegir. Candidatos:
- `liso` (16 parámetros, trae el bloque `epigraph`): el más simple, sirve para ver cuánto núcleo común aparece entre presets.
- uno de los que usa `Post/`: `hoja`/`hojas`, `lienzo-orlado`, `linea-tiempo`, `escalera` o `epigrafe`. Ninguno de los carruseles de `Post/` usa `suizo`, `liso` ni `lamina` de Instatypst.

Método (el que funcionó con `suizo`): casos de prueba en `examples/recetas/<preset>/`, motor en `core/v2/`, `just cmp <preset>`, y después una batería de casos que el demo no ejerce (con `suizo` destapó una regla oculta: etiqueta y pregunta son un solo bloque). La batería vive en `../Instatypst-reveng/pila/` (fuera del repo); `just pila repo:core/v2/frame.typ`.

## Falta acordar (semántica)

1. **`display: format`.** No está claro qué es. `format` ya es el tamaño del lienzo, y `display` ya es alias de `headline` en `swiss`.
2. **`preset` y `type`.** Hoy `type` nombra la familia de diseño. ¿`type` pasa a `preset` y `type` queda para variantes (`fullgrid`)? Añadir `type` como variante es aditivo; lo que rompería es renombrar el argumento que hoy se llama `type`. ¿La función propia va en `preset` o en `type`?
3. **Estructura `presets/`.** Idea: `presets/<nombre>.typ` con el contrato de cada preset, y `frame` lo encuentra por nombre con importación dinámica (probado: la ruta calculada funciona, un directorio no). Regla: nombre del archivo = nombre del tipo, único. Despachar es trivial con cualquier número de presets; enumerarlos (docs, MCP) necesita una lista, porque Typst no lista directorios. Costes: se pierde el mensaje de error propio para un tipo desconocido (no se puede capturar un import fallido, no probado), y los hijos de dos presets pueden chocar (se evita con `#import "presets/x.typ" as x`).
4. **`repeat`.** ¿Cuerpo como función o datos? Y el total en documentos con portada distinta (`anatemas-b`: portada + 4, numeradas sobre 5): `repeat` cuenta solo lo suyo; haría falta el contador de páginas. No probado.
5. **Parámetros sin nombre semántico.** `suizo` tiene 15 de 25 y `lamina` 12 de 17 sin nombre (fuentes, tamaños, márgenes, colores sueltos). ¿Nombre para cada uno, contrato propio por preset, o un argumento de escape?
6. **Modelo Beamer.** ¿El mismo contenido debe poder re-vestirse con otro preset, como cambiar `\usetheme`? Si sí, hace falta un vocabulario común (o adaptadores por preset hacia `piece/v1`); si no, los contratos son por preset, como ahora.
7. **Reglas de lectura de hijos** (en `parts.typ`): anidados se aplanan, gana el último repetido, el contenido suelto cae en el hijo principal. Confirmar que valen para todos los tipos.
8. **Nix.** Camino elegido: declarar el contrato de cada preset en Nix y generar de ahí el JSON, la tabla de traducción, el scaffold y la validación. Nix no está instalado en esta máquina (Arch); el `flake.nix` actual solo define un `devShell` de fuentes.

## Recordatorio: Typst tiene tipos

Los contratos deben tratarse como firmas tipadas (`int`, `str`, `length`, `color`, `content`, `array`, `dictionary`, `function`, `auto`/`none`), como se piensa en Rust. Matiz que no hay que olvidar: Typst es de tipado **dinámico**; los tipos se comprueban al evaluar, no al compilar, así que cada contrato tiene que validarse a mano con `assert`/`panic` (como hace `series` con `index` y `total`).

Detalles que ya nos tocaron:
- El argumento `type` tapa a la función `type()`: dentro de `frame` hay que usar `std.type`.
- `auto` y `none` son valores distintos y de tipos distintos: `theme: auto` (el del tipo) no es lo mismo que `brand: none` (sin marca).
- `int` y `float` no se mezclan en `range`/`calc` sin cuidado; `repeat` acepta `int` o `array` y valida cuál recibió.
- Un `length` (`12pt`) no es un número: los parámetros de medida llevan unidad.

## Fuera del commit (siguen en disco, sin seguir)

`core/scaffold.typ`, `core/primitivas.typ`, `core/recetas/`, `core/nombres.toml`, `scripts/tabla-traduccion.py`, `docs/frame.md`, `docs/traduccion*.md`, los demos de port y scaffold de `suizo`, y `examples/primitivas-uso.typ`. Son andamios o documentos del diseño anterior; algunos se volverán provisionales cuando exista el camino de Nix.
