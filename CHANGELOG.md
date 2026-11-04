# Changelog

## [sin publicar] — catálogo de presets; temas que derivan sus roles extra

Los 16 demos de `examples/presets/` (110 láminas) renderizan idénticos byte a
byte antes y después (PNG a 40 ppi, `cmp`), salvo la lámina 3 de
`suizo-temas.typ`, el cambio deliberado de abajo.

### Añadido

- **Catálogo de presets.** `scripts/catalogo.py` renderiza cada demo de
  `examples/presets/*.typ` a miniaturas PNG (20 ppi, en paralelo) y compila
  `docs/catalogo.typ`: un índice (preset, función, láminas, formatos) y una
  página por preset con su descripción (la cabecera de comentarios de la demo),
  una llamada que lo genera y todas sus láminas en cuadrícula, numeradas y con su
  formato; la altura de las miniaturas se elige para que cada preset quepa en su
  página. Se regenera con `python3 scripts/catalogo.py` (`--png` exporta también
  las páginas del catálogo; con nombres de preset rehace solo esas miniaturas).
  Se versionan solo el script y el `.typ`: las miniaturas, el índice JSON y el
  PDF van a `docs/catalogo/`, ignorada por git (unos 9 MB que cambiarían con
  cada retoque de un preset y salen del código con un comando). Las llamadas
  están en el diccionario `llamadas` de `docs/catalogo.typ`; el script avisa si
  un preset nuevo no tiene la suya.

### Cambiado

- **Roles extra de los temas parciales.** Un tema que no trae un rol extra de
  un preset lo seguía heredando del tema por defecto, aunque cambiara los colores
  base (el filete cálido `#d9d3c7` de `suizo` sobre la paleta fría de
  `tema-desde-theme(theme.base)`; el ornamento vino de las orlas sobre un fondo
  verde). Ahora `resolver-tema` deriva el extra de los roles ya resueltos
  **solo si el tema cambia alguno de los roles de los que depende**
  (`derivados-lamina` en `src/carteles/_temas.typ`): `suizo.linea` (12 % de
  tinta en el fondo); en las orlas, `malla`/`franja` (fondo teñido de tinta) y
  `orn`/`fil`/`hondo` (el acento rebajado en el fondo u oscurecido); `gozne.claro`
  (el más legible sobre el acento, entre fondo y tinta); `demostracion.claro` (la
  tinta: antes un tema claro dejaba la afirmación crema sobre blanco). Con el tema
  por defecto, con uno completo (`"vino"`, `"papel"`) o con uno que solo retoca
  roles de los que el extra no depende, sale idéntico. Los extras de identidad
  (primarios de `bauhaus`, `hondo` de `mosaico` y `teselas`) siguen heredándose.
  Cambio visible en las demos: `suizo-temas.typ`, lámina 3 (filetes grises).
  Cambia también, a propósito, quien pase a una orla un tema con otro acento o
  fondo (los ornamentos siguen al acento).
- **`folio` y `esquela` obedecen al `fondo` del tema.** El degradado y la malla
  del pergamino de `folio` y el viñeteado de `esquela` eran literales; ahora se
  derivan del `fondo` del tema (centro aclarado, bordes oscurecidos; viñeteado =
  el fondo muy oscurecido). Con el fondo del tema por defecto se conservan los
  tonos de la lámina (idéntico). Los parámetros `pergamino:` y `papel:` retocan
  solo el color de fondo, como antes (la demo de esquela con `papel:` sale
  igual). `carteles.folio(..., tema: "escalera")` ya da un folio oscuro legible.
  Queda fija la capitular rubricada de `folio` (su caja beige con la letra roja
  viene de `capitular-ornamentada`).

## [sin publicar] — arquitectura de carteles (rama `refactor/arquitectura-capas`)

Sin cambios visuales con los valores por defecto: los ejemplos de
`examples/presets/` y `examples/blockquotes.typ` renderizan idénticos byte a
byte antes y después.

### Añadido

