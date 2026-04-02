# Borderline Nouns

Use this quick glossary when multiple skills appear to touch the same word.

| Term | Owner | Meaning |
| --- | --- | --- |
| `transcript` | `agent-surface-and-adapters` | 可持久化的消息或事件历史，以及归档和恢复边界 |
| `normalized state` | `agent-protocol-and-tooling` | 外部能力的归一化静态/运行态模型，不等于 transcript |
| `task state` | `multi-agent-architecture` | 一个工作单元的生命周期、阶段、依赖与恢复点 |
| `permission request routing` | `multi-agent-architecture` | 请求如何从 manager/worker 转发到审批 owner |
| `permission evaluation` | `agent-protocol-and-tooling` | 最终是否允许一次外部能力调用的策略判定 |
| `turn-level recovery` | `agent-runtime-architecture` | 单 agent turn 是否继续、停止、恢复的规则 |
| `per-call timeout/retry` | `agent-protocol-and-tooling` | 一次外部能力调用的执行策略 |
| `remote executor` | `agent-protocol-and-tooling` | 作为外部能力后端被调用的远端执行面 |
| `remote worker` | `multi-agent-architecture` | 作为 agent 宿主或拓扑节点存在的远端 worker |
