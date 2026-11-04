// ─────────────────────────────────────────────────────────────
//  carteles/bauhaus.typ — preset «bauhaus»
//
//  Cartel de formas primarias: círculo amarillo, cuadrado rojo, triángulo
//  azul y una barra negra en diagonal, sobre papel crudo. El remate, en
//  minúsculas de sans geométrica (Jost, de la familia de Futura) y negrita,
//  ocupa todo el ancho útil, como el suizo, pero la composición es
//  asimétrica y diagonal en vez de una retícula.
//
//  Mismo contrato que `carteles.suizo` (frase, remate, autor, fechas,
//  etiqueta, planteo, marca): se puede cambiar de estilo cambiando solo el
//  nombre del preset.
//
//  Se usa desde el namespace `carteles` (carteles.bauhaus). No importa
//  carteles.typ ni lib.typ: carteles.typ lo importa a él.
// ─────────────────────────────────────────────────────────────

#import "_base.typ": medida, escala, cuerpo-al-ancho, ajustar-alto
#import "_temas.typ": resolver-tema

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
//
// Pensado para el retrato 1080×1350; las formas y los márgenes se escalan
// con el lado menor, y en apaisado el remate se limita por el alto.
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
  let u = calc.min(ancho, alto) // unidad de las formas
  let ancho-frase = ancho * 0.54
  let y0 = alto * 0.40 // donde arranca el bloque de texto
  let rotulo(cuerpo, ..args) = text(size: 24pt * k, ..args, cuerpo)

  page(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es")
    set par(leading: 0.34em)

    // ── formas primarias: se pisan, como en un cartel de imprenta ──
    let D = 0.70 * u
    place(top + left, dx: ancho - 0.62 * D, dy: -0.22 * D, circle(radius: D / 2, fill: amarillo))
    let lado = 0.30 * u
    place(top + left, dx: ancho * 0.60, dy: alto * 0.20, rect(width: lado, height: lado, fill: acento))
    // barra diagonal, inclinada hacia arriba a la derecha. Su punto más bajo
    // (el extremo izquierdo) queda `hueco` por encima de donde arranca el
    // texto (`y0`), así nunca pisa la etiqueta ni el planteo.
    let angulo = 28deg
    let (largo, grueso, hueco) = (0.95 * u, 0.034 * u, 40pt * k)
    let cx = ancho * 0.38
    let cy = y0 - hueco - (largo / 2) * calc.sin(angulo) - grueso / 2
    place(top + left, dx: cx - largo / 2, dy: cy - grueso / 2,
      rotate(-angulo, origin: center, rect(width: largo, height: grueso, fill: tinta)))
    // triángulo rectángulo, a la derecha de la frase
    let t = 0.20 * u
    let (tx, ty) = (ancho - m - t, alto * 0.52)
    place(top + left, dx: tx, dy: ty, polygon(fill: azul, (0pt, t), (t, t), (t, 0pt)))

    // ── cabecera ──
    if autor != none {
      place(top + left, dx: m, dy: m, rotulo(weight: 700, tracking: 0.1em, autor))
    }
    if fechas != none {
      place(top + left, dx: m, dy: m + 38pt * k, rotulo(weight: 400, fill: suave, fechas))
    }

    // ── barra azul al pie, con su cuadradito rojo ──
    let barra = 20pt * k
    place(bottom + left, dx: m, dy: -160pt * k, rect(width: ancho - 2 * m, height: barra, fill: azul))
    place(bottom + right, dx: -m, dy: -160pt * k, rect(width: barra * 2.4, height: barra, fill: acento))
    if marca != none { place(bottom + left, dx: m, dy: -m + 4pt, marca) }

    context {
      let base = alto - 200pt * k // el remate se apoya acá

      // ── remate: todo el ancho útil, limitado por el alto en apaisado ──
      let texto = if minusculas { lower(remate) } else { remate }
      let palabra(s) = text(font: fuente, size: s, weight: 800, tracking: -0.03em, fill: tinta, top-edge: "bounds", bottom-edge: "bounds", texto)
      let s = calc.min(
        cuerpo-al-ancho(palabra, ancho - 2 * m),
        100pt * (0.5 * (base - y0) / measure(palabra(100pt)).height),
      )
      let caja = palabra(s)
      let remate-y = base - measure(caja).height
      place(top + left, dx: m - 0.03 * s, dy: remate-y, caja)

      // ── etiqueta, planteo y frase: un solo bloque que se achica para caber ──
      let bloque(c) = block(width: ancho-frase, {
        if etiqueta != none { rotulo(weight: 700, tracking: 0.1em, fill: acento, etiqueta); v(6pt * k) }
        if planteo != none { text(size: 40pt * k, weight: 400, fill: suave, tracking: -0.01em, planteo); v(18pt * k) }
        text(size: c, weight: 600, tracking: -0.015em, frase)
      })
      let c = ajustar-alto(bloque, cuerpo-frase * k, remate-y - y0 - 40pt * k)
      place(top + left, dx: m, dy: y0, bloque(c))
    }
  })
}
