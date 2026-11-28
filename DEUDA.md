# Instatypst v2: contrato, deuda y migración

Estado al 27 de noviembre de 2026, rama `feat-v2`. Este documento reúne tres cosas
que en V2 estaban separadas: el **contrato** (lo que era `Spec.MD`, §1), lo que
**falta** para igualar a v1 (§2) y la **deuda técnica** (§3), más lo que queda
abierto (§4), el estado de la **migración** (§5) y la fase WallTypst (§6). Los
nombres de los elementos viven en `spec/vocabulario.md`; las decisiones de
traducción, en `spec/decisiones-traduccion.md`; la receta para traducir un preset,
en `spec/protocolo-traduccion.md`. Lo que aquí se decide se mueve a §1; lo que se
resuelve se borra de aquí.

**Dónde estamos.** Todo el `src/` de V2 ya está en esta rama: `frame`, `elements`,
`core`, `plain`, `modules` (`validate`, `color`, `typography`, `superbg`,
`fleurones`, `theme-v1`), `resources` y los **22 presets traducidos** de los 23 de v1
(falta `lamina`): `plain` (`post` = `liso`), `swiss`, `inscription`, `bauhaus`,
`blueprint`, `bands`, `proof`, `mosaic`, `tiles`, `leaves`, `obituary`, `folio`,
`bordered-quote`, `bordered-chapter`, `bordered-question`, `timeline`, `event`,
`contrast`, `tip`, `hinge`, `stairs` y `social-quote`. Las 68 pruebas de V2 dan 229
páginas idénticas, píxel a píxel, a las de V2. v1 sigue entero en `main` y en la
etiqueta `v1-final` (`fdc248b`). El `src/` de v1 que esta rama aún conserva es lo
que falta traducir, o lo que ya está traducido y se puede borrar (§2.2).

---

## 1. El contrato

El contrato describe **una capa semántica**: nombres, contrato de `frame` y
elementos, encima de un motor. Del motor importa solo lo que aporta semántica
(los roles de color y de texto sí; la geometría —arcos, huecos, colocación— no).

### 1.1 Ontología

| Categoría | Definición | Ejemplos |
|---|---|---|
| **Contenido** | Lo que el usuario escribe. Dentro de un papel se escribe con el nombre del papel (`#brand[Brand]`, no `#text(rol: brand)[Brand]`). El contenido libre (cualquier cosa suelta) no es un elemento y no necesita nombre. | el texto de `main`, `tag`, `prose`, `brand` |
| **Elemento** | Un papel con nombre dentro de un preset. Requiere un cuerpo: el contenido que se le da. Puede ser dinámico y relacional al lienzo. Sus propiedades (`size`, `font`, `fill`, `tracking`, `y`…) se configuran con argumentos. | `brand`, `main`, `tag`, `prose`, `conclusion`, `footer`, `glyph` |
| **Recurso** | Algo configurable que el preset o el elemento **consume**. No lleva cuerpo propio ni contenido del usuario, aunque se escriba como llamada. | ornamento, flecha, la grilla del suizo, `dropcap`, paleta, fuente, `dot` |
| **Preset** | Un **superelemento**: una configuración de elementos y recursos con contenido variable, con definiciones relativas a sí mismo y a algunos de sus elementos. Puede ir dentro del cuerpo de otro preset. | `swiss`, `plain`, `poster` |
| **Frame** | El lienzo: recibe el contenido, define el borde al que se anclan y recortan los elementos, e instancia el preset. Es la única puerta de entrada pública. No es un contenedor neutro. | `#frame[...]` |

Un frame vacío es una página en blanco del tamaño del artboard. La frontera entre
elemento y recurso es semántica (¿lleva cuerpo y participa en la composición, o lo
consume el preset sin llevar nada del usuario?), no sintáctica.

**Un nombre describe un papel en un preset.** No hay una semántica universal:
`conclusion` es, en `swiss`, una palabra que llena el ancho; en otro preset no lo
es. Que dos presets compartan un nombre es una convención, no un contrato de
apariencia.

### 1.2 Criterios para escoger un nombre

1. **Nombra la función**, no la forma ni el tamaño.
2. **Se entiende sin traducir.** El diseño se piensa en español: si el nombre en
   inglés no evoca nada claro en español, no sirve.
3. **Un nombre, una cosa.** No puede significar dos papeles distintos.
4. **Neutro respecto de la voz.** El texto principal vale para una frase propia, un
   párrafo o una cita.
5. **No choca con nada que ya existe**, empezando por la librería estándar de Typst;
   lo comprueba el compilador.
6. **No se crea un nombre si uno existente ya dice lo mismo.**

### 1.3 Vocabulario

`spec/vocabulario.md` es la fuente única: 30 elementos definidos (más `quote` y
`list`, de Typst), los 13 nombres descartados y las razones. `quote` y `list` son los de la librería
estándar (`std`): no se definen, el preset los reconoce en el cuerpo y los estiliza
con `show`; `itemize` es alias de `list`. La atribución se aplana en cuatro
elementos sueltos (`author`, `dates`, `title-role`, `work`). `colophon` es el nombre
de un rol tipográfico, no un elemento: el elemento es `footer`. Todos se definen en
`src/elements.typ`, aunque hoy los use un solo preset.

### 1.4 Reglas

- **Nada es obligatorio.** Un preset se dibuja con el cuerpo vacío.
- **El único error posible es el de sintaxis.** No hay validación de presencia ni de
  nombres de elementos: lo que un preset no reconoce se trata como contenido suelto.
