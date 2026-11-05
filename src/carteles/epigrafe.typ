// ─────────────────────────────────────────────────────────────
//  carteles/epigrafe.typ — carteles de epígrafe: una cita breve con su
//  autor y su obra, en quince estilos
//
//    #carteles.epigrafe([«Cuando un pueblo… \ …lepra del alma.»],
//      autor: [Willem Bilderdijk], obra: [_Oprakeling_], estilo: "luto")
//
//  Estilos (cada uno con su tema propio; `tema:` lo cambia):
//    clásicos   pergamino · portada · lapida · epistola · cartela
//    geométricos hojas · bauhaus · arcos · malla · lineas
//    atmosféricos aura · pizarra · vitral · luto · amanecer
//
//  Todos comparten la firma: cita, autor, obra, formato, tema, marca, guias.
//  La cita se achica hasta caber; si no cabe al mínimo, error con mensaje.
// ─────────────────────────────────────────────────────────────
#import "_epigrafes-a.typ": estilos-a
#import "_epigrafes-b.typ": estilos-b
#import "_epigrafes-c.typ": estilos-c

#let estilos-epigrafe = (: ..estilos-a, ..estilos-b, ..estilos-c)

#let epigrafe(
  cita,
  autor: none,
  obra: none,
  estilo: "luto",
  formato: (1080, 1350),
  tema: auto,
  marca: none,
  guias: false,
) = {
  if not estilo in estilos-epigrafe {
    panic("epigrafe: estilo desconocido " + repr(estilo) + " — disponibles: " + estilos-epigrafe.keys().join(", "))
  }
  (estilos-epigrafe.at(estilo))(cita, autor: autor, obra: obra, formato: formato, tema: tema, marca: marca, guias: guias)
}
