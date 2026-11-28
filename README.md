# instatypst

Sistema de diseño en Typst: temas de color y tipografía, plantillas para
redes sociales, letras capitulares y bloques de cita bíblica.

## Documentación

- **`demo.pdf`** — catálogo visual de todo lo exportado por `src/lib.typ` (lo que *se ve*). Fuente: `demo.typ`.
- **`docs/manual.pdf`** — manual narrativo (cómo *se usa*): instalación, `theme` API, paletas, tipografía, capitulares, editorial, escritura, idiomas, canvas/componentes, plantillas y blockquotes. Fuente: `docs/manual.typ`.
- **`ornamentos/ornamentos.pdf`** — catálogo de ornamentos tipográficos (fleurons, estrellas, manos, flechas, la floritura-alfabeto de Orments…) presentes en `Fonts/`. Todo el subsistema vive junto en `ornamentos/`: fuente `ornamentos.typ`, datos `ornamentos.json`, escáner `catalogar-ornamentos.py` — ver `ornamentos/README.md`.

Compilar cualquiera de ellos:

```bash
typst compile --root . --font-path Fonts demo.typ
typst compile --root . --font-path Fonts docs/manual.typ
typst compile --root . --font-path Fonts ornamentos/ornamentos.typ
```

Con el entorno de Nix (ver abajo) no hace falta `--root`/`--font-path`:
ya quedan fijos por variable de entorno, así que basta
`typst compile demo.typ`.

## Entorno de desarrollo con Nix

La dificultad recurrente de este proyecto era las fuentes: `--font-path
Fonts` hay que repetirlo en cada compilación, y dos familias pesadas
(`Fonts/Iosevka_Nerd_Font/`, `Fonts/ZedMono_Nerd_Font/` — 1.2GB y 705MB)
están en `.gitignore` y no viajan con el repo, así que una máquina nueva
no las tiene hasta copiarlas a mano.

`flake.nix` resuelve ambas cosas:

```bash
nix develop        # typst + poppler_utils + python3, y las 2 Nerd Fonts de nixpkgs
# o, con direnv instalado:
direnv allow       # entra sola cada vez que hagas `cd` al repo (usa .envrc)
```

Adentro, `TYPST_ROOT`/`TYPST_FONT_PATHS` ya apuntan a este repo y a
`Fonts/`, así que `typst compile demo.typ` funciona sin flags. Nota: no
se probó `nix develop` en este repo todavía (revisa que resuelvan los
paquetes `nerd-fonts.*` — nixpkgs reestructuró ese paquete en 2024, ver
comentario en `flake.nix` si tu versión de nixpkgs usa otros nombres).

## Instalar las fuentes en el sistema

`Fonts/` está en el repositorio a propósito: son las 49 familias que usan
los ejemplos y los presets (≈240 MB, con el `OFL.txt` de las que lo traen),
así que cualquier equipo puede tenerlas sin descargar nada más. Instalarlas
a nivel de usuario o de sistema evita repetir `--font-path` /
`TYPST_FONT_PATHS` en cada compilación, y las hace visibles también para
quien compile por su cuenta: la CLI de `typst-rrss`, un editor con vista
previa, otro proyecto.

```bash
# Linux, solo para tu usuario (sin sudo)
mkdir -p ~/.local/share/fonts/instatypst
rsync -a --exclude '*_Nerd_Font' Fonts/ ~/.local/share/fonts/instatypst/
fc-cache -f

# Linux, para todo el sistema
sudo rsync -a --exclude '*_Nerd_Font' Fonts/ /usr/local/share/fonts/instatypst/
sudo fc-cache -f

typst fonts | grep -i "EB Garamond"     # comprobar que Typst las ve
```

Se excluyen las dos Nerd Fonts (`Iosevka_Nerd_Font/`, `ZedMono_Nerd_Font/`):
no viajan con el repo (ver arriba) y los presets no las necesitan. En macOS
copia las familias a `~/Library/Fonts/`; en Windows, instálalas desde el
explorador (selecciona los `.ttf`/`.otf` → «Instalar»). Esas dos rutas no
se probaron aquí.

Con las fuentes instaladas, `--font-path Fonts` pasa a ser opcional. Sigue
siendo útil para fijar exactamente estas versiones en un equipo que ya tiene
otras familias con el mismo nombre.

## Estructura

```
src/                  código del paquete (entrypoint: src/lib.typ)
  lib.typ             frame, elementos y la tabla de presets
  frame.typ           el lienzo genérico
  elements.typ        los elementos de texto
  core/               formatos de lienzo y lectura de elementos
  plain/              la base de todos los presets
  presets/            un preset por carpeta, con sus variantes
  resources/          lo que consumen los presets: capitulares, motivos, orlas
  modules/            subsistemas autónomos
    validate/           validación de argumentos
    color/              temas, paletas, derivación y contraste
    typography/         fuentes, tokens y parejas tipográficas
    superbg/            fondos componibles
    fleurones/          orlas, guardas y viñetas
spec/                 vocabulario de elementos, decisiones, protocolo y spec del MCP
tests/                pruebas de los módulos y del núcleo
demo.typ              catálogo visual (no forma parte del paquete)
docs/manual.typ       manual narrativo (no forma parte del paquete)
ornamentos/           catálogo de ornamentos de Fonts/ (no forma parte del paquete)
Fonts/                fuentes usadas por el proyecto (no forman parte del paquete)
DEUDA.md              contrato, deuda y lo abierto
```

