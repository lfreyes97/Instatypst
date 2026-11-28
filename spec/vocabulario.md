# Vocabulario de elementos

Fuente única de los nombres de los elementos de texto de Instatypst v2.
`DEUDA.md` §1 resume el contrato; aquí están las definiciones completas, los
nombres anteriores y las razones de lo descartado. Este Markdown es el
documento legible; su comprobación automática (`verificar`) está pendiente
(`DEUDA.md` §2.5).

## Elementos

| Nombre | Español | Qué es | Antes | Notas |
|---|---|---|---|---|
| `tag` | etiqueta | Línea breve, antes del texto, que dice de qué trata la pieza. | `eyebrow` | — |
| `subhead` | subtítulo | Enmarca el texto principal: una pregunta, una bajada. | `question` | — |
| `headline` | titular | Encabezado de un texto que continúa debajo en `prose`. | `title` | — |
| `main` | principal | El texto que la pieza dice. Puede ser una frase, un párrafo o una cita; el nombre no lo decide. | `statement` | — |
| `prose` | prosa | Texto corrido que se lee línea a línea: el desarrollo bajo un `headline`. | `detail` | — |
| `conclusion` | conclusión | Lo que cierra o resuelve el texto principal. | `headline` | — |
| `quote` | cita | Palabra ajena. Es el `quote` de Typst: el preset lo reconoce y lo estiliza. | — | `std` |
| `epigraph` | epígrafe | Cita breve de apertura. | — | — |
| `verse` | verso | Texto en líneas de verso. | — | — |
| `footer` | pie | Información secundaria, al final. | — | — |
| `brand` | marca | Quién emite la pieza. | — | — |
| `numeral` | cifra | Número protagonista (con su total, si lo hay). | — | — |
| `versus` | contraste | Dos términos enfrentados. | — | — |
| `list` | lista | Elementos en serie. Es el `list` de Typst (`- a`): el preset lo reconoce y lo estiliza. | — | `std`, alias `itemize` |
| `date` | fecha | Día y mes de un evento. | — | — |
| `author` | autor | Quién dijo o escribió el texto. | — | grupo `atribucion` |
| `dates` | fechas | Los años de vida o de la obra del autor. | — | grupo `atribucion` |
| `title-role` | cargo o título | Qué es el autor: «pastor», «teólogo»… | — | grupo `atribucion` |
| `work` | obra | De dónde procede el texto. | — | grupo `atribucion` |
| `call` | llamada | La llamada a la acción: lo que se le pide al lector («Inscríbete»). | — | `event`, `bordered-chapter` |
| `next` | siguiente | La invitación a pasar a la pieza siguiente de una serie («Desliza →»). | — | `slide` |
| `hint` | pista | Una ayuda breve para responder una pregunta. | — | `bordered-question` |
| `handle` | usuario | El nombre de cuenta de quien firma en una red («@alguien»). | — | `social-quote` |
| `coda` | coda | Una línea más chica que cierra después del remate. | — | `stairs` |
| `gloss` | glosa | Una nota al margen que comenta el texto. | — | `folio` |
| `note` | nota | Un texto chico, secundario, junto a otro elemento. | — | `leaves` |
| `caption` | rótulo | Una línea breve que identifica la pieza fuera del flujo del texto. | — | `leaves` |
| `pivot` | perno | El concepto central alrededor del cual gira un diagrama. | — | `hinge` |
| `calendar` | calendario | Un mes en retícula de siete columnas, con hoy y las fechas marcadas. No lleva cuerpo: `year`, `month`, `today`, `marks`. Decidido el 27 de noviembre de 2026 al portar WallTypst. | — | `timepiece` |
| `clock` | reloj | La hora y la fecha de un instante, en cifras o en esfera. No lleva cuerpo: `time`, `date`, `style`, `show-time`. Decidido el 27 de noviembre de 2026 al portar WallTypst. | — | `timepiece` |
| `glyph` | glifo | Un carácter protagonista, muy grande, que el preset ancla y recorta; lleva el carácter como cuerpo. Decidido el 27 de noviembre de 2026 al portar WallTypst (`cartel-capas`). | — | `anaglyph` |
| `ruler` | regla | Una escala graduada con una marca destacada (p. ej. el versículo dentro del capítulo). No lleva cuerpo: `total`, `current`. Decidido el 27 de noviembre de 2026 al portar WallTypst (`escala-versiculos`). | — | `inscription` |

