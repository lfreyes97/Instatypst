// Derivado de superpelettes/lib/lib.typ (21 nov 2026); Fase 1 de WIP-color: proveedores tw4, rx, oc.
// superpelettes — punto de entrada del paquete.
//
//   #import "@local/superpelettes:0.1.0": *
//
// API unificada (lib/core.typ):
//   providers, families, steps, palette-get, palette-family,
//   new-mix, new-ramp, auto-roles
// Rampas OKLCH (lib/ramp.typ):
//   ramp, scale-from-color, hue-chroma-of, default-steps
// Contraste WCAG (lib/contrast.typ):
//   luminance, contrast, is-aa, is-aaa, readable-on,
//   auto-pair, auto-pair-tinted
// Previsualización (lib/preview.typ):
//   swatch, swatches, ramp-row, family-grid
// Derivadores explícitos de rampas de n pasos (lib/derive.typ, migrado de WIP-color):
//   op-ramp (Open Props v2 beta, 16 pasos; croma 1 por defecto), op1-ramp, op1-gray-ramp, op-hues,
//   anchored-ramp, gamut-ramp, contrast-ramp (WCAG; APCA temporal), shape-ramp
// Matemática de color (lib/color-math.typ):
//   oklch-linear, in-gamut, max-chroma, lch, de-ok, lstar, lrv, apca (TEMPORAL: ver LICENSE-apca)
// Verificadores con interfaz común (lib/verify.typ), como `palettes.verify`:
//   wcag, delta-l-star, delta-l-oklab, lrv-diff, apca, delta-e, gamut; check, for-medium, theme, failures, assert-ok, format
// Proveedores como namespaces (no se exportan planos porque todos
// tienen `get`/`family`/`families`/`steps`):
//   palettes.tw4.get("blue", 500)   palettes.rx.get("tomato", 9, variant: "dark")   palettes.oc.get("grape", 5)

#import "core.typ": providers, families, steps, palette-get, palette-family, new-mix, new-ramp, auto-roles
#import "ramp.typ": ramp, scale-from-color, hue-chroma-of, default-steps
#import "contrast.typ": luminance, contrast, is-aa, is-aaa, readable-on, auto-pair, auto-pair-tinted
#import "preview.typ": swatch, swatches, ramp-row, family-grid
#import "derive.typ": op-ramp, op1-ramp, op1-gray-ramp, op-hues, anchored-ramp, gamut-ramp, contrast-ramp, shape-ramp
#import "color-math.typ": oklch-linear, in-gamut, max-chroma, lch, de-ok, apca, lstar, lrv
#import "verify.typ" as verify
#import "vendors/tw4.typ" as tw4
#import "vendors/rx.typ" as rx
#import "vendors/oc.typ" as oc
