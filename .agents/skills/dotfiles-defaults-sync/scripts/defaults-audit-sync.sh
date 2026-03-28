#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  REPO_ROOT="$SCRIPT_DIR"
fi

DOMAINS_FILE="$SCRIPT_DIR/defaults-domains.txt"
DEFAULTS_SCRIPT="$REPO_ROOT/macos/defaults.sh"
CACHE_DIR="$REPO_ROOT/.cache/dotfiles-defaults-sync"

usage() {
  cat <<'USAGE' >&2
Usage: .agents/skills/dotfiles-defaults-sync/scripts/defaults-audit-sync.sh [--dry-run] [--update-cache] [--domain <domain>]
USAGE
}

update_cache=false
declare -a domain_filters=()

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
    --domain)
      shift
      if [[ $# -eq 0 ]]; then
        echo "error: --domain requires a value" >&2
        usage
        exit 1
      fi
      domain_filters+=("$1")
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -f "$DOMAINS_FILE" ]]; then
  echo "error: domains file not found: $DOMAINS_FILE" >&2
  exit 1
fi

if [[ ! -f "$DEFAULTS_SCRIPT" ]]; then
  echo "error: defaults script not found: $DEFAULTS_SCRIPT" >&2
  exit 1
fi

if [[ "$update_cache" == "true" ]]; then
  mkdir -p "$CACHE_DIR"
fi

