#!/usr/bin/env python3
"""
nueva-plantilla.py — genera un archivo .typ listo para editar, a partir
de una de las plantillas del paquete instatypst (social.typ, articulo.typ,
scripture.typ).

No compila nada por ti a menos que pidas --compilar: solo escribe el
esqueleto con marcadores de posición y, si pediste --paleta/--tipografia,
arma el tema combinado con make-theme() y lo pasa a la plantilla.

Uso:
    python3 scripts/nueva-plantilla.py --listar
    python3 scripts/nueva-plantilla.py announce-post salida.typ
    python3 scripts/nueva-plantilla.py pasaje salida.typ \
        --paleta granates --tipografia revival-vintage \
        --campo referencia="Salmo 23" --campo version=RVR1960

Por defecto genera el import como paquete instalado
(@local/instatypst:0.1.0). Usa --repo si vas a dejar el archivo dentro
de examples/ de este mismo repo (import relativo a ../src/lib.typ).
"""

import argparse
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
FONTS_DEFAULT = REPO_ROOT / "Fonts"

# ── Catálogo de plantillas ──────────────────────────────────────────────
# Cada entrada: (descripción, [(campo, marcador_por_defecto), ...], armar_llamada)
# `armar_llamada` recibe el dict de campos ya resueltos y devuelve el
# texto Typst de la llamada a la función (sin el import ni el tema).

TEMPLATES = {
    "quote-post": (
        "Post de cita — canvas cuadrado, fondo degradado.",
        [("quote", "La cita que quieres destacar."), ("author", "Autor de la cita"), ("handle", "@mi_marca")],
        lambda c: f'[{c["quote"]}],\n  "{c["author"]}",\n  "{c["handle"]}"',
    ),
    "announce-post": (
        "Post de anuncio — badge + título + subtítulo + botón.",
        [("tagline", "NUEVO"), ("title", "Título del anuncio"), ("subtitle", "Subtítulo de apoyo."), ("handle", "@mi_marca")],
        lambda c: f'"{c["tagline"]}",\n  [{c["title"]}],\n  [{c["subtitle"]}],\n  "{c["handle"]}"',
    ),
    "tip-card": (
        "Tarjeta de tip numerado — fondo oscuro, número gigante de marca de agua.",
        [("n", "1"), ("title", "Título del tip"), ("description", "Descripción breve del tip."), ("handle", "@mi_marca")],
        lambda c: f'{c["n"]},\n  [{c["title"]}],\n  [{c["description"]}],\n  "{c["handle"]}"',
    ),
    "carousel-cover": (
        "Portada de carrusel — \"Desliza →\".",
        [("kicker", "GUÍA 2026"), ("title", "Título del carrusel"), ("handle", "@mi_marca"), ("n-pages", "6")],
        lambda c: f'[{c["kicker"]}],\n  [{c["title"]}],\n  "{c["handle"]}",\n  n-pages: {c["n-pages"]}',
    ),
    "carousel-slide": (
        "Slide interior de carrusel — numerado, con barra de progreso.",
        [("n", "2"), ("total", "6"), ("title", "Título del slide"), ("body-text", "Cuerpo del slide."), ("handle", "@mi_marca")],
        lambda c: f'{c["n"]}, {c["total"]},\n  [{c["title"]}],\n  [{c["body-text"]}],\n  "{c["handle"]}"',
    ),
    "stat-card": (
        "Tarjeta de estadística — número gigante + divisor + caption.",
        [("value", "+240%"), ("label", "más alcance orgánico"), ("caption", "Explicación breve del dato."), ("handle", "@mi_marca")],
        lambda c: f'"{c["value"]}",\n  [{c["label"]}],\n  [{c["caption"]}],\n  "{c["handle"]}"',
    ),
    "event-post": (
        "Post de evento — fecha grande + detalles + botón (formato story).",
        [("day", "12"), ("month", "SEPT"), ("title", "Nombre del evento"), ("details", "Detalles del evento."), ("handle", "@mi_marca")],
        lambda c: f'"{c["day"]}", "{c["month"]}",\n  [{c["title"]}],\n  [{c["details"]}],\n  "{c["handle"]}"',
    ),
    "testimonial-post": (
        "Testimonio con avatar de iniciales.",
        [("quote", "Cita del testimonio."), ("name", "Nombre"), ("role", "Rol"), ("initials", "AB"), ("handle", "@mi_marca")],
        lambda c: f'[{c["quote"]}],\n  "{c["name"]}", "{c["role"]}", "{c["initials"]}",\n  "{c["handle"]}"',
    ),
    "poll-story": (
        "Encuesta para stories — dos opciones.",
        [("question", "¿Qué prefieres?"), ("option-a", "Opción A"), ("option-b", "Opción B"), ("handle", "@mi_marca")],
        lambda c: f'[{c["question"]}],\n  "{c["option-a"]}", "{c["option-b"]}",\n  "{c["handle"]}"',
    ),
    "versus-post": (
        "Comparación antes/después — dos columnas con checklist.",
        [("left-title", "Sin estrategia"), ("right-title", "Con sistema"), ("handle", "@mi_marca")],
        lambda c: (
            f'"{c["left-title"]}",\n  ([Publicar al azar], [Sin identidad visual], [Ignorar comentarios]),\n'
            f'  "{c["right-title"]}",\n  ([Calendario fijo], [Plantillas reutilizables], [Comunidad activa]),\n'
            f'  "{c["handle"]}"'
        ),
    ),
    "articulo": (
        "Plantilla editorial de página completa (título + capitular + cuerpo).",
        [("titulo", "Título del artículo"), ("categoria", "Ensayo"), ("autor", "Autor"), ("fecha", "2026")],
        None,  # caso especial: usa #show:, ver render_articulo()
    ),
    "pasaje": (
        "Cita bíblica con letra capital, en su idioma original o traducida.",
        [("referencia", "Salmo 23"), ("version", "RVR1960")],
        None,  # caso especial, ver render_pasaje()
    ),
}