- **Si un elemento se repite, gana el último.**
- **Un elemento también se pasa como argumento.** `#frame(preset: "swiss", author:
  [X])[…]` es azúcar de `#author[X]` en el cuerpo, para cualquier elemento que el
  preset reconozca. Si está en los dos lados, gana el del cuerpo. Un argumento que
  no es un elemento del preset ni una de sus opciones es un error («`autor` no es un
  elemento ni una opción de este preset»): así una errata no pasa en silencio.
- **El contenido suelto** se dibuja como contenido libre; a qué ranura va dentro de
  un preset es decisión del preset.
- **`read-parts` no entra en `list`, `enum` ni `terms`:** un preset recibe cada lista
  entera.

### 1.5 Casos de la sintaxis

1. **Forma explícita.** `#frame(preset: mosaic, variant: "u", artboard: "story")[
   #main[…] ]`. `frame` resuelve `preset`, `variant`, `artboard`, `theme`, `accent`,
   `brand` y `..options`. La firma es **una sola**: los presets no declaran otra.
2. **Azúcar definicional.** `#let mosaic = frame.with(preset: mosaic-fn)`. Es
   exactamente la forma anterior; las dos dan la misma página, píxel a píxel. El
   azúcar siempre se reduce a la forma explícita: ningún preset tiene un dialecto
   propio. **Un preset no se llama como un elemento** (si compartieran nombre, el
   azúcar taparía al elemento): por eso el preset de epígrafes se llama
   `inscription` y `epigraph` es el elemento.
3. **`variant: auto`** equivale a no pasar `variant`. Solo los presets que declaran
   variantes aceptan un valor concreto; `frame` rechaza el resto con un mensaje
   claro.
4. **`auto` y el cuerpo vacío.** `preset: auto` es `plain`; `artboard: auto` resuelve
   al formato que declara el preset (`bands`, `proof` y las orlas son cuadrados,
   `stairs` es story, `hinge` es twitter) o, si no declara ninguno, a `retrato`.
   Cuando no hay `conclusion`, el bloque grande se omite y el texto baja hasta la
   base. `plain` es un lienzo y su color: sin tema es blanco y negro, sin acento ni
   fuente propia, y en él un elemento no reconocido se dibuja como su cuerpo
   (`#main[Hola]` ≡ `#text[Hola]`). Sirve para dos cosas: es el **scaffold** de los
   demás presets y es **lo simple**, donde quien escribe compone a mano.
5. **Contenido, elementos y recursos.** `#tag(fill: "ink", tracking: 0em)[…]`,
   `#prose(step: 1.7)[…]`, `#dot(size: 56)`. Lo que distingue a un elemento es que
   lleva el cuerpo del usuario.
6. **Elemento dinámico relacional.** `#hero-glyph("S", size: 126%, from: right +
   bottom, crop: (x: 0.39, y: 0.13))`: la letra se recorta donde termina el papel.
   *Pendiente* (§2.4).
7. **Preset por `show` y colocación.** `#show: poster.with(artboard: …, theme: …,
   fonts: …)` más `#put(line: 2.8)[…]` sobre la grilla del preset. *Pendiente*
   (§2.4).
8. **Elementos de la librería estándar.** `#quote[…]` y `- item` estilizados por el
   preset con `show`. *Pendiente* de cobertura (§2.4).

Los casos 1 a 4 están implementados y probados. El 5 está implementado salvo los
recursos.

### 1.6 Tamaño y propiedades de los elementos

El tamaño no forma parte del nombre de un elemento: es un valor.

```typ
#conclusion(size: 66)[PUREZA.]     // 66 u
#conclusion(size: 40pt)[PUREZA.]   // 40 pt, absoluto
#conclusion(size: auto)[PUREZA.]   // lo que el preset define
#conclusion[PUREZA.]               // igual que el anterior
```

- **`auto` significa lo que el preset define.** Puede ser un número o una regla (en
  `swiss`, el remate se ajusta al ancho útil y su mayúscula no pasa del 55 % del
  hueco entre el techo y la base).
- **Los nombres de escalón** (`tiny`, `small`, `large`, `huge`, `giga`…) son azúcar:
  cada preset, o quien escribe, los define. *Pendiente* (§2.4).
- **Las propiedades pertenecen al elemento, no al preset.** Lo que en v1 eran
  `cuerpo-X`, `fuente-X` y `X-y` pasa a `size:`, `font:` e `y:` del elemento `X`.
- **La unidad `u`** es el lado corto del artboard entre 1080. Typst no permite
  unidades propias: **un número es una cantidad en u** (`margin: 96`, `size: 66`) y
  **una longitud es absoluta** (`96pt`).

### 1.7 Tema y color

- **`theme` es solo colores**, con cinco roles: `paper`, `ink`, `quiet`, `accent`,
  `guide` (en v1: `fondo`, `tinta`, `suave`, `acento`, `linea`).
- Un color acepta un valor de Typst, un nombre de rol o una referencia al catálogo
  de paletas con la forma `prefijo-familia-paso[-variante]`: `tw4-amber-400`,
  `rx-tomato-9-dark`, `oc-grape-5` (`tw4` Tailwind v4, `rx` Radix, `oc` Open Color).
- Un tema parcial se completa con el tema del preset. `quiet` y `guide` se derivan
  de `paper` e `ink` solo si nadie los da, ni el usuario ni el preset.
- **Un tema entero sale de una semilla** con el constructor de rampas
  (`ramp-theme(seed)`): papel = paso 50, tinta = 950, apagado = 600, guía = 200,
  acento = la semilla. El reparto de pasos es una convención. *Pendiente* (§2.4).
- **Roles extra.** Un preset puede declarar roles propios además de los cinco
  (`extra-roles: ("yellow", "blue")` en el scaffold, con su valor en el tema por
  defecto). Pasan por `modules/color` como los cinco: `theme:` los cambia y aceptan
  colores, claves del registro y referencias al catálogo. No se derivan de nada, y
  otro preset los rechaza. Primer uso: `bauhaus`.

