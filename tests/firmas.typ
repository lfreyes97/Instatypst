// Tests de la tabla de firmas. Compilar:
//   typst compile --root . --font-path Fonts tests/firmas.typ
// Si falla, la tabla de src/carteles/firmas.typ se desincronizó del código.

#import "../src/lib.typ": carteles

#let f = carteles.firmas
#let nombres = f.keys()

#assert.eq(nombres.len(), 23, message: "deben figurar los 23 presets de página (rayar es pieza suelta)")

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
  // contrato de bloques
  let cat = carteles.bloques-catalogo
  assert(type(e.bloques) == dictionary and "requeridos" in e.bloques and "opcionales" in e.bloques,
    message: donde + ": bloques debe tener requeridos y opcionales")
  let usados = ()
  for b in e.bloques.requeridos + e.bloques.opcionales {
    // un elemento-array es «uno de»
    let alternativas = if type(b) == array { b } else { (b,) }
    for a in alternativas {
      assert(a in cat, message: donde + ": bloque fuera del catálogo: " + a)
      assert(a not in usados, message: donde + ": bloque repetido en la firma: " + a)
      usados.push(a)
    }
  }

  assert(type(e.at("marca-funcion", default: false)) == bool, message: donde + ": marca-funcion debe ser bool")
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

// El parentesco apunta a bloques del catálogo y no tiene ciclos.
#for (hijo, padre) in carteles.bloques-padre {
  assert(hijo in carteles.bloques-catalogo and padre in carteles.bloques-catalogo,
    message: "bloques-padre fuera del catálogo: " + hijo + " → " + padre)
  let actual = padre
  let pasos = 0
  while actual in carteles.bloques-padre {
    actual = carteles.bloques-padre.at(actual)
    pasos += 1
    assert(pasos < 5 and actual != hijo, message: "ciclo en bloques-padre desde " + hijo)
  }
}
#assert.eq(carteles.bloques-padre.verse, "quote")

// Casos del contrato de bloques que no deben cambiar sin pensarlo.
#assert.eq(f.liso.bloques.requeridos, ("body",))
#assert.eq(f.contraste.bloques.requeridos, ("contrast",))
#assert.eq(f.contraste.pos, ("izquierda", "derecha"))
#assert.eq(f.evento.pos, ("dia", "mes", "titulo"))
#assert.eq(f.consejo.pos, ("numero", "titulo"))
#assert.eq(f.lamina.pos, ("numero", "total", "titulo"))
#assert.eq(f.consejo.bloques.requeridos, ("number", "title"))
#assert.eq(f.evento.bloques.requeridos, ("date", "title"))
#assert.eq(f.suizo.bloques.requeridos, ("title", "conclusion"))
#assert.eq(f.gozne.bloques.requeridos, (("quote", "body"), "title", "list"))
#assert.eq(f.at("capitulo-orlado").bloques.requeridos, ("number", "title"))

#assert(f.liso.at("marca-funcion", default: false), message: "liso acepta una marca en función")
#assert(not f.epigrafe.at("marca-funcion", default: false), message: "epigrafe aún no acepta una marca en función")

#metadata(nombres.sorted()) <firmas-nombres>
