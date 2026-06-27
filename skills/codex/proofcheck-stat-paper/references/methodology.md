# Proof Check General Guideline

This document is a reusable workflow for checking long paper appendix proofs with the help of coding agents such as Claude Code, Codex, or similar tools. It is designed for mathematics and theoretical computer science papers, especially appendices with many definitions, lemmas, theorem dependencies, asymptotic statements, and technical proof chains.

The purpose is not to summarize the proof. The purpose is to test whether the proof is correct.

## 1. Core Objective

A proof check should answer the following question:

> Given the paper's stated assumptions, definitions, and cited results, does each claimed theorem follow with the stated constants, rates, quantifiers, probability levels, domains, and edge cases?

The checker should verify:

- The statement of every theorem, lemma, proposition, corollary, and claim.
- The precise assumptions needed for each result.
- Whether all variables, events, parameters, norms, distributions, filtrations, and domains are defined before use.
- Whether each proof step follows from previous results, stated assumptions, or valid external facts.
- Whether constants, rates, probability bounds, dimensions, and asymptotic regimes are propagated correctly.
- Whether quantifiers are correct and appear in the correct order.
- Whether edge cases and boundary cases are handled.
- Whether references to earlier equations, lemmas, appendices, or external papers are valid.
- Whether there are circular dependencies.
- Whether notation drifts across sections.
- Whether the final theorem actually follows from the intermediate results.

The checker should not silently repair the proof. If a proof can be fixed by adding an assumption or changing a constant, record the issue and the proposed repair separately.

## 2. Operating Principles

Use these principles throughout the check.

### 2.1 Evidence First

Every conclusion should cite exact evidence:

- Page number.
- Section or appendix label.
- Theorem, lemma, proposition, definition, assumption, or equation number.
- If working from LaTeX source, the file path and line number when available.

Avoid vague references such as "earlier" or "by standard arguments" unless the argument is explicitly reconstructed.

### 2.2 Small Proof Units

Break the appendix into small units:

- One definition.
- One assumption block.
- One lemma statement.
- One lemma proof.
- One theorem proof.
- One technical inequality.
- One dependency chain.

Do not ask an agent to verify a 20-page proof at once. Ask it to verify a bounded proof unit and produce a structured audit record.

### 2.3 Separate Facts, Inferences, and Suspicions

Use three categories:

- Verified: directly checked and supported by references.
- Inferred: likely true, but not explicitly stated or fully checked.
- Suspect: possible gap, ambiguity, mismatch, or error.

Do not mix these categories in the same paragraph.

### 2.4 No Silent Repairs

If the paper claims statement A but the proof proves statement B, record that mismatch.

Acceptable output:

> The proof appears to establish the result under the additional condition `n >= C d log d`, but the lemma statement only assumes `n >= C d`. This is a missing assumption unless another earlier result implies the logarithmic factor.

Unacceptable output:

> The lemma is fine if we add the missing log factor.

### 2.5 Human Owns Final Judgment

Agents are useful for indexing, cross-reference checking, algebraic reconstruction, and adversarial review. They are not the final authority. A human should review every high-severity issue, every proposed repair, and every result marked "verified."

## 3. Recommended Workspace Structure

For each paper, use the directory that contains the target `.tex` file:

