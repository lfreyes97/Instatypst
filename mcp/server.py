#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["mcp>=1.2,<2"]
# ///
"""Servidor MCP de Instatypst.

Envoltorio delgado sobre el repo: no copia nada del paquete, lo consulta.
Paletas, plantillas y fuentes se leen en vivo; compilar usa el `typst` del sistema.
"""
from __future__ import annotations

import os
import re
import subprocess
import time
from pathlib import Path

from mcp.server.fastmcp import FastMCP

REPO = Path(__file__).resolve().parent.parent
FUENTES = REPO / "Fonts"
SALIDA = REPO / "salida" / "mcp"

# Formatos de Instagram: (ancho, alto) en pt; con --ppi 72, 1 pt = 1 px.
FORMATOS = {
    "feed-4x5": (1080, 1350),
    "feed-1x1": (1080, 1080),
    "story": (1080, 1920),
}

mcp = FastMCP("instatypst")


def _typst(*args: str, timeout: int = 600) -> subprocess.CompletedProcess:
    env = {**os.environ, "TYPST_FONT_PATHS": str(FUENTES)}
    return subprocess.run(
        ["typst", *args], capture_output=True, text=True, env=env, timeout=timeout
    )


def _slug(nombre: str) -> str:
    s = re.sub(r"[^a-zA-Z0-9_-]+", "-", nombre).strip("-")
    return s or "pieza"


def _compilar(typ: Path, salida: Path, ppi: float) -> str:
    """Compila y devuelve un informe de texto. Detecta el desborde de página."""
    salida.parent.mkdir(parents=True, exist_ok=True)
    antes = salida.stat().st_mtime if salida.exists() else 0
    t0 = time.time()
    r = _typst("compile", "--root", str(REPO), str(typ), str(salida), "--ppi", str(ppi))
    err = "\n".join(l for l in r.stderr.splitlines() if not l.startswith("instatypst:"))
    if r.returncode != 0:
        if "multiple images" in err:
            return (
                "ERROR: la pieza ocupa más de una página (el texto se desbordó). "
                "Baja el tamaño de letra o los márgenes. El PNG anterior no se actualizó."
            )
        return f"ERROR de Typst:\n{err}"
    if not salida.exists() or salida.stat().st_mtime < max(antes, t0 - 1):
        return "ERROR: Typst no devolvió error pero el PNG no se actualizó."
    try:
        from struct import unpack

        with salida.open("rb") as f:
            f.seek(16)
            w, h = unpack(">II", f.read(8))
        dim = f"{w}×{h}px"
    except Exception:
        dim = "?"
    aviso = f"\nAvisos:\n{err}" if err.strip() else ""
    return f"OK: {salida} ({dim}, {salida.stat().st_size // 1024} KB){aviso}"


# ── descubrimiento (en vivo) ─────────────────────────────────


@mcp.tool()
def ayuda() -> str:
    """Guía de uso de Instatypst (SKILL.md del repo). Léela antes de diseñar."""
    return (REPO / "SKILL.md").read_text(encoding="utf-8")


@mcp.tool()
def listar_paletas() -> str:
    """Paletas disponibles en src/palettes.typ y los tokens de color de cada una."""
    src = (REPO / "src" / "palettes.typ").read_text(encoding="utf-8")
    bloque = re.search(r"#let library = \((.*?)\n\)", src, re.S)
    if not bloque:
        return "No pude leer `library` en src/palettes.typ."
    filas = re.findall(r'"([^"]+)":\s*\((.*?)\)', bloque.group(1))
    return "\n".join(f"{n}: {t}" for n, t in filas)


@mcp.tool()
def listar_plantillas() -> str:
    """Presets de carteles y ejemplos disponibles (archivos .typ mínimos para copiar)."""
    pres = sorted(p.stem for p in (REPO / "examples" / "presets").glob("*.typ"))
    ej = sorted(p.stem for p in (REPO / "examples").glob("*.typ"))
    return f"examples/presets/: {', '.join(pres)}\nexamples/: {', '.join(ej)}"


