---
name: proofcheck-stat-paper
description: Systematically check appendix proofs in statistics, probability, ML-theory, mathematics, and theoretical computer science papers from LaTeX source. Use when the user explicitly invokes $proofcheck-stat-paper or asks to check, bootstrap, re-check, quick-check, audit, index, cross-reference, or produce reports for technical paper proofs, especially requests like "Use $proofcheck-stat-paper to check the appendix proofs in file.tex."
---

# Proofcheck Stat Paper

Use this skill to audit technical appendix proofs from a `.tex` file. Treat the target `.tex` file as the workspace anchor: write all generated artifacts beside that file, never in a required `papers/<name>/` directory.

## Invocation

Canonical request:

```text
Use $proofcheck-stat-paper to check the appendix proofs in file.tex.
```

Resolve `file.tex` to an absolute path. Let `PAPER_DIR` be its parent directory. Use this layout:

```text
PAPER_DIR/
  file.tex
  CHECK_PLAN.md
  EXECUTION_ORDER.md
  audit/
    01_index/
    02_ledgers/
    03_dependencies/
    04_local_checks/
    05_adversarial/
    06_reports/
      ISSUE_LOG.md
      FINAL_REPORT.md
      PROGRESS.md
```

If the user asks to bootstrap only, create `CHECK_PLAN.md` and `EXECUTION_ORDER.md` and stop for review. If the user asks for a quick-check, produce a bounded audit with explicit unchecked scope. If the user asks to re-check, read existing audit files beside the `.tex` file and rerun only affected passes unless the change scope is unclear.

## Workflow

1. Read `references/workflow.md` for the execution method and `references/methodology.md` for severity, templates, and failure patterns.
2. Run `scripts/scaffold.sh /path/to/file.tex` to create the beside-file audit tree.
3. Bootstrap `CHECK_PLAN.md` and `EXECUTION_ORDER.md` from `references/bootstrap.md` unless they already exist and the user asked to continue.
4. Run Pass 0 before proof checking:
   - `scripts/index.sh /path/to/file.tex --after '\appendix'` for theorem/lemma inventory.
   - `scripts/crossref.sh /path/to/file.tex` for label/reference consistency.
   - Create notation, assumption, and dependency ledgers in `audit/`.
5. Check proof units in dependency order from `EXECUTION_ORDER.md`. Use one file per proof unit under `audit/04_local_checks/section_X/`.
6. Run global consistency, adversarial review, and final synthesis. Keep `audit/06_reports/ISSUE_LOG.md` as the single source of truth for issues.
7. Before finalizing, run `scripts/issues.sh /path/to/file.tex` or `scripts/issues.sh PAPER_DIR` and reconcile any mismatches.

## Output Discipline

- Cite exact file paths, line numbers, labels, equations, and assumptions for every major finding.
- Do not silently repair proofs. Record the issue and list possible repairs separately.
- Mark results as `Conditionally verified` if upstream dependencies are unchecked.
- Use severity `S0` fatal, `S1` major, `S2` moderate, `S3` minor.
- State checked scope and unchecked scope honestly in `FINAL_REPORT.md`.

## Resources

- `references/methodology.md`: full proof-check principles, templates, prompts, severity/confidence rules, and common failure patterns.
- `references/workflow.md`: pass/phase execution method and paper-type adaptations.
- `references/bootstrap.md`: Mode A and Mode B prompts for creating `CHECK_PLAN.md` and `EXECUTION_ORDER.md`.
- `references/tutorial-cbara.md`: example walkthrough; use only when examples are helpful.
- `assets/progress-template.md`: copy to `audit/06_reports/PROGRESS.md` for multi-session checks.
- `scripts/`: deterministic helpers for scaffolding, indexing, cross-reference checks, and issue consistency.
