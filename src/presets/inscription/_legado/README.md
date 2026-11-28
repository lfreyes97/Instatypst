# Legado de v1 de `inscription`

Piezas de v1 que hoy solo usan los 15 estilos de `inscription`
(`variants/<estilo>.typ`, con lo común de cada tanda en `variants/_comun-a/b/c.typ`):

- `_base.typ` — medir el formato, escalar y achicar un texto hasta que quepa. Es
  el mismo autoajuste que `plain` "post" y `swiss` hacen por su cuenta: cuando se
  unifique, va a `plain/` como regla del scaffold.
- `_temas.typ` — los temas de lámina de v1 (roles `fondo`, `tinta`…); se retira
  cuando los estilos usen `modules/color`.

Procedencia: `Instatypst-rework`, commit `09e5fff` —la misma referencia fija
que usa el harness—, antes en `src/engine/carteles/`. En la mudanza del 26 nov
2026 solo cambiaron las rutas de los imports.

Los estilos son **variantes de `frame`** (Spec §5); `inscription.typ` traduce
`variant` al estilo de v1. Desde el 26 nov 2026 cada uno está en su archivo
(partidos de `_epigrafes-a/b/c.typ` sin cambiar el código; las 15 paridades con
v1 siguen en 0 px). El paso siguiente es que dejen de dibujar su propia página y
sean `plain` + superbg + reglas.

El resto de lo que era `src/engine/` está en `src/core/pliego.typ`,
`src/modules/` (`superbg`, `fleurones`, `theme-v1`) y `src/resources/`
(`dropcaps`, `motifs`).
