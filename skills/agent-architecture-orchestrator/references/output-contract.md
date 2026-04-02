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
- provenance
- sections
  - design_conclusion
  - layered_diagram
  - responsibility_table
  - connection_table
  - dynamic_flow
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

`protocol -> runtime -> multi-agent -> surface -> orchestrator`

Ownership still wins over priority when they disagree.

## 3. Deterministic Merge Keys

Use these merge keys:

- `模块职责表`: `模块`
- `关键连接表`: `From + Relation + To`
- `反模式检查`: `检查项`
- `分层图`: `diagram_kind + scope`
- `状态流或时序图`: `flow_kind + scope`

## 4. Section Rules

| Section | Merge rule |
| --- | --- |
| `设计结论` | orchestrator rewrites as one final conclusion |
| `分层图` | dedupe by key, prefer owner or higher-priority source |
| `模块职责表` | one row per module, owner wins field conflicts |
| `关键连接表` | dedupe by key, keep higher-priority meaning and provenance |
| `状态流或时序图` | dedupe by key, prefer owner or higher-priority source |
| `设计约束` | dedupe and keep stricter constraints |
| `反模式检查` | keep worst state: `fail > risk > pass` |
| `迁移/兼容/回滚方案` | orchestrator rewrites one phased plan |
| `下一步实现顺序` | orchestrator rewrites one dependency-aware order |

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
