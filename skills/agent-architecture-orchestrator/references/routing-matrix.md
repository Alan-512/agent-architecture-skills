# Routing Matrix

Use this reference when `agent-architecture-orchestrator` is active.

## 1. Task Classification

First classify the request:

- `greenfield`: design from scratch
- `review`: review an existing architecture
- `refactor`: restructure an existing system

If the user did not say which one, infer it from context and record the assumption.

## 2. Domain Classification

Map the request to one or more of:

- `runtime`
- `surface`
- `protocol`
- `multi-agent`

If two or more domains are active, stay in orchestrator mode.

## 3. Dispatch Rules

| Impact domains | Dispatch | Merge order | Why |
| --- | --- | --- | --- |
| runtime only | `agent-runtime-architecture` | runtime | Single domain; route directly |
| surface only | `agent-surface-and-adapters` | surface | Single domain; route directly |
| protocol only | `agent-protocol-and-tooling` | protocol | Single domain; route directly |
| multi-agent only | `multi-agent-architecture` | multi-agent | Single domain; route directly |
| runtime + surface | runtime + surface | runtime -> surface -> orchestrator | Define the kernel before adapters |
| runtime + protocol | protocol + runtime | protocol -> runtime -> orchestrator | Define the internal capability surface before kernel consumption |
| runtime + multi-agent | runtime + multi-agent | runtime -> multi-agent -> orchestrator | Define single-agent semantics before multi-agent reuse |
| surface + protocol | protocol + surface | protocol -> surface -> orchestrator | Define protocol state before outward projection |
| surface + multi-agent | multi-agent + surface | multi-agent -> surface -> orchestrator | Define task semantics before surface exposure |
| protocol + multi-agent | protocol + multi-agent | protocol -> multi-agent -> orchestrator | Define permission and external capabilities before task orchestration |
| three or more | all relevant domain skills | protocol -> runtime -> multi-agent -> surface -> orchestrator | Fixed order avoids duplicate definitions |

## 4. Ambiguity Rule

Default to orchestrator mode when:

- the request mentions two or more likely domains
- the request is broad enough that scope is unclear
- the user asks for “whole-system design”, “whole-system review”, or “whole-system refactor”
- the current turn is short but inherits a cross-domain context from prior turns

## 5. Refactor Rule

If task type is `refactor`, the final merged answer must include:

- migration stages
- compatibility layer or compatibility stance
- cutover point
- rollback point
- risk isolation
