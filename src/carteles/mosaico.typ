// ─────────────────────────────────────────────────────────────
//  carteles/mosaico.typ — preset «mosaico»
//
//  Portada gráfica de líneas concéntricas y formas macizas: diez arcos
//  paralelos (una «C» abierta o una «U» inclinada a 45°) con círculos y un
//  rombo de contrapunto, y dos líneas de texto con mucho espaciado, una
//  vertical al margen y otra al pie. Tres variantes de la misma idea, con
//  los tres colores del tema rotando de papel (fondo, círculo, acento).
//
//  Las medidas salen de una lámina de referencia de 802,5 × 1117,5 (1 :
//  1,393) y se escalan con el lado menor; en otro formato la composición
//  queda centrada y el color de fondo llena el resto. Por defecto no es un
//  cartel de cita: sin `frase`, `etiqueta` ni `remate` lleva solo `autor` y
//  `obra` como rótulos; con ellos suma un título, un párrafo y una palabra
//  apilada, como `carteles.teselas`.
//
//  Ese texto no va en cajas fijas: el arte (arcos, colas, círculos, rombo y
//  rótulos) se describe como obstáculos con los mismos números con que se
//  dibuja, y el texto toma la mayor caja libre a `_aire` de ellos, según un
//  plan por variante: en la «C» y la «U» inversa, un bloque como el de
//  teselas (título, párrafo y la pila a su derecha) en la banda de arriba;
//  en la «U», la pila arriba a la derecha y título y párrafo abajo a la
//  derecha, los dos al borde del pie; en formatos más altos que la lámina,
//  la banda sube; en apaisados, el bloque va en la banda lateral. Si el
//  párrafo no cabe ni a `minimo`, cede el título y luego la pila; si aun así
//  no cabe, error: nunca pisa el arte ni baja del mínimo legible.
//
//  `area` acota la composición entera (lámina y texto) a una parte de la
//  página, `ancla` la apoya, y `arte` achica la lámina dentro del área para
//  dejar sitio al texto (con `arte: auto`, lo justo para que quepa). Por
//  defecto, la página entera y la lámina llenándola, como siempre.
//
//  Se usa desde el namespace `carteles` (carteles.mosaico). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "../pliego.typ": pliego
#import "_base.typ": medida, area-trabajo, encajar
#import "_temas.typ": resolver-tema
#import "_arcos.typ": arcos, contorno-arcos
#import "_texto.typ": resolver-bloque
#import "_huecos.typ": ob-poligono, ob-circulo, ob-rombo, ob-caja

// Lámina de referencia: la zona coloreada, sin el marco blanco (px).
#let _ref = (802.5, 1117.5)

// Las tres composiciones. Posiciones y diámetros en px de la lámina de
// referencia, desde la esquina de arriba a la izquierda de la zona
// coloreada; los colores son ROLES del tema, no valores. Todo está medido
// sobre el render de la referencia (no sobre su SVG: los diámetros del SVG
// salían un 10 % más grandes que lo que se dibuja).
//   grosor   grosor de las líneas
//   titulo   el rótulo vertical: x = su eje, y = donde empieza (lee hacia abajo)
//   pie-x    borde derecho del rótulo del pie
#let _variantes = (
  // «C»: diez arcos con la boca a la derecha, rombo en la boca y un
  // círculo hondo abajo a la izquierda.
  c: (
    papel: "fondo",
    grosor: 10.5,
    arcos: (centro: (441.2, 531.3), radio: 58.6, paso: 28.48, desde: 45deg, hasta: 315deg, cola: (0, 0), color: "tinta"),
    circulos: ((centro: (215.3, 872.6), d: 261.1, color: "hondo"),),
    rombos: ((centro: (577.35, 535.15), diag: 133, color: "acento"),),
    texto: "hondo",
    titulo: (x: 49.5, y: 169),
    pie-x: 717,
    // el texto: la banda libre sobre los arcos, como en teselas
    planes: "banda",
  ),
  // «U» hacia abajo y a la derecha: el brazo largo sale por el borde.
  u: (
    papel: "acento",
    grosor: 7.5,
    arcos: (centro: (363.1, 474.7), radio: 60.2, paso: 20.87, eje: 45deg, cola: (247.3, 4000), color: "tinta"),
    circulos: (
      (centro: (412.65, 227.0), d: 294.4, color: "fondo"),
      (centro: (261.05, 915.25), d: 151.6, color: "hondo"),
    ),
    rombos: (),
    texto: "hondo",
    titulo: (x: 61.5, y: 676),
    pie-x: 702,
    // el texto: pila arriba a la derecha, título y párrafo abajo a la derecha (bajo el brazo largo)
    planes: "diagonal",
  ),
  // «U» hacia abajo y a la izquierda, sobre fondo hondo, líneas en gris.
  u-inversa: (
    papel: "hondo",
    grosor: 7.5,
    arcos: (centro: (465.2, 497.5), radio: 26.6, paso: 20.87, eje: 135deg, cola: (302, 302), color: "suave"),
    circulos: (
      (centro: (386.15, 289.85), d: 203.5, color: "acento"),
      (centro: (442.95, 784.05), d: 327.0, color: "fondo"),
    ),
    rombos: (),
    texto: "suave",
    titulo: (x: 743.5, y: 121),
    pie-x: 688,
    // el texto: la banda libre de arriba, sobre el círculo naranja
    planes: "banda",
  ),
)

