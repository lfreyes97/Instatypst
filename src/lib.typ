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
//      testimonial-post, event-post, poll-story, versus-post, quote-social,
//      avatar, avatar-row, stat, progress, divider…
//    + todo lo de blockquotes.typ: blockquote-*, bq-frame/bq-mark/bq-rule/
//      bq-attribution (sistema de legos para citas, ver ese archivo)
//    + todo lo de carrusel.typ: carrusel-slide, carrusel-slide-definicion,
//      topbar, pie-carrusel, dots, numeral-fondo, referencia-carrusel
//      (legos + motor para carrusel de Instagram, ver ese archivo — NO
//      automático, vos seguís armando cada slide a mano)
//    formas.bocadillo -> formas dibujadas con SVG embebido (formas.typ) —
//      namespace, no función suelta: "bocadillo" es una geometría entre
//      varias futuras, no el nombre del sistema. Feature nueva, todavía
//      sin blockquote-* que la use (ver ese archivo)
//
//  `color-tokens`/`font-tokens`/`formas` van con nombre en vez de
//  `import: *` a propósito. `color-tokens`/`font-tokens`: ambos módulos
//  exportan un dict llamado `tokens` con significados distintos (colores
//  vs. fuentes); aplanarlos de golpe colisionaría. `formas`: es un
//  namespace de geometrías (formas.bocadillo, y a futuro formas.circulo,
//  formas.cinta...) — aplanarlo escondería que todas viven bajo el mismo
//  sistema.
//  ─────────────────────────────────────────────────────────────

#import "theme.typ": theme
#import "tokens.typ" as color-tokens
#import "palettes.typ": palettes
#import "font-tokens.typ" as font-tokens
#import "font-pairings.typ": pairings
#import "dropcaps.typ": capitular
#import "articulo.typ": articulo, primer-parrafo, make-theme, fondo-editorial
#import "scripture.typ": scripture, vs, ch, pasaje
#import "idiomas.typ": lat, gr, he, translit, interlineal, orn
#import "formas.typ" as formas
#import "social.typ": *
#import "blockquotes.typ": *
#import "carrusel.typ": *
