# Ideas de tipografía — pendientes de explorar

Notas para retomar más adelante, no bugs ni features a medio hacer —
cosas que vale la pena investigar antes de decidir cómo (o si)
implementarlas. Distinto de `docs/oportunidades-mejora.md` (esa es
auditoría de bugs confirmados compilando; esto es solo ideas).

## Letras capitulares ornamentadas de EB Garamond

`Fonts/EB_Garamond/` solo trae Regular, Italic, SC (small caps) y AllSC,
en los dos ópticos (08/12) — verificado con `typst fonts --font-path
Fonts --variants`. No hay ninguna variante "Initials"/ornamental: el
tipo de letra capitular decorativa que algunas familias Garamond
publican aparte, con florituras propias en el trazo (no solo una
versión grande de la letra normal) — pensada específicamente para
dropcaps.

Hoy `capitular()` (`src/dropcaps.typ`) usa la letra grande de la misma
fuente del cuerpo — funcional, pero sin el carácter ornamental de una
capitular de verdad.

**Sí existen, en el repo oficial de la fuente — verificado, no
suposición:** [georgd/EB-Garamond-Initials](https://github.com/georgd/EB-Garamond-Initials),
licencia **OFL-1.1** (misma familia de licencia que el resto de
`Fonts/`). Capitulares basadas en las iluminadas de *De Peste
Commentarius* (1589, Jean Antoine Sarrasin), trabajo del mismo
proyecto que `georgd/EB-Garamond` (la fuente que ya usamos). Estructura
del repo: carpeta `SVG/` con los glifos vectoriales reales (además de
`SFD/` fuente editable y fuentes OTF/TTF compiladas en `build/`) — el
material SVG que hacía falta para portar, no una fuente nueva.

Diseño en **dos capas**, pensado para dos colores:
- `EBGaramond-InitialsF1` — el ornamento de fondo (florituras).
- `EBGaramond-InitialsF2` — la letra en primer plano.

Portarlas sería el mismo patrón que los 6 blobs de `Assets/shapes.2svg`
(recortar viewBox real, recolorear con `fill.to-hex()`), pero con DOS
`<path>` por letra en vez de uno — F1 con `theme.colors.accent` (o
`.secondary`), F2 con `theme.colors.primary`/`.dark`, superpuestos.
Nota del propio repo: "work in progress", calidad variable entre
letras — habría que revisar cuáles letras están completas antes de
prometer el alfabeto entero.

**Pendiente de decidir, no hecho:** cuáles letras descargar (todo el
alfabeto son ~52 archivos entre F1/F2 — dos capas × 26 letras) y de
qué commit/tag exacto, antes de bajar nada del repo.

## Falta una fuente con cobertura de emoji

Ninguna de las ~50 fuentes en `Fonts/` cubre emoji — verificado con
`fc-scan` sobre cada archivo del proyecto contra el rango U+1F600+
(caras/gestos): cero coincidencias. No hay ninguna fuente de
color/emoji (Noto Color Emoji, Twemoji, etc.) en el proyecto.

Cualquier emoji literal en un documento actual cae en tofu/glifo
faltante. No se pide una fuente nueva sin que el usuario lo decida —
esto es solo dejar constancia de la carencia para cuando haga falta un
emoji real en algún diseño (`blockquote-callout` ya usa `icono:` como
texto/glifo, así que un emoji ahí hoy fallaría en silencio si no está
en Liga SFMono Nerd Font o similar).
