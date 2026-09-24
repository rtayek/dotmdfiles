The discussion evaluated several candidate languages and representations for defining rules, contracts, and invariants in `.md` files, weighing LLM parsing reliability against human expressiveness:

### 1. Evaluated Formats

* **Narrative English (Natural Language Prose):**
* *Verdict:* **Rejected for core contracts.**
* *Why:* Causes instruction drift, ambiguous interpretations, and conversational fluff over multi-turn context windows.


* **Formal Logic & Rigorous Specification (Prolog, Z-Notation, TLA+):**
* *Verdict:* **Rejected.**
* *Why:* While mathematically precise, modern LLMs lack dense pre-training data for these formalisms in context-instruction tasks, often misinterpreting syntax or generating non-standard inferences.


* **Compact Markdown Tables & RFC 2119 Standards:**
* *Verdict:* **Adopted for permanent rules (Invariants).**
* *Why:* Standard RFC 2119 keywords (`MUST`, `MUST NOT`, `SHOULD`) paired with concise Markdown decision tables align strongly with the model's pre-training distribution, suppressing conversational drift while remaining dense and human-readable.


* **Structured Data Formats (YAML / JSON Schemas):**
* *Verdict:* **Adopted for executable workflows (Skills & Dispatch).**
* *Why:* Ideal for tool definitions and task contracts (defining `preconditions`, `postconditions`, parameters, and shell invocations) because LLMs reliably parse and output structured key-value maps without creative embellishments.


* **POSIX / Bourne Shell (`sh`):**
* *Verdict:* **Adopted for the execution layer.**
* *Why:* Provides deterministic enforcement. Scripts are treated not as prompt text, but as concrete effectors that validate and enforce the formatting rules specified in the `.md` contracts.



---

### 2. The Final Separation of Concerns

The conclusion separated instructions into two distinct linguistic layers:

1. **Dispositional Rules (`AGENTS.md`):** Written in **RFC 2119 Markdown tables** to define invariant tastes, character constraints, and behavioral boundaries (e.g., `INV-NAME`, `INV-PROSE`, `INV-CHARS`).
2. **Dispatchable Skills:** Written as **typed YAML/JSON contract blocks** specifying exact script inputs, outputs, and exit codes for deterministic execution.