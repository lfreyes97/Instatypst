// Tests de la tabla de firmas. Compilar:
//   typst compile --root . --font-path Fonts tests/firmas.typ
// Si falla, la tabla de src/carteles/firmas.typ se desincronizó del código.

#import "../src/lib.typ": carteles

#let f = carteles.firmas
#let nombres = f.keys()

#assert.eq(nombres.len(), 19, message: "deben figurar los 19 presets de página (rayar es pieza suelta)")

#for nombre in nombres {
  let e = f.at(nombre)
  let donde = "firmas." + nombre

  assert(type(e.pos) == array, message: donde + ": pos debe ser array")
  assert(type(e.formato) == array and e.formato.len() == 2,
    message: donde + ": formato debe ser (ancho, alto)")
  assert(e.formato.at(0) > 0 and e.formato.at(1) > 0,
    message: donde + ": formato con dimensiones no positivas")
  assert(type(e.archivo) == str and e.archivo.len() > 0,
    message: donde + ": falta archivo de origen")
  assert(type(e.uso) == str and e.uso.len() > 0,
    message: donde + ": falta la descripción")
  assert(type(e.campo) == dictionary,
    message: donde + ": campo debe ser dict de alias canónicos")
  assert(type(e.compuesto) == bool,
    message: donde + ": compuesto debe ser bool")
  assert(e.tema == none or type(e.tema) == str,
    message: donde + ": tema debe ser cadena o none")
  for p in e.pos {
    assert(type(p) == str and p.len() > 0,
      message: donde + ": nombre posicional inválido")
  }
}

// Casos que historically se escriben mal; los fijamos aquí.
#assert.eq(f.franjas.pos, ("cita",))
#assert.eq(f.franjas.formato, (1080, 1080), message: "franjas es el único 1:1")
#assert.eq(f.mosaico.pos, (), message: "mosaico no tiene posicionales")
#assert.eq(f.gozne.pos, ("cita", "centro", "hojas"))
#assert.eq(f.liso.tema, none, message: "liso no expone tema:")
#assert.eq(f.plano.tema, none, message: "plano no expone tema:")

#metadata(nombres.sorted()) <firmas-nombres>
