# Examples

This directory contains example prompts and expected usage patterns for the five core skills in this repository.

Use these examples when:

- you are trying to decide which skill to start with
- you want a prompt shape that reliably triggers the right skill
- you want to compare single-domain vs cross-domain requests

## Included Examples

- [01-whole-system-review.md](./01-whole-system-review.md)
  Cross-domain architecture review using `agent-architecture-orchestrator`
- [02-single-agent-runtime.md](./02-single-agent-runtime.md)
  Single-agent turn loop and tool reinjection using `agent-runtime-architecture`
- [03-shared-surfaces.md](./03-shared-surfaces.md)
  Shared kernel across CLI/API/SDK using `agent-surface-and-adapters`
- [04-multi-agent-decomposition.md](./04-multi-agent-decomposition.md)
  Manager-worker and task-state design using `multi-agent-architecture`
- [05-tooling-protocol-boundaries.md](./05-tooling-protocol-boundaries.md)
  Provider, tool registry, and protocol boundaries using `agent-protocol-and-tooling`

## How To Read These Files

Each example includes:

- the problem shape
- the best starting skill
- a prompt you can reuse directly
- what a good answer should cover
- common boundary mistakes
