---
name: agent-protocol-and-tooling
description: Use when designing, reviewing, or refactoring an agent external-capability layer that combines builtin tools, model providers, MCP, connectors, or remote executors, especially when registry shape, permission policy, protocol clients, execution policy, or normalized state boundaries are unclear.
---

# Agent Protocol And Tooling

## Overview

Design external-capability systems as explicit layers: catalog, permission and policy, protocol edge, execution orchestration, and normalized state. This skill owns tool registry shape, model/provider client boundaries, permission evaluation, per-call timeout and retry policy, concurrency and cancellation policy, protocol reconnect and dedup rules, and how external capabilities become one internal surface.

## When to Use

Use this skill when the main problem is:

- combining builtin tools with MCP, connectors, or remote executors
- defining model/provider clients, provider streaming, provider fallback, or provider-side reconnect behavior
- defining tool registry shape, capability metadata, and discoverability
- deciding where permission evaluation, approval, per-call timeout, retry, or concurrency policy should live
- designing protocol clients, reconnect behavior, streaming tool state, or normalized state sync
- reviewing whether runtime or adapters leaked external protocol details into the core system

Treat `remote executor` as an external capability backend in this skill. Do not use this skill to define `remote worker` host placement or agent topology; that belongs to `multi-agent-architecture`.

## Do Not Use For

Do not use this skill when the main problem is:

- defining the single-agent turn loop, tool-result reinjection semantics, or stop and recovery logic
- defining CLI, API, SDK, batch, or remote surface ownership for session, transcript, or output normalization
- defining manager-worker orchestration, task lifecycle, or multi-agent host topology
- routing a whole system across multiple architecture domains

For mixed-domain requests, hand off to `agent-architecture-orchestrator`.

## Core Workflow

Follow this order:

1. For `review` or `refactor`, start with evidence-first intake: inventory the real capability layers, protocol clients, state stores, current product scope, and unknowns before proposing changes.
2. Define the internal capability surfaces the runtime should consume.
3. Separate catalog, permission and policy, protocol clients, execution orchestration, and normalized state.
4. Define how external capabilities are adapted into the internal models.
5. Define per-call execution policy: timeout, retry, cancellation, concurrency, idempotency, fallback, and error classification.
6. Define reconnect, dedup, and state-reconciliation rules without leaking protocol objects upward.

Never let a single “tool service” own tool definition, permission, protocol transport, and execution semantics at the same time.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Observed Capability Architecture`
- `Evidence`
- `Architecture Fit Verdict`
- `Tradeoff Assessment`
- `Responsibility Table`
- `Connection Table`
- `Unknowns / Confidence`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Usually produce both `Layered Diagram` and `Dynamic Flow`. Prefer a `layered` overview plus either a `sequence` for tool invocation flow or a `runtime-flow` for reconnect and execution orchestration.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [tool-registry-template.md](./references/tool-registry-template.md) for the output skeleton and [protocol-edge-checklist.md](./references/protocol-edge-checklist.md) for the review checklist.

## Anti-pattern Checks

At minimum, check for these failures:

- tool registry is also acting as executor or protocol client
- permission evaluation is embedded inside protocol clients or runtime code
- execution orchestration directly depends on external protocol object shapes
- normalized state only covers catalog metadata but not execution or connection state
- reconnect, dedup, and retry logic are split across multiple unrelated layers with no single owner
- model/provider client behavior has no explicit owner
- a provider client is labeled over-coupled without distinguishing acceptable single-surface UX shortcuts from cross-surface architecture debt

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` when the runtime still lacks a stable internal capability-consumption interface or tool-result reinjection semantics.
- To `agent-surface-and-adapters` when tool state must still be projected into CLI, API, SDK, or remote surfaces with unclear output or transcript ownership.
- To `agent-state-and-persistence` when normalized-state durability, replay, sync checkpoints, or long-lived capability state contracts remain undefined.
- To `multi-agent-architecture` when permission requests, remote executors, or tool workers start affecting task lifecycle or orchestration design.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “How do we unify builtin tools and MCP/connectors into one tool surface?”
- “Where should provider clients, permission, timeout, retry, and concurrency live?”
- “How should protocol clients, the registry, and the execution orchestrator be split?”
- “Why is our tool system getting too dependent on external protocol details?”

## Not-this-skill Examples

- “How should a single-agent `tool_result` be reinjected into the next turn?”
- “How should CLI, API, and batch share one kernel?”
- “How should manager-worker and background tasks be decomposed?”
- “Help me design an entire agent platform architecture.”
