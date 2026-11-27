// ─────────────────────────────────────────────────────────────
//  pliego.typ — `page(...)` que también cabe dentro de un documento
//
//  Los presets (carteles, orlas, plantillas sociales) arman UNA página
//  por pieza. Typst no permite anidar una página en un contenedor, así
//  que para mostrar una pieza dentro de otro documento (un manual, una
//  hoja de pruebas) hay que renderizarla aparte... o usar esto:
//
//    pliego(width:, height:, margin:, fill:, cuerpo)
//      · fuera de `en-caja`: es exactamente `page(...)`
//      · dentro de `en-caja(k, ...)`: un bloque de width × height, con el
//        mismo fondo, escalado por `k` (0,2 = 20 %) y recortado
//
//    #en-caja(0.25, carteles.liso([Todo es gracia.]))   // cabe en una A4
//
//  El modo viaja por la cadena de estilos (no por un `state`): un `state`
//  se resuelve en la iteración siguiente, y en la primera `page(...)`
//  dentro de un contenedor ya es un error. Un valor de estilo se lee al
//  instante. El canal es el costo de guionado (`text.costs.hyphenation`,
//  100 % por defecto): `en-caja` lo fija en 200 % + k·100 %, algo que
//  ningún preset usa (todos tienen el guionado apagado).
// ─────────────────────────────────────────────────────────────

#let pliego(..args) = context {
  let c = text.costs.hyphenation
  let n = args.named()
  let cuerpo = args.pos().first()
  if c < 200% {
    page(..n, cuerpo)
  } else {
    let k = (c - 200%) / 100%
    scale(
      x: k * 100%, y: k * 100%, reflow: true,
      block(width: n.width, height: n.height, fill: n.at("fill", default: none), clip: true, cuerpo),
    )
  }
}

#let en-caja(k, cuerpo) = {
  set text(costs: (hyphenation: 200% + k * 100%))
  cuerpo
}
