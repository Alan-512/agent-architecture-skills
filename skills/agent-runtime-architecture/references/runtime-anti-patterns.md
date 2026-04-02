# Runtime Anti-patterns

Use this checklist during design review or refactor review.

## Core Failures

| 检查项 | 失败信号 | 修正方向 |
| --- | --- | --- |
| Normalization after model call | 先调模型，再拼消息或补上下文 | 把输入归一化前置到 turn 开始 |
| Tool loop as sidecar | 工具执行在 runtime 外单独拼接 | 把 tool_use -> tool_result 变成 turn loop 分支 |
| Turn-level recovery split across layers | stop/continue/recovery 分散在 adapter、runtime、tool wrapper | 由 runtime 定义统一 turn-level 策略 |
| Runtime owns transcript | runtime 直接决定 transcript 持久化与归档 | 把 transcript ownership 交给 surface/adapters |
| Runtime owns permission policy | runtime 自己判定工具权限与并发策略 | 由 protocol/tooling 层给出策略，runtime 只消费 |
| Turn policy and execution policy conflated | runtime 同时定义 turn-level recovery 与 per-call timeout/retry | runtime 只定义 turn-level 规则，per-call policy 交给 protocol/tooling |

## Review Prompts

Use these prompts to pressure-test the design:

- “如果工具执行失败，下一轮上下文由谁决定是否带上失败结果？”
- “如果用户要求继续，continue 规则是谁定义的？”
- “如果换一个 surface，runtime 需要改哪些行为？”
- “如果 permission policy 变化，runtime 是否需要跟着重写？”

If the answer shows runtime depends on UI protocol, transcript storage, or connector internals, the boundary is still wrong.
