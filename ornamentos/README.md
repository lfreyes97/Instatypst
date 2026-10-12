# Catálogo de ornamentos

Escanea `Fonts/` en busca de glifos ornamentales (fleurons, giraldillas,
asterismos, estrellas, copos, destellos, corazones, comillas/paréntesis
ornamentados, cruces, manos, flechas, hojas) y de la floritura-alfabeto de
`Orments.otf` (cada letra a-z/A-Z/dígito 0-9 es un motivo distinto — ver
`orn()` en `src/idiomas.typ`), y arma un catálogo visual navegable.

Todo el subsistema vive en esta carpeta:

```
ornamentos.typ              catálogo visual (fuente)
ornamentos.json             datos (generados, no editar a mano)
ornamentos.pdf              catálogo compilado
catalogar-ornamentos.py     escáner: Fonts/ -> ornamentos.json
```

## Regenerar

Cuando cambie algo en `Fonts/` (fuente nueva, fuente quitada):

```bash
python3 ornamentos/catalogar-ornamentos.py
typst compile --root . --font-path Fonts ornamentos/ornamentos.typ ornamentos/ornamentos.pdf
```

El escáner cruza `fc-scan --format %{charset}` (qué codepoints tiene cada
archivo) con `typst fonts --variants --font-path Fonts` (qué nombre de
familia resuelve Typst para ese archivo) — así cada ficha del catálogo
muestra una cara que Typst puede resolver de verdad, no solo un nombre de
carpeta.

**Variantes fusionadas:** cuando varios cortes de una misma familia
comparten glifos idénticos (Cormorant + Cormorant Garamond, los 3 Ysabeau
compactos, los 8 cortes de IM FELL, AdwaitaMono NF + Iosevka NF), el
catálogo los muestra en una sola sección — verificado renderizando cada
par lado a lado, no solo por coincidencia de codepoint (dos familias
distintas pueden cubrir el mismo código con un dibujo distinto — por eso
Ysabeau Infant queda aparte: mismo set de codepoints, fleurón distinto).
Esa lista de fusiones vive en `ornamentos.typ` (`#let grupos = (...)`), a
mano — no se recalcula sola al regenerar el JSON.

**Alfabeto-dingbat:** si algún día agregas otra fuente de este tipo (una
letra = una floritura, no texto legible), añade su familia real (la que
resuelve `typst fonts --variants`) a `ALFABETO_DINGBAT_FAMILIAS` en
`catalogar-ornamentos.py` — si no, el escáner la trata como texto normal y
no la cataloga.

## IM FELL FLOWERS: catálogo aparte

Las dos fuentes de flores de Igino Marini (`Fonts/IM_Fell_Flowers/`)
no entran en el catálogo de arriba: guardan sus motivos en las letras
A–Z/a–z, no en codepoints ornamentales, y no son un alfabeto-dingbat
de una floritura por letra sino piezas de orla que se combinan. Tienen
su propio catálogo y hoja de pruebas:

```
fleurones.typ               catálogo + hoja de pruebas (fuente)
fleurones.json              clasificación (generada, no editar a mano)
fleurones.pdf               catálogo compilado
clasificar-fleurones.py     clasificador: rasteriza cada glifo y mide
                            simetrías, su giro de 180°/90° y si encadena
```

```bash
python3 ornamentos/clasificar-fleurones.py
typst compile --root . --font-path Fonts ornamentos/fleurones.typ ornamentos/fleurones.pdf
```

Hallazgos del clasificador: las fuentes no tienen pares en espejo —la
pieza complementaria siempre es un giro de 180° (R↔S, A↔D; en FLOWERS 2
cada minúscula es su mayúscula girada)—, y todo FLOWERS 1 encadena
(su tinta toca los dos costados): la fuente entera es material de orla.
El motor que las compone vive en `src/fleurones.typ`.

Encadenar no basta para servir de marco: un motivo con «arriba»
(crestería, lises, copas) se ve caído de costado. Por eso el paquete
trae los glifos ya repartidos por uso —las primeras páginas del
catálogo—, elegidos a ojo sobre la hoja de pruebas:

| uso | función | presets |
|---|---|---|
| marcos (4 lados) | `fleurones.orla(nombre, ancho, alto, color)` | `fleurones.cadenas`: 20 (las 5 de Magnalia + celosía, trenza, damasco, lises, corazones, margaritas…) |
| guardas (solo horizontal) | `fleurones.guarda(nombre, largo, color)` | `fleurones.guardas`: 14 (guirnalda, crestería, hojarasca, vaivén…) |
| viñetas sueltas | `fleurones.vineta(nombre, alto, color)` | `fleurones.vinetas`: 18 (cruz, flor, lis, mano, acanto…) |
| rosetas | `fleurones.roseta(lado, color, tipo:)` | `fleurones.rosetas`: 9 |
| composiciones | `cabecera`, `separador`, `asterismo`, `remate` | toman una guarda o una viñeta por nombre |

Cada preset fija glifo, esquina, grosor y aire para lienzos de ~1080 px.
Demo en diapositivas: `examples/presets/fleurones.typ`.
