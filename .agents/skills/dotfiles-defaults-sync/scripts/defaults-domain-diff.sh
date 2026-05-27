#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  REPO_ROOT="$SCRIPT_DIR"
fi
CACHE_DIR="$REPO_ROOT/.cache/dotfiles-defaults-sync"

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: required command not found: $cmd" >&2
    exit 1
  fi
}

usage() {
  cat <<'USAGE' >&2
Usage: .agents/skills/dotfiles-defaults-sync/scripts/defaults-domain-diff.sh [--dry-run] [--update-cache] <domain>
Example: .agents/skills/dotfiles-defaults-sync/scripts/defaults-domain-diff.sh com.apple.dt.Xcode
USAGE
}

update_cache=false
domain=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run|--no-update-cache)
      update_cache=false
      shift
      ;;
    --update-cache)
      update_cache=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$domain" ]]; then
        domain="$1"
        shift
      else
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$domain" ]]; then
  usage
  exit 1
fi

require_cmd defaults
require_cmd plutil
require_cmd python3
require_cmd mktemp
require_cmd mkdir
require_cmd mv
require_cmd cp

if [[ "$update_cache" == "true" ]]; then
  mkdir -p "$CACHE_DIR"
fi

baseline_file="$CACHE_DIR/defaults.${domain}.baseline.plist"

tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/defaults-domain-diff.XXXXXX")"
trap 'rm -rf "$tmpdir"' EXIT

current_plist="$tmpdir/current.plist"
diff_out="$tmpdir/diff.out"

mode="dry-run"
if [[ "$update_cache" == "true" ]]; then
  mode="update-cache"
fi

if ! defaults export "$domain" - > "$current_plist" 2>"$tmpdir/export.err"; then
  echo "error: failed to export defaults domain '$domain'" >&2
  cat "$tmpdir/export.err" >&2
  exit 1
fi

echo "## $domain"
echo "# mode: $mode"

if [[ ! -f "$baseline_file" ]]; then
  if [[ "$update_cache" == "true" ]]; then
    baseline_tmp="$(mktemp "$CACHE_DIR/defaults.${domain}.baseline.XXXXXX")"
    cp "$current_plist" "$baseline_tmp"
    mv "$baseline_tmp" "$baseline_file"
    echo "# baseline created: $baseline_file"
  else
    echo "# baseline missing: $baseline_file (run with --update-cache to create)"
  fi
  exit 0
fi

if ! plutil -lint "$baseline_file" >/dev/null 2>&1; then
  if [[ "$update_cache" == "true" ]]; then
    baseline_tmp="$(mktemp "$CACHE_DIR/defaults.${domain}.baseline.XXXXXX")"
    cp "$current_plist" "$baseline_tmp"
    mv "$baseline_tmp" "$baseline_file"
    echo "# baseline recreated (invalid cache): $baseline_file"
    exit 0
  fi

  echo "error: baseline cache is invalid in dry-run mode: $baseline_file (run with --update-cache to recreate)" >&2
  exit 1
fi

python3 - "$baseline_file" "$current_plist" > "$diff_out" <<'PY'
import datetime as dt
import hashlib
import plistlib
import sys
from typing import Any, Dict

baseline_path = sys.argv[1]
current_path = sys.argv[2]


def scalar_to_str(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return format(value, ".17g")
    if isinstance(value, bytes):
        h = hashlib.sha256(value).hexdigest()[:12]
        return f"data(len={len(value)},sha256={h})"
    if isinstance(value, dt.datetime):
        return f"datetime({value.isoformat()})"
    if isinstance(value, dt.date):
        return f"date({value.isoformat()})"
    if isinstance(value, str):
        return repr(value)
    uid_cls = getattr(plistlib, "UID", None)
    if uid_cls is not None and isinstance(value, uid_cls):
        return f"uid({value.data})"
    return repr(value)


def flatten(obj: Any, path: str, out: Dict[str, str]) -> None:
    if isinstance(obj, dict):
        if not obj and path:
            out[path] = "{}"
            return
        for key in sorted(obj.keys(), key=lambda x: str(x)):
            child = f"{path}:{key}" if path else f":{key}"
            flatten(obj[key], child, out)
        return

    if isinstance(obj, list):
        if not obj and path:
            out[path] = "[]"
            return
        for idx, item in enumerate(obj):
            child = f"{path}:{idx}"
            flatten(item, child, out)
        return

    if path:
        out[path] = scalar_to_str(obj)


with open(baseline_path, "rb") as f:
    baseline_obj = plistlib.load(f)
with open(current_path, "rb") as f:
    current_obj = plistlib.load(f)

baseline_flat: Dict[str, str] = {}
current_flat: Dict[str, str] = {}
flatten(baseline_obj, "", baseline_flat)
flatten(current_obj, "", current_flat)

changes = []
all_paths = sorted(set(baseline_flat) | set(current_flat))

for path in all_paths:
    in_baseline = path in baseline_flat
    in_current = path in current_flat

    if in_baseline and in_current:
        if baseline_flat[path] != current_flat[path]:
            changes.append(("CHANGED", path, baseline_flat[path], current_flat[path]))
    elif in_current:
        changes.append(("ADDED", path, "", current_flat[path]))
    else:
        changes.append(("REMOVED", path, baseline_flat[path], ""))

if not changes:
    print("# no changes")
else:
    for kind, path, old_v, new_v in changes:
        if kind == "CHANGED":
            print(f"CHANGED {path} | old={old_v} | new={new_v}")
        elif kind == "ADDED":
            print(f"ADDED {path} | new={new_v}")
        else:
            print(f"REMOVED {path} | old={old_v}")
PY

cat "$diff_out"

if [[ "$update_cache" == "true" ]]; then
  baseline_tmp="$(mktemp "$CACHE_DIR/defaults.${domain}.baseline.XXXXXX")"
  cp "$current_plist" "$baseline_tmp"
  mv "$baseline_tmp" "$baseline_file"
fi
