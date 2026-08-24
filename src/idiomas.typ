// ─────────────────────────────────────────────────────────────
//  IDIOMAS — capa de la API de texto para frases en otro guion:
//  latín, griego politónico y hebreo (con niqqud), más transliteración
//  e interlineal. Cada función usa la fuente que de verdad se verificó
//  compilando con ese guion (ver font-tokens.typ: by-script) — ninguna
//  fuente nueva, solo las que ya estaban en el proyecto:
//
//    latín   -> EB Garamond (cursiva, como se cita en teología/filosofía)
//    griego  -> GFS Didot (auténtico) o Libertinus Serif (consistente)
//    hebreo  -> Libertinus Serif — la única fuente del proyecto con
//               cobertura de hebreo (con niqqud), confirmado renderizando
//               Génesis 1:1 completo
//
//  #import "idiomas.typ": lat, gr, he, translit, interlineal
//  #lat[creatio ex nihilo]
//  #gr[λόγος]              #gr(autentico: true)[λόγος]
//  #he[בְּרֵאשִׁית]
//  ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "font-tokens.typ": family

// Latín — cursiva, EB Garamond.
#let lat(body) = text(font: family("eb-garamond"), style: "italic", lang: "la")[#body]

// Griego politónico. `autentico: true` usa GFS Didot (revival de un Didot
// griego auténtico, más expresivo); por defecto usa Libertinus Serif,
// más consistente si el documento también mezcla hebreo.
#let gr(body, autentico: false) = text(
  font: if autentico { "GFS Didot" } else { family("libertinus-serif") },
  lang: "el",
)[#body]

// Hebreo, con niqqud. Fuerza dir: rtl — Typst no lo infiere solo de `lang:`.
#let he(body) = text(font: family("libertinus-serif"), lang: "he", dir: rtl)[#body]

// Transliteración (texto romanizado) — cursiva, convención académica/SBL
// para distinguirla del cuerpo normal. `color:` opcional para que resalte
// dentro de un interlineal o una cita.
#let translit(body, color: none) = text(style: "italic", fill: color)[#body]

// ─────────────────────────────────────────────────────────────
//  INTERLINEAL — texto original + transliteración + glosa, palabra por
//  palabra, en columnas. `idioma: "hebreo"` pone el bloque en RTL — el
//  orden de `palabras` se da SIEMPRE en orden de lectura natural (la
//  primera palabra del versículo primero en el array); grid() voltea el
//  layout visual solo con `dir: rtl`, no hace falta invertir nada a mano
//  (verificado).
//
//  palabras: array de (original: content, translit: str, gloss: str)
// ─────────────────────────────────────────────────────────────
#let interlineal(
  palabras,
  idioma: "griego", // "griego" | "hebreo" | "latin"
  color: none,
  theme: theme.base,
  tam-original: 22pt,
  tam-translit: 10pt,
  tam-gloss: 9pt,
  gutter: 14pt,
) = {
  let color = if color == none { theme.colors.primary } else { color }
  let es-rtl = idioma == "hebreo"
  let lengua = if idioma == "hebreo" { "he" } else if idioma == "griego" { "el" } else { "la" }
  let fuente-original = if idioma == "hebreo" {
    family("libertinus-serif")
  } else if idioma == "griego" {
    "GFS Didot"
  } else {
    family("eb-garamond")
  }

  block(width: 100%, above: 20pt, below: 20pt)[
    #set text(dir: if es-rtl { rtl } else { ltr })
    #grid(
      columns: (auto,) * palabras.len(),
      column-gutter: gutter,
      ..palabras.map(p => align(center)[
        #text(font: fuente-original, size: tam-original, lang: lengua, p.original)
        #v(5pt)
        #translit(text(size: tam-translit, p.translit), color: color)
        #v(2pt)
        #text(font: theme.fonts.body, size: tam-gloss, fill: gray.darken(10%), p.gloss)
      ]),
    )
  ]
}
