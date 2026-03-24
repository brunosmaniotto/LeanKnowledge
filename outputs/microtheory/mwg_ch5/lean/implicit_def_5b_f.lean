import Mathlib

/-- A production plan for a firm with `M` distinct outputs and `L - M` distinct inputs.
    `q` are output levels and `z` are input levels, both nonnegative. -/
structure ProductionPlan (L M : ℕ) (hM : M ≤ L) where
  /-- Output levels q = (q_1, ..., q_M) -/
  q : Fin M → ℝ
  /-- Input levels z = (z_1, ..., z_{L-M}), measured as nonnegative quantities -/
  z : Fin (L - M) → ℝ
  q_nonneg : ∀ i, 0 ≤ q i
  z_nonneg : ∀ i, 0 ≤ z i