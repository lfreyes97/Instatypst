// ─────────────────────────────────────────────────────────────
//  carteles/bauhaus.typ — preset «bauhaus»
//
//  Cartel de formas primarias sobre papel crudo: cuadrado rojo, círculo
//  amarillo, triángulo azul y una barra negra en diagonal. El remate, en
//  minúsculas de sans geométrica (Jost, de la familia de Futura) y negrita,
//  ocupa todo el ancho útil, como el suizo, pero la composición es
//  asimétrica y diagonal en vez de una retícula.
//
//  Las formas no se reparten a ojo: se construyen unas desde otras.
//    · Una línea de tierra corre justo por encima del texto; todo apoya en
//      ella y nada baja de ella, así ninguna forma pisa la etiqueta, el
//      planteo ni la frase.
//    · El cuadrado rojo apoya en la tierra; el círculo amarillo tiene el
//      centro en la esquina superior derecha del cuadrado y radio igual al
//      lado: queda tangente a la misma tierra y el cuadrado le «muerde» un
//      cuarto. Sangra por la derecha.
//    · La barra negra nace en el margen izquierdo, sobre la tierra, y pasa
//      por esa esquina-centro: es el eje del cartel.
//    · El triángulo azul es la cuña entre la tierra y la barra; su
//      hipotenusa es el canto de la barra.
//  El texto se apoya abajo, contra el remate (frase y remate se leen de un
//  tirón), y las formas se dimensionan con el alto que queda encima. En
//  apaisado, si así caben más grandes, cuadrado y círculo bajan junto a la
//  frase en vez de quedar encima de ella.
//
//  Mismo contrato que `carteles.suizo` (frase, remate, autor, fechas,
//  etiqueta, planteo, marca): se puede cambiar de estilo cambiando solo el
//  nombre del preset.
//
//  Se usa desde el namespace `carteles` (carteles.bauhaus). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "../pliego.typ": pliego
#import "_base.typ": medida, escala, cuerpo-al-ancho, ajustar-alto
#import "_temas.typ": resolver-tema
#import "../superbg/lib.typ" as superbg

