// ─────────────────────────────────────────────────────────────
//  escalera.typ — preset «escalera»: la frase baja en peldaños
//
//  Cosechado de la lámina 04 de campana/ («El calvinista es el hombre
//  que ve a Dios»): sobre un color sólido, la frase baja por el lienzo
//  en escalones —cada peldaño con su cuerpo, sangría, estilo, peso y
//  color— y termina en un clímax grande. Sirve para láminas y para
//  diapositivas: el mismo texto se reparte solo en vertical, cuadrado o
//  apaisado.
//
//  Arma la página entera (page()), como carteles.suizo. Sin marca
//  propia: el logo entra por `marca:` como contenido ya hecho. Todo
//  Fondo: las curvas de nivel de la 04 vienen incluidas (`curvas:`), con
//  la cumbre bajo el clímax; otro decorado propio entra por `decorado:`.
// ─────────────────────────────────────────────────────────────

// Un peldaño: contenido suelto, o un diccionario con
//   texto     (obligatorio)
//   cuerpo    tamaño de letra (por defecto, el `cuerpo` del preset)
//   sangria   auto = escalón automático · un largo = fijo, desde el margen
//   estilo    "normal" | "italic"
//   peso      400, 600…
//   color     "tinta" | "suave" | "acento" | un color
//   tracking  0pt por defecto
//   y         auto = reparto automático · un largo = fijo, desde arriba
#import "pliego.typ": pliego
#import "carteles/_temas.typ": resolver-tema
#import "curvas.typ" as _cv

// ── curvas de nivel ─────────────────────────────────────────
// Mapa topográfico de la lámina 04: anillos alrededor de `cumbre`
// ((x, y) en largos), cada uno un poco corrido hacia arriba a la
// izquierda (la ladera no es simétrica) y con una ondulación que crece
// hacia afuera; cada quinto anillo, más grueso, como las curvas
// maestras. `sep` es la distancia entre anillos.
// (Propias y no bg-topo de superbg: acá la cumbre cae en un punto
// preciso, debajo del clímax.)
#let curvas-de-nivel(cumbre, color, n: 34, sep: 40pt, pasos: 140) = {
  let (x0, y0) = (cumbre.at(0) / 1pt, cumbre.at(1) / 1pt)
  let sep = sep / 1pt
  let deriva = sep / 40 // el corrimiento por anillo crece con la separación
  for k in range(1, n + 1) {
    let r = k * sep
    let cx = x0 - k * 6.5 * deriva
    let cy = y0 - k * 11 * deriva
    let amp = calc.min(0.24, 0.10 + k * 0.006)
    let pts = range(pasos).map(i => {
      let a = 2 * calc.pi * i / pasos
      let f = 1 + amp * (0.5 * calc.sin(2 * a + 0.9 + k * 0.06) + 0.32 * calc.sin(3 * a + 2.1 - k * 0.05) + 0.18 * calc.sin(5 * a + 0.4 + k * 0.09))
      ((cx + r * f * calc.cos(a)) * 1pt, (cy + r * f * 1.18 * calc.sin(a)) * 1pt)
    })
    let maestra = calc.rem(k, 5) == 0
    place(top + left, polygon(
      stroke: (if maestra { 2.2pt } else { 1.1pt }) + color.transparentize(if maestra { 55% } else { 72% }),
      ..pts,
    ))
  }
}

#let _peldano(p, cuerpo) = {
  let d = if type(p) == dictionary { p } else { (texto: p) }
  (
    texto: d.texto,
    cuerpo: d.at("cuerpo", default: cuerpo),
    sangria: d.at("sangria", default: auto),
    estilo: d.at("estilo", default: "normal"),
    peso: d.at("peso", default: 400),
    color: d.at("color", default: "tinta"),
    tracking: d.at("tracking", default: 0pt),
    y: d.at("y", default: auto),
  )
}

