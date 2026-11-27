#import "/src/modules/superbg/lib.typ": contraste, es-aa, texto-sobre
#assert(calc.abs(contraste(black, white) - 21) < 1e-9)
#assert(es-aa(black, white) and texto-sobre(black) == white)
ok
