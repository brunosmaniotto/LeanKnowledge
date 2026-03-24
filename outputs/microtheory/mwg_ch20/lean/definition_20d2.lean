import Mathlib
open BigOperators

/-- A consumption stream is myopically (short-run) utility maximizing in the budget set
determined by prices p and wealth w if utility cannot be increased by a new consumption
stream that merely transfers purchasing power between some two consecutive periods.

That is, for every period t and every transfer δ of purchasing power from period t to
period t+1 (or vice versa), the resulting consumption stream does not yield higher utility. -/
noncomputable def IsMyopicallyUtilityMaximizing
    (u : (ℕ → ℝ) → ℝ)
    (p : ℕ → ℝ)
    (w : ℝ)
    (c : ℕ → ℝ) : Prop :=
  -- c satisfies the budget constraint
  (∀ t, c t ≥ 0) ∧
  (∀ t, p t > 0) ∧
  (∑' t, p t * c t) ≤ w ∧
  -- No two-consecutive-period transfer can improve utility
  (∀ (t : ℕ) (δ : ℝ),
    let c' := Function.update (Function.update c t (c t + δ / p t)) (t + 1) (c (t + 1) - δ / p (t + 1))
    -- If the perturbed stream is feasible (nonneg consumptions)
    c' t ≥ 0 → c' (t + 1) ≥ 0 →
    -- Then it does not improve utility
    u c' ≤ u c)