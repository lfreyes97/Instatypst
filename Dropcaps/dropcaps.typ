#let _partibles = (strong, emph, underline, stroke, overline, highlight, smallcaps)
#let _espacio = [ ].func()

#let _unir(hijos) = if hijos.len() == 0 { [] } else { hijos.join() }

#let _con-etiqueta((primero, segundo), etiqueta) = {
  if etiqueta == none {
    (primero, segundo)
  } else if segundo != none {
    (primero, [#segundo#etiqueta])
  } else if primero != none {
    ([#primero#etiqueta], segundo)
  } else {
    (none, none)
  }
}

#let _a-texto(c) = {
  if type(c) == str {
    c
  } else if c.has("text") {
    _a-texto(c.text)
  } else if c.has("child") {
    _a-texto(c.child)
  } else if c.has("children") {
    c.children.map(_a-texto).join()
  } else if c.func() in _partibles {
    _a-texto(c.body)
  } else if c.func() == smartquote {
    if c.double { "\"" } else { "'"}
  } else if c.func() == space {
    " "
  } else {
    ""
  }
}

#let _puntos(c) = {
  if type(c) == str {
    c.split(" ").len() - 1
  } else if c.has("text") {
    _puntos(c.text)
  } else if c.has("child") {
    _puntos(c.child)
  } else if c.has("children") {
    c.children.map(_puntos).sum(default: 0)
  } else if c.func() in _partibles {
    _puntos(c.body)
  } else if c.func() in (_espacio, linebreak, parbreak) {
    1
  } else {
    0
  }
}

#let _dividir(c, indice) = {
  if indice > _puntos(c) {
    return (c, none, none)
  }
  if indice < 0 {
    return _dividir(c, calc.max(0, _puntos(c) + indice + 1))
  }

  if type(c) == str {
    let palabras = c.split(" ")
    return (palabras.slice(0, indice).join(" "), palabras.slice(indice).join(" "), " ")
  }

  if c.has("text") {
    let (text: texto, ..campos) = c.fields()
    let etiqueta = if c.has("label") { c.label } else { none }
    let reconstruye(it) = if it != none { c.func()(..campos, it) }
    let (a, b, sep) = _dividir(texto, indice)
    return (.._con-etiqueta((reconstruye(a), reconstruye(b)), etiqueta), sep)
  }

  if c.func() in _partibles {
    let (body: texto, ..campos) = c.fields()
    let etiqueta = if c.has("label") { c.label } else { none }
    let reconstruye(it) = if it != none { c.func()(..campos, it) }
    let (a, b, sep) = _dividir(texto, indice)
    return (.._con-etiqueta((reconstruye(a), reconstruye(b)), etiqueta), sep)
  }

  if c.has("child") {
    let (child: hijo, styles: estilos, ..campos) = c.fields()
    let etiqueta = if c.has("label") { c.label } else { none }
    let reconstruye(it) = if it != none { c.func()(it, estilos) }
    let (a, b, sep) = _dividir(hijo, indice)
    return (.._con-etiqueta((reconstruye(a), reconstruye(b)), etiqueta), sep)
  }

  if c.has("children") {
    let primero = ()
    let segundo = ()
    let sep = none
    let sub = indice
    for (i, hijo) in c.children.enumerate() {
      let puntos-hijo = _puntos(hijo)
      if sub <= puntos-hijo {
        if hijo.func() not in (_espacio, linebreak, parbreak) {
          let (ha, hb, hsep) = _dividir(hijo, sub)
          primero.push(ha)
          segundo.push(hb)
          sep = hsep
        } else {
          sep = hijo
        }
        segundo += c.children.slice(i + 1)
        break
      }
      sub -= puntos-hijo
      primero.push(hijo)
    }
    return (_unir(primero), _unir(segundo), sep)
  }

  if indice == 0 { (none, c, none) } else { (c, none, none) }
}

#let _antes = regex("[" + "\"'" + "\u{00A0}\u{2000}-\u{200F}\u{2028}-\u{202F}\u{205F}-\u{3000}" + "\u{00AB}\u{201C}\u{2018}(\[\{" + "]+")
#let _despues = regex("[" + ".\"'" + ",;:!?\u{00BB}\u{201D}\u{2019})\]\}" + "\u{0300}-\u{036F}" + "]+")

#let _inicial(c) = {
  if type(c) == str {
    if c == "" {
      return (none, c)
    }
    return (c.clusters().at(0), c.clusters().slice(1).join())
  }
  if c.has("text") {
    let (text: texto, ..campos) = c.fields()
    let reconstruye(it) = if it != none { c.func()(..campos, it) }
    let (letra, resto) = _inicial(texto)
    return (letra, reconstruye(resto))
  }
  if c.func() in _partibles {
    let (body: texto, ..campos) = c.fields()
    let reconstruye(it) = if it != none { c.func()(..campos, it) }
    let (letra, resto) = _inicial(texto)
    return (letra, reconstruye(resto))
  }
  if c.has("child") {
    let (child: hijo, styles: estilos, ..campos) = c.fields()
    let reconstruye(it) = if it != none { c.func()(it, estilos) }
    let (letra, resto) = _inicial(hijo)
    return (letra, reconstruye(resto))
  }
  if c.has("children") {
    let pos = c.children.position(h => h.func() not in (_espacio, parbreak))
    if pos == none {
      return (none, c)
    }
    let (letra, resto) = _inicial(c.children.at(pos))
    let cola = c.children.slice(pos + 1)
    return (letra, _unir((resto,) + cola))
  }
  return (c, none)
}

