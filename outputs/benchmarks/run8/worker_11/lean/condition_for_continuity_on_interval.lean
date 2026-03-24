import Mathlib

-- Axiomatized sub-lemmas (as given in the problem description)

-- This axiom states that `ContinuousOn` is equivalent to the standard epsilon-delta
-- definition of continuity on a set, using the absolute value as the metric.
axiom step1_continuousOn_iff_metric_abs (f : ℝ → ℝ) (I : Set ℝ) :
  ContinuousOn f I ↔ ∀ x ∈ I, ∀ ε > 0, ∃ δ > 0, ∀ y ∈ I, |x - y| < δ → |f x - f y| < ε

-- This axiom provides a logical equivalence for rewriting a quantified implication.
-- It allows moving a condition on the quantified variable from the hypothesis of the
-- implication into a conjunction inside the quantifier's body.
axiom step2_quantifier_equivalence {α : Type*} {I : Set α} {P Q : α → Prop} :
  (∀ y ∈ I, P y → Q y) ↔ (∀ y, y ∈ I ∧ P y → Q y)

-- Main theorem proving the equivalence of `ContinuousOn` with the user-provided condition.
theorem continuousOn_iff_user_condition (f : ℝ → ℝ) (I : Set ℝ) :
  ContinuousOn f I ↔
    ∀ x ∈ I, ∀ ε > 0, ∃ δ > 0, ∀ y, y ∈ I ∧ |x - y| < δ → |f x - f y| < ε := by
  -- First, rewrite ContinuousOn to its standard epsilon-delta form using absolute values.
  rw [step1_continuousOn_iff_metric_abs]
  -- The goal is now to show that the two epsilon-delta forms are equivalent.
  -- They only differ in the innermost quantifier over y.
  -- We can use `simp_rw` to apply the quantifier equivalence lemma exactly where it's needed.
  -- `simp_rw` is able to apply the rewrite under the binders for `x`, `ε`, and `δ`.
  simp_rw [step2_quantifier_equivalence]