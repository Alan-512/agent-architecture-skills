# Turn Loop Template

Use this template when `agent-runtime-architecture` is active.

## 1. 设计结论

- 用一句话定义 runtime kernel 的职责边界。
- 明确本轮只讨论单 agent turn，不延伸到 surface、protocol、multi-agent。

## 2. 模块职责表

至少包含这些模块：

| 模块 | 主要职责 | 明确不负责 |
| --- | --- | --- |
| Runtime Kernel | 单 turn 的状态推进与终止判定 | transcript 持久化、协议连接 |
| Input Normalizer | 把用户输入和上下文转成规范消息 | 直接调用外部协议 |
| Tool Loop Coordinator | 识别工具触发、接收结果并回灌 | 决定 permission policy |
| Stop / Recovery Policy | 定义 stop、continue、turn-level recovery 与 budget | UI 输出协议、per-call execution policy |

## 3. 关键连接表

至少覆盖：

| From | Relation | To | 含义 | 冲突风险 |
| --- | --- | --- | --- | --- |
| Input Normalizer | feeds | Runtime Kernel | 规范化输入进入 turn loop | medium |
| Runtime Kernel | emits | Tool Loop Coordinator | 当出现 tool_use 时进入工具阶段 | high |
| Tool Loop Coordinator | reinjects | Runtime Kernel | tool_result 回灌下一状态 | high |
| Stop / Recovery Policy | constrains | Runtime Kernel | 限制继续、停止、恢复分支 | medium |

## 4. 状态流或时序图

优先输出：

- `state-machine`：如果重点是 turn 状态推进
- `runtime-flow`：如果重点是 tool loop + recovery
- `sequence`：如果重点是 runtime 与 tool executor 的交互

最小状态集合建议：

- `raw_input`
- `normalized_input`
- `assistant_streaming`
- `tool_pending`
- `tool_running`
- `tool_result_reinjected`
- `terminal_result`
- `recovery`

## 5. 设计约束

至少回答：

- 哪些状态必须在 kernel 内部闭环
- 哪些规则只能由 runtime 定义
- 哪些输入只能作为 runtime 的上游依赖，不能反向污染 runtime

## 6. 反模式检查

至少逐项判断：

- tool loop 是否属于主循环
- recovery 是否被拆散到多个层
- runtime 是否错误持有 transcript/session/protocol 状态
- tool_result 是否绕过 runtime 直接写入下游层

## 7. 下一步实现顺序

建议顺序：

1. 固定 turn 输入输出
2. 固定消息状态机
3. 固定 tool loop reinjection
4. 固定 stop/recovery 与 turn-level budget 规则
5. 最后才决定函数名、目录和接口草案

如果结果后续会被 orchestrator 合并：

- 显式写出所有 section，缺失项用 `N/A`
- 为表格行保留 provenance