### 1.8 Presets y sus nombres

La firma de v1 de cada preset se traduce a la sintaxis nueva: cada opción tiene un
destino (un elemento del cuerpo, una propiedad de un elemento, un color del tema, un
argumento del preset o de `frame`, un recurso, o el contenido libre). Los
posicionales desaparecen y pasan a ser elementos.

| v1 | Nuevo | v1 | Nuevo |
|---|---|---|---|
| `suizo` | `swiss` | `esquela` | `obituary` |
| `liso` | `plain`, `variant: "post"` | `folio` | `folio` |
| `mosaico` | `mosaic` | `plano` | `blueprint` |
| `bauhaus` | `bauhaus` | `cita-orlada` | `bordered-quote` |
| `teselas` | `tiles` | `capitulo-orlado` | `bordered-chapter` |
| `hojas` | `leaves` | `pregunta-orlada` | `bordered-question` |
| `franjas` | `bands` | `contraste` | `contrast` |
| `epigrafe` | `inscription` | `evento` | `event` |
| `cita-social` | `social-quote` | `consejo` | `tip` |
| `escalera` | `stairs` | `demostracion` | `proof` |
| `gozne` | `hinge` | `lamina` | `series` o `slide` (§2.1) |
| `linea-tiempo` | `timeline` | | |

`plain`, `variant: "post"` es el `liso` de v1: el post rápido para redes, con
valores por defecto neutros. Sus opciones de v1 pasan a: `texto` → contenido suelto
o `#main`; `cuerpo`, `peso`, `cuerpo-max`, `alinear` → `size`, `weight`, `max-size`,
`align` de `main` (`size: auto` es el ajuste); `autor` → `#author`; `marca` →
`#brand` o `brand:`; `epigrafe*` → `#epigraph(source:, size:)`; `fondo`, `tinta` →
`paper`, `ink`; `fuente` → `fonts:`; `margen` → `margin:`; `desgaste` → un recurso
(`wear`), sin reconstruir. El bloque (texto y autor) va en el centro óptico del
hueco que dejan márgenes, epígrafe y marca: el aire de arriba es 2/3 del de abajo.

### 1.9 Decisiones de proceso que siguen vigentes

- **Todo preset es `plain` más reglas.** Para quien escribe, los presets son planos
  que se eligen por nombre en `frame`; por debajo, `plain` es la base y un preset o
  variante añade un conjunto de reglas y consume recursos. Un preset importa `plain`,
  el núcleo y los recursos, **nunca otro preset**. Los elementos no tienen dueño:
  viven en `src/elements.typ`. `frame` (`src/frame.typ`) es genérico y no conoce
  ningún preset; cada preset exporta su frame en una línea. Solo `lib` conoce todos
  los presets (ahí está la tabla de nombres) y nadie importa `lib`.
- **El scaffold** (`src/plain/scaffold.typ`) es `plain` más la configuración
  resuelta: mide el artboard, resuelve el tema (`modules/color`) y las fuentes
  (`modules/typography`), lee los elementos que el preset reconoce y la marca, y lo
  entrega todo en un contexto a las reglas del preset (`rules: ctx => …`). Trae el
  autoajuste común (`fit-down`, `fit-width`).
- **La estructura de `src/`.** `modules/` guarda subsistemas autónomos que no
  importan nada fuera de su carpeta salvo otro módulo declarado; `core/` es `parts`,
  `artboard` y `pliego`; `resources/` es lo que consumen los presets; `plain/` es la
  base con `variants/`; `presets/<nombre>/` es cada preset con sus `variants/`.
- **Escala: `k` durante el rework.** Los presets traducidos de v1 conservan su escala
  interna, `k = mín(ancho/1080, alto/1350)`, para lograr la paridad. Pasarlas a `u`
  es ajuste fino posterior: en retrato `k = u`; en cuadrado y apaisado cambia el
  dibujo. Los números de la API son `u` desde ya.
- **`artboard: auto`** es el formato del preset, o retrato.
- **Método.** Todo cambio se compara con una línea base, página a página y píxel a
  píxel (primero se comprueba que el render es determinista); lo no decidido se
  marca, no se inventa.
- **APCA** está dentro (`src/modules/color/palettes/color-math.typ`, licencia en
  `LICENSE-apca`). Decisión del autor: se queda; hay una política mínima de
  cumplimiento y falta poco para cumplirla. Se le dedicarán unos turnos (§3.4).

---

## 2. Lo que falta

### 2.1 Presets: falta 1 de 23

- **`lamina`** → `series` o `slide` (sin decidir), con el elemento `next` y la
  decisión sobre `repeat`: esta spec lo resolvía en `frame`; un borrador anterior
  decía que era responsabilidad de los presets numerados (`series`), que declaran
  `index` y `total`. **El código de `lamina` de v1 no está en `main`**: vive solo en
  el commit `09e5fff` (rama `laboratorios`). Ver §5.5.
- **`proof` va a rediseño** (§3.1).
- **Casos de v1 que quedaron fuera o retocados**: `blueprint` (dos casos sin apagar
  recursos), `obituary` (el atajo `papel:`), `contrast` (el ítem «neutro» y el
  medallón `→`).

### 2.2 El `src/` de v1 que sigue aquí

No compila: importa archivos que ya no están. Se divide en dos grupos.

**Ya traducido a V2 (borrable; v1 vive en `main`):** `carteles.typ` y `carteles/`
(los presets de v1 y sus piezas `_arcos`, `_base`, `_huecos`, `_temas`, `_texto`,
`_cita-social-*`, `_epigrafes-*`, `_hojas-piezas`), `escalera`, `esquela`, `folio`,
`gozne`, `linea-tiempo`, `orlas` y `plano`. Según `weft callers`, **una sola
excepción:** `carteles/_temas.typ` lo importa `mesa/` (pendiente), así que se queda
hasta resolver `mesa`. Los demás solo los importan `examples-v1/` (que ya incluye `trabajos/`), que
son de v1 y se migran aparte (§5.2). Ningún archivo de V2 importa nada de v1.

