#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_NAME="agent-architecture-skills"
PLUGIN_SRC_DIR="$ROOT_DIR/plugins/$PLUGIN_NAME"
TARGET_PLUGIN_DIR="$HOME/plugins/$PLUGIN_NAME"
MARKETPLACE_DIR="$HOME/.agents/plugins"
MARKETPLACE_PATH="$MARKETPLACE_DIR/marketplace.json"

if [[ ! -d "$PLUGIN_SRC_DIR" ]]; then
  echo "Plugin source directory not found: $PLUGIN_SRC_DIR" >&2
  exit 1
fi

mkdir -p "$HOME/plugins" "$MARKETPLACE_DIR"
rm -rf "$TARGET_PLUGIN_DIR"
cp -R "$PLUGIN_SRC_DIR" "$TARGET_PLUGIN_DIR"

python3 - <<'PY'
import json
import os
from pathlib import Path

plugin_name = "agent-architecture-skills"
marketplace_path = Path(os.path.expanduser("~/.agents/plugins/marketplace.json"))

default_root = {
    "name": "local-plugins",
    "interface": {
        "displayName": "Local Plugins"
    },
    "plugins": []
}

entry = {
    "name": plugin_name,
    "source": {
        "source": "local",
        "path": f"./plugins/{plugin_name}"
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
    },
    "category": "Developer Tools"
}

if marketplace_path.exists():
    with marketplace_path.open("r", encoding="utf-8") as f:
        data = json.load(f)
else:
    data = default_root

data.setdefault("name", "local-plugins")
data.setdefault("interface", {})
data["interface"].setdefault("displayName", "Local Plugins")
plugins = data.setdefault("plugins", [])

filtered = [p for p in plugins if p.get("name") != plugin_name]
filtered.append(entry)
data["plugins"] = filtered

with marketplace_path.open("w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY

echo "Installed plugin to $TARGET_PLUGIN_DIR"
echo "Updated marketplace at $MARKETPLACE_PATH"
echo "Restart Codex to pick up the local plugin."
