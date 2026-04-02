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

1. Enumerate the surfaces in scope and the user-facing contract for each one.
2. Extract the shared kernel boundary and remove any surface-specific runtime logic from it.
3. Define input adapters, output adapters, session ownership, and transcript ownership.
4. Define streaming-event shape versus final-result shape for every surface.
5. Verify that adding a new surface would not require rewriting the kernel.

Never invent a generic “application layer” to hide boundary confusion. Name the owner explicitly: runtime, surface, protocol, or multi-agent.

## Required Outputs

Always produce:

- `设计结论`
- `模块职责表`
- `关键连接表`
- `设计约束`
- `反模式检查`
- `下一步实现顺序`

Usually produce `分层图` and either a `sequence` or `runtime-flow` that shows surface-to-kernel adaptation. Use `状态流或时序图` only when it clarifies adapter handoff rather than re-explaining the runtime kernel.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [surface-matrix-template.md](./references/surface-matrix-template.md) for the output skeleton and [adapter-boundary-checklist.md](./references/adapter-boundary-checklist.md) for the review checklist.

## Anti-pattern Checks

At minimum, check for these failures:

- multiple surfaces each reimplement the same runtime decisions
- session, transcript, task, and permission state are collapsed into one vague application layer
- streaming output is treated as business logic instead of a surface concern
- final result format is coupled to one presentation surface such as terminal text or HTTP response bodies
- adapters import connector internals or task-lifecycle rules that belong to other domains

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` when the design still lacks a stable kernel boundary or turn semantics.
- To `agent-protocol-and-tooling` when permission policy, tool descriptors, protocol state, or reconnect behavior remain undefined.
- To `multi-agent-architecture` when tasks, teammates, or background execution start affecting the design.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “CLI、API 和 batch 怎么共用一套 agent 核心”
- “session 和 transcript 应该归谁管”
- “流式输出和最终结果应该怎么分层”
- “为什么我们每个入口都复制了一遍 runtime 逻辑”

## Not-this-skill Examples

- “tool result 应该怎么回灌到下一轮”
- “MCP 工具接进来后权限和重连怎么定”
- “manager-worker 和 background task 怎么拆”
- “帮我设计整个 agent 平台架构”
