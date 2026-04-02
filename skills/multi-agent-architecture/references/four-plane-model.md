# Four Plane Model

Use this template when `multi-agent-architecture` is active.

## 1. 设计结论

- 用一句话定义为什么需要多 agent。
- 明确本轮只讨论 orchestration、execution、task state、host/backend 四个平面，不重写 runtime kernel 或 protocol policy owner。

## 2. 模块职责表

至少包含这些模块：

| 模块 | 主要职责 | 明确不负责 |
| --- | --- | --- |
| Orchestrator / Manager | 拆任务、派发 worker、汇总结果、处理取消与重试 | 定义单 agent turn loop |
| Worker Runtime | 执行具体 agent 工作单元并上报状态 | 持有系统级任务真相源 |
| Task State Store | 记录任务状态、阶段、依赖与恢复点 | 决定 transcript 归档策略 |
| Mailbox / Event Bus | 承载 agent 间消息、进度事件与交接通知 | 负责最终权限判定 |
| Host / Backend | 提供进程、容器、pane、remote worker 等承载面 | 主导任务编排语义 |

## 3. Plane Matrix

至少拆出四个平面：

| Plane | 主要问题 | 典型模块 | 备注 |
| --- | --- | --- | --- |
| orchestration | 任务拆分、分发、汇总、重试、取消 | manager、scheduler |  |
| execution | worker 真正执行 agent 工作 | worker runtime、sandbox |  |
| task state | 任务生命周期与恢复真相源 | state DB、task store |  |
| host/backend | worker 跑在哪里、如何隔离 | process、container、pane、remote |  |

## 4. 关键连接表

至少覆盖：

| From | Relation | To | 含义 | 冲突风险 |
| --- | --- | --- | --- | --- |
| Orchestrator / Manager | dispatches | Worker Runtime | manager 负责派发，不代替 worker 执行 | high |
| Worker Runtime | reports_to | Task State Store | task 真相源不能只在 worker 内存里 | high |
| Worker Runtime | communicates_via | Mailbox / Event Bus | agent 间通信走显式通道 | medium |
| Host / Backend | hosts | Worker Runtime | 承载与任务语义分层 | medium |

## 5. 状态流或时序图

优先输出：

- `state-machine`：如果重点是 task lifecycle 与 worker lifecycle
- `sequence`：如果重点是 manager -> worker -> event bus -> result aggregation

最小状态集合建议：

- task: `queued -> assigned -> running -> waiting_permission -> blocked -> completed / failed / cancelled`
- worker: `created -> ready -> running -> idle -> recycled`

明确说明这两个状态机不是同一个东西。

## 6. 设计约束

至少回答：

- task state 的真相源在哪里
- worker lifecycle 和 task lifecycle 如何解耦
- permission request 经过谁转发，谁只负责等待结果
- 更换宿主承载时，任务编排是否仍然保持稳定

## 7. 反模式检查

至少逐项判断：

- task state 是否只存在于 worker 内存
- 是否把 permission decision 写进 manager
- 是否把 host/backend 选择和 orchestration 语义绑死
- 是否让 worker 负责最终结果汇总

## 8. 下一步实现顺序

建议顺序：

1. 固定 task lifecycle
2. 固定 worker lifecycle
3. 固定 manager 与 worker 的通信和交接协议
4. 固定 task state store
5. 最后才决定具体宿主承载和部署形态

如果结果后续会被 orchestrator 合并：

- 显式写出所有 section，缺失项用 `N/A`
- 为表格行保留 provenance
