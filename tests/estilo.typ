// Tests de estilo.typ. Compilar:
//   typst compile --root . --font-path Fonts tests/estilo.typ
#import "../src/estilo.typ" as estilo

#let pieza = (
  name: "a", index: 2, total: 5,
  format: (1080, 1350),
  palette: (background: red, text: white, muted: gray, accent: blue, line: gray),
  blocks: (
    (type: "title", text: [Uno]),
    (type: "body", text: [Cuerpo A]),
    (type: "body", text: [Cuerpo B]),
    (type: "number", value: 3, total: 8),
  ),
  options: (:),
)

#assert.eq(estilo.bloques(pieza, "body").len(), 2)
#assert.eq(estilo.bloque(pieza, "body").text, [Cuerpo A])
#assert.eq(estilo.bloque(pieza, "nada"), none)
#assert.eq(estilo.texto(pieza, "title"), [Uno])
#assert.eq(estilo.texto(pieza, "nada", defecto: [x]), [x])
// un bloque sin `text` (number) no lo inventa
#assert.eq(estilo.texto(pieza, "number"), none)
#assert.eq(estilo.formato(pieza), (1080pt, 1350pt))
#assert.eq(estilo.formato((:), defecto: (100, 200)), (100pt, 200pt))
#assert.eq(estilo.paleta(pieza).background, red)
#assert.eq(estilo.paleta((:)).background, rgb("#141414"))
// `none` (la pieza no lo declara) cuenta como ausente
#assert.eq(estilo.formato((format: none), defecto: (100, 200)), (100pt, 200pt))
#assert.eq(estilo.paleta((palette: none)).background, rgb("#141414"))
#assert.eq(estilo.marca((brand: none), red), none)
// sin marca, none; con marca, se llama con (color, formato)
#assert.eq(estilo.marca(pieza, red), none)
#assert.eq(estilo.marca(pieza + (brand: (c, f) => [#repr(c)]), red), [#repr(red)])
