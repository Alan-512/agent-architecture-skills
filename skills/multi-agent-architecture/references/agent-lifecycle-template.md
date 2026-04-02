# Agent Lifecycle Template

Use this checklist during design review or refactor review.

## Core Failures

| 检查项 | 失败信号 | 修正方向 |
| --- | --- | --- |
| Task state in worker memory | manager 重启后任务状态丢失 | 让 task state 有独立真相源 |
| Task lifecycle equals worker lifecycle | `running/blocked/completed` 同时描述任务和 worker | 分开两套状态机 |
| Manager as permission decider | manager 既派发任务又最终审批权限 | manager 只路由请求与阻塞状态，策略由 protocol/policy owner 决定 |
| Worker as result aggregator | worker 既执行又负责系统级汇总 | 把系统级汇总交回 orchestrator |
| Host semantics leak upward | 换进程/容器就要重写 orchestration 语义 | 让 host/backend 成为承载层，不主导编排 |

## Review Prompts

Use these prompts to pressure-test the design:

- “如果一个 worker 崩掉，task state 还能恢复吗？”
- “如果一个 task 在等待权限，谁知道它在阻塞，谁决定是否批准？”
- “如果从本地进程池切到 remote worker，manager 语义需要改多少？”
- “如果多个 worker 并行完成，最终谁负责汇总而不是只上报原始输出？”

If the answer shows task truth, permission decision, or host semantics are mixed into one layer, the boundary is still wrong.