**Pendiente de traducir** (clasificado con la ontología de §1.1):

| v1 | Qué es | Destino |
|---|---|---|
| `formas` (`bocadillo`), `curvas`, `blockquotes` (`bq-frame`, `bq-mark`, `bq-rule`) | recursos: geometrías y adornos | `resources/` (o `modules/` si son autónomos, como `curvas`) |
| `scripture` | elemento + recurso: la cita lleva cuerpo; la referencia (`vs`, `ch`, `pasaje`) no | por partir |
| `social.typ` (`quote-post`, `tip-card`, `event-post`, `stat-card`, `poll-story`, `versus-post`…) | presets | `presets/`; varios se solapan con los ya traducidos (`tip-card`/`tip`, `event-post`/`event`, `versus-post`/`contrast`) y hay que fundirlos |
| `carrusel` | preset o `series` | la misma discusión que `lamina` y `repeat` |
| `articulo`, `mesa` | ni preset ni recurso: plantillas de documento | fuera del contrato de `frame`, por decidir |
| `idiomas` | capa de texto en latín, griego y hebreo (`lat`, `gr`, `he`, `translit`, `interlineal`, `orn`) | módulo autónomo; depende solo de `typography`. **No es** el módulo i18n (§5.3) |

Solo en el commit `09e5fff` (no en `main`): `lamina`, `marca`, `estilo`, `consejo`,
`evento`, `contraste` y `carteles/firmas.typ`. `marca` es un recurso, atado a la
decisión sobre `brand` (§4).

### 2.3 La API pública que `lib` no exporta

`capitular`, `capitular-ornamentada`, `fleurones.orla`/`.guarda`/`.vineta`,
`superbg`, `palettes` y `pairings` existen en V2 como módulos o recursos, pero
`src/lib.typ` no los exporta. Los proyectos que usan el paquete los necesitan
(§5.2: `fleurones` 43 usos, `capitular` 14, `superbg` 13).

### 2.4 Lo que el contrato describe y no existe

- **Recursos** (§1.1): ninguno existe todavía. Cada preset dibuja lo que v1 dibujaba
  por defecto, por dentro, y lo que v1 permitía apagar o cambiar queda pendiente:
  `wear` (`plain` "post"), `texture` (`bauhaus`, `obituary`, `folio`, `timeline`),
  `grid` (`proof`), `image` y `veil` (`bands`), `dimension`, `marks` y
  `title-block` (`blueprint`), `border`, `symbol`, `vignette` y `footer-vignette`
  (`obituary`), `parchment`, `rubric` y `dropcap` (`folio`), `border` y `chain` (las
  orlas), `curves`, `rings` y `decoration` (`stairs`), `diagram` (`hinge`), `shadow`
  (`tip`), `medallion` (`contrast`), `initials`, `photo` y `quote-mark`
  (`social-quote`). Hace falta su tabla de nombres.
- **Caso 6:** `hero-glyph` (elemento relacional al lienzo). El elemento `glyph` ya
  existe (§6); falta el relacional.
- **Caso 7:** preset por `show` (`#show: poster.with(…)`) y `#put` sobre la grilla.
- **Caso 8:** `quote` y `list` de la librería estándar, estilizados con `show`.
- **§1.6:** los escalones de tamaño (`tiny`, `small`… `giga`) como azúcar.
- **§1.7:** `ramp-theme(seed)`. El constructor de rampas está en `modules/color`, pero
  nada lo expone con ese nombre.
- **Roles extra de los temas:** el mecanismo está; falta nombrar en inglés los de
  cada preset que se migre (21 de los 28 temas de v1 los traen, con 15 roles
  distintos: `hondo`, `claro`, `tarjeta`…).
- **`fonts`:** el scaffold resuelve las fuentes con `modules/typography`, pero casi
  ningún preset trae una pareja: usan tokens sueltos (Jost, Literata, IM Fell…).
  Falta el rol `smallcaps`, que usan `obituary` y `folio`. `label` sigue siendo el
  nombre del rol de fuente de los rótulos aunque el elemento sea `tag`.

### 2.5 Verificación

En esta rama hay siete pruebas: las de `tests/modules/` (`importa`, `derivadores`,
`verificadores`, `superbg-color`, `superbg-tamano`) y `core-parts` y `vocabulario`.

- **No se trajeron** las 53 pruebas de los presets de V2 (`tests/<preset>.typ`,
  `azucar-*`, `inscription/`), ni el harness que las ejecutaba. Hasta que se traigan,
  los presets se comprueban a mano contra V2 (hash de cada página, tras comprobar que
  el render es determinista). Lo hecho: 68 pruebas, 229 páginas, todas idénticas.
- **La referencia de paridad de v1** (`@local/instatypst-ref`, commit `09e5fff`) ya no
  es útil como código: cumplió su función al igualar los renders. No se trae. Se
  conservan `v1-final` y la rama `main` como referencia de v1.
- **`verificar`** (las comprobaciones de `spec/vocabulario.md`: ningún nombre a la
  vez escogido y descartado, los `std` existen, los choques son exactamente
  `choques-std`) no existe. `choques-std` es `()`.
