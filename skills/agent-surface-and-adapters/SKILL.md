---
name: agent-surface-and-adapters
description: Use when designing, reviewing, or refactoring how CLI, API, SDK, batch, or remote agent surfaces share one runtime kernel, especially when session ownership, transcript ownership, streaming output, or final-result normalization are unclear.
---

# Agent Surface And Adapters

## Overview

Design execution surfaces as thin adapters around a shared runtime kernel. This skill owns session boundaries, transcript ownership, output normalization, and how different entrypoints consume the same kernel without cloning runtime logic.

## When to Use

Use this skill when the main problem is:

- making CLI, API, SDK, batch, or remote modes share one runtime kernel
- deciding which layer owns session state or transcript persistence
- defining streaming events versus final structured results
- reviewing whether a surface duplicated runtime logic or protocol state
- designing adapters that transform host-specific IO into kernel-friendly inputs and outputs

## Do Not Use For

Do not use this skill when the main problem is:

- defining the turn state machine, tool-result reinjection, or stop and recovery logic
- defining tool registry shape, permission evaluation, or protocol reconnect rules
- defining manager-worker, teammate, background-task, or task lifecycle models
- routing a whole system across multiple architecture domains

For mixed-domain requests, hand off to `agent-architecture-orchestrator`.

## Core Workflow

Follow this order:

1. For `review` or `refactor`, start with evidence-first intake: enumerate real surfaces, observed adapter responsibilities, current product scope, durable transcript/session artifacts, and unknowns before proposing changes.
2. Extract the shared kernel boundary and remove any surface-specific runtime logic from it.
3. Define input adapters, output adapters, session ownership, transcript ownership, and whether transcript is a projection, an audit log, or a domain record.
4. Define streaming-event shape versus final-result shape for every surface.
5. Verify that adding a new surface would not require rewriting the kernel or rehosting execution semantics in the adapter.

Never invent a generic “application layer” to hide boundary confusion. Name the owner explicitly: runtime, surface, protocol, or multi-agent.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Observed Surfaces`
- `Evidence`
- `Architecture Fit Verdict`
- `Tradeoff Assessment`
- `Responsibility Table`
- `Connection Table`
- `Unknowns / Confidence`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Usually produce `Layered Diagram` and either a `sequence` or `runtime-flow` that shows surface-to-kernel adaptation. Use `Dynamic Flow` only when it clarifies adapter handoff rather than re-explaining the runtime kernel.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [surface-matrix-template.md](./references/surface-matrix-template.md) for the output skeleton and [adapter-boundary-checklist.md](./references/adapter-boundary-checklist.md) for the review checklist.

## Anti-pattern Checks

At minimum, check for these failures:

- multiple surfaces each reimplement the same runtime decisions
- session, transcript, task, and permission state are collapsed into one vague application layer
- streaming output is treated as business logic instead of a surface concern
- final result format is coupled to one presentation surface such as terminal text or HTTP response bodies
- adapters import connector internals or task-lifecycle rules that belong to other domains
- transcript role is ambiguous and silently mixes projection, audit, and domain semantics
- a UI or client-side state machine still owns retry, confirmation, or progression semantics that belong to runtime
- a surface directly advances persisted lifecycle state instead of projecting or submitting commands through the owning domain
- one user action is overloaded to mean both a domain command and a projection-only cleanup action without separate contracts
- a CLI-first or single-surface product is judged by multi-surface standards without evidence that expansion is actually in scope

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` when the design still lacks a stable kernel boundary or turn semantics.
- To `agent-protocol-and-tooling` when permission policy, tool descriptors, protocol state, or reconnect behavior remain undefined.
- To `agent-state-and-persistence` when transcript durability, projection persistence, recovery strategy, or snapshot-vs-rebuild tradeoffs remain undefined.
- To `multi-agent-architecture` when tasks, teammates, or background execution start affecting the design.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “How should CLI, API, and batch share one agent kernel?”
- “Who should own session and transcript?”
- “How should streaming output and final results be layered?”
- “Why did we duplicate runtime logic in every entrypoint?”

## Not-this-skill Examples

- “How should a tool result be reinjected into the next turn?”
- “How should permission and reconnect be designed once MCP tools are integrated?”
- “How should manager-worker and background tasks be decomposed?”
- “Help me design an entire agent platform architecture”
