// Tests de marca.typ. Compilar:
//   typst compile --root . --font-path Fonts tests/marca.typ
#import "../src/marca.typ"
#import "../src/carteles/_base.typ": resolver-marca

// El alto es una fracción de √(ancho × alto): 36 pt en 1080×1080 (1/30)
#assert.eq(marca.alto((1080, 1080)), 36pt)
// y pesa lo mismo, respecto del área, en cualquier formato (mismo producto ancho×alto → mismo alto)
#assert.eq(marca.alto((1080, 1350)), marca.alto((1350, 1080)))
#assert(marca.alto((1080, 1920)) > marca.alto((1080, 1080)), message: "una story, con más área, lleva una marca mayor")
#assert.eq(marca.alto((1080, 1080), proporcion: 1 / 15), 72pt)

// resolver-marca: un contenido pasa tal cual; none, también; una función se llama con (color, lienzo)
#assert.eq(resolver-marca(none, red, (10, 10)), none)
#assert.eq(resolver-marca([hola], red, (10, 10)), [hola])
#let f = (color, lienzo) => [#repr(color) #repr(lienzo)]
#assert.eq(resolver-marca(f, red, (10, 20)), f(red, (10, 20)))

// cada constructor devuelve una función de dos argumentos
#for m in (marca.texto("@x"), marca.svg("<svg currentColor/>"), marca.imagen(bytes("x"))) {
  assert.eq(type(m), function)
}