// ── el texto: dónde cabe, a partir del arte ─────────────────
// Distancias en unidades de la lámina.
#let _aire = 28 // del texto al arte y a los rótulos (≈ el paso de los arcos de la «C»)
#let _margen = 40 // del texto al borde de la página (el rótulo vertical queda a 40 del suyo)
#let _junta = 28 // entre la pila y la columna de título y párrafo
#let _arriba = _ref.at(1) - 1064 // primera línea: tan lejos del borde de arriba como el pie del de abajo

#let _texto(
  v, X, Y, L, pagina, trabajo,
  color: black, fuente: "Jost", grosor: 7.5,
  autor: none, obra: none, marca: none,
  etiqueta: none, frase: none, remate: none,
  cuerpo: auto, minimo: auto, fuente-texto: "Outfit", guias: false, quien: "carteles.mosaico",
  pila-min: 0.45, probar: false,
) = {
  let (ox, oy, ancho, alto) = pagina
  let (ax, ay, aw, ah) = trabajo
  let u = L(1)
  let a = v.arcos
  // ── el arte, como obstáculos (de los mismos números con que se dibuja) ──
  let lineas = contorno-arcos(a.centro, a.radio, lineas: 10, paso: a.paso, grosor: grosor,
    desde: a.at("desde", default: 0deg), hasta: a.at("hasta", default: 360deg),
    eje: a.at("eje", default: none), cola: a.cola)
  let obs = lineas.map(p => ob-poligono(p, aire: _aire))
  obs += v.circulos.map(c => ob-circulo(c.centro, c.d / 2, aire: _aire))
  obs += v.rombos.map(r => ob-rombo(r.centro, r.diag, aire: _aire))
  // los rótulos, medidos con su tipografía
  let rotulo(t) = measure(text(font: fuente, size: L(19), tracking: 0.65em, weight: 400, upper(t)))
  if autor != none {
    let m = rotulo(autor)
    obs.push(ob-caja((v.titulo.x - 9.5, v.titulo.y, v.titulo.x + 9.5, v.titulo.y + m.width / u), aire: _aire))
  }
  let pie-arriba = 1064 - 19
  if obra != none {
    let m = rotulo(obra)
    obs.push(ob-caja((v.pie-x - m.width / u, pie-arriba, v.pie-x, pie-arriba + m.height / u + 5), aire: _aire))
  }
  if marca != none {
    let m = measure(marca)
    obs.push(ob-caja((45, _ref.at(1) - 40 - m.height / u, 45 + m.width / u, _ref.at(1) - 40), aire: _aire))
  }
  // el área de trabajo (por defecto, la página entera) en unidades de la
  // lámina, menos el margen
  let lim = ((ax - ox) / u + _margen, (ay - oy) / u + _margen, (ax + aw - ox) / u - _margen, (ay + ah - oy) / u - _margen)

  // ── los planes, por orden de preferencia ──
  // el texto arranca donde arranca el motivo de líneas, y la pila se alinea
  // con el borde derecho del pie
  let izq = calc.min(..lineas.map(p => calc.min(..p.map(q => q.at(0)))))
  let pie = v.pie-x
  let planes = ()
  // apaisado: si al lado de la lámina queda una banda ancha, el texto va
  // ahí: primero del lado contrario al rótulo vertical, luego del otro
  let rot-x0 = if autor != none { v.titulo.x - 9.5 } else { _ref.at(0) }
  let rot-x1 = if autor != none { v.titulo.x + 9.5 } else { 0 }
  let borde-izq = calc.min(izq, rot-x0) - 2 * _aire // donde acaba, por la izquierda, el arte
  let borde-der = calc.max(pie, rot-x1) + 2 * _aire // y por la derecha
  // a la derecha: la columna arranca pasado el arte; la pila, al borde de la página
  let derecha = (pila: (x: lim.at(2), y: _arriba), columna: (x: borde-der, y: _arriba, hasta: lim.at(2)))
  // a la izquierda: la columna al borde de la página; la pila, junto al arte
  let izquierda = (pila: (x: borde-izq, y: _arriba), columna: (x: lim.at(0), y: _arriba, hasta: borde-izq))
  let lados = if v.titulo.x < _ref.at(0) / 2 { (derecha, izquierda) } else { (izquierda, derecha) }
  for l in lados {
    if calc.abs(l.columna.hasta - l.columna.x) >= 300 { planes.push(l) }
  }
  // la banda de arriba, a la altura de la lámina; si no cabe, más arriba
  // (en formatos más altos que la lámina hay sitio sobre ella)
  let ys = (_arriba,)
  let y = _arriba - 10
  while y > lim.at(1) { ys.push(y); y -= 10 }
  if lim.at(1) < _arriba { ys.push(lim.at(1)) }
  for y in ys { planes.push((pila: (x: pie, y: y), columna: (x: izq, y: y, hasta: pie))) }
  if v.planes == "diagonal" {
    // pila arriba a la derecha y el bloque abajo a la derecha, sobre el pie:
    // los dos al borde del pie, a uno y otro lado del brazo largo
    let fondo = if obra != none { pie-arriba - _aire - 1 } else { 1064 }
    planes.push((pila: (x: pie, y: _arriba),
      columna: (x: pie, y: fondo, alinear: "derecha", ancla: "abajo", hasta: lim.at(0))))
  }

  let k = _ref.at(0) / 300
  resolver-bloque(L, X, Y, color, color, planes, obs, lim, k: k, pila-min: pila-min, probar: probar,
    etiqueta: etiqueta, frase: frase, remate: remate,
    cuerpo: if cuerpo == auto { 7.4 * k } else { cuerpo },
    // a 1080 px de ancho, 22 px; en otro ancho, en proporción
    minimo: if minimo == auto { 22pt * (ancho / 1080pt) / u } else { minimo * 1pt / u },
    junta: _junta, fuente: fuente-texto, guias: guias, quien: quien)
}

