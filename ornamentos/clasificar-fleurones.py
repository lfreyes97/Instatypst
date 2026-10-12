# Clasifica los 80 glifos de IM FELL FLOWERS 1 y 2 para el catálogo
# ornamentos/fleurones.typ. Rasteriza cada glifo (FreeType vía PIL) y
# mide, sobre la tinta:
#   simetria   "vertical" (espejo izquierda/derecha), "horizontal"
#              (arriba/abajo), "giro" (180°), varias o ninguna
#   giro       el glifo que es este mismo girado 180° (R↔S, A↔D; en
#              FLOWERS 2 cada minúscula es su mayúscula girada): la
#              pieza complementaria para alternar en una banda
#   cuarto     el glifo que es este girado 90° a la derecha (molinetes)
#   espejo     el glifo que es su reflejo izquierda/derecha
#   encadena   la tinta toca los dos costados de su avance: pieza
#              dibujada para unirse con la siguiente en una banda
#   proporcion ancho/alto de la tinta (apaisada, cuadrada, alta)
# Las medidas (avance, ymin, ymax) son las de src/assets/fleurones.json.
#
# Uso (desde la raíz del repo): python3 ornamentos/clasificar-fleurones.py
import json
import numpy as np
from PIL import Image, ImageFont
from fontTools.ttLib import TTFont
from fontTools.pens.boundsPen import BoundsPen

FUENTES = {
    'IM FELL FLOWERS 1': 'Fonts/IM_Fell_Flowers/IMFeFlow1.otf',
    'IM FELL FLOWERS 2': 'Fonts/IM_Fell_Flowers/IMFeFlow2.otf',
}
SALIDA = 'ornamentos/fleurones.json'
# IoU mínimo para dar por iguales dos siluetas. Son grabados de imprenta
# digitalizados: ni las simetrías son exactas (una pieza simétrica da
# 0,8–0,9, una que no lo es, menos de 0,7), ni los pares (0,85–1,00).
UMBRAL_SIM = 0.80
UMBRAL_PAR = 0.85


def silueta(fuente, c):
    m = fuente.getmask(c, mode='L')
    a = np.array(m, dtype=np.uint8).reshape(m.size[1], m.size[0]) > 96
    ys, xs = np.nonzero(a)
    return a[ys.min():ys.max() + 1, xs.min():xs.max() + 1]


def iou(a, b):
    if a.shape != b.shape:
        # misma caja: reescalar b a la forma de a
        b = np.array(Image.fromarray(b.astype(np.uint8) * 255).resize((a.shape[1], a.shape[0]))) > 127
    inter = np.logical_and(a, b).sum()
    union = np.logical_or(a, b).sum()
    return inter / union if union else 0


datos = {}
for familia, ruta in FUENTES.items():
    tt = TTFont(ruta)
    gs = tt.getGlyphSet()
    cmap = tt.getBestCmap()
    pil = ImageFont.truetype(ruta, 400)
    glifos = {}
    sil = {}
    for cp, nombre in sorted(cmap.items()):
        pen = BoundsPen(gs)
        gs[nombre].draw(pen)
        if pen.bounds is None or cp == 0x20:  # sin tinta, o el «espacio visible»
            continue
        c = chr(cp)
        xmin, ymin, xmax, ymax = pen.bounds
        adv = gs[nombre].width
        s = silueta(pil, c)
        sil[c] = s
        simetrias = []
        if iou(s, s[:, ::-1]) >= UMBRAL_SIM: simetrias.append('vertical')
        if iou(s, s[::-1, :]) >= UMBRAL_SIM: simetrias.append('horizontal')
        if iou(s, s[::-1, ::-1]) >= UMBRAL_SIM: simetrias.append('giro')
        tinta_w, tinta_h = xmax - xmin, ymax - ymin
        glifos[c] = {
            'glifo': nombre,
            'avance': round(adv), 'xmin': round(xmin), 'xmax': round(xmax),
            'ymin': round(ymin), 'ymax': round(ymax),
            'simetria': simetrias,
            # toca ambos costados (tolerancia: 2 % del avance)
            'encadena': xmin <= 0.02 * adv and xmax >= 0.98 * adv,
            'proporcion': round(tinta_w / tinta_h, 2),
        }
    # pares: el otro glifo que es este reflejado, girado 180° o 90°
    def par(c, transformar, umbral):
        mejor, val = None, 0
        for d, t in sil.items():
            if d == c: continue
            v = iou(transformar(sil[c]), t)
            if v > val: mejor, val = d, v
        return mejor if val >= umbral else None
    for c in sil:
        g = glifos[c]
        if 'giro' not in g['simetria']:
            d = par(c, lambda a: a[::-1, ::-1], UMBRAL_PAR)
            if d: g['giro'] = d
        if 'vertical' not in g['simetria']:
            d = par(c, lambda a: a[:, ::-1], UMBRAL_PAR)
            if d: g['espejo'] = d
        d = par(c, lambda a: np.rot90(a, -1), UMBRAL_PAR)
        if d: g['cuarto'] = d
    datos[familia] = glifos

with open(SALIDA, 'w') as f:
    json.dump(datos, f, ensure_ascii=False, indent=1, sort_keys=True)

for fam, g in datos.items():
    print(f"{fam}: {len(g)} glifos · encadenan {sum(v['encadena'] for v in g.values())}")
    print('  simétricos:', ' '.join(f"{c}({','.join(v['simetria'])})" for c, v in g.items() if v['simetria']))
    for clave in ('giro', 'espejo', 'cuarto'):
        pares = sorted({tuple(sorted((c, v[clave]))) if clave != 'cuarto' else (c, v[clave]) for c, v in g.items() if clave in v})
        print(f'  {clave}:', ' '.join(a + ('→' if clave == 'cuarto' else '↔') + b for a, b in pares))
