> Origen: derivado por un agente en `suizo-agentes/sistema-opus/` (nov 2026). Las rutas `lib.typ`, `pruebas/` y `ejemplos/` se refieren a ese directorio; `core/` y `src/` al proyecto.

# Vocabulario del sistema

Este sistema de diseño sale de 20 carteles de estilo suizo: `haiku/`, `sonnet/`, `ronda2/haiku/` y `ronda2/opus/`, de 5 carteles cada uno. Este documento recoge tres cosas: lo que se repite en esos carteles, el nombre que recibe cada concepto y por qué.

Referencias a los carteles: **H1–H5** = `haiku/`, **S1–S5** = `sonnet/`, **RH1–RH5** = `ronda2/haiku/`, **RO1–RO5** = `ronda2/opus/`.

---

## 1. Lo que se repite (antes de nombrar)

| Observación | Carteles |
|---|---|
| El lienzo es 1080×1350 en los 20 casos. | todos |
| El margen es de 60 px en casi todos (15 de 20). Excepciones: 70 (H4), 100 (RO5, con marcas de corte a 48), 124 a la izquierda (RO4, para los rótulos del margen) y 0 (H3, formas a sangre). | todos |
| La superficie viva mide 960 de ancho y se divide en 12×80, 16×60, 6×160 o 4×240. El **módulo de 60 coincide con el margen**. | H1, RH2, RH5, RO1, RO2, RO3, S2, S4 |
| Hay **un solo color de acento** y **un solo elemento acentuado** dentro de una serie: el año 1957, la barra 14, la columna 12, el paso actual, los días con sesión, la última línea… | H2, H4, S5, RH1, RH2, RH5, RO1, RO2, RO3, RO4 |
| Una línea mono pequeña en mayúsculas encima del titular, siempre en DM Mono, de 14 a 22 px. | H2, H4, H5, RH1–RH4, RO5 |
| Un pie mono o discreto abajo a la izquierda: «02 / 05 — …», «Cartel 03 · …». | H1–H5, RH1–RH5, RO5 |
| Titular en negrita con tracking negativo (de −2,3 % a −5 % del cuerpo), alineado a la izquierda y nunca centrado. | todos |
| Los tamaños caen sobre una escala 5:4 desde 16: 13, 16, 20, 25, 31, 39, 49, 61, 76, 95, 119, 149, 186 (la tabla del § 3 lo detalla). | todos |
| Las cuatro esquinas tienen función fija: titular arriba a la izquierda, dato breve arriba a la derecha, lugar y fecha abajo a la izquierda, serie abajo a la derecha. | S1–S5 |
| La retícula se deja ver con franjas, filetes, celdas, líneas base o índices. | H1, RH2, RH3, RH5, RO1–RO5 |
| Datos de servicio en pares clave–valor: fecha, hora, lugar. | RO1, RO2, RO5, S1, S5 |
| Campos de celdas iguales con una marca por celda: semitono, cuartos de círculo, pasos, subdivisiones. | S2, S4, RH2, RO2, RO4, H3 |
| Una progresión de barras que crecen. | S5, RO1 |
| Una letra enorme cortada por el borde. | H5, S1 (RO2 lo hace con una letra por campo) |
| Marcas de imprenta: corte, registro, tira de color, fuera de registro. | RH4, RO5 |
| El fondo es claro en 16 carteles, oscuro en 3 (S5, RO1, RO4) y del color de acento en 1 (S1). | — |

---

## 2. Lienzo

