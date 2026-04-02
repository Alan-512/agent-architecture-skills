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

1. Define why multiple agents exist: decomposition, parallelism, isolation, background execution, or role specialization.
2. Split the design into four planes: orchestration, execution, task state, and host or backend.
3. Define task lifecycle separately from worker lifecycle.
4. Define inter-agent communication, result handoff, heartbeat, cancellation, and permission-request routing.
5. Define host placement and failure boundaries without moving orchestration semantics into infrastructure.

Never collapse task state, agent lifecycle, and permission decision into one generic manager layer.

## Required Outputs

Always produce:

- `设计结论`
- `模块职责表`
- `关键连接表`
- `设计约束`
- `反模式检查`
- `下一步实现顺序`

Usually produce both `分层图` and `状态流或时序图`. Prefer a `layered` overview plus either a `state-machine` for task and worker lifecycle or a `sequence` for manager-worker coordination.

When this result may later be merged by `agent-architecture-orchestrator`, emit the canonical section envelope, mark non-applicable sections as explicit `N/A`, and keep row or object provenance for mergeable sections.

Use [four-plane-model.md](./references/four-plane-model.md) for the output skeleton and [agent-lifecycle-template.md](./references/agent-lifecycle-template.md) for lifecycle review.

## Anti-pattern Checks

At minimum, check for these failures:

- task state is stored only inside worker memory
- task lifecycle and agent runtime lifecycle are treated as the same state machine
- host placement decisions are mixed into orchestration semantics
- result aggregation is pushed down into workers instead of orchestration
- permission approval is decided by the manager instead of being routed to the owner policy layer

If any of these fail, the final result cannot be `pass`.

## Handoff

- To `agent-runtime-architecture` when worker kernels or turn semantics are still undefined.
- To `agent-protocol-and-tooling` when permission evaluation, tool concurrency, connector state, or remote execution protocol rules are still undefined.
- To `agent-surface-and-adapters` when session ownership, transcript ownership, or user-facing output surfaces are still unclear.
- To `agent-architecture-orchestrator` when two or more of the above are simultaneously in scope.

## Trigger Examples

- “manager-worker 多 agent 应该怎么拆”
- “后台任务、并行 worker、结果汇总怎么分层”
- “task state 和 worker lifecycle 应该放哪”
- “teammate 之间怎么通信和交接结果”

## Not-this-skill Examples

- “单 agent 的 query loop 怎么设计”
- “MCP 权限、重连和工具并发怎么定”
- “CLI、API 和 SDK 怎么共用一套 kernel”
- “帮我设计整个 agent 平台架构”
