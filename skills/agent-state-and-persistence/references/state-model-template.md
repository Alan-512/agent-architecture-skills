# State Model Template

Use this template when `agent-state-and-persistence` is active.

## 1. Design Conclusion

State the durable-state conclusion in one paragraph.

## 2. Observed State Architecture

List the actual stores and models observed today:

| State Artifact | Kind | Current Owner | Notes |
| --- | --- | --- | --- |
| `...` | write model / read model / projection / cache / ephemeral | `...` | `...` |

## 3. Evidence

Capture the files, traces, or user-provided artifacts that justify the observation.

## 4. Responsibility Table

| Module | Owns | Must Not Own |
| --- | --- | --- |
| `...` | `...` | `...` |

## 5. Connection Table

| From | Relation | To | Why |
| --- | --- | --- | --- |
| `...` | `mutates / persists / derives / rebuilds / replays` | `...` | `...` |

## 6. Unknowns / Confidence

- Unknowns:
- Confidence:

## 7. Constraints

- Truth Source Decision
- Read-model versus Write-model Decision
- Write-model Mutation Owner Decision
- Read-model Recovery Strategy Decision

## 8. Anti-pattern Checks

Mark each as `pass`, `risk`, or `fail`.

## 9. Dynamic Flow

Prefer one of:

- write-model mutation flow
- replay / rebuild flow
- checkpoint / restore flow

## 10. Implementation Order

List the order that removes ambiguity first, then moves code.
