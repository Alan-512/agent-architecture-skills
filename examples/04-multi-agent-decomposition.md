# Example 4: Manager-Worker And Background Task Design

## Best Starting Skill

`multi-agent-architecture`

## When This Example Fits

Use this pattern when the system is adding:

- manager-worker task splitting
- teammates or swarm behavior
- background jobs
- resumable task state
- remote workers or isolated worker hosts

## Prompt

```text
Use multi-agent-architecture to design our manager-worker system.

Current problem:
- We want workers to run in parallel.
- Background tasks must survive worker restarts.
- The manager currently owns too much state and too many decisions.

I want:
- task lifecycle and worker lifecycle split clearly
- a task-state truth source
- clear communication and handoff boundaries
```

## A Good Answer Should Cover

- why multiple agents exist
- the four planes: orchestration, execution, task state, host/backend
- task lifecycle vs worker lifecycle
- manager-worker communication rules
- permission-request routing vs policy ownership

## Common Mistakes

- storing task truth only in worker memory
- making the manager the final permission decider
- tying orchestration semantics to one host topology
