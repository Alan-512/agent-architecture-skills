# Surface Matrix Template

Use this template when `agent-surface-and-adapters` is active.

## 1. Design Conclusion

- Define the relationship between the shared kernel and surface adapters in one sentence.
- Make it explicit that this pass only covers surfaces, session, transcript, and output normalization. Do not redefine runtime or protocol ownership.

## 2. Responsibility Table

Include at least these modules:

| Module | Primary Responsibility | Explicitly Not Responsible For |
| --- | --- | --- |
| Shared Runtime Kernel | Provide core execution capability independent of any surface | Session ownership, transcript archival, presentation protocols |
| Input Adapter | Convert CLI/API/SDK/batch/remote input into a kernel-consumable format | Defining the turn state machine |
| Output Adapter | Project kernel events or results into a surface-specific protocol | Redefining final-result semantics |
| Session Owner | Define session boundaries, restore entrypoints, and user-visible context | Task lifecycle |
| Transcript Owner | Define message/event archival boundaries and restore scope | Permission policy |

## 3. Surface Matrix

List at least the surfaces in scope:

| Surface | Input Form | Output Form | Session Present | Transcript Archival | Notes |
| --- | --- | --- | --- | --- | --- |
| CLI | terminal input / command-line args | terminal streaming plus structured result | yes/no | per session or run |  |
| API | HTTP/JSON/SSE/WebSocket | JSON plus streaming events | yes/no | per request or session |  |
| Batch | job input / task queue | logs / persistence / summarized result | usually weak | per run or job |  |

## 4. Connection Table

Cover at least:

| From | Relation | To | Meaning | Conflict Risk |
| --- | --- | --- | --- | --- |
| Input Adapter | normalizes_for | Shared Runtime Kernel | All surface entrypoints converge into one kernel | high |
| Shared Runtime Kernel | emits | Output Adapter | The kernel only emits neutral events or results | high |
| Session Owner | scopes | Transcript Owner | Session may influence transcript archival boundaries | medium |
| Output Adapter | projects | Surface | The surface decides the output protocol without contaminating the kernel | medium |

## 5. Dynamic Flow

Preferred outputs:

- `sequence`: surface -> adapter -> kernel -> adapter -> surface
- `runtime-flow`: when the focus is splitting streaming output from final results

Suggested minimal path:

- raw host input
- adapter normalization
- kernel invocation
- neutral event stream
- surface projection
- final result envelope

## 6. Constraints

Answer at least:

- Which states are owned by surfaces rather than runtime
- Whether transcript and session must be bound, and where that boundary lives
- Whether adding a new surface requires kernel changes

## 7. Anti-pattern Checks

Check at least:

- whether each surface has its own runtime implementation
- whether session / transcript / task have been collapsed into one store
- whether streaming logic has been pushed into kernel business decisions
- whether the final result format is coupled to one surface

## 8. Implementation Order

Recommended order:

1. Fix the shared-kernel interface
2. Fix session ownership
3. Fix transcript ownership
4. Fix the neutral event and final-result envelope
5. Write each surface adapter last

If this result will later be merged by the orchestrator:

- Emit every section explicitly and mark missing ones as `N/A`
- Keep provenance for table rows
