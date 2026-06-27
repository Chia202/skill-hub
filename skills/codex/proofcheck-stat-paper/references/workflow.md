# Reusable Proof-Check Methodology for Statistics/Theory Papers

This document abstracts the methodology developed during the CBARA appendix proof check into a reusable template. It combines the general `guideline.md` (principles, templates, severity system) with paper-specific adaptation and phased parallel execution using coding agents.

## 1. When to Use This

Apply when:
- You have a statistics / probability / ML-theory paper with a long technical appendix (30+ pages)
- The appendix has clear dependency structure (lemmas → theorems)
- You want to use coding agents (Claude Code, Codex, etc.) for systematic checking
- LaTeX source is available (strongly preferred; PDF-only is possible but harder)

## 2. Four Documents You Need

For each paper, create these four planning documents:

| Document | Purpose | When to write |
|---|---|---|
| `guideline.md` | Reusable generic methodology (principles, templates, severity) | Copy once, reuse forever |
| `CHECK_PLAN.md` | Paper-specific proof architecture understanding | Before any checking |
| `EXECUTION_ORDER.md` | Dependency-ordered phased execution plan with parallelism | After CHECK_PLAN.md |
| `FINAL_REPORT.md` | The deliverable | After all checking |

## 3. Step 0: Understand the Paper (→ CHECK_PLAN.md Part A)

Before writing any checks, read these sections of the paper:

1. **Introduction** — especially the contributions subsection and any dependency diagram (TikZ figures, flowcharts)
2. **Proof strategy section** — most papers have one; it explains the "trick"
3. **Appendix structure section** — the appendix's own roadmap
4. **Main theorem statements** — what is actually being proved

From these, extract and write into CHECK_PLAN.md Part A:

