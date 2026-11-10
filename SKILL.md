---
name: instatypst
description: Crear posts, carruseles, citas, carteles y láminas para redes con el paquete Typst Instatypst. Usar siempre que el usuario pida una imagen o pieza para Instagram, una cita sobre fondo de color, un cartel tipográfico, un carrusel, una capitular o un bloque de pasaje bíblico, o trabaje con archivos .typ de este repo, aunque no nombre el paquete.
---

# Instatypst: hacer piezas con el paquete

Esta skill es para **usar** el paquete, no para desarrollar `src/`. El contenido es en español; no lo cambies salvo que se pida.

## 1 · Formato de Instagram (decidir esto primero)

| Destino | Formato | Nota |
|---|---|---|
| Post de feed (el más común) | **1080×1350** (4:5) | El de los carruseles de este repo |
| Post de feed cuadrado | 1080×1080 (1:1) | `sizes.instagram` |
| Stories / Reels | 1080×1920 (9:16) | `sizes.story`. **No se puede subir al feed.** |

`sizes` no tiene entrada para 4:5: usa `formato: (1080, 1350)` explícito.
Si el usuario no dice el destino, asume feed 4:5.

## 2 · Qué quiero hacer → qué usar

| Quiero… | Usa |
|---|---|
| Un párrafo o frase sobre fondo liso | `carteles.liso(texto, fondo:, fuente:, marca:)`. Ajusta solo el tamaño y elige tinta legible |
| Cita corta con autor y marca | `quote-post([cita], "Autor", "@marca")` |
| Frase + remate, estilo editorial | `carteles.suizo(frase, remate, formato:, papel:, tinta:, acento:)` |
| Anuncio, dato, testimonio, consejo | `announce-post`, `stat-card`, `testimonial-post`, `tip-card` |
| Carrusel | `carousel-cover` + `carousel-slide`, o un preset de `carteles` envuelto en `lamina()` |
| Cita con aspecto de red social (publicación, mensaje, editorial…) | `carteles.cita-social(cita, nombre, estilo:)` (antes `quote-social`) |
| Epígrafe con 15 estilos | `carteles.epigrafe(cita, autor:, obra:, estilo:)` |
| Portada geométrica | `carteles.bauhaus`, `carteles.mosaico`, `carteles.teselas`, `carteles.hojas` |
| Hoja fotografiada sobre una mesa | `mesa.hoja-vertical[…]`, `mesa.vertical` |
| Pasaje bíblico | `pasaje("Salmo 23", version: "RVR1960")[...]` |
| Letra capital | `capitular(cuerpo, alto: 3)` o `capitular-ornamentada(...)` |
| Fondo con capas | `superbg.superbg("neon-aura", size: ...)` (22 presets) |

**Antes de escribir una página a mano, revisa `examples/presets/` y `src/carteles.typ`.** Casi siempre ya hay un preset: `liso`, `suizo`, `demostracion`, `plano`, `rayar`, `escalera`, `gozne`, `linea-tiempo`, `esquela`, `folio`, `cita-social`, `epigrafe`, `bauhaus`, `mosaico`, `teselas`, `hojas`. Casi todos toman `tema:` (un nombre de `carteles.temas-lamina`, un diccionario de roles `fondo`/`tinta`/`suave`/`acento` o `carteles.tema-desde-theme(theme.base)`).

Los ejemplos mínimos de cada uno están en `examples/presets/<nombre>.typ`: copia de ahí.

## 3 · Compilar

Fuera del repo (ej. `~/Proyectos/Post`), usa un `env.sh` que fije las fuentes y úsalo así:

```sh
source env.sh        # fija TYPST_ROOT y TYPST_FONT_PATHS=…/Instatypst/Fonts
typst compile pieza.typ pieza.png --ppi 72
```

