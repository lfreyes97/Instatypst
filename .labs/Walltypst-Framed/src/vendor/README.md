# vendor/

Copias **sin modificar** de piezas de v1, para que Framed no dependa de
`@local/instatypst`.

| Archivo | Origen | Versión |
|---|---|---|
| `curvas.typ` | `~/.local/share/typst/packages/local/instatypst/0.1.0/src/curvas.typ` | 0.1.0 |
| `reticula.typ` | **extracción** de `WallTypst/templates/wall.typ` L331–393 (`lay`, `contenedor`, `celda`), con globales vueltos parámetros | tag `snapshot-pre-diseccion` |

No se edita aquí: si algo cambia, se vuelve a copiar del origen (`sha256sum` de ambos debe coincidir).

`curvas.typ` es copia exacta. `reticula.typ` no: es una extracción (la lógica no cambia). Es temporal: se sustituye por la retícula de `swiss` o por `put` (Spec, caso 7). `curvas.typ` es candidato a un módulo `topography`.
