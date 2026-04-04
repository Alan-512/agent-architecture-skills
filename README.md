# Agent Architecture Skills

Chinese version: [简体中文](./README.zh-CN.md)

Reusable architecture skills for designing, reviewing, or refactoring agent systems.

This repository packages a small, opinionated skill set for reasoning about agent systems with stable boundaries. The focus is not “how to write one prompt”, but how to design and review agent systems with explicit ownership:

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
| `agent-state-and-persistence` | Write model vs read model boundaries, persistence ownership, replay/recovery, projection rebuild strategy |

## Recommended Usage

Start with `agent-architecture-orchestrator` when:

- the request spans more than one domain
- you are not sure which skill should own the problem
- you want one merged architecture conclusion

The orchestrator also includes an architecture review gate plus a full review checklist reference for validating cross-domain proposals as a general review framework, not as a fixed component inventory.

Go directly to a domain skill when the problem is clearly isolated:

- turn loop or tool reinjection -> `agent-runtime-architecture`
- CLI/API/SDK ownership -> `agent-surface-and-adapters`
- tool registry / provider / protocol -> `agent-protocol-and-tooling`
- write model / read model / transcript durability / recovery -> `agent-state-and-persistence`
- manager-worker / swarm / background tasks -> `multi-agent-architecture`

## Examples

- `agent-architecture-orchestrator`: “Help me review the architecture of this agent platform end to end.”
- `agent-runtime-architecture`: “How should tool results be reinjected into the next turn?”
- `agent-surface-and-adapters`: “How should CLI and API share one agent kernel?”
- `multi-agent-architecture`: “How should a manager-worker system split task state and worker lifecycle?”
- `agent-protocol-and-tooling`: “Where should provider clients, permission, timeout, retry, and concurrency live?”
- `agent-state-and-persistence`: “Which state is the write model, which is a projection, and how should recovery rebuild read models?”

Longer reusable examples live in [examples/](./examples/README.md).

## Repository Layout

```text
agent-architecture-skills/
  .agents/plugins/marketplace.json
  README.md
  LICENSE
  examples/
  plugins/
    agent-architecture-skills/
  scripts/
    install.sh
  skills/
    agent-architecture-orchestrator/
    agent-runtime-architecture/
    agent-surface-and-adapters/
    multi-agent-architecture/
    agent-protocol-and-tooling/
    agent-state-and-persistence/
```

Each skill ships with its own `SKILL.md` and any supporting `references/` files it needs.

The repository now also includes a repo-local Codex plugin scaffold under `plugins/agent-architecture-skills/` plus `.agents/plugins/marketplace.json`, so the same skills can be packaged in the distribution model Codex prefers for reusable public integrations.

## Installation

### Codex global install

```bash
bash scripts/install.sh codex
```

This copies the skills into `~/.agents/skills`.

### Claude Code global install

```bash
bash scripts/install.sh claude
```

This copies the skills into `~/.claude/skills`.

### Codex project install

```bash
bash scripts/install.sh project-codex /path/to/your/repo
```

This copies the skills into `/path/to/your/repo/.agents/skills`.

### Claude Code project install

```bash
bash scripts/install.sh project-claude /path/to/your/repo
```

This copies the skills into `/path/to/your/repo/.claude/skills`.

## Use As A Local Codex Plugin

```bash
bash scripts/install-plugin.sh
```

This installs the plugin to `~/plugins/agent-architecture-skills` and creates or updates `~/.agents/plugins/marketplace.json` with a local marketplace entry for Codex.

After installation, restart Codex so it can discover the new local plugin.

### Remove The Local Codex Plugin

```bash
bash scripts/uninstall-plugin.sh
```

This removes `~/plugins/agent-architecture-skills` and deletes the plugin entry from `~/.agents/plugins/marketplace.json`.

After removal, restart Codex so it unloads the local plugin.

## Manual Installation

If you prefer to copy files yourself, copy the skill folders inside `skills/` into one of:

- `~/.agents/skills`
- `<repo>/.agents/skills`
- `~/.claude/skills`
- `<repo>/.claude/skills`

## Official Compatibility

As of April 2, 2026:

- Claude Code officially supports personal skills in `~/.claude/skills` and project skills in `.claude/skills`.
- Codex officially documents user-level skills in `~/.agents/skills` and repo-level skills in `.agents/skills`.
- OpenAI recommends direct skill folders for local authoring and repo-scoped workflows. For reusable public distribution in Codex, plugins are the preferred packaging model.

This repository currently ships direct skill folders for portability and local installation. If you want first-class reusable distribution in Codex, package these skills as a plugin next.

This repository now includes that plugin-ready layout, while keeping the root `skills/` directory for direct installation.

## Design Principles

This skill set assumes:

- the runtime kernel should be designed before surface wrappers
- tool execution is part of the runtime loop, not an afterthought
- provider/protocol details should not leak into the runtime core
- UI state and persisted execution state should not be collapsed into one vague store
- multi-agent systems need explicit task state and lifecycle ownership

## Validation Basis

These skills were exercised against multiple real agent codebases, including image-generation, phone-automation, and broader agent-platform architectures, and refined through repeated review passes before packaging.

## License

MIT
