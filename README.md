# instatypst

Sistema de diseño en Typst: temas de color y tipografía, plantillas para
redes sociales, letras capitulares y bloques de cita bíblica.

## Documentación

- **`demo.pdf`** — catálogo visual de todo lo exportado por `src/lib.typ` (lo que *se ve*). Fuente: `demo.typ`.
- **`docs/manual.pdf`** — manual narrativo (cómo *se usa*): instalación, `theme` API, paletas, tipografía, capitulares, editorial, escritura, idiomas, canvas/componentes, plantillas y blockquotes. Fuente: `docs/manual.typ`.

Compilar cualquiera de los dos:

```bash
typst compile --root . --font-path Fonts demo.typ
typst compile --root . --font-path Fonts docs/manual.typ
```

## Estructura

```
src/                  código del paquete (entrypoint: src/lib.typ)
  theme.typ           API de temas — colores + fuentes, validación, derivación
  tokens.typ          registro de 96 colores individuales nombrados
  palettes.typ        15 paletas curadas + auto-asignación de roles
  font-tokens.typ     registro de 49+ fuentes verificadas (familia real, ejes variables)
  font-pairings.typ   8 parejas tipográficas curadas (display/body/mono)
  dropcaps.typ        letra capital automática (capitular())
  articulo.typ        plantilla editorial: paleta + pareja + capitular en un tema
  scripture.typ       bloques de cita bíblica (pasaje(), vs(), ch())
  idiomas.typ         lat/gr/he, translit e interlineal
  social.typ          plantillas de canvas (Instagram/stories) + blockquotes
demo.typ              catálogo visual (no forma parte del paquete)
docs/manual.typ       manual narrativo (no forma parte del paquete)
examples/             ejemplos de uso de cada módulo (no forman parte del paquete)
Fonts/                fuentes usadas por el proyecto (no forman parte del paquete)
cristianamente.typ    paquete aparte, no integrado — conservado como referencia
```

## Generar un archivo desde una plantilla

`scripts/nueva-plantilla.py` escribe un `.typ` de arranque para cualquiera
de las 12 plantillas (10 de `social.typ` + `articulo` + `pasaje`), con
marcadores de posición listos para editar:

```bash
python3 scripts/nueva-plantilla.py --listar
python3 scripts/nueva-plantilla.py announce-post mi-post.typ \
  --paleta terracota --tipografia editorial-clasico \
  --campo tagline=NUEVO --campo title="Mi título"
```

Por defecto genera `#import "@local/instatypst:0.1.0": *` (asume el
paquete instalado, ver abajo); usa `--repo` para un import relativo si
vas a dejar el archivo dentro de `examples/` de este mismo repo. Con
`--compilar` lo compila de una vez (usa `Fonts/` de este repo por
defecto; `--fonts <ruta>` para otra).

## Uso

### Como paquete instalado localmente

Ya está copiado a `~/.local/share/typst/packages/local/instatypst/0.1.0/`
(sin `Fonts/`, sin `examples/` — solo `src/` + `typst.toml`, igual que
quedaría un paquete real). Se importa desde cualquier proyecto en esta
máquina, sin rutas relativas:

```typst
#import "@local/instatypst:0.1.0": *
```

Si copias `src/` a otra máquina, hay que repetir la instalación ahí
(`cp -r src typst.toml <destino>/packages/local/instatypst/0.1.0/`).

**Fuentes:** el paquete no trae las fuentes consigo — eso no es parte de
cómo funciona el sistema de paquetes de Typst. Quien lo use necesita pasar
`--font-path` apuntando a una copia de `Fonts/` (o tener esas familias
instaladas en el sistema).

### Dentro de este repo (desarrollo)

```typst
#import "src/lib.typ": *
```

Los archivos de `examples/` ya están así. Como importan hacia arriba
(`../src/lib.typ`), hace falta fijar la raíz del proyecto al compilarlos:

```bash
typst compile --root . --font-path Fonts examples/articulo.typ
```

## `lib.typ` — qué expone

- `theme` — API de temas (`theme.define`, `theme.with`, `theme.color`, `theme.contrast`, …)
- `palettes` — biblioteca de paletas (`palettes.get`, `palettes.mix`, `palettes.as-theme`, `palettes.catalog`)
- `pairings` — biblioteca de parejas tipográficas (mismo patrón que `palettes`)
- `color-tokens` / `font-tokens` — los dos registros de tokens, con nombre en vez de aplanados (ambos exportan un dict `tokens`, así que se mantienen namespaced para no chocar)
- `capitular` — letra capital (de `dropcaps.typ`)
- `articulo`, `primer-parrafo`, `make-theme`, `fondo-editorial` — plantilla editorial
- `scripture`, `vs`, `ch`, `pasaje` — bloques de cita bíblica
- todo lo de `social.typ`: `canvas`, `badge`, `headline`, `subhead`, `footer`, `quote-post`, `announce-post`, `tip-card`, `carousel-cover`, `carousel-slide`, `stat-card`, `event-post`, `testimonial-post`, `poll-story`, `versus-post`, `blockquote-*` (9 tipos + `blockquote-grid`/`blockquote-paralelo`/`blockquote-lateral`), `avatar`, `avatar-row`, `stat`, `progress`, `divider`
- `lat`, `gr`, `he`, `translit`, `interlineal` — capa de idiomas (`idiomas.typ`)

## Nota sobre temas y `theme:`

Cada función que depende de color o tipografía acepta un parámetro
`theme:` explícito (por defecto `theme.base`). **No** sombrees
`palette`/`fonts` reasignándolos después de importar — no tiene efecto:
las funciones de este paquete resuelven esos nombres por closure contra
su propio archivo en el momento en que se definieron, no contra lo que
reasignes en tu documento. Pasa el tema por parámetro:

```typst
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
#announce-post("...", [...], [...], "@handle", theme: marca)
```
