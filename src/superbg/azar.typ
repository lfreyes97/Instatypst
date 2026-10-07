// ─────────────────────────────────────────────────────────────
//  superbg / azar.typ — PRNG determinista (LCG) para layouts
//  reproducibles: memphis, topo, malla. Sin estado, sin sorpresas.
// ─────────────────────────────────────────────────────────────

// Un paso del generador (módulo primo 2^31-1, constantes clásicas).
#let _lcg(semilla) = calc.rem(1103515245 * semilla + 12345, 2147483647)

// N floats en [0, 1) a partir de `semilla`. Misma semilla = mismo layout.
#let _secuencia(n, semilla) = {
  let s = semilla
  let fuera = ()
  for _ in range(n) {
    s = _lcg(s)
    fuera.push(s / 2147483647)
  }
  fuera
}
