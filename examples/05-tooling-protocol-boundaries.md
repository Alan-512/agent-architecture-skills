# Example 5: Tool Registry, Provider Clients, And Protocol Boundaries

## Best Starting Skill

`agent-protocol-and-tooling`

## When This Example Fits

Use this pattern when the external-capability layer is getting tangled:

- builtin tools
- provider clients
- MCP servers
- connectors
- remote executors
- permission and timeout policies

## Prompt

```text
Use agent-protocol-and-tooling to review our external capability layer.

Current problem:
- The tool registry also dispatches calls.
- Provider streaming and retry logic are scattered.
- Permission checks live partly in runtime and partly in connector code.

I want:
- one internal tool surface
- a clear split between registry, policy, clients, execution orchestration, and normalized state
- reconnect and retry ownership defined explicitly
```

## A Good Answer Should Cover

- the internal capability surface
- tool registry responsibilities
- provider client ownership
- permission/policy ownership
- execution orchestration vs protocol edge
- normalized state and reconciliation

## Common Mistakes

- letting the registry execute tools directly
- letting protocol clients decide business permission
- leaking raw protocol objects into runtime or adapters
