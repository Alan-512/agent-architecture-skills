# Agent Architecture Review Checklist

Use this checklist when reviewing a cross-domain agent architecture proposal. Mark each item `pass`, `risk`, `fail`, or `n/a`.

## How To Use

Review in this order:

1. Confirm the execution truth source and write-model ownership.
2. Confirm the runtime loop is closed, including tool-result reinjection and reverse commands.
3. Confirm the core boundaries for context, transcript, external capabilities, persistence, and recovery.
4. Review optional capabilities only when the proposal actually includes them.
5. Confirm complexity is proportional to the current product stage.

If a veto condition is present, the final verdict cannot be `pass`.

This checklist is not a component inventory. It evaluates decision quality, ownership clarity, and proportional complexity. Optional capabilities should be marked `n/a` when they are intentionally absent.

## Core Review

These questions apply to nearly all agent proposals, regardless of implementation style.

### Overall Architecture

- What is the single execution truth source?
- What is the write model?
- Who is the single mutation owner for that write model?
- Which parts of the design belong to `runtime`, `surface`, `protocol`, and `state`?
- Is the architecture scaled to the current product stage instead of a speculative future platform?

### Runtime And Agent Loop

- What are the turn start condition, stop condition, continue condition, and completion condition?
- What is the canonical normalized input before model invocation?
- How does the runtime distinguish plain assistant output, tool calls, structured results, and approval-required actions?
- How are tool results reinjected into runtime state?
- Which layer owns cancel, resume, retry, continue, and resolve-action?
- Which layer owns turn budget, tool budget, and token budget?
- How are model errors, tool errors, permission denials, protocol failures, and user interrupts classified?
- Which layer owns stop and recovery behavior?

### Context, Transcript, And Memory

- What exactly counts as model context?
- Which data is for model consumption, and which is for user-facing projection only?
- What role does transcript play: projection, audit log, domain state, or another explicit role?
- Can transcript be rebuilt from lower-level durable state?
- How is context trimmed, summarized, or segmented?
- How do tool outputs enter context, and are they normalized or compressed first?
- How are sensitive values filtered or scoped before entering context?
- What happens when the context budget is exceeded?

### Tools, Skills, And External Capabilities

- What internal capability surface does runtime consume?
- Does the registry own only catalog and metadata, or has it also absorbed execution and policy?
- Which layer owns permission and approval policy?
- Which layer owns timeout, retry, cancellation, concurrency, idempotency, and fallback?
- Are tool schemas stable, validated, and versionable?
- Are external protocol objects prevented from leaking into runtime and surface layers?
- How are raw tool results, normalized results, and user-visible results separated?
- What is the fallback path for unavailable, denied, timed-out, or partially successful tools?

### Surfaces And Adapters

- Do CLI, API, SDK, batch, or remote surfaces share one runtime kernel?
- Do adapters translate input and output only, or do they duplicate runtime logic?
- Who owns session state?
- Who owns transcript persistence and transcript recovery?
- What is the streaming event contract for each surface?
- What is the final result contract for each surface?
- Can a new surface be added without re-implementing runtime, tool policy, or recovery behavior?

### State, Persistence, And Recovery

- Which persisted object is the write model?
- Which persisted objects are read models, projections, caches, or checkpoints?
- What must be durable, and what must remain ephemeral?
- What is the recovery strategy for each important read model: rebuild, replay, persisted projection, or hybrid?
- How are transcript, task view, tool state, and approval state recovered after interruption?
- How does the design prevent duplicate tool execution or duplicate writes during recovery?
- Which idempotency keys, dedup keys, leases, or checkpoints exist?
- Is storage a passive store, or is it acting as a hidden lifecycle owner?

### Observability And Verification

- Can the system show which layer made a decision?
- Can operators distinguish planning stall, tool stall, approval wait, recovery loop, and projection lag?
- Are there explicit fault-injection scenarios for timeout, denial, partial write, crash, reconnect, and duplicate replay?
- Are key lifecycle transitions observable and auditable?
- Can important failures be replayed or at least causally reconstructed?

### Product-Stage Fit

- Which layers are required now?
- Which abstractions are explicitly deferred?
- Which parts of the design are present only for a speculative future?
- If the product stays CLI-first or single-process for six months, does the architecture still look proportionate?

## Optional Capability Review

Mark these sections `n/a` when the proposal intentionally does not include the capability. Do not deduct points for omission unless the product requirements clearly need the capability.

### Long-term Memory

