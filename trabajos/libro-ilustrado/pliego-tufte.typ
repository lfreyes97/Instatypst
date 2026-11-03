// Prueba de concepto, variante «Tufte»: la misma página del libro ilustrado, pero monocroma y con
// dibujos a lápiz, en el formato de márgenes anchos de Edward Tufte (texto estrecho a la
// izquierda; a la derecha, notas y figuras que acompañan la frase a cuya altura nacen).
// Cada nota o figura se ANCLA en la frase con `ancla(id)` (un marcador invisible en el texto) y se
// dibuja en el margen desde el primer plano de la página, a la altura exacta del ancla. Así el
// párrafo queda continuo, sin cortes.
// Cambiar el texto: texto.typ. Figuras: figuras-lapiz.typ. Trazo: lapiz.typ.
// Compilar: typst compile --root . --font-path Fonts trabajos/libro-ilustrado/pliego-tufte.typ salida/pliego-tufte.pdf
#import "figuras-lapiz.typ": finca-lapiz, memorial-lapiz, bandera-lapiz
#import "texto.typ": titulo-obra, autor

#let tinta = rgb("#1a1a1a")
#let apagado = rgb("#6b6b6b")
#let m-izq = 24mm // margen izquierdo de la página
#let texto-w = 100mm // columna de texto
#let hueco = 8mm
#let margen-w = 66mm // columna del margen
#let margen-x = m-izq + texto-w + hueco // x absoluto del margen en la página

// Marcador invisible anclado en el texto.
#let ancla(id) = [#metadata(id)<ancla>]

// Lo que se dibuja en el margen para cada ancla: lista de (dx, dy, contenido) relativos a la
// altura del ancla.
#let nota-1 = {
  set par(leading: 0.5em)
  box(width: margen-w, text(size: 8.5pt, fill: apagado)[#text(weight: 600)[1] Unos 113 km/h (setenta millas por hora).])
}
#let figuras-2-3 = {
  let k1 = 38mm / 190pt
  let k2 = 24mm / 130pt
  box(width: margen-w, {
    grid(columns: (38mm, 24mm), column-gutter: 4mm, align: bottom + left,
      scale(x: k1 * 100%, y: k1 * 100%, origin: top + left, reflow: true, memorial-lapiz()),
      scale(x: k2 * 100%, y: k2 * 100%, origin: top + left, reflow: true, bandera-lapiz()))
    v(1.5mm)
    text(size: 8.5pt, style: "italic", fill: apagado)[Figuras 2 y 3. El Memorial de Lincoln y «Old Glory».]
  })
}
#let en-margen = (
  "nota-1": (-1.5mm, nota-1),
  "figuras": (-2mm, figuras-2-3),
)

#set page(width: 210mm, height: 297mm, fill: white,
  margin: (left: m-izq, right: 12mm, top: 24mm, bottom: 24mm),
  foreground: context {
    for m in query(<ancla>) {
      let pos = m.location().position()
      if pos.page == here().page() {
        let (dy, cuerpo) = en-margen.at(m.value)
        place(top + left, dx: margen-x, dy: pos.y + dy, cuerpo)
      }
    }
  })
#set text(font: "EB Garamond 12", size: 11pt, lang: "es", fill: tinta, hyphenate: true)
#set par(justify: false, leading: 0.66em, spacing: 0.9em)

// ── Cabecera ───────────────────────────────────────────────────────
#text(size: 28pt, style: "italic", titulo-obra)
#v(-1mm)
#text(size: 10pt, tracking: 0.12em, fill: apagado)[#upper(autor)]
#v(7mm)

// ── Figura a todo el ancho ─────────────────────────────────────────
#let ancho-total = 174mm
#block(width: ancho-total, breakable: false, {
  let k = ancho-total / 500pt
  scale(x: k * 100%, y: k * 100%, origin: top + left, reflow: true, finca-lapiz())
  v(2mm)
  text(size: 8.5pt, style: "italic", fill: apagado)[Figura 1. La finca de Dios: «grandes letreros de propiedad puestos por todas partes».]
})
#v(9mm)

// ── Texto ──────────────────────────────────────────────────────────
#block(width: texto-w)[Vea usted: el mundo le pertenece a Él, y usted es su criatura y, como tal, debe reconocerlo honrándolo, ya sea que coma, que beba o que haga cualquier otra cosa. Dios dice que usted vive, por así decirlo, en su finca. Y su finca tiene grandes letreros de propiedad puestos por todas partes, de modo que quien pasa incluso a setenta millas por hora#super(text(size: 8pt, weight: 600)[1])#ancla("nota-1") no puede sino leerlos. Cada hecho de este mundo, afirma el Dios de la Biblia, tiene grabado indeleblemente su sello. ¿Cómo podría usted, entonces, ser neutral ante tal Dios? #ancla("figuras")¿Pasea usted sin prisa, un Cuatro de Julio, por Washington preguntándose si el Memorial de Lincoln pertenece a alguien? ¿Mira usted la «Old Glory» ondeando en lo alto de un asta y se pregunta si representa algo? ¿Le exige algo a usted, nacido ciudadano estadounidense como es? Merecería usted la suerte del «hombre sin patria» si, siendo estadounidense, fuera neutral hacia Estados Unidos. Pues bien, en un sentido mucho más hondo merece usted vivir para siempre sin Dios si no lo reconoce y glorifica como su Creador. […] Cuando Eva se hizo neutral entre Dios y el Diablo, sopesando las pretensiones de cada uno como si fueran, de suyo y a primera vista, de igual valor, ya estaba en realidad del lado del diablo.]
