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
| Multiple execution truths | Two persisted lifecycle models both claim to be the execution truth | Choose one write model and demote the other to a read model, cache, or projection |
| Write-model mutation owner ambiguity | Runtime, persistence listeners, adapters, or projections can all advance the write model | Pick one mutation owner and make every other layer consume snapshots, commands, or events only |
| Read-model recovery ambiguity | Read models or transcripts exist, but it is unclear whether they rebuild from the write model, persist independently, or require replayable events | Choose one recovery strategy explicitly and align persistence and idempotency expectations |
| Transcript carries hidden domain state | Message history quietly stores progression semantics, approvals, or recovery points | Declare transcript as projection, audit record, or domain record, then align ownership |
| Reverse commands missing | Users can cancel, resume, retry, or resolve-action in the product, but the runtime contract only models forward progress | Define reverse commands explicitly and assign ownership before implementation |
| Orchestrator before event contract | A coordinator is extracted while side effects still depend on ad hoc callbacks or UI hooks | Define a neutral runtime event or result envelope before extracting orchestration |
| Event catalog drift | The proposed event list and the actual contract or tables differ, especially around intermediate or recovery states | Maintain one canonical event catalog and reconcile all docs and handlers to it |

## Review Prompts

Use these prompts to pressure-test the design:

- “If a tool call fails, who decides whether the failure result enters the next-turn context?”
- “If the user asks to continue, who defines the continue rule?”
- “If one surface is replaced with another, what behavior in runtime must change?”
- “If permission policy changes, does runtime need to be rewritten?”
- “If recovery starts from storage instead of memory, which persisted record is authoritative?”
- “If transcript is replayed alone, does it recreate domain progression or only user-visible history?”
- “Who is allowed to mutate the write model after a decision is made: runtime, persistence, or an event consumer?”
- “If the user cancels, resumes, or resolves an action, where is that command modeled and who owns it?”
- “After a refresh, are read models rebuilt from the write model, loaded as persisted projections, or reconstructed from replayable events?”
- “Does every event named in the narrative design also exist in the formal event contract?”

If the answer shows runtime depends on UI protocol, transcript storage, or connector internals, the boundary is still wrong.
