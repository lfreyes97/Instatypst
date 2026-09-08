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
capitular de verdad. Dos caminos si se quiere mejorar esto:

- Conseguir esa variante como fuente — rompe la regla del proyecto de
  no pedir fuentes nuevas; solo viable si ya está guardada en algún
  lado, no para pedir una nueva.
- Portarla como SVG en vez de fuente — mismo camino que ya funcionó
  para bocadillo/cinta/blob/aura (`src/formas.typ`, `src/social.typ`):
  si aparece un SVG con letras capitulares reales (glifos, no una
  fuente completa), se puede recortar y recolorear igual que se hizo
  con los 6 blobs de `Assets/shapes.2svg`.

Ninguna existe en el repo todavía — esto es una nota de qué hacer SI
aparece ese material, no una tarea con algo que portar ahora mismo.

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