- **`carteles.teselas`** (`src/carteles/teselas.typ`): cartel con un bloque
  cuadrado de teselas — cuadrícula de 4×4 celdas con bloques de 2×2 — en tres
  colores que rotan de fondo y de figura (discos y «dianas»: un aro con un
  punto). Encima, título en negrita, párrafo (`frase`) y una palabra pesada
  (`remate`) apilada a la derecha, dos letras por línea. Las medidas salen de una
  lámina de referencia y se verificaron contra su render: el bloque coincide, el
  título y el párrafo dentro del 2-4 %. El título se achica si no cabe en el ancho
  del párrafo y la pila se escala si no cabe sobre el bloque (antes, un título
  largo chocaba con la palabra y una palabra larga pisaba el bloque). Tema
  `teselas` (roles `fondo`, `tinta`, `suave`, `acento`, `hondo`, `claro`).
  Diferencias con la referencia: la palabra se parte en pares (la referencia
  parte «DE / SI / G / N» según el ancho de sus letras), y los colores salen del
  SVG de la referencia; la lámina original está en CMYK y otra conversión a RGB
  los da algo más apagados (p. ej. el carmesí, `#D8225A` frente a `#D7375E`). Demo:
  `examples/presets/teselas.typ`.
- **`carteles.mosaico`** (`src/carteles/mosaico.typ` + el ayudante privado
  `src/carteles/_arcos.typ`): portada gráfica de diez líneas concéntricas — una
  «C» abierta o una «U» inclinada a 45° — con círculos macizos y un rombo, y
  dos rótulos muy espaciados (`autor`, vertical; `obra`, al pie). Tres
  variantes (`"c"`, `"u"`, `"u-inversa"`) en las que los tres colores del tema
  rotan de papel. Tema `mosaico` (roles `fondo`, `tinta`, `suave`, `acento` y
  el propio `hondo`). Las medidas salen de una lámina de referencia y se
  verificaron contra su render: líneas, círculos, rombo y rótulos coinciden
  dentro de ±1-2 px. Con `frase`, `etiqueta` y `remate` suma un título, un párrafo
  y una palabra apilada como `teselas`. El texto no va en cajas puestas a ojo: cada
  pieza busca su sitio a partir de la geometría del arte (los arcos y sus colas,
  los círculos, el rombo y los rótulos `autor`/`obra`/`marca` son obstáculos con un
  margen mínimo; `carteles/_huecos.typ`), prueba planes en orden de preferencia
  y cede primero el título y luego la pila antes de dejar el párrafo ilegible.
  Un título que no cabe en una línea se parte en dos. Cada variante forma un solo
  bloque con las alineaciones del propio arte (en «u», la pila arriba a la derecha
  y título con párrafo abajo a la derecha, sobre `obra`). Parámetros nuevos:
  `minimo:` (tamaño mínimo del párrafo, en px de la imagen final; por defecto 22 por
  cada 1080 de ancho) y `guias:` (dibuja los obstáculos y las cajas, para depurar).
  **Contrato:** si el texto no cabe ni al mínimo, `mosaico` da un error con mensaje
  (acorta la frase, quita `remate`, cambia de formato o variante, o baja `minimo`) en
  vez de dibujar un párrafo ilegible o pisar el arte; con ~150 caracteres cabe en
  todos los formatos, con ~300 no en cuadrado. Sin los parámetros de texto sale
  como siempre (idéntico byte a byte). Demo:
  `examples/presets/mosaico.typ`.
