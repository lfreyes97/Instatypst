#!/usr/bin/env python3
"""Batería exhaustiva de un preset de la v2: todas las combinaciones de su espacio.

Cada combinación es una página. Un desborde da error y aborta la compilación
entera, así que las tandas que fallan se parten por la mitad hasta aislar el
caso. Las fugas se miden contra un control (el mismo preset, variante y formato
con el texto «x» y nada más) en el anillo que queda fuera del área: si el texto
largo mancha ahí, hay fuga. Los casos con error y los que fugan quedan en
resultado.json.

Uso:   python3 scripts/exhaustivo.py [PRESET] [--muestra N] [--jobs N] [--ppi N]
Salida: examples/salidas/exhaustivo-v2/   (ignorada por git)

Por ahora solo `social-quote`. Agregar otro preset es una entrada en ESPACIOS:
sus ejes, qué ejes definen el control, cómo se escribe la llamada y qué fracción
del lienzo usa. Cuando exista el catálogo evaluable (DEUDA.md §2.4), los ejes
saldrán de ahí en vez de escribirse a mano.

Su par de la v1 es scripts/exhaustivo-v1.py (carteles.cita-social).
"""
import argparse
import itertools
import json
import random
import shutil
import subprocess
import time
from collections import Counter
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path

from PIL import Image, ImageChops

RAIZ = Path(__file__).resolve().parent.parent
OUT = RAIZ / "examples/salidas/exhaustivo-v2"

FORMATOS = [(1080, 1920), (1080, 1080), (1080, 1350), (1600, 900), (1200, 1200)]
TEXTOS = {
    "s": "La constancia entrena al algoritmo… y a tu #highlight[audiencia].",
    "m": "Una obra pseudónima que presenta una síntesis neoplatónica cristianizada bajo el nombre de un discípulo de los apóstoles adquiere autoridad precisamente por una identidad apostólica que no posee. Si esa obra contribuye a consolidar estructuras, es una #highlight[obra diabólica].",
    "l": "Una obra pseudónima que presenta una síntesis neoplatónica cristianizada bajo el nombre de un discípulo de los apóstoles adquiere autoridad precisamente por una identidad apostólica que no posee. Si esa obra contribuye posteriormente a consolidar determinadas estructuras metafísicas de la teología y liturgia medieval, uno puede describir teológicamente esa falsificación como una #highlight[obra diabólica]: no porque podamos demostrar la agencia personal del diablo, sino porque el mecanismo es exactamente el tipo de engaño que la teología cristiana atribuye a Satanás. Y aun así la pregunta sigue en pie: ¿qué hace que una autoridad prestada pese más que una verdad evidente? La respuesta, dicen, está en el prestigio acumulado de siglos de lectura reverente.",
}
AUTOR = "Luis Felipe Reyes de los Reyes"


# ── social-quote ─────────────────────────────────────────────

CAMPOS_SQ = (
    'handle: "@luisreyes", verified: true, date: "5 nov 2026", tag: [Teología e historia], '
    "metrics: (comments: 48, shares: 1300, likes: 12000, views: 2500000), "
    "reply: (name: [Marta Gil], handle: \"@marta\", text: [¿Qué métrica usarías?])"
)


def llamada_social_quote(c, control):
    args = [
        f'variant: "{c["variant"]}"',
        f'artboard: {c["artboard"]}',
        f'style: "{c["style"]}"',
        'initials: "LR"',
        "area: 80%",
    ]
    if not control:
        if c["campos"]:
            args.append(CAMPOS_SQ)
        if c["foto"]:
            args.append("photo: foto")
        if c["comilla"]:
            args.append("quote-mark: true")
    cita = "x" if control else TEXTOS[c["texto"]]
    return (
        f'#frame(preset: "social-quote", {", ".join(args)})'
        f'[#author(position: "{c["posicion"]}")[{AUTOR}] #quote[{cita}]]'
    )


ESPACIOS = {
    "social-quote": dict(
        ejes=dict(
            variant=["classic", "post", "chat", "editorial", "paper",
                     "chalkboard", "clipping", "aura", "minimal", "underline"],
            artboard=FORMATOS,
            texto=list(TEXTOS),
            campos=[0, 1],
            foto=[0, 1],
            style=["card", "bleed", "open"],
            posicion=["bottom", "top", "side"],
            comilla=[0, 1],
        ),
        control=("variant", "artboard", "style", "posicion"),
        llamada=llamada_social_quote,
        area=0.8,
        preambulo='#let foto = read("/examples-v1/avatar.jpg", encoding: none)',
        por="variant",
    ),
}


# ── el motor ─────────────────────────────────────────────────

def compilar(esp, ppi, nombre, llamadas):
    f = OUT / f"{nombre}.typ"
    f.write_text(
        '#import "/src/lib.typ": *\n' + esp["preambulo"] + "\n" + "\n".join(llamadas) + "\n",
        encoding="utf-8",
    )
    d = OUT / nombre
    d.mkdir(exist_ok=True)
    r = subprocess.run(
        ["typst", "compile", "--root", str(RAIZ), "--font-path", str(RAIZ / "Fonts"),
         str(f), str(d / "p-{p}.png"), "--ppi", str(ppi)],
        capture_output=True, text=True, timeout=900,
    )
    return r.returncode == 0, r.stderr


