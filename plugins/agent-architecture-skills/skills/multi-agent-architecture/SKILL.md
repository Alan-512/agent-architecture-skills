---
name: multi-agent-architecture
description: Use when designing, reviewing, or refactoring a manager-worker, teammate, swarm, or background-task agent system, especially when task state, agent lifecycle, host placement, or inter-agent communication boundaries are unclear.
---

# Multi Agent Architecture

## Overview

Design multi-agent systems as separate but connected planes: orchestration, execution, task state, and host or backend placement. This skill owns task lifecycle, task state, communication topology, and worker hosting choices. It does not redefine the single-agent kernel or protocol permission policy.

## When to Use

Use this skill when the main problem is:

- designing manager-worker, teammate, swarm, or background-task systems
- deciding where task state and task lifecycle should live
- separating agent runtime lifecycle from orchestration state
- choosing how agents communicate, report progress, hand off results, or request permission
- deciding whether workers run in-process, process-isolated, pane-based, containerized, or remote backends

Treat `remote worker` as multi-agent topology or host placement. Do not use this skill to define a `remote executor` that behaves like an external capability or tool backend; that belongs to `agent-protocol-and-tooling`.

## Do Not Use For

Do not use this skill when the main problem is:

- defining a single-agent turn loop, tool-result reinjection, or stop and recovery logic
- defining protocol-level permission evaluation, tool registry shape, reconnect, or concurrency policy
- defining transcript ownership, session ownership, or output normalization for CLI, API, or SDK surfaces
- routing a whole system across multiple architecture domains

For mixed-domain requests, hand off to `agent-architecture-orchestrator`.

## Core Workflow

Follow this order:

1. For `review` or `refactor`, start with evidence-first intake: inventory the actual task model, worker topology, current scale and parallelism needs, durable task artifacts, and unknowns before proposing changes.
2. Define why multiple agents exist: decomposition, parallelism, isolation, background execution, or role specialization.
3. Split the design into four planes: orchestration, execution, task state, and host or backend.
4. Define task lifecycle separately from worker lifecycle.
5. Define inter-agent communication, result handoff, heartbeat, cancellation, and permission-request routing.
6. Define host placement and failure boundaries without moving orchestration semantics into infrastructure.

Never collapse task state, agent lifecycle, and permission decision into one generic manager layer.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Observed Multi-agent Topology`
- `Evidence`
- `Architecture Fit Verdict`
- `Tradeoff Assessment`
- `Responsibility Table`
- `Connection Table`
- `Unknowns / Confidence`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Usually produce both `Layered Diagram` and `Dynamic Flow`. Prefer a `layered` overview plus either a `state-machine` for task and worker lifecycle or a `sequence` for manager-worker coordination.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [four-plane-model.md](./references/four-plane-model.md) for the output skeleton and [agent-lifecycle-template.md](./references/agent-lifecycle-template.md) for lifecycle review.

## Anti-pattern Checks

At minimum, check for these failures:

- task state is stored only inside worker memory
- task lifecycle and agent runtime lifecycle are treated as the same state machine
- host placement decisions are mixed into orchestration semantics
- result aggregation is pushed down into workers instead of orchestration
- permission approval is decided by the manager instead of being routed to the owner policy layer
- a single-agent or lightly parallel system is pushed into manager-worker abstractions without evidence that the current product actually needs them

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` when worker kernels or turn semantics are still undefined.
- To `agent-protocol-and-tooling` when permission evaluation, tool concurrency, connector state, or remote execution protocol rules are still undefined.
- To `agent-surface-and-adapters` when session ownership, transcript ownership, or user-facing output surfaces are still unclear.
- To `agent-state-and-persistence` when durable task state, checkpointing, replayability, queue semantics, or recovery contracts are still undefined.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “How should a manager-worker multi-agent system be decomposed?”
- “How should background tasks, parallel workers, and result aggregation be layered?”
- “Where should task state and worker lifecycle live?”
- “How should teammates communicate and hand off results?”

## Not-this-skill Examples

- “How should a single-agent query loop be designed?”
- “How should MCP permission, reconnect, and tool concurrency be designed?”
- “How should CLI, API, and SDK share one kernel?”
- “Help me design an entire agent platform architecture”
