# Protocolo de traducción de un preset de v1

Para quien traduce a V2 un preset que aún está en v1 (persona o agente). Es lo
aprendido con `swiss`, `plain` "post" y `bauhaus`. Si algo de aquí choca con
`DEUDA.md` §1, manda `DEUDA.md`.

## Leer antes

1. `DEUDA.md` §1: la ontología (§1.1), los criterios de nombres (§1.2), las reglas
   (§1.4), los casos 1–4 (§1.5), el tamaño y la unidad `u` (§1.6) y el tema (§1.7).
2. `spec/vocabulario.md` y `src/elements.typ`: los únicos nombres de elementos.
3. `spec/decisiones-traduccion.md`: **manda sobre cualquier tabla** donde esta tenga
   `?` o se equivoque.
4. `src/plain/scaffold.typ` (la base) y `src/presets/bauhaus/bauhaus.typ` (el modelo:
   escala `k`, roles propios, textura pendiente, elementos como argumentos).
   `src/presets/swiss/swiss.typ` es el otro modelo.
5. El preset en v1: está en la rama `main` y en la etiqueta `v1-final`. Se lee con
   `git show v1-final:src/<archivo>`; no se edita nada de v1.

## La política

- **Cada opción de v1 tiene destino**: un elemento, una propiedad de un elemento, un
  rol del tema, una opción del preset o de `frame`, un recurso o el contenido suelto.
  Los posicionales de v1 pasan a ser elementos (`frase` → `#main[…]`, `remate` →
  `#conclusion[…]`).
- **No se inventa.** Un elemento, rol, recurso u opción que no esté en el vocabulario
  ni en las decisiones no se crea: se mantiene por dentro el comportamiento por
  defecto de v1 y se anota como «decisión pendiente». Tampoco se inventan valores: si
  v1 no tenía un color, no se le pone uno (el rol `guide`, por ejemplo, lo deriva
  `modules/color`; no hace falta darlo).
- **Elementos como argumentos.** Todo elemento que el preset reconoce se acepta
  también como argumento (`author: […]`): `make` termina en `..elements` y lo pasa al
  scaffold en `elements:`. `author` y `dates` son **elementos**, no opciones.
- **Roles propios del tema** (los que mandan a `tema:X` fuera de los cinco): se
  declaran en el scaffold con `extra-roles: (…)`, con su valor de v1 en el tema por
  defecto; las reglas los leen en `ctx.tm.X`. Pasan por `modules/color` como los cinco.
- **Recursos** (`recurso:X`): no existen todavía. Lo que v1 dibujaba por defecto se
  dibuja siempre, por dentro; si v1 permitía apagarlo, se anota como pendiente.
- **Escala `k`.** Se conserva la escala de v1 (normalmente
  `k = mín(ancho/1080, alto/1350)`) para lograr la paridad; pasar a `u` es ajuste fino
  posterior (`DEUDA.md` §3.1). Los números de la API (`main(size: 62)`) son `u` vía
  `ctx.len`.
- **Fuentes** por `fonts` / `default-fonts` del scaffold. Si ninguna pareja de
  `src/modules/typography/font-pairings.typ` trae las familias de v1, no se agrega una:
  se usan tokens o familias sueltas por `ctx.font(…)` y se anota.
- **Nombres** semánticos en inglés, nunca en español, nunca chocando con la librería
  estándar de Typst.

## La forma

- `src/presets/<nombre>/<nombre>.typ` sobre `scaffold` (`rules: ctx => …`). Si tiene
  variantes: `variants/<variante>.typ`, cada uno exporta `variant`. Piezas de v1 que
  necesita y no están en V2 (por ejemplo `_texto`, `_huecos`): a
  `src/resources/motifs/` si son motivos de dibujo, o al preset si son solo suyas.
- Imports: el scaffold, `frame`, `resources/` y `modules/` si hace falta. **Nunca otro
  preset.**
- Al final del archivo: `#let preset = (name: "<nombre>", make: make, variants: …)` y
  `#let <nombre> = frame.with(preset: preset)`.
- Registro en `src/lib.typ`: una línea de import y una entrada en `_presets`. Nada más.
- **No se toca**: el scaffold, `frame`, `plain`, `core`, `modules`, `elements.typ`, el
  vocabulario ni las decisiones. Si hace falta cambiar algo de eso, se para y se
  explica en el informe.

## Trampas conocidas

- **Un nombre local tapa a Typst.** `top`, `bottom`, `left`, `right`, `center`,
  `floor`… como variables dentro de las reglas rompen `place(top + left, …)` con un
  error confuso. Usar otros nombres (`y-top`, `line-start`).
- **Dos tandas de `- …` separadas por una línea en blanco son una sola lista** en
  Typst. Para varios grupos, `#list(…)` por grupo.
- **`context` es una palabra reservada**: no sirve como nombre de opción ni de clave.

## La verificación

Aquí no hay harness. La aceptación sigue siendo **0 píxeles frente a v1**, y se mide
a mano:

1. Compilar el ejemplo de v1 del preset (`examples/presets/<nombre-v1>.typ`) en la
   etiqueta `v1-final`, con un `git worktree` de esa etiqueta, a PNG con
   `--ppi 30` y `--font-path Fonts`. Si el ejemplo importa un nombre que el paquete no
   exporta en la raíz, se toma de `carteles` (`carteles.<x>`); si le falta un archivo
   (por ejemplo `avatar.jpg`), se le da la ruta correcta o se deja ese caso fuera y se
   explica.
2. Escribir `tests/<nombre>.typ` con los mismos casos en sintaxis V2, una página por
   caso y en el mismo orden, y compilarlo con las mismas opciones.
3. Comparar cada página por su hash (`sha256sum`). Comprobar antes que dos renders
   seguidos del mismo archivo dan hashes idénticos.
4. También se escribe `tests/azucar-<nombre>.typ`: la forma explícita
   (`frame(preset: "<nombre>")`) y la abreviada (`<nombre>(…)`) deben dar la misma
   página.
5. **El formato por defecto:** si en v1 el `formato` por defecto no era retrato
   (1080×1350), el descriptor lo declara: `#let preset = (name:, make:, variants:,
   artboard: "cuadrado")`.
6. **El tema:** como en v1, un tema parcial conserva los roles del preset; `quiet` y
   `guide` solo se derivan si nadie los da. Los casos de v1 que pasan solo algunos
   colores se traducen con esos mismos colores, sin agregar los demás.

Un caso que necesita algo sin decidir queda fuera y se explica; no se simula. Si una
paridad no llega a 0 px tras 5 o 6 intentos, se para y se informa qué difiere.

## El informe

1. Archivos creados y cambiados.
2. La traducción aplicada: opción de v1 → destino, una línea por opción, marcando lo
   no implementado.
3. El resultado de cada caso del preset (páginas idénticas / distintas).
4. Decisiones pendientes: cada una, qué hacía v1 y qué se hizo mientras.
5. Fricciones con el scaffold o la arquitectura (archivo y línea).
6. El hash del commit (sin push ni merge).
