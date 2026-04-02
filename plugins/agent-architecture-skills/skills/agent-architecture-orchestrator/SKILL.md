---
name: agent-architecture-orchestrator
description: Use when designing, reviewing, or refactoring an agent system that spans two or more architecture domains such as runtime, surfaces, tooling/protocols, or multi-agent orchestration, especially when the request is broad, ambiguous, or cross-cutting.
---

# Agent Architecture Orchestrator

## Overview

This is the control skill for whole-system agent architecture work. It does not replace the domain skills. It identifies task type and scope, selects all relevant sub-skills, resolves ownership conflicts, and produces one merged architecture conclusion with a clean implementation order.

## When to Use

Use this skill when the request:

- designs a full agent platform from scratch
- reviews or refactors an existing agent system across multiple domains
- mixes runtime, surface, protocol/tooling, and multi-agent concerns in one conversation
- is broad or ambiguous enough that the correct first domain is not obvious
- asks for one coherent architecture and phased design order instead of an isolated subsystem answer

## Do Not Use For

Do not use this skill when the problem is clearly isolated to exactly one domain:

- single-agent turn loop or runtime kernel
- shared kernel across CLI/API/SDK/batch surfaces
- tool registry, MCP/connector integration, permission policy, or protocol reconnect
- manager-worker, swarm, teammates, or background-task orchestration

For single-domain requests, hand off directly to the owning skill.

## Core Workflow

Follow this order:

1. Classify the task as `greenfield`, `review`, or `refactor`.
2. Classify the impact domains: `runtime`, `surface`, `protocol`, `multi-agent`.
3. If the request is single-domain, route out and stop acting as orchestrator.
4. If the request is mixed-domain, select all relevant sub-skills using the routing matrix.
5. Merge results using ownership boundaries, fixed priority, and deterministic section keys.
6. Rewrite one final cross-domain conclusion, one merged risk picture, and one implementation order.

Never answer a cross-cutting request by improvising a new all-in-one architecture taxonomy. Reuse the existing domain boundaries.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Layered Diagram`
- `Responsibility Table`
- `Connection Table`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Produce `Dynamic Flow` only when a cross-domain interaction genuinely needs it. Produce `Migration / Compatibility / Rollback Plan` whenever the task is `review` or `refactor`.

Use [routing-matrix.md](./references/routing-matrix.md) for dispatch, [output-contract.md](./references/output-contract.md) for merge rules, and [borderline-nouns.md](./references/borderline-nouns.md) for the most common ownership confusions.

## Anti-pattern Checks

At minimum, check for these failures:

- a mixed-domain request is answered as if it were single-domain
- two skills define the same concept with conflicting ownership
- the merged result keeps duplicate modules or duplicate lifecycle concepts under different names
- implementation order ignores domain dependencies and mixes later adapters before earlier kernel or protocol decisions
- refactor output gives an ideal target state but no migration, compatibility, or rollback path

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` for single-agent kernel definition.
- To `agent-surface-and-adapters` for session, transcript, and surface adapter design.
- To `agent-protocol-and-tooling` for tool systems, protocol clients, permission policy, and normalized state.
- To `multi-agent-architecture` for task lifecycle, agent lifecycle, orchestration, and host placement.

When multiple domains remain active, stay in orchestrator mode and merge instead of delegating the final answer away.

## Trigger Examples

- “Help me design an agent platform from scratch”
- “How should we refactor this agent system end to end?”
- “We need CLI/API/batch, MCP, and multi-agent support. What should we design first?”
- “Our agent project is getting messy. I want a whole-system architecture review.”

## Not-this-skill Examples

- “How should I design a single-agent query loop?”
- “Who should own session and transcript state?”
- “How should registry and permission be split once MCP tools are integrated?”
- “Where should manager-worker task state live?”
