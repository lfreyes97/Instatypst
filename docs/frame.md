# Cómo llegamos a `frame`

> **Estado actual (20 nov 2026).** Este documento es el historial de la exploración. Lo que quedó, acotado a `suizo`:
> - **Aprendizaje:** una pieza se traduce 1:1 con nombres semánticos. `core/scaffold.typ` lo demuestra: el contrato (`eyebrow`, `question`, `statement`, `headline`...) llama a `carteles.suizo` y el PNG es idéntico al original (`just cmp suizo`).
> - **Reglas:** `engine_v1` = Instatypst (`src/`); `engine_v2` = el motor futuro. `scaffold` es temporal y desaparece con v2. Los nombres de las primitivas se deciden al traducir; la tabla está en `docs/traduccion.md`.
> - **`type: "swiss"`** nombra la retícula suiza; `grid` queda para la grilla real de WallTypst.
> - **Podado:** `frame.typ` (el motor prototipo, cuya `grid` no reproducía `suizo`), `liso`, `lamina` y `marca` del port. Copia en el scratchpad de la sesión del 20 nov.
> - **Se mantiene:** `core/primitivas.typ` y `core/recetas/suizo.typ` (el port, solo como prueba de que las primitivas son fieles a v1; deprecado).
>
> Lo que sigue en este texto describe el camino recorrido, no el estado del código.

Documento de trabajo de la rama `rework/primitivas`. Explica el camino desde los presets de Instatypst hasta el contrato `frame`, por qué `frame` empezó siendo una fachada y qué viene después.

## 1. El punto de partida

Teníamos dos proyectos que no compartían ni un commit:

- **Instatypst**: el sistema de diseño en Typst — presets (`liso`, `suizo`, `lamina`, `hojas`, `folio`…), temas, paletas, tipografías. Canónico, con remoto en GitHub.
- **WallTypst**: un laboratorio local de wallpapers. Su aporte propio era una **rejilla responsiva** (`docs/layout.md`, `templates/wall.typ`): columnas y filas por breakpoint, zona segura, y una idea explícita en `docs/grid-design.md` — *las formas declaran celdas como obstáculos y el texto toma la mayor región libre*.

La primera hipótesis fue que esa grilla era lo que Instatypst necesitaba. Instatypst dibuja sus composiciones sobre una **lámina fija centrada**, que aprovecha mal un lienzo apaisado; la grilla de WallTypst reubica la composición según el aspecto.

## 2. El toolbox y la trampa de la fidelidad

Construimos `core/primitivas.typ` como módulo **autocontenido, cero imports**: geometría, rejilla, breakpoints, zona segura, obstáculos, caja libre, tema, contraste, `reticula`, `pliego`. Sobre él escribimos `marca`, `suizo`, `lamina` y `liso` con la API original, y compilamos sus demos.

El resultado fue fuerte: **24 páginas idénticas byte a byte** contra los originales (`cmp`). Pero esa prueba era engañosa. Demostraba que las primitivas eran fieles, **no que hubiéramos reimplementado nada**: las recetas eran copias con los imports vueltos a apuntar.

El caso límite fue `epigrafe`, `hojas` y `folio`. Para reproducirlos vendorizamos `src/` completo dentro de `core/vendor/`: 74 archivos `.typ` y 3,5 MB de assets. El cálculo de dependencias mostró que las tres recetas necesitaban solo 33 archivos; el resto entraba porque los demos importaban `lib.typ`, que importa todo. Ahí quedó claro: **eso era un port, no un rework**. Se eliminó el vendor y esas tres recetas.

La campaña Warfield (`trabajos/campana/`) nos dio la regla correcta: *"No hay plantilla compartida, y no se debe introducir una"*. Su `_comun.typ` es una **caja de herramientas**, no una plantilla; lo único compartido es la marca y la atribución. Eso es el modelo shadcn/Radix: primitivas headless + recetas que el usuario copia y posee.

## 3. El problema real: los nombres

Mirando la superficie de nuestros casos aparecía el tercer problema:

```typst
#liso(...)
#caso(...)     // envoltorio del usuario
#lamina(...)
```

Son nombres de **catálogo**: dicen qué estilo es, pero no cómo se compone. Para saber qué hace `#lamina` hay que abrir el archivo. Y el `type` de `suizo` tenía doce argumentos con nombre.

La decisión fue un contrato único, en inglés, donde el tipo nombra la **mecánica**:

