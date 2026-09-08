#!/usr/bin/env python3
"""Catálogo de ornamentos — escanea Fonts/ en busca de glifos ornamentales
(fleurons, florones, asterismos, estrellas, asteriscos, copos, destellos,
corazones, comillas ornamentadas, paréntesis ornamentados, cruces, manos,
flechas y hojas ornamentales) y vuelca el resultado a ornamentos.json.

Agrupa por carpeta de Fonts/ (=familia lógica). Para cada glifo registra la
cara (nombre de familia + estilo) que Typst resuelve y que de verdad contiene
el glifo — verificado contra `typst fonts --variants --font-path Fonts` y
`fc-scan --format %{charset}`.

Uso:
  python3 ornamentos/catalogar-ornamentos.py [ruta/Fonts] [salida.json]
"""

import json
import os
import re
import subprocess
import sys

FONT_EXT = (".ttf", ".otf")


def parse_typst_fonts(fonts_dir: str) -> dict[str, dict]:
    """(path -> {familia, estilo}) solo para archivos dentro de fonts_dir."""
    out = subprocess.run(
        ["typst", "fonts", "--variants", "--font-path", fonts_dir],
        capture_output=True, text=True, check=True,
    ).stdout
    faces: dict[str, dict] = {}
    familia = None
    for linea in out.splitlines():
        m = re.match(r"^([^ ].*)$", linea)
        if m and not linea.startswith(" "):
            familia = m.group(1).strip()
            continue
        pm = re.search(r"(\S+\.(?:ttf|otf))(?:\s*\(Variable\))?$", linea.strip())
        if pm and familia:
            path = pm.group(1)
            if not path.startswith("/") or not path.startswith(fonts_dir):
                # rutas relativas no — normalizamos abso
                pass
            real = path if os.path.isabs(path) else os.path.join(fonts_dir, path)
            real = os.path.abspath(real)
            if real.startswith(os.path.abspath(fonts_dir)):
                sm = re.search(r"Style:\s*([A-Za-z]+)", linea.split("Style:", 1)[1]) if "Style:" in linea else None
                estilo = sm.group(1).lower() if sm else "normal"
                faces.setdefault(real, {"familia": familia, "estilo": estilo})
    return faces