- **Área de trabajo en `carteles.mosaico`**: tres parámetros nuevos. `area:` acota
  la composición entera (lámina, rótulos, `marca` y la búsqueda de sitio del texto)
  a una fracción de la página — `70%`, o un par `(100%, 70%)` — y deja el resto en
  el color de fondo; `ancla:` la apoya (`top`, `bottom + left`…; por defecto
  centrada); `arte:` achica la lámina dentro del área para dejarle sitio al texto
  (`0.85`, o `auto`: la mayor escala, de 1 a 0,6, con la que el texto cabe sin que
  la pila baje del 80 %). Combinados resuelven casos que antes salían flojos: en la
  «U», `arte: 0.85, ancla: bottom` sube el texto a la banda de arriba en bandera a
  la derecha (por defecto va abajo, alineado a la derecha); en apaisado, `ancla:
  right` deja al texto una banda ancha a la izquierda; `arte: auto` evita que una
  pila larga se encoja en cuadrado y hace caber textos de ~250 caracteres a página
  completa en cuadrado. `minimo` sigue siendo en px de la imagen, así que un área
  chica admite menos texto: con `area: 70%` cabe una frase corta en todo; con ~150
  caracteres hace falta `arte: auto` y aun así no cabe en cuadrado ni en la «U»
  vertical (error con mensaje, como antes). Con `guias: true` el área se dibuja en
  verde. El brazo largo de la «U» sigue saliendo por el borde de la página. Las
  piezas viven en `carteles/_base.typ` (`area-trabajo`, `encajar`, re-exportadas en
  `carteles`) para que otros presets de lámina puedan usarlas; de momento solo
  `mosaico` las usa. La capa de texto gana `resolver-bloque` (la misma búsqueda,
  sin `context` y con un modo `probar` que no dibuja) y `pila-min`. Con los valores
  por defecto todo sale idéntico byte a byte (los 125 PNG de `examples/presets/` y
  `examples/blockquotes.typ`).
- **`carteles.bauhaus`** (`src/carteles/bauhaus.typ`): cartel de formas
  primarias sobre papel crudo — cuadrado rojo, círculo amarillo, cuña azul y
  una barra negra diagonal — con el remate en minúsculas de Jost (sans
  geométrica) a todo el ancho. Las formas no son porcentajes sueltos: se
  construyen unas de otras sobre una «línea de tierra» justo encima del texto
  (el cuadrado apoya en ella, el círculo está centrado en su esquina, la barra
  pasa por esa esquina y la cuña llena el hueco bajo la barra), así que nada
  puede pisar la etiqueta, el planteo ni la frase. Opción `textura` (grano de
  papel, activada). Mismo contrato que
  `carteles.suizo` (frase, remate, autor, fechas, etiqueta, planteo, marca): se
  cambia de estilo cambiando solo el nombre. Tema `bauhaus` en el registro, con
  los roles propios `amarillo` y `azul`. Demo: `examples/presets/bauhaus.typ`.
- `src/carteles/_base.typ`: `medida`, `escala`, `cuerpo-al-ancho` y
  `ajustar-alto`, que los presets repetían cada uno por su cuenta
  (`carteles.cuerpo-al-ancho` sigue exportado).
- **Temas de lámina** (`src/carteles/_temas.typ`): una paleta por roles común
  a los presets — `fondo`, `tinta`, `suave`, `acento` (más roles propios de
  cada uno, como `linea` o los de la orla). Registro `carteles.temas-lamina`,
  `carteles.resolver-tema` y `carteles.tema-desde-theme(theme.base)`.
  `suizo`, `esquela`, `folio`, `gozne`, `escalera`, `linea-tiempo`,
  `demostracion` y las orlas aceptan `tema:`; sus parámetros de color
  (`papel:`, `luto:`, `rubrica:`…) siguen existiendo y pisan al tema.
- **Vocabulario de atribución**: `autor`, `obra` (la obra citada),
  `referencia` (el pasaje: "Salmo 51"), `fechas`, `version`. `obra:` se
  acepta ahora en `blockquote-editorial/-bar/-card/-hero/-avatar/-lateral/
  -pull`, `bq-attribution`, `cita-orlada` y `pregunta-orlada`;
  `carteles.folio` acepta `referencia: "Salmo 51"` como atajo de `glosa`.

### Cambiado

