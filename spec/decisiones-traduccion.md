# Decisiones de traducción de v1

Decididas el 26 de noviembre de 2026. Completan `Instatypst-rework/schema/traduccion.toml`
(generado, no se edita): donde la tabla marca `?`, propone un elemento nuevo o se
equivoca, **manda este documento**. Un agente que traduce un preset lee la tabla y
después esto.

Criterios: los de `DEUDA.md` §1.2 (nombra la función, se entiende sin traducir, un
nombre una cosa, neutro respecto de la voz, no choca con Typst). Y una regla más:
**no crear un nombre si uno existente ya dice lo mismo**.

## Elementos nuevos (están en `src/elements.typ`)

| v1 | Preset | Decisión | Por qué |
|---|---|---|---|
| `llamada` | `evento`, `capitulo-orlado` | `call` | La llamada a la acción; la comparten dos presets. |
| `siguiente` | `lamina` | `next` | «Desliza →»: la invitación a la pieza siguiente. |
| `pista` | `pregunta-orlada` | `hint` | Ayuda breve para responder. |
| `usuario` | `cita-social` | `handle` | El nombre de cuenta («@alguien»). `user` se confundiría con quien escribe la pieza. |
| `coda` | `escalera` | `coda` | Lo mismo en español: la línea que cierra después del clímax. |
| `glosa` | `folio` | `gloss` | La nota al margen. |
| `nota` | `hojas` | `note` | El texto chico junto a la etiqueta. |
| `rotulo` | `hojas` | `caption` | La línea que identifica la pieza (en hojas, vertical, en versalitas). |
| `centro` | `gozne` | `pivot` | El concepto del centro del diagrama radial: el perno del gozne. No es `main` (lo que la pieza dice es su `quote`), y `center` choca con la alineación de Typst. |

## Destinos que la tabla marcaba con `?` o que cambian

| Preset | v1 | Tabla | Decisión | Por qué |
|---|---|---|---|---|
| `demostracion` | `texto` | `tema:text?` | `tema:ink` | Es el color del texto: el rol `ink`. |
| `demostracion` | `claro` | `tema:light` | `tema:light` (rol propio) | Se confirma. |
| `hojas` | `frase` | `elemento:main?` | `elemento:prose` | Es el párrafo que sigue al título: prosa, no el texto principal. |
| `hojas` | `rotulo` | `elemento:caption?` | `elemento:caption` | Se confirma (ver arriba). |
| `hojas` | `nota` | `elemento:note?` | `elemento:note` | Se confirma (ver arriba). |
| `franjas` | `tira` | `preset:strip?` | `tema:strip` (rol propio) | En v1 es un color del tema (la tira del pie), no una opción. |
| `escalera` | `cumbre` | `recurso:summit?` | `preset:summit` | Un punto (dónde convergen las curvas), opción del preset mientras el recurso `curves` no exista. |
| `gozne` | `centro` | `elemento:main?` | `elemento:pivot` | Ver arriba. |
| `gozne` | `rotulos` | `elemento:tag?` | `preset:positions` | En v1 es un array de posiciones `(x:, y:, lado:)` por hoja: maquetación, no contenido. Las claves pasan a `(x:, y:, side:)`. |
| `esquela` | `luto` | `tema:mourning?` | `tema:ink` | En v1, `luto` es la tinta («`luto` (tinta)»). |
| `esquela` | `sepia` | `tema:sepia` | `tema:quiet` | En v1, `sepia` es el suave («`sepia` (suave)»). La tabla se equivocaba. |
| `folio` | `glosa` | `elemento:gloss` | `elemento:gloss` | Se confirma. |
| `folio` | `referencia` | `elemento:reference` | `elemento:work` | «Salmo 51» dice de dónde procede el texto: es `work`. No hace falta un nombre nuevo. |
| `plano` | `maestra` | `preset:master-grid?` | `preset:major-every` | Cada cuántas celdas va la línea maestra (un número). |
| `cita-orlada`, `capitulo-orlado`, `pregunta-orlada` | `cadena` | `recurso:chain?` | `preset:chain` | El nombre de un marco de `fleurones.cadenas`, opción del preset mientras el recurso `border` no exista. |
| `contraste` | `afirma`, `niega` | `elemento:affirms?`, `elemento:denies?` | `tema:affirm`, `tema:deny` (roles propios) | En v1 son los colores de cada panel (`tm.afirma`, `tm.niega`), no contenido. Los roles de cada ítem (`rol: "afirma"`…) siguen en la lista. |
| `contraste` | `cuerpo-titular` | `propiedad:headline.size?` | `propiedad:headline.size` | Se confirma: el patrón `cuerpo-X` → `X.size` de `DEUDA.md` §1.6. |

## Reglas que salieron de traducir (tandas 1 y 2)

- **`cuerpo`, `peso`, `fuente-texto` → el elemento que lleva el texto principal.** La
  tabla los manda a `main.size`, `main.weight`, `main.font`; si el preset no tiene
  `main`, van al elemento que cumple ese papel (`prose` en `folio`, `obituary` y
  `leaves`; `headline` para el peso del título en `leaves`).
- **`fuente` en las orlas es `work`**, no `preset:fonts`: en v1 era un alias de `obra`
  (la tabla se equivocaba).
- **`fonts.smallcaps`** (`esquela`, `folio`: v1 `fuente-sc`) es un rol de fuente que
  `modules/typography` todavía no declara; funciona porque esos presets no fijan
  pareja. Hay que agregarlo al módulo.
- **El atajo `papel:` de `esquela`** no tiene equivalente exacto: en v1 cambiaba el
  papel sin mover el viñeteado; en V2 `paper` es un rol del tema y el viñeteado lo
  sigue. La referencia de v1 del caso 4 usa `tema: (fondo: …)`, que en v1 da lo
  mismo que V2 (lo anotaba la referencia de v1 de ese caso, que no se trajo).

## Reglas de la tanda 3

- **La fecha de `evento`** (`dia`, `mes`) va entera en el cuerpo de `date` y se parte
  por el salto de línea: `#date[14 \ nov]` (arriba el día, abajo el mes). Es el mismo
  criterio que la glosa de dos líneas de `folio`; no hace falta una propiedad `month`.
- **`contexto` de `cita-social`** va a `tag`: la tabla decía `preset:context`, pero
  `context` es una palabra reservada de Typst.
- **Formatos por defecto declarados** (como en v1): `bands`, `proof` y las tres orlas,
  cuadrado; `stairs`, story; `hinge`, twitter (1600×900).
- **`tip`, `plain`**: sin acento propio, `accent: none` (no se inventa un valor).

## Lo que sigue sin decidir

- **`lamina`**: el nombre del preset (`slide` o `series`) y `repeat` (`DEUDA.md` §2.1). No se traduce todavía.
- **Los recursos** (`texture`, `border`, `curves`, `veil`, `shadow`…): sin tabla de
  nombres ni implementación. Mientras tanto, cada preset dibuja lo que v1 dibujaba
  por defecto, por dentro, y lo anota como pendiente (como `bauhaus` con su textura).