@mcp.tool()
def ver_plantilla(nombre: str) -> str:
    """Devuelve el código de un preset o ejemplo (ej. 'liso', 'suizo') para copiarlo."""
    for base in (REPO / "examples" / "presets", REPO / "examples"):
        p = base / f"{_slug(nombre)}.typ"
        if p.exists():
            return p.read_text(encoding="utf-8")
    return f"No existe '{nombre}'. Usa listar_plantillas."


@mcp.tool()
def listar_fuentes(filtro: str = "") -> str:
    """Familias tipográficas que Typst ve con las fuentes de Instatypst. Filtro opcional."""
    r = _typst("fonts")
    fams = sorted({l.strip() for l in r.stdout.splitlines() if l.strip()})
    if filtro:
        fams = [f for f in fams if filtro.lower() in f.lower()]
    return "\n".join(fams) or "Sin coincidencias."


# ── contraste ────────────────────────────────────────────────


def _lum(hexcol: str) -> float:
    h = hexcol.lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    if not re.fullmatch(r"[0-9a-fA-F]{6}", h):
        raise ValueError(f"color inválido: {hexcol!r} (usa #RRGGBB)")
    c = [int(h[i : i + 2], 16) / 255 for i in (0, 2, 4)]
    c = [x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]


@mcp.tool()
def contraste(color_a: str, color_b: str) -> str:
    """Proporción de contraste WCAG entre dos colores #RRGGBB, con veredicto AA/AAA."""
    try:
        la, lb = _lum(color_a), _lum(color_b)
    except ValueError as e:
        return f"ERROR: {e}"
    r = (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    nivel = "AAA" if r >= 7 else "AA" if r >= 4.5 else "AA solo texto grande" if r >= 3 else "NO cumple"
    return f"{r:.1f}:1 → {nivel}"


# ── compilar ─────────────────────────────────────────────────


@mcp.tool()
def compilar(archivo: str, salida: str = "", ppi: float = 72) -> str:
    """Compila un .typ existente a PNG (una sola página).

    Para Instagram usa ppi=72 (1080pt → 1080px). Si no das `salida`, usa
    <archivo>.png junto al original. Detecta desbordes de página.
    """
    typ = Path(archivo).expanduser().resolve()
    if not typ.exists():
        return f"No existe {typ}"
    out = Path(salida).expanduser().resolve() if salida else typ.with_suffix(".png")
    return _compilar(typ, out, ppi)


@mcp.tool()
def renderizar(codigo: str, nombre: str = "pieza", ppi: float = 72) -> str:
    """Compila código Typst (con `#import "@local/instatypst:0.1.0": *`) a PNG.

    Escribe en salida/mcp/<nombre>.typ y .png dentro del repo (ignorado por git).
    """
    SALIDA.mkdir(parents=True, exist_ok=True)
    typ = SALIDA / f"{_slug(nombre)}.typ"
    typ.write_text(codigo, encoding="utf-8")
    return _compilar(typ, typ.with_suffix(".png"), ppi)


@mcp.tool()
def tarjeta_texto(
    texto: str,
    fondo: str = "#691322",
    formato: str = "feed-4x5",
    fuente: str = "EB Garamond 12",
    peso: int = 500,
    autor: str = "",
    nombre: str = "tarjeta",
) -> str:
    """Tarjeta de texto sobre fondo liso con `carteles.liso` (tamaño y tinta automáticos).

    `formato`: feed-4x5 (1080×1350, por defecto), feed-1x1 o story.
    `fondo`: #RRGGBB. La tinta se elige sola para que sea legible.
    """
    if formato not in FORMATOS:
        return f"Formato inválido. Usa: {', '.join(FORMATOS)}"
    if not re.fullmatch(r"#[0-9a-fA-F]{6}", fondo):
        return "ERROR: fondo debe ser #RRGGBB"
    w, h = FORMATOS[formato]
    esc = lambda s: s.replace("\\", "\\\\").replace('"', '\\"')
    cuerpo = f'#carteles.liso(eval("{esc(texto)}", mode: "markup"), formato: ({w}, {h}), ' \
             f'fondo: rgb("{fondo}"), fuente: "{esc(fuente)}", peso: {peso}'
    if autor:
        cuerpo += f', autor: "{esc(autor)}"'
    cuerpo += ")\n"
    codigo = '#import "@local/instatypst:0.1.0": *\n' + cuerpo
    return renderizar(codigo, nombre)


# ── desarrollo del paquete (solo lectura / compilación) ──────


def _compilar_pdf(typ: Path, tmp: Path) -> tuple[Path, bool, str]:
    out = tmp / (typ.relative_to(REPO).as_posix().replace("/", "__") + ".pdf")
    try:
        r = _typst("compile", "--root", str(REPO), str(typ), str(out), timeout=300)
    except subprocess.TimeoutExpired:
        return typ, False, "timeout (300 s)"
    if r.returncode == 0:
        return typ, True, ""
    lineas = [l for l in r.stderr.splitlines() if l.startswith("error")]
    return typ, False, lineas[0] if lineas else r.stderr.strip()[:200]


@mcp.tool()
def verificar(carpeta: str = "examples", filtro: str = "") -> str:
    """Prueba de regresión: compila los .typ de una carpeta del repo y reporta cuáles fallan.

    `carpeta`: relativa al repo (por defecto `examples`; incluye `examples/presets`).
    `filtro`: texto que debe contener el nombre del archivo. Los PDF van a un
    directorio temporal, no al repo. Las láminas pesadas pueden tardar minutos.
    """
    import tempfile
    from concurrent.futures import ThreadPoolExecutor

    base = (REPO / carpeta).resolve()
    if REPO not in base.parents and base != REPO:
        return "ERROR: la carpeta debe estar dentro del repo."
    archivos = sorted(
        p for p in base.rglob("*.typ") if not p.name.startswith("_") and filtro in p.name
    )
    if not archivos:
        return "No encontré archivos .typ."
    with tempfile.TemporaryDirectory() as t:
        with ThreadPoolExecutor(max_workers=4) as ex:
            res = list(ex.map(lambda p: _compilar_pdf(p, Path(t)), archivos))
    fallos = [(p, m) for p, ok, m in res if not ok]
    lineas = [f"{len(res) - len(fallos)}/{len(res)} compilan."]
    for p, m in fallos:
        lineas.append(f"FALLA {p.relative_to(REPO)}: {m}")
    return "\n".join(lineas)


@mcp.tool()
def auditar_paletas(minimo: float = 4.5, minimo_acento: float = 3.0) -> str:
    """Audita el contraste de los roles de cada paleta (`auto-roles`, como las usa el tema).

    Marca: (1) paletas cuyo par oscuro/claro no llega a `minimo`:1, el que se usa
    para texto sobre fondo; (2) roles primary/secondary/accent que no alcanzan
    `minimo_acento`:1 contra ninguno de los dos (ni el oscuro ni el claro).
    Resuelve con Typst, así que refleja el estado real de src/.
    """
    import json
    import tempfile

    nombres = [l.split(":")[0] for l in listar_paletas().splitlines() if ":" in l]
    if not nombres:
        return "No pude leer las paletas."
    cuerpo = [
        '#import "@local/instatypst:0.1.0": palettes',
        "#let roles(n) = {",
        "  let r = (palettes.auto-roles)((palettes.get)(n))",
        "  (dark: r.dark.to-hex(), light: r.light.to-hex(), primary: r.primary.to-hex(),",
        "   secondary: r.secondary.to-hex(), accent: r.accent.to-hex())",
        "}",
        "#metadata((",
    ]
    for n in nombres:
        cuerpo.append(f'  "{n}": roles("{n}"),')
    cuerpo.append(")) <paletas>")
    with tempfile.TemporaryDirectory() as t:
        f = Path(t) / "paletas.typ"
        f.write_text("\n".join(cuerpo), encoding="utf-8")
        r = _typst("eval", "--root", "/", "query(<paletas>).first().value", "--in", str(f), "--format", "json")
    if r.returncode != 0:
        return "ERROR de Typst:\n" + "\n".join(
            l for l in r.stderr.splitlines() if not l.startswith("instatypst:")
        )
    ratio = lambda a, b: (max(_lum(a), _lum(b)) + 0.05) / (min(_lum(a), _lum(b)) + 0.05)
    data = json.loads(r.stdout)
    avisos = []
    for nombre, roles in data.items():
        base = ratio(roles["dark"], roles["light"])
        if base < minimo:
            avisos.append(f"{nombre}: oscuro/claro {base:.1f}:1 (< {minimo})")
        for rol in ("primary", "secondary", "accent"):
            mejor = max(ratio(roles[rol], roles["dark"]), ratio(roles[rol], roles["light"]))
            if mejor < minimo_acento:
                avisos.append(f"{nombre}: {rol} {roles[rol]} máx {mejor:.1f}:1 (< {minimo_acento})")
    cab = f"{len(data)} paletas auditadas; {len(avisos)} avisos."
    return "\n".join([cab, *avisos])


def _publicas(src: Path) -> list[dict]:
    """Funciones públicas (`#let nombre(...)`, sin `_`) de un .typ: firma y comentario previo."""
    txt = src.read_text(encoding="utf-8")
    lineas = txt.splitlines()
    out = []
    for m in re.finditer(r"^#let ([a-zA-Z][\w-]*)\(", txt, re.M):
        i, prof = m.end(), 1
        while i < len(txt) and prof:
            prof += {"(": 1, ")": -1}.get(txt[i], 0)
            i += 1
        nro = txt.count("\n", 0, m.start())
        com = []
        j = nro - 1
        while j >= 0 and lineas[j].lstrip().startswith("//"):
            com.insert(0, lineas[j].lstrip().lstrip("/").strip())
            j -= 1
        firma = " ".join(txt[m.end() : i - 1].split())
        out.append({"nombre": m.group(1), "firma": firma, "linea": nro + 1, "doc": " ".join(c for c in com if c)})
    return out


@mcp.tool()
def api(modulo: str = "") -> str:
    """Funciones públicas de src/ con su firma real, línea y comentario previo.

    `modulo`: nombre del archivo sin extensión (ej. `carteles`). Vacío = resumen de todos.
    Úsala para escribir o revisar documentación sin inventar parámetros.
    """
    archivos = sorted((REPO / "src").glob("*.typ"))
    if modulo:
        archivos = [p for p in archivos if p.stem == modulo]
        if not archivos:
            return f"No existe src/{modulo}.typ"
    out = []
    for p in archivos:
        fs = _publicas(p)
        if not fs:
            continue
        if modulo:
            out.append(f"## {p.stem}")
            for f in fs:
                out.append(f"- {f['nombre']}({f['firma']})  [src/{p.name}:{f['linea']}]")
                if f["doc"]:
                    out.append(f"    {f['doc'][:240]}")
        else:
            out.append(f"{p.stem}: {', '.join(f['nombre'] for f in fs)}")
    return "\n".join(out)


@mcp.tool()
def cobertura_manual() -> str:
    """Compara docs/manual.typ con src/: qué funciones públicas no se mencionan en el manual.

    Una función cuenta como documentada si su nombre aparece en el manual. Agrupa por módulo.
    """
    manual = (REPO / "docs" / "manual.typ").read_text(encoding="utf-8")
    falta, total, hechas = [], 0, 0
    for p in sorted((REPO / "src").glob("*.typ")):
        fs = _publicas(p)
        if not fs:
            continue
        sin = [f["nombre"] for f in fs if not re.search(r"(?<![\w-])" + re.escape(f["nombre"]) + r"(?![\w-])", manual)]
        total += len(fs)
        hechas += len(fs) - len(sin)
        mod_mencionado = bool(re.search(r"\b" + re.escape(p.stem) + r"\b", manual))
        if sin:
            falta.append(f"{p.stem}{'' if mod_mencionado else ' [módulo no mencionado]'}: {', '.join(sin)}")
    cab = f"{hechas}/{total} funciones públicas aparecen en el manual."
    return "\n".join([cab, *falta])


if __name__ == "__main__":
    mcp.run()
