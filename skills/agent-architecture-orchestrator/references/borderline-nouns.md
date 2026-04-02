# Borderline Nouns

Use this quick glossary when multiple skills appear to touch the same word.

| Term | Owner | Meaning |
| --- | --- | --- |
| `transcript` | `agent-surface-and-adapters` | A persistable history of messages or events, including archive and restore boundaries |
| `domain record in transcript` | `agent-surface-and-adapters` leading, `agent-runtime-architecture` consulted | A transcript that also carries progression semantics must explicitly declare that role instead of silently acting as both projection and domain state |
| `normalized state` | `agent-protocol-and-tooling` | The normalized static and runtime model for external capabilities; not the same as a transcript |
| `execution truth source` | `agent-runtime-architecture` leading, `agent-architecture-orchestrator` when mixed-domain | The authoritative write model for execution progression, recovery, and turn lifecycle |
| `read model` | `agent-architecture-orchestrator` leading, consulted by the owning domain | A projection, cache, or query model derived from a write model; not an independent lifecycle truth |
| `observed architecture` | `agent-architecture-orchestrator` | The evidence-backed description of what exists today, separate from recommendations or target design |
| `evidence` | `agent-architecture-orchestrator` | File-backed observations, runtime facts, or explicit user-provided artifacts that support the review result |
| `architecture fit verdict` | `agent-architecture-orchestrator` | The proportional judgment of whether the current architecture fits the product's actual scope and stage: keep as-is, light refactor, or major refactor |
| `tradeoff assessment` | `agent-architecture-orchestrator` | The explicit judgment that a seam may be an acceptable simplification for the current scope rather than an immediate architecture flaw |
| `unknowns / confidence` | `agent-architecture-orchestrator` | The unresolved areas and stated confidence level for current findings; required for unfamiliar or partially explored repos |
| `present-risk versus future-risk` | `agent-architecture-orchestrator` | Whether a seam is already blocking the current product or is mainly a future expansion risk |
| `write-model mutation owner` | `agent-runtime-architecture` leading, `agent-architecture-orchestrator` when mixed-domain | The one layer allowed to advance the authoritative write model after decisions are made |
| `read-model recovery strategy` | `agent-architecture-orchestrator` leading, `agent-runtime-architecture` consulted | The declared strategy for restoring read models or transcripts after refresh or recovery: rebuild from write model, persist projections, or replay events |
| `task state` | `multi-agent-architecture` | The lifecycle, stages, dependencies, and recovery points of a unit of work |
| `permission request routing` | `multi-agent-architecture` | How a request moves from manager or worker to the approval owner |
| `permission evaluation` | `agent-protocol-and-tooling` | The final policy decision that allows or denies an external capability call |
| `turn-level recovery` | `agent-runtime-architecture` | The rules that decide whether a single-agent turn continues, stops, or recovers |
| `reverse command` | `agent-runtime-architecture` leading, `agent-surface-and-adapters` consulted | A command such as cancel, resume, retry, or resolve-action that pushes execution backward, reopens work, or closes a blocked state |
| `event catalog` | `agent-runtime-architecture` leading, `agent-architecture-orchestrator` when mixed-domain | The canonical list of runtime events that downstream read models, transcripts, and surfaces may consume; narrative lists and formal tables must match |
| `per-call timeout/retry` | `agent-protocol-and-tooling` | The execution policy for one external capability invocation |
| `event / side-effect boundary` | `agent-runtime-architecture` leading, `agent-architecture-orchestrator` when mixed-domain | The neutral envelope runtime emits before adapters, persistence, or UI-specific side effects take over |
| `remote executor` | `agent-protocol-and-tooling` | A remote execution surface invoked as an external capability backend |
| `remote worker` | `multi-agent-architecture` | A remote worker that exists as an agent host or topology node |
