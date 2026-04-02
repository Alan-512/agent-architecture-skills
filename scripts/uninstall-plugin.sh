#!/usr/bin/env bash

set -euo pipefail

PLUGIN_NAME="agent-architecture-skills"
TARGET_PLUGIN_DIR="$HOME/plugins/$PLUGIN_NAME"
MARKETPLACE_PATH="$HOME/.agents/plugins/marketplace.json"

rm -rf "$TARGET_PLUGIN_DIR"

if [[ -f "$MARKETPLACE_PATH" ]]; then
  python3 - <<'PY'
import json
import os
from pathlib import Path

plugin_name = "agent-architecture-skills"
marketplace_path = Path(os.path.expanduser("~/.agents/plugins/marketplace.json"))

with marketplace_path.open("r", encoding="utf-8") as f:
    data = json.load(f)

plugins = data.get("plugins", [])
data["plugins"] = [p for p in plugins if p.get("name") != plugin_name]

with marketplace_path.open("w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
fi

echo "Removed plugin directory: $TARGET_PLUGIN_DIR"
echo "Updated marketplace file: $MARKETPLACE_PATH"
echo "Restart Codex to unload the local plugin."
