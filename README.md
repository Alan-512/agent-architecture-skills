# Agent Architecture Skills

Chinese version: [README.zh-CN.md](./README.zh-CN.md)

Reusable architecture skills for Codex and Claude Code when designing, reviewing, or refactoring agent systems.

This repository packages a small, opinionated skill set distilled from Claude Code style agent architecture work. The focus is not “how to write one prompt”, but how to reason about agent systems with stable boundaries:

- runtime kernel vs adapters
- protocol/tooling vs orchestration
- persisted state vs UI state
- single-agent execution vs future multi-agent expansion

## Who This Is For

Use this repository if you are building or reviewing:

- coding agents
- research agents
- content creation agents
- image or video generation agents
- workflow agents with tools, providers, or MCP-style integrations

Do not use this as a heavy framework template for tiny single-shot apps with no state, no tools, and no execution lifecycle.

## Included Skills

| Skill | Purpose |
| --- | --- |
| `agent-architecture-orchestrator` | Cross-domain entrypoint for whole-system architecture design, review, and refactor |
| `agent-runtime-architecture` | Single-agent turn loop, message state, tool-result reinjection, stop/recovery |
| `agent-surface-and-adapters` | Shared kernel across CLI/API/SDK/batch/remote surfaces |
| `multi-agent-architecture` | Manager-worker, teammates, task state, lifecycle, host placement |
| `agent-protocol-and-tooling` | Tool registry, model/provider edges, MCP/connectors, permission/policy, protocol state |

## Recommended Usage

Start with `agent-architecture-orchestrator` when:

- the request spans more than one domain
- you are not sure which skill should own the problem
- you want one merged architecture conclusion

Go directly to a domain skill when the problem is clearly isolated:

- turn loop or tool reinjection -> `agent-runtime-architecture`
- CLI/API/SDK ownership -> `agent-surface-and-adapters`
- tool registry / provider / protocol -> `agent-protocol-and-tooling`
- manager-worker / swarm / background tasks -> `multi-agent-architecture`

## Repository Layout

```text
agent-architecture-skills/
  README.md
  LICENSE
  scripts/
    install.sh
  skills/
    agent-architecture-orchestrator/
    agent-runtime-architecture/
    agent-surface-and-adapters/
    multi-agent-architecture/
    agent-protocol-and-tooling/
```

Each skill ships with its own `SKILL.md` and any supporting `references/` files it needs.

## Installation

### Codex global install

```bash
bash scripts/install.sh codex
```

This copies the skills into `~/.codex/skills`.

### Claude Code global install

```bash
bash scripts/install.sh claude
```

This copies the skills into `~/.claude/skills`.

### Install into a project

```bash
bash scripts/install.sh project /path/to/your/repo
```

This copies the skills into `/path/to/your/repo/.claude/skills`.

## Manual Installation

If you prefer to copy files yourself, copy the five folders inside `skills/` into one of:

- `~/.codex/skills`
- `~/.claude/skills`
- `<repo>/.claude/skills`

## Design Principles

This skill set assumes:

- the runtime kernel should be designed before surface wrappers
- tool execution is part of the runtime loop, not an afterthought
- provider/protocol details should not leak into the runtime core
- UI state and persisted execution state should not be collapsed into one vague store
- multi-agent systems need explicit task state and lifecycle ownership

## Validation Basis

These skills were exercised against a real image-generation agent project and refined through multiple review passes before packaging.

## License

MIT