def fc_scan(path: str) -> set[int]:
    try:
        ch = subprocess.run(
            ["fc-scan", "--format", "%{charset}", path],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except subprocess.CalledProcessError:
        return set()
    cps = set()
    for tok in ch.split():
        try:
            if "-" in tok:
                a, b = tok.split("-", 1)
                lo, hi = int(a, 16), int(b, 16)
                if lo <= hi:
                    cps.update(range(lo, hi + 1))
            else:
                cps.add(int(tok, 16))
        except ValueError:
            continue
    return cps


# ── Puntos de código ornamentales y su nombre en castellano ───────────────
ORN: list[tuple[int, str, str]] = [
    (0x2042, "asterismo", "asterismo"),
    (0x2605, "estrella", "estrella negra"),
    (0x2606, "estrella", "estrella blanca"),
    (0x2618, "hoja", "trébol"),
    (0x2619, "fleuron", "giraldilla (fleurón)"),
]
# Manos indicadoras (U+261A–U+261F)
for cp in range(0x261A, 0x2620):
    ORN.append((cp, "mano", f"mano índice"))

CRUCES = {
    0x271D: "cruz latina", 0x271E: "cruz latina blanca sombreada",
    0x271F: "cruz delineada", 0x2720: "cruz de Malta",
    0x2721: "estrella de David",
    0x2722: "asterisco de cuatro láminas", 0x2723: "asterisco de cuatro globos",
    0x2724: "asterisco pesado de cuatro globos",
    0x2725: "asterisco pesado de cuatro láminas",
}
for cp, nombre in CRUCES.items():
    ORN.append((cp, "cruz", nombre))

ESTRELLAS = {
    0x2726: "estrella de cuatro puntas",
    0x2727: "estrella negra de cuatro puntas",
    0x2728: "destellos",
    0x2729: "estrella blanca de centro negro",
    0x272A: "estrella blanca rodeada",
    0x272B: "estrella negra de centro abierto",
    0x272C: "estrella blanca de centro negro",
    0x272D: "estrella negra delineada",
    0x272E: "estrella negra delineada pesada",
    0x272F: "estrella de molinete",
    0x2730: "estrella blanca sombreada",
    0x2731: "asterisco pesado",
    0x2732: "asterisco de centro abierto",
    0x2733: "asterisco de ocho radios",
    0x2734: "estrella negra de ocho puntas",
    0x2735: "estrella de molinete de ocho puntas",
    0x2736: "estrella negra de seis puntas",
    0x2737: "estrella negra de ocho puntas rectilínea",
    0x2738: "estrella rectilínea pesada de ocho puntas",
    0x2739: "estrella negra de doce puntas",
    0x273A: "asterisco de dieciséis puntas",
    0x273B: "asterisco de radios en lágrima",
    0x273C: "asterisco de radios en lágrima de centro abierto",
    0x273D: "asterisco de molinete de lágrimas pesado",
    0x273E: "florete de seis pétalos",
    0x273F: "flor negra",
    0x2740: "flor blanca",
    0x2741: "flor negra delineada de ocho pétalos",
    0x2742: "estrella de ocho puntas de centro abierto rodeado",
    0x2743: "asterisco pesado de radios en lágrima",
    0x2744: "copo de nieve",
    0x2745: "copo de nieve trifoliado compacto",
    0x2746: "copo de nieve de cheurón pesado",
    0x2747: "destello",
    0x2748: "destello pesado",
    0x2749: "destello de papeleta",
    0x274A: "asterisco de ocho radios",
    0x274B: "asterisco pesado de ocho radios",
}
for cp, nombre in ESTRELLAS.items():
    cat = ("copo" if cp in (0x2744, 0x2745, 0x2746) else
           "destello" if cp in (0x2728, 0x2747, 0x2748, 0x2749) else
           "flor" if cp in (0x273E, 0x273F, 0x2740, 0x2741) else "estrella")
    ORN.append((cp, cat, nombre))

for cp, nombre in {
    0x274C: "tacha",
    0x274D: "círculo blanco sombreado",
    0x2753: "interrogación ornamentada",
    0x2754: "interrogación blanca ornamentada",
    0x2755: "exclamación blanca ornamentada",
    0x2757: "exclamación pesada",
}.items():
    ORN.append((cp, "sello", nombre))

for cp in range(0x275D, 0x2761):
    ORN.append((cp, "cita", "comilla ornamentada"))
for cp in range(0x2761, 0x2764):
    ORN.append((cp, "puntuacion", "puntuación ornamentada"))
ORN += [
    (0x2763, "corazon", "corazón de exclamación pesado"),
    (0x2764, "corazon", "corazón pesado"),
    (0x2765, "corazon", "corazón pesado rotado"),
    (0x2766, "fleuron", "hedera (floral heart)"),
    (0x2767, "fleuron", "hedera rotada (floral heart)"),
]
for cp in range(0x2768, 0x2776):
    ORN.append((cp, "paren", "paréntesis ornamentado"))

FLECHAS = {
    0x2794: "flecha pesada ancha hacia la derecha",
    0x27A1: "flecha pesada hacia la derecha",
    0x27BF: "doble bucle",
}
for cp in range(0x2794, 0x27C0):
    ORN.append((cp, "flecha", FLECHAS.get(cp, "flecha ornamentada")))

for cp in range(0x1F650, 0x1F680):
    ORN.append((cp, "hoja", "hoja ornamental"))

ORNS = {cp: (categoria, nombre) for cp, categoria, nombre in ORN}
# se llena en tiempo de escaneo con las letras/dígitos reales que sí trae
# cada fuente en ALFABETO_DINGBAT_FAMILIAS (ver alfabeto_extra más abajo)
ORNS_EXTRA: dict[int, tuple[str, str]] = {}

CAT_LABEL = {
    "asterismo": "Asterismo", "fleuron": "Fleurón", "hoja": "Hoja",
    "estrella": "Estrella", "mano": "Mano", "cruz": "Cruz",
    "copo": "Copo de nieve", "destello": "Destello", "flor": "Flor",
    "sello": "Sello", "cita": "Comilla ornamentada",
    "puntuacion": "Puntuación ornamentada", "corazon": "Corazón",
    "paren": "Paréntesis ornamentado", "flecha": "Flecha",
    "alfabeto": "Floritura alfabética",
}

# ── Fuentes "alfabeto-dingbat": cada letra/dígito ASCII mapea a una
# floritura distinta (no a texto legible) — ver font-tokens.typ, token
# "orments". fc-scan por sí solo NO puede distinguir esto de una fuente de
# texto normal que también cubre a-z/A-Z/0-9 (todas lo hacen), así que la
# lista es explícita por nombre de familia, no automática. Si algún día
# metes otra fuente de este tipo (Fonts/<algo>.otf con floritura por
# letra), añade su familia real (la que resuelve `typst fonts --variants`)
# aquí para que este escáner también la catalogue.
ALFABETO_DINGBAT_FAMILIAS = {"Orments"}


def alfabeto_extra(cps_reales: set[int]) -> dict[int, tuple[str, str]]:
    """codepoints ASCII (0-9, A-Z, a-z) realmente presentes en la fuente,
    catalogados como categoría "alfabeto" — solo se llama para fuentes en
    ALFABETO_DINGBAT_FAMILIAS."""
    extra: dict[int, tuple[str, str]] = {}
    for lo, hi in ((0x30, 0x3A), (0x41, 0x5B), (0x61, 0x7B)):
        for cp in range(lo, hi):
            if cp in cps_reales:
                extra[cp] = ("alfabeto", f"floritura «{chr(cp)}»")
    return extra


def main() -> None:
    aqui = os.path.dirname(os.path.abspath(__file__))  # ornamentos/
    actual = os.path.dirname(aqui)  # raíz del repo
    fonts_dir = os.path.abspath(sys.argv[1]) if len(sys.argv) > 1 else os.path.join(actual, "Fonts")
    salida = os.path.join(actual, sys.argv[2]) if len(sys.argv) > 2 else os.path.join(aqui, "ornamentos.json")

    faces = parse_typst_fonts(fonts_dir)

    # (dir -> {"familias": {family: {file, estilo, cps}}, "union": set})
    dirs: dict[str, dict] = {}
    for root, _, files in os.walk(fonts_dir):
        for f in files:
            if not f.lower().endswith(FONT_EXT):
                continue
            full = os.path.join(root, f)
            fam = os.path.relpath(root, fonts_dir)
            if fam.endswith("/static"):
                fam = fam[:-len("/static")]
            info = dirs.setdefault(fam, {"familias": {}, "union": set()})
            cps_reales = fc_scan(full)
            face = faces.get(full, {"familia": "", "estilo": "normal"})
            fkey = face["familia"] or fam
            registro = info["familias"].setdefault(
                fkey, {"file": full, "estilo": face["estilo"], "cps": set()})
            seleccion = cps_reales & set(ORNS)
            if fkey in ALFABETO_DINGBAT_FAMILIAS:
                extra = alfabeto_extra(cps_reales)
                ORNS_EXTRA.update(extra)
                seleccion |= set(extra)
            registro["cps"] |= seleccion
            info["union"] |= seleccion

    datos = []
    for carpeta, info in sorted(dirs.items()):
        if not info["union"]:
            continue
        # Cara canónica: la familia simple (sin calificador de peso) o la primera
        familias = sorted(info["familias"], key=lambda f: (len(f), f))
        preferido = min(familias, key=lambda f: (len(f), f))

        glifos = []
        for cp in sorted(info["union"]):
            # cara que contiene el glifo: normal primero, luego italic
            portadores = [k for k, v in info["familias"].items() if cp in v["cps"]]
            portadores = [k for k in portadores if k == preferido] or portadores
            # preferir estilo normal
            portadores.sort(key=lambda k: 0 if info["familias"][k]["estilo"] == "normal" else 1)
            cara = info["familias"][portadores[0]]
            categoria, nombre = ORNS.get(cp) or ORNS_EXTRA[cp]
            glifos.append({
                "cp": cp,
                "hex": f"{cp:04X}",
                "categoria": categoria,
                "nombre": nombre,
                "cara": portadores[0],
                "estilo": cara["estilo"],
            })
        datos.append({
            "carpeta": carpeta,
            "familia": preferido,
            "glifos": glifos,
        })

    with open(salida, "w", encoding="utf-8") as fh:
        json.dump({"familias": datos}, fh, ensure_ascii=False, indent=1)

    print(f"{len(datos)} familias con ornamentos → {salida}")
    for d in datos:
        cats = {}
        for g in d["glifos"]:
            cats[g["categoria"]] = cats.get(g["categoria"], 0) + 1
        resume = " · ".join(f"{CAT_LABEL[k]} {v}" for k, v in sorted(cats.items()))
        print(f"  {d['carpeta']:<34} {len(d['glifos']):>3} — {resume}")


if __name__ == "__main__":
    main()