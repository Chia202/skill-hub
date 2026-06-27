# Bootstrapping Prompt: Auto-Generate CHECK_PLAN.md + EXECUTION_ORDER.md

This prompt generates a draft proof-check plan for a statistics/theory paper. It supports two modes:

- **Mode A (fully automatic)**: Agent reads the paper and extracts everything. Best when the paper has a clear proof-strategy section and well-labeled dependencies.
- **Mode B (human-guided)**: You provide key insights the agent might miss. Best when the proof strategy is scattered, or you already deeply understand the paper.

---

## Mode A — Fully Automatic

Copy from `## Prompt: Mode A` below. Fill in the three `[...]` fields. Run it.

### When to use Mode A

- The paper has a section called "Proof Strategy", "Proof Outline", or similar
- The intro contains a dependency diagram (TikZ figure, flowchart)
- The appendix has a "Structure of the Proofs" section
- You haven't read the paper deeply yet and want a first-pass map

### Prompt: Mode A

```
You are bootstrapping a proof-check plan for a statistics / theory paper. Do NOT check any proofs — only map the terrain.

Paper: [paper title]
LaTeX source: [path to .tex file]
Appendix starts at: [line number, or "\appendix", or section name]
Prior body-text review (if any): [path, or "none"]

Produce TWO files beside the LaTeX source:
  <paper-dir>/CHECK_PLAN.md
  <paper-dir>/EXECUTION_ORDER.md

---

## Phase A: Extract Proof Architecture (→ CHECK_PLAN.md Part A)

Read these sections from the LaTeX source:
1. Introduction — contributions subsection. Look for TikZ dependency diagrams, flowcharts, relationships between assumptions and theorems.
2. Any section titled "Proof Strategy", "Proof Outline", "Overview of Proofs".
3. The appendix's "Structure of the Proofs" or initial Notation section.

From these, produce:

### A.1 Core Proof Strategy (≤ 5 sentences)
Every good paper has one "trick." State: (a) the fundamental challenge, (b) the solution, (c) the key innovation.

### A.2 Dependency Diagram (ASCII)
Reconstruct from the intro's TikZ figure, or from theorem statements and proof sketches. 
Arrow meaning: "B depends on A" or "A implies B." Be explicit.

### A.3 Critical Proof Chains (3-5 chains)
For each chain, list lemmas/theorems in dependency order from base to final theorem.

### A.4 Key Definitions Table
Notation that appears across multiple sections. Symbol | Meaning | First defined (line number).

---

## Phase B: Index the Appendix (→ CHECK_PLAN.md Part B)

Run grep on the appendix portion for:
1. \section, \subsection headers with line numbers
2. \begin{theorem}, \begin{lemma}, \begin{proposition}, \begin{corollary}, \begin{definition}, \begin{assumption} — with \label and line numbers
3. \begin{proof}...\end{proof} block ranges

Build:
- Appendix structure table: Section | Lines | Content
- Proof unit inventory: ID | Type | Label | Line | Statement summary | Status (all "Unchecked")

---

## Phase C: Build Dependency Graph (→ EXECUTION_ORDER.md)

For each proof unit, extract all \ref{} in its proof. Each target is a dependency.

### C.1 Topological Sort
Layer 0: no internal dependencies (only body assumptions / external theorems)
Layer k: all dependencies in layers < k

### C.2 Parallelism
Units in the same layer are independent → run in parallel.

### C.3 Critical Path
Units cited by ≥ 3 later units, OR on the transitive chain to the main theorem.

### C.4 Phase Grouping
Group consecutive layers. Phase 0 = indexing. Label ‖ vs →.

---

## Phase D: Write Output Files

CHECK_PLAN.md:
  # [Paper] Appendix Proof Check Plan
  ## Context (paper name, file, lines, prior review)
  ## Part A: Proof Architecture (A.1–A.6)
  ## Part B: Appendix Structure (section → lines table)
  ## Part C: Verification Strategy (severity, Pass 0-5 plan, priority order)
  ## Part D: Execution Approach

EXECUTION_ORDER.md:
  # [Paper] — Execution Order & Parallelism
  ## Dependency Map (ASCII DAG)
  ## Phase Plan (table: ID | Unit | Appendix Section | Lines | Content | Depends On)
  ## Parallelism Summary (table: Phase | Parallel | Gate)
  ## Batch Execution (session plan)

## Rules
- EXACT line numbers from grep — do not estimate
- Cross-check every \ref{} against \label{} — report broken refs
- Do NOT check proofs — terrain mapping only
- Mark all units "Unchecked"
- Highlight the key innovation prominently in A.1
- In the Phase Plan, include an "Appendix Section" column (e.g., "D", "H") so each unit maps to the right `04_local_checks/section_X/` directory
- Group units by appendix section within each phase — units in the same section and same phase can share a dependency gate
```

---

## Mode B — Human-Guided

Copy from `## Prompt: Mode B` below. Fill in the knowledge block AND the `[...]` fields. Run it.

### When to use Mode B

- No dedicated "proof strategy" section exists
- The proof strategy is scattered across remarks, proof sketches, and inline comments
- You already understand the paper and want to accelerate bootstrapping
- You know specific tricky dependencies the agent might miss
- The paper uses unconventional notation or structure

