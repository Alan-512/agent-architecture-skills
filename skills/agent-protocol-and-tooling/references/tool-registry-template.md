# Tool Registry Template

Use this template when `agent-protocol-and-tooling` is active.

## 1. 设计结论

- 用一句话定义 internal capability surface 与外部协议面的关系。
- 明确本轮只讨论 registry、provider/tool clients、policy、protocol edge、execution orchestration、normalized state，不重写 runtime 或 surface owner。

## 2. 模块职责表

至少包含这些模块：

| 模块 | 主要职责 | 明确不负责 |
| --- | --- | --- |
| Tool Registry | 维护统一工具目录和 capability metadata | 真正执行调用、决定权限 |
| Provider Client Layer | 处理模型 provider 的握手、流式接收、fallback、provider-side reconnect | 定义 turn-level recovery |
| Permission / Policy Engine | 决定是否允许执行、参数级约束、审批与审计 | 维护协议连接 |
| Protocol Clients | 处理 MCP/connector/remote executor 的握手、连接、重连、心跳 | 定义业务权限或 tool catalog |
| Execution Orchestrator | 组织一次外部能力调用，处理 per-call timeout/retry/cancel/concurrency | 保存长期 catalog 真相源 |
| Normalized State Store | 统一 catalog、连接状态、执行状态与 reconcile 结果 | 直接向 runtime 暴露协议对象 |

## 3. Layer Matrix

至少拆出这些层：

| Layer | 主要问题 | 典型模块 | 备注 |
| --- | --- | --- | --- |
| catalog | 工具定义、schema、metadata、可见性 | registry |  |
| policy | permission、approval、风险与审计 | policy engine |  |
| protocol edge | 协议握手、连接、重连、流式接收 | MCP client、connector client、provider clients |  |
| execution | 单次调用的编排和调度 | execution orchestrator |  |
| normalized state | catalog、连接、执行态的统一模型 | state store |  |

## 4. 关键连接表

至少覆盖：

| From | Relation | To | 含义 | 冲突风险 |
| --- | --- | --- | --- | --- |
| Tool Registry | describes | Execution Orchestrator | 执行层消费统一 capability metadata | high |
| Permission / Policy Engine | gates | Execution Orchestrator | policy 决定能否调，而不是 client 或 runtime | high |
| Protocol Clients | adapts_into | Normalized State Store | 外部协议对象先被归一化 | high |
| Provider Client Layer | streams_into | Normalized State Store | provider 流式状态先被归一化 | medium |
| Execution Orchestrator | invokes_via | Protocol Clients | 编排层通过 client 执行，而不直接操作协议细节 | medium |
| Normalized State Store | exposes | Internal Tool Surface | runtime 只能看到归一后的工具能力和状态 | medium |

## 5. 状态流或时序图

优先输出：

- `sequence`：runtime -> registry/policy -> execution -> protocol/provider client -> result
- `runtime-flow`：如果重点是 reconnect、dedup、state reconcile

最小链路建议：

- tool discovery
- permission check
- invocation scheduling
- protocol/provider send/receive
- normalized state update
- result envelope

## 6. 设计约束

至少回答：

- internal capability surface 的最小接口是什么
- permission policy 是否独立于 protocol client
- execution orchestration 是否独立于 registry 和 client
- model/provider edge 是否有明确 owner
- 断线重连后谁负责 reconcile catalog state 与 execution state

## 7. 反模式检查

至少逐项判断：

- registry 是否越权执行工具
- client 是否越权做 permission 决策
- execution 是否直接依赖外部协议对象
- normalized state 是否同时覆盖静态 catalog 与运行态
- reconnect/dedup/retry 是否没有单一 owner
- provider fallback 与 provider reconnect 是否没有单一 owner

## 8. 下一步实现顺序

建议顺序：

1. 固定 internal capability surface
2. 固定 tool registry metadata shape
3. 固定 permission / policy owner
4. 固定 protocol / provider client adapter 边界
5. 固定 execution orchestration
6. 最后再补 reconnect、dedup、state reconcile

如果结果后续会被 orchestrator 合并：

- 显式写出所有 section，缺失项用 `N/A`
- 为表格行保留 provenance
