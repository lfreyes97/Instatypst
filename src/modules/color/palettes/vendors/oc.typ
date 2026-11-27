// GENERADO por scripts/gen-vendors.mjs (fuentes: scripts/fetch-vendors.sh). No editar a mano.
// Open Color (13 familias × 10 tonos 0…9; 0 = más claro, 9 = más oscuro).
// Fuente: yeun/open-color v1.9.1 open-color.json (MIT, ver LICENSE-open-color).
// white y black van como constantes (no entran en la referencia oc-familia-paso).

#let data = (
  gray: ("0": rgb("#f8f9fa"), "1": rgb("#f1f3f5"), "2": rgb("#e9ecef"), "3": rgb("#dee2e6"), "4": rgb("#ced4da"), "5": rgb("#adb5bd"), "6": rgb("#868e96"), "7": rgb("#495057"), "8": rgb("#343a40"), "9": rgb("#212529")),
  red: ("0": rgb("#fff5f5"), "1": rgb("#ffe3e3"), "2": rgb("#ffc9c9"), "3": rgb("#ffa8a8"), "4": rgb("#ff8787"), "5": rgb("#ff6b6b"), "6": rgb("#fa5252"), "7": rgb("#f03e3e"), "8": rgb("#e03131"), "9": rgb("#c92a2a")),
  pink: ("0": rgb("#fff0f6"), "1": rgb("#ffdeeb"), "2": rgb("#fcc2d7"), "3": rgb("#faa2c1"), "4": rgb("#f783ac"), "5": rgb("#f06595"), "6": rgb("#e64980"), "7": rgb("#d6336c"), "8": rgb("#c2255c"), "9": rgb("#a61e4d")),
  grape: ("0": rgb("#f8f0fc"), "1": rgb("#f3d9fa"), "2": rgb("#eebefa"), "3": rgb("#e599f7"), "4": rgb("#da77f2"), "5": rgb("#cc5de8"), "6": rgb("#be4bdb"), "7": rgb("#ae3ec9"), "8": rgb("#9c36b5"), "9": rgb("#862e9c")),
  violet: ("0": rgb("#f3f0ff"), "1": rgb("#e5dbff"), "2": rgb("#d0bfff"), "3": rgb("#b197fc"), "4": rgb("#9775fa"), "5": rgb("#845ef7"), "6": rgb("#7950f2"), "7": rgb("#7048e8"), "8": rgb("#6741d9"), "9": rgb("#5f3dc4")),
  indigo: ("0": rgb("#edf2ff"), "1": rgb("#dbe4ff"), "2": rgb("#bac8ff"), "3": rgb("#91a7ff"), "4": rgb("#748ffc"), "5": rgb("#5c7cfa"), "6": rgb("#4c6ef5"), "7": rgb("#4263eb"), "8": rgb("#3b5bdb"), "9": rgb("#364fc7")),
  blue: ("0": rgb("#e7f5ff"), "1": rgb("#d0ebff"), "2": rgb("#a5d8ff"), "3": rgb("#74c0fc"), "4": rgb("#4dabf7"), "5": rgb("#339af0"), "6": rgb("#228be6"), "7": rgb("#1c7ed6"), "8": rgb("#1971c2"), "9": rgb("#1864ab")),
  cyan: ("0": rgb("#e3fafc"), "1": rgb("#c5f6fa"), "2": rgb("#99e9f2"), "3": rgb("#66d9e8"), "4": rgb("#3bc9db"), "5": rgb("#22b8cf"), "6": rgb("#15aabf"), "7": rgb("#1098ad"), "8": rgb("#0c8599"), "9": rgb("#0b7285")),
  teal: ("0": rgb("#e6fcf5"), "1": rgb("#c3fae8"), "2": rgb("#96f2d7"), "3": rgb("#63e6be"), "4": rgb("#38d9a9"), "5": rgb("#20c997"), "6": rgb("#12b886"), "7": rgb("#0ca678"), "8": rgb("#099268"), "9": rgb("#087f5b")),
  green: ("0": rgb("#ebfbee"), "1": rgb("#d3f9d8"), "2": rgb("#b2f2bb"), "3": rgb("#8ce99a"), "4": rgb("#69db7c"), "5": rgb("#51cf66"), "6": rgb("#40c057"), "7": rgb("#37b24d"), "8": rgb("#2f9e44"), "9": rgb("#2b8a3e")),
  lime: ("0": rgb("#f4fce3"), "1": rgb("#e9fac8"), "2": rgb("#d8f5a2"), "3": rgb("#c0eb75"), "4": rgb("#a9e34b"), "5": rgb("#94d82d"), "6": rgb("#82c91e"), "7": rgb("#74b816"), "8": rgb("#66a80f"), "9": rgb("#5c940d")),
  yellow: ("0": rgb("#fff9db"), "1": rgb("#fff3bf"), "2": rgb("#ffec99"), "3": rgb("#ffe066"), "4": rgb("#ffd43b"), "5": rgb("#fcc419"), "6": rgb("#fab005"), "7": rgb("#f59f00"), "8": rgb("#f08c00"), "9": rgb("#e67700")),
  orange: ("0": rgb("#fff4e6"), "1": rgb("#ffe8cc"), "2": rgb("#ffd8a8"), "3": rgb("#ffc078"), "4": rgb("#ffa94d"), "5": rgb("#ff922b"), "6": rgb("#fd7e14"), "7": rgb("#f76707"), "8": rgb("#e8590c"), "9": rgb("#d9480f")),
)

#let white = rgb("#ffffff")
#let black = rgb("#000000")

#let families() = ("gray", "red", "pink", "grape", "violet", "indigo", "blue", "cyan", "teal", "green", "lime", "yellow", "orange")
#let steps() = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

#let family(fam) = {
  if not (fam in data) { panic("oc: familia desconocida: " + fam + " -- disponibles: " + families().join(", ")) }
  data.at(fam)
}

#let get(fam, idx) = {
  let ramp = family(fam)
  let key = str(int(str(idx)))
  if not (key in ramp) { panic("oc: índice fuera de rango: " + str(idx) + " -- usar 0..9") }
  ramp.at(key)
}
