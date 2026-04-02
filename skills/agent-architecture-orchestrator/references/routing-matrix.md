# Routing Matrix

Use this reference when `agent-architecture-orchestrator` is active.

## 1. Task Classification

First classify the request:

- `greenfield`: 从零设计
- `review`: 审查现有架构
- `refactor`: 在现有系统上重构

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
| runtime only | `agent-runtime-architecture` | runtime | 单域，直接路由 |
| surface only | `agent-surface-and-adapters` | surface | 单域，直接路由 |
| protocol only | `agent-protocol-and-tooling` | protocol | 单域，直接路由 |
| multi-agent only | `multi-agent-architecture` | multi-agent | 单域，直接路由 |
| runtime + surface | runtime + surface | runtime -> surface -> orchestrator | 先定 kernel，再定 adapter |
| runtime + protocol | protocol + runtime | protocol -> runtime -> orchestrator | 先定统一工具面，再定 kernel 消费方式 |
| runtime + multi-agent | runtime + multi-agent | runtime -> multi-agent -> orchestrator | 先定单 agent，再定多 agent 复用 |
| surface + protocol | protocol + surface | protocol -> surface -> orchestrator | 先定协议状态，再定对外投影 |
| surface + multi-agent | multi-agent + surface | multi-agent -> surface -> orchestrator | 先定 task，再定 surface 暴露 |
| protocol + multi-agent | protocol + multi-agent | protocol -> multi-agent -> orchestrator | 先定权限与外部能力，再定任务编排 |
| three or more | all relevant domain skills | protocol -> runtime -> multi-agent -> surface -> orchestrator | 固定顺序，避免重复定义 |

## 4. Ambiguity Rule

Default to orchestrator mode when:

- the request mentions two or more likely domains
- the request is broad enough that scope is unclear
- the user asks for “整体设计”“整体 review”“整体重构”
- the current turn is short but inherits a cross-domain context from prior turns

## 5. Refactor Rule

If task type is `refactor`, the final merged answer must include:

- migration stages
- compatibility layer or compatibility stance
- cutover point
- rollback point
- risk isolation