```text
<paper-dir>/
  <file>.tex                      # LaTeX source
  CHECK_PLAN.md                   # Proof architecture + verification strategy
  EXECUTION_ORDER.md              # Dependency-ordered phased plan
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
      section_A/                  # One folder per appendix section
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

If time is limited, at minimum maintain:

- `01_index/theorem_inventory.md`
- `02_ledgers/assumption_ledger.md`
- `03_dependencies/dependency_graph.md`
- `06_reports/issue_log.md`
- `06_reports/FINAL_REPORT.md`

## 4. Proof-Check Roles

When using multiple agents, assign narrow roles.

### 4.1 Indexer

Creates inventories:

- Definitions.
- Assumptions.
- Theorems.
- Lemmas.
- Equations.
- External citations.
- Notation.

The indexer should not judge correctness except for obvious missing references or duplicated labels.

### 4.2 Local Checker

Checks one proof unit at a time:

- Restates the claim.
- Lists required inputs.
- Verifies each proof step.
- Identifies gaps.
- Assigns confidence.

### 4.3 Dependency Checker

Builds and audits the dependency graph:

- Which result depends on which earlier result.
- Whether dependencies are available at the point of use.
- Whether any cycles exist.
- Whether final theorem dependencies are complete.

### 4.4 Notation Checker

Tracks notation consistency:

- Same symbol used for different objects.
- Same object given different names.
- Ambiguous overloaded notation.
- Missing dimensions or domains.
- Changed constants.

### 4.5 Adversarial Checker

Looks for failure modes:

- Counterexamples.
- Boundary cases.
- Missing assumptions.
- Invalid quantifier swaps.
- Hidden independence assumptions.
- Union bound mistakes.
- Conditioning mistakes.
- Non-uniform convergence treated as uniform.

### 4.6 Final Auditor

Consolidates all records:

- Verified results.
- Open issues.
- Severity ranking.
- Confidence ranking.
- Required repairs.
- Whether the main theorem is supported.

## 5. Full Workflow

The workflow has nine stages.

1. Ingest and index the document.
2. Build theorem and definition inventory.
3. Build notation and assumption ledgers.
4. Build dependency graph.
5. Check local proof units.
6. Check global consistency.
7. Run adversarial checks.
8. Grade confidence and severity.
9. Produce final proof-check report.

Each stage should leave a written artifact. The artifact matters because long proof checks fail when reasoning is not preserved.

### Stage-to-Pass Mapping

When using the pass-based cadence (Section 17), the detailed stages map to passes as follows:

| Stage(s) | Maps to Pass |
|---|---|
| 1-5 (Ingestion, Inventory, Notation, Assumptions, Dependency Graph) | Pass 0: Indexing |
| 6 (Local Proof Checking) | Pass 1-2: Critical Path + Support Lemmas |
| 7 (Global Consistency) | Pass 3: Global Consistency |
| 8 (Adversarial Checks) | Pass 4: Adversarial Review |
| 9 (Severity/Confidence + Final Report) | Pass 5: Final Report |

## 6. Stage 1: Document Ingestion and Indexing

### 6.1 Inputs

Collect all available sources:

- Main paper PDF.
- Appendix PDF.
- LaTeX source, if available.
- Supplementary notes.
- Errata.
- Code or experiment appendix, if proof depends on algorithms.
- External theorem references, if repeatedly used.

### 6.2 Extraction

If working from PDF:

- Extract text.
- Check whether equations were corrupted.
- Check whether theorem labels survived extraction.
- Use screenshots or PDF page references for complex displays.

If working from LaTeX:

- Preserve file names and line numbers.
- Index labels such as `\label{...}` and references such as `\ref{...}`.
- Track macros, because many notation errors hide inside macros.

### 6.3 First-Pass Index

Create a first-pass table:

| ID | Type | Location | Short name | Statement summary | Depends on | Used by | Status |
|---|---|---|---|---|---|---|---|
| A.1 | Lemma | App. A, p. 31 | Concentration event | Bounds event probability | Assumption 2, Eq. 14 | Thm 3.1 | Unchecked |

The statement summary should be short. Do not replace the formal statement with the summary.

## 7. Stage 2: Theorem, Lemma, and Definition Inventory

Create an inventory of all formal objects.

### 7.1 Formal Results

Record:

- Label and number.
- Exact statement location.
- Mathematical objects involved.
- Assumptions explicitly listed.
- Assumptions inherited from the section.
- Claimed conclusion.
- Probability level or asymptotic regime, if any.
- Constants and whether they are universal, absolute, problem-dependent, or unspecified.
- Where the result is used.

### 7.2 Definitions

Record:

- Defined symbol.
- Definition location.
- Domain and codomain.
- Whether definition depends on parameters.
- Whether definition is reused with changed parameters later.
- Whether multiple definitions use the same symbol.

### 7.3 Assumptions

Record:

- Named assumptions.
- Local assumptions inside a lemma or proof.
- Standing assumptions for a section.
- Implicit assumptions used but not stated.

For long appendices, standing assumptions are a common source of errors. Always ask:

- Does the proof unit explicitly inherit this assumption?
- Is the assumption available in this appendix section?
- Is the assumption stronger or weaker than what the proof uses?

## 8. Stage 3: Notation Ledger

Maintain a notation ledger throughout the check.

| Symbol | Meaning | First defined | Domain / type | Parameters | Later uses | Issues |
|---|---|---|---|---|---|---|
| `X_i` | Random vector | Sec. 2, p. 4 | `R^d` | distribution `P` | Lemma B.2 | None |
| `C` | Universal constant | App. A, p. 28 | positive scalar | may change line to line | Many | Ambiguous in Thm C.1 |

### 8.1 Notation Drift Checks

Check for:

- A symbol first used before definition.
- A symbol redefined without warning.
- A vector treated as scalar.
- A deterministic quantity treated as random.
- A random variable treated as independent without justification.
- A norm changing from `l2` to operator norm.
- Constants changing from universal to distribution-dependent.
- Index sets changing from finite to infinite.
- Probability events changing while retaining the same name.

### 8.2 Macro Checks for LaTeX Source

If LaTeX source is available:

- Inspect custom macros.
- Expand macros for critical definitions.
- Check whether similar-looking macros denote different objects.
- Search for redefinitions of commands.
- Verify that notation in displayed equations matches notation in text.

## 9. Stage 4: Assumption Ledger

Create an assumption ledger.

| ID | Assumption | Location | Scope | Used by | Strength needed | Status |
|---|---|---|---|---|---|---|
| A1 | Samples are i.i.d. | Sec. 2 | Global | Lemma B.1, B.2 | Independence of all samples | Explicit |
| H1 | Matrix is invertible | Lemma C.3 proof | Local / implicit | Lemma C.3 | Minimum eigenvalue positive | Missing in statement |

### 9.1 Assumption Types

Classify assumptions as:

- Distributional.
- Geometric.
- Smoothness.
- Convexity.
- Boundedness.
- Moment or tail condition.
- Independence.
- Identifiability.
- Sample-size.
- Dimension-growth.
- Regularity or measurability.
- Algorithmic.
- Initialization.
- Step-size.
- Event-based.

### 9.2 Hidden Assumption Tests

For each proof unit, ask:

- Does the proof divide by a quantity that may be zero?
- Does it invert a matrix without proving invertibility?
- Does it exchange limits, expectations, derivatives, or integrals?
- Does it apply concentration without checking independence or tail assumptions?
- Does it apply compactness without compact domain?
- Does it use continuity, differentiability, Lipschitzness, or boundedness without stating it?
- Does it assume a minimizer exists?
- Does it assume uniqueness where only existence is stated?
- Does it condition on an event of positive probability?
- Does it use high-probability statements simultaneously without adjusting probability?
- Does it claim a uniform result while proving only pointwise control?

## 10. Stage 5: Dependency Graph

Build a dependency graph before checking proofs deeply. The graph prevents circular reasoning and helps prioritize critical lemmas.

### 10.1 Dependency Table

| Result | Direct dependencies | External dependencies | Used by | Dependency status |
|---|---|---|---|---|
| Lemma A.1 | Def. 2.1, Assumption 1 | Hoeffding inequality | Lemma A.3 | Valid |
| Lemma A.3 | Lemma A.1, Lemma A.2 | None | Theorem 3.1 | A.2 unchecked |

### 10.2 Dependency Rules

For every dependency:

- The dependency must be stated before use or clearly imported.
- Its assumptions must be satisfied at the point of use.
- Its conclusion must match the needed form.
- Any constants, domains, and probability levels must be compatible.
- If the dependency is external, the cited theorem must actually say what the paper uses.

### 10.3 Circularity Checks

Look for:

- Lemma A uses Lemma B, directly or indirectly, while Lemma B uses Lemma A.
- The main theorem is used in an appendix proof that supports the main theorem.
- A corollary is used to prove a theorem from which the corollary follows.
- A result is used before its assumptions are established.

Mark circular dependencies as high severity unless they are purely expository and not logically necessary.

## 11. Stage 6: Local Proof Checking

Local proof checking is the core activity. Work one proof unit at a time.

### 11.0 Output Structure — One File Per Unit

Each proof unit gets its own check file. Do not aggregate multiple units into one file — aggregation hides which units were checked, prevents parallel review, and makes it impossible to track per-unit status.

Organize files by appendix section:

```
04_local_checks/
  section_A_notation/            # One directory per appendix section
    A1_definition_1.md           # One file per proof unit
    A2_definition_2.md
  section_B_main_theorems/
    B1_theorem_1.md
    B2_theorem_2.md
  section_C_lemma_group/
    C1_lemma_transition.md
    C2_lemma_drift.md