| Concepto | Nombre | Qué responde | Tipo | De dónde |
|---|---|---|---|---|
| Lienzo | `canvas(...)` | ¿Qué tamaño tiene y adónde va? | function → dictionary | todos (1080×1350) |
| Formato con nombre | `formats.<nombre>` | ¿Qué tamaño tiene un destino conocido? | dictionary | — |
| Destino | `medium` | ¿Pantalla, impreso o fondo de escritorio? | str (`"screen"`, `"print"`, `"wallpaper"`) | — |
| Sangrado | `bleed` | ¿Cuánto sobra para el corte? | length | RO5 y RH4 lo dibujan |
| Unidad | `unit` | ¿Cuánto mide una unidad de referencia en este lienzo? | length (= lado corto / 1080) | todos |
| Lado de referencia | `reference-side` | ¿Contra qué se miden todas las cifras? | int (1080) | todos |
| Fondo dibujado | `backdrop` (parámetro de `poster`) | ¿Hay una capa decorativa entre el papel y el contenido? | none / content / function layer → content | ninguno de los 20; viene de superbg (ver COMENTARIOS.md) |
| Pátina | `overlay` (parámetro de `poster`) | ¿Hay una capa encima del contenido (manchas, viñeta, desgaste)? | none / content / function layer → content | superbg (`bg-cafe` «encima del texto») |
| Contexto de capa | `layer-context(canvas, palette)` | ¿Qué recibe una capa para dibujarse al tamaño y con los colores del cartel? | function → dictionary (canvas, palette, extent, theme) | — |
| Orientación | `orientation` | ¿Vertical, apaisado o cuadrado? | str | — |

Formatos: `feed-portrait` (1080×1350), `feed-square` (1080×1080), `story` (1080×1920), `slide` (1920×1080), `wallpaper-uhd` (3840×2160), `wallpaper-phone` (1170×2532), `print-a3` y `print-a2` (con 3 mm de sangrado).

Los formatos se nombran por **destino y proporción**, no por píxeles ni por marca: `feed-portrait` y no `instagram-4x5` ni `1080x1350`. El destino cambia menos que la plataforma.

## 3. Color: `palette`

| Rol | Nombre | Qué responde | Tipo | De dónde |
|---|---|---|---|---|
| Fondo | `paper` | ¿Sobre qué se imprime todo? Puede ser oscuro o el color de acento. | color | todos (11 lo llaman `paper`) |
| Tinta | `ink` | ¿De qué color son el texto y las formas principales? | color | todos (13 lo llaman `ink`) |
| Acento | `accent` | ¿De qué color es lo único que destaca? | color | 18 de 20 |
| Texto discreto | `quiet` | ¿De qué color van los pies, metadatos y descripciones? | color | H1, H4, RH2, RH4, RO1–RO4 (`muted`, `grey`) |
| Guía | `guide` | ¿De qué color es la retícula visible? | color | H1, RH2, RH3, RH5, RO1, RO3, RO5 (`guide`, `rule`, `nonrepro`) |
| Plano secundario | `tint` | ¿De qué color es una zona de fondo secundaria? | color | RO4 (`dim`) |
| Tintas adicionales | `swatches` (y `"swatch-N"`) | ¿Qué otras tintas hay en un cartel policromo? | array de color | H3 (primarios), RH4 y RO5 (CMY) |
| Paletas con nombre | `palettes.<nombre>` | ¿Qué combinación ya probada uso? | dictionary | ver tokens.typ |

Todos los componentes aceptan un color o el nombre de un rol (`fill: "accent"`). Así el mismo cartel funciona con otra paleta.

## 4. Tipografía

| Concepto | Nombre | Qué responde | Tipo | De dónde |
|---|---|---|---|---|
| Juego tipográfico | `typeface` / `typefaces.<nombre>` | ¿Qué fuentes uso? | str o dictionary | — |
| Fuente principal | `main` | ¿Con qué fuente van titular, frase, prosa y datos? | str (fuente) | todos: una sola grotesca por cartel |
| Fuente de titulares | `display` | ¿Con qué fuente van titulares y cifras (subhead, headline, numeral)? Por defecto = `main` | str (fuente) | ninguno de los 20 la distingue; swiss de core/v2 usa Bebas Neue (ver INTEGRACION.md) |
| Fuente de anotación | `annotation` | ¿Con qué fuente van etiquetas, índices y pies? | str (fuente) | DM Mono en 13 carteles |
| Escala | `step-size(n)` | ¿Cuánto mide el paso n? (16 × 1,25ⁿ) | function int/float → float | todos |
| Paso | `step` | ¿En qué peldaño de la escala está este texto? | int/float | todos |
| Peso | `weight` | ¿Con qué grosor? | str/int | bold en titulares, black en S4 y RO2, extrabold en RO5, medium en S2 |
| Espaciado entre letras | `tracking` | ¿Qué apriete lleva? (−0,03 em el titular, −0,04 em el dominante, +0,03 em la mono) | length (em) | todos |
| Interlínea | `pitch` | ¿Cuántos em hay entre líneas base? | float | todos |
| Caja | `case` | ¿Va en mayúsculas? | none / `"upper"` / `"lower"` | etiquetas |
| Rol de texto | `typeset(role, …)` | Aplica un rol con sus valores por defecto. | function | — |

