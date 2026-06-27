# Tutorial: Checking the CBARA Paper Appendix

This walks through a complete proof check using the toolkit. The paper is CBARA (covariate-balanced-and-adjusted response-adaptive randomization), ~8359 lines of LaTeX, appendix is ~6400 lines.

## Step 1: What You Start With

```
my-paper/
  flat.tex                  ← the paper (LaTeX source)
  technical_review_report.md ← optional: prior body-text review

  proofcheck-stat-paper/    ← this toolkit (copied or cloned)
    README.md
    guideline.md
    workflow.md
    bootstrap.md
    tutorial/               ← you are here
```

## Step 2: Read guideline.md (15 min)

Skim once. Don't read the templates in detail — just understand the core objective (test whether proofs are correct), the severity system (S0-S3), and the principle of "no silent repairs."

## Step 3: Run bootstrap.md

This paper has a clear proof-strategy section (Section 5) and a dependency diagram in the intro, so use **Mode A** (fully automatic).

Fill in the fields at the top of the prompt in `bootstrap.md`:

```
Paper: CBARA
LaTeX source: flat.tex
Appendix starts at: line 1957 (\appendix)
Prior body-text review: technical_review_report.md
```

Run the prompt. The agent reads the paper and produces two files.

### Output: CHECK_PLAN.md

→ See [`1-check-plan/CHECK_PLAN.md`](1-check-plan/CHECK_PLAN.md) for the full file.

Key sections it contains:
- **Part A**: Proof architecture — what CBARA does, the core proof strategy (pseudo-Markov chain + Poisson equation + coupled robust Lipschitz), the dependency diagram from the intro, four critical proof chains, and a key-definitions table
- **Part B**: Appendix structure mapped to line ranges (10 sections, lines 1957-8359)
- **Part C**: Verification strategy with severity system and Pass 0-5 plan
- **Part D**: Execution approach

### Output: EXECUTION_ORDER.md

→ See [`1-check-plan/EXECUTION_ORDER.md`](1-check-plan/EXECUTION_ORDER.md) for the full file.

Key sections:
- **Dependency Map**: ASCII art of the full DAG, showing which lemmas depend on which
- **Phase Plan**: 7 phases, each with parallel/sequential annotations
- **Parallelism Summary**: which units can run simultaneously, and what gates each phase
- **Batch Execution**: 12 suggested sessions

## Step 4: Human Review (15 min)

Before executing, review both outputs:

- [x] Dependency graph: are there any missing edges?
- [x] Critical chains: are the 4 most important chains correctly identified?
- [x] Phase grouping: are parallel groups correct? Are there hidden sequential dependencies?
- [x] Large units flagged: Small Set proof (~670 lines), Simultaneous Ergodicity (~635 lines)

## Step 5: Execute Phase 0 — Indexing

Three agents run in parallel. Each writes to `audit/`.

### Output: theorem_inventory.md

→ See [`2-phase-output/theorem_inventory.md`](2-phase-output/theorem_inventory.md) for the full file.

47 proof units inventoried: 10 body theorems + 37 appendix lemmas/theorems/definitions, each with label, line number, dependencies, and "Used by" references.

### Output: cross_reference_audit.md (not included — summary)

- 0 broken refs
- 8 orphan labels
- All 13 external citations verified in Library.bib

### Output: notation_ledger.md (not included — summary)

- 42 symbols cataloged across 8 categories
- Body Issues 2-3 resolved in appendix; Issue 4 sidestepped

## Step 6: Execute Phase 1 — Foundations

Four agents run in parallel. Each gets a **context package**: the proof text + definitions + assumptions + prior verified results.

### Output: transition_kernel_check.md

→ See [`2-phase-output/transition_kernel_check.md`](2-phase-output/transition_kernel_check.md) for the full file.

This is what a single proof-unit check looks like. It contains:
- Restated claim
- Explicit and implicit assumptions
- Step-by-step verification table (Step | Line | Claim | Justification | Verdict)
- Edge case analysis
- Issues found (none in this case)
- Final verdict: Fully Verified, High confidence

All 33 proof units follow this same format.

## Step 7: Continue Through Phases 2-7

| Phase | Units | Result |
|-------|-------|--------|
| 0 | 3 indexing tasks | 0 broken refs, 47 units |
| 1 | 4 foundations | All verified |
| 2 | 4 Markov chain | 1 S2 issue |
| 3 | 3 drift/ergodicity | 1 S2 issue |
| 4 | 4 small set/LLN | 1 S2 issue |
| 5 | 4 CLT preparation | 1 S1 issue |
| 6 | 1 Lemma CLT | Verified (most critical unit) |
| 7 | 10 main theorems | All verified |

## Step 8: Final Report (Passes 3-5)

After all local checks: global consistency → adversarial review → final report.

### Output: FINAL_REPORT.md

→ See [`3-final-report/FINAL_REPORT.md`](3-final-report/FINAL_REPORT.md) for the full file.

```
Overall verdict: Correct modulo minor repairs
Main theorem support: All 4 critical chains terminate correctly
Highest severity: S1 (L^2 product bound issue)
Proof units checked: 33
Open issues: 18 (S1: 1, S2: 5, S3: 12)
```

## Complete Output Tree

```
my-paper/
  CHECK_PLAN.md
  EXECUTION_ORDER.md
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
      section_A_structure/
      section_B_main_theorems/
      section_C_IPW/
      section_D_CBARA_lemmas/
      section_E_estimation_lemmas/
      section_F_allocation_form/
      section_G_CLT/
      section_H_markov_chain/
      section_I_additional/
    05_adversarial/
      adversarial_review.md
    06_reports/
      FINAL_REPORT.md
```

## Key Takeaway

The agents did the tedious work: reading 6400 lines of proofs, cross-referencing 200+ labels, checking algebraic manipulations step by step. Human time was spent on: reviewing bootstrap output (~15 min), reviewing ~5% of agent outputs that had issues, and writing the final judgment.
