# Agent Harness Architecture & Comparison (`harness.md`)

## 1. Executive Summary & Overview
[cite_start]An **agent harness** (or execution engine) is the runtime framework that manages an AI model's context, handles tool execution, maintains session memory, and interfaces with local/cloud environments[cite: 31, 34, 38, 41]. [cite_start]While raw models provide reasoning, the harness determines reliability, persistence, and practical system access[cite: 32, 35, 38, 42].

---

## 2. Breakdown of Reviewed Agent Harnesses

### A. OpenClaw
* [cite_start]**Type:** Local-first, open-source autonomous agent harness[cite: 30, 31].
* [cite_start]**Execution Environment:** Runs locally on user hardware or self-hosted servers, connected via messaging apps (Slack, Telegram, WhatsApp, Discord)[cite: 31, 58].
* [cite_start]**Key Strengths:** High flexibility, complete privacy control, local file/system access, and support for modular skills[cite: 32, 59].
* [cite_start]**Primary Drawbacks:** Can become brittle or experience hallucination loops when handling unconstrained or multi-step tasks without custom scaffolding[cite: 33].

### B. Hermes Agent
* [cite_start]**Type:** Open-source, self-improving persistent agent framework[cite: 34].
* [cite_start]**Execution Environment:** Self-hosted server or CLI runtime[cite: 36, 60].
* [cite_start]**Key Strengths:** Built-in procedural skill learning (records past problem-solving methods to reuse later), long-term session memory, native cron-style task scheduling, and model-agnostic operation[cite: 35, 60].
* [cite_start]**Primary Drawbacks:** Requires developer maintenance for infrastructure, dependencies, and hosting setup[cite: 36].

### C. Claude Co-work (Anthropic)
* [cite_start]**Type:** Managed desktop & cloud desktop agent environment[cite: 37].
* [cite_start]**Execution Environment:** Sandboxed local directories or managed cloud runtimes[cite: 38, 61].
* [cite_start]**Key Strengths:** Low-friction desktop task automation, file organization, contract review, and scheduled workflows for non-technical users[cite: 39, 61].
* [cite_start]**Primary Drawbacks:** Closed ecosystem tied directly to Anthropic's model infrastructure and less customizable than open-source alternatives[cite: 40].

### D. Perplexity Computer
* [cite_start]**Type:** Cloud-orchestrated, multi-model execution harness[cite: 41].
* [cite_start]**Execution Environment:** Isolated cloud microVM sandboxes[cite: 41, 62].
* [cite_start]**Key Strengths:** Asynchronous multi-agent coordination[cite: 42, 62]. [cite_start]Automatically routes tasks to optimal specialized models (e.g., core reasoning vs. research vs. media generation) within secure cloud microVMs[cite: 42, 43].
* [cite_start]**Primary Drawbacks:** High token consumption that requires monitoring, with less direct local host control compared to desktop runtimes[cite: 44, 45].

---

## 3. Comparative Summary Matrix

| Harness | Deployment Model | Execution Environment | Core Focus | Key Trade-off |
| :--- | :--- | :--- | :--- | :--- |
| **OpenClaw** | [cite_start]Open-Source / Self-Hosted [cite: 30, 31] | [cite_start]Local / Messaging Gateway [cite: 31, 58] | [cite_start]Messaging-first personal assistant [cite: 31, 58] | [cite_start]High control vs. potential brittleness [cite: 32, 33] |
| **Hermes Agent** | [cite_start]Open-Source / Self-Hosted [cite: 34, 36] | [cite_start]Server CLI Runtime [cite: 36, 60] | [cite_start]Persistent memory & scheduled automation [cite: 34, 35, 60] | [cite_start]Powerful features vs. self-hosting overhead [cite: 35, 36] |
| **Claude Co-work** | [cite_start]Managed / Closed [cite: 37, 40] | [cite_start]Sandboxed Local Folder / Cloud [cite: 38, 61] | [cite_start]Desktop knowledge work & file operations [cite: 39, 61] | [cite_start]High stability vs. vendor lock-in [cite: 39, 40] |
| **Perplexity Computer** | [cite_start]Managed Cloud [cite: 41] | [cite_start]MicroVM Sandboxes [cite: 41, 62] | [cite_start]Heavy research, coding & multi-agent routing [cite: 42, 43, 62] | [cite_start]High capability vs. high token usage [cite: 43, 45] |

---

## 4. Key Architectural Patterns for Custom Harnesses

If building or extending a custom agent harness (e.g., MyClaw), incorporate these industry standards:

1. [cite_start]**Progressive Skill Disclosure:** Store agent tools and instructions as modular `SKILL.md` files[cite: 73, 74]. [cite_start]Index only YAML metadata at boot to minimize prompt token usage, loading full instructions on demand[cite: 89, 94, 125, 129].
2. [cite_start]**Hybrid Model Routing:** Route low-complexity chat and routing prompts to fast, inexpensive models, reserving frontier reasoning models for sandboxed background execution[cite: 77, 152, 153].
3. [cite_start]**Isolated Sandbox Execution:** Execute arbitrary code, shell calls, or web scrapers within isolated cloud microVMs to prevent host corruption or breaking agent loops[cite: 75, 76, 153].
4. [cite_start]**Persistent Memory Loops:** Maintain long-term memory across sessions via scheduled background consolidation tasks[cite: 34, 162, 163].