- Los casos 6, 7 y 8 de §1.5 no tienen cobertura.
- **Weft** (`../Weft/target/release/weft`; `weft index .` y después `weft doctor`,
  `weft graph --format json`, `weft impact`, `weft callers`) sustituye lo que antes
  hacía el caso de capas del harness. Medido el 27 nov 2026 sobre esta rama: **0
  ciclos**; ningún archivo de V2 importa v1; **ningún preset importa otro preset**;
  ningún módulo importa fuera de su carpeta salvo otro módulo
  (`color` → `validate`; `typography` → `color`, `validate`; `superbg`, `theme-v1` →
  `color`; `fleurones` → `typography`); `plain` solo importa `core`, `frame`/`elements`
  y los módulos `color` y `typography`. `doctor` da 65/100, y todo lo que resta es v1:
  **51 imports sin resolver**, todos en `src/` de v1 (48), `examples-v1/` (2) y
  `ornamentos/` (1); en V2, 0. Esos 51 son el mapa de lo que rompió quitar los
  duplicados (§2.2). Los 83 archivos que importan `src/lib.typ` (los de `examples-v1/` y
  `examples-v1/trabajos/`, 3 de `docs/`, `demo`, `svg-lab`, `ornamentos`) apuntan al
  destino equivocado: ahora es el `lib` de V2, y fallan por nombre (`sizes`,
  `carteles.*`). Por eso viven aparte, en `examples-v1/`. Está pendiente escribir un
  `scripts/capas.py` que compruebe las reglas de arriba sobre el grafo y falle si
  alguna se rompe.

---

## 3. Deuda técnica

### 3.1 Arquitectura

- **`proof` va a rediseño** (decidido el 26 nov 2026). Hoy marca el renglón que se
  sostiene con `main` y el que se niega con `versus`, un préstamo semántico:
  `versus` es «dos términos enfrentados». `cuerpo-lectura` y `signo` de v1 no tienen
  destino, y la retícula se dibuja siempre.
- **El papel de una variante.** El lienzo del scaffold pinta siempre `tm.paper`; las
  variantes `u` y `u-inverted` de `mosaic` usan otro rol como papel y lo tapan con
  un rectángulo. Convendría que el scaffold aceptara qué rol es el papel.
- **Ayudantes de v1 fuera del scaffold.** `area-trabajo` y `encajar` (de `_base` de
  v1) viven copiados en `resources/motifs/_lamina.typ` para `mosaic`; `_texto` y
  `_huecos` conservan sus nombres en español. Candidatos a subir al scaffold y a
  renombrarse.
- **La marca de `tiles`** va en negro fijo, como en v1, y no en la tinta del tema.
- **La regla de capas de `presets` es ancha.** `swiss` importa solo
  `plain/scaffold.typ` y `frame.typ`, pero `presets` puede importar `core`, `color`,
  `superbg`, `fleurones` y `resources` porque `inscription` (legado) los usa. Cuando
  `inscription` pase al scaffold, la capa se estrecha.
- **`inscription` no pasa por `plain`.** Cada uno de sus 15 estilos
  (`variants/<estilo>.typ`) dibuja su propia página con el código de v1, traduce los
  roles de V2 a los de v1 (`_a-v1`: `paper` → `fondo`…) y depende de `_legado/`
  (`_base`, `_temas`). Hay que partir cada estilo en fondo (superbg) y reglas, de a
  uno, vigilando la paridad.
- **El autoajuste de v1 sigue en `_legado/_base.typ`** (`ajustar-alto`), que usan los
  estilos de `inscription`. `plain` "post" y `swiss` ya usan el del scaffold
  (`ctx.fit-down`, `ctx.fit-width`).
- **`theme-v1`** (la API de temas de v1) sigue viva solo por `resources/dropcaps`; se
  retira cuando `dropcaps` use `modules/color`.
- **Dos `swiss`:** el de V2 (de `carteles.suizo`) y el de
  `Instatypst-rework/preset-swiss/presets/swiss.typ`, que usa `typography`, `raster`
  y `layers`. Idénticos en los casos probados, pero duplicados. Falta decidir cuál es
  la fuente de verdad (§5.5: ese `preset-swiss/` no está en git).
- **Escala `k` frente a `u`:** ver §1.9. En cuadrado y apaisado el tamaño por defecto
  (`62pt · k` en `bauhaus`) y un `main(size: 62)` (que es `u`) no coinciden.
- **`lib` exporta nombres con guion bajo** (`_frame`, `_parts`, `_plain`,
  `_presets`…): Typst no tiene exports privados; es solo convención.
- **Las variantes no tienen una convención común.** `plain` exporta reglas
  (`ctx => …`), `mosaic` exporta datos, `leaves` funciones de un diccionario propio
  (`_kit.typ`) e `inscription` funciones de v1. Todas exportan `variant`, con firmas
  distintas.
- **Colores internos de las orlas.** `resources/borders/borders.typ` guarda los
  colores de v1 `malla`, `franja`, `orn` y `fil` sin nombre en la tabla: se derivan,
  pero `theme:` no los puede cambiar. Sus temas «vino» y «papel» se convierten en
  diccionario antes del scaffold, porque `modules/color` no los conoce.
- **Partir el cuerpo de un elemento** (en líneas, por el último espacio) lo resolvió
  `folio` por su cuenta; un ayudante en `core` serviría también a `hinge`.