- Who may write long-term memory, under what trigger, and with what provenance?
- What problem does long-term memory solve that transcript or task state cannot?
- How are memory writes filtered, summarized, deduplicated, and audited?
- What breaks if long-term memory is removed from the design?

### Skills Or Planning Layer

- What is the role of skills in the system: prompting aid, planning aid, or execution primitive?
- Which behaviors are impossible or materially worse without the skill layer?
- How does the design degrade when a skill is unavailable or skipped?
- Does the skill layer change execution semantics, or only preparation and guidance?

### Multi-surface Delivery

- Do multiple surfaces exist now, or is the design only preserving the option?
- Which parts are truly shared across CLI, API, SDK, batch, or remote surfaces?
- What user-visible or operational requirement justifies the extra adapter complexity?
- What breaks if the system remains single-surface for the next stage?

### Approval And Human Control

- What exactly is approved: command, capability, resource scope, session scope, or time window?
- Is approval a formal runtime event or just a UI-side interaction?
- Can approval decisions be audited and explained?
- Are approval semantics consistent across all surfaces?
- What is the fallback path after a user denies an action?
- What product or safety requirement justifies explicit approval flows now?

### Replayable Event Log Or Advanced Recovery

- Why is replayable recovery needed instead of simpler snapshot or rebuild strategies?
- Which lifecycle facts must be reconstructable after crash or restart?
- What cutover, deduplication, and idempotency rules protect replay paths?
- What breaks if the design uses simpler recovery?

### Multi-agent And Subagents

- Why do multiple agents exist at all?
- What concrete value do they add: decomposition, parallelism, isolation, background execution, or role specialization?
- Is task lifecycle defined separately from worker lifecycle?
- Does the manager own orchestration only, or has it absorbed permission and execution policy?
- How do agents communicate: commands, events, messages, or shared state?
- Who aggregates results?
- How are failure, timeout, cancellation, heartbeat, and retry handled for workers?
- How is subagent context scoped and reduced?
- Is host placement separated from orchestration semantics?
- What breaks if the design remains single-agent for the current product stage?

## Suggested Questions

- If transcript is deleted, can the system still rebuild the user-visible state correctly?
- If tool execution finishes but the client disconnects, who decides whether the turn continues?
- If the manager crashes while workers keep running, which state source wins?
- If approval is denied, does the system continue through a defined branch or simply fail open or fail opaque?
- If multi-agent behavior is removed, what concrete capability is lost?
- If a new provider or tool backend replaces the current one, does runtime remain unchanged?
- If a projection is corrupted, can it be rebuilt deterministically?
- If the current product never adds a second surface, which abstractions would be unnecessary overhead?

## N/A Rules

- Mark a section `n/a` when the proposal intentionally excludes that capability and the product scope does not currently require it.
- Do not convert `n/a` into `risk` unless the architecture claims a requirement that obviously needs that capability.
- If a capability is absent, prefer asking why its omission is acceptable instead of assuming it is missing by mistake.
- If a capability is present, review whether it solves a real current problem and whether its owner and boundary are explicit.

## Veto Conditions

Treat any of the following as a blocking architecture failure:

- No single execution truth source is identified.
- Two persisted models both behave like write models for the same lifecycle.
- Tool execution is not designed as part of the runtime turn loop.
- Tool results bypass runtime state and write directly into adapters, projections, or UI state.
- Transcript role is ambiguous and silently mixes projection, audit, and domain semantics.
- Permission and approval policy have no clear owner.
- Mutation ownership is split across runtime, storage listeners, adapters, or projections.
- Recovery strategy is undefined for key read models.
- Surface adapters duplicate runtime decisions.
- The design is materially overbuilt for the current product stage.

Only apply the following veto checks when the corresponding capability exists in the proposal:

- Task lifecycle and worker lifecycle are treated as the same state machine.
- Subagents are introduced without a concrete justification tied to current needs.
- Long-term memory is introduced without write policy, provenance, and retention boundaries.
- Approval flows are introduced without a clear owner or fallback path.

## Final Verdict

Use one of these outcome labels:

- `pass`
  - Execution truth, write-model ownership, runtime loop, transcript role, recovery, and approval boundaries are all explicit.
- `pass with risks`
  - The main architecture holds, but one or more important boundaries remain ambiguous or weakly defended.
- `needs refactor`
  - The architecture is understandable but has structural layering or ownership problems that should be fixed before adoption.
- `reject`
  - Core decisions such as execution truth, mutation ownership, tool-loop closure, transcript role, or recovery behavior are missing or contradictory.
