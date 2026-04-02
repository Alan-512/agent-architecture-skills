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

## Review Prompts

Use these prompts to pressure-test the design:

- “If CLI is removed and only API remains, what must change in the kernel?”
- “If a new remote surface is added, does ownership of session and transcript change?”
- “If SSE is replaced with WebSocket, should the final result structure change too?”
- “If a task keeps running in the background, is the surface still defining task lifecycle?”

If the answer shows surfaces own runtime semantics, protocol semantics, or task semantics, the boundary is still wrong.
