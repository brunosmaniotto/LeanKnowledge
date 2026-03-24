# Category Supplement: Probability & Measure Theory

## Key imports
```lean
import Mathlib
open MeasureTheory ProbabilityTheory
```

## Core types
- `MeasurableSpace α` — a type with a σ-algebra
- `MeasureSpace α` — a `MeasurableSpace` with a canonical `Measure`
- `Measure α` — a measure on `α` (usually written `μ`)
- `IsProbabilityMeasure μ` — typeclass asserting `μ Set.univ = 1`
- `MeasurableSet s` — proof that `s` is in the σ-algebra
- `AEStronglyMeasurable f μ` — `f` is measurable up to a.e. equality

## Key lemmas and theorems
```
-- Basic measure operations
MeasureTheory.measure_union      : disjoint s t → MeasurableSet s → MeasurableSet t → μ (s ∪ t) = μ s + μ t
MeasureTheory.measure_compl      : MeasurableSet s → μ sᶜ = μ Set.univ - μ s
MeasureTheory.measure_mono       : s ⊆ t → μ s ≤ μ t
MeasureTheory.measure_iUnion     : countable union of disjoint measurable sets
MeasureTheory.measure_empty      : μ ∅ = 0
MeasureTheory.measure_univ       : (for probability measures) μ Set.univ = 1

-- Integration
MeasureTheory.integral_add       : Integrable f μ → Integrable g μ → ∫ x, (f x + g x) ∂μ = ∫ x, f x ∂μ + ∫ x, g x ∂μ
MeasureTheory.lintegral_add_left : for Lebesgue integrals (ENNReal-valued)
MeasureTheory.integral_mono      : f ≤ᵐ[μ] g → ∫ x, f x ∂μ ≤ ∫ x, g x ∂μ

-- Probability-specific
ProbabilityTheory.measure_compl_le_one
ProbabilityTheory.variance
ProbabilityTheory.IndepFun       : independence of random variables
```

## Naming patterns
- Everything lives in `MeasureTheory.*` or `ProbabilityTheory.*`
- Measure lemmas: `MeasureTheory.measure_<operation>`
- Integration lemmas: `MeasureTheory.integral_<property>` or `MeasureTheory.lintegral_<property>`
- Probability: `ProbabilityTheory.<concept>`

## Notation
- `∫ x, f x ∂μ` — Bochner integral (real-valued)
- `∫⁻ x, f x ∂μ` — Lebesgue integral (ENNReal-valued)
- `μ` — generic measure
- `ℙ` — probability measure (when `IsProbabilityMeasure` is in scope)
- `=ᵐ[μ]` — almost everywhere equality
- `≤ᵐ[μ]` — almost everywhere inequality

## Common pitfalls
1. **σ-algebra requirements**: Many lemmas need `MeasurableSet` hypotheses. If you get "unsolved goals" about `MeasurableSet`, add it as a hypothesis or use `measurableSet_*` lemmas.
2. **ENNReal vs Real**: Measures return `ENNReal` (extended non-negative reals). For real-valued probability, you often need `ENNReal.toReal` or work in `ENNReal` throughout.
3. **Disjointness for union**: `measure_union` requires `Disjoint s t` (not just `s ∩ t = ∅`). Use `Disjoint.symm`, `disjoint_compl_right`.
4. **`Integrable` hypotheses**: Many integral lemmas require `Integrable f μ` — don't forget this hypothesis.

## Worked example: P(Aᶜ) = 1 - P(A)
```lean
import Mathlib
open MeasureTheory ProbabilityTheory

theorem prob_complement {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {A : Set Ω} (hA : MeasurableSet A) :
    μ Aᶜ = μ Set.univ - μ A := by
  exact measure_compl hA (measure_ne_top μ A)
```