`Antes` es el nombre que tenía en `core/v2` antes de migrar; `—` significa que
no era hijo de un preset. Las notas significan:

- `std`: elemento de la librería estándar de Typst. No se define; el preset lo
  reconoce en el cuerpo y lo estiliza con `show`.
- `alias`: otro nombre para lo mismo. `itemize` es alias de `list`.
- `grupo atribucion`: las cuatro piezas del bloque de atribución.

## Quién define cada nombre

Ninguno: un elemento es un nombre sin dueño. Los 17 que no son de la librería
estándar se definen en `src/elements.typ`, y cada preset (o variante) reconoce
los que le sirven. Lo que un preset no reconoce se dibuja como su cuerpo. Los
reconocen hoy:

| Preset | Elementos |
|---|---|
| `plain`, `variant: "post"` | `main`, `epigraph`, `author`, `brand` |
| `swiss` | `tag`, `subhead`, `main`, `conclusion` |
| `inscription` | `epigraph`, `author`, `work`, `brand` |

Todo elemento se define en `src/elements.typ`, también los que hoy usa un solo
preset (la última columna de la tabla dice cuál); así ningún preset exporta
nombres propios desde `lib`. Los nueve últimos (`call`… `pivot`) se decidieron el
26 de noviembre de 2026 para traducir los presets de v1; las razones están en
`spec/decisiones-traduccion.md`.

## Descartadas

| Palabra | Por qué |
|---|---|
| `statement` | En español no dice nada claro: se parece a «declaración» o «enunciado», que suenan a trámite. Era el nombre del texto principal en `core/v2`. |
| `phrase` | Se entiende («frase»), pero en español suena a frase célebre, es decir, a `quote`. |
| `lede` | Casi homófona de `lead`. Es jerga de periodismo anglosajón: el primer párrafo de una noticia. |
| `lead` | Casi homófona de `lede`; misma jerga de prensa. |
| `kicker` | Jerga de prensa; no se entiende al traducir. `tag` cubre ese papel. |
| `eyebrow` | Jerga de prensa; no se entiende al traducir. `tag` cubre ese papel. |
| `label` | Es la función de Typst que crea etiquetas para referencias (`label("x")`) y no es un elemento: no se puede reestilizar con `show`, y un preset que la exportara la taparía. `tag` dice lo mismo («etiqueta») sin tapar nada. |
| `closer` | Evoca un tamaño (la palabra grande de `suizo`, como `\HUGE`) y en otros presets el remate no es grande. Pesó la función, no el tamaño. |
| `title` | Es un encabezado en unos presets y el texto principal en otros: un nombre, dos papeles. |
| `body` | Ya es el rol de fuente principal y el cuerpo de `frame`. Como elemento, el desarrollo se llama `prose`. |
| `display` | Alias de `headline` en `suizo`: retirado. |
| `super` | Es la función de superíndice de Typst. |
| `hyper` | No dice a qué orden de magnitud corresponde. |

## Choques con la librería estándar

Ninguno: `choques-std = ()`. `quote` y `list` no cuentan como choque porque
están marcados `std`: son los originales de Typst. `itemize` es alias de `list`
y tampoco choca.

## Reglas

Cuando exista `verificar` (`DEUDA.md` §2.5), comprobará al compilar:

1. ningún nombre está a la vez escogido y descartado;
2. todo nombre con `antes` lo exporta algún preset migrado;
3. lo marcado `std` existe en Typst, y los alias no chocan con Typst ni con un
   elemento;
4. los choques reales son exactamente los declarados en `choques-std`.

Las dos reglas de cobertura de bloques («todo bloque citado existe y todo
bloque del contrato tiene nombre») desaparecieron junto con
`schema/firmas.json`: ese inventario pertenecía a los presets de v1 y no
describe el contrato de `frame`.