### Knowledge Block (fill in before running)

```markdown
## Paper Knowledge Block

### What the paper does (1-2 sentences)
[Your answer here]

### Core proof strategy / trick (2-4 sentences)
[The fundamental challenge and how the paper solves it. Where is this described in the paper? Give section numbers or line ranges if you know them.]

### Dependency overview (optional)
[If you already know how the main theorems depend on the lemmas, sketch it here. Otherwise write "unknown" and the agent will extract it.]

### Where to find things (optional but helpful)
- Proof strategy or overview: [section name, line range, or "scattered — see remarks X, Y, Z"]
- Notation section: [section name or line range]
- Key assumptions: [label names or line ranges]
- Any known tricky parts: [list or "none"]

### Notation conventions (optional)
[Any non-obvious notation the agent should know about. E.g., "E_θ means expectation under fixed-θ randomization, not under the data distribution."]
```

### Prompt: Mode B

```
You are bootstrapping a proof-check plan for a statistics / theory paper. Do NOT check any proofs — only map the terrain.

Paper: [paper title]
LaTeX source: [path to .tex file]
Appendix starts at: [line number, or "\appendix", or section name]
Prior body-text review (if any): [path, or "none"]

I am providing a knowledge block with what I already understand about this paper. Use it to guide your extraction. Fill in any gaps by reading the paper.

[PASTE THE KNOWLEDGE BLOCK HERE]

Produce TWO files beside the LaTeX source:
  <paper-dir>/CHECK_PLAN.md
  <paper-dir>/EXECUTION_ORDER.md

---

## Phase A: Extract Proof Architecture (→ CHECK_PLAN.md Part A)

Start from the knowledge block. Then read the paper to fill gaps and add detail.

Specifically:
- If the knowledge block gives the proof strategy: verify it against the paper text. Expand it with section references and equation numbers.
- If the knowledge block marks something "unknown": extract it from the paper.
- If the knowledge block gives a dependency sketch: verify and expand it into a full ASCII diagram.
- If no knowledge is provided for a section: act as in Mode A (fully automatic extraction).

The output structure is the same as Mode A (A.1 Core Strategy, A.2 Dependency Diagram, A.3 Critical Chains, A.4 Key Definitions).

## Phase B: Index the Appendix
(Same as Mode A — run grep, build tables)

## Phase C: Build Dependency Graph
(Same as Mode A — topological sort, parallelism, critical path, phase grouping)

## Phase D: Write Output Files
(Same as Mode A — CHECK_PLAN.md and EXECUTION_ORDER.md with the specified structure)

## Rules
- Same as Mode A
- Prioritize the knowledge block over auto-extraction when they conflict — but note any discrepancies you find
- If the knowledge block is incomplete, supplement from the paper without asking
```

---

## Usage

1. Pick Mode A or Mode B
2. Fill in the `[...]` fields and (for Mode B) the knowledge block
3. Paste the prompt into Claude Code
4. Agent outputs `CHECK_PLAN.md` + `EXECUTION_ORDER.md`
5. **Human reviews**:
   - Does the dependency graph look right?
   - Are critical chains correctly identified?
   - Is the phase grouping sensible?
   - Are large proof units (>500 lines) flagged?
6. Adjust, then start Phase 0

## Example Knowledge Block (Mode B)

Here is the knowledge block that would have been used for the CBARA paper, as an example:

```markdown
## Paper Knowledge Block

### What the paper does (1-2 sentences)
CBARA is a sequential treatment assignment procedure that simultaneously balances covariates across treatment groups (like CAR) while adapting the targeted allocation ratio as data accumulate (like CARA).

### Core proof strategy / trick (2-4 sentences)
Challenge: CBARA is not Markovian because the allocation parameter θ_n changes each step, but we need Markov chain tools (Poisson equation, geometric ergodicity). Solution: pseudo-Markov chain framework — conditionally on θ_n, the process is governed by a transition kernel P_{θ_n}. Key innovation: coupled robust Lipschitz continuity replaces the V-norm (which fails for CBARA because changing θ moves the destination state, not just the transition probability). Then: Poisson equation → martingale + remainder decomposition → remainder controlled by new discrepancy → CLT.

### Dependency overview (optional)
Four critical chains:
1. Boundedness: drift_condition → convergence_V_as → Thm boundedness
2. LLN: simultaneous ergodicity + Hölder → convergence_average → Thms LLN
3. CLT: coupled Lipschitz → n-step Corollary → Poisson solution Hölder → Lemma CLT → all CLT theorems → IPW
4. Parameter update: estimation consistency/difference → strong adaptation → update theorems

### Where to find things (optional but helpful)
- Proof strategy: Section 5 (lines 1525-1887)
- Notation section: Appendix A.1 (lines 1964-2003)
- Key assumptions: lines 377 (weak adaptation), 386 (strong adaptation), 1035 (Lipschitz), 1137 (small set)

### Notation conventions (optional)
- E_θ = expectation under fixed-θ randomization (not under data distribution)
- π_θ = invariant probability of kernel P_θ
- V(Λ) = exp(λ_1||Λ||) is the Lyapunov function
- d(θ,θ') = ||θ-θ'|| (ℓ_2), d(Λ,Λ') = ||Λ-Λ'|| (ℓ_2)
```