```

File naming convention: `{section_letter}{sequence}_{descriptive_name}.md`. The directory name matches the appendix section; the file name identifies the specific unit.

Each file follows the same template:
1. **Faithful Restatement** — the claim, all assumptions used, all definitions invoked
2. **Step-by-Step Verification** — each step with paper text, claimed reason, verification, and verdict
3. **Edge Case and Condition Analysis** — boundary values, hidden assumptions, domain restrictions
4. **Dependency Table** — what this unit depends on and whether those dependencies are verified
5. **Summary** — overall verdict and confidence level

For a large proof unit (>300 lines or >15 steps), split it into sub-units with separate files (e.g., `C3a_small_set_sketch.md`, `C3b_small_set_formal.md`).

### 11.1 Local Proof Unit Checklist

For each proof unit:

- Identify the exact claim.
- Rewrite the claim in your own words.
- List all explicit assumptions.
- List all implicit or inherited assumptions.
- List all definitions used.
- List all previous results invoked.
- Check every equation transition.
- Check every inequality direction.
- Check every quantifier.
- Check every probability statement.
- Check every constant and rate.
- Check every domain and dimension.
- Check every boundary case.
- Check conclusion against the statement.
- Assign a confidence grade.
- Record all issues.

### 11.2 Step-by-Step Verification

For each proof paragraph or display equation:

| Step | Paper text / equation | Claimed reason | Required facts | Verification | Issue |
|---|---|---|---|---|---|
| 1 | Eq. (42) to (43) | Triangle inequality | Same norm on both terms | Valid | None |
| 2 | Eq. (43) to (44) | Lemma A.2 | Lemma A.2 requires boundedness | Not established | Missing assumption |

### 11.3 Common Local Errors

Check especially for:

- Incorrect inequality direction.
- Dropping an absolute value.
- Replacing expectation of product by product of expectations.
- Treating dependent variables as independent.
- Applying Jensen's inequality in the wrong direction.
- Applying union bound over an infinite class without covering argument.
- Confusing `O`, `o`, `O_p`, and high-probability bounds.
- Losing a logarithmic factor.
- Losing dimension dependence.
- Changing constants from line to line in a theorem where constants must be fixed.
- Using a result outside its valid parameter range.
- Forgetting measurability.
- Swapping supremum and expectation without justification.
- Proving convergence for fixed parameter but claiming uniform convergence.
- Proving existence but using uniqueness.
- Assuming a minimum exists when only an infimum is guaranteed.

## 12. Stage 7: Global Consistency Checking

After local checks, audit the entire proof system.

### 12.1 Statement Consistency

Check whether:

- Main theorem assumptions match appendix assumptions.
- Lemma conclusions are strong enough for later use.
- Later proofs use the same parameter definitions as earlier statements.
- Probability events are combined correctly.
- Constants are consistently scoped.
- The final rate matches the rate proved in intermediate lemmas.
- The paper does not switch between finite-sample and asymptotic statements without justification.

### 12.2 Quantifier Consistency

Quantifier errors are subtle and common.

Check whether the paper proves:

- For every parameter, there exists a constant.
- There exists a constant such that for every parameter.
- With high probability, uniformly over all parameters.
- For every parameter, with high probability.

These are not interchangeable.

Record exact quantifier order:

```text
Claimed:
  exists C > 0 such that for all n,d and all theta in Theta, ...

Proved:
  for each theta in Theta, there exists C(theta) > 0 such that ...

