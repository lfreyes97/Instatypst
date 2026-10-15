// Compilar: typst compile --root . --font-path Fonts trabajos/vantil-recompensas/vantil-recompensas.typ salida/vantil-recompensas.png --ppi 144
#import "../../src/lib.typ": sizes
#import "../../src/linea-tiempo.typ": linea-tiempo


#linea-tiempo(
  (
    [Primero fue la humanidad como unidad la que recibió la tarea común de sojuzgar la tierra.],
    [Luego la humanidad quebrantó el pacto y Dios puso a todos bajo la maldición, una maldición común.],
  ),
  remate: [Vino Cristo a salvar al mundo.],
  origen: [Adán],
  fin: [Cristo],
  formato: (1080, 1350),
  autor: [Cornelius Van Til],
  obra: [ _Common Grace and the Gospel_ (cap. 4, pp. 99–100)],
  fuente: "Fraunces",
)
