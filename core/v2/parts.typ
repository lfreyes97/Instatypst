// ─────────────────────────────────────────────────────────────
//  core/v2/parts.typ — cómo un tipo lee los hijos de su cuerpo
//
//  Cada tipo define sus propios hijos con `part(kind, body)` (devuelven un
//  `metadata` que no se dibuja) y los lee con `read-parts(body)`.
//    · los hijos pueden venir anidados: se aplanan antes de leerlos
//    · si un hijo se repite, gana el último
//    · el contenido sin etiquetar se devuelve en `content`
// ─────────────────────────────────────────────────────────────

#let part(kind, body) = [#metadata((kind: kind, body: body)) <part>]

#let _flatten(c) = if c.has("children") { c.children.map(_flatten).flatten() } else { (c,) }

#let read-parts(body) = {
  let found = (:)
  let loose = ()
  for c in _flatten(body) {
    if c.func() == metadata {
      if "kind" in c.value { found.insert(c.value.kind, c.value.body) }
    } else if repr(c.func()) != "space" {
      loose.push(c)
    }
  }
  found + (content: loose.fold([], (a, b) => a + b))
}
