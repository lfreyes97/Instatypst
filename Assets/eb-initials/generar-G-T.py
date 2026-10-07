# Genera F2/G.svg y F2/T.svg, que no existen en georgd/EB-Garamond-Initials.
#
# La letra sale de la fuente EB Garamond (Fonts/EB_Garamond, misma
# familia y licencia OFL-1.1), calibrada contra una letra hermana del
# set: G contra C, T contra I. Se toma la escala que lleva la C/I de la
# fuente a la altura de la C/I dibujada, se aplica a la G/T, y se centra
# en el mismo eje. El ornamento (F1/G.svg, F1/T.svg) es copia del de la
# hermana: el de la C deja libre la silueta de la G y el de la I el
# tronco de la T.
#
# Los trazos de la fuente salen ~4-14 unidades (de 1000) más finos que
# los dibujados, así que se engruesan con stroke-width 8 en currentColor
# (dropcaps.typ pone `color=` igual al fill al recolorear).
#
# Uso (desde la raíz del repo): python3 Assets/eb-initials/generar-G-T.py
import io, subprocess
from PIL import Image
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.boundsPen import BoundsPen

D = 'Assets/eb-initials'
font = TTFont('Fonts/EB_Garamond/EBGaramond12-Regular.ttf')
gs = font.getGlyphSet()
cmap = font.getBestCmap()


def svg_bbox(path):
    png = subprocess.run(['rsvg-convert', '-w', '1000', '-h', '1000', path], capture_output=True, check=True).stdout
    return Image.open(io.BytesIO(png)).getchannel('A').getbbox()


def glyph_bbox(ch):
    bp = BoundsPen(gs)
    gs[cmap[ord(ch)]].draw(bp)
    return bp.bounds


def generar(ch, hermana):
    X0, Y0, X1, Y1 = svg_bbox(f'{D}/F2/{hermana}.svg')
    _, y0, _, y1 = glyph_bbox(hermana)
    s = (Y1 - Y0) / (y1 - y0)
    gx0, _, gx1, _ = glyph_bbox(ch)
    tx = (X0 + X1) / 2 - (gx0 + gx1) / 2 * s
    ty = Y1 + y0 * s
    sp = SVGPathPen(gs)
    gs[cmap[ord(ch)]].draw(TransformPen(sp, (s, 0, 0, -s, tx, ty)))
    with open(f'{D}/F2/{ch}.svg', 'w') as f:
        f.write('<?xml version="1.0" encoding="utf-8"?>\n'
                '<svg version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 1000 1000">\n'
                f'<path stroke="currentColor" stroke-width="8" stroke-linejoin="round" d="{sp.getCommands()}"/>\n'
                '</svg>\n')


generar('G', 'C')
generar('T', 'I')
