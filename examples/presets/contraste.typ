// Demo de contraste(): dos lados enfrentados, en tres formatos y con
// distinto número de ítems. Los ítems se ajustan solos a lo que cabe.
// Ver src/contraste.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/contraste.typ
#import "../../src/contraste.typ": contraste

#let marca = text(font: "Jost", size: 20pt, weight: 600, tracking: 0.12em)[TU MARCA]

#let ley = (
  rotulo: [La ley],
  titulo: [Muestra el pecado],
  items: ([Dice lo que Dios exige], [Cierra toda boca], [No puede dar vida]),
)
#let evangelio = (
  rotulo: [El evangelio],
  titulo: [Da al Salvador],
  items: ([Anuncia lo que Dios ha hecho], [Abre la boca para alabar], [Da vida por el Espíritu]),
)

// retrato (4:5): columnas
#contraste(ley, evangelio, titulo: [Ley y evangelio], autor: [B. B. Warfield], obra: [La imputación], marca: marca)

// story (9:16): los lados se apilan
#contraste(ley, evangelio, formato: (1080, 1920), titulo: [Ley y evangelio], marca: marca)

// apaisado: columnas anchas, sin titular
#contraste(ley, evangelio, formato: (1600, 900), marca: marca)

// cuadrado, muchos ítems: se achican para caber; un ítem con rol propio
#contraste(
  (rotulo: [Antes], titulo: [Cargas], items: ([Reunión semanal], [Informe a mano], [Tres hojas de cálculo], [Aprobación por correo], [Archivo perdido])),
  (rotulo: [Después], titulo: [Alivio], items: ([Cada quien su turno], [Informe automático], [Una sola hoja], (texto: [Sigue pendiente el archivo], rol: "neutro"), [Todo en un sitio])),
  formato: (1080, 1080), medallon: [→], marca: marca,
)