**Roles de texto (contenido):**

| Rol | Función | Paso | Para qué sirve | De dónde |
|---|---|---|---|---|
| Índice | `index` | −1 | Numerar columnas, filas o pasos | RH2, RH5, RO1–RO5 |
| Antetítulo | `kicker` | 0 | Tema o serie en mono mayúscula, encima del titular | H2, H4, H5, RH1–RH4, RO5 |
| Titular | `headline` | 8 | El texto principal | todos |
| Titular dominante | `headline(dominant: true)` (rol `display`) | 10 | El titular cuando el cartel es tipográfico | H1, H2, RH1, RH2, RO5, S4 |
| Frase | `lede` | 3 | La frase que explica el titular | H1, H3, RH1, RO1 |
| Prosa | `prose` | 2 | Texto corrido en una medida de columnas | H1, H2, H3, H5, RH3, RH5, RO5 |
| Nota | `note` | 1 | Texto breve de servicio: esquinas, fecha, lugar | S1–S5, H1 |
| Subtítulo | `subhead` | 5 | Dato fuerte, nombre o fecha destacada | RH2, RO2, RO3, RO4 |
| Cifra | `numeral` | 11 | El número protagonista | H1, RH5, RO5 |
| Pie | `colophon` | 0 | Número de serie y descripción técnica | H1–H5, RH1–RH5, RO5 |
| Acentuado | `accented[...]` | — | Poner un fragmento en el color de acento | H2, RH5 |

## 5. Retícula: `raster`

| Concepto | Nombre | Qué responde | Tipo | De dónde |
|---|---|---|---|---|
| Retícula | `raster(...)` | ¿Cómo se divide la superficie? | function → dictionary | todos |
| Columnas | `columns` | ¿En cuántas columnas? | int | 12 (H1, RH5, RO1), 6 (RO3, RO5), 4 (RO2), 7 (RH1, RO4), 16 (RH2, S4) |
| Filas | `rows` | ¿En cuántas filas o campos verticales? | int / auto | RO1 (14), RO2 (5), RO3 (5), RO4 (7) |
| Medianil | `gutter`, `row-gutter` | ¿Qué separación hay entre columnas o filas? | int/float (u. de ref.) | 20 (H1, RH3, RH5), 12 (RO5, S2), 0 (RO1–RO4) |
| Margen | `margin` | ¿Cuánto blanco hay alrededor? | int o dictionary (left, right, top, bottom, x, y, rest) | todos |
| Alto de fila | `row-height` | ¿Filas repartidas, de alto fijo o cuadradas? | auto / número / `"square"` | RO1 (80), H3 (cuadradas) |
| Línea base | `baseline` | ¿Cuál es el paso vertical fino? | número (30 por defecto) | RO5 (24) |
| Desplazamiento | `offset` | ¿Está corrida la retícula? | número | RO3 |
| Campo | `region(...)` | ¿Qué rectángulo ocupa esta posición? | function → dictionary | — |
| Columna inicial / ancho | `col`, `span` | ¿Dónde empieza y cuántas columnas ocupa? | int/float | todos |
| Posición vertical | `row` / `line` / `fraction` | ¿En qué fila, línea base o proporción? | int/float/ratio | todos |
| Alto | `rows` / `lines` / `until` | ¿Cuántas filas o líneas? ¿O hasta N líneas antes del pie? | int/float | — |
| Contar desde abajo | `from: bottom` | ¿Se ancla al pie? | alignment | pies de 15 carteles |
| Hasta el borde | `extend` | ¿Sale hasta el borde del lienzo por algún lado? | array de str | RO1 (columna roja), RO3 (filetes) |
| Colocar | `put(...)` | Pone contenido en una región. | function → content | — |
| Anclaje | `anchor` | ¿Qué borde del contenido cae en la posición? | top/bottom/horizon | RO5 (texto apoyado en la línea base) |
| Corrección óptica | `nudge` | ¿Cuánto hay que compensar el blanco lateral de una letra grande? | dictionary (x, y) | RO5 (−8), RH1, RH2 |
| Cambiar retícula | `use-raster(r)` / `raster: r` | ¿Qué retícula vale a partir de aquí o solo para esto? | function / parámetro | H3, RO3, RO4 |
| Ver la retícula | `raster-guides(style: …)` | ¿Cómo se muestra la estructura? | function → content | ver § 6 |