// escalas que prueba `arte: auto`, de mayor a menor
#let _escalas-arte = (1, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6)

// ── carteles.mosaico ────────────────────────────────────────
//   autor    rótulo vertical al margen (str o contenido), en mayúsculas
//            muy espaciadas
//   obra     rótulo al pie, a la derecha
//   marca    contenido abajo a la izquierda (p. ej. el logo)
//   variante "c" · "u" · "u-inversa"
//   tema     nombre de `temas-lamina` (por defecto "mosaico"), diccionario
//            de roles o `tema-desde-theme(theme.base)`. Roles: fondo,
//            tinta (las líneas), suave, acento, hondo. `fondo`, `tinta`,
//            `suave`, `acento` y `hondo`, si se pasan, pisan al tema.
//   fuente   tipografía de los rótulos (por defecto Jost)
//   etiqueta, frase, remate   el texto como en `carteles.teselas`: título en
//            negrita, párrafo en gris y una palabra pesada apilada (dos
//            letras por línea). Cada variante los pone donde el arte deja
//            sitio (ver arriba); si no se dan, la lámina sale como siempre.
//            Un título que no cabe en una línea se parte en dos.
//   cuerpo   tamaño máximo del párrafo, en px de la lámina (auto = el de
//            `teselas`, a escala); se achica hasta `minimo` si hace falta
//   minimo   tamaño mínimo del párrafo, en px de la IMAGEN final (auto = 22
//            px por cada 1080 de ancho: menos no se lee en un móvil)
//   guias    true: dibuja los obstáculos y las cajas del texto, y en verde
//            el área de trabajo (depurar)
//   fuente-texto   tipografía de ese texto (por defecto Outfit, como `teselas`;
//            `fuente` sigue siendo la de los rótulos espaciados)
//   grosor   grosor de las líneas, en px de la lámina de referencia (auto =
//            el de la variante)
//   area     el rectángulo de trabajo: arte y texto van dentro y el resto de
//            la página queda libre (solo el fondo). 1 = la página entera (por
//            defecto); un número o ratio (0,7 · 70 %) para los dos lados; un
//            par (ancho, alto), p. ej. (100 %, 70 %). El texto busca su sitio
//            dentro del área; `minimo` sigue siendo en px de la imagen, así
//            que un área chica deja sitio a menos texto. (Excepción: el brazo
//            largo de la «U» sigue saliendo por el borde de la página, como
//            en la lámina.)
//   ancla    dónde va el área en la página y la lámina dentro del área (si
//            sobra sitio): center + horizon (por defecto), top, bottom + left…
//   arte     tamaño de la lámina dentro del área: 1 = la llena por su lado
//            menor (por defecto); 0,8 = al 80 %, apoyada según `ancla`, y el
//            sitio que deja lo puede usar el texto (p. ej. `arte: 0.85, ancla:
//            bottom` en la «U» sube el texto a la banda de arriba, en
//            bandera a la derecha). auto = la mayor escala, de 1 a 0,6, con la
//            que el texto cabe sin que la pila baje del 80 %; si no hay
//            ninguna, la que deja caber el texto aunque la pila ceda.
#let mosaico(
  autor: none,
  obra: none,
  marca: none,
  formato: (1080, 1350),
  variante: "c",
  tema: "mosaico",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  hondo: auto,
  fuente: "Jost",
  grosor: auto,
  frase: none,
  etiqueta: none,
  remate: none,
  cuerpo: auto,
  fuente-texto: "Outfit",
  minimo: auto,
  guias: false,
  area: 1,
  ancla: center + horizon,
  arte: 1,
) = {
  if not variante in _variantes {
    panic("mosaico: variante desconocida " + repr(variante) + " — disponibles: " + _variantes.keys().join(", "))
  }
  let v = _variantes.at(variante)
  let (ancho, alto) = medida(formato)
  let arte = if type(arte) == ratio { arte / 100% } else { arte }
  if arte != auto and (type(arte) not in (int, float) or arte <= 0 or arte > 1) {
    panic("carteles.mosaico: `arte` es auto o una fracción entre 0 y 1, no " + repr(arte))
  }
  // el rectángulo de trabajo (por defecto, la página entera)
  let trabajo = area-trabajo(formato, area: area, ancla: ancla, quien: "carteles.mosaico")
  let tm = resolver-tema(tema, defecto: "mosaico")
  let rol = (
    fondo: if fondo == auto { tm.fondo } else { fondo },
    tinta: if tinta == auto { tm.tinta } else { tinta },
    suave: if suave == auto { tm.suave } else { suave },
    acento: if acento == auto { tm.acento } else { acento },
    hondo: if hondo == auto { tm.hondo } else { hondo },
  )
  let hay-texto = etiqueta != none or frase != none or remate != none
  let gr = if grosor == auto { v.grosor } else { grosor }

  // La lámina de referencia encajada en el área (centrada, o según `ancla`),
  // a una fracción `q` del tamaño con que la llena: su esquina y sus medidas.
  let lamina(q) = {
    let (ox, oy, s) = encajar(trabajo, _ref, ancla: ancla, escala: q)
    (ox: ox, oy: oy, X: u => ox + u * s * 1pt, Y: u => oy + u * s * 1pt, L: u => u * s * 1pt)
  }
  let texto(g, probar, pila-min: 0.45) = _texto(v, g.X, g.Y, g.L, (g.ox, g.oy, ancho, alto), trabajo,
    color: rol.at(v.texto), fuente: fuente, grosor: gr,
    autor: autor, obra: obra, marca: marca, etiqueta: etiqueta, frase: frase, remate: remate,
    cuerpo: cuerpo, minimo: minimo, fuente-texto: fuente-texto, guias: guias,
    quien: "carteles.mosaico(variante: " + repr(variante) + ")", pila-min: pila-min, probar: probar)

  let dibujar(g, pila-min: 0.45) = {
    let (X, Y, L) = (g.X, g.Y, g.L)
    // ── las líneas ──
    let a = v.arcos
    arcos(
      (X(a.centro.at(0)), Y(a.centro.at(1))),
      L(a.radio),
      lineas: 10,
      paso: L(a.paso),
      grosor: L(gr),
      desde: a.at("desde", default: 0deg),
      hasta: a.at("hasta", default: 360deg),
      eje: a.at("eje", default: none),
      cola: (L(a.cola.at(0)), L(a.cola.at(1))),
      color: rol.at(a.color),
    )

    // ── círculos macizos (encima de las líneas, como en la lámina) ──
    for c in v.circulos {
      let d = L(c.d)
      place(top + left, dx: X(c.centro.at(0)) - d / 2, dy: Y(c.centro.at(1)) - d / 2,
        circle(radius: d / 2, fill: rol.at(c.color)))
    }
    // ── rombos: un cuadrado girado 45°, de diagonal `diag` ──
    for r in v.rombos {
      let lado = L(r.diag) / calc.sqrt(2)
      place(top + left, dx: X(r.centro.at(0)) - lado / 2, dy: Y(r.centro.at(1)) - lado / 2,
        rotate(45deg, origin: center, rect(width: lado, height: lado, fill: rol.at(r.color))))
    }

    // ── rótulos ──
    set text(font: fuente, fill: rol.at(v.texto), size: L(19), tracking: 0.65em, weight: 400)
    if autor != none {
      place(top + left, dx: X(v.titulo.x) - L(19) / 2, dy: Y(v.titulo.y),
        rotate(90deg, reflow: true, upper(autor)))
    }
    if obra != none {
      place(top + right, dx: -(ancho - X(v.pie-x)), dy: Y(1064) - L(19),
        upper(obra))
    }
    // ── título, párrafo y pila (como en teselas), si se pidieron ──
    if hay-texto { context texto(g, false, pila-min: pila-min) }
    if marca != none {
      place(bottom + left, dx: X(45), dy: -(alto - Y(_ref.at(1)) + L(40)), marca)
    }
    if guias {
      // el área de trabajo, en verde (los obstáculos y las cajas del texto
      // los dibuja la capa de texto)
      let (ax, ay, aw, ah) = trabajo
      place(top + left, dx: ax, dy: ay, rect(width: aw, height: ah, stroke: (paint: green, thickness: 1pt, dash: "dashed")))
    }
  }

  pliego(width: ancho, height: alto, margin: 0pt, fill: rol.at(v.papel),
    if arte == auto and hay-texto {
      // el arte cede: la mayor escala (de 1 a 0,6 del área) con la que el
      // texto cabe, primero sin que la pila baje del 80 % (el arte se achica
      // antes que ella) y, si así no cabe, dejándola ceder como siempre; si
      // ni así, se dibuja a 0,6 y la capa de texto da el error
      context {
        let hecho = none
        for pm in (0.8, 0.45) {
          let q = _escalas-arte.find(q => texto(lamina(q), true, pila-min: pm))
          if q != none { hecho = (q: q, pm: pm); break }
        }
        if hecho == none { hecho = (q: _escalas-arte.last(), pm: 0.45) }
        dibujar(lamina(hecho.q), pila-min: hecho.pm)
      }
    } else {
      dibujar(lamina(if arte == auto { 1 } else { arte }))
    })
}