// ── escalera ────────────────────────────────────────────────
//   peldanos   array de peldaños, o array de grupos (arrays de
//              peldaños): entre grupo y grupo queda más aire, y cada
//              grupo vuelve a empezar su escalón desde el margen
//   climax     el remate, grande y en cursiva, en `acento`
//   coda       una línea más chica bajo el clímax (opcional)
//   autor, obra    cabecera arriba a la izquierda, en `suave`
//   marca      contenido arriba a la derecha (p. ej. el logo)
//   alinear    alineación del clímax: center | left | right
//   paso       cuánto avanza cada escalón dentro de un grupo, como
//              fracción del ancho útil (0,163 = 150pt en 1080; crece
//              un 50 % por grupo)
//   cabecera-y, climax-y   auto, o un largo para fijarlos a mano
//   curvas     curvas de nivel de fondo (la lámina 04): auto = en
//              `suave`, un color = en ese color, none = sin curvas
//   cumbre     auto = bajo el centro del clímax (las curvas convergen
//              donde cae el remate) · (x, y) = fija
//   anillos    auto = los que hagan falta para cubrir el lienzo
//              `curvas:` también acepta un campo de curvas.campo(…): se
//              dibuja su ventana `indice` (desde 0), así una serie de
//              escaleras con el mismo campo forma un deck continuo
//   decorado   contenido de fondo propio, detrás de todo
//
// Automático: los cuerpos se escalan al ancho del formato (base 1080),
// se achican si una línea no cabe o si el conjunto no entra en el alto,
// y el aire entre peldaños se estira (hasta 2,2×) para llenar el alto;
// lo que sobra se reparte 1:2 arriba/abajo. Cada sangría automática se
// recorta para que la línea nunca pase del margen derecho.
// tema: nombre de `temas-lamina` (por defecto "escalera"), diccionario de roles
// (fondo, tinta, suave, acento…) o `carteles.tema-desde-theme(theme.base)`.
// Los parámetros de color (`fondo`, `tinta`, `suave`, `acento`) pisan al tema; auto = el del tema.
#let escalera(
  peldanos,
  climax,
  coda: none,
  formato: (1080, 1920),
  autor: none,
  obra: none,
  marca: none,
  tema: "escalera",
  fondo: auto,
  tinta: auto,
  suave: auto,
  acento: auto,
  fuente: "Literata",
  cuerpo: 60pt,
  cuerpo-climax: 150pt,
  cuerpo-coda: 76pt,
  alinear: center,
  paso: 0.163,
  margen: auto,
  cabecera-y: auto,
  climax-y: auto,
  curvas: auto,
  cumbre: auto,
  anillos: auto,
  indice: 0,
  decorado: none,
) = {
  let tm = resolver-tema(tema, defecto: "escalera")
  let fondo = if fondo == auto { tm.fondo } else { fondo }
  let tinta = if tinta == auto { tm.tinta } else { tinta }
  let suave = if suave == auto { tm.suave } else { suave }
  let acento = if acento == auto { tm.acento } else { acento }
  let (ancho, alto) = (formato.at(0) * 1pt, formato.at(1) * 1pt)
  let kw = ancho / 1080pt // escala de la letra: el ancho manda
  let kh = calc.min(ancho, alto) / 1080pt // escala de cabecera y márgenes
  let margen = if margen == auto { 80pt * kh } else { margen }
  let caja = ancho - 2 * margen
  let cy = if cabecera-y == auto { calc.max(56pt, 110pt * (alto / 1920pt)) } else { cabecera-y }
  let paleta = (tinta: tinta, suave: suave, acento: acento)
  let tono(c) = if type(c) == str { paleta.at(c) } else { c }

  // un solo grupo plano -> lista de un grupo
  let grupos = if peldanos.len() > 0 and type(peldanos.at(0)) == array { peldanos } else { (peldanos,) }
  let grupos = grupos.map(g => g.map(p => _peldano(p, cuerpo)))
  let manual = climax-y != auto and grupos.all(g => g.all(p => p.y != auto))

  let linea(p, e) = text(
    size: p.cuerpo * kw * e, weight: p.peso, style: p.estilo,
    fill: tono(p.color), tracking: p.tracking, p.texto,
  )
  let bloque-climax(e) = block(width: caja, {
    set align(alinear)
    set par(leading: 0.12em, spacing: 0pt)
    text(size: cuerpo-climax * kw * e, weight: 600, style: "italic", fill: acento, tracking: -0.02em, climax)
    if coda != none {
      v(56pt * kw * e)
      text(size: cuerpo-coda * kw * e, weight: 400, style: "italic", fill: acento, coda)
    }
  })

  pliego(width: ancho, height: alto, margin: 0pt, fill: fondo, {
    set text(font: fuente, fill: tinta, lang: "es")

    if decorado != none { decorado }

    context {
      // Aire entre peldaños: dentro del grupo, según el cuerpo del que
      // viene abajo; entre grupos y antes del clímax, según el cuerpo base.
      let aires(e) = {
        let out = ()
        for (g, grupo) in grupos.enumerate() {
          for (j, p) in grupo.enumerate() {
            out.push(if j > 0 { 0.55 * p.cuerpo * kw * e } else if g > 0 { 1.5 * cuerpo * kw * e } else { 0pt })
          }
        }
        out.push(2 * cuerpo * kw * e) // antes del clímax
        out
      }
      let planas = grupos.flatten()
      let medir(e) = (
        planas.map(p => measure(linea(p, e))),
        measure(bloque-climax(e)).height,
      )

      // espacio útil: bajo la cabecera, hasta un margen igual al de arriba
      let techo = cy + 64pt * kh + 100pt * kh
      // (el clímax se mide hasta la línea base: se reserva su descendente)
      let piso = alto - cy - 0.3 * cuerpo-climax * kw
      let e = 1.0
      if not manual {
        // ninguna línea más ancha que la caja
        let anchos = medir(1.0).at(0).map(m => m.width)
        e = calc.min(1.0, ..anchos.map(w => caja / w))
        // y el conjunto, dentro del alto
        let total(e) = {
          let (ms, hc) = medir(e)
          ms.map(m => m.height).sum() + aires(e).sum() + hc
        }
        while total(e) > piso - techo and e > 0.4 { e -= 0.03 }
      }
      let (ms, hc) = medir(e)
      let aire = aires(e)
      let libre = (piso - techo) - ms.map(m => m.height).sum() - aire.sum() - hc
      let estirar = if aire.sum() > 0pt { calc.min(2.2, 1 + libre / aire.sum()) } else { 1 }
      let sobra = libre - aire.sum() * (estirar - 1)

      // posiciones primero: las curvas, que van detrás, dependen del clímax
      let y = techo + sobra / 3
      let k = 0
      let lineas = ()
      for (g, grupo) in grupos.enumerate() {
        for (j, p) in grupo.enumerate() {
          y += aire.at(k) * estirar
          let w = ms.at(k).width
          let s = if p.sangria != auto { p.sangria } else {
            calc.max(0pt, calc.min(caja - w, j * paso * caja * (1 + 0.5 * g)))
          }
          let py = if p.y != auto { p.y } else { y }
          lineas.push((margen + s, py, linea(p, e)))
          y += ms.at(k).height
          k += 1
        }
      }
      y += aire.at(k) * estirar
      let yc = if climax-y != auto { climax-y } else { y }

      // ── curvas de nivel: convergen bajo el clímax ──
      if type(curvas) == dictionary {
        // un campo de curvas.typ: la ventana de esta diapositiva
        _cv.ventana(curvas, indice)
      } else if curvas != none {
        let cima = if cumbre != auto { cumbre } else {
          let wc = measure(text(size: cuerpo-climax * kw * e, weight: 600, style: "italic", tracking: -0.02em, climax)).width
          let x = if alinear == left { margen + wc / 2 } else if alinear == right { ancho - margen - wc / 2 } else { ancho / 2 }
          (x, yc + 0.45 * hc)
        }
        let sep = 40pt * kh
        let n = if anillos != auto { anillos } else {
          let lejos = calc.max(..((0pt, 0pt), (ancho, 0pt), (0pt, alto), (ancho, alto)).map(((x, y)) => {
            calc.sqrt(calc.pow((x - cima.at(0)) / 1pt, 2) + calc.pow((y - cima.at(1)) / 1pt, 2))
          }))
          int(calc.ceil(lejos / (sep / 1pt))) + 2
        }
        curvas-de-nivel(cima, if curvas == auto { suave } else { curvas }, n: n, sep: sep)
      }

      // ── cabecera ──
      if autor != none {
        place(top + left, dx: margen, dy: cy, text(size: 24pt * kh, weight: 600, tracking: 0.16em, fill: suave, autor))
      }
      if obra != none {
        place(top + left, dx: margen, dy: cy + 38pt * kh, text(size: 26pt * kh, style: "italic", fill: suave, obra))
      }
      if marca != none { place(top + right, dx: -margen, dy: cy + 2pt * kh, marca) }

      // ── peldaños y clímax ──
      for (x, py, l) in lineas { place(top + left, dx: x, dy: py, l) }
      place(top + left, dx: margen, dy: yc, bloque-climax(e))
    }
  })
}