- **Decisiones de diseño de la tanda 3** (26 nov 2026; quedan como deuda):
  1. *Propiedades de los elementos estándar.* `list` y `quote` son los de Typst y no
     llevan propiedades. `timeline`, `contrast` y `stairs` escriben un
     `#main(size: …)[]` vacío solo para llevar el tamaño (en `timeline`, un
     `#main[texto]` se pierde en silencio), y `hinge` pone la fuente de la cita en el
     rol `main` de `fonts`, que en typography es alias de `body`. Propuesta: opciones
     del preset con nombre explícito (`list-size:`, `quote-font:`).
  2. *Elementos que van de a dos.* `read-parts` guarda el último de cada nombre
     (§1.4); `contrast` necesita dos `versus` y recorre el cuerpo a mano. Propuesta:
     que el preset declare los elementos múltiples (`many: ("versus",)`).
  3. *Ayudantes en `core/parts`.* `proof`, `contrast`, `timeline`, `hinge` y `stairs`
     copian su propio `_flatten` para sacar grupos e ítems de las listas; `folio` y
     `event` parten el cuerpo en líneas. Hacerlos una vez en `core/parts`.
  4. *Elementos dentro de los ítems de una lista.* `stairs` y `proof` ponen un
     `#main(…)` en cada ítem para las propiedades del renglón. Propuesta: aceptarlo
     como convención; confirmar los nombres que inventó `stairs` (`indent`, `fill`
     con un rol como texto, `style`).
  5. *Nombres que inventó `social-quote`:* roles propios `dots`, `grain`, `tape`,
     `border`, `deep`, `haze`, `light`; `author(position: "bottom" | "top" |
     "side")`; `style: "card" | "bleed" | "open"`; las claves de `metrics`, `reply` y
     `note-*`. `border` choca con el recurso `border` (propuesta: `edge`).
  6. *El número volado de `hinge`* (`llamada` en v1, sin entrada en la tabla): los
     tests lo definen a mano con la etiqueta `<hinge-callout>`. Propuesta: exportarlo
     como función, `callout(n)`.
- **`social-quote` sin `author`** dibuja igual el avatar y el filete: por «nada es
  obligatorio» habría que ocultar el bloque de atribución.
- **Identificadores internos en español** copiados de v1 (`social-quote`, `_texto`,
  `_huecos`, los estilos de `inscription`): la API está en inglés, el código de
  adentro no.

### 3.2 Comportamiento

- **Errores que el contrato no permite** (§1.4: el único error es el de sintaxis).
  Los estilos de `inscription` (legado) dan error si falta la cita. Y varios
  presets heredan de v1 los errores de «no cabe» (`leaves`, `inscription`): son
  límites geométricos, y resolverlos (achicar, reacomodar) es diseño. `leaves` ya no
  exige `headline`.
- **`frame` filtra o rechaza:** hoy rechaza, con el mensaje del scaffold («no es un
  elemento ni una opción de este preset»). Falta confirmar que no se quiere
  descartar en silencio. `theme`, `accent` y `brand` no llegan al preset si valen
  `auto` o `none`: un preset sin acento (`plain`) no ve nunca `accent:` salvo que
  alguien lo pase, y entonces falla con ese mensaje.
- **Una sola tabla de formatos:** `core/artboard` tiene `retrato` y `cuadrado`;
  `instagram` es 1080×1080 y los carteles de v1 son 4:5. (`superbg` guarda su propia
  tabla a propósito.)
- **`main` y el contenido suelto.** `main` lleva las propiedades del texto (`size`,
  `weight`, `tracking`, `max-size`, `align`); si hay `main` y además contenido
  suelto, el suelto se dibuja después, en otro párrafo. `align` alinea también el
  autor, que va en el mismo bloque. El autor mide 0,26 del texto (mínimo 24 u) y va a
  0,45 del texto por debajo: es una definición de `"post"`, heredada de `liso`.

### 3.3 Nombres

- Las variantes de `inscription` (15) siguen en español (`luto`, `cumbre`…); las de
  `mosaic`, `leaves` y `social-quote` ya están en inglés.
- `brand`: elemento y argumento de `frame` a la vez, sin decidir si es un elemento o
  un recurso que se define una vez y los presets toman.
- `title-role` frente a `role` (el desempate anterior lo había simplificado); `date`
  frente a `dates` (el día de un evento y los años de un autor); el «dato fuerte
  destacado» sin nombre.
- `lamina`: `series` o `slide`.
- Los valores de algunas opciones siguen en español porque vienen de módulos de v1:
  las cadenas y viñetas de `fleurones` (`"celosia"`, `"ojivas"`…) y los lados de la
  orla (`"completa"`, `"arriba-abajo"`…).
- `superbg` conserva funciones con «preset» en el nombre (`preset-capas`,
  `superbg-preset`), que en Instatypst significa otra cosa.
- Esto se resuelve con el módulo i18n (§5.3) en vez de renombrar a mano.

### 3.4 Licencias

- **APCA** (`modules/color/palettes/color-math.typ`, `LICENSE-apca`): solo pantallas,
  sin uso comercial; nombre y logo protegidos; patente en trámite. Está dentro por
  decisión del autor (§1.9). Antes de publicar o redistribuir el paquete, o de usarlo
  para impresos, hay que cumplir la política mínima o retirarlo; los pasos de retiro
  están en `src/modules/README.md`.
- **IM Fell:** la licencia de las fuentes pide la nota de crédito
  (`fleurones.credito`) en toda publicación que las use. El paquete no la estampa;
  nada le recuerda a quien publica que la ponga.

---

## 4. Abierto

Lo que no está decidido y no tiene sección propia arriba:

- **`repeat`** en `frame` o en los presets numerados (§2.1).
- **`brand`**: elemento o recurso (§3.3).
- **Destinos con `?`** de la traducción original (16: `cadena`, `cumbre`, `tira`,
  `maestra`, `afirma`, `niega`, `centro`, `luto`…): ya están decididos en
  `spec/decisiones-traduccion.md`; queda como historia.
- **Elementos propuestos** por la traducción de v1 y no incluidos todavía:
  `reference`, `affirms`, `denies`. Las decisiones los mandaron a `work` y a roles
  del tema (`affirm`, `deny`).
- **Los recursos** (`border`, `texture`, `wear`, `grid`, `veil`, `dropcap`,
  `vignette`, `symbol`…) no tienen tabla de nombres decidida (§2.4).

