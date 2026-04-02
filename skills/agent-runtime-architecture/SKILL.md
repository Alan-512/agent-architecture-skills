---
name: agent-runtime-architecture
description: Use when designing, reviewing, or refactoring a single-agent runtime kernel such as a query loop, turn loop, message state machine, tool-result reinjection path, or stop/recovery behavior.
---

# Agent Runtime Architecture

## Overview

Design the single-agent kernel before touching surfaces, protocol integrations, or multi-agent orchestration. The runtime owns turn semantics: input normalization, message-state evolution, tool-loop reinjection, and stop or recovery decisions.

## When to Use

Use this skill when the problem is primarily about:

- `query()` / `runTurn()` / planner-executor loop design
- message normalization before model invocation
- tool call detection, execution handoff, and `tool_result` reinjection
- continue, stop, turn-level budget, or recovery rules
- reviewing whether runtime logic leaked into adapters or tool clients

## Do Not Use For

Do not use this skill when the main problem is:

- CLI, API, SDK, batch, or remote surface design
- MCP, connector, permission policy, or protocol reconnect
- manager-worker, teammate, swarm, or task lifecycle design
- whole-system routing across multiple architecture domains

For mixed-domain requests, hand off to `agent-architecture-orchestrator`.

## Core Workflow

Follow this order:

1. Define the runtime scope and terminal result for one turn.
2. Define canonical turn inputs, normalized message forms, and state transitions.
3. Define the tool loop: trigger point, execution handoff, reinjection path, and failure handling.
4. Define stop, continue, turn-level recovery, and budget rules.
5. Draw the kernel boundary: what runtime owns, what adapters or protocol layers may only feed in.

Never start from directory structure or helper functions. Start from state transitions.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Responsibility Table`
- `Connection Table`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Produce `Dynamic Flow` for nearly all uses of this skill. Prefer a `state-machine` or `runtime-flow`.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [turn-loop-template.md](./references/turn-loop-template.md) for the output skeleton and [runtime-anti-patterns.md](./references/runtime-anti-patterns.md) for the review checklist.

## Anti-pattern Checks

At minimum, check for these failures:

- input normalization happens after model invocation
- tool execution is treated as an external callback instead of part of the turn loop
- tool results bypass runtime state and are written straight into adapters
- turn-level stop or recovery rules are split across multiple layers
- runtime owns transcript persistence or UI protocol details

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-surface-and-adapters` when the kernel must be exposed through CLI, API, SDK, or remote surfaces.
- To `agent-protocol-and-tooling` when external tool descriptors, model/provider clients, permission policy, per-call timeout or retry policy, concurrency policy, or protocol state are still undefined.
- To `multi-agent-architecture` when the design adds manager-worker, teammates, background tasks, or task lifecycle concerns.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “Help me design the query loop for an agent”
- “How should tool results be reinjected into the next-turn context?”
- “Why is my single-agent runtime getting more tangled over time?”
- “Where should stop / continue / retry live?”

## Not-this-skill Examples

- “How should CLI and API share one kernel?”
- “How should permission be unified once MCP tools are integrated?”
- “How should a manager-worker multi-agent system be decomposed?”
- “Help me design an entire agent platform architecture”
