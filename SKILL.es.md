---
name: instatypst
description: Crear contenido con el paquete Typst Instatypst (carruseles de Instagram, posts de cita/anuncio/dato/testimonio, presets de carteles, fleurones, fondos de curvas continuas, citas bíblicas, capitulares). Usa esta skill cuando el usuario trabaje con fuentes de Instatypst, pida carruseles, citas, carteles, capitulares o cualquier cosa que se compile desde este repo — aunque no nombre el paquete explícitamente.
---

# Instatypst — crear contenido con el paquete

Instatypst es un sistema de diseño en Typst: temas de color, parejas
tipográficas, plantillas para redes sociales, carteles editoriales,
fleurones, curvas, bloques de cita bíblica y capitulares. Esta skill es
para **usar** el paquete y producir contenido, no para desarrollar `src/`.

## 1 · Instalación

El paquete está instalado como paquete local de Typst (symlinks en vivo,
así que los cambios en `src/` aplican de inmediato):

```sh
mkdir -p ~/.local/share/typst/packages/local/instatypst/0.1.0
ln -sfn "$(pwd)/src" ~/.local/share/typst/packages/local/instatypst/0.1.0/src
ln -sfn "$(pwd)/typst.toml" ~/.local/share/typst/packages/local/instatypst/0.1.0/typst.toml
```

Importar desde cualquier documento de esta máquina:

```typst
#import "@local/instatypst:0.1.0": *
```

Dentro de este repo (p. ej. archivos bajo `examples/`, `trabajos/`) se usa
import relativo, lo que exige compilar con `--root .`:

```typst
#import "src/lib.typ": *        // desde la raíz del repo
#import "../../src/lib.typ": *  // desde trabajos/<serie>/
#import "../src/lib.typ": *     // desde examples/
```

**Fuentes:** el paquete no trae fuentes (`typst.toml` excluye `Fonts/`;
solo viajan `src/` + `typst.toml`). O se instalan las familias en el
sistema (esta máquina las tiene en `~/.local/share/fonts/instatypst/`) o
se pasa el bundle del repo explícitamente:

```sh
typst compile --root . --font-path Fonts <archivo.typ> <salida.pdf>
```

## 2 · Recetas de compilación

Cada `.typ` en `trabajos/` lleva su comando de compilación en un
comentario de cabecera — seguirlo siempre. Patrones generales:

```sh
# Prueba en PDF (revisar diagramación, leer texto)
typst compile --root . <archivo.typ> <salida.pdf>

# PNG para Instagram, un archivo por página/lámina a 2160px
typst compile --root . <archivo.typ> "salida/<nombre>-{p}.png" --ppi 144

# Serie completa de campaña (solo láminas numeradas; _comun.typ/logo.typ son módulos)
bash trabajos/campana/compile-all.sh
```

Notas:

- `--root .` es obligatorio para archivos del repo: importan hacia arriba
  (`../src/lib.typ`) y Typst los restringe a la raíz del proyecto.
- Las láminas pesadas (1080×1350pt con SVG por capas) pueden tardar
  minutos — lanzar en segundo plano y revisar; log vacío + PNG frescos
  significa éxito.
- Las salidas están en gitignore (`*.pdf`, `salida/`,
  `trabajos/*/*.png`): nunca versionar renders, solo fuentes.
- `examples/` documenta la API; `trabajos/<serie>/` guarda obras
  terminadas de varias láminas, una carpeta por serie (ver
  `trabajos/README.md`).

## 3 · Sistema de temas (leer antes de estilizar nada)

Claves de `theme.base` — toda función de estilo acepta `theme:` y usa
esta base por defecto:

```typst
colors: primary, secondary, accent, dark, light, white
fonts:  display: ("Poppins", "Urbanist", "Outfit"),
        body: ("Inter", "DM Sans", "Public Sans", "Liberation Sans")
```

Derivar, nunca reasignar:

```typst
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
#announce-post("...", [...], [...], "@handle", theme: marca)
```

Reasignar `palette`/`fonts` después de importar se ignora en silencio —
las funciones del paquete resuelven esos nombres por closure al
definirse. Relacionados: `palettes.get("terracota")` (ante nombre
desconocido hace panic con la lista completa), `pairings`,
`color-tokens.tokens` / `font-tokens.tokens` (conservar el namespace —
ambos exportan `tokens` y chocarían) y `theme.auto-pair(bg)` para texto
legible garantizado sobre cualquier fondo.

Tamaños de canvas: `sizes.instagram` es `(1080, 1080)`, `sizes.story` es
`(1080, 1920)`; `page-pad` es `80pt`. `canvas(size, body, theme:)`
produce página a sangre (`margin: 0pt`).

## 4 · Plantillas sociales (`src/social.typ`)

Firmas posicionales primero, `theme:` siempre al final:

```typst
#quote-post([La cita.], "Autor", "@marca")
#announce-post("NUEVO", [Título], [Subtítulo], "@marca")
#tip-card(1, [Título], [Descripción.], "@marca")
#carousel-cover([GUÍA 2026], [Título], "@marca", n-pages: 6)
#carousel-slide(2, 6, [Título], [Cuerpo.], "@marca")
#stat-card("+240%", [más alcance], [Explicación.], "@marca")
#event-post("12", "SEPT", [Evento], [Detalles.], "@marca")  // formato story
#testimonial-post([Cita.], "Nombre", "Rol", "AB", "@marca")
#poll-story([¿Qué prefieres?], "A", "B", "@marca")
#versus-post("Sin sistema", ([Azar], [Sin identidad]), "Con sistema", ([Calendario], [Plantillas]), "@marca")
```

