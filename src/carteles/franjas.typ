// ─────────────────────────────────────────────────────────────
//  carteles/franjas.typ — preset «franjas»
//
//  Cartel de cita con dos franjas y una ilustración al fondo: una cabecera de
//  color con la marca centrada, un título en mayúsculas condensadas, una regla
//  del color de la cabecera y la cita centrada. Debajo, la ilustración a
//  sangre, tapada por un velo del color del cuerpo que se disuelve de arriba
//  abajo (así el texto se lee sobre negro y la imagen aparece al fondo). Cierra
//  una tira oscura con el pie (p. ej. la web).
//
//  Es el cartel para el que se pensó el sistema de redes sociales: una serie
//  de citas de una misma cuenta, con la misma estructura y distinta imagen.
//
//  Las medidas salen de una lámina de 1080 px de ancho y se escalan con el
//  lado menor (`escala`). Las franjas y el texto no se mueven con el alto: lo
//  que crece es la ilustración.
//
//  Se usa desde el namespace `carteles` (carteles.franjas). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "../pliego.typ": pliego
#import "_base.typ": medida, escala, ajustar-alto, cuerpo-al-ancho
#import "_temas.typ": resolver-tema

// ── carteles.franjas ────────────────────────────────────────
//   cita      el texto principal, centrado. Toma el mayor cuerpo que cabe entre
//             la regla y `texto-hasta` (hasta `cuerpo-max`).
//   titulo    mayúsculas sobre la regla (se escribe en mayúsculas solo). Si no
//             cabe en el ancho, se achica. Sin título tampoco hay regla.
//   marca     contenido centrado en la cabecera (p. ej. el logo, ya con su
//             tamaño: la cabecera mide `cabecera` de alto)
//   imagen    contenido a sangre bajo el velo, p. ej.
//             `image("x.jpg", width: 100%, height: 100%, fit: "cover")` o un
//             fondo de superbg. Se recorta al lienzo. Sin imagen no hay velo:
//             el cuerpo es del color de `fondo`.
//   pie       contenido centrado en la tira de abajo (p. ej. la web)
//   tema      nombre de `temas-lamina` (por defecto "franjas"), diccionario de
//             roles o `tema-desde-theme(theme.base)`. Roles: fondo (el cuerpo
//             y el velo), tinta (el texto), suave (el pie), acento (cabecera y
//             regla), tira (la tira del pie). `fondo`, `tinta`, `suave`,
//             `acento` y `tira`, si se pasan, pisan al tema.
//   velo      (desde, hasta): fracciones del alto donde el velo deja de ser
//             opaco y donde desaparece del todo
//   texto-hasta   fracción del alto hasta donde puede llegar la cita
//   fuente    tipografía de la cita, con su `peso` y su `estiramiento` (por
//             defecto Bricolage Grotesque condensada y extraligera, que está en
//             Fonts/: tan alta y fina como la de la lámina original)
//   fuente-titulo   tipografía del título (por defecto Bebas Neue)
//   cabecera, pie-alto, pie-aire, regla, margen, margen-texto   medidas en
//             pt sobre la lámina de 1080 px (`pie-aire` es lo que se ve de la
//             imagen bajo la tira; 0pt = la tira pegada al borde)
#let franjas(
  cita,
  titulo: none,
  imagen: none,
  marca: none,
  pie: none,
  formato: (1080, 1080),
  tema: "franjas",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  tira: auto,
  velo: (34%, 92%),
  texto-hasta: 60%,
  fuente: "Bricolage Grotesque",
  peso: "extralight",
  estiramiento: 75%,
  fuente-titulo: "Bebas Neue",
  cuerpo-max: 43pt,
  cuerpo-titulo: 52pt,
  cuerpo-pie: 31pt,
  cabecera: 134pt,
  pie-alto: 57pt,
  pie-aire: 20pt,
  regla: 2.2pt,
  margen: 69pt,
  margen-texto: 78pt,
) = {
  let tm = resolver-tema(tema, defecto: "franjas")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let suave = if suave == auto { tm.suave } else { suave }
  let acento = if acento == auto { tm.acento } else { acento }
  let tira = if tira == auto { tm.tira } else { tira }

  let (ancho, alto) = medida(formato)
  let k = escala(formato)
  let cab = cabecera * k
  let m = margen * k
  let caja = ancho - 2 * m
  let caja-texto = ancho - 2 * margen-texto * k

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(fill: tinta, lang: "es", hyphenate: false)

    // la imagen a sangre y, encima, el velo del color del cuerpo
    if imagen != none {
      place(top + left, box(width: ancho, height: alto, clip: true, imagen))
      place(top + left, rect(
        width: ancho, height: alto, stroke: none,
        fill: gradient.linear(
          angle: 90deg,
          (fondo, 0%), (fondo, velo.at(0)),
          (fondo.transparentize(100%), velo.at(1)), (fondo.transparentize(100%), 100%),
        ),
      ))
    }

    // cabecera con la marca
    place(top + left, rect(width: ancho, height: cab, fill: acento, stroke: none))
    if marca != none {
      place(top + left, box(width: ancho, height: cab, align(center + horizon, marca)))
    }

    // título y regla; `y` es el borde de arriba del siguiente bloque
    let y = cab
    if titulo != none {
      let el-titulo(c) = text(
        font: fuente-titulo, size: c, top-edge: "cap-height", bottom-edge: "baseline", upper(titulo),
      )
      // la base del título queda fija (cap-height natural a 48 pt de la
      // cabecera); si el título se achica para caber, baja la parte de arriba
      let cap-natural = 0.7 * cuerpo-titulo * k
      let y-base = y + 48pt * k + cap-natural
      context {
        let natural = cuerpo-titulo * k
        let ancho-natural = measure(el-titulo(natural)).width
        let c = if ancho-natural > caja { natural * (caja / ancho-natural) } else { natural }
        place(top + center, dy: y-base - 0.7 * c, el-titulo(c))
      }
      let y-regla = y-base + 16pt * k
      place(top + left, dx: m, dy: y-regla, rect(width: caja, height: regla * k, fill: acento, stroke: none))
      y = y-regla + regla * k
    }

    // la cita: de la regla (a 24 pt) hasta `texto-hasta`
    let y-cita = y + 24pt * k
    let hueco = alto * texto-hasta - y-cita
    let bloque(c) = block(width: caja-texto, align(center, text(
      font: fuente, weight: peso, stretch: estiramiento, size: c,
      top-edge: "cap-height", bottom-edge: "baseline", cita,
    )))
    context {
      set par(leading: 0.43em)
      let c = ajustar-alto(bloque, cuerpo-max * k, hueco, minimo: 18pt * k)
      place(top + center, dy: y-cita, bloque(c))
    }

    // tira del pie
    if pie != none {
      place(bottom + left, dy: -pie-aire * k, box(
        width: ancho, height: pie-alto * k, fill: tira,
        align(center + horizon, text(font: fuente, weight: peso, stretch: estiramiento, size: cuerpo-pie * k, fill: suave, pie)),
      ))
    }
  })
}
