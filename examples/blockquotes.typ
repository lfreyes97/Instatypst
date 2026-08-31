#import "../src/lib.typ": *

// Las blockquote-* no son un canvas por sí solas — se insertan dentro de
// una plantilla o página existente. Aquí, cada una dentro de un canvas en
// blanco (bg + pad), para ver cómo se ven ya montadas en un post real.

#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #blockquote-editorial(
      [El diseño no es cómo se ve algo. Es cómo funciona.],
      autor: "Steve Jobs",
      fuente: "Wired, 1996",
    )
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #blockquote-bar(
      [La constancia entrena al algoritmo... y a tu audiencia.],
      autor: "Equipo de redes",
      color: palette.secondary,
    )
    #v(40pt)
    #blockquote-bar(
      [Una cita más grande, con la variante "grande".],
      autor: "Alguien",
      variante: "grande",
      color: palette.accent,
    )
    #v(40pt)
    #blockquote-bar(
      [Una cita acentuada con fondo tenue.],
      variante: "acento",
      color: palette.primary,
    )
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #blockquote-card(
      [Las cuentas que usan carruseles duplican su interacción.],
      autor: "María J.",
      fuente: "Community Manager",
      color: palette.primary,
    )
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #gradient-bg(from: palette.dark, to: palette.primary)
  #pad(page-pad)[
    #blockquote-hero(
      [No somos almas que tienen cuerpos; somos cuerpos que, cuando Dios lo ordena, resucitarán.],
      autor: "C.S. Lewis",
      color: palette.accent,
    )
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #blockquote-grid(
      columnas: 2,
      (
        blockquote-avatar([En dos semanas pasamos de improvisar a tener un feed coherente.], autor: "María J.", fuente: "CM", iniciales: "MJ"),
        blockquote-avatar([El contenido es rey, pero la constancia es reina.], autor: "Autor Anónimo", iniciales: "AA", color: palette.secondary),
      ),
    )
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #blockquote-hand(
      [El corazón tiene razones que la razón no conoce.],
      autor: "Pascal",
    )
  ]
])

#pagebreak()

// ── Nuevos con finetuning (no-GFM) ──
#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #blockquote-pull(
      [La tipografía es la ropa que le pones a las ideas.],
      autor: "Anónimo", fuente: "Manual de estilo", color: palette.secondary,
    )
    #v(32pt)
    #blockquote-pull(
      [Menos es más — hasta que deja de comunicar.],
      autor: "Mies van der Rohe", marca: none, color: (palettes.as-theme)("neon").colors.primary,
    )
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #blockquote-definition("Sola Scriptura", pronunciacion: "so-la skrip-tu-ra", origen: "latín", relacionados: ("Sola Fide", "Sola Gratia"), color: palette.primary)[Doctrina según la cual la Escritura es la única autoridad infalible para la fe y la práctica. No niega otras autoridades, las subordina.]
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.white)
  #pad(page-pad)[
    #blockquote-callout(variante: "tip", titulo: "Tip", icono: "✦")[Publica carruseles de 6–8 slides: retienen 2× más que una sola imagen.]
    #blockquote-callout(variante: "info", titulo: "Nota editorial", icono: "◐")[Esta traducción usa *YHWH* donde el hebreo trae el tetragrámaton.]
    #blockquote-callout(variante: "warn", titulo: "Cuidado", icono: "⚠")[Evita poner más de 25 palabras por slide — el ojo abandona.]
    #blockquote-callout(variante: "hand", titulo: "Marginal", icono: "✎")[Idea al margen: probar con fondo crema, no blanco.]
  ]
])

#pagebreak()

#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #blockquote-poetry(autor: "Jorge Luis Borges", color: palette.primary)[El aleph es uno de los puntos del espacio \ que contiene todos los puntos. \ Vi en el aleph la tierra y en la tierra otra vez el aleph.]
    #v(28pt)
    #blockquote-timeline("1517", [Martín Lutero clava las 95 tesis en Wittenberg — inicio simbólico de la Reforma.], color: rgb("#8b2e3a"))
    #blockquote-timeline("2026", [Este sistema nace: paletas + tipografía + editorial en Typst.], color: palette.secondary)
  ]
])

#pagebreak()

// Atribución lateral rotada (rotate(270deg)) — puerto de un patrón
// editorial visto fuera del proyecto, con nuestros propios tokens.
#canvas(sizes.instagram, [
  #bg(palette.light)
  #pad(page-pad)[
    #blockquote-lateral(
      n: 26,
      autor: "Blaise Pascal",
      fuente: "Pensées",
    )[Del mismo modo que se estropea la mente, se estropea también el sentimiento.

    La mente y el sentimiento se forman por medio del trato con los demás; y es imposible elegir bien si uno no está ya formado y no estropeado.]
  ]
])