Issue:
  The proof gives a parameter-dependent constant but the theorem claims a uniform constant.
```

### 12.3 Probability and Event Consistency

For probabilistic proofs, maintain an event ledger.

| Event | Definition | Probability | Depends on | Used where | Notes |
|---|---|---|---|---|---|
| `E_1` | Concentration of sample mean | `>= 1 - delta` | Lemma B.1 | Thm 2.1 | Valid for fixed `theta` |
| `E_all` | Intersection of events | `>= 1 - 3 delta` | `E_1,E_2,E_3` | Main theorem | Check union bound |

Check:

- Are all high-probability events defined?
- Are event intersections explicitly handled?
- Is the failure probability accumulated correctly?
- Does a result condition on an event and later forget the conditioning?
- Are random and deterministic quantities clearly separated?
- Are "with probability at least" and "in expectation" mixed incorrectly?

### 12.4 Constants and Rates

Maintain a constants ledger when constants matter.

| Constant | First appears | Meaning | Dependencies | Can change? | Issue |
|---|---|---|---|---|---|
| `C` | Lemma A.1 | Universal constant | None | Yes, line by line | Fine |
| `c_0` | Assumption 3 | Minimum curvature | Distribution | No | Used as universal in Lemma C.2 |

Check:

- Whether constants are absolute, universal, problem-dependent, or sample-size-dependent.
- Whether a constant is reused with a different meaning.
- Whether constants hidden in `O(...)` depend on forbidden quantities.
- Whether rates preserve all dependencies on `n`, `d`, `delta`, `epsilon`, condition numbers, smoothness constants, and tail parameters.
- Whether asymptotic notation is used in a finite-sample theorem.

## 13. Stage 8: Adversarial Checks

After normal verification, deliberately try to break the proof.

### 13.1 Counterexample Search

Ask:

- What happens when dimension is 1?
- What happens when sample size is minimal?
- What happens when variance is zero?
- What happens when a matrix is singular or nearly singular?
- What happens at the boundary of the parameter space?
- What happens when the distribution has heavy tails?
- What happens if two parameters are equal?
- What happens if an event has probability zero?
- What happens if the function is flat, non-unique, or non-smooth?

If the theorem excludes these cases, cite the exclusion. If not, record the gap.

### 13.2 Stress the Assumptions

For each assumption:

- Remove it and see which proof step fails.
- Weaken it and see whether the theorem still appears to hold.
- Check whether the proof uses a stronger version than stated.
- Check whether the theorem statement includes assumptions not used by the proof.

Unused assumptions are not necessarily errors, but they may indicate a mismatch between theorem and proof.

### 13.3 External Theorem Misuse

When the paper invokes a known theorem:

- Check the exact theorem statement.
- Check all prerequisites.
- Check whether the theorem is finite-sample or asymptotic.
- Check whether it gives pointwise or uniform control.
- Check whether constants and dimensions match.
- Check whether the cited result uses the same notation.

Record citation misuse as high severity when the external theorem is central.

## 14. Stage 9: Severity and Confidence

Every issue should have both severity and confidence.

### 14.1 Severity Levels

Use these levels:

- S0: Fatal. The main theorem or a central lemma does not follow.
- S1: Major. A key assumption, dependency, or proof step is missing or incorrect, but likely repairable.
- S2: Moderate. Local ambiguity, incomplete justification, or mismatch that may not affect the final theorem.
- S3: Minor. Typo, unclear notation, missing reference, or expository issue.

### 14.2 Confidence Levels

Use these levels:

- High: The issue is directly supported by exact references and reconstructed reasoning.
- Medium: The issue is likely, but depends on interpretation or an unchecked dependency.
- Low: The issue is a suspicion that requires further review.

### 14.3 Verification Status

For each proof unit, assign one status:

- Verified.
- Verified with minor comments.
- Conditionally verified.
- Unclear.
- Gap found.

### 14.4 Issue Tracking — Single Source of Truth

Issues must be tracked consistently across all audit files. The rule is:

1. **`ISSUE_LOG.md` is canonical.** Every issue gets a unique ID (`I-01`, `I-02`, ...) with severity, location, description, and status. This is the only place that defines what issues exist.

2. **Local check files reference issues by ID.** When a check file finds a problem, it writes the finding in the check file and records the ID. Never describe the same issue independently in two check files without using the same ID.

3. **`FINAL_REPORT.md` imports from `ISSUE_LOG.md`.** The issue summary table in the final report is derived from `ISSUE_LOG.md`, not written independently.

4. **Run `scripts/issues.sh` at the end of Pass 5.** This script cross-references all three sources and reports:
   - Issues in `ISSUE_LOG.md` that are never referenced in any local check file
   - Issues found in local check files that are missing from `ISSUE_LOG.md`
   - Severity count mismatches between `ISSUE_LOG.md` and `FINAL_REPORT.md`

If the script reports errors, fix them before finalizing the report. This guarantees that issue counts and severities are consistent everywhere.
- Incorrect.
- Not checked.

Do not mark a result "verified" if a required dependency remains unchecked. Use "conditionally verified" instead.

## 15. Reusable Templates

### 15.1 Proof-Unit Checklist

```markdown
## Proof Unit: [ID / Name]

- Location:
- Type: [definition / lemma / proposition / theorem / proof segment]
- Checked by:
- Date:
- Status:
- Confidence:

### Statement

[Copy or precisely paraphrase the formal statement.]

### Explicit Assumptions

- [Assumption 1]
- [Assumption 2]

### Inherited / Implicit Assumptions

