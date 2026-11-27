// Los módulos se importan solos (sin lib ni core) y su API básica responde.
#import "/src/modules/validate/validate.typ": expect
#import "/src/modules/color/color.typ": resolve-theme, color-roles
#import "/src/modules/color/palettes.typ": palettes
#import "/src/modules/typography/fonts.typ": resolve-fonts, font-roles
#import "/src/modules/typography/typography.typ": typeset, text-roles

#let tm = resolve-theme((paper: "tw4-stone-50", ink: "tw4-stone-950"), (paper: white, ink: black, accent: red))
#assert(color-roles.all(r => r in tm), message: "color: el tema resuelto trae los cinco roles")
#assert(type(palettes.tw4.get("amber", "400")) == color, message: "color: catálogo tw4")
#let fs = resolve-fonts("suizo", "suizo")
#assert(type(fs) == dictionary, message: "typography: la pareja suizo se resuelve")
#assert("display" in font-roles and "prose" in text-roles, message: "typography: roles")
ok
