# R Package Implementation Contract

Read this reference before creating the implementation specification, then follow it while implementing the confirmed design.

## Package Shape

Create only the files the method needs. A typical research-grade package has `DESCRIPTION`, `NAMESPACE`, `R/`, `man/`, `src/` when compiled code is justified, `tests/testthat/`, and a concise vignette only when it materially helps users reproduce the method. Generate documentation from roxygen2 comments. Do not add R6 classes, factories, registries, or multi-layer wrappers for a small statistical method.

Use ordinary R functions at the public boundary. Prefer method-specific names over a vague universal API. Accept paired numeric matrices or data frames with equal row counts; validate dimensions, finiteness, and method-specific sample-size constraints. Default to `na.action = "fail"`; support omission only when explicitly designed and documented.

## Statistical Return Contract

Return a lightweight list compatible with class `htest` when standard test printing is useful. Include, as applicable:

- `estimate`: the normalized correlation or dependence measure;
- `raw_estimate`: the unnormalized covariance, U-statistic, or paper-specific raw measure;
- `statistic`: the actual test statistic used for calibration;
- `p.value`, `null.value`, `alternative`, `method`, and `data.name`;
- `parameter`: the named numeric parameter vector expected by the standard `htest` convention, when applicable;
- `details`: dimensions, scale estimates, permutation count, seed, calibration selected by `auto`, thread count, and other method metadata that do not belong in `parameter`.

Preserve paper terminology in names or labels. Never silently take a square root, square a quantity, truncate a signed measure, or substitute an estimator merely to force a common range.

When multiple calibrations exist, prefer arguments such as `p_method = c("auto", "asymptotic", "permutation")`, `n_perm`, `seed`, and `n_threads = 1`. `auto` may choose an asymptotic law only when the paper clearly states it and every required condition used by the decision is verifiable. If asymptotic validity depends on unobservable or qualitative conditions, `auto` must use the documented finite-sample method; asymptotic calibration then requires explicit user selection. Do not invent dimension cutoffs or encode empirical simulation observations as theoretical thresholds.

Unless the source defines another valid convention, use the corrected upper-tail permutation estimate

```r
(1 + sum(T_perm >= T_obs)) / (n_perm + 1)
```

and report the realized calibration, permutation count, and RNG information.

At the confirmation gate, distinguish this corrected Monte Carlo convention from a paper's raw exceedance fraction when they differ. Specify whether the identity permutation is included, when exact enumeration replaces sampling, how ties are counted, and which alternative determines the tail. Preserve a reproduction mode only when the user explicitly wants the paper's original finite-simulation convention.

## Reference Before Optimization

Implement a readable pure-R version that follows the confirmed formulas and is feasible on small inputs. Test it before optimizing. This reference is the correctness oracle for compiled kernels; keep it internal or expose it only when useful for verification.

Move only measured hot paths to Rcpp/RcppArmadillo. Good candidates include repeated matrix products, pairwise differences, angular kernels, centering, U-statistic reductions, and permutation statistic evaluation. Clamp roundoff-sensitive cosine values to `[-1, 1]` before `acos`, and implement the paper's exact zero-norm and repeated-observation conventions.

Avoid storing cubic tensors when an anchor-wise stream, sufficient-statistic reduction, or block computation gives the same result. Do not claim a reduced complexity unless the reduction is present in a cited source or derived and independently verified.

For a high-complexity direct implementation, estimate feasible ranges from benchmarks and memory calculations. Add documented input guards or an explicit override rather than allowing an accidental unbounded run. A guard is an operational safeguard, not a claim that the statistical method is invalid beyond the guarded size.

## Parallelism and RNG

Keep a serial path and default to `n_threads = 1`. Profile before adding parallelism. Prefer independent permutations as the first parallel unit; method-specific anchors or feature blocks are alternatives when justified. Avoid nested parallel regions and BLAS oversubscription.

For permutation tests, generate or deterministically define permutation indices independently of worker scheduling so a fixed seed is reproducible. Document whether results are invariant to thread count. Use thread-local accumulation followed by a deterministic reduction where floating-point ordering matters.

Add `RcppParallel` only when benchmarks support the extra dependency. Do not make OpenMP the sole execution path; ensure supported platforms retain a correct serial fallback.

## Dependency and Mutation Boundaries

Use `Rcpp`, `RcppArmadillo`, `testthat`, and `roxygen2` only when needed. Detect missing packages and build tools before starting a long build. Ask before installing dependencies or changing R, compilers, environment variables, or library paths. Respect existing package style and user changes.
