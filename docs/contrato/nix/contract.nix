# Contrato del preset `swiss`: única fuente de verdad (sistema-opus, integración).
#
# Diferencias con referencia/core/nix-exp/contract.nix:
#   · los tipos salen de lo que v2/swiss.typ ACEPTA de verdad (theme también es auto o
#     diccionario; brand también es función), no de una lista escrita a parte;
#   · además del tipo: enumeraciones, rangos, longitud de arrays y claves de diccionario;
#   · los hijos de contenido (parts) son parte del contrato, con su regla de lectura;
#   · cada parte dice qué recurso de sistema-opus la dibuja (para el índice de recursos).
#
# Tipos: nombres EXACTOS de Typst (std.type(v) == <tipo>), más "auto" y "none" como valores.
{
  presets.swiss = {
    doc = "Remate enorme abajo a todo lo ancho, sobre retícula de 6 columnas visible.";

    # Argumentos comunes de frame que este preset usa.
    params = {
      artboard = {
        types = [ "str" "dictionary" ];
        default = ''"feed-portrait"'';
        enum = [ "feed-portrait" "feed-square" "story" "slide" "wallpaper-uhd" ];   # si es str
        keys = { size = [ "array" ]; medium = [ "str" ]; };                          # si es dictionary
        medium = [ "print" "screen" "wallpaper" ];
        doc = "Tamaño y destino del lienzo.";
      };
      variant = {
        types = [ "str" ];
        default = ''"lines"'';
        enum = [ "lines" "cells" "shifted" "baseline" ];
        doc = "Modo de la retícula visible (las cuatro variantes vistas en los carteles).";
      };
      theme = {
        types = [ "auto" "str" "dictionary" ];
        default = "auto";
        enum = [ "suizo" "lamina" ];
        keys = { background = [ "color" ]; ink = [ "color" ]; muted = [ "color" ];
                 accent = [ "color" ]; rule = [ "color" ]; };
        doc = "Colores: auto = el del preset; nombre del registro; o roles sueltos.";
      };
      accent = { types = [ "auto" "color" ]; default = "auto"; doc = "Color del remate y la flecha."; };
      brand = {
        types = [ "none" "content" "str" "function" ];
        default = "none";
        doc = "Marca del pie: contenido o función (color, lienzo) => contenido.";
      };
      author = { types = [ "none" "content" "str" ]; default = "none"; doc = "Cabecera, izquierda."; };
      dates  = { types = [ "none" "content" "str" ]; default = "none"; doc = "Cabecera, columna 4."; };
      repeat = {
        types = [ "none" "int" "array" ];
        default = "none";
        min = 1;                                  # si es int
        doc = "Una lámina por elemento; el cuerpo pasa a ser una función item => contenido.";
      };
    };

    # Hijos del cuerpo. rule: cómo se leen (parts.typ): anidados se aplanan, gana el último,
    # el contenido suelto cae en `fallback`.
    parts = {
      statement = { types = [ "content" ]; required = true;  fallback = true; draws = "fitted(role: prose, fit: height) en flow.fill"; };
      headline  = { types = [ "content" ]; required = true;  draws = "fitted(role: headline, fit: width) en flow.bottom"; };
      eyebrow   = { types = [ "content" ]; required = false; draws = "kicker en flow.top"; };
      question  = { types = [ "content" ]; required = false; draws = "lede en flow.top"; };
    };

    # Capas que el preset compone, en orden, con el recurso que las dibuja.
    layers = [
      { name = "raster";  uses = "raster-guides(style: rules, extent: canvas)"; }
      { name = "header";  uses = "rule + kicker + note"; }
      { name = "flow";    uses = "flow(top, fill, bottom) + fitted + arrow"; }
      { name = "footer";  uses = "rule + brand"; }
    ];
  };
}
