#import "../src/lib.typ": *

// Portada de carrusel
#carousel-cover(
  "GUÍA 2026",
  [Cómo crecer en Instagram sin pagar anuncios],
  "@mi_marca",
)

#pagebreak()

// Slide interior del carrusel
#carousel-slide(
  2, 6,
  [Publica con constancia],
  [El algoritmo premia las cuentas activas. Fija un horario y respétalo: mejor 3 posts semanales fijos que 10 seguidos y silencio.],
  "@mi_marca",
)

#pagebreak()

// Tarjeta de estadística
#stat-card(
  "+240%",
  [más alcance orgánico],
  [Las cuentas que usan carruseles duplican su interacción frente a las imágenes simples.],
  "@mi_marca",
)

#pagebreak()

// Comparación antes / después
#versus-post(
  "Sin estrategia",
  ([Publicar al azar], [Sin identidad visual], [Ignorar comentarios]),
  "Con sistema",
  ([Calendario fijo], [Plantillas reutilizables], [Comunidad activa]),
  "@mi_marca",
)

#pagebreak()

// Evento (formato story)
#event-post(
  "12",
  "SEPT",
  [Webinar: Diseño con Typst],
  ["Gratis · Online · 18:00 CET. Aprende a crear visuales profesionales desde código."],
  "@mi_marca",
)

#pagebreak()

// Testimonio
#testimonial-post(
  [En dos semanas pasamos de publicar improvisando a tener un feed coherente. El engagement se disparó.],
  "María J.",
  "Community Manager",
  "MJ",
  "@mi_marca",
)

#pagebreak()

// Encuesta para stories
#poll-story(
  [¿Qué quieres ver mañana?],
  ["Tutorial paso a paso"],
  ["Plantilla descargable"],
  "@mi_marca",
)
