// Demuestra src/idiomas.typ: lat/gr/he, transliteración, interlineal y
// el nuevo blockquote-paralelo (social.typ). Ninguna fuente nueva —
// Libertinus Serif cubre hebreo (con niqqud) y griego; GFS Didot da
// griego politónico más auténtico. Ver src/font-tokens.typ (by-script).

#import "../src/lib.typ": *

= Frases sueltas

Los escolásticos hablaban de #lat[creatio ex nihilo] — la creación de la nada.

En griego, #gr[λόγος] ("logos") es la palabra que Juan usa para el Verbo;
con una tipografía griega auténtica se ve así: #gr(autentico: true)[λόγος].

En hebreo, #he[בְּרֵאשִׁית] ("bereshit") abre el Génesis.

#pagebreak()

= Interlineal — Juan 1:1

#interlineal(
  idioma: "griego",
  (
    (original: [Ἐν], translit: "en", gloss: "en"),
    (original: [ἀρχῇ], translit: "archē", gloss: "[el] principio"),
    (original: [ἦν], translit: "ēn", gloss: "era"),
    (original: [ὁ], translit: "ho", gloss: "el"),
    (original: [λόγος], translit: "lógos", gloss: "Verbo"),
  ),
)

= Interlineal — Génesis 1:1 (hebreo, de derecha a izquierda)

#interlineal(
  idioma: "hebreo",
  color: rgb("#8b2e3a"),
  (
    (original: [בְּרֵאשִׁית], translit: "bərēʾšît", gloss: "en el principio"),
    (original: [בָּרָא], translit: "bārāʾ", gloss: "creó"),
    (original: [אֱלֹהִים], translit: "ʾĕlōhîm", gloss: "Dios"),
  ),
)

#pagebreak()

= Texto en paralelo — versículo completo

#blockquote-paralelo(
  [Ἐν ἀρχῇ ἦν ὁ λόγος, καὶ ὁ λόγος ἦν πρὸς τὸν θεόν, καὶ θεὸς ἦν ὁ λόγος.],
  [En el principio era el Verbo, y el Verbo era con Dios, y el Verbo era Dios.],
  idioma: "griego",
  referencia: "Juan 1:1",
  color: rgb("#0EA5E9"),
)

#blockquote-paralelo(
  [בְּרֵאשִׁית בָּרָא אֱלֹהִים אֵת הַשָּׁמַיִם וְאֵת הָאָרֶץ],
  [En el principio creó Dios los cielos y la tierra.],
  idioma: "hebreo",
  referencia: "Génesis 1:1",
  color: rgb("#8b2e3a"),
)
