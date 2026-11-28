// ─────────────────────────────────────────────────────────────
//  inscription.typ — el preset `inscription` (en v1, `epigrafe`)
//
//  Los 15 estilos son VARIANTES de frame, no un argumento `style:` propio:
//  la tabla de traducción dice `estilo` → `preset:style`, pero `DEUDA.md` (§1.8)
//  fija que los 15 estilos de `epigrafe` son `variant`. Aquí se corrige esa
//  desalineación semántica.
//
//  Se llama `inscription` y no `epigraph` porque `epigraph` es el elemento de la
//  cita (`DEUDA.md` §1.5, caso 2: un preset y un elemento no comparten nombre).
//
//  Elementos del cuerpo: epigraph (la cita), author, work, brand.
//  Todos están en elements.typ y se leen por su clave.
//  Todavía no es plain + reglas: cada estilo de v1 dibuja su propia página
//  (`DEUDA.md` §3.1).
//  Argumentos: artboard, theme, variant, brand, guides.
//
//  Cada estilo es una variante en su archivo, `variants/<nombre>.typ`, que
//  exporta `variant`; lo común de cada tanda de v1 está en
//  `variants/_comun-a/b/c.typ`, y las piezas de v1 que solo usan estos estilos,
//  en `_legado/`. Todavía no es plain + reglas: cada estilo dibuja su propia
//  página (`DEUDA.md` §3.1).
// ─────────────────────────────────────────────────────────────

#import "/src/core/parts.typ": read-parts
#import "/src/modules/color/color.typ": resolve-theme
#import "/src/frame.typ": frame
#import "variants/pergamino.typ" as _pergamino
#import "variants/portada.typ" as _portada
#import "variants/lapida.typ" as _lapida
#import "variants/epistola.typ" as _epistola
#import "variants/cartela.typ" as _cartela
#import "variants/hojas.typ" as _hojas
#import "variants/bauhaus.typ" as _bauhaus
#import "variants/arcos.typ" as _arcos
#import "variants/malla.typ" as _malla
#import "variants/lineas.typ" as _lineas
#import "variants/aura.typ" as _aura
#import "variants/pizarra.typ" as _pizarra
#import "variants/vitral.typ" as _vitral
#import "variants/luto.typ" as _luto
#import "variants/amanecer.typ" as _amanecer

// Cada variante es un archivo de variants/ que exporta `variant`; el orden es el
// de v1 (tandas A, B y C).
#let estilos = (
  pergamino: _pergamino.variant,
  portada: _portada.variant,
  lapida: _lapida.variant,
  epistola: _epistola.variant,
  cartela: _cartela.variant,
  hojas: _hojas.variant,
  bauhaus: _bauhaus.variant,
  arcos: _arcos.variant,
  malla: _malla.variant,
  lineas: _lineas.variant,
  aura: _aura.variant,
  pizarra: _pizarra.variant,
  vitral: _vitral.variant,
  luto: _luto.variant,
  amanecer: _amanecer.variant,
)
#let variants = estilos.keys()

// V2 → roles del motor de v1.
#let _a-v1(tm) = (
  fondo: tm.paper,
  tinta: tm.ink,
  suave: tm.quiet,
  acento: tm.accent,
  linea: tm.guide,
)

#let _default-v2 = (
  paper: white,
  ink: black,
  quiet: luma(62%),
  accent: rgb("#c8102e"),
  guide: luma(88%),
)

#let make(
  body,
  artboard: (1080, 1350),
  theme: auto,
  brand: none,
  variant: "luto",
  guides: false,
) = {
  let estilo = if variant == auto { "luto" } else { variant }
  if estilo not in estilos {
    panic("inscription: variante desconocida " + repr(estilo) + " (hay: " + variants.join(", ") + ")")
  }

  let r = read-parts(body, known: ("epigraph", "author", "work", "brand"))
  let p = r.parts
  let cita = p.at("epigraph", default: none)
  let cita = if cita == none { r.loose } else if r.has-loose { cita.body + parbreak() + r.loose } else { cita.body }
  let autor = if "author" in p { p.author.body } else { none }
  let obra = if "work" in p { p.work.body } else { none }
  let marca = if "brand" in p { p.brand.body } else { brand }
  let tema = if theme == auto { auto } else { _a-v1(resolve-theme(theme, _default-v2, fn: "inscription")) }

  (estilos.at(estilo))(
    cita,
    autor: autor,
    obra: obra,
    formato: artboard,
    tema: tema,
    marca: marca,
    guias: guides,
  )
}

// El preset y su frame (`DEUDA.md` §1.5, caso 2): una línea, sin firma propia.
#let preset = (name: "inscription", make: make, variants: variants)
#let inscription = frame.with(preset: preset)
