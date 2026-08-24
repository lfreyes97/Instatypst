// ─────────────────────────────────────────────────────────────
//  instatypst — punto de entrada del paquete
//
//  #import "@local/instatypst:0.1.0": *
//  (o, sin instalar el paquete: #import "src/lib.typ": *)
//
//  Trae todo lo público del sistema:
//    theme        -> API de temas (theme.typ)
//    palettes     -> biblioteca de paletas de color (palettes.typ)
//    pairings     -> biblioteca de parejas tipográficas (font-pairings.typ)
//    color-tokens.tokens / .token(key)  -> registro de color (tokens.typ)
//    font-tokens.tokens / .family(key)  -> registro de tipografía (font-tokens.typ)
//    capitular    -> letra capital automática (dropcaps.typ)
//    articulo, primer-parrafo, make-theme, fondo-editorial -> plantilla editorial (articulo.typ)
//    scripture, vs, ch, pasaje -> bloques de cita bíblica (scripture.typ)
//    + todo lo de social.typ: canvas, badge, headline, subhead, footer,
//      quote-post, announce-post, tip-card, carousel-*, stat-card,
//      testimonial-post, event-post, poll-story, versus-post,
//      blockquote-*, avatar, avatar-row, stat, progress, divider…
//
//  `color-tokens`/`font-tokens` van con nombre en vez de `import: *` a
//  propósito — ambos módulos exportan un dict llamado `tokens` con
//  significados distintos (colores vs. fuentes); aplanarlos de golpe
//  colisionaría.
//  ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "tokens.typ" as color-tokens
#import "palettes.typ": palettes
#import "font-tokens.typ" as font-tokens
#import "font-pairings.typ": pairings
#import "dropcaps.typ": capitular
#import "articulo.typ": articulo, primer-parrafo, make-theme, fondo-editorial
#import "scripture.typ": scripture, vs, ch, pasaje
#import "social.typ": *
