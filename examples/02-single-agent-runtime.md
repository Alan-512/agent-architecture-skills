# Example 2: Single-Agent Runtime And Tool Reinjection

## Best Starting Skill

`agent-runtime-architecture`

## When This Example Fits

Use this pattern when the main problem is the single-agent kernel:

- query loop
- message normalization
- tool detection
- `tool_result` reinjection
- stop, continue, or recovery rules

## Prompt

```text
Use agent-runtime-architecture to redesign my single-agent turn loop.

Current problem:
- The model emits tool calls correctly.
- Tool execution works.
- But tool results are stitched back into the transcript ad hoc.
- Stop and retry rules are split between runtime and API handlers.

I want:
- a clean turn state machine
- a proper tool reinjection path
- one owner for turn-level recovery
```

## A Good Answer Should Cover

- the canonical turn input and terminal result
- the message-state transition path
- where `tool_use` becomes `tool_result`
- the turn-level boundary between runtime and adapters
- which policies belong in runtime vs protocol/tooling

## Common Mistakes

- letting adapters decide turn recovery
- treating tool execution as a sidecar callback
- letting tool results bypass runtime state
