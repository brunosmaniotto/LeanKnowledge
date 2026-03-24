import Mathlib
open Topology

/-- A utility function `u` on `ℝⁿ` is *strictly increasing* (in the sense of MWG Lemma 5.2
    and Theorem 5.6) if `x ≥ y` componentwise with `x ≠ y` implies `u(x) > u(y)`.
    This is weaker than *strongly increasing* (which requires strict inequality in every
    component) but stronger than plain monotonicity. -/
def IsStrictlyIncreasing {n : ℕ} (u : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ x y : Fin n → ℝ, (∀ i, y i ≤ x i) → x ≠ y → u x > u y