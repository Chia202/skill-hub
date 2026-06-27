---
name: academic-polish
description: Polish academic writing in statistics and related fields for clarity, precision, concision, and reviewer-facing rigor. Use for papers, abstracts, introductions, related work, methods, theory, simulations, applications, discussions, rebuttals, and cover letters.
---

# Academic Polish

Edit academic text in a conservative style suitable for leading statistics journals.

Core priorities:

1. Preserve the original meaning, scope, and technical claims.
2. Improve clarity, logical flow, concision, and sentence-level precision.
3. Use a plain, professional academic tone.
4. Avoid hype, promotional language, vague adjectives, and unnecessary emphasis.
5. Keep statistical terminology, notation, assumptions, estimands, models, and conclusions consistent.
6. Make claims appropriately qualified when they depend on assumptions, asymptotics, simulations, data examples, or empirical evidence.
7. Do not invent results, citations, numerical values, baselines, assumptions, proofs, limitations, or interpretations.
8. Flag unsupported, overstated, or ambiguous claims instead of strengthening them silently.
9. Preserve citations, labels, references, equation numbers, theorem environments, algorithm names, and cross-references.
10. Prefer precise verbs and concrete nouns over broad evaluative language.

Statistical writing conventions:

- State contributions in terms of statistical content, such as estimands, procedures, assumptions, guarantees, computation, inference, robustness, efficiency, uncertainty quantification, or empirical performance.
- Avoid broad claims such as “state-of-the-art,” “novel,” “powerful,” “significant improvement,” or “substantial gain” unless the evidence is explicit in the text.
- Use careful qualifiers such as “under the stated assumptions,” “in the considered settings,” “in our simulations,” “for this data example,” or “asymptotically” when needed.
- Do not blur distinctions among estimation, prediction, testing, identification, computation, and interpretation.
- Do not make causal claims unless the design, assumptions, or identification argument supports them.
- Keep theoretical claims tied to their stated conditions, such as regularity conditions, sample-size regimes, model classes, or limiting arguments.
- For simulation and data-analysis sections, distinguish clearly between empirical findings and theoretical guarantees.

Word choice:

- Use rigorous and restrained wording.
- Avoid repeated emphatic connectors such as “indeed,” “clearly,” “obviously,” “remarkably,” and “notably.”
- Do not use “indeed” merely to reinforce a claim; use it only when it serves a clear logical function.
- Prefer neutral transitions such as “therefore,” “thus,” “in particular,” “more specifically,” “by contrast,” or “as a result” when they accurately express the relation between sentences.
- Avoid adverbs that overstate certainty, generality, or importance unless justified by the preceding argument or evidence.

Math and LaTeX rules:

- Use `$...$` for inline mathematics.
- Use `$$...$$` for display mathematics.
- Do not introduce `\(...\)` or `\[...\]`.
- Do not arbitrarily break mathematical LaTeX code across lines.
- Keep each mathematical expression on one line whenever feasible.
- Preserve existing equations, notation, labels, references, theorem statements, and proof structure unless a change is necessary for clarity.
- Do not change notation unless the original notation is inconsistent or ambiguous; if notation is changed, explicitly note this under “Major changes.”
- Do not rewrite formulas in ways that alter their mathematical meaning.
- Do not add assumptions, rates, convergence statements, or probability statements that are not present in the original text.

Style:

- Clear, direct, formal academic English.
- Plain professional tone.
- No marketing or promotional language.
- No unnecessary embellishment.
- No inflated claims about novelty, generality, efficiency, robustness, or practical impact.
- Prefer concise transitions that clarify the argument.
- Avoid excessive metadiscourse such as “it is important to note that” unless it improves readability.
- Maintain the author’s intended level of technical detail.

Output format:

1. Revised text.
2. Major changes, if any.
3. Risky, unsupported, or ambiguous claims.
4. Notation or LaTeX issues, if any.
5. Optional shorter version when useful.

When the input is very short and has no evident risks, output only the revised text unless the user asks for comments.
