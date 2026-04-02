# Agent Architecture Skills

面向 Codex 和 Claude Code 的可复用 agent 架构 skill 集，用于设计、审查和重构 agent 系统。

这个仓库提供的不是某个固定框架脚手架，而是一组可组合的架构 skill。重点不在“怎么写一个 prompt”，而在于如何用稳定的边界去思考 agent 系统：

- 运行时内核和适配层如何分开
- 协议/工具层和执行编排如何分开
- 持久化状态和 UI 状态如何分开
- 单 agent 执行模型如何为未来多 agent 扩展留好边界

## 适合谁使用

如果你正在构建或审查下面这些系统，这个仓库会比较合适：

- 编程 agent
- 研究型 agent
- 内容创作 agent
- 图像或视频生成 agent
- 带工具、模型 provider、MCP 风格接入的工作流 agent

如果你的应用只是单轮调用、没有状态、没有工具、也没有执行生命周期，这套 skill 会偏重，不建议直接套用。

## 包含的 Skill

| Skill | 作用 |
| --- | --- |
| `agent-architecture-orchestrator` | 跨域总控入口，用于整体架构设计、审查和重构 |
| `agent-runtime-architecture` | 单 agent 的 turn loop、消息状态、tool result 回灌、stop/recovery |
| `agent-surface-and-adapters` | CLI / API / SDK / batch / remote 等入口如何共享同一内核 |
| `multi-agent-architecture` | manager-worker、teammate、任务状态、生命周期、宿主承载 |
| `agent-protocol-and-tooling` | tool registry、model/provider 边界、MCP/connectors、权限/策略、协议状态 |

## 推荐使用方式

在下面这些场景，优先从 `agent-architecture-orchestrator` 开始：

- 需求跨越多个架构域
- 你还不确定问题到底该由哪个 skill 负责
- 你希望拿到一份收口后的整体架构结论

如果问题已经很明确地落在单一子域，可以直接调用对应 skill：

- turn loop / tool reinjection -> `agent-runtime-architecture`
- CLI / API / SDK 边界 -> `agent-surface-and-adapters`
- tool registry / provider / protocol -> `agent-protocol-and-tooling`
- manager-worker / swarm / 后台任务 -> `multi-agent-architecture`

## 示例

- `agent-architecture-orchestrator`： “Help me review the architecture of this agent platform end to end.”
- `agent-runtime-architecture`： “How should tool results be reinjected into the next turn?”
- `agent-surface-and-adapters`： “How should CLI and API share one agent kernel?”
- `multi-agent-architecture`： “How should a manager-worker system split task state and worker lifecycle?”
- `agent-protocol-and-tooling`： “Where should provider clients, permission, timeout, retry, and concurrency live?”

更完整、可复用的示例放在 [examples/](./examples/README.md)。

## 仓库结构

```text
agent-architecture-skills/
  .agents/plugins/marketplace.json
  README.md
  README.zh-CN.md
  LICENSE
  examples/
  plugins/
    agent-architecture-skills/
  scripts/
    install.sh
  skills/
    agent-architecture-orchestrator/
    agent-runtime-architecture/
    agent-surface-and-adapters/
    multi-agent-architecture/
    agent-protocol-and-tooling/
```

每个 skill 都包含自己的 `SKILL.md`，以及它依赖的 `references/` 辅助文件。

仓库现在也包含了一个 repo 内的 Codex plugin 骨架，位于 `plugins/agent-architecture-skills/`，并带有 `.agents/plugins/marketplace.json`。也就是说，这套 skill 现在同时支持“直接 skill 目录安装”和“Codex 推荐的 plugin 分发形态”。

## 安装方式

### 安装到 Codex 全局目录

```bash
bash scripts/install.sh codex
```

这会把技能复制到 `~/.agents/skills`。

### 安装到 Claude Code 全局目录

```bash
bash scripts/install.sh claude
```

这会把技能复制到 `~/.claude/skills`。

### 安装到 Codex 项目里

```bash
bash scripts/install.sh project-codex /path/to/your/repo
```

这会把技能复制到 `/path/to/your/repo/.agents/skills`。

### 安装到 Claude Code 项目里

```bash
bash scripts/install.sh project-claude /path/to/your/repo
```

这会把技能复制到 `/path/to/your/repo/.claude/skills`。

## 作为本地 Codex Plugin 使用

```bash
bash scripts/install-plugin.sh
```

这个脚本会把 plugin 安装到 `~/plugins/agent-architecture-skills`，并创建或更新 `~/.agents/plugins/marketplace.json`，让 Codex 以本地 plugin 的方式发现它。

安装完成后，需要重启 Codex 才能加载新的本地 plugin。

### 卸载本地 Codex Plugin

```bash
bash scripts/uninstall-plugin.sh
```

这个脚本会删除 `~/plugins/agent-architecture-skills`，并从 `~/.agents/plugins/marketplace.json` 中移除对应的 plugin 条目。

卸载完成后，需要重启 Codex 才能真正卸载这个本地 plugin。

## 手动安装

如果你不想用脚本，也可以手动把 `skills/` 下面的 5 个目录复制到以下任一位置：

- `~/.agents/skills`
- `<repo>/.agents/skills`
- `~/.claude/skills`
- `<repo>/.claude/skills`

## 官方兼容说明

截至 2026-04-02：

- Claude Code 官方技能目录仍然是 `~/.claude/skills` 和项目内 `.claude/skills`
- Codex 官方文档使用的是 `~/.agents/skills` 和项目内 `.agents/skills`
- OpenAI 对 Codex 的公开可复用分发，更推荐用 plugin；直接 skill 目录更适合本地创作和 repo 内使用

这个仓库当前仍以“直接 skill 目录”方式分发，优先保证可复制、可本地安装、可在仓库内直接使用。如果后续要更贴近 Codex 官方推荐分发形态，下一步应该把它打包成 plugin。

现在仓库里已经补上了 plugin-ready 的目录结构，同时保留了根目录下的 `skills/` 作为直接安装入口。

## 设计原则

这套 skill 默认建立在以下原则上：

- 先设计 runtime kernel，再设计 surface wrapper
- 工具执行属于 runtime loop 的一部分，不是外挂回调
- provider / protocol 细节不应该泄漏进 runtime core
- UI 状态和持久化执行状态不能混成一个模糊 store
- 多 agent 系统需要明确的 task state 和 lifecycle ownership

## 验证来源

这套 skill 在一个真实的图像生成 agent 项目上做过架构验证，并经过多轮审查和修订后才整理成仓库。

## 许可证

MIT
