// Demo de carteles.franjas() — la cita con una cabecera de color y la marca
// centrada, un título en mayúsculas condensadas, una regla, la cita centrada y,
// debajo, una ilustración a sangre tapada por un velo del color del cuerpo que
// se disuelve hacia abajo; cierra una tira oscura con el pie. Es la estructura
// de una serie de citas de una misma cuenta: cambia el texto y la imagen, y el
// resto se queda. Primero con un fondo de superbg como ilustración, luego con
// otro, sin título (y por tanto sin regla), y por último en vertical, sin
// ilustración y con los colores del tema cambiados.
// La imagen entra ya hecha (`imagen:`), como el logo (`marca:`): el paquete no
// conoce a nadie. Aquí hacen de ilustración unos fondos de superbg.
// Compilar: typst compile --root . --font-path Fonts examples/presets/franjas.typ
#import "../../src/lib.typ": *

#let marca = text(font: "Bebas Neue", size: 34pt, tracking: 0.04em, fill: white)[TU MARCA]
#let pie = [tu-sitio.com]
#let cita = [«Por supuesto, todos los hombres tienen fe. Los incrédulos tienen fe tanto como los creyentes. Pero eso se debe al hecho de que ellos también son criaturas de Dios. Por lo tanto, la fe siempre tiene contenido.»]

// Una ilustración a sangre cualquiera: un fondo de superbg del tamaño de la lámina
#carteles.franjas(
  cita, titulo: "El autoengaño del incrédulo", marca: marca, pie: pie,
  imagen: superbg.superbg("atardecer-malla", size: (1080, 1080)),
)

// Otro fondo. Con una foto propia: `imagen: image("foto.jpg", width: 100%,
// height: 100%, fit: "cover")` (la ruta es relativa al archivo que la llama)
#carteles.franjas(
  [Dios no necesita que lo defendamos. Él es la precondición de toda defensa.],
  titulo: "La roca de los siglos", marca: marca, pie: pie,
  imagen: superbg.superbg("aurora", size: (1080, 1080)),
)

// Sin título no hay regla: la cita sube bajo la cabecera. Aquí en 4:5.
#carteles.franjas(
  [El temor de Jehová es el principio de la sabiduría.],
  marca: marca, pie: pie, formato: (1080, 1350),
  imagen: superbg.superbg("amanecer", size: (1080, 1350)),
)

// En vertical, sin ilustración (el cuerpo es liso) y con los roles cambiados:
// cabecera azul y tira azul marino. El velo y la imagen siguen siendo opcionales.
#carteles.franjas(
  cita, titulo: "Otro tema", marca: marca, pie: pie, formato: (1080, 1920),
  acento: rgb("#1d4ed8"), tira: rgb("#0b1b3b"), fondo: rgb("#050b1a"),
)
