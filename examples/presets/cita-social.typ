// Demo de carteles.cita-social() — la cita con su autor (foto o iniciales), en
// tres variantes (tarjeta, sangre, abierta) y tres posiciones de la atribución,
// con el cuerpo ajustado solo. Sustituye a quote-social.
// Láminas 1-6: el estilo clásico tal cual (las de referencia); 7: el clásico
// con los campos de contenido; 8-16: un estilo por lámina, en formatos varios.
// Compilar: typst compile --root . --font-path Fonts examples/presets/cita-social.typ
#import "../../src/lib.typ": *

#let larga = [Una obra pseudónima que presenta una síntesis neoplatónica cristianizada bajo el nombre de un discípulo de los apóstoles adquiere autoridad precisamente por una identidad apostólica que no posee. Si esa obra contribuye posteriormente a consolidar determinadas estructuras metafísicas de la teología y liturgia medieval, uno puede describir teológicamente esa falsificación como una #highlight[obra diabólica]: no porque podamos demostrar la agencia personal del diablo, sino porque el mecanismo es exactamente el tipo de engaño que la teología cristiana atribuye a Satanás.]
#let corta = [La constancia entrena al algoritmo… y a tu #highlight[audiencia].]
#let quien = [Luis Felipe Reyes de los Reyes]
#let foto = "/examples/avatar.jpg"

// story, tarjeta con foto y atribución arriba, fondo verde
#carteles.cita-social(larga, quien, iniciales: "LR", foto: foto, atribucion: "arriba",
  formato: (1080, 1920), fondo: rgb("#13ddab"))
// cuadrado, cita corta: el cuerpo sube hasta el máximo
#carteles.cita-social(corta, quien, iniciales: "LR", formato: (1080, 1080), comilla: true)
// de sangre
#carteles.cita-social(larga, quien, iniciales: "LR", foto: foto, variante: "sangre", formato: (1080, 1350))
// abierta, atribución al lado
#carteles.cita-social(corta, quien, iniciales: "LR", foto: foto, variante: "abierta", atribucion: "lado",
  formato: (1080, 1350), comilla: true)
// apaisado (twitter)
#carteles.cita-social(corta, quien, iniciales: "LR", foto: foto, formato: sizes.twitter)
// con marca y notas
#carteles.cita-social(corta, quien, iniciales: "LR", formato: (1080, 1350),
  marca: text(weight: 700, tracking: 0.12em, size: 18pt)[TU MARCA],
  nota-izq: (icono: "🔒", texto: "privado"), nota-der: (icono: "🔑", texto: "llave"))

// ── contenido extra y estilos ──
#let media = [Lo que no se mide no se mejora, pero lo que se mide mal se empeora con toda #highlight[confianza]: elige bien la métrica antes de optimizarla.]
#let breve = [Menos, pero #highlight[mejor].]
#let datos = (usuario: "@luisreyes", fecha: "5 nov 2026", verificado: true)
#let cifras = (comentarios: 48, compartidos: 1310, me-gusta: 12345, vistas: 2500000)

// 7. el clásico con usuario, fecha, insignia, contexto y métricas
#carteles.cita-social(media, quien, iniciales: "LR", foto: foto, formato: (1080, 1350), ..datos,
  contexto: [En respuesta a \@marta], metricas: cifras)
// 8. publicación, con la cita anidada y las métricas
#carteles.cita-social(media, quien, iniciales: "LR", foto: foto, estilo: "publicacion", formato: (1080, 1350),
  ..datos, metricas: cifras,
  respuesta: (nombre: [Marta Gil], usuario: "@marta", texto: [¿Qué métrica usarías para medir el alcance real?]))
// 9. mensaje, story
#carteles.cita-social(corta, quien, iniciales: "LR", foto: foto, estilo: "mensaje", formato: (1080, 1920),
  ..datos, contexto: [Hoy], metricas: (me-gusta: 214, comentarios: 12),
  respuesta: (nombre: [Marta Gil], texto: [¿Publicar todos los días sirve de algo?]))
// 10. editorial, cuadrado, firma al lado
#carteles.cita-social(media, quien, estilo: "editorial", formato: (1080, 1080), atribucion: "lado",
  contexto: [De _Notas sobre medir_], fecha: "2026")
// 11. papel, con comilla y foto
#carteles.cita-social(media, quien, iniciales: "LR", foto: foto, estilo: "papel", formato: (1080, 1350),
  comilla: true, contexto: [Cuaderno, p. 12], fecha: "5 nov 2026")
// 12. pizarra, apaisada
#carteles.cita-social(media, quien, estilo: "pizarra", formato: sizes.twitter,
  contexto: [Clase de métricas], fecha: [5 de noviembre], verificado: true)
// 13. recorte, la cita larga
#carteles.cita-social(larga, quien, foto: foto, estilo: "recorte", formato: (1080, 1350),
  contexto: [Teología e historia], fecha: "Miércoles, 5 de noviembre de 2026", usuario: "@luisreyes")
// 14. aura, LinkedIn
#carteles.cita-social(corta, quien, iniciales: "LR", foto: foto, estilo: "aura", formato: (1200, 1200),
  ..datos, contexto: [Lo más leído de la semana], metricas: (me-gusta: 3400, compartidos: 120))
// 15. minimal, cuadrado
#carteles.cita-social(breve, quien, estilo: "minimal", formato: (1080, 1080), fecha: "2026")
// 16. subrayado, story, atribución arriba
#carteles.cita-social(media, quien, iniciales: "LR", estilo: "subrayado", formato: (1080, 1920),
  atribucion: "arriba", comilla: true, contexto: [Idea del día], usuario: "@luisreyes")
