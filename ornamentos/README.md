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
