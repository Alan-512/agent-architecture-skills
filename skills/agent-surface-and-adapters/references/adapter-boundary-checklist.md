# Adapter Boundary Checklist

Use this checklist during design review or refactor review.

## Core Failures

| 检查项 | 失败信号 | 修正方向 |
| --- | --- | --- |
| Surface-specific runtime logic | CLI/API/batch 各自维护一套决策分支 | 把决策移回 shared runtime kernel |
| Vague application layer | session、transcript、permission、task 都塞进“应用层” | 明确 owner：surface、protocol 或 multi-agent |
| Streaming as business logic | token/SSE/terminal 渲染决定核心行为 | 让 kernel 只发中立事件，surface 决定投影方式 |
| Final result tied to one surface | 最终结果只适配终端文本或某个 HTTP schema | 定义 surface-neutral result envelope |
| Transcript/task coupling | transcript 切片规则跟 task lifecycle 绑死 | transcript 由 surface 定义，task 由 multi-agent 定义 |

## Review Prompts

Use these prompts to pressure-test the design:

- “如果把 CLI 去掉，只保留 API，kernel 需要改什么？”
- “如果新增一个 remote surface，session 和 transcript 的 owner 会变吗？”
- “如果把 SSE 改成 WebSocket，最终结果结构是否需要跟着变化？”
- “如果 task 在后台继续运行，surface 是否还在定义 task lifecycle？”

If the answer shows surfaces own runtime semantics, protocol semantics, or task semantics, the boundary is still wrong.
