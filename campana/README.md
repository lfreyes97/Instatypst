# Campaña de lanzamiento — 20 citas de B.B. Warfield

Cada cita es un `.typ` independiente en esta carpeta, listo para compilar a
PNG y publicar. Fuente: *Ensayos de B.B. Warfield sobre el calvinismo y
otros temas* (primera traducción al español).

## Compilar

Una sola imagen:

```bash
typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ salida.png
```

Todas de una vez (también como script: `./campana/compile-all.sh`):

```bash
for f in campana/*.typ; do
  base=$(basename "$f" .typ)
  [ "$base" = "_comun" ] && continue   # no es una tarjeta, es el sistema compartido
  typst compile --root . --font-path Fonts "$f" "campana/$base.png"
done
```

**Tamaño del pie:** `lienzo()` lleva `pie-scale: 1.5` — logo o handle al
150 % del tamaño base de `footer()` (30pt → 45pt). A tamaño base el logo
quedaba diminuto en lienzos de 900–1920pt. Cada tarjeta puede
sobrescribirlo (`#lienzo(contenido, tema, pie-scale: 1.2, size: ...)`),
pero el valor de campaña es uno solo o la grilla pierde el ritmo.

---

## La dirección de arte, en una frase

**Tinta sobre papel, a tamaño de cartel.** Veinte piezas que se leen como
una misma imprenta: cuatro familias cromáticas repartidas en cuatro actos,
una voz tipográfica por acto, una sola firma de atribución para las veinte,
y texto dimensionado para llenar el lienzo en vez de flotar en el centro.

### Qué cambió respecto del sistema anterior

| | Antes | Ahora |
|---|---|---|
| Superficie | blanco puro en las 20, con manchas pálidas | 8 tonos (4 familias × papel/tinta); **5 tarjetas son de fondo oscuro** |
| Escala del texto | ninguna tarjeta pasaba `size:` → todas en el tamaño base de la plantilla (32–48 pt sobre lienzos de 900–1920 pt), con medio lienzo vacío | `size:` explícito en las 20 (56–132 pt), calibrado tarjeta por tarjeta |
| Color | 4 paletas de biblioteca por «estado de ánimo» (`granates`, `noche-azul`, `vintage`, `grises`) resueltas por `auto-roles()` | 8 tonos compuestos a mano con tokens de `src/tokens.typ`, con roles asignados explícitamente (nada depende de qué color resulte más saturado) |
| Tipografía | 8 parejas, una por capricho de tarjeta (el README viejo decía 3 — estaba desactualizado respecto de los `.typ`) | 4 parejas: **una voz por acto** |
| Formatos | 2 (twitter 1600×900, instagram 1080×1080) | 3 (se suma **story 1080×1920** en 4 tarjetas) |
| Atribución | la que trajera cada plantilla: ~6 anatomías distintas entre las 20 | **una sola `firma()`** para las 20 (filete · versalitas · ensayo en itálica) |

---

## `_comun.typ` — ahora sí es el sistema, no un atajo

La versión anterior de `_comun.typ` era un wrapper mínimo (solo ahorraba
repetir el handle). Hoy contiene las tres decisiones que tienen que ser
idénticas en las 20 o la campaña deja de leerse como campaña:

1. **`tonos` / `tema-campana(tono, tipografía)`** — la superficie. Ningún
   lienzo es blanco puro.
2. **`firma(tema, fuente:, autor:, nota:, alineacion:)`** — la atribución.
3. **`lienzo(contenido, tema, size:)`** — handle, fondo, mancha y pie,
   todos derivados del tono.

Lo que **sigue decidiendo cada tarjeta** (y por eso no vive en `_comun.typ`):
qué tono, qué pareja tipográfica, qué plantilla `blockquote-*`, qué tamaño
de cuerpo y qué formato.

### Los 8 tonos

Cada tono son cuatro colores con rol fijo: `bg` (fondo del lienzo **y**
relleno interno de las plantillas con caja propia), `tinta` (cuerpo de la
cita), `acento` (filete, comilla, barra, resaltado) y `brillo` (manchas de
fondo, al 8–10 % de opacidad).

| Familia | Papel | Tinta | Para qué |
|---|---|---|---|
| **vino** | `marfil` / tinta `caoba` / acento `wine` | `wine` / tinta `marfil` / acento `caramelo` | identidad del calvinismo; el barro cocido de la 08 |
| **noche** | `cyan-50` / tinta `navy` / acento `petróleo` | `navy` / tinta `sky-100` / acento `azafrán` | la obra de la gracia: exposición doctrinal serena |
| **salvia** | `green-50` / tinta `esmeralda.darken(72%)` / acento `lago` | `esmeralda.darken(78%)` / tinta `pergamino` / acento `salvia` | el Espíritu Santo: vida, afecto, crecimiento |
| **grafito** | `slate-50` / tinta `stone-850` / acento `grafito` | `stone-850` / tinta `slate-50` / acento `slate-400` | polémica, historia, distancia crítica |

