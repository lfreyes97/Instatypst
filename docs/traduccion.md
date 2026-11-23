# Tabla de traducción: engine_v1 → contrato semántico

Fuente de los nombres semánticos: lo que mapeaba el contrato en `core/scaffold.typ` y en el prototipo `frame.typ` (ya podado; hoy solo `suizo` está cerrado en el scaffold, así que las columnas «solo frame» de `liso` y `lamina` son historial). «—» = sin mapeo. Los números de línea los extrajo un agente de lectura y se contrastaron solo en parte; revisar antes de citarlos.

Regla: los nombres se deciden al traducir. Cada preset que cierra el `scaffold` completa su parte.

## Un mismo concepto, varios nombres en v1

| Semántico | suizo | liso | lamina |
|---|---|---|---|
| `background` | `papel` | `fondo` | `fondo` |
| `padding` | `margen` (de la retícula; `padding` de frame no lo toca) | `margen` | `margen` |
| cuerpo principal | `frase` (hijo `statement`) | `texto` (cuerpo sin etiquetar) | `titulo` (hijo `title`) |

## `suizo` (`src/carteles.typ:179`)

| v1 | defecto | semántico | estado |
|---|---|---|---|
| `frase` (pos.) | — | `statement` | mapeado |
| `remate` (pos.) | — | `headline` (alias `display`) | mapeado |
| `formato` | `(1080, 1350)` | `format` | mapeado |
| `autor` | `none` | `author` | mapeado |
| `fechas` | `none` | `dates` | mapeado |
| `etiqueta` | `none` | `eyebrow` | mapeado |
| `planteo` | `none` | `question` | mapeado |
| `marca` | `none` | `brand` | mapeado |
| `tema` | `"suizo"` | `theme` | mapeado |
| `acento` | `auto` | `accent` | mapeado |
| `papel` | `auto` | `background` | solo frame; scaffold no lo pasa |
| `columnas` | `6` | `columns` | solo frame; scaffold no lo pasa |
| `tinta`, `gris`, `linea` | `auto` | — | sin mapeo |
| `fuente`, `fuente-rotulos`, `fuente-remate` | Hanken Grotesk / Inter / Bebas Neue | — | sin mapeo |
| `cuerpo-frase`, `margen`, `medianil`, `aire` | 66pt / 64pt / 24pt / 150pt | — | sin mapeo |
| `flecha`, `frase-y`, `flecha-hasta` | `true` / `auto` / `auto` | — | sin mapeo |

## `liso` (`src/carteles.typ:333`)

| v1 | defecto | semántico | estado |
|---|---|---|---|
| `texto` (pos.) | — | cuerpo sin etiquetar | mapeado |
| `formato` | `(1080, 1350)` | `format` | mapeado |
| `marca` | `none` | `brand` | mapeado |
| `fondo` | `#141414` | `background` | mapeado |
| `margen` | `96pt` | `padding` | solo frame |
| `autor` | `none` | `author` | existe en el contrato; scaffold no lo cablea y frame no lo usa en `free` |
| `tinta`, `fuente`, `peso`, `cuerpo`, `cuerpo-max`, `alinear` | — | — | sin mapeo |
| `desgaste`, `epigrafe`, `epigrafe-fuente`, `cuerpo-epigrafe` | — | — | sin mapeo |

`liso` no tiene parámetro `tema`: que `theme` no le llegue no es un fallo.

## `lamina` (`src/lamina.typ:33`; se importa como `carteles.lamina` o `#import "../src/lamina.typ": lamina`)

| v1 | defecto | semántico | estado |
|---|---|---|---|
| `numero` (pos.) | — | `index` | mapeado |
| `total` (pos.) | — | `total` | mapeado |
| `titulo` (pos.) | — | `title` | mapeado |
| `texto` | `none` | `detail` | mapeado |
| `marca` | `none` | `brand` | mapeado |
| `siguiente` | `[Desliza →]` | `next` | mapeado |
| `formato` | `(1080, 1350)` | `format` | mapeado |
| `tema`, `fondo`, `acento` | `"lamina"` / `auto` / `auto` | `theme`, `background`, `accent` | solo frame; scaffold no los reenvía |
| `margen` | `88pt` | `padding` | solo frame, con defecto 96pt |
| `tinta`, `suave` | `auto` | — | sin mapeo |
| `fuente`, `fuente-rotulos`, `cuerpo-titulo`, `cuerpo-texto` | Literata / Jost / 124pt / 46pt | — | sin mapeo |

## Inconsistencias abiertas

- `scaffold` acepta `padding`, `columns`, `rows`, `debug` y los pasa a v1, que los rechaza; `frame` descarta `..args` sin avisar.
- En `series`, `scaffold` ignora `background`, `accent` y `theme`; `frame` los usa.
- Sin hijo `statement`, `scaffold` usa el cuerpo suelto y `frame` no dibuja el enunciado.
- `frame.typ` no llama a `suizo` ni a `lamina`: redibuja con valores fijos, así que `margen`, `medianil`, `aire`, `flecha` y las fuentes de `suizo` no tienen equivalente.

## Sin resolver

Qué hacer con los parámetros sin mapeo (29 entre las tres funciones): nombre semántico para cada uno, o contratos por preset. Ver la discusión sobre contratos por preset y por pieza.