- **What does the paper do?** (1 paragraph)
- **What is the core proof strategy?** (the "trick" — every paper has one)
- **Dependency diagram** (extract from paper's own figures or reconstruct from text)
- **Critical proof chains** (trace from base lemmas to main theorems)
- **Key definitions table** (notation that appears everywhere)
- **Appendix structure map** (section → line ranges → content summary)

### Example: Core Proof Strategy Extraction

For the CBARA paper, the strategy was:
```
Challenge: process is non-Markovian, need Markov chain tools
Solution: pseudo-Markov chain + Poisson equation decomposition
Key innovation: coupled robust Lipschitz continuity (replaces V-norm)
```

For YOUR paper, extract the analogous 3-4 sentence summary.

### Example: Dependency Diagram Extraction

CBARA's intro had an explicit TikZ diagram. If your paper doesn't, reconstruct from the theorem statements:
```
Theorem A (LLN) → uses Assumption 1 (weak adaptation)
Theorem B (CLT) → uses Assumption 2 (strong adaptation)  
Assumption 1 ← guaranteed by Theorem C (update mechanism, weak)
Assumption 2 ← guaranteed by Theorem C (update mechanism, strong) + Theorem D (estimation)
```

## 4. Step 1: Build the Execution Order (→ EXECUTION_ORDER.md)

This is the most important step. The execution order translates dependency structure into parallelizable batches.

### 4.1 Extract All Proof Units

From `grep` on the LaTeX source:
```bash
grep -n '\\begin{theorem}\|\\begin{lemma}\|\\begin{proposition}\|\\begin{corollary}\|\\begin{definition}\|\\begin{assumption}' paper.tex
```

Build a table: ID | Type | Label | Line | Dependencies | Used by

### 4.2 Draw the Dependency Graph

For each proof unit, identify:
- Which earlier units does it cite? (its dependencies)
- Which later units cite it? (its dependents)

Draw as ASCII art. The graph determines the phase ordering.

### 4.3 Group into Phases

Rule: a unit goes into phase N if all its dependencies are in phases < N.

Within each phase, units with no mutual dependencies can run in PARALLEL.

Typical phase structure for a statistics paper:

```
Phase 0: Indexing (always first, always parallel)
  - Theorem/lemma inventory
  - Cross-reference audit  
  - Notation ledger

Phase 1: Foundations (definitions + simplest lemmas)
  - Notation section
  - Core definitions
  - Basic lemmas with no internal dependencies

Phase 2-N: Escalating complexity
  - Group by dependency depth
  - Maximize parallelism within each phase

Phase N: Main theorem proofs (always last)
  - Each theorem typically just assembles prior lemmas
  - All can run in parallel once dependencies clear
```

### 4.4 Identify the Critical Path

Some proof units are used by MANY downstream results. These must be checked first within their phase:
- In CBARA: Lemma CLT, Lemma continuity_transition_kernels
- In your paper: identify the 2-3 most-cited lemmas

### 4.5 Write the Execution Order Document

For each phase, specify:
- Phase number and name
- What runs in parallel (‖)
- What is sequential (→)
- Gate conditions (what must complete before this phase starts)
- Estimated effort per unit

## 5. Step 2: Set Up the Workspace

```
<paper-dir>/
  <file>.tex                 # LaTeX source
  CHECK_PLAN.md              # This paper's proof architecture
  EXECUTION_ORDER.md         # Phased execution plan
  audit/
    01_index/
      theorem_inventory.md
      cross_reference_audit.md
      equation_index.md
    02_ledgers/
      notation_ledger.md
      assumption_ledger.md
      constants_ledger.md
    03_dependencies/
      dependency_graph.md
    04_local_checks/
      section_A/             # One folder per appendix section
        lemma_A1_check.md
        lemma_A2_check.md
      section_B/
        ...
    05_adversarial/
      hidden_assumptions.md
      counterexamples.md
    06_reports/
      issue_log.md
      FINAL_REPORT.md
```

## 6. Step 3: Execute Phase by Phase

### Phase 0 / Pass 0: Indexing (always first)

Three parallel tasks, use grep + agents:

1. **Theorem inventory**: Extract all `\begin{theorem}`, `\begin{lemma}`, etc. with labels and line numbers
2. **Cross-reference audit**: Match all `\ref{}` against all `\label{}`; report broken refs
3. **Notation ledger**: Extract definitions from notation section; track body-text issues

### Phases 1-N / Passes 1-2: Proof Unit Checking

For EACH proof unit, provide the agent with a **context package**:

```
1. The full proof text (copy-paste from LaTeX source)
2. The statement being proved
3. Relevant definitions (copy from notation section)
4. Assumptions in scope (list with labels)
5. Dependencies that are already verified (list with verdicts)
6. The expected output format (standardized template)
```

### Agent Prompt Template

Customize this for each proof unit:

```
Check [Lemma/Theorem name] from [Paper name].

Read the proof at [file path], lines [X-Y].

Context:
- Definitions available: [list]
- Assumptions: [list]
- Prior verified results: [list]

Tasks:
1. Restate the claim in your own words
2. List explicit and implicit assumptions
3. Step-by-step verification (table format)
4. Check edge cases
5. Report issues with severity (S0-S3) and confidence (High/Medium/Low)
6. Final verdict: Verified / Conditionally verified / Gap found / Unclear

Rules:
- Do NOT silently fix proofs
- Cite exact line numbers
- Mark unchecked dependencies as "conditionally verified"
- Distinguish "dependency available" from "dependency verified"
```

### Severity System (Standard)

| Level | Meaning |
|---|---|
| S0 | Fatal — main theorem does not follow |
| S1 | Major — missing assumption or incorrect step, likely repairable |
| S2 | Moderate — local ambiguity, may not affect final result |
| S3 | Minor — typo, unclear notation, missing reference |

### Verification Statuses

- **Verified** — all dependencies checked, logic sound
- **Conditionally verified** — correct IF listed dependencies hold
- **Gap found** — specific missing step identified
- **Incorrect** — error found
- **Not checked** — not yet examined

## 7. Step 4: Global Consistency (Pass 3)

After all local checks, verify cross-cutting properties:

1. **No circular dependencies** — trace every chain to base assumptions
2. **Notation consistent** — no symbol drift between sections
3. **Assumptions propagate** — every cited assumption is in scope
4. **Theorems assemble correctly** — each main theorem's transitive dependencies are all proved
5. **Cross-formula consistency** — formulas that should match, do match

## 8. Step 5: Adversarial Review (Pass 4)

Systematically try to break each proof:

1. **Hidden assumptions**: Division by zero? Matrix invertibility? Limit/expectation exchange? Compactness without continuity?
2. **Counterexamples**: d=1, N=1, zero-variance, boundary of parameter space, degenerate cases
3. **Quantifier errors**: Pointwise vs. uniform, parameter-dependent vs. universal constants
4. **External theorem misuse**: Do cited theorems actually say what the paper claims?
5. **Constants/rates**: Does n^2 overwhelm exponential decay? Are O_P(1) terms uniform enough?

## 9. Step 6: Final Report (Pass 5)

Synthesize everything into `FINAL_REPORT.md`:

1. Executive summary (1 paragraph + statistics)
2. Verified results table
3. Open issues ranked by severity
4. Conditional results (depends on unchecked upstream)
5. Recommended repairs
6. Final judgment
7. Unchecked scope (be honest about what wasn't checked)

## 10. Paper-Type-Specific Adaptations

### For Papers with Asymptotic Theory (CBARA-like)
- Check that o_P(1), O_P(1), o(1), O(1) are used correctly
- Verify CLT/Lindeberg conditions carefully
- Check that rates compose correctly through chains of lemmas
- Watch for uniform vs. pointwise convergence

### For Papers with Concentration Inequalities
- Check tail conditions (sub-Gaussian, sub-exponential, bounded moment)
- Verify union bounds over potentially infinite classes
- Check that δ (failure probability) propagates correctly

### For Papers with Optimization Theory
- Check convexity/smoothness assumptions
- Verify that minima exist (compactness + continuity)
- Check step size conditions in iterative algorithms
- Watch for local vs. global optimum confusion

### For Papers with Markov Chain Theory
- Check drift conditions are uniform over parameter space
- Verify small set conditions are simultaneous (not pointwise)
- Watch for geometric ergodicity vs. plain ergodicity
- Check that Poisson equation solution is well-defined

### For Papers with M-Estimation
- Check identifiability (unique maximizer)
- Verify score function has mean zero
- Check Hessian invertibility
- Watch for IP-weighting complications

## 11. Time Estimation

| Paper Size | Appendix Lines | Estimated Sessions |
|---|---|---|
| Small | <2000 | 1-2 sessions |
| Medium | 2000-5000 | 3-5 sessions |
| Large | 5000-10000 | 5-10 sessions |
| Very Large | >10000 | 10+ sessions |

## 12. Quick-Start Checklist

For a NEW paper, do this in order:

- [ ] Read `guideline.md` (at toolkit root — principles, severity, templates)
- [ ] Read intro + proof strategy + appendix structure
- [ ] Write CHECK_PLAN.md Part A (proof architecture understanding)
- [ ] Write CHECK_PLAN.md Part B (appendix structure with line ranges)
- [ ] Index proof units (use `scripts/index.sh` or manual grep)
- [ ] Draw dependency graph
- [ ] Write EXECUTION_ORDER.md (phased plan with parallelism)
- [ ] Create audit/ directory structure (use `scripts/scaffold.sh` or manual mkdir)
- [ ] Run Phase 0 (indexing)
- [ ] Run Phase 1 (foundations)
- [ ] Continue through remaining phases
- [ ] Run global consistency check
- [ ] Run adversarial review
- [ ] Write final report
