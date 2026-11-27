// ─────────────────────────────────────────────────────────────
//  parts.typ — cómo un preset lee los elementos de su cuerpo
//
//  Un elemento es `part(kind, body, ..props)`: devuelve un `metadata` que no se
//  dibuja por sí solo. `read-parts(body, known:)` aplana el cuerpo y devuelve
//    parts   kind -> (body:, props:)     solo los de `known`; si un elemento se
//            repite, gana el último
//    loose   el contenido sin nombre, junto; un elemento que el preset NO
//            reconoce también es contenido suelto: su cuerpo, en su lugar
//  `known: auto` reconoce todos los elementos.
//  Nada es obligatorio y nada da error (Spec §1.4).
//
//  `show-parts` es la regla de base: un elemento sin reglas que lo configuren se
//  dibuja como su cuerpo, igual que un `h1` sin estilar. `#main[Hola]` y
//  `#text[Hola]` salen iguales en `plain`. Cubre también los elementos anidados
//  (`#align(center)[#main[…]]`), que `read-parts` no ve.
// ─────────────────────────────────────────────────────────────

#let part(kind, body, ..props) = [#metadata((kind: kind, body: body, props: props.named()))]

#let _is-part(v) = type(v) == dictionary and "kind" in v and "body" in v

// No entra en `list`, `enum` ni `terms`: un preset las reconoce enteras (sus ítems
// son un grupo), y aplanarlas perdería la frontera entre una lista y la siguiente.
#let _flatten(c) = if c.has("children") and c.func() not in (list, enum, terms) {
  c.children.map(_flatten).flatten()
} else { (c,) }

#let read-parts(body, known: auto) = {
  let found = (:)
  let loose = ()
  for c in _flatten(body) {
    if c.func() == metadata and _is-part(c.value) {
      if known == auto or c.value.kind in known {
        found.insert(c.value.kind, (body: c.value.body, props: c.value.props))
      } else {
        loose.push(c.value.body)
      }
    } else if repr(c.func()) not in ("space", "parbreak") {
      loose.push(c)
    }
  }
  (parts: found, loose: loose.fold([], (a, b) => a + b), has-loose: loose.len() > 0)
}

// Regla `show` de base: los elementos que nadie consumió se dibujan como su cuerpo.
#let show-parts(it) = if _is-part(it.value) { it.value.body } else { it }
