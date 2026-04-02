#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT_DIR/skills"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install.sh codex
  bash scripts/install.sh claude
  bash scripts/install.sh project /path/to/repo

Targets:
  codex    Install into ~/.codex/skills
  claude   Install into ~/.claude/skills
  project  Install into <repo>/.claude/skills
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  codex)
    TARGET_DIR="$HOME/.codex/skills"
    ;;
  claude)
    TARGET_DIR="$HOME/.claude/skills"
    ;;
  project)
    if [[ $# -lt 2 ]]; then
      echo "Missing repository path for project install." >&2
      usage
      exit 1
    fi
    TARGET_DIR="$2/.claude/skills"
    ;;
  *)
    echo "Unknown install target: $1" >&2
    usage
    exit 1
    ;;
esac

mkdir -p "$TARGET_DIR"

for skill_dir in "$SKILLS_DIR"/*; do
  skill_name="$(basename "$skill_dir")"
  rm -rf "$TARGET_DIR/$skill_name"
  cp -R "$skill_dir" "$TARGET_DIR/"
  echo "Installed $skill_name -> $TARGET_DIR/$skill_name"
done

echo "Done."
