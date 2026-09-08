# Oportunidades de mejora — Instatypst

Análisis del proyecto completo (`src/*.typ`, `docs/manual.typ`, `cristianamente.typ`, `typst.toml`),
2026-09-01. Los tres bugs críticos de la sección 🔴 están verificados compilando repros mínimos con
`typst 0.15.1`; el resto son hallazgos de lectura de código, concretos y con archivo:línea.

---

## 🔴 Bugs que rompen la compilación (confirmados compilando)

### 1. `capitular(size: ...)` falla siempre
**[src/dropcaps.typ:190](../src/dropcaps.typ#L190)**

`_dimensionado` hace `text(..args)` cuando se pasa `size:` explícito, pero `args` no incluye
`letra` (el cuerpo de la letra capitular, que es un parámetro posicional aparte de
`_dimensionado`). Falta `text(..args, letra)`.

```
#capitular(size: 40pt)[Hola mundo, esto es una prueba.]
→ error: missing argument: body   (src/dropcaps.typ:190)
```

Cualquier uso documentado o futuro de `size:` en `capitular()` está roto, no es un caso raro.

### 2. `capitular[A]` (cuerpo de una sola letra) crashea
**[src/dropcaps.typ:131](../src/dropcaps.typ#L131)** (vía 175-180)

`_a-texto(sig)` se llama en el segundo `while` de `_extraer` sin comprobar `sig == none`, y
`_inicial()` legítimamente devuelve `none` cuando el contenido se agota.

```
#capitular[A]
→ error: type none has no method `has`   (src/dropcaps.typ:131, vía _inicial en :175)
```

Mismo crash con `capitular[A.]` (letra + puntuación que se consume entera, rama de la línea 179).
La única vía sin crash es pasar `letra:` explícito, que evita `_extraer` por completo.

### 3. `translit()` sin `color:` falla siempre
**[src/idiomas.typ:40](../src/idiomas.typ#L40)**

```typst
#let translit(body, color: none) = text(style: "italic", fill: color)[#body]
```

`text(fill:)` no acepta `none` (solo color/gradient/tiling).

```
#translit[bereshit]
→ error: expected color, gradient, or tiling, found none   (src/idiomas.typ:40)
```

`translit` se reexporta como API pública desde `lib.typ`. Solo "funciona" hoy porque
`interlineal()` siempre le pasa un color ya resuelto — cualquier uso standalone revienta.

---

## 🟠 Bugs de lógica (compilan, resultado incorrecto)

### 4. El bug de luminancia ya arreglado en `theme.typ` sigue vivo en `palettes.typ`
**[src/palettes.typ:61-67](../src/palettes.typ#L61-L67)**

El commit `a7e344f` arregló `_chan()`/`luminance()`/`contrast()` en `theme.typ` (dividían por
`100` en vez de por `100%`, aplastando el canal dos veces — blanco puro daba luminancia ~0.01 en
vez de 1.0). `palettes.typ` tiene su **propia copia independiente** de `luminance()` que nunca se
tocó y arrastra el mismo bug:

```typst
#let _chan(v) = v / 100          // dead code, nadie la llama

#let luminance(c) = {
  ...
  let f(v) = {
    let u = v / 100              // el MISMO bug: divide por 100, no por 100%
    if u <= 4.045% { u / 12.92 } else { calc.pow((u + 5.5%) / 105.5%, 2.4) }
  }
  ...
}
```

Alimenta `auto-roles()` (asigna `dark`/`light`/`primary`/`secondary`/`accent` a las 15 paletas
curadas) y se expone públicamente como `palettes.luminance` (documentado en
`docs/manual.typ:693`). El orden dark/light no se invierte por casualidad — la función sigue
siendo monótona porque casi siempre cae en la rama lineal — pero el **valor numérico** que
devuelve es incorrecto e inconsistente con `theme.luminance()` (ya corregida).

**Recomendación:** eliminar la reimplementación y que `palettes.typ` importe `luminance`/
`contrast` de `theme.typ`, en vez de mantener dos copias de la misma fórmula que ya divergieron
una vez.

### 5. `bq-mark(size:, detras: true)` ignora `size:`
**[src/blockquotes.typ:415-422](../src/blockquotes.typ#L415-L422)** (se movió de `social.typ` a
`blockquotes.typ` en el split del "sistema de legos" — el bug viajó con la función sin arreglarse;
reconfirmado el 2026-09-08 con `bq-mark("\u{201C}", size: 40pt, detras: true)`: renderiza a ~180pt
igual que antes)

```typst
#let bq-mark(texto, size: 60pt, fill: none, theme: theme.base, detras: false) = {
  let fill = if fill == none { theme.colors.primary.transparentize(75%) } else { fill }
  if detras {
    place(dx: -10pt, dy: -30pt)[#text(font: theme.fonts.display, size: 180pt, ...)]  // ← 180pt fijo
  } else {
    text(font: theme.fonts.display, size: size, fill: fill, ...)                      // ← aquí sí
  }
}
```

`bq-mark("\u{201C}", size: 300pt, detras: true)` acepta `size: 300pt` y lo descarta en silencio,
siempre renderiza a `180pt`. Además, en esa rama se aplica un `.transparentize(30%)` extra sobre
el `fill` ya resuelto — si el llamador pasó `fill:` explícito esperando usarlo tal cual, termina
más transparente de lo pedido solo en modo `detras`.

### 6. `event-post()` con `size:` distinto de `story` rompe el fondo
**[src/social.typ:389-403](../src/social.typ#L389-L403)**

El segundo blob decorativo usa `dy: 1300pt` fijo (la altura de `sizes.story`, el default), a
diferencia de `quote-post`/`stat-card`, que sí escalan la posición en función de `size:`. Con
`event-post(..., size: sizes.instagram)` o `sizes.linkedin`, el blob queda completamente fuera
del canvas — invisible, sin error ni aviso.

### 7. Defaults de color que no pasan por el tema
**[src/social.typ:123](../src/social.typ#L123)** (`footer()`), y también `subhead()` (:114),
`stat()` (:260), `avatar-row()` (:249)

```typst
#let footer(handle, logo: none, color: white, theme: theme.base) = ...
```

El resto de ~25 funciones del archivo resuelve su color con el patrón
`let X = if X == none { theme.colors.Y } else { X }` para que un tema personalizado se propague.
`footer()` y las otras tres rompen ese contrato usando literales (`white`, `gray.darken(...)`)
en vez de derivarlos del `theme:` que sí reciben como parámetro. Con un tema custom cuyo rol
"claro" no sea blanco puro, el pie de marca sigue saliendo en `#FFFFFF` puro.

### 8. `interlineal(idioma: ...)` no valida el valor
**[src/idiomas.typ:52-71](../src/idiomas.typ#L52-L71)**

El parámetro `idioma` no se valida contra `"griego"|"hebreo"|"latin"`. Un typo (`"hebreo "`,
`"hebrew"`, `"latín"`) cae silenciosamente en la rama `else`: fuente, `lang: "la"` y layout LTR
equivocados sin ningún error — especialmente grave para hebreo, que pierde el RTL sin aviso.

### 9. `fondo-editorial()` no valida el contraste del color de links
**[src/articulo.typ:48-51](../src/articulo.typ#L48-L51)** y su uso en **:89**

`fondo-editorial(t)` decide entre `light`/`white` comprobando AA solo de `primary` y `dark`
contra el fondo candidato, pero `articulo()` pinta los links con `t.colors.secondary` (línea 89),
que nunca entra en esa validación. En una paleta monocromática los links pueden quedar ilegibles
aunque el resto del texto pase AA.

### 10. `progress()` / `carousel-slide()` sin guarda de división por cero ni clamp
**[src/social.typ:265-271](../src/social.typ#L265-L271)**, uso en `n / total` (:333)

`total: 0` produce división por cero. Si `n > total` (off-by-one al enumerar páginas), `pct > 1`
y el `box` interno recibe un ancho mayor al 100% del contenedor, sin clamp ni validación.

---

## 🟡 Documentación desincronizada con el código

### 11. Tabla de migración de `docs/manual.typ:718` es incorrecta para 2 de 3 funciones

Dice que `definicion`, `ver-tambien` y `grid-citas` de `cristianamente.typ` "no tienen puerto
directo". Falso para dos de ellas:

- `cristianamente.typ:256` `definicion(...)` es prácticamente un port de
  `blockquote-definition(...)` en [src/social.typ:801](../src/social.typ#L801) — mismos campos
  (badge de origen + pills de relacionados).
- `cristianamente.typ:498` `grid-citas(tarjetas, columnas: 2)` es idéntica a
  `blockquote-grid(tarjetas, columnas: 2)` en [src/social.typ:688](../src/social.typ#L688).

Solo `ver-tambien` (`cristianamente.typ:305`) de verdad carece de equivalente. El manual
desinforma sobre la cobertura real de `social.typ`.

### 12. Referencias de línea desactualizadas en `docs/manual.typ`

- Línea 154 cita `social.typ:24` para la nota sobre closures de `palette`/`fonts`; la nota
  empieza en la línea 12 y la definición real (`#let palette = theme.base.colors`) está en la
  línea 35.
- Línea 190 cita `src/theme.typ:109`; el comentario del fix empieza en la línea ~111 y
  `luminance()` en la 120.

---

## 🔵 Inconsistencias de API

- **Mensajes de error no uniformes.** `tokens.token()`, `palettes.get()`, `font-pairings`
  sugieren claves válidas al fallar (`"— ver tokens.keys()"`, `"— disponibles: " + ...`).
  `theme.color()`/`theme.font()` ([src/theme.typ:92,97](../src/theme.typ#L92)) solo hacen
  `panic("color desconocido: " + key)`, sin listar alternativas — mismo tipo de error, trato
  distinto dentro del mismo sistema.
- **`bg-color:` vs `color:`.** `avatar()`/`avatar-row()`
  ([src/social.typ:226,240](../src/social.typ#L226)) usan `bg-color:`; el resto de ~25 funciones
  del archivo usa `color:` para el mismo concepto — obliga a traducir el nombre al reenviarlo
  (se nota en `blockquote-avatar`, [src/social.typ:661](../src/social.typ#L661)).
- **`alto:` vs `capitular-alto:`.** `primer-parrafo` ([src/articulo.typ:119](../src/articulo.typ#L119))
  usa `alto:` (igual que `capitular()` de dropcaps.typ), pero `pasaje` en
  [src/scripture.typ:63,79](../src/scripture.typ#L63) expone el mismo control como
  `capitular-alto:`. Dos nombres para el mismo parámetro en dos plantillas hermanas.
- **Colisión de nombre `articulo()`.** `cristianamente.typ:82` define su propio
  `articulo(titulo:, subtitulo:, ..., paper: "a4", modo-oscuro:, doc)`, con firma incompatible
  con `src/articulo.typ:62` (`paleta:`, `tipografia:`, `paper: "a5"`, sin `subtitulo:` ni
  `modo-oscuro:`). No rompe nada porque `src/` nunca importa `cristianamente.typ`, pero es una
  trampa si alguien copia código del legado pensando que aplica al paquete actual.
- **`theme.color()` accesor validado, pero casi nunca usado.** `social.typ` (~30 funciones)
  siempre indexa `theme.colors.X`/`theme.fonts.X` directo en vez de pasar por
  `theme.color()`/`theme.font()`, evitando el `panic` descriptivo que el propio sistema ya
  definió para claves faltantes.

---

## ⚪ Código muerto

- **[src/font-tokens.typ:112-118](../src/font-tokens.typ#L112)** — namespace `font-tokens`
  autorreferencial, nunca importado (todo el proyecto usa `import "font-tokens.typ" as
  font-tokens`, que ya expone `.tokens`/`.token`/`.family` directamente).
- **[src/font-pairings.typ:14](../src/font-pairings.typ#L14)** — importa `by-category` y no lo
  usa; es la única referencia a esa función en todo el proyecto fuera de su propia definición.
- **[src/scripture.typ:36-39](../src/scripture.typ#L36)** — `set-body-font(doc)` no se usa en
  ningún otro archivo (`lib.typ` solo importa `scripture, vs, ch, pasaje`).
- **[src/palettes.typ:61](../src/palettes.typ#L61)** — `_chan()` global es código muerto,
  sombreada por una `f()` local (ver hallazgo #4).

---

## Notas menores

- `scripts/nueva-plantilla.py` no está en el `exclude` de `typst.toml` (junto a `Fonts`,
  `examples`, `cristianamente.typ`, `demo.typ`, `demo.pdf`, `docs`) — se publicaría
  innecesariamente en el paquete, y por defecto asume una carpeta `examples/` que no existirá
  en la instalación real.
- `demo.pdf`/`docs/manual.pdf` ya están cubiertos por `*.pdf` en `.gitignore`; su mención
  explícita en `exclude` es redundante (inofensivo).
- El `exclude` de `typst.toml` en sí **no rompe** el paquete publicado: `src/lib.typ` y todo lo
  que importa transitivamente es autocontenido dentro de `src/` (verificado por grep, sin
  `#import` hacia `cristianamente.typ`, `examples/` ni `docs/`).

---

## Causa raíz transversal

No existe carpeta `tests/` en el proyecto. Los tres bugs críticos (#1-3) son casos de uso directos
de funciones públicas documentadas, no rincones oscuros — un puñado de `#assert.eq`/repros como
los usados para verificar esta lista los habría atrapado antes de publicar. Ejemplo mínimo de lo
que haría falta:

```typst
#assert.eq(theme.luminance(white), 1.0)
#assert.eq(theme.luminance(black), 0.0)
#assert.eq(theme.contrast(black, white), 21.0)
#capitular(size: 40pt)[Prueba]
#capitular[A]
#translit[bereshit]
```

---

## 🔴 Auditoría de `blockquotes.typ` y del ejemplo de `theme.define()` (2026-09-08)

`blockquotes.typ` no existía como archivo propio en el análisis del 2026-09-01 (las `blockquote-*`
vivían en `social.typ`); esta sección audita el split + el "sistema de legos" (`bq-frame`/
`bq-attribution`) agregados después, más un hallazgo transversal encontrado de paso al armar los
repros. Todo lo de acá está verificado compilando con `typst 0.15.1`, no solo leído.

### 13. `blockquote-callout()` ignora `theme:` para los colores por defecto de variante
**[src/blockquotes.typ:359-361](../src/blockquotes.typ#L359-L361)**

```typst
#let defaults = (tip: palette.accent, info: palette.primary, warn: rgb("#EAB308"), hand: palette.secondary)
#let color = if color == none { defaults.at(variante, default: palette.accent) } else { color }
```

`palette` viene de `#import "social.typ": radius, avatar-row, palette` (línea 13) —
`social.typ:35` lo define como `#let palette = theme.base.colors`, fijo a **`theme.base`**, sin
relación con el parámetro `theme:` que la propia función recibe. Repro:

```typst
#let mi-tema = (theme.define)("mi-tema", colors: (accent: rgb("#00ff00")))
#blockquote-callout(variante: "tip", theme: mi-tema)[...]
→ el ícono y la barra salen ámbar (theme.base.colors.accent), no verde (mi-tema.colors.accent)
```

Es exactamente la clase de bug que el propio encabezado del archivo dice evitar ("`theme:`
siempre presente y reenviada a cualquier componente interno", líneas 22-25) y que motivó el
refactor de `social.typ` con parámetro `theme:` explícito en todas partes — pero esta función
nueva la reintrodujo. Cualquier llamada a `blockquote-callout(theme: <tema-custom>, variante: "tip"|"info"|"warn"|"hand")`
sin `color:` explícito ignora el tema pasado.

**Fix:** reemplazar los 4 `palette.*` por `theme.colors.*` (usando el `theme:` que ya recibe la
función), igual que el resto del archivo.

### 14. `bq-frame(tipo: "hard")` acepta `theme:` pero nunca lo usa
**[src/blockquotes.typ:469-477](../src/blockquotes.typ#L469-L477)**

```typst
#block(..., fill: black, ...)[ #block(fill: white, stroke: 3.5pt + black, ...)[#body] ]
```

Repro: `bq-frame(tipo: "hard", theme: mi-tema)` con `mi-tema.colors.primary` verde renderiza igual
que con `theme.base` — negro/blanco puros, sin ninguna referencia a `theme.colors`. Puede ser
intencional (el brutalismo pide negro/blanco fijos sin importar el tema), pero entonces `theme:`
no debería aceptarse en silencio para esa rama — o documentarlo explícitamente en el comentario de
la función, que hoy no lo aclara. Las ramas `"soft"`/`"glass"` sí usan `theme.colors.white`/
`color` (este último ya viene resuelto por el llamador).

### 15. `bq-attribution(modo: "mono")` fija el texto en blanco sin chequeo de contraste
**[src/blockquotes.typ:446](../src/blockquotes.typ#L446)**

```typst
box(fill: theme.colors.primary, ...)[#text(..., fill: white, label)]
```

El fondo de la caja sí usa `theme.colors.primary` (confirmado: con un tema custom, la caja cambia
de color correctamente) — pero el texto encima es `white` fijo, no pasa por `theme.is-aa()` ni por
ningún chequeo. Con un tema cuyo `primary` sea claro (p. ej. un amarillo pastel), el texto queda
ilegible. Mismo espíritu que el hallazgo #9 (`fondo-editorial()` no valida contraste de
`secondary`), pero acá adentro de un lego nuevo.

### 16. El ejemplo documentado de `theme.define()`/`theme.with()` no compila tal cual está escrito
**[README.md:145](../README.md#L145)**, **[docs/manual.typ:219-220,228,364](../docs/manual.typ#L219)**,
**[src/theme.typ:8](../src/theme.typ#L8)**, **[src/social.typ:9](../src/social.typ#L9)**

```typst
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
→ error: cannot directly call dictionary keys as functions
  hint: to call the stored function, wrap the field access in parentheses: (theme.define)(..)
```

`theme` se importa como **valor** (`#import "theme.typ": theme` — un dict con `base`/`define`/
`with`/`color`/`font`/... adentro), no como **namespace** (`#import "theme.typ" as theme`, el
patrón que sí usan `color-tokens`/`font-tokens`). Typst no permite `dict.key(args)` directo sobre
un dict cuyo valor es una función — solo sobre bindings de un módulo importado con `as`. Confirmado
reproduciendo en aislado, importando `theme.typ` directo (sin pasar por `lib.typ`) — no es un
artefacto de `lib.typ`.

Esto no rompe la compilación de `docs/manual.typ` (los ejemplos están dentro de fences ` ```typ `,
se muestran como texto, no se ejecutan) — pero significa que **cualquier usuario que copie el
ejemplo documentado de la API principal (crear un tema custom) tal cual está escrito, revienta**.
El resto del proyecto ya conoce el workaround (`(palettes.as-theme)("neon")` en
`examples/blockquotes.typ:111`) pero nunca se aplicó a la documentación de `theme.define`/`theme.with`.

**Fix real (no solo de docs):** restructurar `theme.typ` para exportar sus funciones directo
(no envueltas en un dict `theme`) e importarlo `as theme` en todo el proyecto — el mismo patrón
que `font-tokens.typ`/`tokens.typ` ya usan con éxito. Es un cambio con radio de impacto grande
(cada archivo de `src/` hace `#import "theme.typ": theme`), así que documentarlo aquí en vez de
aplicarlo de una — necesita decisión explícita antes de tocar ~10 archivos.

---

## Prioridad sugerida

1. Arreglar los 3 bugs críticos (#1-3) — cambios pequeños, ya verificados con repros.
2. Arreglar #13 (`blockquote-callout` ignora `theme:`) — mismo nivel de gravedad que #1-3: rompe
   el contrato central del proyecto ("`theme:` siempre se respeta"), no solo un caso raro.
3. Consolidar luminancia/contraste en un solo módulo (#4) y borrar la copia de `palettes.typ`.
4. Añadir un `tests/` mínimo con los repros de esta lista para que no vuelvan a colarse.
5. Decidir sobre #16 (namespace de `theme.typ`) antes de seguir documentando `theme.define`/
   `theme.with` en más sitios — cada ejemplo nuevo repite el mismo error.
6. El resto (🟠 lógica, 🟡 docs, 🔵 API, ⚪ código muerto, #14/#15) por orden de impacto según se
   use cada función en producción.
