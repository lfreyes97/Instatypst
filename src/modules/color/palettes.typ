// ─────────────────────────────────────────────────────────────
//  lib/palettes.typ — el módulo de colores (catálogo vendor + rampas + contraste)
//
//  Es el paquete superpelettes integrado (lib/palettes/): proveedores `tw4` (Tailwind v4,
//  OKLCH), `rx` (Radix, light/dark) y `oc` (Open Color), rampas OKLCH y contraste WCAG. Se importa como
//  un solo nombre para no llenar el espacio de nombres de quien hace `import "/lib.typ": *`:
//
//    #palettes.tw4.get("blue", 500)             #palettes.contrast(a, b)
//    #palettes.new-ramp("#c8102e")              #palettes.family-grid("rx", "tomato")
//
//  Un color del catálogo se pide también por texto en cualquier campo de color
//  (`theme`, `accent`, `fill`): "tw4-blue-500", "rx-tomato-9-dark" (lib/color.typ).
// ─────────────────────────────────────────────────────────────
#import "palettes/lib.typ" as palettes
