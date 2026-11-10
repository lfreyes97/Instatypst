#!/bin/sh
# Instala los hooks de git que mantienen al día la rama de trabajo.
# Los hooks viven en .git/hooks (no se versionan): ejecútalo una vez por clon.
raiz=$(git rev-parse --show-toplevel) || exit 1
for h in post-commit post-merge; do
  printf '#!/bin/sh\nexec "%s/scripts/sincronizar-rama.sh"\n' "$raiz" > "$(git rev-parse --git-path hooks)/$h"
  chmod +x "$(git rev-parse --git-path hooks)/$h"
done
echo "Hooks post-commit y post-merge instalados."