**Por qué tonos compuestos a mano y no `palettes.get(nombre)`:** `auto-roles()`
asigna `primary`/`secondary` por saturación, no por lo que sugiere el nombre
de la paleta (de ahí la nota del README viejo sobre `marino`, cuyos colores
más saturados son dos rojos). Para una campaña de 20 piezas que tienen que
convivir en una grilla, hace falta decidir el rol de cada color a mano. Los
colores siguen siendo tokens de `src/tokens.typ` — no hay hex sueltos.

**Por qué las 20 pasan `autor: none, fuente: none` a la plantilla:** las
`blockquote-*` pintan su atribución con `gray.darken(10..20%)` fijo, que es
ilegible sobre cualquier superficie oscura. Apagarla y componer `firma()`
debajo hace dos cosas a la vez: le da a la campaña una sola firma, y vuelve
posibles las superficies de tinta. (El intento anterior de fondos oscuros —
commit `39ecde0`, «corregir 6 tarjetas con fondo oscuro» — se revirtió a
blanco justamente porque las cajas internas seguían siendo blancas y la
atribución gris desaparecía. Acá se resuelve mapeando `colors.white` al
color del papel/tinta.)

---

## Los cuatro actos

Cada acto tiene una familia de color y **una sola voz tipográfica**. Cada
acto lleva además al menos un **ancla oscura**, para que la grilla del perfil
tenga ritmo y no sea una pared de papel claro.

### Acto I · «¿Qué es el calvinismo?» — familia **vino**, tipografía `lectura-editorial`
Bodoni Moda: didona de contraste alto, la letra de la declaración y el
cartel. Es el acto que define el término, así que habla en titular.
Tarjetas 01–04. Ancla oscura: **02**.

### Acto II · «La obra de la gracia» — familia **noche**, tipografía `editorial-clasico`
Cormorant / EB Garamond: la voz de la exposición. Soteriología — incapacidad,
expiación, imputación, predestinación, elección, redención.
Tarjetas 05–10. Ancla oscura: **08**.

### Acto III · «El Espíritu» — familia **salvia**, tipografía `revival-vintage`
IM FELL English / Cormorant Garamond: tipos de imprenta del XVII, calor
devocional en vez de precisión académica.
Tarjetas 11–15. Ancla oscura: **13**.

### Acto IV · «Polémica y mundo» — familia **grafito**, tipografía `geometrico-moderno`
Outfit / Inter: la única voz sans de la campaña. El acto donde Warfield
discute con su siglo, así que suena a prensa moderna y no a libro antiguo.
Tarjetas 16–20. Anclas oscuras: **17** y **20**.

---

## Tabla maestra

| # | Fuente (ensayo) | Acto | Tono | Tipografía | Plantilla | Formato | `size:` |
|---|---|---|---|---|---|---|---|
| 01 | ¿Qué es el calvinismo? | I | papel-vino | lectura-editorial | hero | twitter 1600×900 | 102 pt |
| 02 | El calvinismo: significado y usos del término | I | **tinta-vino** | lectura-editorial | pull | twitter | 115 pt |
| 03 | El calvinismo hoy | I | papel-vino | lectura-editorial | editorial | instagram 1080×1080 | 64 pt |
| 04 | La teología de Calvino | I | papel-vino | lectura-editorial | bar «grande» | **story 1080×1920** | 84 pt |
| 05 | La incapacidad y la exigencia de la fe | II | papel-noche | editorial-clasico | hero | twitter | 102 pt |
| 06 | La expiación | II | papel-noche | editorial-clasico | editorial | instagram | 72 pt |
| 07 | La imputación | II | papel-noche | editorial-clasico | card | instagram | 64 pt |
| 08 | La predestinación | II | **tinta-vino** ⚑ | editorial-clasico | hero | instagram | 92 pt |
| 09 | La elección | II | papel-noche | editorial-clasico | **superbg papel + cita editorial** | twitter | 82 pt |
| 10 | "Redentor" y "redención" | II | papel-noche | editorial-clasico | poetry | instagram | 80 pt |
| 11 | La persona y la obra del Espíritu Santo (Salmo 51) | III | papel-salvia | revival-vintage | bar | instagram | 78 pt |
| 12 | ídem (La guía del Espíritu) | III | papel-salvia | revival-vintage | editorial | instagram | 68 pt |
| 13 | ídem (El Espíritu de fe) | III | **tinta-salvia** | revival-vintage | pull | **story** | 92 pt |
| 14 | ídem (Fortalecimiento espiritual) | III | papel-salvia | revival-vintage | hero | twitter | 104 pt |
| 15 | ídem (El amor del Espíritu Santo) | III | papel-salvia | revival-vintage | hand ⚑ | instagram | 104 pt |
| 16 | La polémica del pedobautismo | IV | papel-grafito | geometrico-moderno | callout | **story** | 76 pt |
| 17 | Apologética | IV | **tinta-grafito** | geometrico-moderno | bar «acento» | twitter | 104 pt |
| 18 | El sobrenaturalismo cristiano | IV | papel-grafito | geometrico-moderno | editorial | instagram | 56 pt |
| 19 | La vida religiosa de Charles Darwin | IV | papel-grafito | geometrico-moderno | lateral ⚑ | **story** | 72 pt |
| 20 | ídem (contraste con Charles Hodge) | IV | **tinta-grafito** | geometrico-moderno | pull | twitter | 132 pt |