#let _extraer(cuerpo) = {
  let (letra, resto) = _inicial(cuerpo)
  if letra == none {
    return (none, cuerpo)
  }
  let cadena = _a-texto(letra)
  if cadena != "" {
    while _antes in cadena.last() {
      let (sig, nuevo-resto) = _inicial(resto)
      if sig == none { break }
      letra += sig
      resto = nuevo-resto
      cadena = _a-texto(sig)
    }
    let (sig, nuevo-resto) = _inicial(resto)
    while _a-texto(sig) != "" and _despues in _a-texto(sig).first() {
      letra += sig
      resto = nuevo-resto
      (sig, nuevo-resto) = _inicial(resto)
    }
  }
  (letra, resto)
}

#let _en-linea(elem) = elem != none and measure(h(0.1pt) + elem).width > measure(elem).width

#let _dimensionado(alto, letra, ..args) = context {
  let nombrados = args.named()
  if "size" in nombrados {
    text(..args)
  } else {
    let base = 10pt
    let m = measure(text(..nombrados, size: base, letra)).height
    let factor = if m > 0pt { alto / m } else { 1 }
    text(..nombrados, size: base * factor, letra)
  }
}

#let _resolver-alto(alto) = if type(alto) == int { measure([x\ ] * alto).height } else { alto.to-absolute() }

#let capitular(
  cuerpo,
  letra: none,
  alto: 2,
  justificar: auto,
  hueco: 0.08em,
  sangria: 0pt,
  profundidad: 0,
  transformar: none,
  ..args-texto,
) = layout(reg => {
  let args = args-texto
  if alto != auto {
    if "top-edge" not in args.named() {
      args = arguments(..args, top-edge: "bounds")
    }
    if "bottom-edge" not in args.named() {
      args = arguments(..args, bottom-edge: "bounds")
    }
  }

  let (inicial, resto) = if letra != none {
    (letra, cuerpo)
  } else {
    let (l, r) = _extraer(cuerpo)
    assert(l != none, message: "el cuerpo no contiene ninguna letra inicial")
    (l, r)
  }

  if transformar != none {
    inicial = context transformar(inicial)
  }

  let alto-letra = if alto == auto {
    measure(text(..args.named(), inicial)).height
  } else {
    _resolver-alto(alto)
  }
  let prof = _resolver-alto(profundidad)

  let caja-letra = box(height: alto-letra + prof, _dimensionado(alto-letra, inicial, ..args))
  let ancho-letra = measure(caja-letra).width

  let justificar = if justificar == auto { par.justify } else { justificar }

  let acotado = box.with(width: reg.width - ancho-letra - hueco)

  let i = 1
  let posicion-top = 0pt
  let altura-previa = 0pt
  let (primera, segunda, sep) = while true {
    let (a, b, _) = _dividir(resto, i)
    let a = {
      set par(hanging-indent: sangria, justify: justificar)
      a
    }
    let altura = measure(acotado(a)).height
    let (_, nueva, _) = _dividir(a, -1)
    posicion-top = calc.max(
      posicion-top,
      altura - measure(nueva).height - par.leading.to-absolute(),
    )

    if posicion-top >= alto-letra + prof - 1e-6pt and altura > altura-previa {
      _dividir(resto, i - 1)
      break
    }

    if b == none {
      (a, none, none)
      break
    }

    i += 1
    altura-previa = altura
  }

  set par(justify: justificar)

  let hay-salto = type(sep) == content and sep.func() in (linebreak, parbreak)
  if not hay-salto {
    let s = _dividir(primera, -1).at(2)
    hay-salto = type(s) == content and s.func() in (linebreak, parbreak)
  }

  let ultimo-de-primera = _dividir(primera, -1).at(1)
  let primero-de-segunda = if segunda == none { none } else { _dividir(segunda, 1).at(0) }

  let envuelve(body-content) = if _en-linea(ultimo-de-primera) {
    box(body-content) + linebreak()
  } else {
    block(body-content)
  }

  envuelve(grid(
    column-gutter: hueco,
    columns: (ancho-letra, 1fr),
    caja-letra,
    {
      set par(hanging-indent: sangria)
      primera
      if not hay-salto and _en-linea(ultimo-de-primera) and _en-linea(primero-de-segunda) {
        linebreak(justify: justificar)
      }
    },
  ))

  if type(sep) == content and sep.func() in (linebreak, parbreak) { sep }

  segunda
})
