# Runtime Anti-patterns

Use this checklist during design review or refactor review.

## Core Failures

| Check | Failure Signal | Correction Direction |
| --- | --- | --- |
| Normalization after model call | The model is called before messages or context are normalized | Move input normalization to the beginning of the turn |
| Tool loop as sidecar | Tool execution is stitched on outside runtime | Turn `tool_use -> tool_result` into a branch of the turn loop |
| Turn-level recovery split across layers | stop/continue/recovery is split across adapters, runtime, and tool wrappers | Let runtime define one turn-level policy |
| Runtime owns transcript | Runtime directly decides transcript persistence and archival | Give transcript ownership to surface/adapters |
| Runtime owns permission policy | Runtime decides tool permission and concurrency policy by itself | Let protocol/tooling provide policy; runtime only consumes it |
| Turn policy and execution policy conflated | Runtime defines both turn-level recovery and per-call timeout/retry | Runtime only defines turn-level rules; per-call policy belongs to protocol/tooling |

## Review Prompts

Use these prompts to pressure-test the design:

- “If a tool call fails, who decides whether the failure result enters the next-turn context?”
- “If the user asks to continue, who defines the continue rule?”
- “If one surface is replaced with another, what behavior in runtime must change?”
- “If permission policy changes, does runtime need to be rewritten?”

If the answer shows runtime depends on UI protocol, transcript storage, or connector internals, the boundary is still wrong.
