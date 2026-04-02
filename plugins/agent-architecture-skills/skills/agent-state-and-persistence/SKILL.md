---
name: agent-state-and-persistence
description: Use when designing, reviewing, or refactoring an agent system's durable state architecture, especially when write models, read models, persistence ownership, snapshotting, replayability, recovery, queue semantics, or transcript durability are unclear.
---

# Agent State And Persistence

## Overview

Design durable state as a first-class architecture domain. This skill owns write models, read models, persistence boundaries, recovery strategy, replayability, checkpointing, queue or event-log semantics, and how transcripts or projections are restored after refresh, crash, or restart.

## When to Use

Use this skill when the main problem is:

- deciding what the write model is and who may mutate it
- separating write models from read models, projections, or caches
- defining snapshot persistence, queue semantics, event-log semantics, or replayability
- deciding whether transcripts, task views, or normalized state rebuild from durable state or persist as projections
- reviewing recovery behavior after restart, interruption, failover, or client reconnect
- reviewing whether persistence is acting as a passive store or as a hidden lifecycle owner

## Do Not Use For

Do not use this skill when the main problem is:

- defining the single-agent turn loop or tool-result reinjection semantics
- defining protocol-level retries, provider clients, or connector reconnect behavior
- defining user-facing surface ownership for CLI, API, or SDK output normalization
- defining manager-worker orchestration or agent host placement without a durable-state question
- routing a whole system across multiple architecture domains

For mixed-domain requests, hand off to `agent-architecture-orchestrator`.

## Core Workflow

Follow this order:

1. For `review` or `refactor`, start with evidence-first intake: inventory durable stores, write paths, read paths, current recovery expectations, and unknowns before proposing changes.
2. Identify the write models, read models, projections, caches, and ephemeral state in scope.
3. Define the mutation owner for each durable write model.
4. Define recovery strategy for each read model or projection: rebuild from write model, persist projection, or replay an event log.
5. Define persistence contract: snapshot, append-only log, queue, checkpoint, lease, or hybrid model.
6. Define idempotency, deduplication, and cutover behavior for recovery and replay paths.

Never let storage appear passive in diagrams while secretly owning lifecycle transitions or recovery semantics.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Observed State Architecture`
- `Evidence`
- `Architecture Fit Verdict`
- `Tradeoff Assessment`
- `Responsibility Table`
- `Connection Table`
- `Unknowns / Confidence`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Usually produce both `Layered Diagram` and `Dynamic Flow`. Prefer a `layered` overview plus either a `state-machine` for recovery behavior or a `sequence` for write-model mutation and projection update flow.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [state-model-template.md](./references/state-model-template.md) for the output skeleton and [persistence-review-checklist.md](./references/persistence-review-checklist.md) for the review checklist.

## Anti-pattern Checks

At minimum, check for these failures:

- two persisted models both behave like write models for the same lifecycle
- mutation ownership is split between runtime, persistence listeners, adapters, or projections
- read-model recovery strategy is undefined or different parts of the design imply different answers
- projections or transcripts are persisted incrementally but cannot be rebuilt or replayed deterministically
- storage is presented as passive, but lifecycle transitions or replay semantics actually live there
- queue, event-log, and snapshot semantics are mixed without clear ownership or cutover rules
- a system with no durable-state requirement is pushed into event-log or replay abstractions without evidence that persistence is actually a first-class need

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` when turn semantics or runtime transition rules are still undefined.
- To `agent-surface-and-adapters` when transcript projection, session durability, or UI read-model ownership remains unclear.
- To `agent-protocol-and-tooling` when provider state, connector state, or protocol-side recovery rules remain undefined.
- To `multi-agent-architecture` when durable task state, distributed queues, or worker checkpointing start affecting orchestration design.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “What is the write model in this agent system, and who is allowed to mutate it?”
- “Should these task views rebuild from the job snapshot or persist as projections?”
- “How should replay, checkpoint, and recovery work after interruption?”
- “Why does persistence keep acting like a hidden lifecycle owner?”

## Not-this-skill Examples

- “How should a single-agent query loop be designed?”
- “How should MCP retry and reconnect work?”
- “How should CLI and API share one kernel?”
- “Help me design an entire agent platform architecture”
