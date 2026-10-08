# Campaña de lanzamiento — 20 citas de B.B. Warfield

Cada cita es un `.typ` independiente en esta carpeta, listo para compilar a
PNG y publicar. Fuente: *Ensayos de B.B. Warfield sobre el calvinismo y
otros temas* (primera traducción al español).

## Compilar

```bash
./campana/compile-all.sh                     # las 20 (~1,5 min)
typst compile --root . --font-path Fonts campana/07-imputacion-gozne.typ campana/07-imputacion-gozne.png
```

---

## La dirección de arte: una idea por lámina

**La campaña vive de la diversidad.** Cada lámina tiene su propia
composición, formato, letra y fondo, sacados de lo que *dice* la cita: la
bisagra de la imputación se dibuja como un gozne, la palabra que muere
recibe una esquela, «ensanchador» se ensancha, el árbol de Darwin está seco
por la copa. No hay plantilla compartida, y no se debe introducir una: una
versión anterior unificó las 20 en un solo «pliego» y aplanó justamente lo
que hacía valer la campaña.

El único hilo común obligatorio es la **atribución** (B. B. Warfield + el
ensayo; en la 20, Darwin citado por Warfield) y la **marca**: siempre el
logo, nunca el handle en texto, y siempre a la misma escala respecto del
lienzo. `logo(color, (ancho, alto))` fija el alto en 1/30 de √(ancho ×
alto): ocupa la misma parte de la lámina sea cuadrada (36 pt), retrato
(40 pt), apaisada (40 pt) o story (48 pt). Un tamaño fijo, o uno medido
solo por el ancho, no sirve con geometrías distintas. No se ajusta a mano por lámina.

`_comun.typ` no es una plantilla: es una caja de herramientas (`logo()`
recoloreado, `formatos` con el 4:5, `ajustar()` para el mayor tamaño de
texto que cabe).

## Las 20

| # | Ensayo | Formato | Concepto | Letra |
|---|---|---|---|---|
| 01 | ¿Qué es el calvinismo? | retrato 4:5 | Cartel suizo: «PUREZA.» en rojo a todo el ancho, retícula visible | Bebas Neue, Hanken Grotesk |
| 02 | El calvinismo: significado y usos del término | cuadrado | Noche con rayos de oro detrás de «ha visto a Dios»: la visión como luz | DM Serif Display |
| 03 | El calvinismo hoy | cuadrado | Risografía a dos tintas: un mundo en semitonos asoma bajo «esperanza del mundo» | Fraunces 72pt |
| 04 | La teología de Calvino | story | Mapa topográfico nocturno (los fenómenos); el clímax cae sobre la cumbre | Literata |
| 05 | La incapacidad y la exigencia de la fe | retrato | Partida en diagonal: mandato en negro, promesa en amarillo | Bricolage Grotesque |
| 06 | La expiación | cuadrado | Quiasmo en espejo a los lados de una cruz-eje; filetes que forman una χ | Cormorant Garamond |
| 07 | La imputación | twitter | Lámina técnica: un gozne visto desde arriba, las tres doctrinas como hojas | Libre Baskerville, Instrument Sans |
| 08 | La predestinación | retrato | Barro: terracota, terrones y una vasija recién torneada | Fraunces 72pt Soft |
| 09 | La elección | twitter | Corrección de pruebas: la primera cláusula tachada, «para que» en rojo | Public Sans |
| 10 | «Redentor» y «redención» | retrato | Esquela: orla de luto, cruz y REDENCIÓN como nombre del difunto | IM FELL |
| 11 | Salmo 51 | cuadrado | Folio de salterio: capitular iluminada (la única de la campaña), rúbricas, manecilla | IM FELL |
| 12 | La guía del Espíritu | story | «nosotros mismos por nosotros mismos» en anillo cerrado; «por el Espíritu Santo» rompe hacia las olas | Cormorant Garamond, Ysabeau |
| 13 | El Espíritu de fe | story | Pasquín de tipos de madera, negro y rojo sobre papel de periódico | Bebas Neue |
| 14 | Fortalecimiento espiritual | twitter | «ensanchador.» deformado a todo el ancho con cota; «estira el intelecto» espaciado | Jost, Syne |
| 15 | El amor del Espíritu Santo | cuadrado | Malla cálida, exclamaciones gigantes, «anhelante» y «celoso» ladeados | Fraunces 72pt |
| 16 | La polémica del pedobautismo | retrato | Línea de tiempo: de Abraham (Génesis 17) a hoy | Jost, Literata |
| 17 | Apologética | cuadrado | Demostración en pizarra: ⊢ racional / ⊬ ~~ir~~racional | Instrument Sans, DM Mono |
| 18 | El sobrenaturalismo cristiano | twitter | Horizonte: DE bajo tierra, EN sobre la línea, SOBRE en el cielo, sol en la cumbre | Cormorant Garamond, Marcellus |
| 19 | La vida religiosa de Charles Darwin | story | Árbol dibujado por código, vivo abajo y seco por la copa | Literata |
| 20 | (Darwin, citado por Warfield) | retrato | Vacío oscuro, la frase pequeña en el centro; dialoga en color con la 19 | GFS Didot, DM Mono |
| 21 | (fuera de la serie Warfield) Is 7,9 Vetus Latina | story | Reloj de arena de texto: el pasado se estrecha, el latín pasa por la cintura en rojo, el futuro se abre; cada renglón llena el vidrio a su altura | EB Garamond 12 con dlig + hlig, ſ a mano |
| 21b | (v2 de la 21) | twitter | Libro abierto: verso = pasado, recto = futuro; los une el reclamo «y eſta-». Titulillos «crede, / ut intelligas.» | EB Garamond 12 con dlig + hlig, ſ a mano |

Formatos: 6 cuadrado (1080×1080) · 6 retrato (1080×1350) · 4 twitter
(1600×900) · 4 story (1080×1920) — repartidos por lo que pide cada cita, no
por cuota.

**19 y 20 — par Darwin/Hodge.** Las dos llevan una nota visible aclarando
que son palabras *sobre* Darwin o *de* Darwin, no de Warfield. Sin esa
nota, suelta en un feed, la 20 parecería atribuirle a Warfield una frase de
Darwin.

## Reglas que sí se mantienen

- La redacción de las citas no se toca (la tipografía sí: versalitas,
  mayúsculas de la 13, cortes de línea a mano).
- Ningún texto por debajo de ~22 pt en lienzos de 1080 de ancho.
- Contraste de texto ≥ 4,5:1 (`contrast()` de `src/contrast.typ`); se
  verificó en las 20.

## Notas técnicas

- **Signo menos en SVG.** `str()` de Typst escribe los negativos con
  U+2212 («−»), que el SVG no entiende: `bg-rayos`, `bg-topo` y demás
  fondos de `superbg` perdían toda forma con coordenadas negativas (la 02
  solo mostraba un cuadrante de rayos). Corregido en `src/superbg/` y en
  `aura-bg` de `social.typ` con `.replace("−", "-")` antes de `bytes()`.
- **Fraunces variable** trae una itálica «wonky» (l y d enroscadas) que a
  tamaño grande se lee rara; para itálicas grandes usar el corte estático
  «Fraunces 72pt».
- **`ajustar()` y grillas.** No llamarla en una celda con `align: horizon`:
  la grilla mide esa fila con alto infinito y el bucle no termina.
- **El `;` que desaparece.** Un `;` pegado tras `#func(..)[..]` no se
  imprime; usar `#[;]`.
- **IM FELL no es variable:** pedirle pesos no hace nada.