- **Para Instagram, `--ppi 72`**: un lienzo de 1080pt sale a 1080px. No uses 144 salvo que se pida el doble de resolución.
- **Varias páginas**: usa `"salida/nombre-{p}.png"`. Con una sola ruta, Typst falla con `cannot export multiple images without a page number template`.
- **Ese mismo error en una pieza de una sola página significa que el texto se desbordó**: el contenido pasó a una 2.ª página. Baja el tamaño o los márgenes. Cuidado: tras el error el PNG anterior sigue en disco sin cambios y parece que nada cambió.
- Dentro del repo, importa relativo y compila con `--root .`: `#import "../src/lib.typ": *`.
- Las láminas pesadas (SVG por capas) tardan minutos: lánzalas en segundo plano.
- Para mostrar una pieza **dentro de otro documento** (un manual, una hoja de pruebas), no la renderices aparte: `#en-caja(0.15, carteles.liso([…]))` la escala y la recorta como bloque. Los presets llaman `pliego(...)` en vez de `page(...)` justo para eso; si escribes uno nuevo, haz lo mismo.
- `*.pdf`, `salida/` y los `.png` están en `.gitignore`: no se commitean renders, solo fuentes.

Para ver el resultado, **abre la imagen**; compilar sin errores no garantiza que se vea bien.

## 4 · Color y contraste

- Texto sobre fondo de color: no lo elijas a ojo. Usa `readable-on(fondo, white, black)`, `auto-pair(fondo)` o `contrast(a, b)` (todos exportados desde `lib.typ`; ver `src/contrast.typ`).
- Mínimos WCAG: **4.5:1** texto normal (`is-aa`), 7:1 ideal (`is-aaa`).
- Los rojos de la paleta `granates` son oscuros-medios: con texto casi negro dan entre 1,6 y 4,1:1. Para fondo rojo usa **texto crema sobre `wine`** (~10:1), o un rojo claro (`#ff6a4d`, ~7:1) con texto casi negro.
- Con fuentes finas (EB Garamond) sobre fondo oscuro, `weight: 500` mejora la legibilidad sin cambiar el tamaño.

## 5 · Tema y paletas

Los estilos se derivan, no se reasignan:

```typst
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
#announce-post("…", [...], [...], "@handle", theme: marca)
```

- Reasignar `palette` o `fonts` después de importar **se ignora en silencio**. Pasa `theme:` explícito.
- `palettes.get` y `palettes.names` son funciones guardadas en un diccionario. Llamadas solas funcionan (`palettes.get("granates")`), pero para encadenar métodos hay que envolverlas: `(palettes.get)("granates").at(0)`. Sin los paréntesis falla con `cannot directly call dictionary keys`.
- Nombre de paleta inválido: Typst falla y muestra la lista completa. `(palettes.names)()` las enumera.
- `color-tokens`, `font-tokens` y `formas` se importan **con espacio de nombres**, nunca `import: *` (chocan en `tokens`).

## 6 · Fuentes

- El paquete no trae fuentes: viven en `Fonts/` del repo y las apunta `TYPST_FONT_PATHS`.
- Antes de usar una familia, comprueba el nombre con `typst fonts`: los nombres visibles difieren de los de archivo (`"EB Garamond 12"`, `"EB Garamond 12 All SC"`, `"IM FELL English"`).
- Un nombre mal escrito puede caer a otra fuente sin avisar. Revisa el render.
- `blockquote-hand` usa Caveat, que necesita `Fonts/`.

## 7 · Reglas del oficio

- **Una idea visual por lámina.** En carruseles, firma solo en portada y cierre; contador `n / total` en las interiores.
- Texto largo en un post: es mejor un párrafo más pequeño que partirlo. Si no cabe, baja el tamaño en pasos de 2pt hasta que no haya desborde.
- Para tarjetas de texto en feed, márgenes de ~84 a 96pt. Las Stories reservan ~220pt arriba y abajo para la interfaz de Instagram.

## 8 · Referencias (leer antes de trabajos grandes)

- `src/lib.typ` (comentario de cabecera): lista autoritativa de exports.
- `demo.typ`: catálogo visual de todo.
- `docs/manual.typ`: manual narrativo (tema, paletas, tipografía, editorial).
- `examples/presets/*.typ`: un archivo mínimo por preset.
- `scripts/nueva-plantilla.py --listar`: genera una plantilla `.typ` lista (`--paleta`, `--tipografia`, `--campo k=v`, `--compilar`).
- `trabajos/README.md`: convenciones de las series terminadas.
- Instalación como paquete local (enlaces simbólicos a `src/` y `typst.toml` en `~/.local/share/typst/packages/local/instatypst/0.1.0/`): ver `README.md`. En Windows, una *junction* de `src` evita pedir permisos de administrador.