- [Standing assumption]
- [Potential hidden assumption]

### Dependencies

| Dependency | Location | Required form | Available? | Notes |
|---|---|---|---|---|
| [Lemma] | [Location] | [Needed conclusion] | [Yes/No/Partial] | [Notes] |

### Step Check

| Step | Location | Claim | Justification | Verdict | Notes |
|---|---|---|---|---|---|
| 1 | [Eq./paragraph] | [Claim] | [Reason] | [Valid/Gap] | [Notes] |

### Edge Cases

- [Boundary case checked]
- [Degenerate case checked]

### Issues

| Severity | Confidence | Description | Evidence | Proposed repair |
|---|---|---|---|---|
| [S0-S3] | [High/Medium/Low] | [Issue] | [Reference] | [Repair or none] |

### Final Verdict

[Verified / Conditionally verified / Gap found / Incorrect / Unclear]
```

### 15.2 Lemma Audit Record

```markdown
## Lemma Audit: [Lemma number]

### Claim

[Exact statement or faithful formal rewrite.]

### What the Lemma Must Provide Later

- Used by:
- Required conclusion:
- Required assumptions at use site:

### Proof Reconstruction

1. [Step]
2. [Step]
3. [Step]

### Mismatches

- Statement vs proof:
- Proof vs later use:
- Constants/rates:
- Quantifiers:
- Domains:

### Verdict

- Status:
- Severity of worst issue:
- Confidence:
- Follow-up needed:
```

### 15.3 Dependency Table

```markdown
| Node | Type | Depends on | Used by | Assumptions required | Status | Notes |
|---|---|---|---|---|---|---|
| [Lemma A.1] | Lemma | [Def 2.1, Assump 1] | [Lemma A.3] | [i.i.d., bounded] | [Checked] | [Notes] |
```

### 15.4 Assumption Ledger

```markdown
| ID | Assumption | Location | Scope | Used by | Is it stated? | Is it sufficient? | Notes |
|---|---|---|---|---|---|---|---|
| [A1] | [Assumption text] | [Location] | [Global/Local] | [Results] | [Yes/No] | [Yes/No/Partial] | [Notes] |
```

### 15.5 Notation Ledger

```markdown
| Symbol | Meaning | First definition | Type/domain | Parameters | Later use | Drift risk |
|---|---|---|---|---|---|---|
| [x] | [Meaning] | [Location] | [Type] | [Parameters] | [Locations] | [None/Low/High] |
```

### 15.6 Issue Report

```markdown
## Issue [ID]: [Short title]

- Severity: [S0/S1/S2/S3]
- Confidence: [High/Medium/Low]
- Location:
- Affected result:
- Affected downstream results:

### Problem

[Describe the issue precisely.]

### Evidence

- [Reference 1]
- [Reference 2]

### Why It Matters

[Explain whether this blocks the proof, weakens the theorem, or creates ambiguity.]

### Possible Repair

[State repair if obvious. Otherwise write "No repair proposed."]

### Verification Needed

[What must be checked next.]
```

### 15.7 Final Proof-Check Report

```markdown
# Final Proof-Check Report: [Paper / Appendix]

## Executive Summary

- Overall verdict:
- Main theorem support:
- Highest severity issue:
- Number of checked proof units:
- Number of open issues:

## Checked Scope

- Sections checked:
- Results checked:
- Results not checked:
- External references checked:
- External references not checked:

## Main Dependency Chain

[Summarize how the main theorem depends on intermediate results.]

## Verified Results

| Result | Status | Confidence | Notes |
|---|---|---|---|
| [Result] | [Verified] | [High] | [Notes] |

## Open Issues

| ID | Severity | Confidence | Affected result | Summary |
|---|---|---|---|---|
| [Issue] | [S1] | [High] | [Lemma] | [Summary] |

## Conditional Results

| Result | Condition needed | Evidence |
|---|---|---|
| [Result] | [Extra condition] | [Reference] |

## Recommended Repairs

1. [Repair]
2. [Repair]

## Final Judgment

[State whether the proof appears correct, correct modulo repairs, incomplete, or incorrect.]
```

## 16. Agent Prompt Templates

The following prompts are written for coding agents. Replace bracketed fields before use.

### 16.1 First-Pass Indexing Prompt

```text
You are helping me proof-check a long mathematics / CS theory paper appendix.

Task:
Create a first-pass index of all formal proof objects in the provided text.

Scope:
[Paste section range, file path, or page range.]

Please extract:
1. Definitions.
2. Assumptions.
3. Theorems.
4. Lemmas.
5. Propositions.
6. Corollaries.
7. Important displayed equations.
8. Named events.
9. External theorem citations.

For each item, provide:
- ID / label.
- Exact location.
- Short description.
- Formal dependencies if explicitly stated.
- Later references if visible.
- Any immediate ambiguity or missing definition.

Rules:
- Do not judge correctness yet except for obvious broken references.
- Cite exact locations.
- Separate exact statements from summaries.
- Mark uncertain extraction as "uncertain."

Output format:
Markdown tables plus a short list of extraction concerns.
```

### 16.2 Single Lemma Check Prompt

```text
You are checking one proof unit for correctness, not summarizing it.

Proof unit:
[Paste lemma statement and proof, or give exact file/page range.]

Context available:
[List definitions, assumptions, prior lemmas, and notation.]

Task:
Verify whether the proof establishes the stated result under the stated assumptions.

