// suizo / SCAFFOLD (contrato semántico sobre engine_v1) — seis láminas: cuatro formatos, con y sin etiqueta/planteo/autor/acento.
// Los cuatro archivos de esta carpeta deben tener los mismos casos en el mismo orden.
#import "../../../core/scaffold.typ": frame, eyebrow, question, statement, headline
#import "../../../core/primitivas.typ": formatos as formats

#let mark = text(font: "Inter", size: 18pt, weight: 700, tracking: 0.12em)[TU MARCA]

#frame(type: "swiss", format: formats.story, brand: mark, author: [B. B. WARFIELD], dates: [1851 – 1921], accent: rgb("#1d4ed8"))[
  #eyebrow[DEL ENSAYO]
  #question[¿Qué es el calvinismo?]
  #statement[El calvinismo es simplemente la religión en su]
  #headline[PUREZA.]
]

#frame(type: "swiss", format: formats.instagram, brand: mark)[
  #statement[Todo es gracia.]
  #headline[GRACIA.]
]

#frame(type: "swiss", format: formats.instagram, brand: mark, author: [B. B. WARFIELD], dates: [1851 – 1921])[
  #eyebrow[APOCALIPSIS 13:18]
  #question[¿Capacidad o entendimiento?]
  #statement[El que tiene entendimiento, calcule el número de la bestia. No pide cómputo, pide]
  #headline[SABIDURÍA.]
]

#frame(type: "swiss", format: formats.retrato, brand: mark, author: [B. B. WARFIELD], dates: [1851 – 1921])[
  #eyebrow[UNA PALABRA]
  #statement[Todo es]
  #headline[GRACIA.]
]

#frame(type: "swiss", format: formats.twitter, brand: mark, author: [B. B. WARFIELD], dates: [1851 – 1921])[
  #eyebrow[DEL ENSAYO]
  #question[¿Qué es el calvinismo?]
  #statement[El calvinismo es simplemente la religión en su]
  #headline[PUREZA.]
]

#frame(type: "swiss", format: formats.story, brand: mark, accent: rgb("#c8102e"))[
  #statement[Todo es]
  #headline[GRACIA.]
]