- La capa de texto de `teselas` (título que se achica, párrafo que se achica, palabra
  apilada que se escala) pasa a un módulo privado, `carteles/_texto.typ`, que usan
  `teselas` y `mosaico`. `teselas` sale idéntico byte a byte (5 de 5 páginas). La
  capa fija su propio espaciado y tipografía: el primer intento en `mosaico`
  heredaba el `tracking: 0.65em` de sus rótulos y salía ilegible. (Dentro de
  `context`, `measure` no ve los `set text` del mismo bloque: la capa medía el
  párrafo con una tipografía y lo dibujaba con otra, y por eso encogía de más; ahora
  cada texto lleva su tipografía y espaciado explícitos y mide lo que dibuja.)
- `scripture.typ` tenía dos APIs que no se hablaban: `scripture`, `vs` y `ch`
  con fuentes fijas, y `pasaje` con tema. Ahora las tres piezas aceptan
  `theme:` (por defecto `auto`) y `pasaje` también (`theme:` en vez de
  `paleta:`/`tipografia:`). El tema de un `pasaje` o `scripture` llega a los
  `#vs[2]` y `#ch[1]` de su cuerpo (por un `state`, que el contenedor fija y
  restituye); fuera de un contenedor con tema, el aspecto neutro de siempre.
  Efecto visible: dentro de un `pasaje`, el número de versículo sale en la
  tipografía del cuerpo del tema, no en EB Garamond fijo.
- `fuente:` como "obra citada" (blockquotes y orlas) pasa a ser alias de
  `obra:` (manda `obra` si se dan las dos). `fuente` queda reservado para la
  tipografía, que es lo que significa en `escalera`, `gozne`, `folio` y
  `linea-tiempo`; antes el mismo nombre significaba dos cosas.
- `orlas`: el rol `texto` de sus temas pasa a `tinta`; un diccionario viejo con
  `texto` se sigue entendiendo, y `carteles.temas-orla` conserva `texto`.

### Arreglado

- **`superbg`: el `ruido` ya no hace pesar un PDF decenas de MB.** El ruido es
  un filtro SVG (`feTurbulence`) y Typst, al exportar a PDF, lo rasteriza en una
  sola imagen de ~4000×5000 px más su máscara, sin importar el `viewBox`: un
  cartel con textura pesaba 26 MB. Ahora `bg-patron(patron: "ruido")` dibuja una
  tesela de 216 pt repetida con `tiling` (el SVG ya traía `stitchTiles`, así que
  no hay costura). Medido: sin diferencia en el borde de la tesela (×1,00 la
  diferencia entre columnas contiguas) ni en la intensidad del grano
  (desviación 0,637 contra 0,640). PDF de `esquela` 50,8 → 1,0 MB (45 → 3 s), de
  `folio` 62,9 → 3,0 MB (50 → 16 s), de `bauhaus` 26,8 → 1,5 MB. Los PNG de
  `esquela` y `folio` cambian solo en el detalle del grano (error medio 0,2-0,4 %,
  ningún píxel difiere más del 8 %); `suizo`, sin ruido, sigue idéntico byte a
  byte.

### Quitado

- Código muerto sin uso: el diccionario autorreferencial de
  `font-tokens.typ`, el import `by-category` de `font-pairings.typ` y
  `set-body-font` de `scripture.typ`.

### Pendiente

Ver `docs/oportunidades-mejora.md`, sección «Pendientes de la refactorización
de carteles» (roles extra de temas parciales; colores de ambientación fijos en
`folio` y `esquela`).

## [sin publicar] — contraste WCAG vendorizado + rename semántico de tokens

Hecho en sesión de Claude Code sobre `rapiquote`. Contexto completo
para quien retome esto: `rapiquote` y este repo compartían el mismo
sistema de color (mismos 96 tokens `familia-NNN`, mismo bug de
contraste). En `rapiquote` se arregló primero y se generalizó en un
paquete hermano, `superpelettes`; acá se trajo ese arreglo de vuelta
pero vendorizado directo en `src/contrast.typ` (ver sección
"Cambiado"), no como dependencia del paquete `@local`.

### Arreglado (bug real, no solo estilo)