Please produce:
1. A faithful restatement of the claim.
2. Explicit assumptions.
3. Implicit or inherited assumptions.
4. Dependencies used.
5. Step-by-step verification of the proof.
6. Checks for constants, rates, dimensions, domains, and quantifiers.
7. Edge cases or degenerate cases.
8. Any gaps, ambiguities, or possible errors.
9. Final verdict: Verified / Conditionally verified / Gap found / Incorrect / Unclear.

Rules:
- Cite exact equations, lines, pages, or labels.
- Do not silently fix the proof.
- If a repair is possible, list it separately under "Possible repair."
- If a dependency is unchecked, mark the result "conditionally verified."
```

### 16.3 Proof Chain Check Prompt

```text
You are checking a dependency chain leading to a target theorem.

Target theorem:
[Theorem ID and statement.]

Candidate dependencies:
[List lemmas, propositions, assumptions, equations.]

Task:
Determine whether the target theorem follows from the listed dependencies.

Check:
1. Whether every dependency is available before use.
2. Whether each dependency's assumptions are satisfied.
3. Whether each dependency's conclusion has the exact form needed.
4. Whether constants, probability levels, rates, dimensions, and quantifiers compose correctly.
5. Whether any circular dependency exists.
6. Whether the final theorem statement is stronger than what the chain proves.

Output:
- Dependency table.
- Missing or mismatched links.
- Circularity analysis.
- Final verdict.

Rules:
- Distinguish "dependency unchecked" from "dependency invalid."
- Cite exact locations.
- Do not fill missing assumptions silently.
```

### 16.4 Hidden Assumption Search Prompt

```text
You are performing an adversarial hidden-assumption search.

Scope:
[Paste theorem / lemma / proof chain.]

Task:
Find assumptions that the proof appears to use but the statement does not explicitly include.

Focus on:
- Independence.
- Boundedness.
- Moment or tail conditions.
- Invertibility or nonzero denominators.
- Compactness.
- Existence or uniqueness of optimizers.
- Smoothness or measurability.
- Uniformity over parameter classes.
- Sample-size or dimension restrictions.
- Conditioning on events.
- Exchange of limits, expectations, derivatives, suprema, or integrals.

For each possible hidden assumption:
- State the proof step where it is used.
- Explain why the stated assumptions may not imply it.
- Assign severity and confidence.
- Suggest the minimal assumption or lemma needed to repair it, if clear.
```

### 16.5 Constants and Asymptotics Review Prompt

```text
You are reviewing constants, rates, and asymptotic notation in a technical proof.

Scope:
[Paste result and proof chain.]

Task:
Track all constants and rates from assumptions to final conclusion.

Check:
1. Which constants are universal and which depend on problem parameters.
2. Whether constants are allowed to change line by line.
3. Whether hidden constants in O/o/Theta notation depend on forbidden quantities.
4. Whether finite-sample claims rely on asymptotic notation.
5. Whether rates preserve dependencies on n, d, delta, epsilon, condition numbers, smoothness parameters, and tail parameters.
6. Whether logarithmic factors or dimension factors are dropped.
7. Whether probability levels compose correctly.

Output:
- Constants ledger.
- Rate propagation table.
- List of mismatches.
- Final verdict.
```

### 16.6 Notation Drift Prompt

```text
You are checking notation consistency.

Scope:
[Paste section range or extracted text.]

Task:
Identify notation drift, overloaded symbols, undefined symbols, and type/domain mismatches.

For each symbol:
- First definition.
- Intended meaning.
- Type/domain/dimension.
- Later uses.
- Whether later uses are consistent.

Flag:
- Symbols used before definition.
- Same symbol used for different objects.
- Same object named in multiple incompatible ways.
- Scalar/vector/matrix mismatches.
- Random/deterministic mismatches.
- Norm or metric changes.
- Constants with changed dependencies.

Output:
Notation ledger and issue list.
```

### 16.7 Final Audit Summary Prompt

```text
You are preparing the final proof-check report.

Inputs:
- Theorem inventory.
- Assumption ledger.
- Notation ledger.
- Dependency graph.
- Local proof checks.
- Issue log.

Task:
Produce a final proof-check report.

The report must include:
1. Overall verdict.
2. Checked scope.
3. Main dependency chain.
4. Verified results.
5. Conditionally verified results.
6. Open issues ranked by severity.
7. Missing assumptions.
8. Notation or reference problems.
9. Constants/rates/probability concerns.
10. Recommended repairs.
11. Final confidence level.

