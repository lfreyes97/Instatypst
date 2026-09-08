# Campaña de lanzamiento — 20 citas de B.B. Warfield

Cada cita es un `.typ` independiente en esta carpeta, listo para compilar a
PNG y publicar. Fuente: *Ensayos de B.B. Warfield sobre el calvinismo y
otros temas* (primera traducción al español).

## Compilar

Una sola imagen:

```bash
typst compile --root . --font-path Fonts campana/01-calvinismo-pureza.typ salida.png
```

Todas de una vez:

```bash
for f in campana/*.typ; do
  base=$(basename "$f" .typ)
  [ "$base" = "_comun" ] && continue   # no es una tarjeta, es el helper compartido
  typst compile --root . --font-path Fonts "$f" "campana/$base.png"
done
```

## `_comun.typ` y el patrón de cada tarjeta

Cada tarjeta sigue el mismo patrón — receta (arriba) separada de contenido
(abajo), usando `.with()` nativo de Typst para no repetir `theme:`/`color:`
en cada llamada:

```typst
#import "../src/lib.typ": *
#import "_comun.typ": warfield-canvas

#let tema = make-theme(paleta: "...", tipografia: "...")
#let cita = blockquote-hero.with(theme: tema, color: tema.colors.primary)

#warfield-canvas(
  cita([texto de la cita...], autor: "B.B. Warfield", fuente: "..."),
  tema,
  size: sizes.twitter, bg-color: tema.colors.white, blob-color: tema.colors.primary, footer-color: gray.darken(45%),
)
```

`_comun.typ` solo evita repetir el handle `"presuposicionalismo.com"` y pasar
`theme: tema` una segunda vez a `cita-canvas` — el resto (paleta, tipografía,
plantilla de blockquote, tamaños, colores de fondo/blob/pie) sigue siendo
decisión de cada tarjeta.

**Tipografía on-the-fly dentro del `body`:** varias tarjetas usan `#set`/
`#text()` locales, dentro del contenido que reciben las `blockquote-*`, para
un matiz que esas funciones no exponen como parámetro:

- **07** — `[La imputación]` (interpolación editorial, no es de Warfield) va
  en redonda con `#text(style: "normal")[...]`, contrastando contra el resto
  del cuerpo en itálica (`blockquote-card` la pone toda en itálica).
- **09, 13, 17, 18, 19** — la frase que sostiene el contraste de la cita, ya
  marcada con `#highlight()`, recibe además `#text(weight: ...)` (o
  `tracking:` en la 09, ver nota abajo) para que el énfasis se sienta en el
  trazo, no solo en el color de fondo.
- **09, nota de fuente estática** — `blockquote-hero` ahí usa Bebas Neue
  (tipografía "brutalista"), una fuente **no variable** de un solo peso:
  pedirle `weight: 900` no hace nada (verificado con diff de píxeles — 0%
  de diferencia). `tracking:` sí funciona en cualquier fuente, variable o
  no, y es lo que usa esa tarjeta.
- **Bug de Typst encontrado armando la 09**: un `;` pegado justo después de
  cerrar un `#función(..)[..]` (sin espacio) no se muestra — Typst lo toma
  como el terminador opcional de esa expresión de código embebida en
  markup, no como texto literal (`.`/`,` no tienen ese problema). Fix:
  forzar el `;` a contenido literal con `#[;]`.

## Sistema de la campaña

- **Twitter/X** (1600×900, `quote-post`): citas cortas y autocontenidas — 1, 2, 5, 9, 13, 17.
- **Instagram cuadrado** (1080×1080, `quote-post`): resto de citas expositivas — 4, 6, 7, 8, 11, 12, 16.
- **Instagram con textura** (1080×1080, `quote-social`, con avatar/iniciales "BW" y comilla decorativa): las de más carga emocional o histórica — 3, 10, 14, 15, 18, 19, 20.
  - 19 y 20 están pensadas como **par** (Darwin/Hodge): mismo estilo visual, y cada una lleva una nota de contexto (`nota-izq`) aclarando que son palabras *sobre* o *citadas por* Warfield, no citas propias — para que no se malinterpreten si circulan sueltas.
- **Paleta por estado de ánimo** (cuatro familias visualmente distintas, verificadas contra el algoritmo de `auto-roles` — no todos los nombres de paleta dan el color que su nombre sugiere, ver nota abajo):
  - `granates` (rojo/vino profundo) → identidad central del calvinismo: 1, 2, 3, 4, 13, 18.
  - `noche-azul` (azul acero/índigo) → exposición doctrinal serena: 5, 6, 9, 11, 12, 17.
  - `vintage` (coral/dorado/crema) → imágenes de amor, anhelo, artesanía: 8, 14, 15.
  - `grises` (neutro) → polémica, historia, distancia crítica: 7, 10, 16, 19, 20.
- **Tipografía**: `editorial-clasico` en las expositivas/cortas, `revival-vintage` en las poéticas (3, 8, 14, 15), `lectura-editorial` en las técnicas/históricas (7, 10, 16, 18, 19, 20).
- **Handle**: `presuposicionalismo.com` en el pie de cada imagen (en `quote-social` va como nota con icono 🌐, porque esa plantilla no trae `footer` propio).
- **Resaltados** (`#highlight`, nativo de Typst) en 5 citas donde el contraste interno de la frase se presta: 9, 13, 17, 18, 19.

> Nota sobre paletas: `auto-roles()` (en `src/palettes.typ`) asigna `primary`/
> `secondary` por saturación, no por lo que sugiere el nombre de la paleta —
> por eso `marino` no se usó aquí (sus colores más saturados son dos rojos,
> no los azules) y se sustituyó por `noche-azul`, verificada visualmente.

## Índice de citas (fuente del ensayo, para el caption)

| # | Plantilla | Fuente (ensayo) |
|---|-----------|------------------|
| 01 | Twitter | ¿Qué es el calvinismo? |
| 02 | Twitter | El calvinismo: significado y usos del término |
| 03 | IG textura | El calvinismo hoy |
| 04 | IG | La teología de Calvino |
| 05 | Twitter | La incapacidad y la exigencia de la fe |
| 06 | IG | La expiación |
| 07 | IG | La imputación |
| 08 | IG | La predestinación |
| 09 | Twitter | La elección |
| 10 | IG textura | "Redentor" y "redención" |
| 11 | IG | La persona y la obra del Espíritu Santo (Salmo 51) |
| 12 | IG | La persona y la obra del Espíritu Santo (La guía del Espíritu) |
| 13 | Twitter | La persona y la obra del Espíritu Santo (El Espíritu de fe) |
| 14 | IG textura | La persona y la obra del Espíritu Santo (Fortalecimiento espiritual) |
| 15 | IG textura | La persona y la obra del Espíritu Santo (El amor del Espíritu Santo) |
| 16 | IG | La polémica del pedobautismo |
| 17 | Twitter | Apologética |
| 18 | IG textura | El sobrenaturalismo cristiano |
| 19 | IG textura | La vida religiosa de Charles Darwin |
| 20 | IG textura | La vida religiosa de Charles Darwin (contraste con Charles Hodge) |

El título del ensayo no está en la imagen — es contexto para el copy del
post, no parte del diseño visual (así queda cada tarjeta limpia y reusable
fuera de contexto).
