// ─────────────────────────────────────────────────────────────
//  Instatypst v2 — punto de entrada público
//
//    frame(preset:, variant:, artboard:, theme:, accent:, brand:, ..options, body)
//
//  Presets, por nombre (entre paréntesis, el nombre en v1): 22, todos los de
//  carteles menos lamina.
//    "plain" (el lienzo; su variante "post" es liso), "swiss" (suizo),
//    "inscription" (epigrafe; 15 variantes), "bauhaus", "blueprint" (plano),
//    "bands" (franjas), "proof" (demostracion), "mosaic" (mosaico), "tiles"
//    (teselas), "leaves" (hojas), "obituary" (esquela), "folio",
//    "bordered-quote", "bordered-chapter", "bordered-question" (las orlas),
//    "timeline" (linea-tiempo), "event" (evento), "contrast" (contraste), "tip"
//    (consejo), "hinge" (gozne), "stairs" (escalera) y "social-quote"
//    (cita-social; 10 variantes).
//  Cada preset exporta su frame con su nombre: el frame genérico con el preset
//  ya puesto (Spec, caso 2).
//  Elementos: los 26 de elements.typ (`quote` y `list` son los de Typst).
//
//  lib es el único que conoce todos los presets: aquí está la tabla de nombres.
//  Ningún archivo del paquete importa lib.
// ─────────────────────────────────────────────────────────────

#import "frame.typ" as _frame
#import "elements.typ": *
#import "/src/core/artboard.typ": formats
#import "/src/plain/plain.typ": plain, preset as _plain
#import "/src/presets/swiss/swiss.typ": swiss, preset as _swiss
#import "/src/presets/inscription/inscription.typ": inscription, preset as _inscription
#import "/src/presets/bauhaus/bauhaus.typ": bauhaus, preset as _bauhaus
#import "/src/presets/blueprint/blueprint.typ": blueprint, preset as _blueprint
#import "/src/presets/bands/bands.typ": bands, preset as _bands
#import "/src/presets/proof/proof.typ": proof, preset as _proof
#import "/src/presets/mosaic/mosaic.typ": mosaic, preset as _mosaic
#import "/src/presets/tiles/tiles.typ": tiles, preset as _tiles
#import "/src/presets/leaves/leaves.typ": leaves, preset as _leaves
#import "/src/presets/obituary/obituary.typ": obituary, preset as _obituary
#import "/src/presets/folio/folio.typ": folio, preset as _folio
#import "/src/presets/timeline/timeline.typ": timeline, preset as _timeline
#import "/src/presets/bordered-quote/bordered-quote.typ": bordered-quote, preset as _bordered-quote
#import "/src/presets/bordered-chapter/bordered-chapter.typ": bordered-chapter, preset as _bordered-chapter
#import "/src/presets/bordered-question/bordered-question.typ": bordered-question, preset as _bordered-question
#import "/src/presets/event/event.typ": event, preset as _event
#import "/src/presets/contrast/contrast.typ": contrast, preset as _contrast
#import "/src/presets/tip/tip.typ": tip, preset as _tip
#import "/src/presets/hinge/hinge.typ": hinge, preset as _hinge
#import "/src/presets/stairs/stairs.typ": stairs, preset as _stairs
#import "/src/presets/social-quote/social-quote.typ": social-quote, preset as _social-quote

#let _presets = (
  plain: _plain,
  swiss: _swiss,
  inscription: _inscription,
  bauhaus: _bauhaus,
  blueprint: _blueprint,
  bands: _bands,
  proof: _proof,
  mosaic: _mosaic,
  tiles: _tiles,
  leaves: _leaves,
  obituary: _obituary,
  folio: _folio,
  timeline: _timeline,
  bordered-quote: _bordered-quote,
  bordered-chapter: _bordered-chapter,
  bordered-question: _bordered-question,
  event: _event,
  contrast: _contrast,
  tip: _tip,
  hinge: _hinge,
  stairs: _stairs,
  social-quote: _social-quote,
)

// El frame público: el genérico, con los nombres resueltos. `preset: auto` es plain.
#let frame(preset: auto, ..args) = {
  let p = if preset == auto { _presets.plain } else if type(preset) == str {
    if preset not in _presets {
      panic("frame: preset desconocido " + repr(preset) + " (hay: " + _presets.keys().join(", ") + "; o pasa una función)")
    }
    _presets.at(preset)
  } else { preset }
  _frame.frame(preset: p, ..args)
}

#let version = "0.1.0"
