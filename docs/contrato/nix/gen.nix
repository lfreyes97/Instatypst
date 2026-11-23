# Nix → Typst: genera el módulo de contrato de cada preset a partir de contract.nix.
#   nix eval --raw --extra-experimental-features nix-command -f gen.nix swiss > swiss-contrato.typ
#   nix eval --json --extra-experimental-features nix-command -f contract.nix presets.swiss > swiss-contrato.json
# Lo generado valida; no dibuja. El dibujo sigue escrito a mano (swiss-compuesto.typ).
let
  c = import ./contract.nix;
  join = builtins.concatStringsSep;
  names = builtins.attrNames;
  len = builtins.length;
  q = s: "\"" + s + "\"";
  # array de Typst con coma final si tiene un solo elemento: ("a",)
  tarr = l: "(" + join ", " (map q l) + (if len l == 1 then ",)" else ")");
  # array de tipos Typst sin comillas: (str,), (array, dictionary)
  tarrT = l: "(" + join ", " l + (if len l == 1 then ",)" else ")");
  isT = t: if t == "auto" then "v == auto" else if t == "none" then "v == none" else "std.type(v) == ${t}";

  checks = pre: n: p: join "\n" (builtins.filter (s: s != "") [
    "#let _chk-${n}(v) = {"
    "  assert(${join " or " (map isT p.types)},"
    "    message: \"${pre}: `${n}` debe ser ${join " | " p.types}, no \" + repr(v))"
    (if p ? enum then
      "  if std.type(v) == str { assert(v in ${tarr p.enum},\n    message: \"${pre}: `${n}` debe ser uno de ${join ", " p.enum}, no \" + repr(v)) }"
     else "")
    (if p ? min then
      "  if std.type(v) == int { assert(v >= ${toString p.min}, message: \"${pre}: `${n}` debe ser >= ${toString p.min}, no \" + repr(v)) }"
     else "")
    (if p ? keys then join "\n" [
      "  if std.type(v) == dictionary {"
      # tipos reales, no sus nombres: str(type("a")) es "string", no "str"
      "    let allowed = (${join ", " (map (k: "${k}: ${tarrT p.keys.${k}}") (names p.keys))})"
      "    for (k, x) in v {"
      "      assert(k in allowed, message: \"${pre}: `${n}` no tiene la clave \" + repr(k) + \" (claves: ${join ", " (names p.keys)})\")"
      "      assert(std.type(x) in allowed.at(k), message: \"${pre}: `${n}.\" + k + \"` debe ser \" + allowed.at(k).map(repr).join(\" | \") + \", no \" + repr(x))"
      "    }"
      (if p ? medium then join "\n" [
        "    if \"medium\" in v { assert(v.medium in ${tarr p.medium}, message: \"${pre}: `${n}.medium` debe ser uno de ${join ", " p.medium}, no \" + repr(v.medium)) }"
        "    if \"size\" in v { assert(v.size.len() == 2 and v.size.all(s => (std.type(s) in (int, float) and s > 0) or (std.type(s) == length and s > 0pt)),"
        "      message: \"${pre}: `${n}.size` es (ancho, alto) positivos, no \" + repr(v.size)) }"
      ] else "")
      "  }"
    ] else "")
    "}"
  ]);

  # literal Typst de los metadatos (para documentación, MCP, índice de recursos)
  esc = s: builtins.replaceStrings [ "\"" ] [ "\\\"" ] s;
  paramMeta = n: p: "${n}: (types: ${tarr p.types}, default: ${q (esc p.default)}, doc: ${q (esc p.doc)})";
  partMeta = n: p: "${n}: (types: ${tarr p.types}, required: ${if p.required then "true" else "false"}, draws: ${q (esc p.draws)})";

  emit = name: pr: let ps = pr.params; pn = names ps; parts = pr.parts; in join "\n" [
    "// GENERADO por integracion/gen.nix desde contract.nix. No editar a mano."
    "// Preset `${name}`: ${pr.doc}"
    ""
    (join "\n\n" (map (n: checks name n ps.${n}) pn))
    ""
    "/// El contrato como datos: para documentación, un servidor MCP o el índice de recursos."
    "#let ${name}-contract = ("
    "  params: (${join ", " (map (n: paramMeta n ps.${n}) pn)}),"
    "  parts: (${join ", " (map (n: partMeta n parts.${n}) (names parts))}),"
    "  layers: ${tarr (map (l: l.name) pr.layers)},"
    ")"
    ""
    "/// Valores por defecto (literales Typst del contrato)."
    "#let ${name}-defaults = (${join ", " (map (n: "${n}: ${ps.${n}.default}") pn)})"
    ""
    "/// Valida los argumentos con nombre, rechaza los desconocidos y completa los que faltan."
    "#let ${name}-args(..args) = {"
    "  assert(args.pos().len() == 0, message: \"${name}: solo admite argumentos con nombre\")"
    "  let given = args.named()"
    "  for k in given.keys() {"
    "    assert(k in ${name}-defaults, message: \"${name}: argumento desconocido \" + repr(k) + \" (hay: ${join ", " pn})\")"
    "  }"
    "  let out = ${name}-defaults + given"
    (join "\n" (map (n: "  _chk-${n}(out.${n})") pn))
    "  out"
    "}"
    ""
    "/// Comprueba los hijos leídos del cuerpo (diccionario kind => contenido, más `content`)."
    "#let ${name}-check-parts(found) = {"
    (join "\n" (map (n: let p = parts.${n}; in
      if p.required then
        "  assert(${q n} in found${if p ? fallback then " or found.at(\"content\", default: []) != []" else ""},\n    message: \"${name}: falta el hijo `${n}`${if p ? fallback then " (o contenido suelto)" else ""}\")"
      else "") (names parts)))
    "  found"
    "}"
    ""
  ];
in builtins.mapAttrs emit c.presets
