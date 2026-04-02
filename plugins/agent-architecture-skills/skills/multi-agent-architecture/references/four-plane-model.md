# Four Plane Model

Use this template when `multi-agent-architecture` is active.

## 1. Design Conclusion

- Define in one sentence why multiple agents are needed.
- Make it explicit that this pass only covers orchestration, execution, task state, and host/backend. Do not redefine the runtime kernel or protocol policy owner.

## 2. Responsibility Table

Include at least these modules:

| Module | Primary Responsibility | Explicitly Not Responsible For |
| --- | --- | --- |
| Orchestrator / Manager | Split tasks, dispatch workers, aggregate results, handle cancellation and retry | Defining the single-agent turn loop |
| Worker Runtime | Execute one agent work unit and report status | Owning the system-level task truth source |
| Task State Store | Record task state, stages, dependencies, and recovery points | Deciding transcript archival strategy |
| Mailbox / Event Bus | Carry inter-agent messages, progress events, and handoff notifications | Making final permission decisions |
| Host / Backend | Provide process, container, pane, or remote-worker hosting | Owning task orchestration semantics |

## 3. Plane Matrix

Split at least these four planes:

| Plane | Primary Concern | Typical Modules | Notes |
| --- | --- | --- | --- |
| orchestration | task decomposition, dispatch, aggregation, retry, cancellation | manager, scheduler |  |
| execution | where workers actually perform agent work | worker runtime, sandbox |  |
| task state | the truth source for task lifecycle and recovery | state DB, task store |  |
| host/backend | where workers run and how they are isolated | process, container, pane, remote |  |

## 4. Connection Table

Cover at least:

| From | Relation | To | Meaning | Conflict Risk |
| --- | --- | --- | --- | --- |
| Orchestrator / Manager | dispatches | Worker Runtime | The manager dispatches work but does not execute it | high |
| Worker Runtime | reports_to | Task State Store | Task truth must not live only in worker memory | high |
| Worker Runtime | communicates_via | Mailbox / Event Bus | Inter-agent communication goes through an explicit channel | medium |
| Host / Backend | hosts | Worker Runtime | Hosting is separated from task semantics | medium |

## 5. Dynamic Flow

Preferred outputs:

- `state-machine`: when task lifecycle and worker lifecycle are the main focus
- `sequence`: when manager -> worker -> event bus -> result aggregation is the main focus

Suggested minimal state set:

- task: `queued -> assigned -> running -> waiting_permission -> blocked -> completed / failed / cancelled`
- worker: `created -> ready -> running -> idle -> recycled`

Make it explicit that these two state machines are not the same thing.

## 6. Constraints

Answer at least:

- Where the task-state truth source lives
- How worker lifecycle and task lifecycle are decoupled
- Who forwards permission requests and who merely waits for the result
- Whether task orchestration remains stable when host placement changes

## 7. Anti-pattern Checks

Check at least:

- whether task state exists only in worker memory
- whether permission decisions are embedded in the manager
- whether host/backend selection is tightly coupled to orchestration semantics
- whether the worker is responsible for final result aggregation

## 8. Implementation Order

Recommended order:

1. Fix task lifecycle
2. Fix worker lifecycle
3. Fix the communication and handoff protocol between manager and worker
4. Fix the task-state store
5. Decide concrete host placement and deployment shape last

If this result will later be merged by the orchestrator:

- Emit every section explicitly and mark missing ones as `N/A`
- Keep provenance for table rows
