# Agent Lifecycle Template

Use this checklist during design review or refactor review.

## Core Failures

| Check | Failure Signal | Correction Direction |
| --- | --- | --- |
| Task state in worker memory | Task state is lost when the manager restarts | Give task state an independent truth source |
| Task lifecycle equals worker lifecycle | `running/blocked/completed` describe both task and worker | Split them into two separate state machines |
| Manager as permission decider | The manager both dispatches tasks and makes final permission decisions | Let the manager route requests and blocking state only; strategy belongs to the protocol/policy owner |
| Worker as result aggregator | The worker both executes and performs system-level aggregation | Move system-level aggregation back to the orchestrator |
| Host semantics leak upward | Changing process/container topology forces orchestration semantics to change | Treat host/backend as a hosting layer, not the owner of orchestration semantics |

## Review Prompts

Use these prompts to pressure-test the design:

- “If a worker crashes, can task state still be recovered?”
- “If a task is waiting for permission, who knows it is blocked and who decides approval?”
- “If local workers are replaced with remote workers, how much does manager semantics change?”
- “If multiple workers finish in parallel, who owns final aggregation instead of just reporting raw outputs?”

If the answer shows task truth, permission decision, or host semantics are mixed into one layer, the boundary is still wrong.
