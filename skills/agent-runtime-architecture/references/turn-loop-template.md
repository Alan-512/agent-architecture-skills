# Turn Loop Template

Use this template when `agent-runtime-architecture` is active.

## 1. Design Conclusion

- Define the responsibility boundary of the runtime kernel in one sentence.
- Make it explicit that this pass only covers a single-agent turn, not surfaces, protocol, or multi-agent concerns.

## 2. Responsibility Table

Include at least these modules:

| Module | Primary Responsibility | Explicitly Not Responsible For |
| --- | --- | --- |
| Runtime Kernel | State progression and terminal decision for one turn | Transcript persistence, protocol connection management |
| Input Normalizer | Convert user input and context into canonical messages | Calling external protocols directly |
| Tool Loop Coordinator | Detect tool triggers, receive results, and reinject them | Permission policy decisions |
| Stop / Recovery Policy | Define stop, continue, turn-level recovery, and budget | UI output protocols and per-call execution policy |

## 3. Connection Table

Cover at least:

| From | Relation | To | Meaning | Conflict Risk |
| --- | --- | --- | --- | --- |
| Input Normalizer | feeds | Runtime Kernel | Normalized input enters the turn loop | medium |
| Runtime Kernel | emits | Tool Loop Coordinator | Enter the tool phase when `tool_use` appears | high |
| Tool Loop Coordinator | reinjects | Runtime Kernel | `tool_result` is reinjected into the next state | high |
| Stop / Recovery Policy | constrains | Runtime Kernel | Limits continue, stop, and recovery branches | medium |

## 4. Dynamic Flow

Preferred outputs:

- `state-machine`: when turn-state progression is the main focus
- `runtime-flow`: when tool loop plus recovery is the main focus
- `sequence`: when the main focus is runtime interaction with a tool executor

Suggested minimal state set:

- `raw_input`
- `normalized_input`
- `assistant_streaming`
- `tool_pending`
- `tool_running`
- `tool_result_reinjected`
- `terminal_result`
- `recovery`

## 5. Constraints

Answer at least:

- Which states must remain a closed loop inside the kernel
- Which rules may only be defined by runtime
- Which inputs may only feed runtime from upstream and must not back-contaminate it

## 6. Anti-pattern Checks

Check at least:

- whether the tool loop belongs to the main loop
- whether recovery has been split across multiple layers
- whether runtime wrongly owns transcript/session/protocol state
- whether `tool_result` bypasses runtime and writes directly into downstream layers

## 7. Implementation Order

Recommended order:

1. Fix the turn input/output contract
2. Fix the message state machine
3. Fix tool-loop reinjection
4. Fix stop/recovery and turn-level budget rules
5. Decide function names, directories, and interface drafts last

If this result will later be merged by the orchestrator:

- Emit every section explicitly and mark missing ones as `N/A`
- Keep provenance for table rows
