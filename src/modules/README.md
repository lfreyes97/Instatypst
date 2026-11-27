# Módulos

Un **módulo** es un subsistema autónomo que no sabe nada de Instatypst: tiene su
propia API, no importa nada fuera de su carpeta salvo otro módulo declarado, y
podría publicarse como paquete aparte. Las dependencias entre módulos son datos
del harness (`tests/harness/manifest.toml`, caso `capas-sin-imports-laterales`):

| Módulo | Puede importar | Origen |
|---|---|---|
| `validate/` | — | `Instatypst-rework/preset-swiss/lib/validate.typ` |
| `color/` | `validate` | `preset-swiss/lib/color.typ`, `color-tokens.typ`, `palettes.typ`, `palettes/` |
| `typography/` | `validate`, `color` (`resolve-fill`) | `preset-swiss/lib/typography.typ`, `fonts.typ`, `font-tokens.typ`, `font-pairings.typ` |
| `superbg/` | `color` | v1, `Instatypst-rework` commit `09e5fff` (`src/superbg/`) |
| `fleurones/` | `typography` | v1, commit `09e5fff` (`src/fleurones.typ`) |
| `theme-v1/` | `color` | v1, commit `09e5fff`: la API de temas de v1 (`theme`, `tokens`, `contrast`). Legado: solo la usa `resources/dropcaps` |

`preset-swiss/lib/` es la fuente de verdad de color y tipografía (las copias en
`src/` y `core/color/` del rework son más viejas). Se copió el 26 de noviembre de
2026; en el rework esa carpeta no estaba en git (commit `50e394b`), así que la
procedencia es el sha256 de cada archivo **antes** de cambiarle los imports (los
únicos cambios: `validate.typ` y `color.typ` pasan a rutas `/src/modules/…`):

```
2640670292fcd19dc254edbe7bd3dd1544305902ce0191df2b064aa350349b64  validate.typ
42d0a8b48612b65adc1e5c1cfb885a335f5af289fb18a62c103c2b1089dd6cb6  color.typ
0019cfb395b95c91ab2973d1015c5b1bcae46e0662dd357d5e8feb1794b89f1d  color-tokens.typ
5f369d7544356389786929bd1d3e352969bc1a57050904f06cfd9ca142c759c2  palettes.typ
9727d5f06e2aef8a278047838968224b7346e1354255e73e371dbfdfc8d71c5b  typography.typ
9542f10df9e4f9e73d45cb045947ee9a7173bca7e119653336e366765d811248  fonts.typ
fcbe0470221ef0d0078d985f005d38f64381655e2de617ed52c1b12199654f69  font-tokens.typ
6e74fd0459f8e18a852c8b09ce1faf24b0f6ce02e6b85ec4a451ce68fa1c2f27  font-pairings.typ
e2112b3f24561313c9bb8f8b8aadc005a5ed01ccd4150a8f1eeeb729d97be963  palettes/color-math.typ
a21d2d536ca9b3b5a4a1d5cd5e784f481bf2376c232bc3af9e3d9a55447052eb  palettes/contrast.typ
7db0c5234431ab056928a6d4ace5cace141d0fdfdfdb5e768275a9a20921db17  palettes/core.typ
ba0fdb08978344a29685db8bf110170001b632f006726caac5d149f71a55ed2b  palettes/derive.typ
de239c1564b62fbf62b690633d4001a87886898f7fe5c241a8a56da7f27c8f0e  palettes/lib.typ
95f81a6882d1ed8962495abc8c58c51fd693da275f6df89cf5555e50285f96fe  palettes/LICENSE-apca
0c27fd35156b4d0e4aba5e68f3bd7f541e4b55a0dd6326d3c716758eb3b8a5f6  palettes/preview.typ
ca91f1f90c5d6c0eec5f4f5aa65c7b3e28703b853834dfc3a081827dd8ac793f  palettes/ramp.typ
62f1f7f590dd772b61fe8e07eff8c52de11d545f3ba079bc25b38a82a6ea4bae  palettes/vendors/LICENSE-open-color
d981bc30e0d78b9ffc8f279fcaa274ea0444ff51d983548a609397d5c8a42dc2  palettes/vendors/LICENSE-radix-colors
60e0b68c0f35c078eef3a5d29419d0b03ff84ec1df9c3f9d6e39a519a5ae7985  palettes/vendors/LICENSE-tailwindcss
10e92213eaf7b30b77701f62dfcb5b6da1110209963509a10a26d5e617198907  palettes/vendors/oc.typ
891078a756819ee98277781f8c3e4c3885f96e4d554849b35aeb1cf1d6c58243  palettes/vendors/rx.typ
aacaca4f7828d4c985a2848e34581c459358ddfd33360cf36057bf5cc0f64af1  palettes/vendors/tw4.typ
9d22310dbe74eecb94707bc8f78a1101f8124e121165b697c071a2ced172e1e3  palettes/verify.typ
```

Sus pruebas vienen con ellos: `tests/modules/derivadores.typ` y
`tests/modules/verificadores.typ` (y `tests/modules/importa.typ`, nueva).

## APCA: temporal

`color/palettes/color-math.typ` trae `apca()` (bloque «APCA (TEMPORAL, uso
personal)»), derivado de apca-w3 0.1.9, con su licencia en
`color/palettes/LICENSE-apca`: solo contenido web en pantallas, sin uso
comercial, nombre y logo protegidos, patente en trámite. Está aquí de forma
temporal, por decisión del usuario (26 nov 2026).

**Antes de publicar o redistribuir el paquete, o de usarlo para impresos**, hay
que retirar:

- el bloque APCA de `color/palettes/color-math.typ`;
- `color/palettes/LICENSE-apca`;
- el import de `apca` en `color/palettes/derive.typ`, `color/palettes/verify.typ`
  y `color/palettes/lib.typ`;
- las pruebas de APCA de `tests/modules/derivadores.typ` y
  `tests/modules/verificadores.typ`;

y `contrast-ramp` vuelve a ser solo WCAG.

## Hecho el 26 nov 2026

- Los presets resuelven el tema con `color` (`core/theme.typ` se retiró): el
  catálogo de paletas funciona en `theme`, con 0 px de diferencia en las 24
  paridades con v1.
- `fleurones` toma IM Fell Flowers 1 y 2 del registro de `typography`
  (`font-tokens.typ`, categoría `ornament`): la dependencia es una arista.
- El contraste WCAG tiene una sola implementación, `color/palettes/contrast.typ`.
  `theme-v1/contrast.typ` (idéntico) se borró; `superbg/color.typ` es un
  adaptador con sus nombres (`contraste`, `es-aa`, `texto-sobre`) y deja el
  umbral 0,03928 de la errata de WCAG 2.0 por el 0,04045 de sRGB.
- `superbg/presets.typ` se llama `catalogo.typ` (sus funciones no cambian).

## Pendiente

- La tabla `sizes` de `superbg/_util.typ` se queda: está duplicada a propósito
  (independencia del módulo), y un módulo no puede importar `core/artboard`.
- `theme-v1` se retira cuando `resources/dropcaps` use `color`.
