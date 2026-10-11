# Mide los glifos de IM FELL FLOWERS 1 y 2 para src/fleurones.typ.
#
# Por cada carácter del cmap guarda (avance, ymin, ymax) en unidades de
# 1000/em: el avance horizontal y el alto real de la tinta. Con eso
# fleurones.caja() mete cada glifo en una caja exacta (top-edge/bottom-edge
# "bounds" sobre su tinta), y banda()/marco()/diaper() los encadenan sin
# costuras. Reemplaza la tabla `met` que Magnalia llevaba a mano (~45
# glifos) por la de todos.
#
# Uso (desde la raíz del repo): python3 scripts/medir-fleurones.py
import json
from fontTools.ttLib import TTFont
from fontTools.pens.boundsPen import BoundsPen

FUENTES = {
    'IM FELL FLOWERS 1': 'Fonts/IM_Fell_Flowers/IMFeFlow1.otf',
    'IM FELL FLOWERS 2': 'Fonts/IM_Fell_Flowers/IMFeFlow2.otf',
}
SALIDA = 'src/assets/fleurones.json'

datos = {}
for familia, ruta in FUENTES.items():
    f = TTFont(ruta)
    escala = 1000 / f['head'].unitsPerEm
    gs = f.getGlyphSet()
    glifos = {}
    for cp, nombre in sorted(f.getBestCmap().items()):
        pen = BoundsPen(gs)
        gs[nombre].draw(pen)
        if pen.bounds is None:  # espacio u otro glifo sin tinta
            continue
        _, ymin, _, ymax = pen.bounds
        glifos[chr(cp)] = [round(gs[nombre].width * escala), round(ymin * escala), round(ymax * escala)]
    datos[familia] = glifos

with open(SALIDA, 'w') as s:
    json.dump(datos, s, ensure_ascii=False, indent=1, sort_keys=True)
print(SALIDA, {k: len(v) for k, v in datos.items()})