Rules:
- Do not overstate certainty.
- Distinguish fatal gaps from minor exposition issues.
- Cite exact evidence for every major issue.
- State which parts were not checked.
```

## 17. Pass-Based Check Cadence

A long appendix should be checked in passes, not linearly once. Passes 0-2 subsume Stages 1-6 of the full workflow; Passes 3-5 correspond to Stages 7-9. Within Passes 0-2, workflow.md uses paper-specific "Phases" for dependency-ordered execution batching.

### Why passes must be in this order

The pass structure is not arbitrary — it's designed to **fail fast on cheap checks** before investing effort in expensive ones:

1. **Pass 0 catches free problems.** Broken cross-references, missing definitions, and notation conflicts are detectable by grep. You'd rather find these in 30 seconds than after 3 hours of checking a proof that uses a mislabeled equation.

2. **Pass 1 catches structural problems.** If the drift condition lemma is wrong, every theorem built on it (boundedness, LLN, CLT) collapses. Checking the critical path first prevents wasting time on downstream proofs that depend on a broken foundation.

3. **Pass 2 fills gaps.** After the backbone is confirmed, the remaining lemmas can be checked in any order — they're independent of each other.

4. **Pass 3 catches integration problems.** Local checks can all pass individually but fail together. A norm might be ℓ₂ in Section D but ℓ₁ in Section H. An assumption might be invoked in a proof but only stated three sections earlier with a subtly different condition. These cross-sectional bugs are invisible to per-unit checks.

5. **Pass 4 catches happy-path thinking.** Authors (and agents doing Pass 1-2) naturally check that the proof works when everything goes right. Pass 4 explicitly asks: what if ‖Λ‖ = 0? What if θ is on the boundary of Θ? What if the small set condition fails because φ is discrete?

6. **Pass 5 forces a honest audit.** The final report must separate what was actually checked from what was assumed, mark conditional results explicitly, and give a clear verdict.

Skipping passes produces predictable failure modes:
- Skip Pass 0 → waste time re-deriving notation, miss broken refs
- Skip Pass 1 → check support lemmas that depend on a false critical lemma
- Skip Pass 3 → miss notation drift that invalidates cross-section theorem application
- Skip Pass 4 → miss boundary cases that break the proof in edge regimes

### Pass 0: Indexing (Map the Terrain)

**Why first:** You can't check what you can't find. This is the cheapest pass — mostly grep and pattern matching. Broken refs, missing labels, and undefined notation found here save hours later.

Goal:

- Know what exists.
- Identify the main dependency chain.
- Identify high-risk sections.

Artifacts:

- Theorem inventory.
- Definition inventory.
- Initial dependency graph.
- Initial issue log.

Do not spend too much time proving details in this pass.

### Pass 1: Check Critical Path

**Why second:** If the drift condition or the transition kernel lemma is wrong, everything downstream is suspect. Checking the longest dependency chain first finds structural errors before you invest in support lemmas.

Goal:

- Check the chain leading to the main theorem.
- Prioritize lemmas used by many later results.
- Find blockers early.

Artifacts:

- Local checks for critical lemmas.
- Updated dependency graph.
- Severity-ranked issue log.

### Pass 2: Check Support Lemmas

**Why third:** After the backbone is confirmed, remaining lemmas are independent of each other — they can be checked in parallel. These are typically technical bounds, Hölder continuity verifications, and explicit formula derivations.

Goal:

- Verify technical lemmas that support the critical path.
- Check constants, events, and assumptions carefully.

Artifacts:

- Lemma audit records.
- Constants ledger.
- Event ledger.

### Pass 3: Global Consistency

**Why fourth:** Per-unit checks are local — they verify Lemma X using the notation and assumptions stated in its own section. Pass 3 checks whether Lemma X in Section D and Theorem Y in Section B agree on what ‖·‖ means, whether an assumption stated in Section 2 actually reaches the appendix proof that needs it, and whether any proof accidentally cites a result that transitively depends on itself.

Goal:

- Check notation drift.
- Check assumption propagation.
- Check circular dependencies.
- Check final theorem assembly.

Artifacts:

- Final dependency graph.
- Assumption ledger.
- Notation ledger.

### Pass 4: Adversarial Review

**Why fifth:** Passes 1-3 check that the proof works as written. Pass 4 checks that it doesn't break in ways the author didn't consider. This requires a different mindset — you're not verifying steps, you're searching for counterexamples, stress-testing boundary cases, and asking "what hidden assumption makes this step true?"

Goal:

- Try to break the proof.
- Search for counterexamples.
- Stress assumptions and boundary cases.

Artifacts:

- Adversarial issue log.
- Proposed repairs.

### Pass 5: Final Report

**Why last:** All previous passes produce raw findings — verified units, issues, conditionals. Pass 5 synthesizes them into a single coherent judgment. This is also where you confront what you didn't check and make that explicit.

Goal:

- State what is verified, what is conditional, and what remains unresolved.

Artifacts:

- Final proof-check report.

**Consistency check:** Before finalizing, run `scripts/issues.sh <paper-dir>/<file>.tex` to verify that ISSUE_LOG.md, local check files, and FINAL_REPORT.md all agree on issue IDs, counts, and severities. Fix any discrepancies before declaring Pass 5 complete.

## 18. Prioritization Strategy

When time is limited, prioritize:

1. The main theorem statement.
2. The final proof of the main theorem.
3. Lemmas directly used in the final proof.
4. Lemmas used repeatedly.
5. Results with probability, asymptotics, optimization, or external theorem invocations.
6. Definitions and assumptions used across many sections.
7. Isolated technical lemmas with limited downstream use.

High-risk proof areas:

- Concentration inequalities.
- Uniform convergence.
- Empirical process arguments.
- Optimization landscape arguments.
- Matrix perturbation and spectral bounds.
- Fixed point or contraction arguments.
- Asymptotic normality.
- Minimax lower bounds.
- Reductions between models.
- Algorithm convergence proofs.
- Claims involving multiple limits.
- Claims involving hidden conditioning.

## 19. Common Failure Patterns

Use this list as a diagnostic checklist.

### 19.1 Logical Failures

- Proving a weaker statement than claimed.
- Assuming the conclusion.
- Circular dependency.
- Missing base case in induction.
- Induction hypothesis used outside its range.
- Existence claimed without compactness, coercivity, or other existence argument.
- Uniqueness used but not proved.
- Local optimum treated as global optimum.

### 19.2 Quantifier Failures

- Pointwise result used as uniform result.
- Parameter-dependent constant used as universal constant.
- "For every epsilon there exists N" confused with "there exists N for every epsilon."
- High-probability statement for fixed object used over a class without union bound or covering.
- A result holding for each `n` used as almost sure eventual statement.

### 19.3 Probability Failures

- Missing independence.
- Conditional probability mishandled.
- Event intersection probability not adjusted.
- Expectation bound used as high-probability bound.
- High-probability bound used inside expectation without integration.
- Random index or stopping time used in a fixed-index concentration bound.
- Measurability of supremum ignored.

### 19.4 Analysis Failures

- Limit and expectation exchanged without dominated convergence, monotone convergence, uniform integrability, or boundedness.
- Derivative and integral exchanged without regularity.
- Supremum and limit exchanged incorrectly.
- Compactness assumed but not stated.
- Continuity or Lipschitzness assumed but not proved.
- Norm equivalence used without dimension dependence.

### 19.5 Algebra and Inequality Failures

- Inequality direction reversed.
- Nonnegative quantity assumed without proof.
- Square root or square manipulation loses sign condition.
- Matrix inequality applied to non-symmetric matrix.
- Operator norm, Frobenius norm, and vector norm confused.
- Triangle inequality applied to incompatible norms.
- Dropped cross term without sign justification.

### 19.6 Asymptotic and Rate Failures

- `O_p` used as deterministic `O`.
- Constants hidden in asymptotic notation depend on `n`.
- Dimension dependence dropped.
- Logarithmic factors dropped.
- Rate valid under one scaling regime but theorem states another.
- Finite-sample theorem proved only asymptotically.

### 19.7 Citation Failures

- External theorem requires stronger assumptions.
- External theorem conclusion is weaker than needed.
- External theorem uses different normalization.
- External theorem is asymptotic but used for finite sample.
- External theorem applies to independent data but data are dependent.
- Citation points to wrong theorem or equation.

## 20. Working With Coding Agents

### 20.1 Good Agent Task Design

Good tasks are:

- Small.
- Bounded.
- Evidence-based.
- Structured.
- Explicit about output format.
- Clear about what context is available.

Poor task:

> Check Appendix B.

Better task:

> Check Lemma B.3 and its proof on pages 42-44. Use Definitions 2.1, 2.2, Assumption 1, and Lemmas B.1-B.2. Verify whether the proof establishes the stated bound uniformly over `theta in Theta`. Produce a step table, dependency table, and issue list with severity.

### 20.2 Give Agents Context Packages

For each local check, provide:

- The formal statement.
- The full proof.
- Relevant definitions.
- Relevant assumptions.
- Direct dependencies.
- The use site, if known.

Agents often make mistakes when context is incomplete. If the context is incomplete, require the agent to say so.

### 20.3 Require Structured Output

Ask for:

- Tables.
- Status labels.
- Severity labels.
- Confidence labels.
- Exact references.
- Explicit "unchecked dependencies" section.

This makes it easier to compare multiple agent outputs.

### 20.4 Cross-Check Agents

For critical lemmas:

- Ask one agent to verify normally.
- Ask another agent to find hidden assumptions.
- Ask a third pass to check constants and quantifiers.

Compare outputs manually. Disagreement is a signal, not a problem.

### 20.5 Prevent Agent Overconfidence

In prompts, include:

```text
If a step is unclear, mark it unclear. Do not infer missing assumptions unless you label them as inferred. Do not repair the proof silently.
```

Also include:

```text
Your goal is to find correctness issues. A result should be marked verified only if all required dependencies and assumptions are checked or explicitly listed as conditional.
```

## 21. Suggested Daily Workflow

For long checks, use a daily loop.

1. Pick 3-5 proof units.
2. Prepare context packages.
3. Run local agent checks.
4. Review agent outputs manually.
5. Update issue log.
6. Update dependency graph.
7. Update assumption and notation ledgers.
8. Decide next proof units based on blockers.

At the end of each session, write:

```markdown
## Session Summary: [Date]