def tanda(args):
    """Devuelve (casos ok con su PNG, errores)."""
    preset, ppi, nombre, casos, control = args
    esp = ESPACIOS[preset]
    errs, hecho = [], []

    def ir(lista, nom):
        ok, err = compilar(esp, ppi, nom, [esp["llamada"](c, control) for c in lista])
        if ok:
            for i, c in enumerate(lista):
                hecho.append((c, str(OUT / nom / f"p-{i + 1}.png")))
            return
        if len(lista) == 1:
            msg = [l for l in err.splitlines() if l.startswith("error")]
            errs.append((lista[0], msg[0] if msg else err[:200]))
            return
        m = len(lista) // 2
        ir(lista[:m], nom + "a")
        ir(lista[m:], nom + "b")

    ir(casos, nombre)
    return hecho, errs


def tandas(preset, ppi, lista, pref, control, n):
    return [(preset, ppi, f"{pref}{i:04d}", lista[i:i + n], control) for i in range(0, len(lista), n)]


def fuga(png, png_control, area):
    """Píxeles distintos entre el caso y su control, solo en el anillo fuera del área."""
    a = Image.open(png).convert("RGB")
    b = Image.open(png_control).convert("RGB")
    w, h = a.size
    mx, my = round(w * (1 - area) / 2) - 1, round(h * (1 - area) / 2) - 1
    diff = ImageChops.difference(a, b).convert("L").point(lambda v: 255 if v > 40 else 0)
    diff.paste(0, (mx, my, w - mx, h - my))
    return diff.histogram()[255]


def clave(esp, c):
    return tuple(str(c[k]) for k in esp["control"])


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("preset", nargs="?", default="social-quote", choices=sorted(ESPACIOS))
    ap.add_argument("--muestra", type=int, default=0, help="solo N casos al azar (semilla fija)")
    ap.add_argument("--jobs", type=int, default=4)
    ap.add_argument("--ppi", type=int, default=12)
    o = ap.parse_args()
    esp = ESPACIOS[o.preset]
    t0 = time.time()
    shutil.rmtree(OUT, ignore_errors=True)
    OUT.mkdir(parents=True)

    nombres = list(esp["ejes"])
    casos = [dict(zip(nombres, v)) for v in itertools.product(*esp["ejes"].values())]
    total = len(casos)
    if o.muestra and o.muestra < total:
        casos = random.Random(1).sample(casos, o.muestra)
    # un control por cada combinación de los ejes de control que aparece
    primero = {k: v[0] for k, v in esp["ejes"].items()}
    controles = {}
    for c in casos:
        controles.setdefault(clave(esp, c), {**primero, **{k: c[k] for k in esp["control"]}})
    controles = list(controles.values())
    print(f"{o.preset}: {len(casos)} casos de {total}, {len(controles)} controles", flush=True)

    ctl_png, errores, fugas, n = {}, [], [], 0
    with ProcessPoolExecutor(o.jobs) as ex:
        for hecho, errs in ex.map(tanda, tandas(o.preset, o.ppi, controles, "k", True, 40)):
            for c, png in hecho:
                ctl_png[clave(esp, c)] = png
            if errs:
                print("ERROR EN CONTROL", errs[:2], flush=True)
        print(f"controles listos ({time.time() - t0:.0f}s)", flush=True)

        # agrupados por formato: cada tanda tiene páginas del mismo tamaño
        trabajos = []
        for f in esp["ejes"]["artboard"]:
            lista = [c for c in casos if c["artboard"] == f]
            trabajos += tandas(o.preset, o.ppi, lista, f"c{f[0]}x{f[1]}-", False, 60)
        for hecho, errs in ex.map(tanda, trabajos):
            errores += errs
            for c, png in hecho:
                n += 1
                if (k := clave(esp, c)) in ctl_png:
                    px = fuga(png, ctl_png[k], esp["area"])
                    if px > 4:
                        fugas.append((c, px))
            if n % 600 < 60:
                print(f"  {n} medidos ({time.time() - t0:.0f}s)", flush=True)

    json.dump(
        {"preset": o.preset, "casos": len(casos), "total": total,
         "errores": [(c, m) for c, m in errores], "fugas": [(c, p) for c, p in fugas]},
        open(OUT / "resultado.json", "w"), ensure_ascii=False, indent=1,
    )
    por = esp["por"]
    print(f"FIN {time.time() - t0:.0f}s: {n} medidos, {len(errores)} con error, {len(fugas)} con fuga")
    for titulo, lista in (("error", [c for c, _ in errores]), ("fuga", [c for c, _ in fugas])):
        if lista:
            print(f"  por {por}, {titulo}:", dict(Counter(c[por] for c in lista).most_common()))
    if errores:
        for m, k in Counter(m for _, m in errores).most_common(5):
            print(f"  {k}× {m[:150]}")


if __name__ == "__main__":
    main()
