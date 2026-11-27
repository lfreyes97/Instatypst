// superbg: un patrón con tamaño no entero no falla (antes `range` exigía enteros).
#import "/src/modules/superbg/lib.typ": bg-patron
#for p in ("dots", "grid") { bg-patron(patron: p, size: (1080.5, 1350.25)) }
ok
