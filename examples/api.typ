#import "../src/lib.typ": *

// ===== 1. Definir un tema de marca (deriva del tema base) =====
#let marca = (theme.define)("mi-marca", colors: (
  primary: rgb("#0EA5E9"),
  secondary: rgb("#14B8A6"),
  accent: rgb("#F97316"),
  dark: rgb("#0F172A"),
))

// ===== 2. Derivar variantes sin mutar el original =====
#let marca-alt = (theme.with-color)(marca, "primary", rgb("#8B5CF6"))
#let marca-display = (theme.with-font)(marca, "display", "Outfit")

// ===== 3. Consultas a la API =====
#set page(width: auto, height: auto, margin: 24pt)
#set text(size: 11pt, font: (theme.font)("body", t: marca))

#block(width: 340pt, inset: 14pt, fill: (theme.color)("light", t: marca), radius: 10pt)[
  #table(
    columns: (auto, auto),
    stroke: none,
    inset: (y: 4pt),
    text(weight: "bold")[Tema], repr(marca.name),
    text(weight: "bold")[Primary],
    box(circle(radius: 5pt, fill: (theme.color)("primary", t: marca))) + h(6pt) + (theme.color)("primary", t: marca).to-hex(),
    text(weight: "bold")[Accent (derivado)],
    box(circle(radius: 5pt, fill: (theme.color)("accent", t: marca))) + h(6pt) + (theme.color)("accent", t: marca).to-hex(),
    text(weight: "bold")[Display],
    (theme.font)("display", t: marca-display).first(),
    text(weight: "bold")[Contraste dark/light],
    str(calc.round((theme.contrast)((theme.color)("dark", t: marca), (theme.color)("light", t: marca)), digits: 2)) + " · AA: " + if (theme.is-aa)((theme.color)("dark", t: marca), (theme.color)("light", t: marca)) { "sí" } else { "no" },
    text(weight: "bold")[Texto legible sobre primary],
    if (theme.readable-on)((theme.color)("primary", t: marca), white, black) == white { "blanco" } else { "negro" },
  )
]

// El original nunca cambió:
- primary de \`marca\`: (#theme.color)("primary", t: marca).to-hex()
- primary de \`marca-alt\`: (#theme.color)("primary", t: marca-alt).to-hex()

// ===== 4. Usar el tema con las plantillas — pásalo explícito con `theme:` =====
// (sombrear `palette`/`fonts` como en versiones viejas de este ejemplo NO
// funciona: las funciones de social.typ resuelven esos nombres por closure
// contra su propio archivo, no contra lo que reasignes aquí — ver la nota
// al inicio de src/social.typ.)
#announce-post(
  "NUEVO",
  [Temas gestionados por la API],
  [Todos los colores y fuentes salen de tu tema, no de valores fijos.],
  "@mi_marca",
  theme: marca,
)