// ── carteles.bauhaus ────────────────────────────────────────
//   frase    contenido: lo que se lee antes del remate
//   remate   la palabra que llena el ancho (str o contenido); sale en
//            minúsculas salvo `minusculas: false`
//   autor, fechas        cabecera, arriba a la izquierda
//   etiqueta, planteo    rótulo en acento y pregunta, sobre la frase
//   marca    contenido para el pie (p. ej. el logo), abajo a la izquierda
//   tema     nombre de `temas-lamina` (por defecto "bauhaus"), diccionario
//            de roles o `tema-desde-theme(theme.base)`. Roles: fondo,
//            tinta, suave, acento (rojo), amarillo, azul. `fondo`, `tinta`,
//            `suave`, `acento`, `amarillo` y `azul`, si se pasan, pisan al
//            tema (auto = el del tema).
//   fuente   tipografía (por defecto Jost)
//   cuerpo-frase   tamaño máximo de la frase; se achica si no cabe
//   textura  grano de papel (ruido muy tenue en el color de la tinta)
//
// Pensado para el retrato 1080×1350; los textos y márgenes se escalan con
// `escala`, las formas con el espacio que deja el texto.
#let bauhaus(
  frase,
  remate,
  formato: (1080, 1350),
  autor: none,
  fechas: none,
  etiqueta: none,
  planteo: none,
  marca: none,
  tema: "bauhaus",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  amarillo: auto,
  azul: auto,
  fuente: "Jost",
  cuerpo-frase: 62pt,
  minusculas: true,
  textura: true,
) = {
  let (ancho, alto) = medida(formato)
  let k = escala(formato, base: (1080, 1350))
  let tm = resolver-tema(tema, defecto: "bauhaus")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let suave = if suave == auto { tm.suave } else { suave }
  let acento = if acento == auto { tm.acento } else { acento }
  let amarillo = if amarillo == auto { tm.amarillo } else { amarillo }
  let azul = if azul == auto { tm.azul } else { azul }

  let m = 72pt * k // margen
  let u = calc.min(ancho, alto)
  let ancho-frase = ancho * 0.54
  let hueco = 44pt * k // aire entre la tierra y el texto
  let rotulo(cuerpo, size: 26pt, ..args) = text(size: size * k, ..args, cuerpo)

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es")
    set par(leading: 0.34em)

    if textura {
      place(superbg.bg-patron(patron: "ruido", color: tinta, opacidad: 14%, size: formato))
    }

    // ── barra azul al pie, con su remate rojo ──
    let barra = 20pt * k
    place(bottom + left, dx: m, dy: -160pt * k, rect(width: ancho - 2 * m, height: barra, fill: azul))
    place(bottom + right, dx: -m, dy: -160pt * k, rect(width: barra * 3, height: barra, fill: acento))
    if marca != none { place(bottom + left, dx: m, dy: -m + 4pt, marca) }

    context {
      // ── cabecera: autor en versalitas espaciadas, fechas debajo ──
      let cabecera = if autor == none and fechas == none { none } else {
        block({
          if autor != none { rotulo(size: 32pt, weight: 700, tracking: 0.12em, autor) }
          if autor != none and fechas != none { v(10pt * k) }
          if fechas != none { rotulo(size: 28pt, weight: 400, fill: suave, fechas) }
        })
      }
      let (hw, hh) = if cabecera == none { (0pt, 0pt) } else {
        let t = measure(cabecera)
        (t.width, t.height)
      }

      // ── remate: todo el ancho útil, limitado por el alto en apaisado ──
      let base = alto - 200pt * k // el remate se apoya acá
      let y-min = alto * 0.40 // el texto no sube de acá
      let texto = if minusculas { lower(remate) } else { remate }
      let palabra(s) = text(font: fuente, size: s, weight: 800, tracking: -0.03em, fill: tinta, top-edge: "bounds", bottom-edge: "bounds", texto)
      let s = calc.min(
        cuerpo-al-ancho(palabra, ancho - 2 * m),
        100pt * (0.5 * (base - y-min) / measure(palabra(100pt)).height),
      )
      let caja = palabra(s)
      let remate-y = base - measure(caja).height

      // ── etiqueta, planteo y frase: un bloque apoyado sobre el remate ──
      let bloque(c) = block(width: ancho-frase, {
        if etiqueta != none { rotulo(weight: 700, tracking: 0.1em, fill: acento, etiqueta); v(8pt * k) }
        if planteo != none { text(size: 40pt * k, weight: 400, fill: suave, tracking: -0.01em, planteo); v(18pt * k) }
        text(size: c, weight: 600, tracking: -0.015em, frase)
      })
      let aire = 36pt * k // entre la frase y el remate
      let c = ajustar-alto(bloque, cuerpo-frase * k, remate-y - aire - y-min)
      let medido = measure(bloque(c))
      let texto-y = remate-y - aire - medido.height

      // ── composición: todo apoya en la tierra, justo sobre el texto ──
      let gt = texto-y - hueco
      // lado máximo del cuadrado: algo mayor en formatos altos, donde
      // sobra alto y el ancho es lo único que limita
      let cap = if alto > 1.5 * ancho { 0.40 * u } else { 0.36 * u }
      let g = 0.046 * u // grosor de la barra
      let min-incl = 22deg
      let aire-cab = 40pt * k // distancia mínima de cualquier forma a la cabecera
      let (cab-der, cab-pie) = (m + hw, m + hh) // borde derecho e inferior de la cabecera
      // Para un lado L, dónde va el borde izquierdo del cuadrado (sx):
      //  · el círculo (radio L, centro en la esquina superior derecha del
      //    cuadrado) sangra 0.2 L por la derecha y como mucho 0.5 L por
      //    arriba; el bloque no empieza antes de 0.30 del ancho;
      //  · por defecto se apoya contra el borde derecho, pero si así la
      //    barra (que nace en (m, gt) y pasa por el centro del círculo)
      //    quedara más tendida que `min-incl`, se corre a la izquierda;
      //  · ni el círculo ni el cuadrado ni la barra se acercan a la
      //    cabecera a menos de `aire-cab`.
      // Se busca el mayor L para el que todo eso se cumple.
      let lugar(L) = {
        let cy = gt - L
        let x-min = ancho * 0.30
        if cabecera != none {
          // el círculo, lejos de la caja de la cabecera
          let dy = calc.max(0pt, cy - cab-pie)
          let r = L + aire-cab
          if dy < r { x-min = calc.max(x-min, cab-der + calc.sqrt(calc.pow(r / 1pt, 2) - calc.pow(dy / 1pt, 2)) * 1pt - L) }
          // el cuadrado, lejos de la cabecera si sube hasta ella
          if cy < cab-pie + aire-cab { x-min = calc.max(x-min, cab-der + aire-cab) }
        }
        // Si se corre, llega al menos a dejar el círculo tangente al margen
        // derecho (donde termina el remate): ni sangra ni queda «casi
        // tocando» el borde, que parece un error de registro.
        let sx-incl = m + L / calc.tan(min-incl) - L
        let sx-sangra = ancho - 1.8 * L
        let sx = if sx-incl >= sx-sangra { sx-sangra } else { calc.min(sx-incl, ancho - m - 2 * L) }
        let sx = calc.max(x-min, sx)
        let cx = sx + L
        let gv = g / calc.cos(calc.atan2((cx - m) / 1pt, L / 1pt))
        let tg = (L - gv / 2) / (cx - m) // pendiente del canto inferior de la barra
        let ok = sx + 1.8 * L <= ancho + 0.01pt and gt - 2 * L >= -0.5 * L
        if cabecera != none {
          // la barra, por debajo de la cabecera donde pasa a su altura
          ok = ok and gt - (cab-der + aire-cab - m) * tg - gv >= cab-pie + aire-cab
        }
        (ok: ok, sx: sx, tg: tg, gv: gv)
      }
      let L = calc.min(cap, gt / 1.5)
      while L > 0.12 * u and not lugar(L).ok { L -= 0.01 * u }
      let (cabe, sx, tg, gv) = { let l = lugar(L); (l.ok, l.sx, l.tg, l.gv) }
      let (cx, cy) = (sx + L, gt - L) // esquina = centro del círculo
      let y-en(x) = gt - (x - m) * tg // canto inferior de la barra
      let xf = ancho + 2 * g

      // Si ni el cuadrado más chico cabe sin acercarse a la cabecera (una
      // cabecera enorme sobre un texto que sube mucho), no hay formas:
      // antes un cartel sin composición que una forma pisando texto.
      if cabe {
        place(top + left, dx: cx - L, dy: cy - L, circle(radius: L, fill: amarillo))
        place(top + left, dx: sx, dy: cy, rect(width: L, height: L, fill: acento))

        // triángulo: cuña entre la tierra y el canto de la barra, hasta poco
        // antes del cuadrado
        let x1 = sx - 0.14 * L
        place(top + left, polygon(fill: azul, (m, gt), (x1, gt), (x1, y-en(x1))))
        place(top + left, polygon(fill: tinta,
          (m, gt), (xf, y-en(xf)), (xf, y-en(xf) - gv), (m, gt - gv)))
      }

      // ── textos, encima de todo ──
      if cabecera != none { place(top + left, dx: m, dy: m, cabecera) }
      place(top + left, dx: m - 0.03 * s, dy: remate-y, caja)
      place(top + left, dx: m, dy: texto-y, bloque(c))
    }
  })
}
