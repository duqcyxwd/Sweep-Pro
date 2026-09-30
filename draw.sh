#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "$0")"

draw() {
  keymap parse -c 10 -z config/sweep.keymap | keymap draw \
    --ortho-layout '{split: true, rows: 3, columns: 5, thumbs: 3}' \
    - \
    -o sweep_keymap.ortho.svg

  printf 'Generated %s\n' "$(date '+%H:%M:%S') sweep_keymap.ortho.svg"
}

case "${1:-}" in
  "")
    draw
    ;;
  watch)
    command -v entr >/dev/null 2>&1 || {
      printf 'Error: entr is required for watch mode.\n' >&2
      exit 1
    }

    draw
    printf 'Watching config/ for changes. Press Ctrl-C to stop.\n'
    find config -type f -print | entr -r ./draw.sh
    ;;
  *)
    printf 'Usage: %s [watch]\n' "$0" >&2
    exit 2
    ;;
esac
