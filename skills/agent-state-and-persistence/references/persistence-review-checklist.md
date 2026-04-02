# Persistence Review Checklist

Use this checklist during design review or refactor review.

## Core Failures

| Check | Failure Signal | Correction Direction |
| --- | --- | --- |
| Dual write models | Two durable models both define lifecycle progression | Pick one write model and demote the other to a read model or projection |
| Mutation owner ambiguity | Runtime, storage, adapters, or listeners can all advance durable state | Assign one mutation owner and make all other layers consume snapshots, commands, or events only |
| Recovery ambiguity | It is unclear whether projections rebuild, persist independently, or replay events | Pick one recovery strategy explicitly and align implementation to it |
| Projection without rebuild | A read model or transcript is persisted but cannot be deterministically reconstructed | Add a rebuild path or make the projection explicitly authoritative |
| Storage as hidden owner | Persistence logic decides lifecycle transitions or recovery semantics | Move decision logic to the owning runtime or state domain |
| Queue/log/snapshot blur | The design mixes queue semantics, event-log semantics, and snapshot storage with no cutover rules | Declare the persistence contract and the replay or checkpoint boundary explicitly |

## Review Prompts

- “If the process crashes, what durable artifact is authoritative on restart?”
- “Which layer is allowed to advance the write model?”
- “Can this read model be rebuilt from the write model without hidden state?”
- “If an event is replayed twice, what prevents duplicate projection updates?”
- “If the projection is deleted, what reconstructs it?”

If the answer is split across unrelated modules or depends on undocumented behavior, the boundary is still wrong.
