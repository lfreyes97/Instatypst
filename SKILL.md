---
name: instatypst
description: Author social-media and editorial content with the Instatypst Typst package (Instagram carousels, quote/announcement/stat/testimonial posts, carteles presets, fleurons, continuous-curve backgrounds, scripture blocks, drop caps). Use this skill whenever the user works with Instatypst sources, asks for carruseles, citas, carteles, capitulares, or anything compiled from this repo — even if they don't name the package explicitly.
---

# Instatypst — authoring with the package

Instatypst is a Typst design system: color themes, type pairings,
social-media templates, editorial carteles, fleurons, curves, Bible-quote
blocks and drop caps. This skill is for **using** the package to make
content, not for developing `src/` itself.

## 1 · Setup

The package is installed as a local Typst package (live symlinks, so edits
to `src/` apply immediately):

```sh
mkdir -p ~/.local/share/typst/packages/local/instatypst/0.1.0
ln -sfn "$(pwd)/src" ~/.local/share/typst/packages/local/instatypst/0.1.0/src
ln -sfn "$(pwd)/typst.toml" ~/.local/share/typst/packages/local/instatypst/0.1.0/typst.toml
```

Import from any document on this machine:

```typst
#import "@local/instatypst:0.1.0": *
```

Inside this repo (e.g. anything under `examples/`, `trabajos/`) use a
relative import instead, which requires compiling with `--root .`:

```typst
#import "src/lib.typ": *        // from repo root
#import "../../src/lib.typ": *  // from trabajos/<serie>/
#import "../src/lib.typ": *     // from examples/
```

**Fonts:** the package ships no fonts (`typst.toml` excludes `Fonts/`;
only `src/` + `typst.toml` travel). Either install the families
system-wide (this machine has them under
`~/.local/share/fonts/instatypst/`) or pass the repo bundle explicitly:

```sh
typst compile --root . --font-path Fonts <file.typ> <out.pdf>
```

## 2 · Compile recipes

Every `.typ` in `trabajos/` carries its compile command in a header
comment — always follow it. The general patterns:

```sh
# PDF proof (check layout, read text)
typst compile --root . <file.typ> <out.pdf>

# Instagram PNGs, one file per page/slide at 2160px
typst compile --root . <file.typ> "salida/<name>-{p}.png" --ppi 144

# Batch a whole campaign series (only numbered plates; _comun.typ/logo.typ are modules)
bash trabajos/campana/compile-all.sh
```

Notes:

- `--root .` is mandatory for in-repo files: they import upward
  (`../src/lib.typ`) and Typst restricts to the project root otherwise.
- Heavy plates (1080×1350pt with layered SVG) can take minutes — launch
  in background and poll; an empty log plus fresh PNGs means success.
- Outputs are gitignored (`*.pdf`, `salida/`, `trabajos/*/*.png`): never
  commit renders, only sources.
- `examples/` documents the API; `trabajos/<serie>/` holds finished
  multi-plate works, one folder per series (see `trabajos/README.md`).

## 3 · Theme system (read before styling anything)

`theme.base` keys — every styling function accepts `theme:` and defaults
to it:

```typst
colors: primary, secondary, accent, dark, light, white
fonts:  display: ("Poppins", "Urbanist", "Outfit"),
        body: ("Inter", "DM Sans", "Public Sans", "Liberation Sans")
```

Derive, never reassign:

```typst
#let marca = theme.define("marca", colors: (primary: rgb("#0EA5E9")))
#announce-post("...", [...], [...], "@handle", theme: marca)
```

Reassigning `palette`/`fonts` after import is silently ignored — package
functions resolve those names by closure at definition time.
Related: `palettes.get("terracota")` (panics with the full name list on
unknown names), `pairings`, `color-tokens.tokens` / `font-tokens.tokens`
(keep namespaced — both export `tokens` and would collide), and
`theme.auto-pair(bg)` for guaranteed-readable text on any background.

Canvas sizes: `sizes.instagram` is `(1080, 1080)`, `sizes.story` is
`(1080, 1920)`; `page-pad` is `80pt`. `canvas(size, body, theme:)`
produces a full-bleed page (`margin: 0pt`).

## 4 · Social templates (`src/social.typ`)

Positional-first signatures, `theme:` always last:

```typst
#quote-post([La cita.], "Autor", "@marca")
#announce-post("NUEVO", [Título], [Subtítulo], "@marca")
#tip-card(1, [Título], [Descripción.], "@marca")
#carousel-cover([GUÍA 2026], [Título], "@marca", n-pages: 6)
#carousel-slide(2, 6, [Título], [Cuerpo.], "@marca")
#stat-card("+240%", [más alcance], [Explicación.], "@marca")
#event-post("12", "SEPT", [Evento], [Detalles.], "@marca")  // story format
#testimonial-post([Cita.], "Nombre", "Rol", "AB", "@marca")
#poll-story([¿Qué prefieres?], "A", "B", "@marca")
#versus-post("Sin sistema", ([Azar], [Sin identidad]), "Con sistema", ([Calendario], [Plantillas]), "@marca")
```

Prefer scaffolding via the generator over hand-writing (12 templates,
`--paleta` / `--tipografia` flags, `--repo` for in-repo relative imports,
`--compilar` to compile at once):

