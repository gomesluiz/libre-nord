#!/usr/bin/env bash
set -euo pipefail

NEXT_VERSION="${1:-}"
CHANGELOG_FILE="${2:-CHANGELOG.md}"

if [[ -z "${NEXT_VERSION}" ]]; then
  echo "error: missing version." >&2
  echo "usage: update_changelog.sh <version> [changelog_file]" >&2
  exit 1
fi

if [[ ! -f "${CHANGELOG_FILE}" ]]; then
  echo "error: changelog file not found: ${CHANGELOG_FILE}" >&2
  exit 1
fi

if grep -Eq "^## \[${NEXT_VERSION//./\\.}\] - " "${CHANGELOG_FILE}"; then
  echo "error: version ${NEXT_VERSION} already exists in ${CHANGELOG_FILE}" >&2
  exit 1
fi

LAST_TAG="$(git describe --tags --abbrev=0 2>/dev/null || true)"
if [[ -n "${LAST_TAG}" ]]; then
  RANGE="${LAST_TAG}..HEAD"
else
  RANGE="HEAD"
fi

COMMITS="$(git log --no-merges --pretty=format:%s ${RANGE})"
if [[ -z "${COMMITS}" ]]; then
  echo "error: no commits found in range ${RANGE}" >&2
  exit 1
fi

added=""
fixed=""
changed=""
maintenance=""
other=""

while IFS= read -r subject; do
  [[ -z "${subject}" ]] && continue

  if printf '%s\n' "${subject}" | grep -Eq '^[a-zA-Z]+(\([^)]+\))?!?:[[:space:]]*'; then
    commit_type="$(printf '%s\n' "${subject}" | sed -E 's/^([a-zA-Z]+)(\([^)]+\))?!?:[[:space:]]*.*/\1/' | tr '[:upper:]' '[:lower:]')"
    commit_summary="$(printf '%s\n' "${subject}" | sed -E 's/^[a-zA-Z]+(\([^)]+\))?!?:[[:space:]]*//')"
  else
    commit_type="other"
    commit_summary="${subject}"
  fi

  [[ -z "${commit_summary}" ]] && commit_summary="${subject}"

  case "${commit_type}" in
    feat)
      added+="- ${commit_summary}"$'\n'
      ;;
    fix)
      fixed+="- ${commit_summary}"$'\n'
      ;;
    docs|refactor|perf|style|test)
      changed+="- ${commit_summary}"$'\n'
      ;;
    build|ci|chore)
      maintenance+="- ${commit_summary}"$'\n'
      ;;
    *)
      other+="- ${subject}"$'\n'
      ;;
  esac
done <<< "${COMMITS}"

TODAY="$(date +%Y-%m-%d)"
SECTION="## [${NEXT_VERSION}] - ${TODAY}"$'\n'

if [[ -n "${added}" ]]; then
  SECTION+="### Adicionado"$'\n'
  SECTION+="${added}"$'\n'
fi

if [[ -n "${fixed}" ]]; then
  SECTION+="### Corrigido"$'\n'
  SECTION+="${fixed}"$'\n'
fi

if [[ -n "${changed}" ]]; then
  SECTION+="### Alterado"$'\n'
  SECTION+="${changed}"$'\n'
fi

if [[ -n "${maintenance}" ]]; then
  SECTION+="### Manutencao"$'\n'
  SECTION+="${maintenance}"$'\n'
fi

if [[ -n "${other}" ]]; then
  SECTION+="### Outros"$'\n'
  SECTION+="${other}"$'\n'
fi

TMP_FILE="$(mktemp)"
awk -v section="${SECTION}" '
  BEGIN { inserted = 0 }
  !inserted && $0 ~ /^## \[/ {
    print section
    inserted = 1
  }
  { print }
  END {
    if (!inserted) {
      print ""
      print section
    }
  }
' "${CHANGELOG_FILE}" > "${TMP_FILE}"

mv "${TMP_FILE}" "${CHANGELOG_FILE}"
echo "[INFO] Updated ${CHANGELOG_FILE} with version ${NEXT_VERSION} (range: ${RANGE})"