def parse_campos(pares):
    out = {}
    for par in pares or []:
        if "=" not in par:
            sys.exit(f"--campo espera clave=valor, recibí: {par!r}")
        k, v = par.split("=", 1)
        out[k] = v
    return out


def resolver_campos(tipo, overrides):
    _, campos_def, _ = TEMPLATES[tipo]
    campos = {nombre: marcador for nombre, marcador in campos_def}
    for k, v in overrides.items():
        if k not in campos:
            sys.exit(f"'{tipo}' no tiene el campo '{k}'. Campos válidos: {', '.join(campos)}")
        campos[k] = v
    return campos


def armar_tema(paleta, tipografia):
    """Devuelve (lineas_previas, expr_tema) o (None, None) si no se pidió tema."""
    if not paleta and not tipografia:
        return None, None
    args = []
    if paleta:
        args.append(f'paleta: "{paleta}"')
    if tipografia:
        args.append(f'tipografia: "{tipografia}"')
    linea = f'#let mi-tema = make-theme({", ".join(args)})'
    return linea, "mi-tema"


def render_import(repo_mode):
    if repo_mode:
        return '#import "../src/lib.typ": *'
    return '#import "@local/instatypst:0.1.0": *'


def render_canvas(tipo, campos, tema_linea, tema_expr, repo_mode):
    _, _, armar_llamada = TEMPLATES[tipo]
    llamada = armar_llamada(campos)
    if tema_expr:
        llamada += f",\n  theme: {tema_expr}"
    partes = [render_import(repo_mode), ""]
    if tema_linea:
        partes += [tema_linea, ""]
    partes.append(f"#{tipo}(\n  {llamada},\n)")
    return "\n".join(partes) + "\n"


def render_articulo(campos, paleta, tipografia, repo_mode):
    # articulo() recibe paleta:/tipografia: directo en su propia firma
    # (igual que pasaje()) — internamente arma el tema con make-theme()
    # y lo deja en un state() que primer-parrafo() lee solo; no hace
    # falta (ni existe) un parámetro theme: aquí.
    extra = ""
    if paleta:
        extra += f',\n  paleta: "{paleta}"'
    if tipografia:
        extra += f',\n  tipografia: "{tipografia}"'
    partes = [render_import(repo_mode), ""]
    partes.append(
        f'#show: articulo.with(\n'
        f'  titulo: "{campos["titulo"]}",\n'
        f'  categoria: "{campos["categoria"]}",\n'
        f'  autor: "{campos["autor"]}",\n'
        f'  fecha: "{campos["fecha"]}"{extra},\n'
        f')\n\n'
        f'#primer-parrafo[Escribe aquí el primer párrafo — sale con letra capital automática.]\n\n'
        f'Resto del cuerpo del artículo. Usa == para un encabezado de sección si hace falta.\n'
    )
    return "\n".join(partes) + "\n"


