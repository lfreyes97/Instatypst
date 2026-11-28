// Fase 2 — esqueleto compilable del lado V2.
//
// Lee los mismos `sys.inputs` que WallTypst, pero dibuja con `frame` + `artboard`:
// las dimensiones las gobierna el frame, no un `#set page` a mano.
//
// Todavía NO hay ningún preset portado. El cuerpo es solo una prueba de que el
// TOML se lee y se valida: se muestran los tipos de capa. No es la traducción.

#import "/src/lib.typ": frame

#let inp = sys.inputs
#let ancho = int(inp.w)
#let alto = int(inp.h)
#let d = toml(inp.preset)
#assert("layers" in d, message: "el preset no trae `layers`: " + inp.preset)

#frame(preset: "plain", artboard: (ancho, alto))[
  #for capa in d.layers [
    #capa.at("tipo", default: "?")
  ]
]
