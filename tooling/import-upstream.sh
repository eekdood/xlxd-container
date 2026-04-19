#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <source-repo-path> <source-commit>"
  exit 1
fi

SOURCE_REPO="$1"
SOURCE_COMMIT="$2"

for path in src config dashboard1 dashboard2 scripts license.txt; do
  rm -rf "$path"
  cp -R "${SOURCE_REPO}/${path}" "$path"
done

printf '%s\n' "$SOURCE_COMMIT" > UPSTREAM_XLXD_COMMIT