## 6. Elementos gráficos reutilizables

| Elemento | Nombre | Qué responde | Tipo | De dónde |
|---|---|---|---|---|
| Retícula visible | `raster-guides` con `style` = `stripes` / `rules` / `rows` / `cells` / `baselines` / `row-ticks` / `column-ticks` | ¿Cómo se deja ver la estructura? | function | H1, RO1, RO2, RO3, RO5, RH5 |
| Índices de columna | `column-indices` | ¿Qué número tiene cada columna? | function | RH5, RO1, RO2, RO3, RO5 |
| Índices de fila o de línea | `row-indices(per: "row" \| "line")` | ¿Qué número tiene cada fila o línea base? | function | RO2, RO4, RO5 |
| Filete | `rule(weight: …)` | Una línea que separa o subraya. | function | S1, S3, RH3, RH5, RO1, RO3 |
| Grosores | `strokes.guide` / `divider` / `emphasis` / `frame` | ¿Para qué es este trazo? | dictionary de números | 0,5–0,8 / 1–1,5 / 3–4 / 6 |
| Punto | `dot` | Una marca circular. | function | H5, H4 |
| Forma | `shape(kind)`: `block`, `disc`, `ring`, `wedge`, `quarter`, `half` | Una forma geométrica que ocupa una región. | function | H3, RH4, RO1, RO2 |
| Bloque de llamada | `callout` | Un bloque de color con una cifra o un dato dentro. | function | H1, RH5, RO3 (con `fill: none`, celdas con relleno interior en RO2) |
| Campos | `fields(across, down, mark)` | Una región subdividida en celdas iguales, con una marca por celda. | function | S2, S4, RH2, RO2, RO4 |
| Marcas de celda | `mark-fill`, `mark-dot`, `mark-quarter` | ¿Qué se dibuja en cada celda? | function → function | RH2 y RO4, S4, S2 |
| Barras | `bars(axis, growth, accent-at)` | Una progresión que crece, con una barra acentuada. | function | S5, RO1 |
| Elemento acentuado | `accent-at` | ¿Qué elemento de la serie va en acento? | int / array / function | H4, S5, RO2, facts |
| Cronología | `timeline` | Fechas sobre una regla vertical. | function | H4 |
| Listado | `listing` | Filas de datos alineadas, con filetes. | function | S3 |
| Datos | `facts(layout: "stacked" \| "inline")` | Pares clave–valor de servicio. | function | RO1, RO2, RO5 |
| Sección | `section` | Etiqueta, filete y bloque. | function | RH3 |
| Columnas de texto | `text-columns` | Un texto en n columnas con filetes entre ellas. | function | RH3 |
| Calendario | `month-calendar` | Un mes en una tabla de 7 columnas. | function | RH1 |
| Leyenda | `legend` | Qué significa cada color. | function | RH2 |
| Texto ajustado | `fitted(fit: "width" \| "height", max-height, side-bearing)` | ¿Qué cuerpo hace que el texto llene su caja? | function | swiss de core/v2 (remate a todo lo ancho, frase que se achica) |
| Flujo vertical | `flow(top, fill, bottom, gap-top, gap-bottom)` | ¿Cómo se reparte el alto entre un bloque fijo arriba, uno elástico en medio y uno fijo abajo? | function | swiss y series de core/v2; el hueco señalado en LIMITES.md § 4 |
| Flecha | `arrow` | Señala la lectura de un bloque a otro. | function | swiss de core/v2 |
| Letra protagonista | `hero-glyph(from, crop)` | Una letra enorme que sale por una esquina. | function | H5, S1 |
| Marco de la superficie viva | `margin-frame` | Un rectángulo en los márgenes. | function | RH4 |
| Marcas de corte | `crop-marks` | Las esquinas de corte. | function | RH4, RO5 |
| Marcas de registro | `registration-marks` | Dianas en el centro de cada borde. | function | RO5 |
| Tira de control | `color-bar(strip:)` | Las muestras de tinta y densidad. | function | RH4, RO5 |
| Fuera de registro | `misregister(make, plates)` | Copias desplazadas en otras tintas. | function | RO5 |

