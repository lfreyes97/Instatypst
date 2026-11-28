// inscription, variante "psalm": `salmo-columna` de WallTypst (muestra verso-xrefs.json). Compilar desde la raíz del repo.
#import "/src/lib.typ": verse, work
#import "/.labs/Walltypst-Framed/src/inscription.typ": inscription

#inscription(variant: "psalm", artboard: (1920, 1080))[
  #verse(xrefs: ("Salmos 100:3", "Habacuc 2:20", "Ezequiel 38:23"))[Estad quietos, y conoced que yo soy Dios: ensalzado he de ser entre las gentes, ensalzado seré en la tierra.]
  #work[Salmos 46:10]
]
