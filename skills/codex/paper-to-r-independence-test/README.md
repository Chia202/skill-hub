# Paper to R Independence Test

`paper-to-r-independence-test` is a Codex skill for turning a paper or mathematical specification for an unconditional independence test into a verified, installable R package. It also supports independence tests constructed from correlation, covariance, kernel, distance, projection, or other dependence measures.

The skill emphasizes mathematical fidelity, explicit inference calibration, readable reference implementations, justified optimization, and reproducible validation.

## Scope

Use this skill when you want to:

- implement an unconditional independence test described in a paper;
- turn a paper's correlation or dependence measure into a calibrated independence test;
- expose the dependence estimate, test statistic, and p-value without conflating them;
- build and validate a small, method-focused R package;
- compare a pure-R reference implementation with optimized Rcpp code.

The skill is not intended for:

- standalone correlation estimation without independence inference;
- conditional-independence tests;
- general statistical analysis;
- unrelated hypothesis tests;
- generic R package development;
- paper summarization without implementation.

## Installation

Copy the complete skill directory into the Codex skills directory:

```bash
mkdir -p ~/.codex/skills
cp -R paper-to-r-independence-test ~/.codex/skills/
```

To update an existing local installation from a working copy:

```bash
rsync -a --exclude .DS_Store \
  paper-to-r-independence-test/ \
  ~/.codex/skills/paper-to-r-independence-test/
```

The installed layout should contain:

```text
~/.codex/skills/paper-to-r-independence-test/
├── SKILL.md
├── README.md
├── agents/
│   └── openai.yaml
└── references/
    ├── paper-to-spec.md
    ├── r-package-implementation.md
    └── validation.md
```

Start a new Codex turn after installation so the skill can be discovered.

## Usage

Invoke the skill explicitly and provide the paper, appendix, mathematical specification, or relevant source files.

English example:

```text
Use $paper-to-r-independence-test to implement the unconditional
independence test in paper.pdf as a verified R package.
```

中文示例：

```text
使用 $paper-to-r-independence-test，把 paper.pdf 中基于相关性度量的
无条件独立性检验实现为一个经过验证、可以安装的 R 包。
```

For a more reproducible request, also provide any available supplementary material, errata, official source code, desired package name, author and maintainer details, license preference, and required p-value calibration.

The skill presents the extracted specification, unresolved source conflicts, proposed API, inference strategy, and validation plan before writing package code. Package implementation begins only after the required choices are confirmed.

## Expected R Package

The generated package normally contains only the files needed by the method:

```text
DESCRIPTION
NAMESPACE
R/
man/
src/                 # when compiled optimization is justified
tests/testthat/
vignettes/           # when a vignette materially helps reproduction
```

Public functions use ordinary R interfaces and accept paired numeric matrices or numeric data frames when appropriate. Test results should be compatible with `htest` when useful and keep the following quantities distinct:

- normalized correlation or dependence estimate;
- raw covariance, U-statistic, or paper-specific estimator;
- calibrated test statistic;
- p-value and calibration metadata.

## Implementation and Validation Principles

- Extract the estimand, finite-sample estimator, null hypothesis, rejection tail, and calibration exactly.
- Treat papers, supplements, errata, and official code as evidence and document material discrepancies.
- Stop when a definition-critical source is missing.
- Implement a readable pure-R reference version before optimization.
- Move only measured hot paths to Rcpp or RcppArmadillo.
- Keep a serial implementation and default to one thread.
- Make permutation generation reproducible independently of worker scheduling.
- Unless the method requires another convention, use the corrected upper-tail permutation p-value
  `(1 + sum(T_perm >= T_obs)) / (n_perm + 1)`.
- Compare optimized kernels with the pure-R reference, normally using relative tolerance `1e-8`.
- Test claimed invariances, independent and dependent data, nonlinear dependence, heavy tails, degeneracy, repeated observations, invalid inputs, and missing values.
- Regenerate documentation, run the complete test suite, build and install in a clean temporary library, and run `R CMD check`.
- Do not claim CRAN readiness unless CRAN-specific release checks were actually completed.

The skill does not install missing R packages, compilers, or system dependencies without user permission.

## Files

- [`SKILL.md`](SKILL.md): activation rules, workflow, stopping conditions, and design boundaries.
- [`references/paper-to-spec.md`](references/paper-to-spec.md): evidence hierarchy and formula-extraction checklist.
- [`references/r-package-implementation.md`](references/r-package-implementation.md): R API, implementation, parallelism, and dependency contract.
- [`references/validation.md`](references/validation.md): numerical, statistical, package, and performance validation requirements.

## Author

Wang and Chia <xzm1@ruc.edu.cn>
