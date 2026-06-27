---
name: simple-research-code
description: Default to clear, minimally engineered research code for academic experiments, simulations, ablation studies, benchmark scripts, plotting, and reproducibility work, especially in Python or R. Use when writing, modifying, or reviewing code where ordinary students should be able to read and adapt the implementation, and avoid over-designed abstractions, production architecture, heavy CLIs, config systems, registries, packaging, or test infrastructure unless clearly justified.
---

# Simple Research Code

Use this skill to keep research experiment code simple, direct, and readable. The goal is not to ban abstraction; the goal is to make complexity pay rent.

## Default Stance

- Prefer scripts and small functions over packages, class hierarchies, frameworks, and generalized architectures.
- Optimize for a research student reading, editing, rerunning, and debugging the code.
- Keep the data flow visible: load data, set parameters, run the experiment, summarize results, save outputs.
- Follow the existing project structure when editing an existing repo, but keep new experiment code as simple as the surrounding interfaces allow.
- Leave unrelated architecture alone. Do not refactor a project just to make it match this style.

## Complexity Budget

Do directly:

- Write a single script for one experiment, plot, simulation, ablation, or benchmark.
- Use a few clear helper functions for repeated data loading, metrics, simulation steps, summaries, or plots.
- Put important parameters near the top of the file or inside a simple `main()` function.
- Use a tiny `argparse` block or a few R command-line arguments only when the user needs repeated runs with different settings.
- Save ordinary outputs as simple files such as CSV, RDS, NPY/NPZ, JSON, PNG, or PDF.

Abstract only when:

- The same logic appears at least two or three times.
- A statistical calculation, data transformation, or plotting convention is easy to get wrong.
- A helper will be reused by several scripts in the current experiment.
- The existing repo already has a simple utility module and using it reduces duplication.

Stop and explain the reason before adding:

- A new package layout, `src/` package, Python packaging files, or an R package structure.
- Multiple classes, inheritance, factories, registries, plugin systems, or callback architectures.
- YAML/TOML config systems, Hydra, experiment managers, MLflow, W&B, databases, services, containers, or workflow engines.
- A broad CLI with subcommands or many flags.
- CI, coverage, mock-heavy tests, fixture-heavy tests, or a new test framework.
- Broad rewrites that are not required for the requested experiment.

If the user explicitly asks for one of these, or the repo already relies on it, use the smallest version that satisfies the request.

## Python Style

- Prefer the normal research stack already present in the project: `numpy`, `pandas`, `scipy`, `statsmodels`, `scikit-learn`, `matplotlib`, `seaborn`, and similar standard libraries.
- Avoid adding dependencies unless they directly simplify the experiment and are worth the install cost.
- Prefer plain functions such as `simulate_data`, `fit_model`, `run_experiment`, `summarize_results`, and `make_plot`.
- Pass arrays, data frames, and parameter values explicitly. Avoid hidden global state except for top-level constants.
- Set random seeds explicitly for simulations and randomized methods.
- Use dictionaries or data frames for results unless a class clearly improves readability.
- Avoid premature object-oriented design, factories, registries, decorators, and metaprogramming.

## R Style

- Prefer base R, tidyverse, data.table, and ggplot2 when they match the existing code and task.
- Prefer scripts plus plain functions over S3/S4/R6 classes or an R package.
- Put parameters, file paths, and seeds near the top of the script.
- Use `set.seed()` for simulations and randomized procedures.
- Store results in data frames or tibbles, then save with `write.csv()`, `readr::write_csv()`, `saveRDS()`, or project-local conventions.
- Save figures with `ggsave()` or a direct graphics device such as `pdf()` and `png()`.
- Do not introduce `targets`, `drake`, `renv`, package scaffolding, or report-generation infrastructure unless the user asks or the project already uses it.

## Verification

- Run the smallest command that exercises the changed code.
- Check output files, dimensions, missing values, seeds, and a small sample of numerical summaries.
- Prefer sanity checks, assertions, and short smoke runs over a full test suite.
- Add small tests only when code will be reused, a statistic is easy to implement incorrectly, or the repo already has tests.
- State any unchecked scope clearly when data, time, or compute limits prevent a full run.

## Response Discipline

- Before substantial edits, state the simple implementation plan.
- If tempted to add engineering complexity, ask whether the complexity serves the experiment.
- In final responses, mention the files changed, the verification run, and any deliberate simplifications.
- Keep explanations concrete and tied to the experiment rather than generic software engineering ideals.