```sh
python3 scripts/nueva-plantilla.py --listar
python3 scripts/nueva-plantilla.py announce-post mi-post.typ \
  --paleta terracota --tipografia editorial-clasico \
  --campo tagline=NUEVO --campo title="Mi título"
```

## 5 · Editorial carteles (one visual idea per plate)

Presets and their key knobs:

```typst
#carteles.suizo(frase, remate, formato: (1080, 1350), papel:, tinta:, acento:, marca:)
#carteles.liso(texto, formato:, fondo:, fuente: "Hanken Grotesk", peso: 700, cuerpo-max: 150pt, marca:)
#carteles.demostracion(grupos, formato: (1080, 1080), fondo:, claro:, marca:)
#carteles.rayar(cuerpo, color:, trazo: "recto", grosor: auto)
#plano(...)  // src/plano.typ — minimal preset, see examples/presets/plano.typ
#carteles.escalera / .gozne / .linea-tiempo / .esquela / .folio  // series presets, one example each in examples/presets/
```

The orla-fronted variants live apart: `cita-orlada`, `capitulo-orlado`,
`pregunta-orlada` in `src/orlas.typ`.

Carousel assembly pattern (model on
`trabajos/presuposicionalismo-circular/presuposicionalismo-circular.typ`):
wrap a preset in `lamina(n, fondo:, cuerpo)` with `formato:
sizes.instagram` and a `marca:` footer — signature/brand on cover and
closing only, `n / total` counter on inner slides. Write slides with
headings: `= kicker` (small mono antetitle in the plate accent),
`== punch line` (large guiding phrase), plain paragraphs for development
at a fraction `k` of the phrase size. The `carrusel-slide()` /
`topbar()` / `pie-carrusel()` / `dots()` legos in `src/carrusel.typ` are
an alternative lower-level kit (manual assembly either way — nothing here
auto-generates slides).

## 6 · Backgrounds, ornaments, curves

```typst
// Layered backgrounds (22 named presets incl. "neon-aura", "aurora",
// "papel-viejo", "papel-escaneado", "papel-cafe"); first child of canvas()
#superbg.superbg("neon-aura", theme: theme.base, size: sizes.instagram)
// Custom stack: gradiente / aura / patron / vignette / papel / mancha-cafe …
#superbg.superbg((capas: (
  (tipo: "gradiente", from: theme.base.colors.dark, to: theme.base.colors.primary),
  (tipo: "aura", colores: (theme.base.colors.secondary, theme.base.colors.accent)),
  (tipo: "patron", patron: "dots", color: white, opacidad: 12%),
  (tipo: "vignette", intensidad: 28%),
)), size: sizes.instagram, theme: theme.base)

// IM FELL FLOWERS ornaments (license: Fonts/IM_Fell_Flowers/LICENCIA.txt)
#fleurones.orla(nombre, ancho, alto, color)
#fleurones.guarda(nombre, largo, color)   // + .vineta .roseta .cabecera .separador .asterismo .remate

// Backgrounds continuous across slides: build once, window per slide
#let c = curvas.campo("topo", diapositivas: 5, formato: (1080, 1080))
#curvas.ventana(c, 2)   // tipos: "topo" "ondas" "flujo" "paralelas" "cinta" "orbitas"
```

## 7 · Scripture, quotes, caps, languages

```typst
#pasaje("Salmo 23", version: "RVR1960", capitular-alto: 2)[...]  // vs()/ch() inside for verse/chapter marks
#capitular(cuerpo, alto: 3)                    // automatic capital
#capitular-ornamentada(...)                    // two-layer EB Garamond Initials illuminated capital
#blockquote-editorial / -bar / -card / -hero / -avatar / -hand / -pull / -definition / -callout / -poetry / -timeline [...]
#blockquote-grid(tarjetas, columnas: 2)        // + -paralelo / -lateral for side-by-side
#lat / #gr / #he / #translit / #interlineal    // original-language layers (src/idiomas.typ)
```

`blockquote-hand` delegates to Caveat — needs the repo `Fonts/` bundle
unless installed system-wide.

## 8 · Rules that matter

- **Pass `theme:` explicitly.** Never shadow `palette`/`fonts` by
  reassigning after import (silently ignored — §3).
- **Keep `color-tokens` / `font-tokens` / `formas` namespaced**; never
  `import: *` them.
- **One visual idea per plate** in campaign work; signature on cover and
  closing only, counters on inner slides.
- Content in this repo is Spanish; keep it that way unless asked otherwise.
- Check `typst fonts` for a family name before using it — display names
  differ from file names (e.g. `"IM FELL English"`, `"EB Garamond 12"`).

## 9 · References (read before large tasks)

- `docs/manual.typ` — narrative manual: installation, theme API, palettes,
  typography, editorial, scripture, canvas components.
- `demo.typ` — visual catalog of everything `src/lib.typ` exports.
- `src/lib.typ` header comment — authoritative export list.
- `examples/presets/*.typ` — one minimal file per cartel/fleuron preset;
  copy-paste starting points.
- `trabajos/*/README.md` + `trabajos/README.md` — series conventions.