```typst
#frame(type: "grid", format: formats.story, brand: mark)[
  #eyebrow[DEL ENSAYO]
  #question[¿Qué es el calvinismo?]
  #statement[El calvinismo es simplemente la religión en su]
  #headline[PUREZA.]
]
```

- `type`: `free` (texto en la mayor caja libre), `grid` (celdas y obstáculos), `series` (página numerada).
- Argumentos: `format`, `theme`, `background`, `accent`, `brand`, `author`, `dates`, `index`, `total`, `next`.
- Hijos semánticos: `eyebrow`, `question`, `statement`, `headline` (alias `display`), `title`, `detail`.
- El `#caso` desaparece: el envoltorio del usuario es solo un `#let` que fija argumentos.

Probamos en Typst que los hijos del `body` se pueden extraer: cada hijo semántico devuelve `metadata((kind: ..., body: ...))`, y `frame` aplana el cuerpo con `c.has("children")` y lee `c.value.kind`. Eso hizo posible `#frame[...](body)`.

## 4. `frame` como fachada

La primera versión de `core/frame.typ` era una **fachada**: una interfaz nueva delante del sistema viejo que solo traducía y delegaba.

```typst
} else if type == "grid" {
  suizo(
    p.at("statement"), p.at("headline"),   // inglés → posicionales
    formato: format,                        // format → formato
    etiqueta: p.at("eyebrow"),              // eyebrow → etiqueta
    planteo: p.at("question"),              // question → planteo
    autor: author, fechas: dates, marca: brand,
  )
}
```

`liso`, `suizo` y `lamina` seguían existiendo y haciendo todo el trabajo con sus `place()`, su `reticula` y sus firmas en español. `frame` era solo un traductor encima. Por eso la página `grid` salió **idéntica byte a byte** al `suizo` original: no había cambiado el motor, solo la etiqueta. Era el mismo patrón que el vendor, pero en pequeño.

## 5. `frame` como contrato

La versión actual ya **no importa las recetas**. Importa las primitivas con alias en inglés y las usa directamente:

```typst
#import "primitivas.typ": formatos as formats, medida as dimensions,
  rejilla as grid, ob-celda as cell-obstacle,
  mayor-caja-libre as largest-free-rect, pliego as sheet, ...
```

Los tres tipos están implementados dentro de `frame`:

- **`free`**: texto en el mayor rectángulo útil con `fit-box`; marca al pie.
- **`grid`**: la rejilla crea dos bandas de celdas (cabecera y titular), las publica como obstáculos con `cell-obstacle`, y el `statement` se coloca en `largest-free-rect`. Aquí la grilla de WallTypst deja de ser código muerto y pasa a mandar.
- **`series`**: barra de progreso por `index`/`total`, contador, título y detalle con `fit-height`.

El resultado ya **no es byte-idéntico** (`grid`: 116.641 bytes vs 140.602 del original). Eso es lo esperado: el `cmp` solo servía para validar la fachada; en el nivel de las recetas lo reemplaza la revisión visual, que de hecho cazó un fallo real —la cabecera salía apilada porque los offsets se solapaban— y permitió corregirlo.

## 6. El siguiente paso

1. **Borrar las recetas viejas** (`suizo`, `lamina`, `liso`) y sus demos: `frame` ya no las llama. Queda solo el contrato + el toolbox.
2. **Renombrar las primitivas internas al inglés**. Los alias en `frame.typ` son un parche: el toolbox todavía habla español (`rejilla`, `celda`, `ob-celda`, `resolver-tema`). Un solo idioma en todo el sistema.
3. **Probar `grid` en los cuatro formatos** — vertical, apaisado, ultra y 1366×768— y verificar que el texto esquiva la geometría. Esa es la necesidad que trajimos de WallTypst y todavía no está demostrada.
4. **Reactivar epigrafe, hojas y folio solo como primitivas**, nunca copiando código ni trayendo un vendor. Si algo no se puede expresar con el toolbox, se descarta.
5. **Mantener el `cmp` en su lugar correcto**: como prueba de las primitivas, no de las recetas. Los 24 PNG originales quedan como fixtures de esa capa.
6. **Fusionar `rework/primitivas` a `main`** cuando el conjunto cierre.

## Estado

- Sin `vendor/`, sin imports a Instatypst, sin commit.
- `frame` compila el demo de 4 páginas con `typst compile --root . --font-path Fonts --ignore-system-fonts examples/recetas/frame-demo.typ`.
- Única referencia al código anterior: los alias en `frame.typ` que apuntan a `primitivas.typ`.
