// ─────────────────────────────────────────────────────────────
//  carteles/_epigrafes-a.typ — estilos de epígrafe, tanda A
//
//  Cinco estilos clásicos, de imprenta y de archivo, para el futuro
//  `carteles.epigrafe(cita, autor:, obra:, estilo:)`. Cada uno es una
//  composición distinta, no un cambio de color:
//
//    pergamino  hoja manuscrita: pergamino tostado, filetes rojos del
//               copista, capitular iluminada y la cita en cursiva
//    portada    portada de libro del XVII: orla de filete doble, cabecera
//               de florones, primera palabra en versalitas rojas, pie de
//               imprenta con autor y obra
//    lapida     inscripción en piedra: mayúsculas romanas espaciadas,
//               letra incisa (sombra y luz), el autor como «fecit»
//    epistola   carta en papel verjurado: margen ancho con la obra como
//               nota de archivo, cuerpo con sangría y firma con rúbrica
//    cartela    cartela de museo: pared blanca, bloque pequeño de sans
//               fina abajo a la izquierda, mucho aire
//
//  Todos con la misma firma:
//    (cita, autor: none, obra: none, formato: (1080, 1350), tema: auto,
//     marca: none, guias: false) => página
//  `tema`: auto (el del estilo), un nombre de `temas-lamina` o un
//  diccionario de roles (fondo, tinta, suave, acento, hondo); lo que falte
//  sale del tema del estilo. `guias: true` dibuja las cajas del texto.
//  La cita se achica hasta caber en su caja; si a 34 px de cuerpo (en
//  1080 de ancho) no cabe, error.
//
//  Privado de `carteles/`: lo usa el despachador de epígrafes.
// ─────────────────────────────────────────────────────────────

//  Este archivo guarda lo común de la tanda; cada estilo está en su archivo
//  (variants/<estilo>.typ), que importa este con `*`.

#import "/src/core/pliego.typ": pliego
#import "/src/presets/inscription/_legado/_base.typ": medida, escala, ajustar-alto
#import "/src/presets/inscription/_legado/_temas.typ": temas-lamina, resolver-tema
#import "/src/modules/superbg/lib.typ" as superbg
#import "/src/modules/fleurones/fleurones.typ" as fl
#import "/src/resources/dropcaps/dropcaps.typ": capitular-ornamentada, _dividir

// ── Temas propios de cada estilo (roles de lámina) ──
#let temas-epigrafe-a = (
  epigrafe-pergamino: (
    fondo: rgb("#ead9b0"),
    tinta: rgb("#2a1c12"),
    suave: rgb("#5e4630"),
    acento: rgb("#9a2118"),
    hondo: rgb("#b8955c"),
  ),
  epigrafe-portada: (
    fondo: rgb("#f2ede2"),
    tinta: rgb("#15120e"),
    suave: rgb("#4a433a"),
    acento: rgb("#b0231a"),
    hondo: rgb("#15120e"),
  ),
  epigrafe-lapida: (
    fondo: rgb("#b7b2a8"),
    tinta: rgb("#2e2b27"),
    suave: rgb("#45413b"),
    acento: rgb("#e6e2da"),
    hondo: rgb("#8a857b"),
  ),
  epigrafe-epistola: (
    fondo: rgb("#f4f0e6"),
    tinta: rgb("#1c2538"),
    suave: rgb("#5f5c55"),
    acento: rgb("#8b3a26"),
    hondo: rgb("#cfc8b8"),
  ),
  epigrafe-cartela: (
    fondo: rgb("#efede8"),
    tinta: rgb("#1d1d1b"),
    suave: rgb("#55534e"),
    acento: rgb("#8f8b83"),
    hondo: rgb("#1d1d1b"),
  ),
)

#let _tema(tema, propio) = resolver-tema(
  if tema == auto { propio } else { tema },
  defecto: propio,
  registro: temas-lamina + temas-epigrafe-a,
)

#let _validar(quien, cita, formato) = {
  if cita == none { panic(quien + ": falta la cita") }
  if type(formato) != array or formato.len() != 2 or formato.any(x => type(x) not in (int, float) or x <= 0) {
    panic(quien + ": `formato` es (ancho, alto) en px, p. ej. (1080, 1350) — recibido: " + repr(formato))
  }
}

// Cuerpo con el que `hacer(s)` cabe en `alto`, de `desde` a `minimo`; si ni
// a `minimo` cabe, error. Usar dentro de `context`.
#let _cuerpo(quien, hacer, desde, alto, minimo) = {
  let s = ajustar-alto(hacer, desde, alto, minimo: minimo, paso: 1pt)
  if measure(hacer(s)).height > alto {
    panic(quien + ": la cita no cabe con el cuerpo a " + str(calc.round(minimo / 1pt, digits: 1))
      + " px (el mínimo legible). Acórtala o usa un formato más alto.")
  }
  s
}

// Guía de depuración: el contorno de una caja.
#let _guia(guias, dx, dy, w, h) = if guias {
  place(top + left, dx: dx, dy: dy, rect(width: w, height: h, stroke: (paint: rgb("#e0218a"), thickness: 1.5pt, dash: "dashed")))
}

// La obra va en cursiva: si ya viene con `_…_` (emph) se deja; si no, se
// le pone. (Dentro de un texto en cursiva, el emph la vuelve redonda.)
#let _obra(o) = if type(o) == content and o.func() == emph { o } else { emph(o) }
