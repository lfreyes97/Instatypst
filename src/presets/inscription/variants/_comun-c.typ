// ─────────────────────────────────────────────────────────────
//  carteles/_epigrafes-c.typ — estilos de epígrafe, tanda C: los
//  atmosféricos (cada uno trae su fondo o su ambiente)
//
//    aura      niebla de luz oscura (halos violeta, azul y ámbar), la
//              cita en Cormorant cursiva clara, el autor discreto
//    pizarra   pizarra verde con tiza: Caveat, marco de filetes trazado
//              a mano, polvo de tiza encima de todo
//    vitral    fondo de celosía de fleurones, orla de damasco en oro y
//              filete rojo; la cita en el óvalo central (IM FELL)
//    luto      negro total, una cruz fina dorada y la cita en blanco
//              (Bodoni Moda): la máxima solemnidad
//    amanecer  banda horizontal de luz cálida sobre azul noche; la cita
//              en el horizonte (Fraunces), contrapunto de `luto`
//
//  Todos con la misma firma:
//    (cita, autor: none, obra: none, formato: (1080, 1350), tema: auto,
//     marca: none, guias: false) => página
//  `cita` es contenido (admite `\`); `tema` es auto (el del estilo), un
//  nombre de `temas-lamina` o de `temas-c`, o un diccionario de roles
//  (fondo, tinta, suave, acento, hondo y los propios de cada estilo); lo
//  que falte sale del tema del estilo. La cita se achica hasta caber; si
//  no cabe ni al cuerpo mínimo (34 px por cada 1080 de ancho; 44 en la
//  manuscrita de `pizarra`), error.
//
//  Exporta `estilos-c` (nombre → función) y `temas-c`. Privado de
//  `carteles/`: lo usa el despachador de `carteles.epigrafe`.
// ─────────────────────────────────────────────────────────────

//  Este archivo guarda lo común de la tanda; cada estilo está en su archivo
//  (variants/<estilo>.typ), que importa este con `*`.

#import "/src/core/pliego.typ": pliego
#import "/src/presets/inscription/_legado/_base.typ": medida, escala, ajustar-alto
#import "/src/presets/inscription/_legado/_temas.typ": temas-lamina, resolver-tema
#import "/src/modules/fleurones/fleurones.typ" as fl
#import "/src/modules/superbg/lib.typ" as superbg
#import "/src/modules/superbg/azar.typ": _secuencia

// ── Temas propios de cada estilo ──
#let temas-c = (
  aura: (
    fondo: rgb("#0c0d16"),
    tinta: rgb("#f1ebe0"),
    suave: rgb("#aaa3b6"),
    acento: rgb("#c7a46c"),
    hondo: rgb("#3b2b78"), // el halo violeta
    bruma: rgb("#17505f"), // el halo azul verdoso
  ),
  pizarra: (
    fondo: rgb("#24392f"),
    tinta: rgb("#f2f0e6"), // tiza blanca
    suave: rgb("#c9d3c8"),
    acento: rgb("#eedb8e"), // tiza amarilla
    hondo: rgb("#1a2a22"),
  ),
  vitral: (
    fondo: rgb("#13234c"), // azul profundo
    tinta: rgb("#f3ead2"), // crema
    suave: rgb("#d9c99c"),
    acento: rgb("#c99b3e"), // oro
    hondo: rgb("#0b1532"), // el óvalo
    rojo: rgb("#8c1b22"),
  ),
  luto: (
    fondo: rgb("#000000"),
    tinta: rgb("#f6f4ef"),
    suave: rgb("#8f8a81"),
    acento: rgb("#bf9d5c"), // oro de la cruz
  ),
  amanecer: (
    fondo: rgb("#0a1332"), // noche, arriba
    hondo: rgb("#110b23"), // noche, abajo
    tinta: rgb("#151a36"), // la cita, sobre la luz
    suave: rgb("#eadcc1"), // autor y obra, sobre la noche
    acento: rgb("#f0a462"), // borde cálido de la banda
    claro: rgb("#fbe7c4"), // el centro de la luz
  ),
)

#let _tema(tema, estilo) = {
  let base = temas-c.at(estilo)
  if tema == auto { return base }
  base + resolver-tema(tema, registro: temas-lamina + temas-c)
}

// Cuerpo mínimo legible: `px` por cada 1080 de ancho.
#let _minimo(W, px: 34) = px * 1pt * (W / 1080pt)

// La cita compuesta en una caja de `ancho`: `t(s)` es el texto a cuerpo `s`
// (sin caja). Devuelve (s:, q:) con el mayor cuerpo ≤ desde con el que cabe
// en `alto`; error si no cabe ni a `minimo`. Las líneas que el autor cortó a
// mano con `\` se respetan si caben enteras achicando poco (hasta un 25 %);
// si no, los cortes se vuelven espacios y la cita corre seguida, para no
// dejar una palabra sola en la línea de abajo. Usar dentro de `context`.
#let _encajar(t, ancho, desde, alto, minimo, quien, alin: center) = {
  let caja(s, seguida) = block(width: ancho, align(alin, {
    show linebreak: it => if seguida [ ] else { it }
    t(s)
  }))
  let ajustar(seguida) = {
    let hacer(s) = caja(s, seguida)
    let s = calc.max(minimo, ajustar-alto(hacer, desde, alto, minimo: minimo, paso: 1pt))
    if measure(hacer(s)).height > alto + 0.5pt {
      panic(quien + ": la cita no cabe ni con el cuerpo mínimo (" + repr(calc.round(minimo / 1pt)) + " pt) — acórtala o usa un formato más alto")
    }
    s
  }
  let s = ajustar(false)
  let w = measure(t(s)).width
  if w <= ancho { return (s: s, q: caja(s, false)) }
  let s2 = s * (ancho / w) * 0.995
  if s2 >= 0.75 * s and s2 >= minimo { return (s: s2, q: caja(s2, false)) }
  let s3 = ajustar(true)
  (s: s3, q: caja(s3, true))
}

// Tamaño ≤ s con el que `hacer(t)` no pasa de `ancho` (autor, obra).
#let _al-ancho(hacer, s, ancho) = {
  let w = measure(hacer(s)).width
  if w > ancho { s * ancho / w } else { s }
}

// Caja de guía (depurar).
#let _guia(w, h) = rect(width: w, height: h, stroke: (paint: rgb("#ff2bd6"), thickness: 1pt, dash: "dashed"))

// Halo: elipse con degradado radial de `col` (a `op`) a transparente.
#let _halo(x, y, rx, ry, col, op) = place(top + left, dx: x - rx, dy: y - ry, ellipse(
  width: 2 * rx, height: 2 * ry, stroke: none,
  fill: gradient.radial(
    (col.transparentize(100% - op), 0%),
    (col.transparentize(100% - op * 0.55), 35%),
    (col.transparentize(100%), 100%),
  ),
))
