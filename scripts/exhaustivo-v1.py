#!/usr/bin/env python3
# Recuperado de la transcripción de la sesión del 5 de noviembre de 2026 (el script
# vivió en un scratchpad de /tmp y nunca se commiteó). El cuerpo es el original; solo
# cambió la ruta de RAIZ, que era absoluta. Es de la v1: llama a
# `carteles.cita-social` e importa `src/lib.typ` como la v1, así que en esta rama no
# corre. Su par para la v2 es `scripts/exhaustivo.py`.
"""Batería exhaustiva de carteles.cita-social: todas las combinaciones, por tandas.
Un overflow da panic (aborta toda la compilación): las tandas que fallan se
parten por la mitad hasta aislar el caso. Las fugas se miden contra un control
(el mismo estilo/formato/variante/atribución con el texto «x») en el anillo
fuera del área (area: 80 %)."""
import itertools, json, subprocess, sys, time, shutil
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path
from PIL import Image, ImageChops

RAIZ = Path(__file__).resolve().parent.parent
OUT = RAIZ / "examples/salidas/exhaustivo"
PPI = 12
ESTILOS = ["clasico","publicacion","mensaje","editorial","papel","pizarra","recorte","aura","minimo","subrayado"]
ESTILOS[8] = "minimal"
FORMATOS = [(1080,1920),(1080,1080),(1080,1350),(1600,900),(1200,1200)]
TEXTOS = {"s": "La constancia entrena al algoritmo… y a tu #highlight[audiencia].",
          "m": "Una obra pseudónima que presenta una síntesis neoplatónica cristianizada bajo el nombre de un discípulo de los apóstoles adquiere autoridad precisamente por una identidad apostólica que no posee. Si esa obra contribuye a consolidar estructuras, es una #highlight[obra diabólica].",
          "l": "Una obra pseudónima que presenta una síntesis neoplatónica cristianizada bajo el nombre de un discípulo de los apóstoles adquiere autoridad precisamente por una identidad apostólica que no posee. Si esa obra contribuye posteriormente a consolidar determinadas estructuras metafísicas de la teología y liturgia medieval, uno puede describir teológicamente esa falsificación como una #highlight[obra diabólica]: no porque podamos demostrar la agencia personal del diablo, sino porque el mecanismo es exactamente el tipo de engaño que la teología cristiana atribuye a Satanás. Y aun así la pregunta sigue en pie: ¿qué hace que una autoridad prestada pese más que una verdad evidente? La respuesta, dicen, está en el prestigio acumulado de siglos de lectura reverente."}
CAMPOS = {0: "", 1: 'usuario: "@luisreyes", verificado: true, fecha: "5 nov 2026", contexto: [Teología e historia], metricas: (comentarios: 48, compartidos: 1300, "me-gusta": 12000, vistas: 2500000), respuesta: (texto: [¿Qué métrica usarías?], nombre: "Marta Gil", usuario: "@marta"),'}
VARIANTES = ["tarjeta","sangre","abierta"]
ATRIB = ["abajo","arriba","lado"]

def llamada(c, control=False):
    est, fmt, txt, campos, foto, var, atr, com = c
    cita = "[x]" if control else f"[{TEXTOS[txt]}]"
    return (f'#carteles.cita-social({cita}, [Luis Felipe Reyes de los Reyes], iniciales: "LR", '
            f'estilo: "{est}", formato: {fmt}, variante: "{var}", atribucion: "{atr}", comilla: {str(bool(com)).lower()}, '
            f'{"" if control else CAMPOS[campos]} {"" if (control or not foto) else "foto: foto,"} area: 80%)')

def compilar(nombre, llamadas):
    f = OUT / f"{nombre}.typ"
    f.write_text('#import "../../../src/lib.typ": *\n#let foto = "/examples/avatar.jpg"\n' + "\n".join(llamadas) + "\n", encoding="utf-8")
    d = OUT / nombre; d.mkdir(exist_ok=True)
    r = subprocess.run(["typst","compile","--root",str(RAIZ),"--font-path",str(RAIZ/"Fonts"),str(f),str(d/"p-{p}.png"),"--ppi",str(PPI)],
                       capture_output=True, text=True)
    return r.returncode == 0, r.stderr

def tanda(args):
    """Devuelve (casos ok con su PNG, errores)."""
    nombre, casos, controles = args
    ok, errs, hecho = [], [], []
    def ir(lista, nom):
        good, err = compilar(nom, [llamada(c, controles) for c in lista])
        if good:
            for i, c in enumerate(lista):
                hecho.append((c, str(OUT/nom/f"p-{i+1}.png")))
            return
        if len(lista) == 1:
            msg = [l for l in err.splitlines() if l.startswith("error")]
            errs.append((lista[0], msg[0] if msg else err[:200]))
            return
        m = len(lista)//2
        ir(lista[:m], nom+"a"); ir(lista[m:], nom+"b")
    ir(casos, nombre)
    return hecho, errs

def main():
    t0 = time.time()
    shutil.rmtree(OUT, ignore_errors=True); OUT.mkdir(parents=True)
    # controles
    claves = sorted({(e,f,"s",0,0,v,a,0) for e in ESTILOS for f in FORMATOS for v in VARIANTES for a in ATRIB})
    casos = [(e,f,t,c,fo,v,a,co) for e in ESTILOS for f in FORMATOS for t in TEXTOS for c in CAMPOS for fo in (0,1) for v in VARIANTES for a in ATRIB for co in (0,1)]
    print(len(casos), "casos,", len(claves), "controles", flush=True)
    def tandas(lista, pref, controles, n=40):
        return [(f"{pref}{i:04d}", lista[i:i+n], controles) for i in range(0, len(lista), n)]
    with ProcessPoolExecutor(4) as ex:
        ctl = {}
        for hecho, errs in ex.map(tanda, tandas(claves, "k", True)):
            for c, png in hecho: ctl[c[0],c[1],c[5],c[6]] = png
            if errs: print("ERROR EN CONTROL", errs[:2])
        print(f"controles listos ({time.time()-t0:.0f}s)", flush=True)
        # los casos, agrupados por formato para que cada tanda tenga páginas del mismo tamaño
        resultados, errores, fugas, n = [], [], [], 0
        trabajos = []
        for f in FORMATOS:
            lista = [c for c in casos if c[1] == f]
            trabajos += tandas(lista, f"c{f[0]}x{f[1]}-", False, 60)
        for hecho, errs in ex.map(tanda, trabajos):
            errores += errs
            for c, png in hecho:
                n += 1
                a = Image.open(png).convert("RGB"); b = Image.open(ctl[c[0],c[1],c[5],c[6]]).convert("RGB")
                w, h = a.size; mx, my = round(w*0.1)-1, round(h*0.1)-1
                diff = ImageChops.difference(a, b).convert("L").point(lambda v: 255 if v > 40 else 0)
                diff.paste(0, (mx, my, w-mx, h-my))   # solo el anillo
                px = sum(1 for v in diff.getdata() if v)
                if px > 4: fugas.append((c, px))
            if n % 600 < 60: print(f"  {n} medidos ({time.time()-t0:.0f}s)", flush=True)
    json.dump({"errores": [(list(c), m) for c, m in errores], "fugas": [(list(c), p) for c, p in fugas]}, open(OUT/"resultado.json","w"), ensure_ascii=False, indent=1)
    print(f"FIN {time.time()-t0:.0f}s: {n} medidos, {len(errores)} con error, {len(fugas)} con fuga")

if __name__ == "__main__": main()
