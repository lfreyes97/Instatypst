# Changelog

## [sin publicar] — fusión con `superpelettes` + rename semántico de tokens

Hecho en sesión de Claude Code sobre `rapiquote` (cambios aplicados acá
pero **sin commitear** -- quedan en el working tree). Contexto completo
para quien retome esto: `rapiquote` y este repo compartían el mismo
sistema de color (mismos 96 tokens `familia-NNN`, mismo bug de
contraste). En `rapiquote` se arregló primero y se generalizó en un
paquete hermano, `superpelettes`; esto trae ese arreglo de vuelta acá.

### Arreglado (bug real, no solo estilo)

`theme.typ` y `palettes.typ` reimplementaban, cada uno por su lado, el
mismo cálculo de contraste WCAG -- y las dos copias tenían el mismo
bug: `luminance(c)` llamaba `c.components()` sin forzar `.rgb()`
antes. Para cualquier color en espacio `luma` (`white`/`black`,
literales que `theme.base.colors.white` usa) eso lee mal los canales:
`luminance(black)` daba **0.7152** en vez de **0**.

Confirmado con un caso real del propio repo (`examples/api.typ`,
"Texto legible sobre primary"): con el bug elegía **blanco**; el
contraste correcto da negro a **7.57:1** contra apenas **2.77:1** de
blanco -- la respuesta estaba al revés. Ya corregido: ahora elige
**negro**.

### Cambiado (breaking)

- **`tokens.typ`: 96 → 81 colores, renombrados.** El sufijo numérico
  (`red-650`, `blue-700`...) no representaba nada estandarizado, y
  varias claves distintas resultaban, medidas en OKLCH, el *mismo*
  color real (`blue-700`/`blue-800` diferían en hue < 1° y en croma <
  0.01). Cada nombre nuevo (`coral`, `cielo`, `vino-frío`, `escarlata`...)
  es un color realmente distinto. Mapeo completo viejo → nuevo en el
  comentario de cabecera de `src/tokens.typ`. Los 19 neutros
  (`stone-*`, `slate-*`) conservan su nombre-NNN -- ahí el número sí es
  una escala real de claridad.
  **Cualquier código que llame `token("red-650")` (o cualquier clave
  vieja) con el nombre anterior ahora hace `panic`.**
- **`palettes.get("granates")` y `palettes.get("marino")` devuelven
  colores distintos**, no solo renombrados. Varias de sus 10/5 claves
  viejas colapsaron en el mismo color real al medirlas; se
  reconstruyeron a mano con colores genuinamente distintos para no
  perder la variedad visual de la paleta.
- **Nueva dependencia dura:** `theme.typ`/`palettes.typ` importan
  `luminance`/`contrast`/`is-aa`/`is-aaa`/`readable-on`/`auto-pair`/
  `auto-pair-tinted`/`auto-roles` de `@local/superpelettes:0.1.0` en
  vez de reimplementarlos. Sin ese paquete instalado en el namespace
  `local`, nada que importe `theme.typ`/`palettes.typ` compila (o sea,
  casi todo el paquete). Instalar:
  ```sh
  mkdir -p ~/.local/share/typst/packages/local/superpelettes
  ln -sfn /ruta/a/superpelettes ~/.local/share/typst/packages/local/superpelettes/0.1.0
  ```
  (ver el README de `superpelettes` para su propio `link.sh`.)

### Agregado (no rompe nada)

- `theme.auto-pair(bg)` / `theme.auto-pair-tinted(bg, extra:)` --
  nuevas en el namespace `theme`, no existían antes. Dado cualquier
  color de fondo, eligen el texto (blanco o negro, + candidatos extra
  en la variante `tinted`) de mayor contraste real garantizado.

### Sin cambios

- `src/lib.typ` -- mismos exports de siempre (`theme`, `palettes`,
  `color-tokens`, etc.), nada nuevo ni eliminado a ese nivel.
- Todas las demás funciones de `theme`/`palettes` (`define`, `with`,
  `color`, `font`, `get`, `mix`, `as-theme`, `swatch`, `catalog`...) --
  misma firma, mismo comportamiento.
- `theme.base.colors.primary/secondary/accent` -- mismo hex de siempre
  (`#4f46e5`, etc.), solo cambió el nombre de token interno que los
  resuelve (`indigo-400` → `índigo`, etc.)

### Archivos tocados

`src/theme.typ`, `src/tokens.typ`, `src/palettes.typ`, `demo.typ`
(conteo "Tokens (96)" → "(81)"), `docs/manual.typ` (dos snippets con
claves viejas + conteo), `README.md` (nueva sección "Dependencias" +
instrucciones de instalación local vía symlink).

Verificado compilando los 14 `examples/*.typ`, `demo.typ` (46
páginas), `docs/manual.typ` y `ornamentos/ornamentos.typ` -- todo
compila limpio.
