# State And Persistence

Use this example when the main architecture question is about durable state, truth sources, projections, transcript role, or recovery strategy.

## Best Starting Skill

`agent-state-and-persistence`

## Reusable Prompt

“Review this agent system's durable state model. Identify the write model, read models, transcript role, mutation owner, and recovery strategy. Tell me whether the current design should stay as-is, get a light refactor, or needs a larger change.”

## What A Good Answer Should Cover

- which state is the canonical write model
- which structures are read models or projections
- whether transcript is audit log, UX projection, or domain record
- who owns write-model mutation
- whether recovery rebuilds from snapshots, projections, or replayable events
- whether current persistence complexity fits the product scope

## Common Boundary Mistakes

- treating two persisted lifecycle models as equal truth sources
- letting transcript silently carry domain progression semantics
- mixing projection cleanup actions with domain commands
- describing replay, snapshot, and projection rebuild as if they were all active at once