## Uso

### Como paquete instalado localmente

Se instala en `~/.local/share/typst/packages/local/instatypst/0.1.0/`
(sin `Fonts/`, sin `examples/` — solo `src/` + `typst.toml`, igual que
quedaría un paquete real). Para desarrollo, un symlink de `src/` y
`typst.toml` es más cómodo que copiar (los cambios quedan en vivo):

```sh
mkdir -p ~/.local/share/typst/packages/local/instatypst/0.1.0
ln -sfn "$(pwd)/src" ~/.local/share/typst/packages/local/instatypst/0.1.0/src
ln -sfn "$(pwd)/typst.toml" ~/.local/share/typst/packages/local/instatypst/0.1.0/typst.toml
```

Se importa desde cualquier proyecto en esta máquina, sin rutas relativas:

```typst
#import "@local/instatypst:0.1.0": *
```

Si vas a *publicar* una copia fija en vez de symlinkear (p. ej. para
llevarla a otra máquina), ahí sí copiá: `cp -r src typst.toml
<destino>/packages/local/instatypst/0.1.0/`.

**Fuentes:** el paquete no trae las fuentes consigo — eso no es parte de
cómo funciona el sistema de paquetes de Typst. Quien lo use necesita pasar
`--font-path` apuntando a una copia de `Fonts/` (o tener esas familias
instaladas en el sistema: ver «Instalar las fuentes en el sistema»).

### Dentro de este repo (desarrollo)

```typst
#import "src/lib.typ": *
```

Desde una subcarpeta el import sube (`../src/lib.typ`) y hace falta fijar la raíz
del proyecto al compilar:

```bash
typst compile --root . --font-path Fonts carpeta/pieza.typ
```

## `lib.typ` — qué expone

- `frame(preset:, variant:, artboard:, theme:, accent:, brand:, ..options)[…]` — el
  lienzo. `preset` es un nombre o una función, y `auto` es `plain`.
- un frame por preset, con su nombre: `plain`, `swiss`, `inscription`, `bauhaus`,
  `blueprint`, `bands`, `proof`, `mosaic`, `tiles`, `leaves`, `obituary`, `folio`,
  `bordered-quote`, `bordered-chapter`, `bordered-question`, `timeline`, `event`,
  `contrast`, `tip`, `hinge`, `stairs`, `social-quote` — es `frame` con el preset ya
  puesto
- los elementos de `elements.typ` (`spec/vocabulario.md`) y `formats`, los nombres
  de artboard
- `version`

Los recursos no salen de `lib.typ`: `capitular`, `fleurones`, `superbg` y las
paletas se importan desde su módulo, por ejemplo
`#import "/src/modules/superbg/lib.typ": superbg`.

## Fondos componibles con superbg

`superbg` es un módulo independiente (`src/modules/superbg/`): no importa nada del
resto del paquete. Tiene tres niveles, con una sola puerta: fondos preconstruidos
por nombre, constructores por tipo (`bg-aura`, `bg-malla`, `bg-olas`, `bg-topo`,
`bg-patron`, `bg-papel`…) y un motor que mezcla capas en una llamada.
`superbg-page` lo pone en una página con el contenido encima:

```typst
#import "/src/modules/superbg/lib.typ": superbg-page, sizes

#superbg-page("neon-aura", size: sizes.instagram)[
  #text(fill: white, size: 80pt)[Fondo de marca]
]

#superbg-page((capas: (
  (tipo: "gradiente", from: rgb("#1c1917"), to: rgb("#7c2d12")),
  (tipo: "aura", colores: (rgb("#f59e0b"), rgb("#ea580c"))),
  (tipo: "patron", patron: "dots", color: white, opacidad: 12%),
  (tipo: "vignette", intensidad: 28%),
)), size: sizes.instagram)[
  #text(fill: white, size: 80pt)[Fondo de marca]
]
```

Los presets lo usan por dentro; no hace falta llamarlo para usar un preset. Sus
pruebas están en `tests/modules/superbg-*.typ`.

## Nota sobre temas y `theme:`

`theme` se pasa por parámetro a `frame` o a su atajo, y es un diccionario de colores
con cinco roles: `paper`, `ink`, `quiet`, `accent` y `guide`. Un tema parcial se
completa con el del preset: si solo cambias `paper`, el preset conserva el `quiet`
y el `guide` que traía. Cada color acepta un valor de Typst, el nombre de un rol o
una referencia al catálogo de paletas (`tw4-amber-400`, `rx-tomato-9-dark`,
`oc-grape-5`). Algunos presets declaran roles propios además de los cinco; otro
preset los rechaza.

```typst
#swiss(theme: (paper: rgb("#f3ece2"), accent: "tw4-amber-600"))[
  #main[Todo es gracia.]
]
```