def render_pasaje(campos, paleta, tipografia, repo_mode):
    # pasaje() recibe paleta:/tipografia: directo en su propia firma — no
    # pasa por make-theme()/theme: como el resto de las plantillas.
    args = [f'"{campos["referencia"]}"', f'version: "{campos["version"]}"']
    if paleta:
        args.append(f'paleta: "{paleta}"')
    if tipografia:
        args.append(f'tipografia: "{tipografia}"')
    partes = [render_import(repo_mode), ""]
    partes.append(
        f'#pasaje(\n  {", ".join(args)},\n)[\n'
        f'  Texto del versículo (usa #vs[2] para marcar cada versículo siguiente).\n]\n'
    )
    return "\n".join(partes) + "\n"


def render(tipo, campos, paleta, tipografia, repo_mode):
    if tipo == "pasaje":
        return render_pasaje(campos, paleta, tipografia, repo_mode)
    if tipo == "articulo":
        return render_articulo(campos, paleta, tipografia, repo_mode)
    tema_linea, tema_expr = armar_tema(paleta, tipografia)
    return render_canvas(tipo, campos, tema_linea, tema_expr, repo_mode)


def listar():
    print("Plantillas disponibles:\n")
    for nombre, (desc, campos, _) in TEMPLATES.items():
        campos_str = ", ".join(n for n, _ in campos)
        print(f"  {nombre:<18} {desc}")
        print(f"  {'':<18} campos: {campos_str}\n")
    print("Paletas: ver src/palettes.typ (library). Parejas tipográficas: ver src/font-pairings.typ (library).")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("tipo", nargs="?", help="Tipo de plantilla (ver --listar)")
    ap.add_argument("salida", nargs="?", type=Path, help="Ruta del .typ a generar")
    ap.add_argument("--listar", action="store_true", help="Lista las plantillas disponibles y sale")
    ap.add_argument("--campo", action="append", metavar="clave=valor", help="Sobrescribe un campo del contenido (repetible)")
    ap.add_argument("--paleta", help="Nombre de paleta de src/palettes.typ (opcional)")
    ap.add_argument("--tipografia", help="Nombre de pareja de src/font-pairings.typ (opcional)")
    ap.add_argument("--repo", action="store_true", help="Genera import relativo (../src/lib.typ) en vez de @local/instatypst:0.1.0 — para usar dentro de examples/ de este repo")
    ap.add_argument("--compilar", action="store_true", help="Compila el .typ generado con typst (usa --fonts o Fonts/ del repo)")
    ap.add_argument("--fonts", type=Path, default=FONTS_DEFAULT, help=f"Ruta de fuentes para --compilar (default: {FONTS_DEFAULT})")
    args = ap.parse_args()

    if args.listar or not args.tipo:
        listar()
        return

    if args.tipo not in TEMPLATES:
        sys.exit(f"Plantilla desconocida: {args.tipo!r}. Usa --listar para ver las disponibles.")
    if not args.salida:
        sys.exit("Falta la ruta de salida (segundo argumento).")

    overrides = parse_campos(args.campo)
    campos = resolver_campos(args.tipo, overrides)
    contenido = render(args.tipo, campos, args.paleta, args.tipografia, args.repo)

    args.salida.parent.mkdir(parents=True, exist_ok=True)
    args.salida.write_text(contenido, encoding="utf-8")
    print(f"Generado: {args.salida}")

    if args.compilar:
        salida_pdf = args.salida.with_suffix(".pdf")
        cmd = ["typst", "compile", "--root", str(REPO_ROOT), "--font-path", str(args.fonts), str(args.salida), str(salida_pdf)]
        print("Compilando:", " ".join(cmd))
        r = subprocess.run(cmd)
        if r.returncode != 0:
            sys.exit(r.returncode)
        print(f"Compilado: {salida_pdf}")


if __name__ == "__main__":
    main()
