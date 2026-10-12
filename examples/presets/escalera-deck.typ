// Demo: carteles.escalera + curvas.campo — un deck de 3 diapositivas
// apaisadas cuyo fondo de curvas de nivel corre continuo de una a otra
// (`curvas:` recibe el campo, `indice:` dice qué ventana dibuja).
// Compilar: typst compile --root . --font-path Fonts examples/presets/escalera-deck.typ
#import "../../src/lib.typ": carteles, curvas

#let formato = (1920, 1080)
#let fondo = curvas.campo("topo", diapositivas: 3, formato: formato, color: rgb("#8fb8a4"), opacidad: 40%, semilla: 3)
#let diapositiva(i, peldanos, climax) = carteles.escalera(
  peldanos, climax, formato: formato, curvas: fondo, indice: i,
  autor: [B. B. WARFIELD], obra: [La teología de Calvino],
  marca: text(size: 18pt, tracking: 0.12em)[TU MARCA],
)

#diapositiva(0, ([El calvinista es el hombre], (texto: [que ve a Dios], cuerpo: 96pt, peso: 600)), [detrás de todo.])
#diapositiva(1, ([detrás de todos], [los fenómenos,], [y en todo lo que ocurre]), [reconoce])
#diapositiva(2, ([en todo lo que ocurre reconoce],), [la mano de Dios.])