python_args=("$DOMAINS_FILE" "$DEFAULTS_SCRIPT" "$CACHE_DIR" "$update_cache")
if (( ${#domain_filters[@]} )); then
  python_args+=("${domain_filters[@]}")
fi

python3 - "${python_args[@]}" <<'PY'
import datetime as dt
import hashlib
import plistlib
import re
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Tuple

MEANINGFUL_KEY_PATTERNS: Dict[str, Tuple[str, ...]] = {
    "NSGlobalDomain": (
        r"^AppleInterfaceStyle$",
        r"^ApplePressAndHoldEnabled$",
        r"^AppleShowAllExtensions$",
        r"^com\.apple\.mouse\.scaling$",
        r"^com\.apple\.trackpad\.scaling$",
        r"^com\.apple\.swipescrolldirection$",
    ),
    "com.apple.menuextra.battery": (
        r"^ShowPercent$",
    ),
    "com.apple.finder": (
        r"^AppleShowAllFiles$",
        r"^ShowPathbar$",
        r"^ShowHardDrivesOnDesktop$",
        r"^FXEnableExtensionChangeWarning$",
    ),
    "com.apple.desktopservices": (
        r"^DSDontWriteNetworkStores$",
        r"^DSDontWriteUSBStores$",
    ),
    "com.apple.driver.AppleBluetoothMultitouch.mouse": (
        r"^MouseButtonMode$",
    ),
    "com.apple.Safari": (
        r"^ShowFullURLInSmartSearchField$",
        r"^HomePage$",
        r"^IncludeDevelopMenu$",
        r"^WebKitDeveloperExtrasEnabledPreferenceKey$",
        r"^com\.apple\.Safari\.ContentPageGroupIdentifier\.WebKit2DeveloperExtrasEnabled$",
    ),
    "com.apple.dt.Xcode": (
        r"^DVTTextIndentTabWidth$",
        r"^DVTTextIndentWidth$",
        r"^DVTTextPageGuideLocation$",
        r"^ShowBuildOperationDuration$",
        r"^DVTTextEditorTrimTrailingWhitespace$",
        r"^DVTTextEditorTrimWhitespaceOnlyLines$",
        r"^DVTTextShowLineNumbers$",
        r"^XCFontAndColorCurrentTheme$",
        r"^XCFontAndColorCurrentDarkTheme$",
    ),
    "com.apple.CoreSimulator": (
        r"^EnableDefaultSetCreation$",
    ),
    "com.apple.dock": (
        r"^tilesize$",
        r"^largesize$",
        r"^magnification$",
        r"^orientation$",
        r"^autohide$",
        r"^show-process-indicators$",
        r"^showhidden$",
        r"^show-recents$",
        r"^expose-group-apps$",
    ),
    "com.apple.WindowManager": (
        r"^EnableTiledWindowMargins$",
        r"^GloballyEnabled$",
        r"^AutoHide$",
    ),
    "com.apple.TextEdit": (
        r"^NSShowAppCentricOpenPanelInsteadOfUntitledFile$",
    ),
    "com.apple.CrashReporter": (
        r"^UseUNC$",
    ),
}


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


def is_supported_proposal_type(value: Any) -> bool:
    return isinstance(value, (bool, int, float, str))


def coerce_scalar(value: Any) -> Tuple[str, Any]:
    if isinstance(value, bool):
        return ("bool", value)
    if isinstance(value, int):
        return ("int", value)
    if isinstance(value, float):
        return ("float", value)
    if isinstance(value, str):
        lowered = value.lower()
        if lowered in {"true", "yes"}:
            return ("bool", True)
        if lowered in {"false", "no"}:
            return ("bool", False)
        if re.fullmatch(r"[-+]?\d+", value):
            try:
                return ("int", int(value))
            except ValueError:
                pass
        if re.fullmatch(r"[-+]?(?:\d+\.\d*|\.\d+)", value):
            try:
                return ("float", float(value))
            except ValueError:
                pass
        return ("string", value)
    return ("other", scalar_to_str(value))


def values_equivalent(script_value: Any, truth_value: Any) -> bool:
    s_type, s_value = coerce_scalar(script_value)
    t_type, t_value = coerce_scalar(truth_value)

    if s_type == t_type and s_value == t_value:
        return True

    if s_type in {"int", "float"} and t_type in {"int", "float"}:
        return float(s_value) == float(t_value)

    return False


def flatten(obj: Any, path: str, out: Dict[str, Tuple[Any, str]]) -> None:
    if isinstance(obj, dict):
        if not obj and path:
            out[path] = ({}, "{}")
            return
        for key in sorted(obj.keys(), key=lambda x: str(x)):
            child = f"{path}:{key}" if path else f":{key}"
            flatten(obj[key], child, out)
        return

    if isinstance(obj, list):
        if not obj and path:
            out[path] = ([], "[]")
            return
        for idx, item in enumerate(obj):
            child = f"{path}:{idx}"
            flatten(item, child, out)
        return

    if path:
        out[path] = (obj, scalar_to_str(obj))


def format_path(path: str) -> str:
    if not path:
        return "(root)"
    tokens = [token for token in path.split(":") if token]
    if not tokens:
        return "(root)"
    out: List[str] = []
    for token in tokens:
        if re.fullmatch(r"\d+", token):
            if out:
                out[-1] = f"{out[-1]}[{token}]"
            else:
                out.append(f"[{token}]")
        else:
            out.append(token)
    return ".".join(out)


def parse_script_value(rest: List[str]) -> Tuple[Any, str]:
    if not rest:
        return None, "unsupported"

    flag = rest[0]
    values = rest[1:] if flag.startswith("-") else rest

    if not values:
        return None, "unsupported"

    raw = values[0] if len(values) == 1 else " ".join(values)

    if flag == "-bool":
        lowered = raw.lower()
        if lowered in {"true", "yes", "1"}:
            return True, "bool"
        if lowered in {"false", "no", "0"}:
            return False, "bool"
        return None, "unsupported"
    if flag == "-int":
        try:
            return int(raw), "int"
        except ValueError:
            return None, "unsupported"
    if flag == "-float":
        try:
            return float(raw), "float"
        except ValueError:
            return None, "unsupported"
    if flag == "-string":
        return raw, "string"

    if flag.startswith("-"):
        return None, "unsupported"

    # Untyped values can still persist as typed scalars.
    lowered = raw.lower()
    if lowered in {"true", "yes"}:
        return True, "bool"
    if lowered in {"false", "no"}:
        return False, "bool"

    if re.fullmatch(r"[-+]?\d+", raw):
        try:
            return int(raw), "int"
        except ValueError:
            pass

    if re.fullmatch(r"[-+]?(?:\d+\.\d*|\.\d+)", raw):
        try:
            return float(raw), "float"
        except ValueError:
            pass

    return raw, "string"


def build_write_command(domain: str, key: str, value: Any) -> str:
    domain_q = shlex.quote(domain)
    key_q = shlex.quote(key)
    if isinstance(value, bool):
        return f"defaults write {domain_q} {key_q} -bool {'true' if value else 'false'}"
    if isinstance(value, int):
        return f"defaults write {domain_q} {key_q} -int {value}"
    if isinstance(value, float):
        return f"defaults write {domain_q} {key_q} -float {format(value, '.17g')}"
    if isinstance(value, str):
        return f"defaults write {domain_q} {key_q} -string {shlex.quote(value)}"
    raise ValueError("unsupported command value type")


def load_baseline(path: Path) -> Any:
    with path.open("rb") as f:
        return plistlib.load(f)


def save_baseline(path: Path, raw: bytes) -> None:
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_bytes(raw)
    tmp.replace(path)


def is_meaningful_key(domain: str, key: str) -> bool:
    patterns = MEANINGFUL_KEY_PATTERNS.get(domain, ())
    return any(re.search(pattern, key) for pattern in patterns)


def parse_defaults_script(path: Path) -> Dict[Tuple[str, str], Dict[str, Any]]:
    declared: Dict[Tuple[str, str], Dict[str, Any]] = {}
    lines = path.read_text().splitlines()

    for idx, line in enumerate(lines, start=1):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue

        try:
            tokens = shlex.split(stripped, posix=True)
        except ValueError:
            continue

        if not tokens:
            continue

        domain = None
        key = None
        value_tokens: List[str] = []

        if len(tokens) >= 5 and tokens[0] == "defaults" and tokens[1] == "write":
            cursor = 2
            if tokens[cursor] == "-g":
                domain = "NSGlobalDomain"
                cursor += 1
            else:
                domain = tokens[cursor]
                cursor += 1

            if cursor < len(tokens):
                key = tokens[cursor]
                cursor += 1
                value_tokens = tokens[cursor:]

        elif len(tokens) >= 3 and tokens[0] == "safari_defaults_write":
            domain = "com.apple.Safari"
            key = tokens[1]
            value_tokens = tokens[2:]

        if not domain or not key:
            continue

        value, value_type = parse_script_value(value_tokens)
        if value_type == "unsupported":
            continue

        declared[(domain, key)] = {
            "line": idx,
            "value": value,
            "canonical": scalar_to_str(value),
            "type": value_type,
        }

    return declared


def main() -> int:
    domains_file = Path(sys.argv[1])
    defaults_script = Path(sys.argv[2])
    cache_dir = Path(sys.argv[3])
    update_cache = sys.argv[4].lower() == "true"
    filters = set(sys.argv[5:])

    all_domains = [
        line.strip()
        for line in domains_file.read_text().splitlines()
        if line.strip() and not line.strip().startswith("#")
    ]
    domains = [d for d in all_domains if not filters or d in filters]

    if filters:
        unknown = sorted(filters - set(all_domains))
        if unknown:
            print(f"error: unknown domain(s): {', '.join(unknown)}", file=sys.stderr)
            return 1

    declared = parse_defaults_script(defaults_script)

    summary: List[Dict[str, Any]] = []
    top_priority: List[Dict[str, Any]] = []
    nested_changes: List[Dict[str, Any]] = []
    mismatches: List[Dict[str, Any]] = []
    missing: List[Dict[str, Any]] = []
    commands: List[str] = []
    notes: List[str] = []

    changed_root_keys = set()
    had_error = False

    for domain in domains:
        export = subprocess.run(["defaults", "export", domain, "-"], capture_output=True)

        if export.returncode != 0:
            had_error = True
            err = export.stderr.decode().strip() or "unknown error"
            summary.append(
                {
                    "domain": domain,
                    "status": "error",
                    "message": err,
                    "changed_root": 0,
                    "added_root": 0,
                    "removed_root": 0,
                    "nested": 0,
                }
            )
            continue

        current_raw = export.stdout
        current_obj = plistlib.loads(current_raw)

        baseline_path = cache_dir / f"defaults.{domain}.baseline.plist"
        baseline_exists = baseline_path.exists()
        baseline_obj = None
        baseline_valid = False

        if baseline_exists:
            try:
                baseline_obj = load_baseline(baseline_path)
                baseline_valid = True
            except Exception:
                baseline_valid = False

        if not baseline_exists:
            notes.append(f"{domain}: baseline missing")
            if update_cache:
                save_baseline(baseline_path, current_raw)
                notes.append(f"{domain}: baseline created")
            else:
                notes.append(f"{domain}: run with --update-cache to create baseline")
        elif not baseline_valid:
            notes.append(f"{domain}: baseline invalid")
            if update_cache:
                save_baseline(baseline_path, current_raw)
                notes.append(f"{domain}: baseline recreated")
            else:
                notes.append(f"{domain}: run with --update-cache to recreate baseline")

        current_flat: Dict[str, Tuple[Any, str]] = {}
        flatten(current_obj, "", current_flat)

        baseline_flat: Dict[str, Tuple[Any, str]] = {}
        has_comparable_baseline = baseline_exists and baseline_valid and baseline_obj is not None
        if has_comparable_baseline:
            flatten(baseline_obj, "", baseline_flat)
        else:
            baseline_flat = dict(current_flat)

        changed_root = 0
        added_root = 0
        removed_root = 0
        nested = 0

        all_paths = sorted(set(baseline_flat) | set(current_flat))
        for path in all_paths:
            baseline_val = baseline_flat.get(path)
            current_val = current_flat.get(path)

            if baseline_val is not None and current_val is not None:
                if baseline_val[1] == current_val[1]:
                    continue
                kind = "CHANGED"
            elif current_val is not None:
                kind = "ADDED"
            else:
                kind = "REMOVED"

            is_root = path.startswith(":") and path.count(":") == 1

            if is_root:
                key = path[1:]
                if kind == "CHANGED":
                    changed_root += 1
                elif kind == "ADDED":
                    added_root += 1
                else:
                    removed_root += 1

                if kind in {"CHANGED", "ADDED"} and current_val is not None:
                    truth_value = current_val[0]
                    supported_for_proposal = is_supported_proposal_type(truth_value)
                    if supported_for_proposal:
                        changed_root_keys.add((domain, key))
                    in_script = (domain, key) in declared
                    top_priority.append(
                        {
                            "domain": domain,
                            "key": key,
                            "kind": kind,
                            "old": baseline_val[1] if baseline_val else "",
                            "new": current_val[1],
                            "in_script": in_script,
                            "supported_for_proposal": supported_for_proposal,
                        }
                    )
            else:
                nested += 1
                nested_changes.append(
                    {
                        "domain": domain,
                        "path": format_path(path),
                        "kind": kind,
                        "old": baseline_val[1] if baseline_val else "",
                        "new": current_val[1] if current_val else "",
                    }
                )

        root_truth: Dict[str, Any] = {}
        if isinstance(current_obj, dict):
            for key, value in current_obj.items():
                if is_supported_proposal_type(value):
                    root_truth[key] = value

        for key, truth_value in sorted(root_truth.items()):
            k = (domain, key)
            truth_canon = scalar_to_str(truth_value)
            if k in declared:
                if not values_equivalent(declared[k]["value"], truth_value):
                    mismatches.append(
                        {
                            "domain": domain,
                            "key": key,
                            "line": declared[k]["line"],
                            "script": declared[k]["canonical"],
                            "truth": truth_canon,
                            "truth_value": truth_value,
                        }
                    )
            else:
                if k in changed_root_keys or is_meaningful_key(domain, key):
                    missing.append(
                        {
                            "domain": domain,
                            "key": key,
                            "truth": truth_canon,
                            "truth_value": truth_value,
                        }
                    )

        if update_cache:
            save_baseline(baseline_path, current_raw)

        summary.append(
            {
                "domain": domain,
                "status": "ok",
                "changed_root": changed_root,
                "added_root": added_root,
                "removed_root": removed_root,
                "nested": nested,
                "message": "",
            }
        )

    print("# macOS Defaults Audit")
    print(f"Generated: {dt.datetime.now().isoformat(timespec='seconds')}")
    print(f"Mode: {'update-cache' if update_cache else 'dry-run'}")
    print()

    print("## Drift Summary by Domain")
    if not summary:
        print("- No domains configured.")
    else:
        for item in summary:
            if item["status"] == "error":
                print(f"- `{item['domain']}`: error (`{item['message']}`)")
            else:
                print(
                    f"- `{item['domain']}`: changed_root={item['changed_root']} added_root={item['added_root']} "
                    f"removed_root={item['removed_root']} nested_changes={item['nested']}"
                )
    print()

    print("## Top Priority: Changed/Added Root Keys")
    if not top_priority:
        print("- No changed/added root keys detected.")
        if nested_changes:
            print("- Nested changes were detected. See `Nested Changes (Informational)` below.")
    else:
        mapped_priority = sorted(
            [item for item in top_priority if item["in_script"]],
            key=lambda x: (x["domain"], x["key"]),
        )
        unmapped_priority = sorted(
            [item for item in top_priority if not item["in_script"]],
            key=lambda x: (x["domain"], x["key"]),
        )

        print("### Already Mapped in defaults.sh (Highest Priority)")
        if not mapped_priority:
            print("- None")
        else:
            for item in mapped_priority:
                print(
                    f"- `{item['domain']} {item['key']}` ({item['kind']}): old={item['old']} new={item['new']} "
                    f"proposal_supported={'yes' if item['supported_for_proposal'] else 'no'}"
                )

        print("### Not Mapped in defaults.sh (Review for Addition)")
        if not unmapped_priority:
            print("- None")
        else:
            for item in unmapped_priority:
                print(
                    f"- `{item['domain']} {item['key']}` ({item['kind']}): old={item['old']} new={item['new']} "
                    f"proposal_supported={'yes' if item['supported_for_proposal'] else 'no'}"
                )
    print()

    print("## Nested Changes (Informational)")
    if not nested_changes:
        print("- No nested changes detected.")
    else:
        for item in sorted(nested_changes, key=lambda x: (x["domain"], x["path"])):
            print(
                f"- `{item['domain']} {item['path']}` ({item['kind']}): old={item['old']} new={item['new']}"
            )
    print()

    print("## defaults.sh Keys With Mismatched Values")
    if not mismatches:
        print("- No mismatches found.")
    else:
        for item in sorted(mismatches, key=lambda x: (x["domain"], x["key"])):
            print(
                f"- `{item['domain']} {item['key']}` line {item['line']}: defaults.sh={item['script']} current={item['truth']}"
            )
            commands.append(build_write_command(item["domain"], item["key"], item["truth_value"]))
    print()

    print("## Suggested Root Keys Missing From defaults.sh")
    if not missing:
        print("- No meaningful missing root-level scalar keys found.")
    else:
        for item in sorted(missing, key=lambda x: (x["domain"], x["key"])):
            print(f"- `{item['domain']} {item['key']}` current={item['truth']}")
            commands.append(build_write_command(item["domain"], item["key"], item["truth_value"]))
    print()

    print("## Suggested Commands (Copy/Paste)")
    if not commands:
        print("- No commands suggested.")
    else:
        unique_commands = []
        seen = set()
        for cmd in commands:
            if cmd not in seen:
                seen.add(cmd)
                unique_commands.append(cmd)
        print("```bash")
        for cmd in unique_commands:
            print(cmd)
        print("```")
    print()

    print("## Notes")
    if not notes:
        print("- None")
    else:
        for note in notes:
            print(f"- {note}")

    actionable = bool(mismatches or missing)
    if had_error:
        return 1
    if actionable:
        return 2
    return 0


raise SystemExit(main())
PY