## 7. Variantes

| Variante | Cómo se expresa | De dónde |
|---|---|---|
| Cartel tipográfico o cartel de figura | `headline(dominant: true)` frente a `headline()`, más una figura grande | Tipográficos: H1, H2, RH1, RH3, RH5, RO5. De figura: el resto |
| Fondo claro, oscuro o de acento | La paleta: `cream-red` frente a `night`, `navy`, `forest` o `red-ground` | S1, S5, RO1, RO4 |
| Retícula oculta o visible | Con o sin `raster-guides` | — |
| Lienzo | `canvas: "feed-square"`, etc. Los ejemplos aceptan `--input canvas=…` | — |

---

## 8. Decisiones difíciles

1. **`raster` y no `grid`.** `grid` es una función de Typst y además «grid» en Typst significa una tabla de layout, no una retícula de diseño. *Raster* es la palabra de Müller-Brockmann (*Rastersysteme*) y no choca con nada. Por la misma tradición, las celdas se llaman **campos** (`fields`, sus *Felder*).

2. **`headline` y `display`.** Los titulares de los carteles van de 64 a 160 px. Eso no es un solo tamaño: son dos. Cuando el texto es la figura del cartel, el titular está en torno a 150 (H1, H2, RH1, RH2, RO5, S4). Cuando hay una figura, el titular baja a unos 95 (RO1, RO4, H4, S5). Podían ser dos funciones (`headline`, `display`), pero entonces el usuario tendría que elegir por tamaño. Preferí **una sola función con la pregunta semántica**: `headline(dominant: true)`, ¿el titular es lo que domina? `display` sobrevive solo como nombre del rol interno. Tampoco `heading`, que es de Typst y significa encabezado de documento.

3. **`kicker` y `label`.** El rol más repetido (la línea mono sobre el titular) se llamaría «etiqueta», pero `label` es una función de Typst y además «label» sugiere un rótulo pegado a algo. *Kicker* es el término de prensa para esa línea y dice para qué sirve: introducir el titular.

4. **`colophon` y `footnote`.** El pie («02 / 05 — …») no es una nota al pie (`footnote` es de Typst y significa otra cosa) ni un folio (el folio es solo el número). Es un **colofón**: quién, qué serie, qué técnica.

5. **`note` y `prose`.** Las dos son texto regular de 20 a 26 px. La diferencia es de uso: `prose` es texto corrido que se lee (varias líneas, una medida de columnas) y `note` es información de servicio que se consulta (esquinas, fecha, lugar). Las separa la función, no el tamaño, así que llevan nombres distintos aunque estén a un paso de distancia en la escala.

6. **`index` y `kicker`.** Las dos son mono pequeñas. `index` numera la estructura (columnas, filas, pasos) y por defecto va en `quiet`. `kicker` presenta un contenido y va en `ink`. Si se confundieran, los índices de la retícula competirían con el antetítulo.

