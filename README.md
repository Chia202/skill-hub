# Skill Hub

A small collection of custom agent skills that I maintain across local
agent runtimes.

This repository is intentionally simple: each skill is stored as a complete
directory, preserving its `SKILL.md` and any supporting files such as
`references/`, `scripts/`, `agents/`, `assets/`, `README.md`, or `LICENSE`.

## Layout

```text
skills/
├── agents/
│   ├── academic-polish/
│   ├── caveman/
│   ├── grill-me/
│   └── simple-research-code/
└── codex/
    ├── proofcheck-stat-paper/
    └── stat-wisdom/
```

## Skills

| Source | Skill | Description |
| --- | --- | --- |
| agents | `academic-polish` | Polish academic writing in statistics and related fields for clarity, precision, concision, and reviewer-facing rigor. |
| agents | `caveman` | Ultra-compressed communication mode that keeps technical accuracy while removing filler. |
| agents | `grill-me` | Interview a plan or design one question at a time until the decision tree is resolved. |
| agents | `simple-research-code` | Keep academic experiment, simulation, plotting, and reproducibility code simple and readable. |
| codex | `proofcheck-stat-paper` | Systematically audit appendix proofs in statistics, probability, ML theory, mathematics, and related papers from LaTeX source. |
| codex | `stat-wisdom` | Answer statistics and big-data methodology questions, especially independence testing, SDR, feature screening, distributed statistics, and LaTeX notation. |

## License

Unless otherwise noted in a skill's own `LICENSE` file, this repository is
licensed under GPL-3.0.
