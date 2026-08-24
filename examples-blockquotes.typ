#import "social.typ": *

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
