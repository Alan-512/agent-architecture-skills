# Protocol Edge Checklist

Use this checklist during design review or refactor review.

## Core Failures

| 检查项 | 失败信号 | 修正方向 |
| --- | --- | --- |
| Registry as executor | registry 既维护 metadata 又直接发调用 | 把执行编排拆到 execution orchestrator |
| Permission inside client | MCP/connector client 自己判定业务是否允许 | 把 permission evaluation 提升到 policy owner |
| Protocol object leakage | runtime 或 adapter 直接依赖外部 client 对象或响应结构 | 先归一化成 internal tool surface 与 state |
| Partial state normalization | 只有工具目录被归一化，连接态和执行态散落各处 | 建立统一 normalized state store |
| Split retry and reconnect ownership | retry、timeout、reconnect 分散在 runtime、client、tool wrapper | 明确 execution owner 与 protocol owner 的边界 |
| Missing provider edge owner | provider streaming、fallback、provider-side retry/reconnect 没有明确 owner | 把 provider client 放进 protocol/tooling 域 |

## Review Prompts

Use these prompts to pressure-test the design:

- “如果把一个内置工具换成 MCP 工具，runtime 需要改什么？”
- “如果 connector 掉线，谁负责重连，谁负责决定本次执行是否重试？”
- “如果审批策略变化，protocol client 需要跟着改吗？”
- “如果 catalog 变了但连接还活着，谁负责 reconcile 归一化状态？”
- “如果 provider 切换、fallback 或流式中断，谁负责重连和重试？”

If the answer shows runtime, adapters, or protocol clients 各自持有一部分工具真相源，边界仍然不稳。
