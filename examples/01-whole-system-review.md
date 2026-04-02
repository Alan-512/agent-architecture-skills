# Example 1: Whole-System Agent Architecture Review

## Best Starting Skill

`agent-architecture-orchestrator`

## When This Example Fits

Use this pattern when the system mixes more than one domain:

- runtime loop
- API or UI surfaces
- tool/provider integrations
- background jobs or multi-agent coordination

## Prompt

```text
Use agent-architecture-orchestrator to review this agent platform end to end.

Context:
- We have a chat UI, REST API, and background workers.
- The core agent calls tools and model providers.
- Tasks can resume after failure.
- We may add multi-agent workers later.

What I need:
- one merged architecture conclusion
- clear ownership boundaries
- top risks
- phased refactor order
```

## A Good Answer Should Cover

- whether the request is `review` or `refactor`
- which domains are active: runtime, surface, protocol, multi-agent
- a merged layered design
- module ownership conflicts
- migration or rollback guidance if refactor is involved

## Common Mistakes

- answering as if this were only a runtime question
- inventing a new taxonomy instead of reusing the domain skills
- giving an ideal target state with no migration order