`theme.typ` y `palettes.typ` reimplementaban, cada uno por su lado, el
mismo cálculo de contraste WCAG -- y las dos copias tenían el mismo
bug: `luminance(c)` llamaba `c.components()` sin forzar `.rgb()`
antes. Para cualquier color en espacio `luma` (`white`/`black`,
literales que `theme.base.colors.white` usa) eso lee mal los canales:
`luminance(black)` daba **0.7152** en vez de **0**.

Confirmado con un caso real del propio repo (`examples/api.typ`,
"Texto legible sobre primary"): con el bug elegía **blanco**; el
contraste correcto da negro a **7.57:1** contra apenas **2.77:1** de
blanco -- la respuesta estaba al revés. Ya corregido: ahora elige
**negro**.

### Cambiado (breaking)

- **`tokens.typ`: 96 → 81 colores, renombrados.** El sufijo numérico
  (`red-650`, `blue-700`...) no representaba nada estandarizado, y
  varias claves distintas resultaban, medidas en OKLCH, el *mismo*
  color real (`blue-700`/`blue-800` diferían en hue < 1° y en croma <
  0.01). Cada nombre nuevo (`coral`, `cielo`, `vino-frío`, `escarlata`...)
  es un color realmente distinto. Mapeo completo viejo → nuevo en el
  comentario de cabecera de `src/tokens.typ`. Los 19 neutros
  (`stone-*`, `slate-*`) conservan su nombre-NNN -- ahí el número sí es
  una escala real de claridad.
  **Cualquier código que llame `token("red-650")` (o cualquier clave
  vieja) con el nombre anterior ahora hace `panic`.**
- **`palettes.get("granates")` y `palettes.get("marino")` devuelven
  colores distintos**, no solo renombrados. Varias de sus 10/5 claves
  viejas colapsaron en el mismo color real al medirlas; se
  reconstruyeron a mano con colores genuinamente distintos para no
  perder la variedad visual de la paleta.
- **`src/contrast.typ` nuevo:** `luminance`/`contrast`/`is-aa`/`is-aaa`/
  `readable-on`/`auto-pair`/`auto-pair-tinted` vendorizados desde
  `superpelettes` (ya con el fix de `.rgb()`), sin que el paquete haga
  falta instalado en ningún lado -- `theme.typ` y `palettes.typ`
  importan de este archivo local. `auto-roles` queda en `palettes.typ`
  mismo (usa su `saturation` ya existente + `luminance` de
  `contrast.typ`). Cero dependencias nuevas, el repo compila solo.

### Agregado (no rompe nada)

- `theme.auto-pair(bg)` / `theme.auto-pair-tinted(bg, extra:)` --
  nuevas en el namespace `theme`, no existían antes. Dado cualquier
  color de fondo, eligen el texto (blanco o negro, + candidatos extra
  en la variante `tinted`) de mayor contraste real garantizado.

### Sin cambios

- `src/lib.typ` -- mismos exports de siempre (`theme`, `palettes`,
  `color-tokens`, etc.), nada nuevo ni eliminado a ese nivel.
- Todas las demás funciones de `theme`/`palettes` (`define`, `with`,
  `color`, `font`, `get`, `mix`, `as-theme`, `swatch`, `catalog`...) --
  misma firma, mismo comportamiento.
- `theme.base.colors.primary/secondary/accent` -- mismo hex de siempre
  (`#4f46e5`, etc.), solo cambió el nombre de token interno que los
  resuelve (`indigo-400` → `índigo`, etc.)

### Archivos tocados

`src/contrast.typ` (nuevo), `src/theme.typ`, `src/tokens.typ`,
`src/palettes.typ`, `demo.typ` (conteo "Tokens (96)" → "(81)"),
`docs/manual.typ` (dos snippets con claves viejas + conteo + referencia
a `@local/superpelettes` actualizada a `src/contrast.typ`), `README.md`
(línea de `contrast.typ` en la estructura; se quitó la sección
"Dependencias", ya no aplica).

Verificado compilando los 14 `examples/*.typ`, `demo.typ` (46
páginas), `docs/manual.typ` y `ornamentos/ornamentos.typ` -- todo
compila limpio, sin ningún paquete `@local` instalado más allá de
`instatypst` mismo.
