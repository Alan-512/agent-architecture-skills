# Adapter Boundary Checklist

Use this checklist during design review or refactor review.

## Core Failures

| Check | Failure Signal | Correction Direction |
| --- | --- | --- |
| Surface-specific runtime logic | CLI/API/batch each maintain their own decision branches | Move decisions back into the shared runtime kernel |
| Vague application layer | session, transcript, permission, and task are all shoved into one “application layer” | Name the owner explicitly: surface, protocol, or multi-agent |
| Streaming as business logic | token/SSE/terminal rendering determines core behavior | Let the kernel emit neutral events and let the surface decide projection |
| Final result tied to one surface | Final results only fit terminal text or one HTTP schema | Define a surface-neutral result envelope |
| Transcript/task coupling | Transcript slicing rules are tied to task lifecycle | Let surface define transcripts and multi-agent define tasks |
| Transcript role ambiguity | Transcript is treated as UI history, audit log, and domain state at the same time | Pick the transcript role explicitly and move extra semantics to the owning domain |
| UI state machine as second runtime | client-side state owns retry, confirmation, or execution progression | Move execution semantics back to runtime and leave interaction state in the surface |
| Surface-driven lifecycle writes | a surface mutates persisted execution state directly instead of issuing commands | Route lifecycle changes through the owning runtime or task domain |
| Action overload | one button or handler both triggers a domain command and deletes or hides a projection | Split domain commands from projection cleanup and give each an explicit contract |

## Review Prompts

Use these prompts to pressure-test the design:

- “If CLI is removed and only API remains, what must change in the kernel?”
- “If a new remote surface is added, does ownership of session and transcript change?”
- “If SSE is replaced with WebSocket, should the final result structure change too?”
- “If a task keeps running in the background, is the surface still defining task lifecycle?”
- “If the UI is closed and reopened, which semantics must be restored from transcript versus the owning domain model?”
- “If a confirmation dialog is bypassed, does execution policy still exist outside the surface?”
- “If the user clicks remove, is that canceling domain work or only dismissing a projection?”

If the answer shows surfaces own runtime semantics, protocol semantics, or task semantics, the boundary is still wrong.
