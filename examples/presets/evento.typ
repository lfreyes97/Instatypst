// Demo de evento(): la fecha como protagonista, en tres formatos y con
// distinto largo de título. El título se achica solo hasta caber.
// Ver src/evento.typ.
// Compilar: typst compile --root . --font-path Fonts examples/presets/evento.typ
#import "../../src/evento.typ": evento

#let marca = text(font: "Jost", size: 22pt, weight: 600, tracking: 0.12em)[TU MARCA]

// retrato (4:5), con todo
#evento(
  14, [nov], [Conferencia de otoño: la soberanía de Dios en la vida diaria],
  etiqueta: [Conferencia],
  detalle: [Sábado · 9:00 a. m. · Salón principal],
  llamada: [Reserva tu lugar →], marca: marca,
)

// story (9:16): sobra alto, el título queda abajo
#evento(
  2, [dic], [Culto de acción de gracias],
  formato: (1080, 1920), etiqueta: [Domingo],
  detalle: [10:30 a. m. · Todos invitados],
  llamada: [Confirma tu asistencia →], marca: marca,
)

// cuadrado, título largo: se achica para caber
#evento(
  21, [diciembre], [Retiro de matrimonios: edificando el hogar sobre la roca de la Palabra de Dios],
  formato: (1080, 1080), detalle: [Casa de retiros · cupos limitados],
  llamada: [Inscríbete →], marca: marca,
)

// apaisado, sin llamada ni detalle: solo fecha y título
#evento(
  7, [ene], [Reunión de líderes],
  formato: (1600, 900), marca: marca,
)
