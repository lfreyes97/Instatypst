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
//  Se usa desde el namespace `carteles` (carteles.mosaico). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "_base.typ": medida, escala
#import "_temas.typ": resolver-tema
#import "_arcos.typ": arcos
#import "_texto.typ": capa-texto

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
    // la banda libre sobre los arcos (que empiezan en y ≈ 211)
    zona: (
      titulo: (x: 100, y: 60, ancho: 470),
      parrafo: (x: 100, y: 118, ancho: 470, alto: 78, alto-autor: 78),
      pila: (derecha: 717, y: 60, alto: 140),
      autor: (x: 100, y: 190),
    ),
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
    // la columna libre arriba a la derecha (sobre el brazo largo) y la
    // esquina de arriba a la izquierda para la pila
    zona: (
      titulo: (x: 590, y: 60, ancho: 185),
      parrafo: (x: 590, y: 130, ancho: 185, alto: 330, alto-autor: 330),
      pila: (derecha: 250, y: 50, alto: 185),
      autor: (x: 590, y: 480),
    ),
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
    // la banda libre arriba (el círculo naranja empieza en y ≈ 188) y la pila
    // arriba a la derecha, a la izquierda del rótulo vertical
    zona: (
      titulo: (x: 60, y: 60, ancho: 500),
      parrafo: (x: 60, y: 118, ancho: 500, alto: 62, alto-autor: 62),
      pila: (derecha: 700, y: 50, alto: 200),
      autor: (x: 60, y: 185),
    ),
  ),
)

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
//            sitio; si no se dan, la lámina sale como siempre.
//   cuerpo   tamaño máximo del párrafo, en px de la lámina (auto = el de
//            `teselas`, a escala)
//   fuente-texto   tipografía de ese texto (por defecto Outfit, como `teselas`;
//            `fuente` sigue siendo la de los rótulos espaciados)
//   grosor   grosor de las líneas, en px de la lámina de referencia (auto =
//            el de la variante)
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
) = {
  if not variante in _variantes {
    panic("mosaico: variante desconocida " + repr(variante) + " — disponibles: " + _variantes.keys().join(", "))
  }
  let v = _variantes.at(variante)
  let (ancho, alto) = medida(formato)
  let s = escala(formato, base: _ref)
  let tm = resolver-tema(tema, defecto: "mosaico")
  let rol = (
    fondo: if fondo == auto { tm.fondo } else { fondo },
    tinta: if tinta == auto { tm.tinta } else { tinta },
    suave: if suave == auto { tm.suave } else { suave },
    acento: if acento == auto { tm.acento } else { acento },
    hondo: if hondo == auto { tm.hondo } else { hondo },
  )

  // La lámina de referencia, centrada en la página.
  let ox = (ancho - _ref.at(0) * s * 1pt) / 2
  let oy = (alto - _ref.at(1) * s * 1pt) / 2
  let X(u) = ox + u * s * 1pt
  let Y(u) = oy + u * s * 1pt
  let L(u) = u * s * 1pt

  page(width: ancho, height: alto, margin: 0pt, fill: rol.at(v.papel), {
    // ── las líneas ──
    let a = v.arcos
    arcos(
      (X(a.centro.at(0)), Y(a.centro.at(1))),
      L(a.radio),
      lineas: 10,
      paso: L(a.paso),
      grosor: L(if grosor == auto { v.grosor } else { grosor }),
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
    // (el párrafo en el color de texto de la variante: `suave` es el gris de las líneas
    // y sobre menta o naranja no se lee)
    capa-texto(L, X, Y, rol.at(v.texto), rol.at(v.texto), v.zona, k: _ref.at(0) / 300,
      etiqueta: etiqueta, frase: frase, remate: remate,
      cuerpo: if cuerpo == auto { 7.4 * _ref.at(0) / 300 } else { cuerpo },
      fuente: fuente-texto)
    if marca != none {
      place(bottom + left, dx: X(45), dy: -(oy + L(40)), marca)
    }
  })
}
