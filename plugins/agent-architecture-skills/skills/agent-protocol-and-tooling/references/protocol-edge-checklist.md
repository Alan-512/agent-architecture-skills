# Protocol Edge Checklist

Use this checklist during design review or refactor review.

## Core Failures

| Check | Failure Signal | Correction Direction |
| --- | --- | --- |
| Registry as executor | The registry maintains metadata and directly dispatches calls | Split execution orchestration into a dedicated execution orchestrator |
| Permission inside client | An MCP or connector client decides whether a business action is allowed | Lift permission evaluation into the policy owner |
| Protocol object leakage | Runtime or adapters depend directly on external client objects or response shapes | Normalize first into an internal tool surface and state model |
| Partial state normalization | Only the tool catalog is normalized while connection and execution state are scattered | Create one normalized state store |
| Split retry and reconnect ownership | Retry, timeout, and reconnect are split across runtime, client, and tool wrapper | Define a clear boundary between execution owner and protocol owner |
| Missing provider edge owner | Provider streaming, fallback, or provider-side retry/reconnect has no clear owner | Put the provider client inside the protocol/tooling domain |

## Review Prompts

Use these prompts to pressure-test the design:

- “If a builtin tool is replaced with an MCP tool, what must runtime change?”
- “If a connector drops, who reconnects and who decides whether this call should retry?”
- “If the approval policy changes, does the protocol client need to change too?”
- “If the catalog changes while the connection stays alive, who reconciles normalized state?”
- “If the provider changes, falls back, or the stream breaks, who owns reconnect and retry?”

If the answer shows runtime, adapters, or protocol clients each owning part of the tool truth source, the boundary is still unstable.
