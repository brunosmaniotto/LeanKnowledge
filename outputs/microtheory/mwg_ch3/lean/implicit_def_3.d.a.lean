import Mathlib
open BigOperators

/-- The Walrasian budget set: all non-negative consumption bundles affordable at prices `p` and wealth `w`. -/
def walrasianBudgetSet (L : ℕ) (p : Fin L → ℝ) (w : ℝ) : Set (Fin L → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ w}

/-- The Utility Maximization Problem (UMP): the supremum of utility `u` over the
    Walrasian budget set B_{p,w}, given strictly positive prices `p >> 0` and wealth `w > 0`. -/
noncomputable def utilityMaximizationProblem (L : ℕ) (u : (Fin L → ℝ) → ℝ) (p : Fin L → ℝ) (w : ℝ) : ℝ :=
  sSup (u '' walrasianBudgetSet L p w)