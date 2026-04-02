# Surface Matrix Template

Use this template when `agent-surface-and-adapters` is active.

## 1. 设计结论

- 用一句话定义 shared kernel 与 surface adapter 的关系。
- 明确本轮只讨论 surface、session、transcript、output normalization，不重写 runtime 或 protocol owner。

## 2. 模块职责表

至少包含这些模块：

| 模块 | 主要职责 | 明确不负责 |
| --- | --- | --- |
| Shared Runtime Kernel | 提供与 surface 无关的核心执行能力 | session 持有、transcript 归档、展示协议 |
| Input Adapter | 把 CLI/API/SDK/batch/remote 输入转成 kernel 可消费格式 | 定义 turn state machine |
| Output Adapter | 把内核事件或结果投影成 surface 需要的协议 | 重新决定最终结果语义 |
| Session Owner | 定义会话边界、恢复入口、用户可感知上下文 | task lifecycle |
| Transcript Owner | 定义消息/事件归档边界与恢复范围 | permission policy |

## 3. Surface Matrix

至少列出在 scope 内的 surfaces：

| Surface | 输入形式 | 输出形式 | Session 是否存在 | Transcript 如何归档 | 备注 |
| --- | --- | --- | --- | --- | --- |
| CLI | 终端输入/命令行参数 | 终端流式渲染 + 结构化结果 | 是/否 | 按 session 或 run 归档 |  |
| API | HTTP/JSON/SSE/WebSocket | JSON + 流式事件 | 是/否 | 按 request 或 session 归档 |  |
| Batch | 作业输入/任务队列 | 日志/落库/汇总结果 | 通常弱化 | 按 run 或 job 归档 |  |

## 4. 关键连接表

至少覆盖：

| From | Relation | To | 含义 | 冲突风险 |
| --- | --- | --- | --- | --- |
| Input Adapter | normalizes_for | Shared Runtime Kernel | 各 surface 入口统一进入同一 kernel | high |
| Shared Runtime Kernel | emits | Output Adapter | kernel 只产出中立事件或结果 | high |
| Session Owner | scopes | Transcript Owner | transcript 归档边界可受 session 影响 | medium |
| Output Adapter | projects | Surface | 输出协议由 surface 决定，不反向污染 kernel | medium |

## 5. 状态流或时序图

优先输出：

- `sequence`：surface -> adapter -> kernel -> adapter -> surface
- `runtime-flow`：如果重点是流式输出与最终结果分流

最小链路建议：

- raw host input
- adapter normalization
- kernel invocation
- neutral event stream
- surface projection
- final result envelope

## 6. 设计约束

至少回答：

- 哪些状态由 surface 主导，而不是 runtime 主导
- transcript 和 session 是否必须绑定，以及绑定边界在哪里
- 新增一个 surface 时，kernel 需要不需要修改

## 7. 反模式检查

至少逐项判断：

- 是否存在每个 surface 各写一套 runtime
- 是否把 session / transcript / task 混成一个 store
- 是否把 streaming 逻辑放进 kernel 业务决策
- 是否把最终结果格式绑死在某一个 surface

## 8. 下一步实现顺序

建议顺序：

1. 固定 shared kernel 接口
2. 固定 session ownership
3. 固定 transcript ownership
4. 固定 neutral event 和 final result envelope
5. 最后才写每个 surface adapter

如果结果后续会被 orchestrator 合并：

- 显式写出所有 section，缺失项用 `N/A`
- 为表格行保留 provenance
