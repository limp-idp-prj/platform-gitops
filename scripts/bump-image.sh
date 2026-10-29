#!/usr/bin/env bash
# Обновляет apps/<name>/values.yaml: image.tag; если replicaCount == 0 -> 1.
# Вызывается из CI сервиса. Требует yq (mikefarah) v4.
set -euo pipefail
[ $# -eq 2 ] || { echo "usage: $0 <name> <tag>" >&2; exit 2; }
name="$1"; tag="$2"
root="$(cd "$(dirname "$0")/.." && pwd)"
file="${APPS_DIR:-$root/apps}/$name/values.yaml"
[ -f "$file" ] || { echo "not found: $file" >&2; exit 1; }
TAG="$tag" yq -i '.image.tag = strenv(TAG)' "$file"
if [ "$(yq '.replicaCount // 0' "$file")" = "0" ]; then
  yq -i '.replicaCount = 1' "$file"
fi
