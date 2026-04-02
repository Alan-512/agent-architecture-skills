# Tool Registry Template

Use this template when `agent-protocol-and-tooling` is active.

## 1. Design Conclusion

- Define in one sentence how the internal capability surface relates to external protocol surfaces.
- Make it explicit that this pass only covers the registry, provider/tool clients, policy, protocol edge, execution orchestration, and normalized state. Do not redefine runtime or surface ownership.

## 2. Responsibility Table

Include at least these modules:

| Module | Primary Responsibility | Explicitly Not Responsible For |
| --- | --- | --- |
| Tool Registry | Maintain a unified tool catalog and capability metadata | Direct execution or permission decisions |
| Provider Client Layer | Handle model provider handshake, streaming, fallback, and provider-side reconnect | Turn-level recovery |
| Permission / Policy Engine | Decide whether execution is allowed, including parameter-level constraints, approval, and audit | Protocol connection management |
| Protocol Clients | Handle MCP/connector/remote-executor handshake, connection, reconnect, and heartbeat | Business permission rules or tool catalog ownership |
| Execution Orchestrator | Organize one external capability call and handle per-call timeout/retry/cancel/concurrency | Long-lived catalog truth |
| Normalized State Store | Unify catalog, connection state, execution state, and reconciliation results | Exposing raw protocol objects directly to runtime |

## 3. Layer Matrix

Split at least these layers:

| Layer | Primary Concern | Typical Modules | Notes |
| --- | --- | --- | --- |
| catalog | Tool definitions, schema, metadata, visibility | registry |  |
| policy | permission, approval, risk, audit | policy engine |  |
| protocol edge | protocol handshake, connection, reconnect, streaming receive | MCP client, connector client, provider clients |  |
| execution | one-call orchestration and scheduling | execution orchestrator |  |
| normalized state | unified model for catalog, connection, and execution state | state store |  |

## 4. Connection Table

Cover at least:

| From | Relation | To | Meaning | Conflict Risk |
| --- | --- | --- | --- | --- |
| Tool Registry | describes | Execution Orchestrator | The execution layer consumes unified capability metadata | high |
| Permission / Policy Engine | gates | Execution Orchestrator | Policy decides whether a call is allowed, not the client or runtime | high |
| Protocol Clients | adapts_into | Normalized State Store | External protocol objects are normalized first | high |
| Provider Client Layer | streams_into | Normalized State Store | Provider streaming state is normalized first | medium |
| Execution Orchestrator | invokes_via | Protocol Clients | The orchestrator executes through clients without manipulating protocol details directly | medium |
| Normalized State Store | exposes | Internal Tool Surface | Runtime only sees normalized tool capabilities and state | medium |

## 5. Dynamic Flow

Preferred outputs:

- `sequence`: runtime -> registry/policy -> execution -> protocol/provider client -> result
- `runtime-flow`: when reconnect, dedup, or state reconciliation is the main focus

Suggested minimal path:

- tool discovery
- permission check
- invocation scheduling
- protocol/provider send/receive
- normalized state update
- result envelope

## 6. Constraints

Answer at least:

- What is the minimal interface for the internal capability surface?
- Is permission policy independent from the protocol client?
- Is execution orchestration independent from the registry and the client?
- Does the model/provider edge have a clear owner?
- After disconnect and reconnect, who reconciles catalog state with execution state?

## 7. Anti-pattern Checks

Check at least:

- whether the registry is overreaching into execution
- whether the client is overreaching into permission decisions
- whether execution depends directly on external protocol objects
- whether normalized state covers both static catalog and runtime state
- whether reconnect/dedup/retry lacks a single owner
- whether provider fallback and provider reconnect lack a single owner

## 8. Implementation Order

Recommended order:

1. Fix the internal capability surface
2. Fix the tool-registry metadata shape
3. Fix the permission / policy owner
4. Fix the protocol / provider-client adapter boundary
5. Fix execution orchestration
6. Add reconnect, dedup, and state reconciliation last

If this result will later be merged by the orchestrator:

- Emit every section explicitly and mark missing ones as `N/A`
- Keep provenance for table rows
