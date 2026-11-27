// core/parts: read-parts no entra en las listas (sus ítems son un grupo).
#import "/src/core/parts.typ": read-parts

#let r = read-parts([#list[a][b] #list[c]])
#let listas = r.loose.children.filter(c => c.func() == list)
#assert(listas.len() == 2, message: "las dos listas deben llegar enteras, llegan " + str(listas.len()))
ok
