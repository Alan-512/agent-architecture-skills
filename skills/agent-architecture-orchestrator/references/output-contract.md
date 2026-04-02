# Output Contract

Use this reference when `agent-architecture-orchestrator` is active.

## 1. Canonical Envelope

Every sub-result must be interpreted through this common shape:

```text
SkillResult
- skill_name
- scope
- task_type
- affected_domains
- confidence
- provenance
- sections
  - design_conclusion
  - layered_diagram
  - observed_architecture
  - evidence
  - architecture_fit_verdict
  - tradeoff_assessment
  - responsibility_table
  - connection_table
  - dynamic_flow
  - unknowns_confidence
  - constraints
  - anti_patterns
  - migration_plan
  - implementation_order
```

Missing sections must be explicit `N/A`, never omitted.

## 2. Ownership Before Priority

When two results touch the same concept:

1. apply ownership boundary first
2. then apply merge priority

Merge priority:

`protocol -> runtime -> state -> multi-agent -> surface -> orchestrator`

Ownership still wins over priority when they disagree.

## 3. Deterministic Merge Keys

Use these merge keys:

- `Responsibility Table`: `Module`
- `Connection Table`: `From + Relation + To`
- `Anti-pattern Checks`: `Check`
- `Layered Diagram`: `diagram_kind + scope`
- `Dynamic Flow`: `flow_kind + scope`

## 4. Section Rules

| Section | Merge rule |
| --- | --- |
| `Design Conclusion` | orchestrator rewrites as one final conclusion |
| `Layered Diagram` | dedupe by key, prefer owner or higher-priority source |
| `Observed Architecture` | merge only from evidence-backed observations; do not rewrite into target state |
| `Evidence` | keep citations and observations; never replace with inferred recommendations |
| `Architecture Fit Verdict` | orchestrator rewrites one proportional judgment tied to current scope and stage |
| `Tradeoff Assessment` | keep explicit tradeoffs, accepted simplifications, and their validity horizon |
| `Responsibility Table` | one row per module, owner wins field conflicts |
| `Connection Table` | dedupe by key, keep higher-priority meaning and provenance |
| `Dynamic Flow` | dedupe by key, prefer owner or higher-priority source |
| `Unknowns / Confidence` | union unknowns, keep lowest confidence for disputed areas |
| `Constraints` | dedupe and keep stricter constraints |
| `Anti-pattern Checks` | keep worst state: `fail > risk > pass` |
| `Migration / Compatibility / Rollback Plan` | orchestrator rewrites one phased plan |
| `Implementation Order` | orchestrator rewrites one dependency-aware order |

For `review` and `refactor`, `Constraints` or `Migration / Compatibility / Rollback Plan` must explicitly resolve these decisions whenever they are in scope:

- `Truth Source Decision`
- `Read-model versus Write-model Decision`
- `Write-model Mutation Owner Decision`
- `Read-model Recovery Strategy Decision`
- `Transcript Role Decision`
- `Reverse Command Contract`
- `Event / Side-effect Boundary Decision`
- `Change Recommendation Level`
- `Present-risk versus Future-risk Classification`

For `review`, the final result must also include:

- `Observed Architecture`
- `Evidence`
- `Architecture Fit Verdict`
- `Tradeoff Assessment`
- `Unknowns / Confidence`

## 5. Provenance Rule

Merged rows or objects must keep:

```text
provenance
- primary
  - source_skill
  - source_section
  - source_concept
- merged_from[]
  - source_skill
  - source_section
  - source_concept
```

If a conflict cannot be resolved by ownership or merge priority, output:

- `Unresolved conflict`
- the concept in conflict
- the involved skills
- who should lead the next resolution
