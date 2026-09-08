# Statistical and Package Validation

Read this reference before declaring the generated package complete.

## Numerical Equivalence

- Compare every optimized kernel with the pure-R reference on multiple randomized small cases.
- Use a default relative tolerance of `1e-8`, tightening or relaxing it only with a numerical justification.
- Compare intermediate quantities when an end-to-end mismatch occurs; do not conceal disagreement by loosening the final tolerance.
- Test fixed seeds and record the RNG behavior of permutation and parallel paths.

## Statistical Properties

Test every property the source actually claims, such as symmetry under swapping `X` and `Y`, translation, scale, or orthogonal invariance. Include independent data, strong dependence, nonlinear dependence, heavy tails, repeated observations, zero-norm or degenerate inputs, invalid dimensions, and missing values.

Check that the normalized estimate, raw estimate, test statistic, and p-value remain distinct and internally consistent. Verify the exact permutation exceedance count and correction on a tiny deterministic example. For asymptotic calibration, test the implemented formula directly and use simulation only as supporting evidence, not as a brittle unit-test oracle.

When licensed official code or published numerical values are available, compare against them and document any discrepancy. Reproduce a small representative paper example when computationally practical; do not turn a large simulation study into a mandatory package check.

## Package Checks

- Regenerate documentation and confirm exported functions match `NAMESPACE`.
- Run focused unit tests, then the full test suite.
- Build and install the package in a clean temporary library when feasible.
- Run `R CMD check`; require zero errors and explain or remove every warning and note.
- Exercise the documented examples and any vignette.

Do not install missing dependencies without permission. If an unavailable compiler or dependency prevents a check, report the exact blocked command and what remains unverified.

## Performance Checks

Benchmark representative sizes only after correctness passes. Compare pure R, serial compiled, and parallel implementations when present. Report elapsed time, problem dimensions, thread count, and peak-memory observations when available. Do not promise an arbitrary speedup or hide slower cases.

## Completion Report

Summarize:

- package location and primary functions;
- implemented estimands and test statistics;
- p-value calibration and `auto` decision rule;
- checks and comparisons that passed;
- benchmark conditions and results;
- source citations, discrepancies, and license status;
- remaining limitations, missing fast formulas, and unverified platform behavior.

