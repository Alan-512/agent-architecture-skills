# Example 3: Shared Kernel Across CLI, API, And SDK

## Best Starting Skill

`agent-surface-and-adapters`

## When This Example Fits

Use this pattern when multiple surfaces are drifting apart:

- CLI has one flow
- API has another flow
- SDK wrappers have duplicated runtime logic
- transcript or session ownership is unclear

## Prompt

```text
Use agent-surface-and-adapters to redesign how our CLI, API, and SDK share one agent kernel.

Current problem:
- Each surface has its own request normalization.
- Streaming output behaves differently everywhere.
- Session and transcript ownership are unclear.

I want:
- one shared kernel
- thin input/output adapters
- clear session and transcript ownership
```

## A Good Answer Should Cover

- the shared kernel boundary
- input adapters and output adapters
- streaming events vs final result envelopes
- session ownership and transcript ownership
- how a new surface could be added without rewriting runtime

## Common Mistakes

- inventing a vague “application layer”
- treating streaming as business logic
- binding final results to only terminal text or one HTTP response shape