⚑ = excepción documentada, ver abajo. En negrita: superficies de tinta,
formatos no cuadrados y desvíos del sistema.

**Reparto de formatos:** 7 twitter (citas cortas y autocontenidas) · 9
instagram (citas expositivas) · 4 story (las cuatro citas largas: 04, 13, 16,
19 — el vertical deja que caigan en cascada en vez de apretarlas). `linkedin`
(1200×1200) existe en `sizes` pero no se usa: no aporta nada que no dé el
cuadrado de instagram.

**Resaltados** (`#highlight`, nativo de Typst) en 10 de 20, siempre sobre la
frase que sostiene el contraste interno de la cita, nunca como decoración:
03, 05, 06, 11, 12, 13, 16, 17, 18, 19. El relleno sale de `realce(tema)`,
que calibra la transparencia distinto según la superficie (sobre tinta hace
falta más, para que el acento claro no tape la letra).

**Handle:** `presuposicionalismo.com` en el pie de las 20, puesto por
`lienzo()`.

---

## Las excepciones (y por qué existen)

- **08 — única excepción cromática.** Pertenece al Acto II (familia noche)
  pero se imprime en familia vino: la imagen es barro cocido, y el tono del
  horno manda sobre el tono del acto.
- **15 — única tarjeta manuscrita.** `blockquote-hand` fija Caveat sin
  importar la pareja tipográfica. Es la frase más exclamativa y menos
  argumentativa de las 20: una nota al margen, no una tesis.
- **19 — única tarjeta que conserva la atribución de su plantilla.** La
  barra vertical rotada *es* `blockquote-lateral`; apagarla la dejaría en un
  párrafo justificado sin carácter. La `firma()` aparece igual, sin filete y
  solo con la nota.
- **19 y 20 — par Darwin/Hodge.** Las dos llevan `nota:` en la firma
  aclarando que son palabras *sobre* o *citadas por* Warfield, no suyas. Sin
  esa nota, sueltas en un feed, la 20 parecería atribuirle a Warfield una
  frase de Darwin.
- **16 — cambio de plantilla.** Usaba `blockquote-timeline`, que trae una
  regla vertical de **alto fijo (44 pt)**: no escala con `size:`, y a tamaño
  de lienzo quedaba como una astilla junto al cuerpo. Se pasó a
  `blockquote-callout` (la única plantilla de `blockquotes.typ` que ninguna
  tarjeta usaba), que además permite poner «Génesis 17» como título del
  bloque en vez de perderlo en el pie.

---

## Notas técnicas que conviene no perder

- **IM FELL English (13) no es fuente variable.** Pedirle `weight: 800` no
  hace nada — verificado con diff de píxeles: 0 % de diferencia.
- **Bug de Typst — el `;` que desaparece.** Un `;` pegado justo después de
  cerrar un `#función(..)[..]` (sin espacio) no se imprime: Typst lo toma
  como el terminador opcional de esa expresión de código embebida en markup
  (`.` y `,` no tienen ese problema). Fix: forzarlo a contenido literal con
  `#[;]`. Afecta a la tarjeta **11**; la 09 ahora encierra la puntuación
  dentro del contenido tipográfico y ya no necesita ese escape.
- **El hueco de `blockquote-editorial`.** Su comilla vive en lo alto de una
  caja de línea de `60pt * k`, lo que deja un vacío grande entre la comilla y
  la primera línea del cuerpo. Las cuatro tarjetas que usan esa plantilla
  (03, 06, 12, 18) abren el cuerpo con `#v(-0.6em)` para compensarlo; va en
  `em` para que escale sola con el `size:` de cada una.
- **`blockquote-lateral` justifica por dentro** (`set par(justify: true)`).
  A tamaño de lienzo y con la columna angosta que deja la barra rotada, eso
  parte palabras cada dos líneas. La 19 lo desactiva con un `set par(justify:
  false)` local al inicio del cuerpo (gana por ser posterior).
- **Tipografía on-the-fly dentro del `body`.** La **07** pone `[La
  imputación]` —interpolación editorial, no palabra de Warfield— en redonda
  con `#text(style: "normal")`, contra el resto del cuerpo en itálica. Las
  **17, 18, 19** suman `#text(weight:)` o `tracking:` sobre el
  `#highlight()` para que el énfasis se sienta también en el trazo.

---

El título del ensayo **sí** está ahora en la imagen (es la segunda línea de
la firma): una cita teológica que circula sin referencia es una cita que no
se puede verificar. La columna «Fuente (ensayo)» de la tabla sirve igual
para el copy del post.