7. **`accent` (color), `accented` (texto) y `accent-at` (serie).** Un mismo concepto, «lo único que destaca», con tres formas: el color de la paleta, la función que pinta un fragmento de texto y el parámetro que elige qué elemento de una serie va en acento. Pensé en `highlight`, pero es una función de Typst (el subrayado de rotulador). Los tres nombres comparten raíz a propósito.

8. **`paper`/`ink` y `background`/`foreground`.** Los carteles ya usaban `paper` e `ink` (11 y 13 veces), y son nombres de función, no de aspecto: en S1 el papel es rojo y la tinta blanca. *Revisado en la segunda fase:* el fondo dibujado sí existe como concepto aparte y se llama `backdrop`. `paper` sigue siendo un color obligatorio, el tono dominante y el color de los vaciados. `background` se descarta porque nombra a la vez las dos cosas que hay que separar (ver COMENTARIOS.md, objeción 1).

9. **`quiet` y `muted`/`grey`.** `grey` dice cómo se ve y deja de ser cierto en un fondo azul marino (RO4, donde el texto discreto es crema translúcido). `muted` es casi sinónimo, pero se asocia a «desactivado» en interfaces. `quiet` dice lo que hace: hablar bajo.

10. **`tint` y `field`.** El plano secundario de RO4 (la zona ya recorrida) iba a llamarse `field`, pero `fields` ya era el componente de campos. Para no tener un color y un componente con el mismo nombre, el color se llama `tint`.

11. **`guide` y `rule`.** `guide` es el color de lo que muestra la estructura; `rule` es el componente filete, que puede ir en cualquier color. Un filete de guía es `rule(weight: "guide", fill: "guide")`: el grosor y el color tienen la misma función, pero son ejes distintos.

12. **Grosores por función, no por valor.** `strokes.guide` (0,75), `divider` (1,5), `emphasis` (4) y `frame` (6), en lugar de `hairline`, `thin` o `thick`. Sale de los datos: los filetes de retícula miden siempre 0,5–0,8, los separadores de fila 1–1,5, el subrayado del titular o la regla de tiempo 3–4, y el cierre de tabla 6 (S3).

13. **Unidad de referencia (`unit`) y no porcentajes.** Todas las cifras se escriben como en el cartel de 1080 y se multiplican por lado-corto/1080. Los porcentajes del ancho romperían la tipografía en apaisado (un titular «del 14 % del ancho» sería enorme en 3840). El lado corto mantiene la relación entre letra y margen en cualquier formato.

14. **`put` y `place`.** `place` es de Typst. `put` es corto, no choca y su significado (poner algo en un sitio de la retícula) no se confunde con nada de la librería.

15. **`nudge` como nombre explícito de la corrección óptica.** Varios carteles corrigen a mano el blanco lateral de las letras grandes (RO5: `col(0) - 8pt`). Lo nombré `nudge` y lo documenté como corrección óptica para que no se use como posicionamiento. Si aparece un `nudge` de más de unas decenas de unidades, es una señal de que falta algo en la retícula.

16. **Mezclas de nombre y valor.** Las paletas con nombre (`cream-red`, `navy`…) sí describen un aspecto. Una paleta *es* un aspecto, y nombrarla por uso («exhibition») mentiría en cuanto se usara para otra cosa. Los formatos, en cambio, se nombran por destino.

### Comprobación de choques

`pruebas/nombres-libres.sh` compila `#let _x = NOMBRE` para los 69 nombres que exporta `lib.typ`, sin importar la librería. Resultado: **69 libres, 0 choques**. Los candidatos descartados por chocar fueron `grid`, `label`, `title`, `footnote`, `highlight`, `tiling`, `square`, `measure` y `layout`. Algunos parámetros (`align`, `columns`, `line`, `layout`) sombrean funciones de Typst solo dentro de su propia función; la librería usa `std.*` cuando las necesita.
