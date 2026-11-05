#!/bin/sh
# Lleva `main` a la rama de trabajo sin cambiar de rama ni tocar el árbol
# actual: hace la fusión en un worktree temporal y, si sale limpia, mueve la
# rama. Si hay conflicto, aborta y avisa (la fusión se hace a mano).
# Flujo acordado: el paquete va de main a la rama de trabajo, nunca al revés.
#
# Uso: scripts/sincronizar-rama.sh [rama]     (por defecto presuposicionalismo-circular)
# Lo llaman los hooks post-commit y post-merge de main (ver scripts/instalar-hooks.sh).
# Con SINCRONIZAR_PUSH=1 sube además la rama a origin.
rama="${1:-presuposicionalismo-circular}"
raiz=$(git rev-parse --show-toplevel) || exit 0
cd "$raiz" || exit 0

actual=$(git symbolic-ref --short -q HEAD)
[ "$actual" = main ] || exit 0                       # solo al avanzar main
git rev-parse --verify -q "refs/heads/$rama" >/dev/null || exit 0
git merge-base --is-ancestor main "$rama" && exit 0  # ya está al día

# Si la rama está abierta en otro worktree, no se la toca (puede haber trabajo a medias).
if git worktree list --porcelain | grep -qx "branch refs/heads/$rama"; then
  echo "sincronizar-rama: '$rama' está abierta en otro worktree; no la toco. Haz 'git merge main' allí." >&2
  exit 0
fi

tmp=$(mktemp -d) || exit 0
antes=$(git rev-parse "refs/heads/$rama")
git worktree add --detach -q "$tmp" "$rama" || { rm -rf "$tmp"; exit 0; }
if git -C "$tmp" merge --no-edit -q -m "Fusiona main en $rama (automático)" main >/dev/null 2>&1; then
  git update-ref "refs/heads/$rama" "$(git -C "$tmp" rev-parse HEAD)" "$antes" \
    && echo "sincronizar-rama: main fusionado en '$rama'."
  [ "${SINCRONIZAR_PUSH:-0}" = 1 ] && git push -q origin "$rama"
else
  git -C "$tmp" merge --abort >/dev/null 2>&1
  echo "sincronizar-rama: conflicto al fusionar main en '$rama'; no se cambió nada." >&2
  echo "  Hazlo a mano:  git checkout $rama && git merge main" >&2
fi
git worktree remove --force "$tmp" >/dev/null 2>&1 || rm -rf "$tmp"
git worktree prune
exit 0
