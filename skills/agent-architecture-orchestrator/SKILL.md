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
- mixes runtime, surface, protocol/tooling, state/persistence, and multi-agent concerns in one conversation
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
2. For `review` or `refactor`, perform evidence-first intake before synthesis: repo inventory, primary entrypoints, durable-state artifacts, naming map, and explicit unknowns.
3. Classify the impact domains: `runtime`, `surface`, `protocol`, `state`, `multi-agent`.
4. For `review` or `refactor`, explicitly assess product scope and stage before recommending change: current surfaces, current scale, deployment style, user model, and whether the system is intentionally CLI-first, single-process, or research-grade.
5. Record observed architecture separately from target recommendations whenever the task is `review` or `refactor`.
6. If the request is single-domain, route out and stop acting as orchestrator.
7. If the request is mixed-domain, select all relevant sub-skills using the routing matrix.
8. Merge results using ownership boundaries, fixed priority, and deterministic section keys.
9. Rewrite one final cross-domain conclusion, one merged risk picture, one proportional recommendation, and one implementation order.

Never answer a cross-cutting request by improvising a new all-in-one architecture taxonomy. Reuse the existing domain boundaries.

## Required Outputs

Always produce:

- `Design Conclusion`
- `Layered Diagram`
- `Observed Architecture`
- `Evidence`
- `Architecture Fit Verdict`
- `Tradeoff Assessment`
- `Responsibility Table`
- `Connection Table`
- `Unknowns / Confidence`
- `Constraints`
- `Anti-pattern Checks`
- `Implementation Order`

Produce `Dynamic Flow` only when a cross-domain interaction genuinely needs it. Produce `Migration / Compatibility / Rollback Plan` whenever the task is `review` or `refactor`.

For `review` and `refactor`, explicitly force these cross-domain decisions into the final result whenever they apply:

- `Truth Source Decision`
- `Read-model versus Write-model Decision`
- `Write-model Mutation Owner Decision`
- `Read-model Recovery Strategy Decision`
- `Transcript Role Decision`
- `Reverse Command Contract`
- `Event / Side-effect Boundary Decision`
- `Change Recommendation Level` (`keep as-is`, `light refactor`, or `major refactor`)
- `Present-risk versus Future-risk Classification`

Use [routing-matrix.md](./references/routing-matrix.md) for dispatch, [output-contract.md](./references/output-contract.md) for merge rules, and [borderline-nouns.md](./references/borderline-nouns.md) for the most common ownership confusions.

## Architecture Review Gate

Use this gate before declaring a cross-domain design `pass`. Keep the answer concise, but do not skip the questions.

Always force explicit answers for:

- What is the single execution truth source?
- What is the write model, and who is the single mutation owner?
- Is tool execution part of the runtime turn loop, including result reinjection?
- What role does transcript play: projection, audit log, domain state, or another explicitly named role?
- Who owns permission and approval policy?
- Are cancel, resume, retry, continue, and resolve-action paths formal contracts instead of loose callbacks?
- Is the recommended architecture proportional to the current product stage and operating model?

When the proposal includes optional capabilities such as multi-agent orchestration, long-term memory, approval flows, multiple surfaces, replayable event logs, or a skill layer, force explicit justification for why each capability exists now, what boundary it owns, and what would break if it were removed.

Mark optional-capability questions as `n/a` when the design intentionally does not include that capability. Do not treat omission as a defect unless the stated product scope actually requires it.

If any core answer is missing or ambiguous, the result cannot be stronger than `pass with risks`.

Use [agent-architecture-review-checklist.md](./references/agent-architecture-review-checklist.md) for the full review template, including required questions, suggested questions, veto conditions, and final verdict framing.

## Anti-pattern Checks

At minimum, check for these failures:

- a mixed-domain request is answered as if it were single-domain
- two skills define the same concept with conflicting ownership
- the merged result keeps duplicate modules or duplicate lifecycle concepts under different names
- implementation order ignores domain dependencies and mixes later adapters before earlier kernel or protocol decisions
- refactor output gives an ideal target state but no migration, compatibility, or rollback path
- the final result leaves execution truth, transcript role, or read-model versus write-model boundaries undecided even though multiple domains depend on them
- the final result leaves write-model mutation ownership or reverse-command ownership undecided even though cancel, resume, retry, or resolution paths exist
- the final result leaves read-model recovery ambiguous between rebuild-from-write-model, persisted projection, or replayable event log
- the suggested event list and the formal event contract drift apart, leaving intermediate states or recovery paths undefined
- a review result jumps to recommendations without showing observed structure, primary evidence, unknowns, or confidence
- an orchestrator or application layer is introduced without a neutral event or side-effect contract across domains
- the result treats every seam as a defect instead of distinguishing acceptable scope-bound tradeoffs from blockers
- the recommendation strength is disproportionate to the current product scope, stage, and operating model

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` for single-agent kernel definition.
- To `agent-surface-and-adapters` for session, transcript, and surface adapter design.
- To `agent-protocol-and-tooling` for tool systems, protocol clients, permission policy, and normalized state.
- To `agent-state-and-persistence` for write models, read models, persistence contracts, replayability, recovery, queue or event-log semantics, and durable-state ownership.
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
