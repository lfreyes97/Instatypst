"""Compilación de referencia del lado V2 — fase 2, aún sin presets portados.

Igual interfaz que en ../Walltypst para que ambos lados se compilen con los
mismos parámetros. Las rutas se derivan de la posición del script: no hay
rutas absolutas escritas ni números escondidos.

Uso:
  python3 harness/referencias.py --w 1920 --h 1080 --seed 1 --now 2026-11-19T09:48 [preset…]
"""
import argparse
import hashlib
import subprocess
import tomllib
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
LAB = HERE.parent
REPO = HERE.parents[1]
MOTOR = HERE / "src" / "wall.typ"
PRESETS = LAB / "Walltypst" / "presets"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--w", type=int, required=True, help="ancho del artboard, de render.sh")
    ap.add_argument("--h", type=int, required=True, help="alto del artboard, de render.sh")
    ap.add_argument("--seed", required=True, help="mismo parámetro que en WallTypst")
    ap.add_argument("--now", required=True, help="mismo parámetro que en WallTypst")
    ap.add_argument("presets", nargs="*")
    a = ap.parse_args()

    todos = sorted(p.stem for p in PRESETS.glob("*.toml"))
    nombres = a.presets or todos
    outdir = HERE / "out" / "ref"
    outdir.mkdir(parents=True, exist_ok=True)

    manifest, fallos = [], []
    for nombre in nombres:
        toml = PRESETS / f"{nombre}.toml"
        if not toml.exists():
            fallos.append((nombre, "no existe el TOML"))
            continue
        muestras = tomllib.loads(toml.read_text()).get("muestras", ["data/largo.json", "data/corto.json"])
        muestra = muestras[0] if muestras else ""

        cmd = ["typst", "compile", "--root", str(REPO),
               "--input", f"preset=/.labs/Walltypst/presets/{nombre}.toml",
               "--input", f"w={a.w}", "--input", f"h={a.h}",
               "--input", f"seed={a.seed}", "--input", f"now={a.now}"]
        if muestra:
            cmd += ["--input", f"data=/.labs/Walltypst/{muestra}"]

        destino = outdir / f"{nombre}.svg"
        r = subprocess.run(cmd + ["--format", "svg", str(MOTOR), str(destino)],
                           capture_output=True, text=True)
        if r.returncode:
            fallos.append((nombre, r.stderr.strip().splitlines()[-1] if r.stderr.strip() else "error"))
            destino.unlink(missing_ok=True)
            continue
        manifest.append((nombre, hashlib.sha256(destino.read_bytes()).hexdigest()))

    (HERE / "referencias.sha256").write_text("".join(f"{h}  {n}.svg\n" for n, h in manifest))
    print(f"{len(manifest)}/{len(nombres)} compilados -> {outdir}")
    for nombre, motivo in fallos:
        print(f"  FALLO {nombre}: {motivo[:140]}")


if __name__ == "__main__":
    main()