- Proof units checked:
- New verified results:
- New issues:
- Updated dependencies:
- Open blockers:
- Next targets:
```

## 22. Final Acceptance Criteria

A long appendix proof is ready to be called checked only when:

- Every main theorem dependency has been identified.
- Every critical dependency has been locally checked or explicitly marked conditional.
- No unresolved S0 issue remains.
- All S1 issues are either repaired, downgraded with evidence, or explicitly reported.
- Assumption propagation has been checked.
- Notation drift has been checked.
- Constants, rates, probability levels, and quantifiers have been checked for the main chain.
- Circular dependencies have been ruled out or reported.
- The final report states checked and unchecked scope honestly.

## 23. Minimal Quick-Start Version

If you only have limited time, do this:

1. Build a theorem and lemma inventory.
2. Identify the main theorem's dependency chain.
3. Check the final theorem proof.
4. Check each direct dependency.
5. Track assumptions and notation while checking.
6. Run a hidden-assumption prompt on the main chain.
7. Run a constants/rates prompt on the main chain.
8. Produce an issue log with severity.
9. State final confidence and unchecked scope.

This quick-start process is not a full proof check, but it catches many serious errors.

## 24. Final Reminder

The most important discipline is to keep proof checking evidential.

For every claim, ask:

- Where is it stated?
- What assumptions does it need?
- Are those assumptions available here?
- Does the cited result really imply this exact step?
- Are constants, rates, domains, and quantifiers preserved?
- What would break this proof if I tried to construct a counterexample?

If the answer is not written down, the proof check is not finished.