Preferir el generador a escribir a mano (12 plantillas, flags `--paleta` /
`--tipografia`, `--repo` para imports relativos dentro del repo,
`--compilar` para compilar de una vez):

```sh
python3 scripts/nueva-plantilla.py --listar
python3 scripts/nueva-plantilla.py announce-post mi-post.typ \
  --paleta terracota --tipografia editorial-clasico \
  --campo tagline=NUEVO --campo title="Mi título"
```

## 5 · Carteles editoriales (una idea visual por lámina)

Presets y sus controles principales:

```typst
#carteles.suizo(frase, remate, formato: (1080, 1350), papel:, tinta:, acento:, marca:)
#carteles.liso(texto, formato:, fondo:, fuente: "Hanken Grotesk", peso: 700, cuerpo-max: 150pt, marca:)
#carteles.demostracion(grupos, formato: (1080, 1080), fondo:, claro:, marca:)
#carteles.rayar(cuerpo, color:, trazo: "recto", grosor: auto)
#plano(...)  // src/plano.typ — preset mínimo, ver examples/presets/plano.typ
#carteles.escalera / .gozne / .linea-tiempo / .esquela / .folio  // presets de serie, un ejemplo de cada uno en examples/presets/
```

Las variantes con orla viven aparte: `cita-orlada`, `capitulo-orlado`,
`pregunta-orlada` en `src/orlas.typ`.

Patrón de ensamblado de carrusel (modelo en
`trabajos/presuposicionalismo-circular/presuposicionalismo-circular.typ`):
envolver un preset en `lamina(n, fondo:, cuerpo)` con `formato:
sizes.instagram` y pie de `marca:` — firma/marca solo en portada y cierre,
contador `n / total` en las interiores. Escribir las láminas con
encabezados: `= antetítulo` (chico, en mono, color de acento de la
lámina), `== frase` (grande, la que guía o remata), párrafos normales para
el desarrollo a una fracción `k` del cuerpo de la frase. Los legos
`carrusel-slide()` / `topbar()` / `pie-carrusel()` / `dots()` de
`src/carrusel.typ` son un kit alternativo de más bajo nivel (el ensamblado
es manual en ambos casos — nada aquí autogenera láminas).

## 6 · Fondos, ornamentos, curvas

```typst
// Fondos por capas (22 presets con nombre, incl. "neon-aura", "aurora",
// "papel-viejo", "papel-escaneado", "papel-cafe"); primer hijo de canvas()
#superbg.superbg("neon-aura", theme: theme.base, size: sizes.instagram)
// Pila propia: gradiente / aura / patron / vignette / papel / mancha-cafe …
#superbg.superbg((capas: (
  (tipo: "gradiente", from: theme.base.colors.dark, to: theme.base.colors.primary),
  (tipo: "aura", colores: (theme.base.colors.secondary, theme.base.colors.accent)),
  (tipo: "patron", patron: "dots", color: white, opacidad: 12%),
  (tipo: "vignette", intensidad: 28%),
)), size: sizes.instagram, theme: theme.base)

// Ornamentos IM FELL FLOWERS (licencia: Fonts/IM_Fell_Flowers/LICENCIA.txt)
#fleurones.orla(nombre, ancho, alto, color)
#fleurones.guarda(nombre, largo, color)   // + .vineta .roseta .cabecera .separador .asterismo .remate

// Fondos continuos entre láminas: construir una vez, ventanas por lámina
#let c = curvas.campo("topo", diapositivas: 5, formato: (1080, 1080))
#curvas.ventana(c, 2)   // tipos: "topo" "ondas" "flujo" "paralelas" "cinta" "orbitas"
```

## 7 · Escritura, citas, capitulares, idiomas

```typst
#pasaje("Salmo 23", version: "RVR1960", capitular-alto: 2)[...]  // vs()/ch() adentro marcan versículo/capítulo
#capitular(cuerpo, alto: 3)                    // capital automática
#capitular-ornamentada(...)                    // iluminada de EB Garamond Initials en dos capas
#blockquote-editorial / -bar / -card / -hero / -avatar / -hand / -pull / -definition / -callout / -poetry / -timeline [...]
#blockquote-grid(tarjetas, columnas: 2)        // + -paralelo / -lateral para lado a lado
#lat / #gr / #he / #translit / #interlineal    // capas en idiomas originales (src/idiomas.typ)
```

`blockquote-hand` delega en Caveat — necesita el bundle `Fonts/` del repo
salvo que esté instalada en el sistema.

## 8 · Reglas que importan

- **Pasar `theme:` explícito.** Nunca sombrear `palette`/`fonts`
  reasignando después de importar (se ignora en silencio — §3).
- **Conservar con nombre `color-tokens` / `font-tokens` / `formas`**;
  nunca `import: *` de ellos.
- **Una idea visual por lámina** en trabajo de campaña; firma solo en
  portada y cierre, contador en las interiores.
- El contenido de este repo es en español; mantenerlo así salvo pedido
  en contrario.
- Verificar el nombre de familia con `typst fonts` antes de usarla — los
  nombres visibles difieren de los archivos (p. ej. `"IM FELL English"`,
  `"EB Garamond 12"`).

## 9 · Referencias (leer antes de tareas grandes)

- `docs/manual.typ` — manual narrativo: instalación, API de theme,
  paletas, tipografía, editorial, escritura, componentes de canvas.
- `demo.typ` — catálogo visual de todo lo que exporta `src/lib.typ`.
- Comentario de cabecera de `src/lib.typ` — lista autoritativa de exports.
- `examples/presets/*.typ` — un archivo mínimo por preset de
  cartel/fleurón; puntos de partida para copiar-pegar.
- `trabajos/*/README.md` + `trabajos/README.md` — convenciones de series.
