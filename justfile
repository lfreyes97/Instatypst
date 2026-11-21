# Pruebas de equivalencia (cmp) entre las capas del rework.
# Uso:  just cmp suizo   |   just cmp-all   |   just --list
#
# Cada preset vive en examples/recetas/<preset>/ con 2 a 4 archivos (el original es obligatorio):
#   <preset>-original.typ  engine_v1: src/lib.typ (Instatypst canónico)
#   <preset>-demo.typ      port: core/recetas/<preset>.typ (sobre primitivas)
#   scaffold-demo.typ      core/scaffold.typ (contrato -> engine_v1)
#   v2-demo.typ            core/v2/ (contrato -> engine_v2, sin v1)
#
# Eslabones:
#   1. original = port       (idéntico) -> primitivas y recetas fieles a v1
#   2. original = scaffold   (idéntico) -> traducción del contrato a engine_v1
#   3. original = v2         (idéntico) -> engine_v2 reproduce a engine_v1


root := justfile_directory()
ppi  := "72"

default:
    @just --list

# Compila las cuatro variantes de un preset a PNG y compara por páginas.
cmp preset:
    #!/usr/bin/env bash
    set -u
    src="{{root}}/examples/recetas/{{preset}}"
    out="{{root}}/examples/salidas/{{preset}}"
    [ -d "$src" ] || { echo "no existe $src"; exit 2; }
    rm -rf "$out"; mkdir -p "$out"

    declare -A file=(
      [original]="{{preset}}-original.typ"
      [port]="{{preset}}-demo.typ"
      [scaffold]="scaffold-demo.typ"
      [v2]="v2-demo.typ"
    )
    [ -f "$src/${file[original]}" ] || { echo "falta $src/${file[original]}"; exit 2; }
    # variantes presentes (el original es la referencia; no todo preset tiene port y scaffold)
    var=()
    for k in port scaffold v2; do [ -f "$src/${file[$k]}" ] && var+=("$k"); done
    for k in original "${var[@]}"; do
      typst compile --root "{{root}}" --font-path "{{root}}/Fonts" --ignore-system-fonts \
        --format png --ppi {{ppi}} "$src/${file[$k]}" "$out/$k-{p}.png" \
        || { echo "FALLÓ la compilación de $k"; exit 2; }
    done

    n=$(ls "$out"/original-*.png | wc -l)
    for k in "${var[@]}"; do
      [ "$(ls "$out"/$k-*.png | wc -l)" -eq "$n" ] \
        || { echo "número de páginas distinto en $k (original: $n)"; exit 1; }
    done

    fail=0
    printf '%-7s' página; for k in "${var[@]}"; do printf '%-22s' "original = $k"; done; echo
    for p in $(seq 1 "$n"); do
      # typst numera con relleno de ceros según el total de páginas
      f() { ls "$out"/$1-*.png | sed -n "${p}p"; }
      a=$(f original)
      printf '%-7s' "$p"
      for k in "${var[@]}"; do
        r=OK; cmp -s "$a" "$(f $k)" || { r=DIFF; fail=1; }
        printf '%-22s' "$r"
      done
      echo
    done
    echo "salidas: $out"
    exit $fail

# Todos los presets que tengan carpeta en examples/recetas/.
cmp-all:
    #!/usr/bin/env bash
    fail=0
    for d in "{{root}}"/examples/recetas/*/; do
      p=$(basename "$d"); echo "== $p"
      just --justfile "{{justfile()}}" cmp "$p" || fail=1
    done
    exit $fail