---

## 5. Migración de v1 a V2

### 5.1 Lo hecho

La migración es aditiva, en la rama `feat-v2`, sobre la etiqueta `v1-final`:

1. **Módulos** `validate`, `color` y `typography`, con sus pruebas.
2. **`superbg` y `fleurones`.** De 17 archivos de `superbg`, 14 eran idénticos; las
   diferencias de V2 son intencionadas: `presets.typ` se renombra `catalogo.typ`,
   `color.typ` delega el contraste en el módulo `color` (una sola implementación) y
   `pattern.typ` admite tamaños no enteros (arreglo de un fallo). `fleurones` lee sus
   familias de `typography`.
3. **`theme` y `tokens`** pasan a `modules/theme-v1/` con `git mv`; los diez archivos
   de v1 que los importaban se reapuntaron. 147 páginas de 15 ejemplos, idénticas
   antes y después.
4. **`core`, `plain`, `frame`, `elements`, `resources`.**
5. **Los 21 presets** de `src/presets/`.
6. **`lib.typ`** de V2 sustituye al de v1.
7. **Se borraron los duplicados de v1** que V2 cubre (`superbg`, `pliego`, `fleurones`
   y su json, `contrast`, `font-tokens`, `font-pairings`, `palettes`, `dropcaps` y los
   59 assets de `eb-initials`).
8. **`spec/` y este documento.** `Spec.MD` no se trae: lo normativo está en §1.

Quedan fuera, a propósito: `Spec.MD`, `spec/traduccion-walltypst.*` (el port está
hecho; es archivo), el harness de paridad contra v1 y `tests/harness/ref/` (copias de
v1 para medir píxeles).

### 5.2 Proyectos que importan el paquete

El paquete instalado `@local/instatypst:0.1.0` es un symlink a `src/` de este
directorio, así que mientras `feat-v2` esté extraída esos proyectos leen V2 y no
compilan. Se asume: migrarlos es poco trabajo, y `frame` lo facilita. Importan el
paquete: `Post` (18 archivos), `Kuyper` (7), `unotypst` (2), `presets` (2),
`grammata` (2), `CoverBook` (2) y archivos sueltos en `~/Documents` (2). `WallTypst`
(3) queda cubierto por su port (§6). Usan la API de v1: `fleurones`, `capitular`,
`superbg` y algunos `carteles.*` (`hoja`, `lienzo-orlado`, `temas-orla`, `teselas`,
`linea-tiempo`). Para ellos hace falta antes §2.3 (que `lib` exporte los recursos).

### 5.3 El módulo i18n

Con la API de V2 en inglés y estable, lo que queda de la migración es traducción de
nombres, no rediseño. El español pasa a ser una **capa** encima, no un segundo
conjunto de nombres a mantener:

| Capa | Contenido |
|---|---|
| Núcleo (V2) | `swiss`, `inscription`, `bands`, `stairs`… y los 30 elementos de `elements.typ` |
| i18n `es` | `suizo`, `epigrafe`, `franjas`, `escalera`…, más los nombres de elementos y parámetros (`cita`, `marca`, `formato`…) |

La tabla `es` sale casi hecha de `spec/vocabulario.md` (columna «Español») y de
`spec/decisiones-traduccion.md`. Hacerla con una tabla (no con código duplicado) da
además la compatibilidad con v1: `carteles.suizo(…)` seguiría compilando. No se
construye ahora. **`idiomas` (§2.2) no es i18n:** `idiomas` es texto en otras
lenguas (latín, griego, hebreo); i18n son los nombres de la API.

### 5.4 `ornamentos/`, `scripts/` y `examples-v1/`

- **`ornamentos/`** es un subsistema aparte, independiente del paquete: el escáner
  de glifos ornamentales de `Fonts/` y su catálogo. V2 no tiene equivalente. Su
  `fleurones.json` es la clasificación de la hoja de pruebas, distinto de las medidas
  que consume `modules/fleurones/assets/`. Se queda como está (queda por decidir si
  pasa a `tools/`).
- **`scripts/medir-fleurones.py`** ya escribe en `src/modules/fleurones/assets/` y
  regenera el json byte a byte igual. Otros scripts (`catalogo.py`, `nueva-plantilla.py`,
  `foto-de-lamina.py`) llaman a la API de v1.
- **`examples-v1/`** (los ejemplos de v1 y, dentro, `trabajos/`) es la carpeta
  explícita de lo que usa la API de v1; se movió con `git mv` el 27 nov 2026. Los
  ejemplos conservan la profundidad, así que sus imports relativos valen; los de
  `trabajos/` ganaron un `../`. `examples/` queda libre para los de V2. No compilan
  contra V2 hasta migrarse, uno a uno. `mcp/server.py` y `scripts/catalogo.py` ya
  leen de ahí. **`docs/`** y **`mcp/`** también usan la API de v1.
- **`README.md`, `SKILL.md` y `docs/manual.typ`** describen v1: citan `src/lib.typ`
  como la entrada de v1 y las rutas `examples/` y `trabajos/`, que ya no existen.
  `README.md` y `SKILL.md` tienen prioridad sobre este documento; hay que decidir si
  se reescriben.

### 5.5 Antes de borrar ramas o worktrees

- **`laboratorios` y el commit `09e5fff`.** Esa rama es lo único que contiene el
  código de v1 de `lamina`, `marca`, `estilo`, `consejo`, `evento` y `contraste`
  (`main` va 2 commits por detrás). Si se borra la rama sin más, esos archivos se
  pierden. La referencia de paridad ya no hace falta como código (§2.5), pero **antes
  de borrar hay que revisar las investigaciones** que contiene o fijar el commit con
  una etiqueta.
