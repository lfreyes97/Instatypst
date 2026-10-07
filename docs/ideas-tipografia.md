# Ideas de tipografía — pendientes de explorar

Notas para retomar más adelante, no bugs ni features a medio hacer —
cosas que vale la pena investigar antes de decidir cómo (o si)
implementarlas. Distinto de `docs/oportunidades-mejora.md` (esa es
auditoría de bugs confirmados compilando; esto es solo ideas).

## Letras capitulares ornamentadas de EB Garamond — HECHO

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
`SFD/` fuente editable; la carpeta `build/` con OTF/TTF compiladas ya no
existe en el repo, verificado 2026-10-07) — el material SVG que hacía
falta para portar, no una fuente nueva.

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

**Prototipo hecho y confirmado (2026-09-09):** bajé F1/S.svg y F2/S.svg
de verdad (`raw.githubusercontent.com/georgd/EB-Garamond-Initials/master/SVG/...`,
19.4 KB + 0.7 KB), compuse ambos `<path>` (cada uno viewBox `0 0 1000
1000` — coinciden exacto, sin traducir nada) con `theme.colors.primary`/
`.dark` de la paleta `terracota` real, y renderizó — un fleurón/vid
completo alrededor de una "S" sólida, calidad de manuscrito iluminado
de verdad. Muy por encima de lo que da `capitular()` hoy.

**Hallazgo real que limita el alcance:** el listado completo de las 28
letras (vía API de GitHub, F1 y F2 coinciden exacto) confirma que
**faltan G y T por completo** — no es que la calidad sea baja en esas
dos, no existen. Cualquier `capitular-ornamentada()` que se construya
necesita un fallback (usar el `capitular()` de siempre) para esas dos
letras, no puede prometer el alfabeto completo.

**Hecho (2026-10-07):** se bajaron las 24 letras + Ä/Ö/Ü en ambas
capas a `Assets/eb-initials/{F1,F2}/` (con `COPYING`, OFL-1.1) y se
armaron `capitular-ornamentada()` e `inicial-ornamentada()` en
`src/dropcaps.typ`. G, T, letras acentuadas (Á, É, Ñ…) y párrafos que
arrancan con puntuación caen a `capitular()` normal. Muestra completa en
`examples/capitulares-ornamentadas.typ`.

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