- **`Instatypst-rework` tiene trabajo sin versionar:** `preset-swiss/` (59 MB: `lib`,
  `WIP-color`, `WIP-web`, `casos`, `PLAN.md`, `CAMBIOS.md`), `docs/grafo*` y `.weft/`.
  `color`, `typography` y `validate` de V2 se copiaron de `preset-swiss/lib/`, que no
  está en git; la procedencia es el sha256 de cada archivo (`src/modules/README.md`).
  Si ese worktree se borra, se pierde.

---

## 6. La fase WallTypst

El port está hecho y V2 la absorbe. Vive en `.labs/Walltypst-Framed` del repositorio
`InstatypstV2` (rama `pre-fusion`), que no se ha traído aquí. Es una fase previa a la
fusión: lo vendorizado y lo provisional está aislado y se funde después en módulos.
Hay **37 de los 47 presets** de WallTypst portados, con paridad medida en tres formatos
(apaisado, vertical y ultra ancho): `timepiece` (7 variantes), `anaglyph` (20),
`inscription` (5 nuevas, sobre las 15) y `tableau` (5). **36 de las 37 dan 0 píxeles**;
la excepción es `month` (1278 px, el 0,06 %: WallTypst pinta los números en `#000000`,
el rol `dark`, y V2 usa la `ink` del tema). No están registrados en `src/lib.typ`.

**Elementos nuevos ya decididos:** `calendar`, `clock`, `glyph` y `ruler`
(`spec/vocabulario.md`; con ellos son 30).

**Módulos que esta fase pide:**

| Pieza | Destino |
|---|---|
| curvas de nivel (`curvas.campo`/`ventana`) | módulo `topography` (curvas, ondas, flujo, órbitas) |
| retícula (columnas × filas, zona segura, sangrado) | engine de retículas / `put` (§1.5, caso 7) |
| reloj (`_dial`, `_clock`, `_sky`, el tema por día de la semana) | engine de reloj |
| pasadas de tinta, ajuste de texto, `azar`/`rango`/`choose` | módulo `glitcher` |
| nombres de meses y días | módulo i18n (§5.3) |
| `aspect` / `pick` (`{ apaisado, ultra, vertical }`) | el «lenguaje de valores» |
| ajuste multiplicativo ×0,95 | `fit-down` con `factor:`; toca `scaffold.typ` |
| grano de papel (capa `ruido`) | recurso `grain` |

**Decisiones abiertas:**
- **`seed` y paleta.** WallTypst elige su paleta con `elegir` + semilla (35 de 47
  presets). Decidido: `seed:` es una semilla de **color** que por defecto deriva el
  motor de colores. Sin implementar; hoy `seed: 1` solo gobierna el azar de los
  desplazamientos. Son dos significados de «seed» y hay que separarlos.
- **Nombres provisionales:** los presets `timepiece`, `anaglyph` y `tableau`, y la
  mayoría de sus variantes. `monogram`, `twin` y `grotesque` igualan los píxeles pero
  se rehacen: no darlas por definitivas.
- **Tipografía por pairing.** WallTypst toma `display`/`body` del pairing; aquí cada
  variante pide su familia por nombre. Hay que decidir si `anaglyph` usa los pairings
  de V2 (`fonts:`).
- **De dónde sale la cita:** `word` y `scale` leen `#main`; `edge` lee `#verse` o
  `#epigraph`; WallTypst tomaba el primero que hubiera. Sin unificar. La firma de un
  verso se escribe `#author[referencia]` + `#work[versión]`: es un parche semántico.
- **`hora-del-dia`:** la hora de transición (`mezcla = 60`) no interpola en WallTypst
  (un error suyo); está replicado.

**Lo que falta portar (10 de 47):**
- **Libro** (5, hard-rework): `cartel-libro` (+`-doble`, `-indice`, `-lomos`) y
  `cartel-numeral`. Piden datos del verso (`verse.book`, `verse.chapter`,
  `verse.number`) que V2 no tiene.
- **Gráficos** (6): `cartel-ondas`, `marea` y `cartografia` dependen de `topography` y
  de la capa `velo`; `folio` y `bauhaus` de WallTypst son **otros diseños** con el
  mismo nombre que los de V2: decidir si son variantes o se descartan.
- Pendiente: `measure` y `max-width` (los usan `cartel-numeral` y `bauhaus`).

**El laboratorio.** Los prototipos de `.labs/` (`glitcher.typ`, `presets/capas|stamp|regla`,
`plain/variants/anaglyph.typ`) no son portes: difieren de WallTypst entre 4 y 79 %. Se
retiran o se funden cuando `glitcher` sea módulo.

---

## 7. Orden sugerido

1. **Cerrar el volcado:** las pruebas de los presets (§2.5) y `.labs/`.
2. **Que `lib` exporte la API pública de recursos** (§2.3), para poder migrar los
   proyectos de §5.2.
3. **Los ayudantes de `core/parts`** (§3.1, tanda 3, punto 3): no necesitan decisión y
   simplifican cinco presets.
4. **La tabla de nombres de los recursos** y su implementación, de a uno: cada recurso
   apaga o cambia lo que hoy cada preset dibuja siempre.
5. **`lamina`** cuando se decidan su nombre y `repeat`; rescatar antes su código
   (§5.5).
6. **`proof`, a rediseño.** **`inscription` como `plain` + superbg + reglas**, estilo
   por estilo.
7. **El módulo i18n** (§5.3), cuando los nombres de la API estén fijos, y migrar los
   proyectos de §5.2.
8. **Ajuste fino:** escala `k` → `u`, nombres internos en inglés, variantes de
   `inscription` en inglés.
9. **Antes de publicar:** APCA (§3.4) y la nota de IM Fell.
10. **Fase WallTypst** (§6): `topography`, `glitcher`, retículas, reloj; separar `seed`.
